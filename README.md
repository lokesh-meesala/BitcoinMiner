# BitcoinMiner
Developed Bitcoin Miner using Erlang and principles of Distributed operating systems.
## Execution Steps:
1. Create a node using following command.<br/>
    erl -name username@IPAddress
2. Compile the erl file. <br/>
    c(filename).
3. start the server in node.
    filename:initiate_server().
4. provide the leading zeroes for the bitcoin as input followed by '.'.
5. Execute the implementation using following command.
   filename:calc('username@IPAddress',workunits).
   
## System Specs
11th Gen Intel(R) Core(TM) i5<br/>
Sockets - 1<br/>
Cores - 4<br/>

## Questions
1. Best performance for the work units.

   Size of the work units to get best performance from the implementation can be scene for 500 processing units with a processing speed of 7.31<br/>
   We calculated the performances for the input string length of 200.
   
|  Work units | 10 | 100 |500|1000|
| ----------- | -- | -- | -- | -- |
| Performance |5.28| 6.78|7.31|6.51| 

![500-7 31](https://user-images.githubusercontent.com/92518161/192125768-2fdc1e46-1da2-433f-98cf-cfafa0ffc3a7.jpeg)


2. Input size of 4 i.e. bitcoins with 4 leading zeroes<br/>

![input 4](https://user-images.githubusercontent.com/92518161/192122892-a0d7e0f7-ef79-4f35-be28-435afcc5ee97.jpeg)


3. Parallelism for input size of 4 <br/>
   CPU time = 18875<br/>
   REAL time = 4811<br/>
   RATIO = 3.92<br/>
   For 4 cores, we can see a ratio of 3.92 showing that parallelism is achieved.
   
 4. most 0's in the bitcoin we found is '7'.<br/>
    While mining for bitcoins with 7 leading 0's, the processor found few but takes a lot of time to complete.<br/>
    
 ![7s](https://user-images.githubusercontent.com/92518161/192125882-eaa02ea3-0cf1-41b2-8e2e-4174a6b717e0.jpg)
