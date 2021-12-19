use std::borrow::{Borrow};
use std::collections::HashMap;
use std::fs::File;
use std::io;
use std::io::BufRead;
use std::path::Path;

struct Inputs {
    template: String,
    rules: HashMap<String, char>,
}

fn main() {
    let inputs = read_inputs();
    println!("Part 1 : {}", solve(inputs, 10));
    let inputs = read_inputs();
    println!("Part 2 : {}", solve(inputs, 40));
}

fn solve(inputs: Inputs, steps: u64) -> u64 {
    let mut pair_count: HashMap<String, u64> = HashMap::new();
    let mut letter_count: HashMap<char, u64> = HashMap::new();

    for pair in to_pairs(inputs.template.clone()) {
        pair_count.insert(pair.clone(), get_or_default1(pair_count.clone(), pair.clone(), 0) + 1);
    }

    for letter in inputs.template.chars() {
        letter_count.insert(letter.clone(), get_or_default2(letter_count.clone(), letter, 0) + 1);
    }

    for _ in 0..steps {
        let mut new_pair_count: HashMap<String, u64> = HashMap::new();

        for pair in pair_count.keys() {
            let curr_count = pair_count[pair];
            let added = inputs.rules[pair].clone();

            let mut p1 = String::from(pair.chars().nth(0).unwrap());
            p1.push(added);
            let mut p2 = String::from(added.clone());
            p2.push(pair.chars().nth(1).unwrap());

            new_pair_count.insert(p1.clone(), get_or_default1(new_pair_count.clone(), p1, 0) + curr_count);
            new_pair_count.insert(p2.clone(), get_or_default1(new_pair_count.clone(), p2, 0) + curr_count);

            letter_count.insert(added.clone(), get_or_default2(letter_count.clone(), added.clone(), 0) + curr_count);
        }

        pair_count = new_pair_count;
    }

    let mut min: u64 = u64::MAX;
    let mut max: u64 = 0;

    for val in letter_count.values() {
        if val > &max {
            max = val.clone();
        }
        if val < &min {
            min = val.clone();
        }
    }

    max - min
}

fn get_or_default1(m: HashMap<String, u64>, key: String, default_value: u64) -> u64 {
    if m.contains_key(key.as_str()) {
        return *m.borrow().get(key.clone().as_str()).unwrap();
    }
    return default_value;
}

fn get_or_default2(m: HashMap<char, u64>, key: char, default_value: u64) -> u64 {
    if m.contains_key(key.borrow()) {
        return *m.borrow().get(key.borrow()).unwrap();
    }
    return default_value;
}

fn to_pairs(string: String) -> Vec<String> {
    let mut pairs: Vec<String> = Vec::new();

    for i in 0..string.len() {
        if string.len() - i >= 2 {
            pairs.push(string[i..i + 2].parse().unwrap())
        }
    }

    pairs
}

fn read_inputs() -> Inputs {
    let mut rules: HashMap<String, char> = HashMap::new();
    let mut templ: String = "".parse().unwrap();

    if let Ok(lines) = read_lines("input.txt") {
        let mut i = 0;
        for l in lines {
            if let Ok(line) = l {
                if i == 0 {
                    templ = line;
                } else if i > 1 {
                    let mut spliced = line.split(" -> ");
                    let key = spliced.nth(0).unwrap().to_string();
                    let result = spliced.nth(0).unwrap().to_string();
                    rules.insert(key, result.chars().nth(0).unwrap());
                }
            }
            i = i + 1;
        }
    }
    Inputs { rules, template: templ }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
    where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}