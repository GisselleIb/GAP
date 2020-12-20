Primero se deben cargar las bases de datos con el comando:

$ sqlite3 db/gap3.db < db/gap3.sql
$ sqlite3 db/gap3.db < db/gap3.sql

Para compilar el programa basta con escribir en la terminal
desde este directorio:

$ nim c src/main.nim

Una vez compilado para ejecutar el programa se debe escribir en la terminal:

$ ./src/main db/gap3.db [semilla1,...,semillak]
$ ./src/main db/gap4.db [semilla1,...,semillak]

Las mejores semillas para probar cada instancia vienen en el archivo data/seeds.txt
