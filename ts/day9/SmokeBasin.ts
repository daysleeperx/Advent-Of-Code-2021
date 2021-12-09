import { readFileSync } from 'fs';
import path from 'path';

/*
--- Day 9: Smoke Basin ---
These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

2199943210
3987894921
9856789892
8767896789
9899965678
Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.

Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?
*/

type Point = [x: number, y: number, value: number];
type Dir = [dx: number, dy: number];
const dirs: Array<Dir> = [[0, 1], [0, -1], [-1, 0], [1,0]];

function inBounds(grid: Array<Array<number>>, row: number, col: number, dx: number, dy: number): boolean {
  return row + dy >= 0 && row + dy < grid.length  && col + dx >= 0 && col + dx < grid[0].length 
}

function getLowPoints(grid: Array<Array<number>>): Array<Point> {
    const lowPoints: Array<Point> = [];

    for (let row = 0; row < grid.length; row++) {
      for (let col = 0; col < grid[0].length; col++) {
        let valid: boolean = true;
        for (const dir of dirs) {
          const [dx, dy] = dir;
          if (inBounds(grid, row, col, dx, dy) && grid[row][col] >= grid[row + dy][col + dx]) {
            valid = false;
            break;
          }
        }
        if (valid) {
          lowPoints.push([col, row, grid[row][col]]);
        };
      }
    }

    return lowPoints;
}

/*
--- Part Two ---
Next, you need to find the largest basins so you know what areas are most important to avoid.

A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.

The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

The top-left basin, size 3:

2199943210
3987894921
9856789892
8767896789
9899965678
The top-right basin, size 9:

2199943210
3987894921
9856789892
8767896789
9899965678
The middle basin, size 14:

2199943210
3987894921
9856789892
8767896789
9899965678
The bottom-right basin, size 9:

2199943210
3987894921
9856789892
8767896789
9899965678
Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.

What do you get if you multiply together the sizes of the three largest basins?
*/
function traverseBasin(grid: Array<Array<number>>, row: number, col: number, visited: Set<string>): void {
  visited.add([row, col].join(","));

  for (const dir of dirs) {
    const [dx, dy] = dir;
    if (
      inBounds(grid, row, col, dx, dy) && 
      grid[row + dy][col + dx] !== 9 && 
      !visited.has([row + dy, col + dx].join(","))
    ) {
      traverseBasin(grid, row + dy, col + dx, visited);
    }
  }
}

function countBasins(grid: Array<Array<number>>, points: Array<Point>): number {
  const visitedCount: Array<Set<string>> = [];

  points.forEach(([col, row, _val]) => {
    const visited: Set<string> = new Set([]);
    traverseBasin(grid, row, col, visited)
    visitedCount.push(visited);
  })

  return visitedCount.sort((a, b) => a.size - b.size).reverse().slice(0, 3).reduce((r, c) => r * c.size, 1);
}

function main(): void {
  const grid = readFileSync(path.join(__dirname, "input.txt"), { encoding: "utf-8" }).split("\n").map(line => line.split("").map(Number));
  const lowPoints = getLowPoints(grid);
  console.log(lowPoints.reduce((acc, [_x, _y, v]) => acc + v + 1, 0));
  console.log(countBasins(grid, lowPoints));
}  

main();