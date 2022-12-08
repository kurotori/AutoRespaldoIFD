# AutoRespaldoIFD
Sistema de respaldo periódico automatizado de las computadoras de una red local mixta GNU/Linux y MS Windows, con IP dinámica, hacia un servidor de almacenamiento.
## Propósito
El sistema se basa en una serie de scripts (*bash* en el caso del servidor y las PCs con GNU/Linux, *[AutoIt 3][autoit]* en el caso de las PCs con MS Windows) que permiten configurar y ejecutar de forma periódica respaldos de los documentos generados en las mismas.
## Nmap
Este sistema se basa, para su funcionalidad principal, en la funcionalidad del paquete *[NMAP][nmap]*. Este paquete es nativo o fácilmente instalable en las distribuciones de GNU/Linux utilizadas en el ambiente para el cuál este sistema fue desarrollado, pero no así en el caso de MS Windows, por lo que se incluye la versión correspondiente de NMAP para ese sistema operativo.   
## Origen
Este proyecto surge y se desarrolla en el Instituto de Formación Docente de Melo, y esta pensado para funcionar en la red administrativa de dicha institución.
## 

[autoit]: https://www.autoitscript.com/site/
[nmap]: https://nmap.org/