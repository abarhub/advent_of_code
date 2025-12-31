use std::collections::HashSet;
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
    //partie1("input.txt");
    //partie2("test1.txt");
    partie2("input.txt");
}

fn partie2(filename: &str) -> i64 {
    let (tx, rx) = mpsc::channel();

    parse(filename, tx);

    let resultat = calcul2(rx);
    println!("resultat: {:?}", resultat);
    return resultat;
}

fn calcul2(rx: Receiver<Interval>) -> i64 {
    let (tx2, rx2) = mpsc::channel();

    for interval in rx {
        let debut = interval.debut;
        let fin = interval.fin;
        let debut_str = interval.debut_str;
        let fin_str = interval.fin_str;
        let len_min = debut_str.len();
        let len_max = fin_str.len();

        println!("verification pour: {} - {}", debut_str, fin_str);

        // for taille_nombre in len_min..=len_max {
        //     if taille_nombre % 2 == 0 {
        //         let taille_doublons = taille_nombre / 2;
        //
        //         for nb_doublons in 1..=taille_doublons {
        //             // if debut_str.len() ==fin_str.len() && nb_doublons>fin_str.len() {
        //             //     continue;
        //             // }
        //             if taille_doublons*nb_doublons!=taille_nombre{
        //                 continue;
        //             }
        //             liste_nombres(debut, fin, taille_nombre, taille_doublons, nb_doublons as u64, &tx2);
        //         }
        //
        //         //liste_nombres(debut, fin, i, i0, 2, &tx2);
        //     }
        // }

        liste_nombres2(debut, fin, len_min, len_max, &tx2);
    }

    drop(tx2);

    let mut resultat = 0;
    let mut set = HashSet::new();
    for valeur in rx2 {
        if !set.contains(&valeur) {
            resultat += valeur;
            set.insert(valeur);
        }
    }

    return resultat;
}

fn liste_nombres2(debut: i64, fin: i64, len_min: usize, len_max: usize, tx: &Sender<i64>) {
    for taille_nombre in len_min..=len_max {
        for diviseur in 2..=taille_nombre {
            if taille_nombre % diviseur == 0 {
                let taille_doublons = taille_nombre / diviseur;

                for nb_doublons in 1..=taille_nombre {
                    // if debut_str.len() ==fin_str.len() && nb_doublons>fin_str.len() {
                    //     continue;
                    // }
                    if taille_doublons * nb_doublons != taille_nombre {
                        continue;
                    }
                    liste_nombres(
                        debut,
                        fin,
                        taille_nombre,
                        taille_doublons,
                        nb_doublons as u64,
                        &tx,
                    );
                }

                //liste_nombres(debut, fin, i, i0, 2, &tx2);
            }
        }
    }
}

fn liste_nombres(
    debut: i64,
    fin: i64,
    taille_nombre: usize,
    taille_doublons: usize,
    nb_doublons: u64,
    tx: &Sender<i64>,
) {
    let n = 10i64.checked_pow((taille_doublons - 1) as u32).unwrap();
    let n_max = 10i64.checked_pow((taille_doublons) as u32).unwrap() - 1;
    let n3 = 10i64.checked_pow((taille_doublons) as u32).unwrap();

    println!(
        "i: {} ({}), n:{}, n_max: {}",
        taille_nombre, taille_doublons, n, n_max
    );

    let mut resultat = 0i64;
    for n02 in n..=n_max {
        let mut n2 = n02;
        let s5 = n02.to_string();
        let mut s6 = String::new();
        //println!("test0 de: {} ({}), {}, {}",n2, n, n02,nb);

        for k in 0..nb_doublons {
            //n2 = n2 * n3 + n02;
            s6 = s6 + s5.as_str();
        }
        //println!("test de: {} ({}), {}, '{}', {}, {}, {}",n2, n, n02,s6, nb_doublons, debut, fin);
        n2 = s6.parse::<i64>().unwrap();
        //println!("test de: {} ({})",n2, n);
        if n2 >= debut && n2 <= fin {
            println!("id invalide: {}", n2);
            resultat += n2;
            tx.send(n2).unwrap();
        }

        if n2 > fin {
            break;
        }
    }
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

    #[test]
    fn test_partie2_exemple() {
        assert_eq!(partie2("./test1.txt"), 4174379265i64);
    }

    #[test]
    fn test_partie2_input() {
        assert_eq!(partie2("./input.txt"), 48631958998i64);
    }

    #[test]
    fn test_partie2_liste_nombres2() {
        let resultat = test_liste_nombres2(11, 22);
        assert_eq!(resultat.len(), 2);
        assert_eq!(resultat[0], 11);
        assert_eq!(resultat[1], 22);
    }

    #[test]
    fn test_partie2_liste_nombres2_bis() {
        let resultat = test_liste_nombres2(95, 115);
        assert_eq!(resultat.len(), 2);
        assert_eq!(resultat[0], 99);
        assert_eq!(resultat[1], 111);
    }

    fn test_liste_nombres2(debut: i64, fin: i64) -> Vec<i64> {
        let len_min = debut.to_string().len();
        let len_max = fin.to_string().len();
        let (tx, rx) = mpsc::channel();
        liste_nombres2(debut, fin, len_min, len_max, &tx);
        drop(tx);
        let mut resultat = vec![];
        for valeur in rx {
            resultat.push(valeur);
        }
        return resultat;
    }
}
