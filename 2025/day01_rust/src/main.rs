use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::sync::mpsc;
use std::sync::mpsc::{Receiver, Sender};

#[derive(Debug)]
struct Action {
    valeur: i32,
    valeur_ajoute: i32,
}

fn main() {
    let res: i32;
    //res = read_file("./test1.txt");
    //read_file("./input.txt");
    //res = read_file_bis("./test1.txt");
    res = read_file_bis("./input.txt");
    println!("resultat: {}", res);
}

fn read_file_bis(filename: &str) -> i32 {
    let (tx, rx) = mpsc::channel();

    parse(filename, tx);

    let nb_zero = calcul(rx);

    return nb_zero;
}

fn parse(filename: &str, tx: Sender<i32>) {
    // File hosts.txt must exist in the current path
    if let Ok(lines) = read_lines(filename) {
        for line in lines.map_while(Result::ok) {
            if line.starts_with("R") {
                let n = &line[1..].parse::<i32>().unwrap();

                let tx_clone = tx.clone();
                //thread::spawn(move || {
                tx_clone.send(*n).unwrap();
                //});
            } else if line.starts_with("L") {
                let n = &line[1..].parse::<i32>().unwrap();

                let tx_clone = tx.clone();
                //thread::spawn(move || {
                let n2 = -n;
                tx_clone.send(n2).unwrap();
                //});
            }
        }
    }

    drop(tx); // important : permet à recv() de savoir quand finir
}

fn calcul(rx: Receiver<i32>) -> i32 {
    let mut valeur = 50;
    let mut nb_zero = 0;

    println!("Valeur initiale: {}, nb_zero: {}", valeur, nb_zero);

    for nb in rx {
        //println!("Reçu: {}", nb);

        let n = nb;
        if n >= 0 {
            //nb_zero += (valeur + n) / 100;
            //valeur = (valeur + n) % 100;
            let valeur2: i32;
            let nb_zero2: i32;
            (valeur2, nb_zero2) = ajout(valeur, n);
            valeur = valeur2;
            nb_zero += nb_zero2;
        } else {
            // let mut n2 = valeur - n;
            // if n2 < 0 {
            //     let mut n0 = valeur;
            //     while n2 < 0 {
            //         //if n0!=0 || true {
            //         nb_zero += 1;
            //         //}
            //         n2 += 100;
            //         n0 = n2;
            //     }
            // } else if n2 == 0 {
            //     nb_zero += 1;
            // }
            let nb_zero2: i32;
            (valeur, nb_zero2) = soustrait(valeur, -n);
            nb_zero += nb_zero2;

            //nb_zero+=(valeur+n)/100;
            //valeur=(valeur+n)%100;
        }
        println!("Reçu: {}, valeur: {}, nb_zero: {}", nb, valeur, nb_zero);
    }

    return nb_zero;
}

fn ajout(valeur: i32, nb_ajout: i32) -> (i32, i32) {
    if true {
        return calcul_suite(valeur, nb_ajout);
    } else {
        let nb_zero = (valeur + nb_ajout) / 100;
        let valeur2 = (valeur + nb_ajout) % 100;
        return (valeur2, nb_zero);
    }
}

fn soustrait(valeur: i32, nb_soustrait: i32) -> (i32, i32) {
    if true {
        return calcul_suite(valeur, -nb_soustrait);
    } else {
        let mut n2 = valeur - nb_soustrait;
        let mut nb_zero = 0;
        let mut valeur2 = valeur;
        if valeur == 0 {
            nb_zero = nb_soustrait / 100;
            // n2 = n2 % 100;
            while n2 < 0 {
                n2 += 100;
            }
        } else if n2 < 0 {
            let mut n0 = valeur;
            let mut premier = true;
            nb_zero = 1 + (nb_soustrait / 100);
            // n2 = n2 % 100;
            while n2 < 0 {
                // if !(premier && valeur == 0) {
                //     nb_zero += 1;
                // }
                n2 += 100;
                n0 = n2;
                premier = false;
            }
            if n2 == 0 {
                nb_zero += 1;
            }
        } else if n2 == 0 {
            nb_zero += 1;
        }
        valeur2 = n2;
        return (valeur2, nb_zero);
    }
}

fn calcul_modulo(n: i32, diviseur: i32) -> i32 {
    let mut n2 = n;
    while n2 < 0 || n2 >= diviseur {
        if n2 >= diviseur {
            n2 -= diviseur;
        } else if n2 < 0 {
            n2 += diviseur;
        }
    }
    return n2;
}

