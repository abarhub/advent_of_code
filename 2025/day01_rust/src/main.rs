use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    //read_file("./test1.txt");
    read_file("./input.txt");
}

fn read_file(filename: &str) {
    // File hosts.txt must exist in the current path
    if let Ok(lines) = read_lines(filename) {
        // Consumes the iterator, returns an (Optional) String
        let mut valeur = 50;
        let mut nb_zero = 0;
        let mut valeur_precedente: i32;

        for line in lines.map_while(Result::ok) {
            println!("{}", line);
            valeur_precedente = valeur;
            if line.starts_with("L") {
                let n = &line[1..].parse::<i32>().unwrap();
                println!("left: {}", n);
                valeur = (valeur + n) % 100;
            } else if line.starts_with("R") {
                let n = &line[1..].parse::<i32>().unwrap();
                println!("right: {}", n);
                valeur = (valeur - n) % 100;
            }
            if valeur_precedente != valeur && valeur == 0 {
                nb_zero += 1;
            }
        }
        println!("valeur finale: {}", valeur);
        println!("nombre zero: {}", nb_zero);
    }
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
