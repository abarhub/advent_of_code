use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::sync::mpsc;
use std::sync::mpsc::{Receiver, Sender};

#[derive(Debug)]
struct Interval {
    debut: i64,
    debut_str: String,
    fin: i64,
    fin_str: String,
}

fn main() {
    //partie1("test1.txt");
    partie1("input.txt");
}

fn partie1(filename: &str) -> i64 {
    let (tx, rx) = mpsc::channel();

    parse(filename, tx);

    let resultat = calcul(rx);
    println!("resultat: {:?}", resultat);
    return resultat;
}

fn parse(filename: &str, tx: Sender<Interval>) {
    // File hosts.txt must exist in the current path
    if let Ok(lines) = read_lines(filename) {
        for line in lines.map_while(Result::ok) {
            let tab = line.split(",");

            for part in tab {
                let parties = part.split("-");
                if parties.clone().count() == 2 {
                    let collection = parties.collect::<Vec<&str>>();
                    let debut = collection[0].parse::<i64>().unwrap();
                    let fin = collection[1].parse::<i64>().unwrap();
                    let interval = Interval {
                        debut,
                        debut_str: collection[0].to_string(),
                        fin,
                        fin_str: collection[1].to_string(),
                    };
                    tx.send(interval).unwrap();
                }
            }
        }
    }

    drop(tx); // important : permet à recv() de savoir quand finir
}

fn calcul(rx: Receiver<Interval>) -> i64 {
    let mut resultat = 0;
    for interval in rx {
        let debut = interval.debut;
        let fin = interval.fin;
        let debut_str = interval.debut_str;
        let fin_str = interval.fin_str;
        let len_min = debut_str.len();
        let len_max = fin_str.len();

        println!("verification pour: {} - {}", debut_str, fin_str);

        for i in len_min..=len_max {
            if i % 2 == 0 {
                let i0 = i / 2;
                let n = 10i64.checked_pow((i0 - 1) as u32).unwrap();
                let n_max = 10i64.checked_pow((i0) as u32).unwrap() - 1;

                println!("i: {} ({}), n:{}, n_max: {}", i, i0, n, n_max);

                for n02 in n..=n_max {
                    let n2 = n02 * n * 10 + n02;
                    //println!("test de: {} ({})",n2, n);
                    if n2 >= debut && n2 <= fin {
                        println!("id invalide: {}", n2);
                        resultat += n2;
                    }

                    if n2 > fin {
                        break;
                    }
                }
            }
        }
    }

    return resultat;
}

// The output is wrapped in a Result to allow matching on errors.
// Returns an Iterator to the Reader of the lines of the file.
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

#[cfg(test)]
mod tests {
    // Note this useful idiom: importing names from outer (for mod tests) scope.
    use super::*;

    #[test]
    fn test_partie1_exemple() {
        assert_eq!(partie1("./test1.txt"), 1227775554i64);
    }

    #[test]
    fn test_partie1_input() {
        assert_eq!(partie1("./input.txt"), 29940924880i64);
    }
}