fn calcul_suite(valeur_initiale: i32, valeur_ajoute: i32) -> (i32, i32) {

    let mut n2=valeur_initiale;
    let mut nb_zero = 0;
    let mut valeur_corrigee = n2;
    let valeur_ajoute_abs= valeur_ajoute.abs();

    for n in 1..=valeur_ajoute_abs{

        if valeur_ajoute>=0{
            valeur_corrigee=(valeur_corrigee+1)%100;
        } else {
            valeur_corrigee=(valeur_corrigee-1+100)%100;
        }

        if valeur_corrigee==0{
            nb_zero+=1;
        }
    }

    return (valeur_corrigee, nb_zero);
}

fn calcul_suite2(valeur_initiale: i32, valeur_ajoute: i32) -> (i32, i32) {
    let mut n2 = valeur_initiale + valeur_ajoute;
    let mut nb_zero = 0;
    let mut valeur_corrigee = n2;
    let diviseur = 100;

    if valeur_corrigee < 0 || valeur_corrigee >= diviseur {
        while valeur_corrigee < 0 || valeur_corrigee >= diviseur {
            if valeur_corrigee >= diviseur {
                valeur_corrigee -= diviseur;
            } else if valeur_corrigee < 0 {
                valeur_corrigee += diviseur;
            }
            nb_zero += 1
        }
        if valeur_initiale == 0 && nb_zero > 0 {
            nb_zero -= 1;
        } else if valeur_corrigee == 0 && valeur_ajoute < 0 {
            nb_zero += 1
        }
    } else if valeur_corrigee == 0 {
        nb_zero += 1
    }

    return (valeur_corrigee, nb_zero);
}

fn read_file_bis_old(filename: &str) -> i32 {
    // File hosts.txt must exist in the current path
    if let Ok(lines) = read_lines(filename) {
        // Consumes the iterator, returns an (Optional) String
        let mut valeur = 50;
        let mut nb_zero = 0;

        println!("valeur initiale: {}", valeur);

        for line in lines.map_while(Result::ok) {
            println!("{}", line);
            if line.starts_with("R") {
                let n = &line[1..].parse::<i32>().unwrap();
                println!("right: {}", n);
                let n2 = valeur + n;
                valeur = n2 % 100;
                if n2 > 99 {
                    nb_zero += n2 / 100;
                } else if valeur == 0 {
                    nb_zero += 1;
                }
            } else if line.starts_with("L") {
                let n = &line[1..].parse::<i32>().unwrap();
                println!("left: {}", n);
                let mut n2 = valeur - n;
                if n2 < 0 {
                    let mut n0 = valeur;
                    while n2 < 0 {
                        if n0 != 0 || true {
                            nb_zero += 1;
                        }
                        n2 += 100;
                        n0 = n2;
                    }
                } else if n2 == 0 {
                    nb_zero += 1;
                }
                valeur = n2;
            }
            println!("valeur: {}, nb zero: {}", valeur, nb_zero);
        }
        println!("valeur finale: {}", valeur);
        println!("nombre zero: {}", nb_zero);

        return nb_zero;
    }
    return 0;
}

