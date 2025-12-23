//package days01;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class Main {

    public static void main(String arg[]) throws IOException {
        //Path p=Path.of("test1.txt");
        Path p=Path.of("test2.txt");
        //Path p=Path.of("test3.txt");
        System.out.println("file:"+p);
        int total=0;
        var lines=Files.readAllLines(p);
        for(var line:lines){
            int nDebut=-1,nFin=-1;
            /*var opt=line.chars().filter(x->Character.isDigit(x)).findFirst();
            if(opt.isPresent()){
                nDebut=opt.getAsInt();
            }
            opt=line.chars().filter(x->Character.isDigit(x)).findFirst();
            if(opt.isPresent()){
                nDebut=opt.getAsInt();
            }*/
            for(int i=0;i<line.length();i++){
                var n=nombre(line,i);
                if(n>=0){
                    nDebut=n;
                    break;
                }
            }
            for(int i=line.length()-1;i>=0;i--){
                var n=nombre(line,i);
                if(n>=0){
                    nFin=n;
                    break;
                }
            }
            System.out.println("line:"+line);
            if(nDebut==-1||nFin==-1){
                System.err.println("Erreur: début="+nDebut+",fin="+nFin);
            } else {
                total+=nDebut*10+nFin;
            }
        }
        System.out.println("total:"+total);
    }

    private static int nombre(String line,int pos){
        if(Character.isDigit(line.charAt(pos))){
            return line.charAt(pos)-'0';
        }
        if(line.startsWith("zero", pos)){
            return 0;
        }
        if(line.startsWith("one", pos)){
            return 1;
        }
        if(line.startsWith("two", pos)){
            return 2;
        }        
        if(line.startsWith("three", pos)){
            return 3;
        }
        if(line.startsWith("four", pos)){
            return 4;
        }
        if(line.startsWith("five", pos)){
            return 5;
        }
        if(line.startsWith("six", pos)){
            return 6;
        }
        if(line.startsWith("seven", pos)){
            return 7;
        }
        if(line.startsWith("eight", pos)){
            return 8;
        }
        if(line.startsWith("nine", pos)){
            return 9;
        }
        return-1;
    }

}