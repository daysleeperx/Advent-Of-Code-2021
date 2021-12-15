import { readFileSync } from 'fs';
import path from 'path';

/*
--- Day 14: Extended Polymerization ---
The incredible pressures at this depth are starting to put a strain on your submarine. The submarine has polymerization equipment that would produce suitable materials to reinforce the submarine, and the nearby volcanically-active caves should even have the necessary input elements in sufficient quantities.

The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a polymer template and a list of pair insertion rules (your puzzle input). You just need to work out what polymer would result after repeating the pair insertion process a few times.

For example:

NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
The first line is the polymer template - this is the starting point of the process.

The following section defines the pair insertion rules. A rule like AB -> C means that when elements A and B are immediately adjacent, element C should be inserted between them. These insertions all happen simultaneously.

So, starting with the polymer template NNCB, the first step simultaneously considers all three pairs:

The first pair (NN) matches the rule NN -> C, so element C is inserted between the first N and the second N.
The second pair (NC) matches the rule NC -> B, so element B is inserted between the N and the C.
The third pair (CB) matches the rule CB -> H, so element H is inserted between the C and the B.
Note that these pairs overlap: the second element of one pair is the first element of the next pair. Also, because all pairs are considered simultaneously, inserted elements are not considered to be part of a pair until the next step.

After the first step of this process, the polymer becomes NCNBCHB.

NNCB -> NCNCB -> NCNBCB -> NCNBCHB
NNCB -> NCNCB -> NCNBCB -> NCNBCHB

Here are the results of a few steps using the above rules:

Template:     NNCB
After step 1: NCNBCHB
After step 2: NBCCNBBBCBHCB
After step 3: NBBBCNCCNBBNBNBBCHBHHBCHB
After step 4: NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB
This polymer grows quickly. After step 5, it has length 97; After step 10, it has length 3073. After step 10, B occurs 1749 times, C occurs 298 times, H occurs 161 times, and N occurs 865 times; taking the quantity of the most common element (B, 1749) and subtracting the quantity of the least common element (H, 161) produces 1749 - 161 = 1588.

Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?
*/

type Dict<T> = Map<string, T>;

function processPolymer(pairs: Dict<number>, rules: Dict<string>, countDict: Dict<number>, steps: number): number {    
    [...Array(steps).keys()].reduce((acc, _) => process(acc), pairs);

    function process(pairs: Dict<number>): Dict<number> {
        return [...pairs.entries()].reduce((acc, [pair, cnt]) => {
          const replace = rules.get(pair);
          acc.set(pair[0] + replace, (acc.get(pair[0] + replace) ?? 0) + cnt);
          acc.set(replace + pair[1], (acc.get(replace + pair[1]) ?? 0) + cnt);
          countDict.set(replace, (countDict.get(replace) ?? 0) + cnt);
          return acc;
        }, new Map());
    }
    
    return Math.max(...countDict.values()) - Math.min(...countDict.values());
}

/*
--- Part Two ---
The resulting polymer isn't nearly strong enough to reinforce the submarine. You'll need to run more steps of the pair insertion process; a total of 40 steps should do it.

In the above example, the most common element is B (occurring 2192039569602 times) and the least common element is H (occurring 3849876073 times); subtracting these produces 2188189693529.

Apply 40 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?
*/

function main(): void {
    const [file] = process.argv.slice(2);

    const [template, ...rules] = readFileSync(path.join(__dirname, file), { encoding: "utf-8" }).split(/\n\s*\n/).map(p => p.split("\n")).flat();

    const rulesDict: Dict<string> = rules.reduce((dict, rule) => {
        const [k, v] = rule.split(" -> ");
        dict.set(k, v);
        return dict;
    }, new Map());

    const pairs: Dict<number> = [...Array(template.length).keys()].map(i => i + 2).reduce((acc, i) => {
        const pair: string = template.slice(i - 2, i);
        acc.set(pair, (acc.get(pair) ?? 0) + 1);
        return acc;
      }, new Map());
      
    const count: Dict<number> = template.split("").reduce((dict, l) => {
        dict.set(l, (dict.get(l) ?? 0) + 1);
        return dict;
    }, new Map());  

    console.time("Extended Polymerization - Part 1");
    console.log(processPolymer(pairs, new Map([...rulesDict.entries()]), new Map([...count.entries()]), 10));
    console.timeEnd("Extended Polymerization - Part 1");

    console.time("Extended Polymerization - Part 2");
    console.log(processPolymer(pairs, rulesDict, new Map([...count.entries()]), 40));
    console.timeEnd("Extended Polymerization - Part 2");
  }  
  
  main();