fn read_file(filename: &str) -> i32 {
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
        return nb_zero;
    }
    return 0;
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
    use rstest::rstest;

    #[test]
    fn test_read_file_exemple() {
        assert_eq!(read_file("./test1.txt"), 3);
    }

    #[test]
    fn test_read_file_input() {
        assert_eq!(read_file("./input.txt"), 1036);
    }

    #[test]
    fn test_read_file_bis_exemple() {
        assert_eq!(read_file_bis("./test1.txt"), 6);
    }

    #[test]
    fn test_read_file_bis_input() {
        assert_eq!(read_file_bis("./input.txt"), 6228);
    }

    #[test]
    fn test_read_file_bis_test1() {
        assert_eq!(read_file_bis("./test_files/test1_1.txt"), 1);
        assert_eq!(read_file_bis("./test_files/test2_1.txt"), 1);
        assert_eq!(read_file_bis("./test_files/test3_1.txt"), 1);
        assert_eq!(read_file_bis("./test_files/test4_1.txt"), 1);

        assert_eq!(read_file_bis("./test_files/test1_2.txt"), 2);
        assert_eq!(read_file_bis("./test_files/test2_2.txt"), 2);
        assert_eq!(read_file_bis("./test_files/test3_2.txt"), 2);
        assert_eq!(read_file_bis("./test_files/test4_2.txt"), 2);
    }

    #[test]
    fn test_ajout() {
        assert_eq!(ajout(50, 5), (55, 0));
        assert_eq!(ajout(50, 35), (85, 0));
        assert_eq!(ajout(52, 48), (0, 1));
        assert_eq!(ajout(95, 60), (55, 1));
        assert_eq!(ajout(0, 14), (14, 0));
    }

    #[test]
    fn test_ajout2() {
        assert_eq!(ajout(98, 1), (99, 0));
        assert_eq!(ajout(98, 2), (0, 1));
        assert_eq!(ajout(98, 3), (1, 1));
        assert_eq!(ajout(98, 4), (2, 1));
        assert_eq!(ajout(98, 101), (99, 1));
        assert_eq!(ajout(98, 102), (0, 2));
        assert_eq!(ajout(98, 103), (1, 2));
        assert_eq!(ajout(98, 104), (2, 2));
        assert_eq!(ajout(98, 201), (99, 2));
        assert_eq!(ajout(98, 202), (0, 3));
        assert_eq!(ajout(98, 203), (1, 3));
        assert_eq!(ajout(98, 204), (2, 3));
        assert_eq!(ajout(98, 301), (99, 3));
        assert_eq!(ajout(98, 302), (0, 4));
        assert_eq!(ajout(98, 303), (1, 4));
        assert_eq!(ajout(98, 304), (2, 4));
        assert_eq!(ajout(0, 10), (10, 0));
        assert_eq!(ajout(90, 10), (0, 1));
    }

    #[test]
    fn test_soustrait() {
        assert_eq!(soustrait(50, 35), (15, 0));
        assert_eq!(soustrait(50, 68), (82, 1));
        assert_eq!(soustrait(82, 30), (52, 0));
        assert_eq!(soustrait(0, 5), (95, 0));
        assert_eq!(soustrait(55, 55), (0, 1));
        assert_eq!(soustrait(0, 1), (99, 0));
        assert_eq!(soustrait(99, 99), (0, 1));
        assert_eq!(soustrait(14, 82), (32, 1));
    }

    #[test]
    fn test_soustrait3() {
        assert_eq!(soustrait(3, 1), (2, 0));
        assert_eq!(soustrait(3, 2), (1, 0));
        assert_eq!(soustrait(3, 3), (0, 1));
        assert_eq!(soustrait(3, 4), (99, 1));
        assert_eq!(soustrait(3, 5), (98, 1));
        assert_eq!(soustrait(3, 101), (2, 1));
        assert_eq!(soustrait(3, 102), (1, 1));
        assert_eq!(soustrait(3, 103), (0, 2));
        assert_eq!(soustrait(3, 104), (99, 2));
        assert_eq!(soustrait(3, 105), (98, 2));
        assert_eq!(soustrait(3, 201), (2, 2));
        assert_eq!(soustrait(3, 202), (1, 2));
        assert_eq!(soustrait(3, 203), (0, 3));
        assert_eq!(soustrait(3, 204), (99, 3));
        assert_eq!(soustrait(3, 205), (98, 3));
        assert_eq!(soustrait(3, 301), (2, 3));
        assert_eq!(soustrait(3, 302), (1, 3));
        assert_eq!(soustrait(3, 303), (0, 4));
        assert_eq!(soustrait(3, 304), (99, 4));
        assert_eq!(soustrait(3, 305), (98, 4));
        assert_eq!(soustrait(0, 10), (90, 0));
    }

    #[rstest]
    #[case(50, 35, 15, 0)]
    #[case(50, 68, 82, 1)]
    fn test_soustrait2(
        #[case] valeur: i32,
        #[case] valeur_soustrait: i32,
        #[case] valeur_resultat: i32,
        #[case] nb_zero: i32,
    ) {
        assert_eq!(
            soustrait(valeur, valeur_soustrait),
            (valeur_resultat, nb_zero)
        );
    }

    #[test]
    fn test_calcul_modulo() {
        assert_eq!(calcul_modulo(50, 100), 50);
        assert_eq!(calcul_modulo(150, 100), 50);
        assert_eq!(calcul_modulo(10, 100), 10);
        assert_eq!(calcul_modulo(-10, 100), 90);
        assert_eq!(calcul_modulo(0, 100), 0);
        assert_eq!(calcul_modulo(99, 100), 99);
        assert_eq!(calcul_modulo(100, 100), 0);
        assert_eq!(calcul_modulo(101, 100), 1);
        assert_eq!(calcul_modulo(-1, 100), 99);
        assert_eq!(calcul_modulo(-2, 100), 98);
    }
}
