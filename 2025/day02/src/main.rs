use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::sync::mpsc;
use std::sync::mpsc::Sender;


#[derive(Debug)]
struct Interval {
    debut: i32,
    fin: i32,
}

fn main() {
    println!("Hello, world!");
    partie1();
}

fn partie1() {
    let (tx, rx) = mpsc::channel();

    parse("test1.txt",tx);
}


fn parse(filename: &str, tx: Sender<Interval>) {
    // File hosts.txt must exist in the current path
    if let Ok(lines) = read_lines(filename) {
        for line in lines.map_while(Result::ok) {

            let tab=line.split(",");

            for part in tab {

                let parties=part.split("-");
                if parties.clone().count() == 2 {
                    let collection = parties.collect::<Vec<&str>>();
                    let debut = collection[0].parse::<i32>().unwrap();
                    let fin = collection[1].parse::<i32>().unwrap();
                    let interval = Interval{debut, fin };
                    tx.send(interval).unwrap();
                }
            }

        }
    }

    drop(tx); // important : permet à recv() de savoir quand finir
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