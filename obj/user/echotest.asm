
obj/user/echotest.debug:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 db 02 00 00       	callq  80031c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  800050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800054:	48 89 c6             	mov    %rax,%rsi
  800057:	48 bf 8e 42 80 00 00 	movabs $0x80428e,%rdi
  80005e:	00 00 00 
  800061:	b8 00 00 00 00       	mov    $0x0,%eax
  800066:	48 ba 0f 05 80 00 00 	movabs $0x80050f,%rdx
  80006d:	00 00 00 
  800070:	ff d2                	callq  *%rdx
	exit();
  800072:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  800079:	00 00 00 
  80007c:	ff d0                	callq  *%rax
}
  80007e:	c9                   	leaveq 
  80007f:	c3                   	retq   

0000000000800080 <umain>:

void umain(int argc, char **argv)
{
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	48 83 ec 50          	sub    $0x50,%rsp
  800088:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80008b:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80008f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("Connecting to:\n");
  800096:	48 bf 92 42 80 00 00 	movabs $0x804292,%rdi
  80009d:	00 00 00 
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	48 ba 0f 05 80 00 00 	movabs $0x80050f,%rdx
  8000ac:	00 00 00 
  8000af:	ff d2                	callq  *%rdx
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  8000b1:	48 bf a2 42 80 00 00 	movabs $0x8042a2,%rdi
  8000b8:	00 00 00 
  8000bb:	48 b8 dc 3d 80 00 00 	movabs $0x803ddc,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	callq  *%rax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	48 be a2 42 80 00 00 	movabs $0x8042a2,%rsi
  8000d0:	00 00 00 
  8000d3:	48 bf ac 42 80 00 00 	movabs $0x8042ac,%rdi
  8000da:	00 00 00 
  8000dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e2:	48 b9 0f 05 80 00 00 	movabs $0x80050f,%rcx
  8000e9:	00 00 00 
  8000ec:	ff d1                	callq  *%rcx

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000ee:	ba 06 00 00 00       	mov    $0x6,%edx
  8000f3:	be 01 00 00 00       	mov    $0x1,%esi
  8000f8:	bf 02 00 00 00       	mov    $0x2,%edi
  8000fd:	48 b8 05 2d 80 00 00 	movabs $0x802d05,%rax
  800104:	00 00 00 
  800107:	ff d0                	callq  *%rax
  800109:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80010c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800110:	79 16                	jns    800128 <umain+0xa8>
		die("Failed to create socket");
  800112:	48 bf c1 42 80 00 00 	movabs $0x8042c1,%rdi
  800119:	00 00 00 
  80011c:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  800128:	48 bf d9 42 80 00 00 	movabs $0x8042d9,%rdi
  80012f:	00 00 00 
  800132:	b8 00 00 00 00       	mov    $0x0,%eax
  800137:	48 ba 0f 05 80 00 00 	movabs $0x80050f,%rdx
  80013e:	00 00 00 
  800141:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800143:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800147:	ba 10 00 00 00       	mov    $0x10,%edx
  80014c:	be 00 00 00 00       	mov    $0x0,%esi
  800151:	48 89 c7             	mov    %rax,%rdi
  800154:	48 b8 77 13 80 00 00 	movabs $0x801377,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  800160:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  800164:	48 bf a2 42 80 00 00 	movabs $0x8042a2,%rdi
  80016b:	00 00 00 
  80016e:	48 b8 dc 3d 80 00 00 	movabs $0x803ddc,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
  80017a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  80017d:	bf 10 27 00 00       	mov    $0x2710,%edi
  800182:	48 b8 e4 41 80 00 00 	movabs $0x8041e4,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
  80018e:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to connect to server\n");
  800192:	48 bf e8 42 80 00 00 	movabs $0x8042e8,%rdi
  800199:	00 00 00 
  80019c:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a1:	48 ba 0f 05 80 00 00 	movabs $0x80050f,%rdx
  8001a8:	00 00 00 
  8001ab:	ff d2                	callq  *%rdx

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8001ad:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  8001b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b4:	ba 10 00 00 00       	mov    $0x10,%edx
  8001b9:	48 89 ce             	mov    %rcx,%rsi
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	48 b8 ca 2b 80 00 00 	movabs $0x802bca,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	79 16                	jns    8001e4 <umain+0x164>
		die("Failed to connect with server");
  8001ce:	48 bf 05 43 80 00 00 	movabs $0x804305,%rdi
  8001d5:	00 00 00 
  8001d8:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax

	cprintf("connected to server\n");
  8001e4:	48 bf 23 43 80 00 00 	movabs $0x804323,%rdi
  8001eb:	00 00 00 
  8001ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f3:	48 ba 0f 05 80 00 00 	movabs $0x80050f,%rdx
  8001fa:	00 00 00 
  8001fd:	ff d2                	callq  *%rdx

	// Send the word to the server
	echolen = strlen(msg);
  8001ff:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800206:	00 00 00 
  800209:	48 8b 00             	mov    (%rax),%rax
  80020c:	48 89 c7             	mov    %rax,%rdi
  80020f:	48 b8 74 10 80 00 00 	movabs $0x801074,%rax
  800216:	00 00 00 
  800219:	ff d0                	callq  *%rax
  80021b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(sock, msg, echolen) != echolen)
  80021e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800221:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800228:	00 00 00 
  80022b:	48 8b 08             	mov    (%rax),%rcx
  80022e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800231:	48 89 ce             	mov    %rcx,%rsi
  800234:	89 c7                	mov    %eax,%edi
  800236:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  80023d:	00 00 00 
  800240:	ff d0                	callq  *%rax
  800242:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800245:	74 16                	je     80025d <umain+0x1dd>
		die("Mismatch in number of sent bytes");
  800247:	48 bf 38 43 80 00 00 	movabs $0x804338,%rdi
  80024e:	00 00 00 
  800251:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax

	// Receive the word back from the server
	cprintf("Received: \n");
  80025d:	48 bf 59 43 80 00 00 	movabs $0x804359,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	48 ba 0f 05 80 00 00 	movabs $0x80050f,%rdx
  800273:	00 00 00 
  800276:	ff d2                	callq  *%rdx
	while (received < echolen) {
  800278:	eb 6b                	jmp    8002e5 <umain+0x265>
		int bytes = 0;
  80027a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800281:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  800285:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800288:	ba 1f 00 00 00       	mov    $0x1f,%edx
  80028d:	48 89 ce             	mov    %rcx,%rsi
  800290:	89 c7                	mov    %eax,%edi
  800292:	48 b8 80 22 80 00 00 	movabs $0x802280,%rax
  800299:	00 00 00 
  80029c:	ff d0                	callq  *%rax
  80029e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a5:	7f 16                	jg     8002bd <umain+0x23d>
			die("Failed to receive bytes from server");
  8002a7:	48 bf 68 43 80 00 00 	movabs $0x804368,%rdi
  8002ae:	00 00 00 
  8002b1:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8002b8:	00 00 00 
  8002bb:	ff d0                	callq  *%rax
		}
		received += bytes;
  8002bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002c0:	01 45 fc             	add    %eax,-0x4(%rbp)
		buffer[bytes] = '\0';        // Assure null terminated string
  8002c3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002c6:	48 98                	cltq   
  8002c8:	c6 44 05 c0 00       	movb   $0x0,-0x40(%rbp,%rax,1)
		cprintf(buffer);
  8002cd:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d9:	48 ba 0f 05 80 00 00 	movabs $0x80050f,%rdx
  8002e0:	00 00 00 
  8002e3:	ff d2                	callq  *%rdx
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  8002e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e8:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002eb:	72 8d                	jb     80027a <umain+0x1fa>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8002ed:	48 bf 8c 43 80 00 00 	movabs $0x80438c,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	48 ba 0f 05 80 00 00 	movabs $0x80050f,%rdx
  800303:	00 00 00 
  800306:	ff d2                	callq  *%rdx

	close(sock);
  800308:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030b:	89 c7                	mov    %eax,%edi
  80030d:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  800314:	00 00 00 
  800317:	ff d0                	callq  *%rax
}
  800319:	c9                   	leaveq 
  80031a:	c3                   	retq   
	...

000000000080031c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80031c:	55                   	push   %rbp
  80031d:	48 89 e5             	mov    %rsp,%rbp
  800320:	48 83 ec 10          	sub    $0x10,%rsp
  800324:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800327:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80032b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800332:	00 00 00 
  800335:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  80033c:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  800343:	00 00 00 
  800346:	ff d0                	callq  *%rax
  800348:	48 98                	cltq   
  80034a:	48 89 c2             	mov    %rax,%rdx
  80034d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800353:	48 89 d0             	mov    %rdx,%rax
  800356:	48 c1 e0 02          	shl    $0x2,%rax
  80035a:	48 01 d0             	add    %rdx,%rax
  80035d:	48 01 c0             	add    %rax,%rax
  800360:	48 01 d0             	add    %rdx,%rax
  800363:	48 c1 e0 05          	shl    $0x5,%rax
  800367:	48 89 c2             	mov    %rax,%rdx
  80036a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800371:	00 00 00 
  800374:	48 01 c2             	add    %rax,%rdx
  800377:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80037e:	00 00 00 
  800381:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800384:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800388:	7e 14                	jle    80039e <libmain+0x82>
		binaryname = argv[0];
  80038a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038e:	48 8b 10             	mov    (%rax),%rdx
  800391:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800398:	00 00 00 
  80039b:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80039e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a5:	48 89 d6             	mov    %rdx,%rsi
  8003a8:	89 c7                	mov    %eax,%edi
  8003aa:	48 b8 80 00 80 00 00 	movabs $0x800080,%rax
  8003b1:	00 00 00 
  8003b4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003b6:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	callq  *%rax
}
  8003c2:	c9                   	leaveq 
  8003c3:	c3                   	retq   

00000000008003c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003c4:	55                   	push   %rbp
  8003c5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003c8:	48 b8 a9 20 80 00 00 	movabs $0x8020a9,%rax
  8003cf:	00 00 00 
  8003d2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d9:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  8003e0:	00 00 00 
  8003e3:	ff d0                	callq  *%rax
}
  8003e5:	5d                   	pop    %rbp
  8003e6:	c3                   	retq   
	...

00000000008003e8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003e8:	55                   	push   %rbp
  8003e9:	48 89 e5             	mov    %rsp,%rbp
  8003ec:	48 83 ec 10          	sub    $0x10,%rsp
  8003f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fb:	8b 00                	mov    (%rax),%eax
  8003fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800400:	89 d6                	mov    %edx,%esi
  800402:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800406:	48 63 d0             	movslq %eax,%rdx
  800409:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80040e:	8d 50 01             	lea    0x1(%rax),%edx
  800411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800415:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041b:	8b 00                	mov    (%rax),%eax
  80041d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800422:	75 2c                	jne    800450 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800428:	8b 00                	mov    (%rax),%eax
  80042a:	48 98                	cltq   
  80042c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800430:	48 83 c2 08          	add    $0x8,%rdx
  800434:	48 89 c6             	mov    %rax,%rsi
  800437:	48 89 d7             	mov    %rdx,%rdi
  80043a:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  800441:	00 00 00 
  800444:	ff d0                	callq  *%rax
        b->idx = 0;
  800446:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800450:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800454:	8b 40 04             	mov    0x4(%rax),%eax
  800457:	8d 50 01             	lea    0x1(%rax),%edx
  80045a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800461:	c9                   	leaveq 
  800462:	c3                   	retq   

0000000000800463 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800463:	55                   	push   %rbp
  800464:	48 89 e5             	mov    %rsp,%rbp
  800467:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80046e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800475:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80047c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800483:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80048a:	48 8b 0a             	mov    (%rdx),%rcx
  80048d:	48 89 08             	mov    %rcx,(%rax)
  800490:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800494:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800498:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80049c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004a7:	00 00 00 
    b.cnt = 0;
  8004aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004b1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004b4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004bb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004c2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004c9:	48 89 c6             	mov    %rax,%rsi
  8004cc:	48 bf e8 03 80 00 00 	movabs $0x8003e8,%rdi
  8004d3:	00 00 00 
  8004d6:	48 b8 c0 08 80 00 00 	movabs $0x8008c0,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004e2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004e8:	48 98                	cltq   
  8004ea:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004f1:	48 83 c2 08          	add    $0x8,%rdx
  8004f5:	48 89 c6             	mov    %rax,%rsi
  8004f8:	48 89 d7             	mov    %rdx,%rdi
  8004fb:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  800502:	00 00 00 
  800505:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80050d:	c9                   	leaveq 
  80050e:	c3                   	retq   

000000000080050f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80050f:	55                   	push   %rbp
  800510:	48 89 e5             	mov    %rsp,%rbp
  800513:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80051a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800521:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800528:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80052f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800536:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80053d:	84 c0                	test   %al,%al
  80053f:	74 20                	je     800561 <cprintf+0x52>
  800541:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800545:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800549:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80054d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800551:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800555:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800559:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80055d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800561:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800568:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80056f:	00 00 00 
  800572:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800579:	00 00 00 
  80057c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800580:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800587:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80058e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800595:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80059c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005a3:	48 8b 0a             	mov    (%rdx),%rcx
  8005a6:	48 89 08             	mov    %rcx,(%rax)
  8005a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005b9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005c0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005c7:	48 89 d6             	mov    %rdx,%rsi
  8005ca:	48 89 c7             	mov    %rax,%rdi
  8005cd:	48 b8 63 04 80 00 00 	movabs $0x800463,%rax
  8005d4:	00 00 00 
  8005d7:	ff d0                	callq  *%rax
  8005d9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005df:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005e5:	c9                   	leaveq 
  8005e6:	c3                   	retq   
	...

00000000008005e8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e8:	55                   	push   %rbp
  8005e9:	48 89 e5             	mov    %rsp,%rbp
  8005ec:	48 83 ec 30          	sub    $0x30,%rsp
  8005f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005fc:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005ff:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800603:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800607:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80060a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80060e:	77 52                	ja     800662 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800610:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800613:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800617:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80061a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80061e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800622:	ba 00 00 00 00       	mov    $0x0,%edx
  800627:	48 f7 75 d0          	divq   -0x30(%rbp)
  80062b:	48 89 c2             	mov    %rax,%rdx
  80062e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800631:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800634:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80063c:	41 89 f9             	mov    %edi,%r9d
  80063f:	48 89 c7             	mov    %rax,%rdi
  800642:	48 b8 e8 05 80 00 00 	movabs $0x8005e8,%rax
  800649:	00 00 00 
  80064c:	ff d0                	callq  *%rax
  80064e:	eb 1c                	jmp    80066c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800650:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800654:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800657:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80065b:	48 89 d6             	mov    %rdx,%rsi
  80065e:	89 c7                	mov    %eax,%edi
  800660:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800662:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800666:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80066a:	7f e4                	jg     800650 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80066c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80066f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800673:	ba 00 00 00 00       	mov    $0x0,%edx
  800678:	48 f7 f1             	div    %rcx
  80067b:	48 89 d0             	mov    %rdx,%rax
  80067e:	48 ba 90 45 80 00 00 	movabs $0x804590,%rdx
  800685:	00 00 00 
  800688:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80068c:	0f be c0             	movsbl %al,%eax
  80068f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800693:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800697:	48 89 d6             	mov    %rdx,%rsi
  80069a:	89 c7                	mov    %eax,%edi
  80069c:	ff d1                	callq  *%rcx
}
  80069e:	c9                   	leaveq 
  80069f:	c3                   	retq   

00000000008006a0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 83 ec 20          	sub    $0x20,%rsp
  8006a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ac:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006af:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006b3:	7e 52                	jle    800707 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b9:	8b 00                	mov    (%rax),%eax
  8006bb:	83 f8 30             	cmp    $0x30,%eax
  8006be:	73 24                	jae    8006e4 <getuint+0x44>
  8006c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cc:	8b 00                	mov    (%rax),%eax
  8006ce:	89 c0                	mov    %eax,%eax
  8006d0:	48 01 d0             	add    %rdx,%rax
  8006d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d7:	8b 12                	mov    (%rdx),%edx
  8006d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e0:	89 0a                	mov    %ecx,(%rdx)
  8006e2:	eb 17                	jmp    8006fb <getuint+0x5b>
  8006e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ec:	48 89 d0             	mov    %rdx,%rax
  8006ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006fb:	48 8b 00             	mov    (%rax),%rax
  8006fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800702:	e9 a3 00 00 00       	jmpq   8007aa <getuint+0x10a>
	else if (lflag)
  800707:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80070b:	74 4f                	je     80075c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80070d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800711:	8b 00                	mov    (%rax),%eax
  800713:	83 f8 30             	cmp    $0x30,%eax
  800716:	73 24                	jae    80073c <getuint+0x9c>
  800718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800724:	8b 00                	mov    (%rax),%eax
  800726:	89 c0                	mov    %eax,%eax
  800728:	48 01 d0             	add    %rdx,%rax
  80072b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072f:	8b 12                	mov    (%rdx),%edx
  800731:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800734:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800738:	89 0a                	mov    %ecx,(%rdx)
  80073a:	eb 17                	jmp    800753 <getuint+0xb3>
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800744:	48 89 d0             	mov    %rdx,%rax
  800747:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80074b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800753:	48 8b 00             	mov    (%rax),%rax
  800756:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80075a:	eb 4e                	jmp    8007aa <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80075c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800760:	8b 00                	mov    (%rax),%eax
  800762:	83 f8 30             	cmp    $0x30,%eax
  800765:	73 24                	jae    80078b <getuint+0xeb>
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800773:	8b 00                	mov    (%rax),%eax
  800775:	89 c0                	mov    %eax,%eax
  800777:	48 01 d0             	add    %rdx,%rax
  80077a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077e:	8b 12                	mov    (%rdx),%edx
  800780:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800783:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800787:	89 0a                	mov    %ecx,(%rdx)
  800789:	eb 17                	jmp    8007a2 <getuint+0x102>
  80078b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800793:	48 89 d0             	mov    %rdx,%rax
  800796:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80079a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a2:	8b 00                	mov    (%rax),%eax
  8007a4:	89 c0                	mov    %eax,%eax
  8007a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007ae:	c9                   	leaveq 
  8007af:	c3                   	retq   

00000000008007b0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007b0:	55                   	push   %rbp
  8007b1:	48 89 e5             	mov    %rsp,%rbp
  8007b4:	48 83 ec 20          	sub    $0x20,%rsp
  8007b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007bc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007bf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007c3:	7e 52                	jle    800817 <getint+0x67>
		x=va_arg(*ap, long long);
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	8b 00                	mov    (%rax),%eax
  8007cb:	83 f8 30             	cmp    $0x30,%eax
  8007ce:	73 24                	jae    8007f4 <getint+0x44>
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dc:	8b 00                	mov    (%rax),%eax
  8007de:	89 c0                	mov    %eax,%eax
  8007e0:	48 01 d0             	add    %rdx,%rax
  8007e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e7:	8b 12                	mov    (%rdx),%edx
  8007e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f0:	89 0a                	mov    %ecx,(%rdx)
  8007f2:	eb 17                	jmp    80080b <getint+0x5b>
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007fc:	48 89 d0             	mov    %rdx,%rax
  8007ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800807:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80080b:	48 8b 00             	mov    (%rax),%rax
  80080e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800812:	e9 a3 00 00 00       	jmpq   8008ba <getint+0x10a>
	else if (lflag)
  800817:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80081b:	74 4f                	je     80086c <getint+0xbc>
		x=va_arg(*ap, long);
  80081d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800821:	8b 00                	mov    (%rax),%eax
  800823:	83 f8 30             	cmp    $0x30,%eax
  800826:	73 24                	jae    80084c <getint+0x9c>
  800828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800834:	8b 00                	mov    (%rax),%eax
  800836:	89 c0                	mov    %eax,%eax
  800838:	48 01 d0             	add    %rdx,%rax
  80083b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083f:	8b 12                	mov    (%rdx),%edx
  800841:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	89 0a                	mov    %ecx,(%rdx)
  80084a:	eb 17                	jmp    800863 <getint+0xb3>
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800854:	48 89 d0             	mov    %rdx,%rax
  800857:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80085b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800863:	48 8b 00             	mov    (%rax),%rax
  800866:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80086a:	eb 4e                	jmp    8008ba <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	8b 00                	mov    (%rax),%eax
  800872:	83 f8 30             	cmp    $0x30,%eax
  800875:	73 24                	jae    80089b <getint+0xeb>
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80087f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800883:	8b 00                	mov    (%rax),%eax
  800885:	89 c0                	mov    %eax,%eax
  800887:	48 01 d0             	add    %rdx,%rax
  80088a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088e:	8b 12                	mov    (%rdx),%edx
  800890:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800893:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800897:	89 0a                	mov    %ecx,(%rdx)
  800899:	eb 17                	jmp    8008b2 <getint+0x102>
  80089b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a3:	48 89 d0             	mov    %rdx,%rax
  8008a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008b2:	8b 00                	mov    (%rax),%eax
  8008b4:	48 98                	cltq   
  8008b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008be:	c9                   	leaveq 
  8008bf:	c3                   	retq   

00000000008008c0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008c0:	55                   	push   %rbp
  8008c1:	48 89 e5             	mov    %rsp,%rbp
  8008c4:	41 54                	push   %r12
  8008c6:	53                   	push   %rbx
  8008c7:	48 83 ec 60          	sub    $0x60,%rsp
  8008cb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008cf:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008d3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008d7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008db:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008df:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008e3:	48 8b 0a             	mov    (%rdx),%rcx
  8008e6:	48 89 08             	mov    %rcx,(%rax)
  8008e9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008ed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008f1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008f5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f9:	eb 17                	jmp    800912 <vprintfmt+0x52>
			if (ch == '\0')
  8008fb:	85 db                	test   %ebx,%ebx
  8008fd:	0f 84 ea 04 00 00    	je     800ded <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800903:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800907:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80090b:	48 89 c6             	mov    %rax,%rsi
  80090e:	89 df                	mov    %ebx,%edi
  800910:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800912:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800916:	0f b6 00             	movzbl (%rax),%eax
  800919:	0f b6 d8             	movzbl %al,%ebx
  80091c:	83 fb 25             	cmp    $0x25,%ebx
  80091f:	0f 95 c0             	setne  %al
  800922:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800927:	84 c0                	test   %al,%al
  800929:	75 d0                	jne    8008fb <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80092b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80092f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800936:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80093d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800944:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80094b:	eb 04                	jmp    800951 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80094d:	90                   	nop
  80094e:	eb 01                	jmp    800951 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800950:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800951:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800955:	0f b6 00             	movzbl (%rax),%eax
  800958:	0f b6 d8             	movzbl %al,%ebx
  80095b:	89 d8                	mov    %ebx,%eax
  80095d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800962:	83 e8 23             	sub    $0x23,%eax
  800965:	83 f8 55             	cmp    $0x55,%eax
  800968:	0f 87 4b 04 00 00    	ja     800db9 <vprintfmt+0x4f9>
  80096e:	89 c0                	mov    %eax,%eax
  800970:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800977:	00 
  800978:	48 b8 b8 45 80 00 00 	movabs $0x8045b8,%rax
  80097f:	00 00 00 
  800982:	48 01 d0             	add    %rdx,%rax
  800985:	48 8b 00             	mov    (%rax),%rax
  800988:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80098a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80098e:	eb c1                	jmp    800951 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800990:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800994:	eb bb                	jmp    800951 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800996:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80099d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009a0:	89 d0                	mov    %edx,%eax
  8009a2:	c1 e0 02             	shl    $0x2,%eax
  8009a5:	01 d0                	add    %edx,%eax
  8009a7:	01 c0                	add    %eax,%eax
  8009a9:	01 d8                	add    %ebx,%eax
  8009ab:	83 e8 30             	sub    $0x30,%eax
  8009ae:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009b1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009b5:	0f b6 00             	movzbl (%rax),%eax
  8009b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8009be:	7e 63                	jle    800a23 <vprintfmt+0x163>
  8009c0:	83 fb 39             	cmp    $0x39,%ebx
  8009c3:	7f 5e                	jg     800a23 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ca:	eb d1                	jmp    80099d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8009cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cf:	83 f8 30             	cmp    $0x30,%eax
  8009d2:	73 17                	jae    8009eb <vprintfmt+0x12b>
  8009d4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009d8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009db:	89 c0                	mov    %eax,%eax
  8009dd:	48 01 d0             	add    %rdx,%rax
  8009e0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e3:	83 c2 08             	add    $0x8,%edx
  8009e6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e9:	eb 0f                	jmp    8009fa <vprintfmt+0x13a>
  8009eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ef:	48 89 d0             	mov    %rdx,%rax
  8009f2:	48 83 c2 08          	add    $0x8,%rdx
  8009f6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009fa:	8b 00                	mov    (%rax),%eax
  8009fc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009ff:	eb 23                	jmp    800a24 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800a01:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a05:	0f 89 42 ff ff ff    	jns    80094d <vprintfmt+0x8d>
				width = 0;
  800a0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a12:	e9 36 ff ff ff       	jmpq   80094d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800a17:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a1e:	e9 2e ff ff ff       	jmpq   800951 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a23:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a28:	0f 89 22 ff ff ff    	jns    800950 <vprintfmt+0x90>
				width = precision, precision = -1;
  800a2e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a31:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a34:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a3b:	e9 10 ff ff ff       	jmpq   800950 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a40:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a44:	e9 08 ff ff ff       	jmpq   800951 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4c:	83 f8 30             	cmp    $0x30,%eax
  800a4f:	73 17                	jae    800a68 <vprintfmt+0x1a8>
  800a51:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a58:	89 c0                	mov    %eax,%eax
  800a5a:	48 01 d0             	add    %rdx,%rax
  800a5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a60:	83 c2 08             	add    $0x8,%edx
  800a63:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a66:	eb 0f                	jmp    800a77 <vprintfmt+0x1b7>
  800a68:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a6c:	48 89 d0             	mov    %rdx,%rax
  800a6f:	48 83 c2 08          	add    $0x8,%rdx
  800a73:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a77:	8b 00                	mov    (%rax),%eax
  800a79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a7d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a81:	48 89 d6             	mov    %rdx,%rsi
  800a84:	89 c7                	mov    %eax,%edi
  800a86:	ff d1                	callq  *%rcx
			break;
  800a88:	e9 5a 03 00 00       	jmpq   800de7 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a90:	83 f8 30             	cmp    $0x30,%eax
  800a93:	73 17                	jae    800aac <vprintfmt+0x1ec>
  800a95:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9c:	89 c0                	mov    %eax,%eax
  800a9e:	48 01 d0             	add    %rdx,%rax
  800aa1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa4:	83 c2 08             	add    $0x8,%edx
  800aa7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aaa:	eb 0f                	jmp    800abb <vprintfmt+0x1fb>
  800aac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ab0:	48 89 d0             	mov    %rdx,%rax
  800ab3:	48 83 c2 08          	add    $0x8,%rdx
  800ab7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800abb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800abd:	85 db                	test   %ebx,%ebx
  800abf:	79 02                	jns    800ac3 <vprintfmt+0x203>
				err = -err;
  800ac1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ac3:	83 fb 15             	cmp    $0x15,%ebx
  800ac6:	7f 16                	jg     800ade <vprintfmt+0x21e>
  800ac8:	48 b8 e0 44 80 00 00 	movabs $0x8044e0,%rax
  800acf:	00 00 00 
  800ad2:	48 63 d3             	movslq %ebx,%rdx
  800ad5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ad9:	4d 85 e4             	test   %r12,%r12
  800adc:	75 2e                	jne    800b0c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800ade:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ae2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae6:	89 d9                	mov    %ebx,%ecx
  800ae8:	48 ba a1 45 80 00 00 	movabs $0x8045a1,%rdx
  800aef:	00 00 00 
  800af2:	48 89 c7             	mov    %rax,%rdi
  800af5:	b8 00 00 00 00       	mov    $0x0,%eax
  800afa:	49 b8 f7 0d 80 00 00 	movabs $0x800df7,%r8
  800b01:	00 00 00 
  800b04:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b07:	e9 db 02 00 00       	jmpq   800de7 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b0c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b14:	4c 89 e1             	mov    %r12,%rcx
  800b17:	48 ba aa 45 80 00 00 	movabs $0x8045aa,%rdx
  800b1e:	00 00 00 
  800b21:	48 89 c7             	mov    %rax,%rdi
  800b24:	b8 00 00 00 00       	mov    $0x0,%eax
  800b29:	49 b8 f7 0d 80 00 00 	movabs $0x800df7,%r8
  800b30:	00 00 00 
  800b33:	41 ff d0             	callq  *%r8
			break;
  800b36:	e9 ac 02 00 00       	jmpq   800de7 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3e:	83 f8 30             	cmp    $0x30,%eax
  800b41:	73 17                	jae    800b5a <vprintfmt+0x29a>
  800b43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4a:	89 c0                	mov    %eax,%eax
  800b4c:	48 01 d0             	add    %rdx,%rax
  800b4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b52:	83 c2 08             	add    $0x8,%edx
  800b55:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b58:	eb 0f                	jmp    800b69 <vprintfmt+0x2a9>
  800b5a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b5e:	48 89 d0             	mov    %rdx,%rax
  800b61:	48 83 c2 08          	add    $0x8,%rdx
  800b65:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b69:	4c 8b 20             	mov    (%rax),%r12
  800b6c:	4d 85 e4             	test   %r12,%r12
  800b6f:	75 0a                	jne    800b7b <vprintfmt+0x2bb>
				p = "(null)";
  800b71:	49 bc ad 45 80 00 00 	movabs $0x8045ad,%r12
  800b78:	00 00 00 
			if (width > 0 && padc != '-')
  800b7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b7f:	7e 7a                	jle    800bfb <vprintfmt+0x33b>
  800b81:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b85:	74 74                	je     800bfb <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b87:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b8a:	48 98                	cltq   
  800b8c:	48 89 c6             	mov    %rax,%rsi
  800b8f:	4c 89 e7             	mov    %r12,%rdi
  800b92:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  800b99:	00 00 00 
  800b9c:	ff d0                	callq  *%rax
  800b9e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ba1:	eb 17                	jmp    800bba <vprintfmt+0x2fa>
					putch(padc, putdat);
  800ba3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800ba7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bab:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800baf:	48 89 d6             	mov    %rdx,%rsi
  800bb2:	89 c7                	mov    %eax,%edi
  800bb4:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bba:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bbe:	7f e3                	jg     800ba3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc0:	eb 39                	jmp    800bfb <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800bc2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bc6:	74 1e                	je     800be6 <vprintfmt+0x326>
  800bc8:	83 fb 1f             	cmp    $0x1f,%ebx
  800bcb:	7e 05                	jle    800bd2 <vprintfmt+0x312>
  800bcd:	83 fb 7e             	cmp    $0x7e,%ebx
  800bd0:	7e 14                	jle    800be6 <vprintfmt+0x326>
					putch('?', putdat);
  800bd2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bd6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bda:	48 89 c6             	mov    %rax,%rsi
  800bdd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800be2:	ff d2                	callq  *%rdx
  800be4:	eb 0f                	jmp    800bf5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800be6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bea:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bee:	48 89 c6             	mov    %rax,%rsi
  800bf1:	89 df                	mov    %ebx,%edi
  800bf3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf9:	eb 01                	jmp    800bfc <vprintfmt+0x33c>
  800bfb:	90                   	nop
  800bfc:	41 0f b6 04 24       	movzbl (%r12),%eax
  800c01:	0f be d8             	movsbl %al,%ebx
  800c04:	85 db                	test   %ebx,%ebx
  800c06:	0f 95 c0             	setne  %al
  800c09:	49 83 c4 01          	add    $0x1,%r12
  800c0d:	84 c0                	test   %al,%al
  800c0f:	74 28                	je     800c39 <vprintfmt+0x379>
  800c11:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c15:	78 ab                	js     800bc2 <vprintfmt+0x302>
  800c17:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c1f:	79 a1                	jns    800bc2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c21:	eb 16                	jmp    800c39 <vprintfmt+0x379>
				putch(' ', putdat);
  800c23:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c27:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c2b:	48 89 c6             	mov    %rax,%rsi
  800c2e:	bf 20 00 00 00       	mov    $0x20,%edi
  800c33:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3d:	7f e4                	jg     800c23 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c3f:	e9 a3 01 00 00       	jmpq   800de7 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c44:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c48:	be 03 00 00 00       	mov    $0x3,%esi
  800c4d:	48 89 c7             	mov    %rax,%rdi
  800c50:	48 b8 b0 07 80 00 00 	movabs $0x8007b0,%rax
  800c57:	00 00 00 
  800c5a:	ff d0                	callq  *%rax
  800c5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c64:	48 85 c0             	test   %rax,%rax
  800c67:	79 1d                	jns    800c86 <vprintfmt+0x3c6>
				putch('-', putdat);
  800c69:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c6d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c71:	48 89 c6             	mov    %rax,%rsi
  800c74:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c79:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7f:	48 f7 d8             	neg    %rax
  800c82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c86:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c8d:	e9 e8 00 00 00       	jmpq   800d7a <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c96:	be 03 00 00 00       	mov    $0x3,%esi
  800c9b:	48 89 c7             	mov    %rax,%rdi
  800c9e:	48 b8 a0 06 80 00 00 	movabs $0x8006a0,%rax
  800ca5:	00 00 00 
  800ca8:	ff d0                	callq  *%rax
  800caa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cae:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cb5:	e9 c0 00 00 00       	jmpq   800d7a <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cba:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cbe:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cc2:	48 89 c6             	mov    %rax,%rsi
  800cc5:	bf 58 00 00 00       	mov    $0x58,%edi
  800cca:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800ccc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cd0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cd4:	48 89 c6             	mov    %rax,%rsi
  800cd7:	bf 58 00 00 00       	mov    $0x58,%edi
  800cdc:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800cde:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ce2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ce6:	48 89 c6             	mov    %rax,%rsi
  800ce9:	bf 58 00 00 00       	mov    $0x58,%edi
  800cee:	ff d2                	callq  *%rdx
			break;
  800cf0:	e9 f2 00 00 00       	jmpq   800de7 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800cf5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cf9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cfd:	48 89 c6             	mov    %rax,%rsi
  800d00:	bf 30 00 00 00       	mov    $0x30,%edi
  800d05:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800d07:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d0b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d0f:	48 89 c6             	mov    %rax,%rsi
  800d12:	bf 78 00 00 00       	mov    $0x78,%edi
  800d17:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d1c:	83 f8 30             	cmp    $0x30,%eax
  800d1f:	73 17                	jae    800d38 <vprintfmt+0x478>
  800d21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d28:	89 c0                	mov    %eax,%eax
  800d2a:	48 01 d0             	add    %rdx,%rax
  800d2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d30:	83 c2 08             	add    $0x8,%edx
  800d33:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d36:	eb 0f                	jmp    800d47 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800d38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d3c:	48 89 d0             	mov    %rdx,%rax
  800d3f:	48 83 c2 08          	add    $0x8,%rdx
  800d43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d47:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d4e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d55:	eb 23                	jmp    800d7a <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d57:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d5b:	be 03 00 00 00       	mov    $0x3,%esi
  800d60:	48 89 c7             	mov    %rax,%rdi
  800d63:	48 b8 a0 06 80 00 00 	movabs $0x8006a0,%rax
  800d6a:	00 00 00 
  800d6d:	ff d0                	callq  *%rax
  800d6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d73:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d7a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d7f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d82:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d89:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d91:	45 89 c1             	mov    %r8d,%r9d
  800d94:	41 89 f8             	mov    %edi,%r8d
  800d97:	48 89 c7             	mov    %rax,%rdi
  800d9a:	48 b8 e8 05 80 00 00 	movabs $0x8005e8,%rax
  800da1:	00 00 00 
  800da4:	ff d0                	callq  *%rax
			break;
  800da6:	eb 3f                	jmp    800de7 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800da8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dac:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800db0:	48 89 c6             	mov    %rax,%rsi
  800db3:	89 df                	mov    %ebx,%edi
  800db5:	ff d2                	callq  *%rdx
			break;
  800db7:	eb 2e                	jmp    800de7 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800db9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dbd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dc1:	48 89 c6             	mov    %rax,%rsi
  800dc4:	bf 25 00 00 00       	mov    $0x25,%edi
  800dc9:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dcb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd0:	eb 05                	jmp    800dd7 <vprintfmt+0x517>
  800dd2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ddb:	48 83 e8 01          	sub    $0x1,%rax
  800ddf:	0f b6 00             	movzbl (%rax),%eax
  800de2:	3c 25                	cmp    $0x25,%al
  800de4:	75 ec                	jne    800dd2 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800de6:	90                   	nop
		}
	}
  800de7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800de8:	e9 25 fb ff ff       	jmpq   800912 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800ded:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dee:	48 83 c4 60          	add    $0x60,%rsp
  800df2:	5b                   	pop    %rbx
  800df3:	41 5c                	pop    %r12
  800df5:	5d                   	pop    %rbp
  800df6:	c3                   	retq   

0000000000800df7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800df7:	55                   	push   %rbp
  800df8:	48 89 e5             	mov    %rsp,%rbp
  800dfb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e02:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e09:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e10:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e17:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e1e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e25:	84 c0                	test   %al,%al
  800e27:	74 20                	je     800e49 <printfmt+0x52>
  800e29:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e2d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e31:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e35:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e39:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e3d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e41:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e45:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e49:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e50:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e57:	00 00 00 
  800e5a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e61:	00 00 00 
  800e64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e68:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e6f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e76:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e7d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e84:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e8b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e92:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e99:	48 89 c7             	mov    %rax,%rdi
  800e9c:	48 b8 c0 08 80 00 00 	movabs $0x8008c0,%rax
  800ea3:	00 00 00 
  800ea6:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ea8:	c9                   	leaveq 
  800ea9:	c3                   	retq   

0000000000800eaa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eaa:	55                   	push   %rbp
  800eab:	48 89 e5             	mov    %rsp,%rbp
  800eae:	48 83 ec 10          	sub    $0x10,%rsp
  800eb2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eb5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800eb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ebd:	8b 40 10             	mov    0x10(%rax),%eax
  800ec0:	8d 50 01             	lea    0x1(%rax),%edx
  800ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ece:	48 8b 10             	mov    (%rax),%rdx
  800ed1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed5:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ed9:	48 39 c2             	cmp    %rax,%rdx
  800edc:	73 17                	jae    800ef5 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ede:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee2:	48 8b 00             	mov    (%rax),%rax
  800ee5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ee8:	88 10                	mov    %dl,(%rax)
  800eea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef2:	48 89 10             	mov    %rdx,(%rax)
}
  800ef5:	c9                   	leaveq 
  800ef6:	c3                   	retq   

0000000000800ef7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ef7:	55                   	push   %rbp
  800ef8:	48 89 e5             	mov    %rsp,%rbp
  800efb:	48 83 ec 50          	sub    $0x50,%rsp
  800eff:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f03:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f06:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f0a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f0e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f12:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f16:	48 8b 0a             	mov    (%rdx),%rcx
  800f19:	48 89 08             	mov    %rcx,(%rax)
  800f1c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f20:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f24:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f28:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f30:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f34:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f37:	48 98                	cltq   
  800f39:	48 83 e8 01          	sub    $0x1,%rax
  800f3d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800f41:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f45:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f4c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f51:	74 06                	je     800f59 <vsnprintf+0x62>
  800f53:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f57:	7f 07                	jg     800f60 <vsnprintf+0x69>
		return -E_INVAL;
  800f59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5e:	eb 2f                	jmp    800f8f <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f60:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f64:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f68:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f6c:	48 89 c6             	mov    %rax,%rsi
  800f6f:	48 bf aa 0e 80 00 00 	movabs $0x800eaa,%rdi
  800f76:	00 00 00 
  800f79:	48 b8 c0 08 80 00 00 	movabs $0x8008c0,%rax
  800f80:	00 00 00 
  800f83:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f89:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f8c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f8f:	c9                   	leaveq 
  800f90:	c3                   	retq   

0000000000800f91 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f91:	55                   	push   %rbp
  800f92:	48 89 e5             	mov    %rsp,%rbp
  800f95:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f9c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fa3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fa9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fb0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fb7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fbe:	84 c0                	test   %al,%al
  800fc0:	74 20                	je     800fe2 <snprintf+0x51>
  800fc2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fc6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fca:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fce:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fd2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fd6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fda:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fde:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fe2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fe9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ff0:	00 00 00 
  800ff3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ffa:	00 00 00 
  800ffd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801001:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801008:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80100f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801016:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80101d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801024:	48 8b 0a             	mov    (%rdx),%rcx
  801027:	48 89 08             	mov    %rcx,(%rax)
  80102a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80102e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801032:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801036:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80103a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801041:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801048:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80104e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801055:	48 89 c7             	mov    %rax,%rdi
  801058:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  80105f:	00 00 00 
  801062:	ff d0                	callq  *%rax
  801064:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80106a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801070:	c9                   	leaveq 
  801071:	c3                   	retq   
	...

0000000000801074 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801074:	55                   	push   %rbp
  801075:	48 89 e5             	mov    %rsp,%rbp
  801078:	48 83 ec 18          	sub    $0x18,%rsp
  80107c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801080:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801087:	eb 09                	jmp    801092 <strlen+0x1e>
		n++;
  801089:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80108d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801096:	0f b6 00             	movzbl (%rax),%eax
  801099:	84 c0                	test   %al,%al
  80109b:	75 ec                	jne    801089 <strlen+0x15>
		n++;
	return n;
  80109d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a0:	c9                   	leaveq 
  8010a1:	c3                   	retq   

00000000008010a2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010a2:	55                   	push   %rbp
  8010a3:	48 89 e5             	mov    %rsp,%rbp
  8010a6:	48 83 ec 20          	sub    $0x20,%rsp
  8010aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010b9:	eb 0e                	jmp    8010c9 <strnlen+0x27>
		n++;
  8010bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010c4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010c9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010ce:	74 0b                	je     8010db <strnlen+0x39>
  8010d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d4:	0f b6 00             	movzbl (%rax),%eax
  8010d7:	84 c0                	test   %al,%al
  8010d9:	75 e0                	jne    8010bb <strnlen+0x19>
		n++;
	return n;
  8010db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010de:	c9                   	leaveq 
  8010df:	c3                   	retq   

00000000008010e0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010e0:	55                   	push   %rbp
  8010e1:	48 89 e5             	mov    %rsp,%rbp
  8010e4:	48 83 ec 20          	sub    $0x20,%rsp
  8010e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010f8:	90                   	nop
  8010f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010fd:	0f b6 10             	movzbl (%rax),%edx
  801100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801104:	88 10                	mov    %dl,(%rax)
  801106:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110a:	0f b6 00             	movzbl (%rax),%eax
  80110d:	84 c0                	test   %al,%al
  80110f:	0f 95 c0             	setne  %al
  801112:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801117:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80111c:	84 c0                	test   %al,%al
  80111e:	75 d9                	jne    8010f9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801124:	c9                   	leaveq 
  801125:	c3                   	retq   

0000000000801126 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801126:	55                   	push   %rbp
  801127:	48 89 e5             	mov    %rsp,%rbp
  80112a:	48 83 ec 20          	sub    $0x20,%rsp
  80112e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801132:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113a:	48 89 c7             	mov    %rax,%rdi
  80113d:	48 b8 74 10 80 00 00 	movabs $0x801074,%rax
  801144:	00 00 00 
  801147:	ff d0                	callq  *%rax
  801149:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80114c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80114f:	48 98                	cltq   
  801151:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801155:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801159:	48 89 d6             	mov    %rdx,%rsi
  80115c:	48 89 c7             	mov    %rax,%rdi
  80115f:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  801166:	00 00 00 
  801169:	ff d0                	callq  *%rax
	return dst;
  80116b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80116f:	c9                   	leaveq 
  801170:	c3                   	retq   

0000000000801171 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801171:	55                   	push   %rbp
  801172:	48 89 e5             	mov    %rsp,%rbp
  801175:	48 83 ec 28          	sub    $0x28,%rsp
  801179:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801181:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801189:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80118d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801194:	00 
  801195:	eb 27                	jmp    8011be <strncpy+0x4d>
		*dst++ = *src;
  801197:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80119b:	0f b6 10             	movzbl (%rax),%edx
  80119e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a2:	88 10                	mov    %dl,(%rax)
  8011a4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ad:	0f b6 00             	movzbl (%rax),%eax
  8011b0:	84 c0                	test   %al,%al
  8011b2:	74 05                	je     8011b9 <strncpy+0x48>
			src++;
  8011b4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011c6:	72 cf                	jb     801197 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011cc:	c9                   	leaveq 
  8011cd:	c3                   	retq   

00000000008011ce <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011ce:	55                   	push   %rbp
  8011cf:	48 89 e5             	mov    %rsp,%rbp
  8011d2:	48 83 ec 28          	sub    $0x28,%rsp
  8011d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011ea:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ef:	74 37                	je     801228 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8011f1:	eb 17                	jmp    80120a <strlcpy+0x3c>
			*dst++ = *src++;
  8011f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f7:	0f b6 10             	movzbl (%rax),%edx
  8011fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fe:	88 10                	mov    %dl,(%rax)
  801200:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801205:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80120a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80120f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801214:	74 0b                	je     801221 <strlcpy+0x53>
  801216:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80121a:	0f b6 00             	movzbl (%rax),%eax
  80121d:	84 c0                	test   %al,%al
  80121f:	75 d2                	jne    8011f3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801221:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801225:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801228:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80122c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801230:	48 89 d1             	mov    %rdx,%rcx
  801233:	48 29 c1             	sub    %rax,%rcx
  801236:	48 89 c8             	mov    %rcx,%rax
}
  801239:	c9                   	leaveq 
  80123a:	c3                   	retq   

000000000080123b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80123b:	55                   	push   %rbp
  80123c:	48 89 e5             	mov    %rsp,%rbp
  80123f:	48 83 ec 10          	sub    $0x10,%rsp
  801243:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801247:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80124b:	eb 0a                	jmp    801257 <strcmp+0x1c>
		p++, q++;
  80124d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801252:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801257:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125b:	0f b6 00             	movzbl (%rax),%eax
  80125e:	84 c0                	test   %al,%al
  801260:	74 12                	je     801274 <strcmp+0x39>
  801262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801266:	0f b6 10             	movzbl (%rax),%edx
  801269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126d:	0f b6 00             	movzbl (%rax),%eax
  801270:	38 c2                	cmp    %al,%dl
  801272:	74 d9                	je     80124d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801278:	0f b6 00             	movzbl (%rax),%eax
  80127b:	0f b6 d0             	movzbl %al,%edx
  80127e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801282:	0f b6 00             	movzbl (%rax),%eax
  801285:	0f b6 c0             	movzbl %al,%eax
  801288:	89 d1                	mov    %edx,%ecx
  80128a:	29 c1                	sub    %eax,%ecx
  80128c:	89 c8                	mov    %ecx,%eax
}
  80128e:	c9                   	leaveq 
  80128f:	c3                   	retq   

0000000000801290 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801290:	55                   	push   %rbp
  801291:	48 89 e5             	mov    %rsp,%rbp
  801294:	48 83 ec 18          	sub    $0x18,%rsp
  801298:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012a4:	eb 0f                	jmp    8012b5 <strncmp+0x25>
		n--, p++, q++;
  8012a6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ba:	74 1d                	je     8012d9 <strncmp+0x49>
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	0f b6 00             	movzbl (%rax),%eax
  8012c3:	84 c0                	test   %al,%al
  8012c5:	74 12                	je     8012d9 <strncmp+0x49>
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	0f b6 10             	movzbl (%rax),%edx
  8012ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d2:	0f b6 00             	movzbl (%rax),%eax
  8012d5:	38 c2                	cmp    %al,%dl
  8012d7:	74 cd                	je     8012a6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012de:	75 07                	jne    8012e7 <strncmp+0x57>
		return 0;
  8012e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e5:	eb 1a                	jmp    801301 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012eb:	0f b6 00             	movzbl (%rax),%eax
  8012ee:	0f b6 d0             	movzbl %al,%edx
  8012f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	0f b6 c0             	movzbl %al,%eax
  8012fb:	89 d1                	mov    %edx,%ecx
  8012fd:	29 c1                	sub    %eax,%ecx
  8012ff:	89 c8                	mov    %ecx,%eax
}
  801301:	c9                   	leaveq 
  801302:	c3                   	retq   

0000000000801303 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801303:	55                   	push   %rbp
  801304:	48 89 e5             	mov    %rsp,%rbp
  801307:	48 83 ec 10          	sub    $0x10,%rsp
  80130b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130f:	89 f0                	mov    %esi,%eax
  801311:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801314:	eb 17                	jmp    80132d <strchr+0x2a>
		if (*s == c)
  801316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131a:	0f b6 00             	movzbl (%rax),%eax
  80131d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801320:	75 06                	jne    801328 <strchr+0x25>
			return (char *) s;
  801322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801326:	eb 15                	jmp    80133d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801328:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801331:	0f b6 00             	movzbl (%rax),%eax
  801334:	84 c0                	test   %al,%al
  801336:	75 de                	jne    801316 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leaveq 
  80133e:	c3                   	retq   

000000000080133f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80133f:	55                   	push   %rbp
  801340:	48 89 e5             	mov    %rsp,%rbp
  801343:	48 83 ec 10          	sub    $0x10,%rsp
  801347:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134b:	89 f0                	mov    %esi,%eax
  80134d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801350:	eb 11                	jmp    801363 <strfind+0x24>
		if (*s == c)
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80135c:	74 12                	je     801370 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80135e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801367:	0f b6 00             	movzbl (%rax),%eax
  80136a:	84 c0                	test   %al,%al
  80136c:	75 e4                	jne    801352 <strfind+0x13>
  80136e:	eb 01                	jmp    801371 <strfind+0x32>
		if (*s == c)
			break;
  801370:	90                   	nop
	return (char *) s;
  801371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801375:	c9                   	leaveq 
  801376:	c3                   	retq   

0000000000801377 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801377:	55                   	push   %rbp
  801378:	48 89 e5             	mov    %rsp,%rbp
  80137b:	48 83 ec 18          	sub    $0x18,%rsp
  80137f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801383:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801386:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80138a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80138f:	75 06                	jne    801397 <memset+0x20>
		return v;
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801395:	eb 69                	jmp    801400 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139b:	83 e0 03             	and    $0x3,%eax
  80139e:	48 85 c0             	test   %rax,%rax
  8013a1:	75 48                	jne    8013eb <memset+0x74>
  8013a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a7:	83 e0 03             	and    $0x3,%eax
  8013aa:	48 85 c0             	test   %rax,%rax
  8013ad:	75 3c                	jne    8013eb <memset+0x74>
		c &= 0xFF;
  8013af:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b9:	89 c2                	mov    %eax,%edx
  8013bb:	c1 e2 18             	shl    $0x18,%edx
  8013be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c1:	c1 e0 10             	shl    $0x10,%eax
  8013c4:	09 c2                	or     %eax,%edx
  8013c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c9:	c1 e0 08             	shl    $0x8,%eax
  8013cc:	09 d0                	or     %edx,%eax
  8013ce:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d5:	48 89 c1             	mov    %rax,%rcx
  8013d8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e3:	48 89 d7             	mov    %rdx,%rdi
  8013e6:	fc                   	cld    
  8013e7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013e9:	eb 11                	jmp    8013fc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013f6:	48 89 d7             	mov    %rdx,%rdi
  8013f9:	fc                   	cld    
  8013fa:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801400:	c9                   	leaveq 
  801401:	c3                   	retq   

0000000000801402 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801402:	55                   	push   %rbp
  801403:	48 89 e5             	mov    %rsp,%rbp
  801406:	48 83 ec 28          	sub    $0x28,%rsp
  80140a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801412:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801416:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80141e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801422:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80142e:	0f 83 88 00 00 00    	jae    8014bc <memmove+0xba>
  801434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801438:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143c:	48 01 d0             	add    %rdx,%rax
  80143f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801443:	76 77                	jbe    8014bc <memmove+0xba>
		s += n;
  801445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801449:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80144d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801451:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801459:	83 e0 03             	and    $0x3,%eax
  80145c:	48 85 c0             	test   %rax,%rax
  80145f:	75 3b                	jne    80149c <memmove+0x9a>
  801461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801465:	83 e0 03             	and    $0x3,%eax
  801468:	48 85 c0             	test   %rax,%rax
  80146b:	75 2f                	jne    80149c <memmove+0x9a>
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	83 e0 03             	and    $0x3,%eax
  801474:	48 85 c0             	test   %rax,%rax
  801477:	75 23                	jne    80149c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147d:	48 83 e8 04          	sub    $0x4,%rax
  801481:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801485:	48 83 ea 04          	sub    $0x4,%rdx
  801489:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80148d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801491:	48 89 c7             	mov    %rax,%rdi
  801494:	48 89 d6             	mov    %rdx,%rsi
  801497:	fd                   	std    
  801498:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80149a:	eb 1d                	jmp    8014b9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80149c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b0:	48 89 d7             	mov    %rdx,%rdi
  8014b3:	48 89 c1             	mov    %rax,%rcx
  8014b6:	fd                   	std    
  8014b7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014b9:	fc                   	cld    
  8014ba:	eb 57                	jmp    801513 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	83 e0 03             	and    $0x3,%eax
  8014c3:	48 85 c0             	test   %rax,%rax
  8014c6:	75 36                	jne    8014fe <memmove+0xfc>
  8014c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cc:	83 e0 03             	and    $0x3,%eax
  8014cf:	48 85 c0             	test   %rax,%rax
  8014d2:	75 2a                	jne    8014fe <memmove+0xfc>
  8014d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d8:	83 e0 03             	and    $0x3,%eax
  8014db:	48 85 c0             	test   %rax,%rax
  8014de:	75 1e                	jne    8014fe <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e4:	48 89 c1             	mov    %rax,%rcx
  8014e7:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f3:	48 89 c7             	mov    %rax,%rdi
  8014f6:	48 89 d6             	mov    %rdx,%rsi
  8014f9:	fc                   	cld    
  8014fa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014fc:	eb 15                	jmp    801513 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801502:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801506:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80150a:	48 89 c7             	mov    %rax,%rdi
  80150d:	48 89 d6             	mov    %rdx,%rsi
  801510:	fc                   	cld    
  801511:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801517:	c9                   	leaveq 
  801518:	c3                   	retq   

0000000000801519 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801519:	55                   	push   %rbp
  80151a:	48 89 e5             	mov    %rsp,%rbp
  80151d:	48 83 ec 18          	sub    $0x18,%rsp
  801521:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801525:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801529:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80152d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801531:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801539:	48 89 ce             	mov    %rcx,%rsi
  80153c:	48 89 c7             	mov    %rax,%rdi
  80153f:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  801546:	00 00 00 
  801549:	ff d0                	callq  *%rax
}
  80154b:	c9                   	leaveq 
  80154c:	c3                   	retq   

000000000080154d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80154d:	55                   	push   %rbp
  80154e:	48 89 e5             	mov    %rsp,%rbp
  801551:	48 83 ec 28          	sub    $0x28,%rsp
  801555:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801559:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80155d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801565:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801569:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801571:	eb 38                	jmp    8015ab <memcmp+0x5e>
		if (*s1 != *s2)
  801573:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801577:	0f b6 10             	movzbl (%rax),%edx
  80157a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157e:	0f b6 00             	movzbl (%rax),%eax
  801581:	38 c2                	cmp    %al,%dl
  801583:	74 1c                	je     8015a1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801585:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801589:	0f b6 00             	movzbl (%rax),%eax
  80158c:	0f b6 d0             	movzbl %al,%edx
  80158f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801593:	0f b6 00             	movzbl (%rax),%eax
  801596:	0f b6 c0             	movzbl %al,%eax
  801599:	89 d1                	mov    %edx,%ecx
  80159b:	29 c1                	sub    %eax,%ecx
  80159d:	89 c8                	mov    %ecx,%eax
  80159f:	eb 20                	jmp    8015c1 <memcmp+0x74>
		s1++, s2++;
  8015a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015ab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015b0:	0f 95 c0             	setne  %al
  8015b3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015b8:	84 c0                	test   %al,%al
  8015ba:	75 b7                	jne    801573 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c1:	c9                   	leaveq 
  8015c2:	c3                   	retq   

00000000008015c3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015c3:	55                   	push   %rbp
  8015c4:	48 89 e5             	mov    %rsp,%rbp
  8015c7:	48 83 ec 28          	sub    $0x28,%rsp
  8015cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015de:	48 01 d0             	add    %rdx,%rax
  8015e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015e5:	eb 13                	jmp    8015fa <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015eb:	0f b6 10             	movzbl (%rax),%edx
  8015ee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015f1:	38 c2                	cmp    %al,%dl
  8015f3:	74 11                	je     801606 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015f5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fe:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801602:	72 e3                	jb     8015e7 <memfind+0x24>
  801604:	eb 01                	jmp    801607 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801606:	90                   	nop
	return (void *) s;
  801607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80160b:	c9                   	leaveq 
  80160c:	c3                   	retq   

000000000080160d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80160d:	55                   	push   %rbp
  80160e:	48 89 e5             	mov    %rsp,%rbp
  801611:	48 83 ec 38          	sub    $0x38,%rsp
  801615:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801619:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80161d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801620:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801627:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80162e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80162f:	eb 05                	jmp    801636 <strtol+0x29>
		s++;
  801631:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163a:	0f b6 00             	movzbl (%rax),%eax
  80163d:	3c 20                	cmp    $0x20,%al
  80163f:	74 f0                	je     801631 <strtol+0x24>
  801641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801645:	0f b6 00             	movzbl (%rax),%eax
  801648:	3c 09                	cmp    $0x9,%al
  80164a:	74 e5                	je     801631 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80164c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801650:	0f b6 00             	movzbl (%rax),%eax
  801653:	3c 2b                	cmp    $0x2b,%al
  801655:	75 07                	jne    80165e <strtol+0x51>
		s++;
  801657:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80165c:	eb 17                	jmp    801675 <strtol+0x68>
	else if (*s == '-')
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 2d                	cmp    $0x2d,%al
  801667:	75 0c                	jne    801675 <strtol+0x68>
		s++, neg = 1;
  801669:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80166e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801675:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801679:	74 06                	je     801681 <strtol+0x74>
  80167b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80167f:	75 28                	jne    8016a9 <strtol+0x9c>
  801681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801685:	0f b6 00             	movzbl (%rax),%eax
  801688:	3c 30                	cmp    $0x30,%al
  80168a:	75 1d                	jne    8016a9 <strtol+0x9c>
  80168c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801690:	48 83 c0 01          	add    $0x1,%rax
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	3c 78                	cmp    $0x78,%al
  801699:	75 0e                	jne    8016a9 <strtol+0x9c>
		s += 2, base = 16;
  80169b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016a0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016a7:	eb 2c                	jmp    8016d5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ad:	75 19                	jne    8016c8 <strtol+0xbb>
  8016af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b3:	0f b6 00             	movzbl (%rax),%eax
  8016b6:	3c 30                	cmp    $0x30,%al
  8016b8:	75 0e                	jne    8016c8 <strtol+0xbb>
		s++, base = 8;
  8016ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016bf:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016c6:	eb 0d                	jmp    8016d5 <strtol+0xc8>
	else if (base == 0)
  8016c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016cc:	75 07                	jne    8016d5 <strtol+0xc8>
		base = 10;
  8016ce:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d9:	0f b6 00             	movzbl (%rax),%eax
  8016dc:	3c 2f                	cmp    $0x2f,%al
  8016de:	7e 1d                	jle    8016fd <strtol+0xf0>
  8016e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e4:	0f b6 00             	movzbl (%rax),%eax
  8016e7:	3c 39                	cmp    $0x39,%al
  8016e9:	7f 12                	jg     8016fd <strtol+0xf0>
			dig = *s - '0';
  8016eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ef:	0f b6 00             	movzbl (%rax),%eax
  8016f2:	0f be c0             	movsbl %al,%eax
  8016f5:	83 e8 30             	sub    $0x30,%eax
  8016f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016fb:	eb 4e                	jmp    80174b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	3c 60                	cmp    $0x60,%al
  801706:	7e 1d                	jle    801725 <strtol+0x118>
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	0f b6 00             	movzbl (%rax),%eax
  80170f:	3c 7a                	cmp    $0x7a,%al
  801711:	7f 12                	jg     801725 <strtol+0x118>
			dig = *s - 'a' + 10;
  801713:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801717:	0f b6 00             	movzbl (%rax),%eax
  80171a:	0f be c0             	movsbl %al,%eax
  80171d:	83 e8 57             	sub    $0x57,%eax
  801720:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801723:	eb 26                	jmp    80174b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801729:	0f b6 00             	movzbl (%rax),%eax
  80172c:	3c 40                	cmp    $0x40,%al
  80172e:	7e 47                	jle    801777 <strtol+0x16a>
  801730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	3c 5a                	cmp    $0x5a,%al
  801739:	7f 3c                	jg     801777 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80173b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173f:	0f b6 00             	movzbl (%rax),%eax
  801742:	0f be c0             	movsbl %al,%eax
  801745:	83 e8 37             	sub    $0x37,%eax
  801748:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80174b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80174e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801751:	7d 23                	jge    801776 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801753:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801758:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80175b:	48 98                	cltq   
  80175d:	48 89 c2             	mov    %rax,%rdx
  801760:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801765:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801768:	48 98                	cltq   
  80176a:	48 01 d0             	add    %rdx,%rax
  80176d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801771:	e9 5f ff ff ff       	jmpq   8016d5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801776:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801777:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80177c:	74 0b                	je     801789 <strtol+0x17c>
		*endptr = (char *) s;
  80177e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801782:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801786:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801789:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80178d:	74 09                	je     801798 <strtol+0x18b>
  80178f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801793:	48 f7 d8             	neg    %rax
  801796:	eb 04                	jmp    80179c <strtol+0x18f>
  801798:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80179c:	c9                   	leaveq 
  80179d:	c3                   	retq   

000000000080179e <strstr>:

char * strstr(const char *in, const char *str)
{
  80179e:	55                   	push   %rbp
  80179f:	48 89 e5             	mov    %rsp,%rbp
  8017a2:	48 83 ec 30          	sub    $0x30,%rsp
  8017a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b2:	0f b6 00             	movzbl (%rax),%eax
  8017b5:	88 45 ff             	mov    %al,-0x1(%rbp)
  8017b8:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  8017bd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017c1:	75 06                	jne    8017c9 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	eb 68                	jmp    801831 <strstr+0x93>

	len = strlen(str);
  8017c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017cd:	48 89 c7             	mov    %rax,%rdi
  8017d0:	48 b8 74 10 80 00 00 	movabs $0x801074,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
  8017dc:	48 98                	cltq   
  8017de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	0f b6 00             	movzbl (%rax),%eax
  8017e9:	88 45 ef             	mov    %al,-0x11(%rbp)
  8017ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  8017f1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017f5:	75 07                	jne    8017fe <strstr+0x60>
				return (char *) 0;
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fc:	eb 33                	jmp    801831 <strstr+0x93>
		} while (sc != c);
  8017fe:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801802:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801805:	75 db                	jne    8017e2 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801807:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80180b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80180f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801813:	48 89 ce             	mov    %rcx,%rsi
  801816:	48 89 c7             	mov    %rax,%rdi
  801819:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  801820:	00 00 00 
  801823:	ff d0                	callq  *%rax
  801825:	85 c0                	test   %eax,%eax
  801827:	75 b9                	jne    8017e2 <strstr+0x44>

	return (char *) (in - 1);
  801829:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182d:	48 83 e8 01          	sub    $0x1,%rax
}
  801831:	c9                   	leaveq 
  801832:	c3                   	retq   
	...

0000000000801834 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801834:	55                   	push   %rbp
  801835:	48 89 e5             	mov    %rsp,%rbp
  801838:	53                   	push   %rbx
  801839:	48 83 ec 58          	sub    $0x58,%rsp
  80183d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801840:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801843:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801847:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80184b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80184f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801853:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801856:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801859:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80185d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801861:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801865:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801869:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80186d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801870:	4c 89 c3             	mov    %r8,%rbx
  801873:	cd 30                	int    $0x30
  801875:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801879:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80187d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801881:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801885:	74 3e                	je     8018c5 <syscall+0x91>
  801887:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80188c:	7e 37                	jle    8018c5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80188e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801892:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801895:	49 89 d0             	mov    %rdx,%r8
  801898:	89 c1                	mov    %eax,%ecx
  80189a:	48 ba 68 48 80 00 00 	movabs $0x804868,%rdx
  8018a1:	00 00 00 
  8018a4:	be 23 00 00 00       	mov    $0x23,%esi
  8018a9:	48 bf 85 48 80 00 00 	movabs $0x804885,%rdi
  8018b0:	00 00 00 
  8018b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b8:	49 b9 18 3a 80 00 00 	movabs $0x803a18,%r9
  8018bf:	00 00 00 
  8018c2:	41 ff d1             	callq  *%r9

	return ret;
  8018c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018c9:	48 83 c4 58          	add    $0x58,%rsp
  8018cd:	5b                   	pop    %rbx
  8018ce:	5d                   	pop    %rbp
  8018cf:	c3                   	retq   

00000000008018d0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018d0:	55                   	push   %rbp
  8018d1:	48 89 e5             	mov    %rsp,%rbp
  8018d4:	48 83 ec 20          	sub    $0x20,%rsp
  8018d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ef:	00 
  8018f0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018fc:	48 89 d1             	mov    %rdx,%rcx
  8018ff:	48 89 c2             	mov    %rax,%rdx
  801902:	be 00 00 00 00       	mov    $0x0,%esi
  801907:	bf 00 00 00 00       	mov    $0x0,%edi
  80190c:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801913:	00 00 00 
  801916:	ff d0                	callq  *%rax
}
  801918:	c9                   	leaveq 
  801919:	c3                   	retq   

000000000080191a <sys_cgetc>:

int
sys_cgetc(void)
{
  80191a:	55                   	push   %rbp
  80191b:	48 89 e5             	mov    %rsp,%rbp
  80191e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801922:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801929:	00 
  80192a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801930:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801936:	b9 00 00 00 00       	mov    $0x0,%ecx
  80193b:	ba 00 00 00 00       	mov    $0x0,%edx
  801940:	be 00 00 00 00       	mov    $0x0,%esi
  801945:	bf 01 00 00 00       	mov    $0x1,%edi
  80194a:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801951:	00 00 00 
  801954:	ff d0                	callq  *%rax
}
  801956:	c9                   	leaveq 
  801957:	c3                   	retq   

0000000000801958 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801958:	55                   	push   %rbp
  801959:	48 89 e5             	mov    %rsp,%rbp
  80195c:	48 83 ec 20          	sub    $0x20,%rsp
  801960:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801966:	48 98                	cltq   
  801968:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196f:	00 
  801970:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801976:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801981:	48 89 c2             	mov    %rax,%rdx
  801984:	be 01 00 00 00       	mov    $0x1,%esi
  801989:	bf 03 00 00 00       	mov    $0x3,%edi
  80198e:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801995:	00 00 00 
  801998:	ff d0                	callq  *%rax
}
  80199a:	c9                   	leaveq 
  80199b:	c3                   	retq   

000000000080199c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80199c:	55                   	push   %rbp
  80199d:	48 89 e5             	mov    %rsp,%rbp
  8019a0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019a4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ab:	00 
  8019ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c2:	be 00 00 00 00       	mov    $0x0,%esi
  8019c7:	bf 02 00 00 00       	mov    $0x2,%edi
  8019cc:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  8019d3:	00 00 00 
  8019d6:	ff d0                	callq  *%rax
}
  8019d8:	c9                   	leaveq 
  8019d9:	c3                   	retq   

00000000008019da <sys_yield>:

void
sys_yield(void)
{
  8019da:	55                   	push   %rbp
  8019db:	48 89 e5             	mov    %rsp,%rbp
  8019de:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019e2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e9:	00 
  8019ea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801a00:	be 00 00 00 00       	mov    $0x0,%esi
  801a05:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a0a:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801a11:	00 00 00 
  801a14:	ff d0                	callq  *%rax
}
  801a16:	c9                   	leaveq 
  801a17:	c3                   	retq   

0000000000801a18 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a18:	55                   	push   %rbp
  801a19:	48 89 e5             	mov    %rsp,%rbp
  801a1c:	48 83 ec 20          	sub    $0x20,%rsp
  801a20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a27:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a2d:	48 63 c8             	movslq %eax,%rcx
  801a30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a37:	48 98                	cltq   
  801a39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a40:	00 
  801a41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a47:	49 89 c8             	mov    %rcx,%r8
  801a4a:	48 89 d1             	mov    %rdx,%rcx
  801a4d:	48 89 c2             	mov    %rax,%rdx
  801a50:	be 01 00 00 00       	mov    $0x1,%esi
  801a55:	bf 04 00 00 00       	mov    $0x4,%edi
  801a5a:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801a61:	00 00 00 
  801a64:	ff d0                	callq  *%rax
}
  801a66:	c9                   	leaveq 
  801a67:	c3                   	retq   

0000000000801a68 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a68:	55                   	push   %rbp
  801a69:	48 89 e5             	mov    %rsp,%rbp
  801a6c:	48 83 ec 30          	sub    $0x30,%rsp
  801a70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a77:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a7a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a7e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a82:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a85:	48 63 c8             	movslq %eax,%rcx
  801a88:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a8f:	48 63 f0             	movslq %eax,%rsi
  801a92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a99:	48 98                	cltq   
  801a9b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a9f:	49 89 f9             	mov    %rdi,%r9
  801aa2:	49 89 f0             	mov    %rsi,%r8
  801aa5:	48 89 d1             	mov    %rdx,%rcx
  801aa8:	48 89 c2             	mov    %rax,%rdx
  801aab:	be 01 00 00 00       	mov    $0x1,%esi
  801ab0:	bf 05 00 00 00       	mov    $0x5,%edi
  801ab5:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801abc:	00 00 00 
  801abf:	ff d0                	callq  *%rax
}
  801ac1:	c9                   	leaveq 
  801ac2:	c3                   	retq   

0000000000801ac3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	48 83 ec 20          	sub    $0x20,%rsp
  801acb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ace:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ad2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad9:	48 98                	cltq   
  801adb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae2:	00 
  801ae3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aef:	48 89 d1             	mov    %rdx,%rcx
  801af2:	48 89 c2             	mov    %rax,%rdx
  801af5:	be 01 00 00 00       	mov    $0x1,%esi
  801afa:	bf 06 00 00 00       	mov    $0x6,%edi
  801aff:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801b06:	00 00 00 
  801b09:	ff d0                	callq  *%rax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 20          	sub    $0x20,%rsp
  801b15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b18:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1e:	48 63 d0             	movslq %eax,%rdx
  801b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b24:	48 98                	cltq   
  801b26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2d:	00 
  801b2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3a:	48 89 d1             	mov    %rdx,%rcx
  801b3d:	48 89 c2             	mov    %rax,%rdx
  801b40:	be 01 00 00 00       	mov    $0x1,%esi
  801b45:	bf 08 00 00 00       	mov    $0x8,%edi
  801b4a:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801b51:	00 00 00 
  801b54:	ff d0                	callq  *%rax
}
  801b56:	c9                   	leaveq 
  801b57:	c3                   	retq   

0000000000801b58 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b58:	55                   	push   %rbp
  801b59:	48 89 e5             	mov    %rsp,%rbp
  801b5c:	48 83 ec 20          	sub    $0x20,%rsp
  801b60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6e:	48 98                	cltq   
  801b70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b77:	00 
  801b78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b84:	48 89 d1             	mov    %rdx,%rcx
  801b87:	48 89 c2             	mov    %rax,%rdx
  801b8a:	be 01 00 00 00       	mov    $0x1,%esi
  801b8f:	bf 09 00 00 00       	mov    $0x9,%edi
  801b94:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801b9b:	00 00 00 
  801b9e:	ff d0                	callq  *%rax
}
  801ba0:	c9                   	leaveq 
  801ba1:	c3                   	retq   

0000000000801ba2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ba2:	55                   	push   %rbp
  801ba3:	48 89 e5             	mov    %rsp,%rbp
  801ba6:	48 83 ec 20          	sub    $0x20,%rsp
  801baa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bb1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb8:	48 98                	cltq   
  801bba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc1:	00 
  801bc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bce:	48 89 d1             	mov    %rdx,%rcx
  801bd1:	48 89 c2             	mov    %rax,%rdx
  801bd4:	be 01 00 00 00       	mov    $0x1,%esi
  801bd9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bde:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801be5:	00 00 00 
  801be8:	ff d0                	callq  *%rax
}
  801bea:	c9                   	leaveq 
  801beb:	c3                   	retq   

0000000000801bec <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bec:	55                   	push   %rbp
  801bed:	48 89 e5             	mov    %rsp,%rbp
  801bf0:	48 83 ec 30          	sub    $0x30,%rsp
  801bf4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bfb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bff:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c05:	48 63 f0             	movslq %eax,%rsi
  801c08:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0f:	48 98                	cltq   
  801c11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1c:	00 
  801c1d:	49 89 f1             	mov    %rsi,%r9
  801c20:	49 89 c8             	mov    %rcx,%r8
  801c23:	48 89 d1             	mov    %rdx,%rcx
  801c26:	48 89 c2             	mov    %rax,%rdx
  801c29:	be 00 00 00 00       	mov    $0x0,%esi
  801c2e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c33:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801c3a:	00 00 00 
  801c3d:	ff d0                	callq  *%rax
}
  801c3f:	c9                   	leaveq 
  801c40:	c3                   	retq   

0000000000801c41 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c41:	55                   	push   %rbp
  801c42:	48 89 e5             	mov    %rsp,%rbp
  801c45:	48 83 ec 20          	sub    $0x20,%rsp
  801c49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c58:	00 
  801c59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c65:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6a:	48 89 c2             	mov    %rax,%rdx
  801c6d:	be 01 00 00 00       	mov    $0x1,%esi
  801c72:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c77:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801c7e:	00 00 00 
  801c81:	ff d0                	callq  *%rax
}
  801c83:	c9                   	leaveq 
  801c84:	c3                   	retq   

0000000000801c85 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c85:	55                   	push   %rbp
  801c86:	48 89 e5             	mov    %rsp,%rbp
  801c89:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c94:	00 
  801c95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cab:	be 00 00 00 00       	mov    $0x0,%esi
  801cb0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cb5:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	callq  *%rax
}
  801cc1:	c9                   	leaveq 
  801cc2:	c3                   	retq   

0000000000801cc3 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801cc3:	55                   	push   %rbp
  801cc4:	48 89 e5             	mov    %rsp,%rbp
  801cc7:	48 83 ec 30          	sub    $0x30,%rsp
  801ccb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cd2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cd5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cd9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801cdd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ce0:	48 63 c8             	movslq %eax,%rcx
  801ce3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ce7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cea:	48 63 f0             	movslq %eax,%rsi
  801ced:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf4:	48 98                	cltq   
  801cf6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801cfa:	49 89 f9             	mov    %rdi,%r9
  801cfd:	49 89 f0             	mov    %rsi,%r8
  801d00:	48 89 d1             	mov    %rdx,%rcx
  801d03:	48 89 c2             	mov    %rax,%rdx
  801d06:	be 00 00 00 00       	mov    $0x0,%esi
  801d0b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d10:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801d17:	00 00 00 
  801d1a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d1c:	c9                   	leaveq 
  801d1d:	c3                   	retq   

0000000000801d1e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d1e:	55                   	push   %rbp
  801d1f:	48 89 e5             	mov    %rsp,%rbp
  801d22:	48 83 ec 20          	sub    $0x20,%rsp
  801d26:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3d:	00 
  801d3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d4a:	48 89 d1             	mov    %rdx,%rcx
  801d4d:	48 89 c2             	mov    %rax,%rdx
  801d50:	be 00 00 00 00       	mov    $0x0,%esi
  801d55:	bf 10 00 00 00       	mov    $0x10,%edi
  801d5a:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801d61:	00 00 00 
  801d64:	ff d0                	callq  *%rax
}
  801d66:	c9                   	leaveq 
  801d67:	c3                   	retq   

0000000000801d68 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d68:	55                   	push   %rbp
  801d69:	48 89 e5             	mov    %rsp,%rbp
  801d6c:	48 83 ec 08          	sub    $0x8,%rsp
  801d70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d74:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d78:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d7f:	ff ff ff 
  801d82:	48 01 d0             	add    %rdx,%rax
  801d85:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d89:	c9                   	leaveq 
  801d8a:	c3                   	retq   

0000000000801d8b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d8b:	55                   	push   %rbp
  801d8c:	48 89 e5             	mov    %rsp,%rbp
  801d8f:	48 83 ec 08          	sub    $0x8,%rsp
  801d93:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9b:	48 89 c7             	mov    %rax,%rdi
  801d9e:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  801da5:	00 00 00 
  801da8:	ff d0                	callq  *%rax
  801daa:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801db0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801db4:	c9                   	leaveq 
  801db5:	c3                   	retq   

0000000000801db6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801db6:	55                   	push   %rbp
  801db7:	48 89 e5             	mov    %rsp,%rbp
  801dba:	48 83 ec 18          	sub    $0x18,%rsp
  801dbe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dc9:	eb 6b                	jmp    801e36 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dce:	48 98                	cltq   
  801dd0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dd6:	48 c1 e0 0c          	shl    $0xc,%rax
  801dda:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de2:	48 89 c2             	mov    %rax,%rdx
  801de5:	48 c1 ea 15          	shr    $0x15,%rdx
  801de9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801df0:	01 00 00 
  801df3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df7:	83 e0 01             	and    $0x1,%eax
  801dfa:	48 85 c0             	test   %rax,%rax
  801dfd:	74 21                	je     801e20 <fd_alloc+0x6a>
  801dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e03:	48 89 c2             	mov    %rax,%rdx
  801e06:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e11:	01 00 00 
  801e14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e18:	83 e0 01             	and    $0x1,%eax
  801e1b:	48 85 c0             	test   %rax,%rax
  801e1e:	75 12                	jne    801e32 <fd_alloc+0x7c>
			*fd_store = fd;
  801e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e28:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e30:	eb 1a                	jmp    801e4c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e32:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e36:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e3a:	7e 8f                	jle    801dcb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e40:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e47:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e4c:	c9                   	leaveq 
  801e4d:	c3                   	retq   

0000000000801e4e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
  801e52:	48 83 ec 20          	sub    $0x20,%rsp
  801e56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e61:	78 06                	js     801e69 <fd_lookup+0x1b>
  801e63:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e67:	7e 07                	jle    801e70 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6e:	eb 6c                	jmp    801edc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e73:	48 98                	cltq   
  801e75:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e7b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e87:	48 89 c2             	mov    %rax,%rdx
  801e8a:	48 c1 ea 15          	shr    $0x15,%rdx
  801e8e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e95:	01 00 00 
  801e98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e9c:	83 e0 01             	and    $0x1,%eax
  801e9f:	48 85 c0             	test   %rax,%rax
  801ea2:	74 21                	je     801ec5 <fd_lookup+0x77>
  801ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea8:	48 89 c2             	mov    %rax,%rdx
  801eab:	48 c1 ea 0c          	shr    $0xc,%rdx
  801eaf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eb6:	01 00 00 
  801eb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebd:	83 e0 01             	and    $0x1,%eax
  801ec0:	48 85 c0             	test   %rax,%rax
  801ec3:	75 07                	jne    801ecc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ec5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eca:	eb 10                	jmp    801edc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ecc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ed0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ed4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 83 ec 30          	sub    $0x30,%rsp
  801ee6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801eea:	89 f0                	mov    %esi,%eax
  801eec:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef3:	48 89 c7             	mov    %rax,%rdi
  801ef6:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  801efd:	00 00 00 
  801f00:	ff d0                	callq  *%rax
  801f02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f06:	48 89 d6             	mov    %rdx,%rsi
  801f09:	89 c7                	mov    %eax,%edi
  801f0b:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  801f12:	00 00 00 
  801f15:	ff d0                	callq  *%rax
  801f17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f1e:	78 0a                	js     801f2a <fd_close+0x4c>
	    || fd != fd2)
  801f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f24:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f28:	74 12                	je     801f3c <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f2a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f2e:	74 05                	je     801f35 <fd_close+0x57>
  801f30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f33:	eb 05                	jmp    801f3a <fd_close+0x5c>
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3a:	eb 69                	jmp    801fa5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f40:	8b 00                	mov    (%rax),%eax
  801f42:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f46:	48 89 d6             	mov    %rdx,%rsi
  801f49:	89 c7                	mov    %eax,%edi
  801f4b:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  801f52:	00 00 00 
  801f55:	ff d0                	callq  *%rax
  801f57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f5e:	78 2a                	js     801f8a <fd_close+0xac>
		if (dev->dev_close)
  801f60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f64:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f68:	48 85 c0             	test   %rax,%rax
  801f6b:	74 16                	je     801f83 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f71:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801f75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f79:	48 89 c7             	mov    %rax,%rdi
  801f7c:	ff d2                	callq  *%rdx
  801f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f81:	eb 07                	jmp    801f8a <fd_close+0xac>
		else
			r = 0;
  801f83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f8e:	48 89 c6             	mov    %rax,%rsi
  801f91:	bf 00 00 00 00       	mov    $0x0,%edi
  801f96:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801f9d:	00 00 00 
  801fa0:	ff d0                	callq  *%rax
	return r;
  801fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fa5:	c9                   	leaveq 
  801fa6:	c3                   	retq   

0000000000801fa7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fa7:	55                   	push   %rbp
  801fa8:	48 89 e5             	mov    %rsp,%rbp
  801fab:	48 83 ec 20          	sub    $0x20,%rsp
  801faf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fbd:	eb 41                	jmp    802000 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fbf:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fc6:	00 00 00 
  801fc9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fcc:	48 63 d2             	movslq %edx,%rdx
  801fcf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd3:	8b 00                	mov    (%rax),%eax
  801fd5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fd8:	75 22                	jne    801ffc <dev_lookup+0x55>
			*dev = devtab[i];
  801fda:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fe1:	00 00 00 
  801fe4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fe7:	48 63 d2             	movslq %edx,%rdx
  801fea:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffa:	eb 60                	jmp    80205c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ffc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802000:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802007:	00 00 00 
  80200a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80200d:	48 63 d2             	movslq %edx,%rdx
  802010:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802014:	48 85 c0             	test   %rax,%rax
  802017:	75 a6                	jne    801fbf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802019:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802020:	00 00 00 
  802023:	48 8b 00             	mov    (%rax),%rax
  802026:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80202c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80202f:	89 c6                	mov    %eax,%esi
  802031:	48 bf 98 48 80 00 00 	movabs $0x804898,%rdi
  802038:	00 00 00 
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	48 b9 0f 05 80 00 00 	movabs $0x80050f,%rcx
  802047:	00 00 00 
  80204a:	ff d1                	callq  *%rcx
	*dev = 0;
  80204c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802050:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802057:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80205c:	c9                   	leaveq 
  80205d:	c3                   	retq   

000000000080205e <close>:

int
close(int fdnum)
{
  80205e:	55                   	push   %rbp
  80205f:	48 89 e5             	mov    %rsp,%rbp
  802062:	48 83 ec 20          	sub    $0x20,%rsp
  802066:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802069:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80206d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802070:	48 89 d6             	mov    %rdx,%rsi
  802073:	89 c7                	mov    %eax,%edi
  802075:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  80207c:	00 00 00 
  80207f:	ff d0                	callq  *%rax
  802081:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802084:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802088:	79 05                	jns    80208f <close+0x31>
		return r;
  80208a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80208d:	eb 18                	jmp    8020a7 <close+0x49>
	else
		return fd_close(fd, 1);
  80208f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802093:	be 01 00 00 00       	mov    $0x1,%esi
  802098:	48 89 c7             	mov    %rax,%rdi
  80209b:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  8020a2:	00 00 00 
  8020a5:	ff d0                	callq  *%rax
}
  8020a7:	c9                   	leaveq 
  8020a8:	c3                   	retq   

00000000008020a9 <close_all>:

void
close_all(void)
{
  8020a9:	55                   	push   %rbp
  8020aa:	48 89 e5             	mov    %rsp,%rbp
  8020ad:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020b8:	eb 15                	jmp    8020cf <close_all+0x26>
		close(i);
  8020ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bd:	89 c7                	mov    %eax,%edi
  8020bf:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020cf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020d3:	7e e5                	jle    8020ba <close_all+0x11>
		close(i);
}
  8020d5:	c9                   	leaveq 
  8020d6:	c3                   	retq   

00000000008020d7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020d7:	55                   	push   %rbp
  8020d8:	48 89 e5             	mov    %rsp,%rbp
  8020db:	48 83 ec 40          	sub    $0x40,%rsp
  8020df:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020e2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020e5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020e9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020ec:	48 89 d6             	mov    %rdx,%rsi
  8020ef:	89 c7                	mov    %eax,%edi
  8020f1:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8020f8:	00 00 00 
  8020fb:	ff d0                	callq  *%rax
  8020fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802100:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802104:	79 08                	jns    80210e <dup+0x37>
		return r;
  802106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802109:	e9 70 01 00 00       	jmpq   80227e <dup+0x1a7>
	close(newfdnum);
  80210e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802111:	89 c7                	mov    %eax,%edi
  802113:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  80211a:	00 00 00 
  80211d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80211f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802122:	48 98                	cltq   
  802124:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80212a:	48 c1 e0 0c          	shl    $0xc,%rax
  80212e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802136:	48 89 c7             	mov    %rax,%rdi
  802139:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  802140:	00 00 00 
  802143:	ff d0                	callq  *%rax
  802145:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802149:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214d:	48 89 c7             	mov    %rax,%rdi
  802150:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  802157:	00 00 00 
  80215a:	ff d0                	callq  *%rax
  80215c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802164:	48 89 c2             	mov    %rax,%rdx
  802167:	48 c1 ea 15          	shr    $0x15,%rdx
  80216b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802172:	01 00 00 
  802175:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802179:	83 e0 01             	and    $0x1,%eax
  80217c:	84 c0                	test   %al,%al
  80217e:	74 71                	je     8021f1 <dup+0x11a>
  802180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802184:	48 89 c2             	mov    %rax,%rdx
  802187:	48 c1 ea 0c          	shr    $0xc,%rdx
  80218b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802192:	01 00 00 
  802195:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802199:	83 e0 01             	and    $0x1,%eax
  80219c:	84 c0                	test   %al,%al
  80219e:	74 51                	je     8021f1 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a4:	48 89 c2             	mov    %rax,%rdx
  8021a7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021b2:	01 00 00 
  8021b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b9:	89 c1                	mov    %eax,%ecx
  8021bb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c9:	41 89 c8             	mov    %ecx,%r8d
  8021cc:	48 89 d1             	mov    %rdx,%rcx
  8021cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d4:	48 89 c6             	mov    %rax,%rsi
  8021d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021dc:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  8021e3:	00 00 00 
  8021e6:	ff d0                	callq  *%rax
  8021e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ef:	78 56                	js     802247 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f5:	48 89 c2             	mov    %rax,%rdx
  8021f8:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021fc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802203:	01 00 00 
  802206:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220a:	89 c1                	mov    %eax,%ecx
  80220c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802212:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802216:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80221a:	41 89 c8             	mov    %ecx,%r8d
  80221d:	48 89 d1             	mov    %rdx,%rcx
  802220:	ba 00 00 00 00       	mov    $0x0,%edx
  802225:	48 89 c6             	mov    %rax,%rsi
  802228:	bf 00 00 00 00       	mov    $0x0,%edi
  80222d:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  802234:	00 00 00 
  802237:	ff d0                	callq  *%rax
  802239:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802240:	78 08                	js     80224a <dup+0x173>
		goto err;

	return newfdnum;
  802242:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802245:	eb 37                	jmp    80227e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802247:	90                   	nop
  802248:	eb 01                	jmp    80224b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80224a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80224b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224f:	48 89 c6             	mov    %rax,%rsi
  802252:	bf 00 00 00 00       	mov    $0x0,%edi
  802257:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80225e:	00 00 00 
  802261:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802267:	48 89 c6             	mov    %rax,%rsi
  80226a:	bf 00 00 00 00       	mov    $0x0,%edi
  80226f:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  802276:	00 00 00 
  802279:	ff d0                	callq  *%rax
	return r;
  80227b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80227e:	c9                   	leaveq 
  80227f:	c3                   	retq   

0000000000802280 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802280:	55                   	push   %rbp
  802281:	48 89 e5             	mov    %rsp,%rbp
  802284:	48 83 ec 40          	sub    $0x40,%rsp
  802288:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80228b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80228f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802293:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802297:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80229a:	48 89 d6             	mov    %rdx,%rsi
  80229d:	89 c7                	mov    %eax,%edi
  80229f:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	callq  *%rax
  8022ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b2:	78 24                	js     8022d8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b8:	8b 00                	mov    (%rax),%eax
  8022ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022be:	48 89 d6             	mov    %rdx,%rsi
  8022c1:	89 c7                	mov    %eax,%edi
  8022c3:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  8022ca:	00 00 00 
  8022cd:	ff d0                	callq  *%rax
  8022cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d6:	79 05                	jns    8022dd <read+0x5d>
		return r;
  8022d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022db:	eb 7a                	jmp    802357 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e1:	8b 40 08             	mov    0x8(%rax),%eax
  8022e4:	83 e0 03             	and    $0x3,%eax
  8022e7:	83 f8 01             	cmp    $0x1,%eax
  8022ea:	75 3a                	jne    802326 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022ec:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8022f3:	00 00 00 
  8022f6:	48 8b 00             	mov    (%rax),%rax
  8022f9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022ff:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802302:	89 c6                	mov    %eax,%esi
  802304:	48 bf b7 48 80 00 00 	movabs $0x8048b7,%rdi
  80230b:	00 00 00 
  80230e:	b8 00 00 00 00       	mov    $0x0,%eax
  802313:	48 b9 0f 05 80 00 00 	movabs $0x80050f,%rcx
  80231a:	00 00 00 
  80231d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80231f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802324:	eb 31                	jmp    802357 <read+0xd7>
	}
	if (!dev->dev_read)
  802326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80232e:	48 85 c0             	test   %rax,%rax
  802331:	75 07                	jne    80233a <read+0xba>
		return -E_NOT_SUPP;
  802333:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802338:	eb 1d                	jmp    802357 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80233a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802346:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80234a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80234e:	48 89 ce             	mov    %rcx,%rsi
  802351:	48 89 c7             	mov    %rax,%rdi
  802354:	41 ff d0             	callq  *%r8
}
  802357:	c9                   	leaveq 
  802358:	c3                   	retq   

0000000000802359 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802359:	55                   	push   %rbp
  80235a:	48 89 e5             	mov    %rsp,%rbp
  80235d:	48 83 ec 30          	sub    $0x30,%rsp
  802361:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802364:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802368:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80236c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802373:	eb 46                	jmp    8023bb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802378:	48 98                	cltq   
  80237a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80237e:	48 29 c2             	sub    %rax,%rdx
  802381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802384:	48 98                	cltq   
  802386:	48 89 c1             	mov    %rax,%rcx
  802389:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  80238d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802390:	48 89 ce             	mov    %rcx,%rsi
  802393:	89 c7                	mov    %eax,%edi
  802395:	48 b8 80 22 80 00 00 	movabs $0x802280,%rax
  80239c:	00 00 00 
  80239f:	ff d0                	callq  *%rax
  8023a1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023a4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023a8:	79 05                	jns    8023af <readn+0x56>
			return m;
  8023aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023ad:	eb 1d                	jmp    8023cc <readn+0x73>
		if (m == 0)
  8023af:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023b3:	74 13                	je     8023c8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023b8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023be:	48 98                	cltq   
  8023c0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023c4:	72 af                	jb     802375 <readn+0x1c>
  8023c6:	eb 01                	jmp    8023c9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023c8:	90                   	nop
	}
	return tot;
  8023c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023cc:	c9                   	leaveq 
  8023cd:	c3                   	retq   

00000000008023ce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	48 83 ec 40          	sub    $0x40,%rsp
  8023d6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023d9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023dd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023e1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023e8:	48 89 d6             	mov    %rdx,%rsi
  8023eb:	89 c7                	mov    %eax,%edi
  8023ed:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
  8023f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802400:	78 24                	js     802426 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802406:	8b 00                	mov    (%rax),%eax
  802408:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80240c:	48 89 d6             	mov    %rdx,%rsi
  80240f:	89 c7                	mov    %eax,%edi
  802411:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802418:	00 00 00 
  80241b:	ff d0                	callq  *%rax
  80241d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802420:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802424:	79 05                	jns    80242b <write+0x5d>
		return r;
  802426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802429:	eb 79                	jmp    8024a4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80242b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242f:	8b 40 08             	mov    0x8(%rax),%eax
  802432:	83 e0 03             	and    $0x3,%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	75 3a                	jne    802473 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802439:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802440:	00 00 00 
  802443:	48 8b 00             	mov    (%rax),%rax
  802446:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80244c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80244f:	89 c6                	mov    %eax,%esi
  802451:	48 bf d3 48 80 00 00 	movabs $0x8048d3,%rdi
  802458:	00 00 00 
  80245b:	b8 00 00 00 00       	mov    $0x0,%eax
  802460:	48 b9 0f 05 80 00 00 	movabs $0x80050f,%rcx
  802467:	00 00 00 
  80246a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80246c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802471:	eb 31                	jmp    8024a4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802477:	48 8b 40 18          	mov    0x18(%rax),%rax
  80247b:	48 85 c0             	test   %rax,%rax
  80247e:	75 07                	jne    802487 <write+0xb9>
		return -E_NOT_SUPP;
  802480:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802485:	eb 1d                	jmp    8024a4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80248f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802493:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802497:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80249b:	48 89 ce             	mov    %rcx,%rsi
  80249e:	48 89 c7             	mov    %rax,%rdi
  8024a1:	41 ff d0             	callq  *%r8
}
  8024a4:	c9                   	leaveq 
  8024a5:	c3                   	retq   

00000000008024a6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024a6:	55                   	push   %rbp
  8024a7:	48 89 e5             	mov    %rsp,%rbp
  8024aa:	48 83 ec 18          	sub    $0x18,%rsp
  8024ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024b1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024b4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024bb:	48 89 d6             	mov    %rdx,%rsi
  8024be:	89 c7                	mov    %eax,%edi
  8024c0:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8024c7:	00 00 00 
  8024ca:	ff d0                	callq  *%rax
  8024cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d3:	79 05                	jns    8024da <seek+0x34>
		return r;
  8024d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d8:	eb 0f                	jmp    8024e9 <seek+0x43>
	fd->fd_offset = offset;
  8024da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024de:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024e1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e9:	c9                   	leaveq 
  8024ea:	c3                   	retq   

00000000008024eb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024eb:	55                   	push   %rbp
  8024ec:	48 89 e5             	mov    %rsp,%rbp
  8024ef:	48 83 ec 30          	sub    $0x30,%rsp
  8024f3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024f6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024f9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024fd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802500:	48 89 d6             	mov    %rdx,%rsi
  802503:	89 c7                	mov    %eax,%edi
  802505:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	callq  *%rax
  802511:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802514:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802518:	78 24                	js     80253e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80251a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251e:	8b 00                	mov    (%rax),%eax
  802520:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802524:	48 89 d6             	mov    %rdx,%rsi
  802527:	89 c7                	mov    %eax,%edi
  802529:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax
  802535:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802538:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253c:	79 05                	jns    802543 <ftruncate+0x58>
		return r;
  80253e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802541:	eb 72                	jmp    8025b5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802547:	8b 40 08             	mov    0x8(%rax),%eax
  80254a:	83 e0 03             	and    $0x3,%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	75 3a                	jne    80258b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802551:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802558:	00 00 00 
  80255b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80255e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802564:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802567:	89 c6                	mov    %eax,%esi
  802569:	48 bf f0 48 80 00 00 	movabs $0x8048f0,%rdi
  802570:	00 00 00 
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	48 b9 0f 05 80 00 00 	movabs $0x80050f,%rcx
  80257f:	00 00 00 
  802582:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802584:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802589:	eb 2a                	jmp    8025b5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80258b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80258f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802593:	48 85 c0             	test   %rax,%rax
  802596:	75 07                	jne    80259f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802598:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80259d:	eb 16                	jmp    8025b5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80259f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8025a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ab:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8025ae:	89 d6                	mov    %edx,%esi
  8025b0:	48 89 c7             	mov    %rax,%rdi
  8025b3:	ff d1                	callq  *%rcx
}
  8025b5:	c9                   	leaveq 
  8025b6:	c3                   	retq   

00000000008025b7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025b7:	55                   	push   %rbp
  8025b8:	48 89 e5             	mov    %rsp,%rbp
  8025bb:	48 83 ec 30          	sub    $0x30,%rsp
  8025bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025cd:	48 89 d6             	mov    %rdx,%rsi
  8025d0:	89 c7                	mov    %eax,%edi
  8025d2:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax
  8025de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e5:	78 24                	js     80260b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025eb:	8b 00                	mov    (%rax),%eax
  8025ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025f1:	48 89 d6             	mov    %rdx,%rsi
  8025f4:	89 c7                	mov    %eax,%edi
  8025f6:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  8025fd:	00 00 00 
  802600:	ff d0                	callq  *%rax
  802602:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802605:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802609:	79 05                	jns    802610 <fstat+0x59>
		return r;
  80260b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260e:	eb 5e                	jmp    80266e <fstat+0xb7>
	if (!dev->dev_stat)
  802610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802614:	48 8b 40 28          	mov    0x28(%rax),%rax
  802618:	48 85 c0             	test   %rax,%rax
  80261b:	75 07                	jne    802624 <fstat+0x6d>
		return -E_NOT_SUPP;
  80261d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802622:	eb 4a                	jmp    80266e <fstat+0xb7>
	stat->st_name[0] = 0;
  802624:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802628:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80262b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80262f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802636:	00 00 00 
	stat->st_isdir = 0;
  802639:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80263d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802644:	00 00 00 
	stat->st_dev = dev;
  802647:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80264b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80264f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80265e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802662:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802666:	48 89 d6             	mov    %rdx,%rsi
  802669:	48 89 c7             	mov    %rax,%rdi
  80266c:	ff d1                	callq  *%rcx
}
  80266e:	c9                   	leaveq 
  80266f:	c3                   	retq   

0000000000802670 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802670:	55                   	push   %rbp
  802671:	48 89 e5             	mov    %rsp,%rbp
  802674:	48 83 ec 20          	sub    $0x20,%rsp
  802678:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80267c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802684:	be 00 00 00 00       	mov    $0x0,%esi
  802689:	48 89 c7             	mov    %rax,%rdi
  80268c:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  802693:	00 00 00 
  802696:	ff d0                	callq  *%rax
  802698:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269f:	79 05                	jns    8026a6 <stat+0x36>
		return fd;
  8026a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a4:	eb 2f                	jmp    8026d5 <stat+0x65>
	r = fstat(fd, stat);
  8026a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ad:	48 89 d6             	mov    %rdx,%rsi
  8026b0:	89 c7                	mov    %eax,%edi
  8026b2:	48 b8 b7 25 80 00 00 	movabs $0x8025b7,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
  8026be:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c4:	89 c7                	mov    %eax,%edi
  8026c6:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
	return r;
  8026d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026d5:	c9                   	leaveq 
  8026d6:	c3                   	retq   
	...

00000000008026d8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026d8:	55                   	push   %rbp
  8026d9:	48 89 e5             	mov    %rsp,%rbp
  8026dc:	48 83 ec 10          	sub    $0x10,%rsp
  8026e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026e7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026ee:	00 00 00 
  8026f1:	8b 00                	mov    (%rax),%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	75 1d                	jne    802714 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026f7:	bf 01 00 00 00       	mov    $0x1,%edi
  8026fc:	48 b8 c2 3c 80 00 00 	movabs $0x803cc2,%rax
  802703:	00 00 00 
  802706:	ff d0                	callq  *%rax
  802708:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80270f:	00 00 00 
  802712:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802714:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80271b:	00 00 00 
  80271e:	8b 00                	mov    (%rax),%eax
  802720:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802723:	b9 07 00 00 00       	mov    $0x7,%ecx
  802728:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80272f:	00 00 00 
  802732:	89 c7                	mov    %eax,%edi
  802734:	48 b8 13 3c 80 00 00 	movabs $0x803c13,%rax
  80273b:	00 00 00 
  80273e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802740:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802744:	ba 00 00 00 00       	mov    $0x0,%edx
  802749:	48 89 c6             	mov    %rax,%rsi
  80274c:	bf 00 00 00 00       	mov    $0x0,%edi
  802751:	48 b8 2c 3b 80 00 00 	movabs $0x803b2c,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
}
  80275d:	c9                   	leaveq 
  80275e:	c3                   	retq   

000000000080275f <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  80275f:	55                   	push   %rbp
  802760:	48 89 e5             	mov    %rsp,%rbp
  802763:	48 83 ec 20          	sub    $0x20,%rsp
  802767:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80276b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  80276e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802772:	48 89 c7             	mov    %rax,%rdi
  802775:	48 b8 74 10 80 00 00 	movabs $0x801074,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
  802781:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802786:	7e 0a                	jle    802792 <open+0x33>
		return -E_BAD_PATH;
  802788:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80278d:	e9 a5 00 00 00       	jmpq   802837 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802792:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802796:	48 89 c7             	mov    %rax,%rdi
  802799:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  8027a0:	00 00 00 
  8027a3:	ff d0                	callq  *%rax
  8027a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8027a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ac:	79 08                	jns    8027b6 <open+0x57>
		return r;
  8027ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b1:	e9 81 00 00 00       	jmpq   802837 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  8027b6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027bd:	00 00 00 
  8027c0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027c3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8027c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cd:	48 89 c6             	mov    %rax,%rsi
  8027d0:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027d7:	00 00 00 
  8027da:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  8027e1:	00 00 00 
  8027e4:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  8027e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ea:	48 89 c6             	mov    %rax,%rsi
  8027ed:	bf 01 00 00 00       	mov    $0x1,%edi
  8027f2:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
  8027fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802801:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802805:	79 1d                	jns    802824 <open+0xc5>
		fd_close(new_fd, 0);
  802807:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280b:	be 00 00 00 00       	mov    $0x0,%esi
  802810:	48 89 c7             	mov    %rax,%rdi
  802813:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  80281a:	00 00 00 
  80281d:	ff d0                	callq  *%rax
		return r;	
  80281f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802822:	eb 13                	jmp    802837 <open+0xd8>
	}
	return fd2num(new_fd);
  802824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802828:	48 89 c7             	mov    %rax,%rdi
  80282b:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802832:	00 00 00 
  802835:	ff d0                	callq  *%rax
}
  802837:	c9                   	leaveq 
  802838:	c3                   	retq   

0000000000802839 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802839:	55                   	push   %rbp
  80283a:	48 89 e5             	mov    %rsp,%rbp
  80283d:	48 83 ec 10          	sub    $0x10,%rsp
  802841:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802845:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802849:	8b 50 0c             	mov    0xc(%rax),%edx
  80284c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802853:	00 00 00 
  802856:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802858:	be 00 00 00 00       	mov    $0x0,%esi
  80285d:	bf 06 00 00 00       	mov    $0x6,%edi
  802862:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  802869:	00 00 00 
  80286c:	ff d0                	callq  *%rax
}
  80286e:	c9                   	leaveq 
  80286f:	c3                   	retq   

0000000000802870 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802870:	55                   	push   %rbp
  802871:	48 89 e5             	mov    %rsp,%rbp
  802874:	48 83 ec 30          	sub    $0x30,%rsp
  802878:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80287c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802880:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802888:	8b 50 0c             	mov    0xc(%rax),%edx
  80288b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802892:	00 00 00 
  802895:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802897:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80289e:	00 00 00 
  8028a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028a5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8028a9:	be 00 00 00 00       	mov    $0x0,%esi
  8028ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8028b3:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	callq  *%rax
  8028bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8028c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c6:	7e 23                	jle    8028eb <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8028c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cb:	48 63 d0             	movslq %eax,%rdx
  8028ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028d9:	00 00 00 
  8028dc:	48 89 c7             	mov    %rax,%rdi
  8028df:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  8028e6:	00 00 00 
  8028e9:	ff d0                	callq  *%rax
	}
	return nbytes;
  8028eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028ee:	c9                   	leaveq 
  8028ef:	c3                   	retq   

00000000008028f0 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028f0:	55                   	push   %rbp
  8028f1:	48 89 e5             	mov    %rsp,%rbp
  8028f4:	48 83 ec 20          	sub    $0x20,%rsp
  8028f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802904:	8b 50 0c             	mov    0xc(%rax),%edx
  802907:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80290e:	00 00 00 
  802911:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802913:	be 00 00 00 00       	mov    $0x0,%esi
  802918:	bf 05 00 00 00       	mov    $0x5,%edi
  80291d:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  802924:	00 00 00 
  802927:	ff d0                	callq  *%rax
  802929:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802930:	79 05                	jns    802937 <devfile_stat+0x47>
		return r;
  802932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802935:	eb 56                	jmp    80298d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802937:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80293b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802942:	00 00 00 
  802945:	48 89 c7             	mov    %rax,%rdi
  802948:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  80294f:	00 00 00 
  802952:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802954:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80295b:	00 00 00 
  80295e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802964:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802968:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80296e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802975:	00 00 00 
  802978:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80297e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802982:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80298d:	c9                   	leaveq 
  80298e:	c3                   	retq   
	...

0000000000802990 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802990:	55                   	push   %rbp
  802991:	48 89 e5             	mov    %rsp,%rbp
  802994:	48 83 ec 20          	sub    $0x20,%rsp
  802998:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80299b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80299f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029a2:	48 89 d6             	mov    %rdx,%rsi
  8029a5:	89 c7                	mov    %eax,%edi
  8029a7:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
  8029b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ba:	79 05                	jns    8029c1 <fd2sockid+0x31>
		return r;
  8029bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029bf:	eb 24                	jmp    8029e5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8029c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c5:	8b 10                	mov    (%rax),%edx
  8029c7:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8029ce:	00 00 00 
  8029d1:	8b 00                	mov    (%rax),%eax
  8029d3:	39 c2                	cmp    %eax,%edx
  8029d5:	74 07                	je     8029de <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8029d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029dc:	eb 07                	jmp    8029e5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8029de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8029e5:	c9                   	leaveq 
  8029e6:	c3                   	retq   

00000000008029e7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8029e7:	55                   	push   %rbp
  8029e8:	48 89 e5             	mov    %rsp,%rbp
  8029eb:	48 83 ec 20          	sub    $0x20,%rsp
  8029ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8029f2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8029f6:	48 89 c7             	mov    %rax,%rdi
  8029f9:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  802a00:	00 00 00 
  802a03:	ff d0                	callq  *%rax
  802a05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0c:	78 26                	js     802a34 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802a0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a12:	ba 07 04 00 00       	mov    $0x407,%edx
  802a17:	48 89 c6             	mov    %rax,%rsi
  802a1a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a1f:	48 b8 18 1a 80 00 00 	movabs $0x801a18,%rax
  802a26:	00 00 00 
  802a29:	ff d0                	callq  *%rax
  802a2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a32:	79 16                	jns    802a4a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802a34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a37:	89 c7                	mov    %eax,%edi
  802a39:	48 b8 f4 2e 80 00 00 	movabs $0x802ef4,%rax
  802a40:	00 00 00 
  802a43:	ff d0                	callq  *%rax
		return r;
  802a45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a48:	eb 3a                	jmp    802a84 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802a4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4e:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802a55:	00 00 00 
  802a58:	8b 12                	mov    (%rdx),%edx
  802a5a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802a5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a60:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a6e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802a71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a75:	48 89 c7             	mov    %rax,%rdi
  802a78:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802a7f:	00 00 00 
  802a82:	ff d0                	callq  *%rax
}
  802a84:	c9                   	leaveq 
  802a85:	c3                   	retq   

0000000000802a86 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802a86:	55                   	push   %rbp
  802a87:	48 89 e5             	mov    %rsp,%rbp
  802a8a:	48 83 ec 30          	sub    $0x30,%rsp
  802a8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a95:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a9c:	89 c7                	mov    %eax,%edi
  802a9e:	48 b8 90 29 80 00 00 	movabs $0x802990,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
  802aaa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab1:	79 05                	jns    802ab8 <accept+0x32>
		return r;
  802ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab6:	eb 3b                	jmp    802af3 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802ab8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802abc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac3:	48 89 ce             	mov    %rcx,%rsi
  802ac6:	89 c7                	mov    %eax,%edi
  802ac8:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  802acf:	00 00 00 
  802ad2:	ff d0                	callq  *%rax
  802ad4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802adb:	79 05                	jns    802ae2 <accept+0x5c>
		return r;
  802add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae0:	eb 11                	jmp    802af3 <accept+0x6d>
	return alloc_sockfd(r);
  802ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae5:	89 c7                	mov    %eax,%edi
  802ae7:	48 b8 e7 29 80 00 00 	movabs $0x8029e7,%rax
  802aee:	00 00 00 
  802af1:	ff d0                	callq  *%rax
}
  802af3:	c9                   	leaveq 
  802af4:	c3                   	retq   

0000000000802af5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802af5:	55                   	push   %rbp
  802af6:	48 89 e5             	mov    %rsp,%rbp
  802af9:	48 83 ec 20          	sub    $0x20,%rsp
  802afd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b04:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b0a:	89 c7                	mov    %eax,%edi
  802b0c:	48 b8 90 29 80 00 00 	movabs $0x802990,%rax
  802b13:	00 00 00 
  802b16:	ff d0                	callq  *%rax
  802b18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1f:	79 05                	jns    802b26 <bind+0x31>
		return r;
  802b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b24:	eb 1b                	jmp    802b41 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802b26:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b29:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b30:	48 89 ce             	mov    %rcx,%rsi
  802b33:	89 c7                	mov    %eax,%edi
  802b35:	48 b8 50 2e 80 00 00 	movabs $0x802e50,%rax
  802b3c:	00 00 00 
  802b3f:	ff d0                	callq  *%rax
}
  802b41:	c9                   	leaveq 
  802b42:	c3                   	retq   

0000000000802b43 <shutdown>:

int
shutdown(int s, int how)
{
  802b43:	55                   	push   %rbp
  802b44:	48 89 e5             	mov    %rsp,%rbp
  802b47:	48 83 ec 20          	sub    $0x20,%rsp
  802b4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b4e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b51:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b54:	89 c7                	mov    %eax,%edi
  802b56:	48 b8 90 29 80 00 00 	movabs $0x802990,%rax
  802b5d:	00 00 00 
  802b60:	ff d0                	callq  *%rax
  802b62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b69:	79 05                	jns    802b70 <shutdown+0x2d>
		return r;
  802b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6e:	eb 16                	jmp    802b86 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802b70:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b76:	89 d6                	mov    %edx,%esi
  802b78:	89 c7                	mov    %eax,%edi
  802b7a:	48 b8 b4 2e 80 00 00 	movabs $0x802eb4,%rax
  802b81:	00 00 00 
  802b84:	ff d0                	callq  *%rax
}
  802b86:	c9                   	leaveq 
  802b87:	c3                   	retq   

0000000000802b88 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802b88:	55                   	push   %rbp
  802b89:	48 89 e5             	mov    %rsp,%rbp
  802b8c:	48 83 ec 10          	sub    $0x10,%rsp
  802b90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802b94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b98:	48 89 c7             	mov    %rax,%rdi
  802b9b:	48 b8 50 3d 80 00 00 	movabs $0x803d50,%rax
  802ba2:	00 00 00 
  802ba5:	ff d0                	callq  *%rax
  802ba7:	83 f8 01             	cmp    $0x1,%eax
  802baa:	75 17                	jne    802bc3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802bac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb0:	8b 40 0c             	mov    0xc(%rax),%eax
  802bb3:	89 c7                	mov    %eax,%edi
  802bb5:	48 b8 f4 2e 80 00 00 	movabs $0x802ef4,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
  802bc1:	eb 05                	jmp    802bc8 <devsock_close+0x40>
	else
		return 0;
  802bc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc8:	c9                   	leaveq 
  802bc9:	c3                   	retq   

0000000000802bca <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802bca:	55                   	push   %rbp
  802bcb:	48 89 e5             	mov    %rsp,%rbp
  802bce:	48 83 ec 20          	sub    $0x20,%rsp
  802bd2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bd5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bd9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bdc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bdf:	89 c7                	mov    %eax,%edi
  802be1:	48 b8 90 29 80 00 00 	movabs $0x802990,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
  802bed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf4:	79 05                	jns    802bfb <connect+0x31>
		return r;
  802bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf9:	eb 1b                	jmp    802c16 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802bfb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bfe:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c05:	48 89 ce             	mov    %rcx,%rsi
  802c08:	89 c7                	mov    %eax,%edi
  802c0a:	48 b8 21 2f 80 00 00 	movabs $0x802f21,%rax
  802c11:	00 00 00 
  802c14:	ff d0                	callq  *%rax
}
  802c16:	c9                   	leaveq 
  802c17:	c3                   	retq   

0000000000802c18 <listen>:

int
listen(int s, int backlog)
{
  802c18:	55                   	push   %rbp
  802c19:	48 89 e5             	mov    %rsp,%rbp
  802c1c:	48 83 ec 20          	sub    $0x20,%rsp
  802c20:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c23:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c26:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c29:	89 c7                	mov    %eax,%edi
  802c2b:	48 b8 90 29 80 00 00 	movabs $0x802990,%rax
  802c32:	00 00 00 
  802c35:	ff d0                	callq  *%rax
  802c37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3e:	79 05                	jns    802c45 <listen+0x2d>
		return r;
  802c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c43:	eb 16                	jmp    802c5b <listen+0x43>
	return nsipc_listen(r, backlog);
  802c45:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4b:	89 d6                	mov    %edx,%esi
  802c4d:	89 c7                	mov    %eax,%edi
  802c4f:	48 b8 85 2f 80 00 00 	movabs $0x802f85,%rax
  802c56:	00 00 00 
  802c59:	ff d0                	callq  *%rax
}
  802c5b:	c9                   	leaveq 
  802c5c:	c3                   	retq   

0000000000802c5d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802c5d:	55                   	push   %rbp
  802c5e:	48 89 e5             	mov    %rsp,%rbp
  802c61:	48 83 ec 20          	sub    $0x20,%rsp
  802c65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c69:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c6d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802c71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c75:	89 c2                	mov    %eax,%edx
  802c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c7b:	8b 40 0c             	mov    0xc(%rax),%eax
  802c7e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802c82:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c87:	89 c7                	mov    %eax,%edi
  802c89:	48 b8 c5 2f 80 00 00 	movabs $0x802fc5,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
}
  802c95:	c9                   	leaveq 
  802c96:	c3                   	retq   

0000000000802c97 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802c97:	55                   	push   %rbp
  802c98:	48 89 e5             	mov    %rsp,%rbp
  802c9b:	48 83 ec 20          	sub    $0x20,%rsp
  802c9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ca3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ca7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802cab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802caf:	89 c2                	mov    %eax,%edx
  802cb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb5:	8b 40 0c             	mov    0xc(%rax),%eax
  802cb8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802cbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  802cc1:	89 c7                	mov    %eax,%edi
  802cc3:	48 b8 91 30 80 00 00 	movabs $0x803091,%rax
  802cca:	00 00 00 
  802ccd:	ff d0                	callq  *%rax
}
  802ccf:	c9                   	leaveq 
  802cd0:	c3                   	retq   

0000000000802cd1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802cd1:	55                   	push   %rbp
  802cd2:	48 89 e5             	mov    %rsp,%rbp
  802cd5:	48 83 ec 10          	sub    $0x10,%rsp
  802cd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802ce1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce5:	48 be 1b 49 80 00 00 	movabs $0x80491b,%rsi
  802cec:	00 00 00 
  802cef:	48 89 c7             	mov    %rax,%rdi
  802cf2:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
	return 0;
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d03:	c9                   	leaveq 
  802d04:	c3                   	retq   

0000000000802d05 <socket>:

int
socket(int domain, int type, int protocol)
{
  802d05:	55                   	push   %rbp
  802d06:	48 89 e5             	mov    %rsp,%rbp
  802d09:	48 83 ec 20          	sub    $0x20,%rsp
  802d0d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d10:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802d13:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802d16:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d19:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802d1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d1f:	89 ce                	mov    %ecx,%esi
  802d21:	89 c7                	mov    %eax,%edi
  802d23:	48 b8 49 31 80 00 00 	movabs $0x803149,%rax
  802d2a:	00 00 00 
  802d2d:	ff d0                	callq  *%rax
  802d2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d36:	79 05                	jns    802d3d <socket+0x38>
		return r;
  802d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3b:	eb 11                	jmp    802d4e <socket+0x49>
	return alloc_sockfd(r);
  802d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d40:	89 c7                	mov    %eax,%edi
  802d42:	48 b8 e7 29 80 00 00 	movabs $0x8029e7,%rax
  802d49:	00 00 00 
  802d4c:	ff d0                	callq  *%rax
}
  802d4e:	c9                   	leaveq 
  802d4f:	c3                   	retq   

0000000000802d50 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802d50:	55                   	push   %rbp
  802d51:	48 89 e5             	mov    %rsp,%rbp
  802d54:	48 83 ec 10          	sub    $0x10,%rsp
  802d58:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802d5b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802d62:	00 00 00 
  802d65:	8b 00                	mov    (%rax),%eax
  802d67:	85 c0                	test   %eax,%eax
  802d69:	75 1d                	jne    802d88 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802d6b:	bf 02 00 00 00       	mov    $0x2,%edi
  802d70:	48 b8 c2 3c 80 00 00 	movabs $0x803cc2,%rax
  802d77:	00 00 00 
  802d7a:	ff d0                	callq  *%rax
  802d7c:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802d83:	00 00 00 
  802d86:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802d88:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802d8f:	00 00 00 
  802d92:	8b 00                	mov    (%rax),%eax
  802d94:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d97:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d9c:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802da3:	00 00 00 
  802da6:	89 c7                	mov    %eax,%edi
  802da8:	48 b8 13 3c 80 00 00 	movabs $0x803c13,%rax
  802daf:	00 00 00 
  802db2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802db4:	ba 00 00 00 00       	mov    $0x0,%edx
  802db9:	be 00 00 00 00       	mov    $0x0,%esi
  802dbe:	bf 00 00 00 00       	mov    $0x0,%edi
  802dc3:	48 b8 2c 3b 80 00 00 	movabs $0x803b2c,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
}
  802dcf:	c9                   	leaveq 
  802dd0:	c3                   	retq   

0000000000802dd1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802dd1:	55                   	push   %rbp
  802dd2:	48 89 e5             	mov    %rsp,%rbp
  802dd5:	48 83 ec 30          	sub    $0x30,%rsp
  802dd9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ddc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802de0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802de4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802deb:	00 00 00 
  802dee:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802df1:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802df3:	bf 01 00 00 00       	mov    $0x1,%edi
  802df8:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802dff:	00 00 00 
  802e02:	ff d0                	callq  *%rax
  802e04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0b:	78 3e                	js     802e4b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802e0d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e14:	00 00 00 
  802e17:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802e1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1f:	8b 40 10             	mov    0x10(%rax),%eax
  802e22:	89 c2                	mov    %eax,%edx
  802e24:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802e28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e2c:	48 89 ce             	mov    %rcx,%rsi
  802e2f:	48 89 c7             	mov    %rax,%rdi
  802e32:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e42:	8b 50 10             	mov    0x10(%rax),%edx
  802e45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e49:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e4e:	c9                   	leaveq 
  802e4f:	c3                   	retq   

0000000000802e50 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e50:	55                   	push   %rbp
  802e51:	48 89 e5             	mov    %rsp,%rbp
  802e54:	48 83 ec 10          	sub    $0x10,%rsp
  802e58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e5f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802e62:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e69:	00 00 00 
  802e6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e6f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802e71:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e78:	48 89 c6             	mov    %rax,%rsi
  802e7b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802e82:	00 00 00 
  802e85:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802e91:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e98:	00 00 00 
  802e9b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e9e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802ea1:	bf 02 00 00 00       	mov    $0x2,%edi
  802ea6:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802ead:	00 00 00 
  802eb0:	ff d0                	callq  *%rax
}
  802eb2:	c9                   	leaveq 
  802eb3:	c3                   	retq   

0000000000802eb4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802eb4:	55                   	push   %rbp
  802eb5:	48 89 e5             	mov    %rsp,%rbp
  802eb8:	48 83 ec 10          	sub    $0x10,%rsp
  802ebc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ebf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802ec2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ec9:	00 00 00 
  802ecc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ecf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802ed1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ed8:	00 00 00 
  802edb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ede:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802ee1:	bf 03 00 00 00       	mov    $0x3,%edi
  802ee6:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802eed:	00 00 00 
  802ef0:	ff d0                	callq  *%rax
}
  802ef2:	c9                   	leaveq 
  802ef3:	c3                   	retq   

0000000000802ef4 <nsipc_close>:

int
nsipc_close(int s)
{
  802ef4:	55                   	push   %rbp
  802ef5:	48 89 e5             	mov    %rsp,%rbp
  802ef8:	48 83 ec 10          	sub    $0x10,%rsp
  802efc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802eff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f06:	00 00 00 
  802f09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f0c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802f0e:	bf 04 00 00 00       	mov    $0x4,%edi
  802f13:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802f1a:	00 00 00 
  802f1d:	ff d0                	callq  *%rax
}
  802f1f:	c9                   	leaveq 
  802f20:	c3                   	retq   

0000000000802f21 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f21:	55                   	push   %rbp
  802f22:	48 89 e5             	mov    %rsp,%rbp
  802f25:	48 83 ec 10          	sub    $0x10,%rsp
  802f29:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f2c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f30:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802f33:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f3a:	00 00 00 
  802f3d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f40:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802f42:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f49:	48 89 c6             	mov    %rax,%rsi
  802f4c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802f53:	00 00 00 
  802f56:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  802f5d:	00 00 00 
  802f60:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  802f62:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f69:	00 00 00 
  802f6c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f6f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  802f72:	bf 05 00 00 00       	mov    $0x5,%edi
  802f77:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
}
  802f83:	c9                   	leaveq 
  802f84:	c3                   	retq   

0000000000802f85 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802f85:	55                   	push   %rbp
  802f86:	48 89 e5             	mov    %rsp,%rbp
  802f89:	48 83 ec 10          	sub    $0x10,%rsp
  802f8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f90:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  802f93:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f9a:	00 00 00 
  802f9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fa0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  802fa2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fa9:	00 00 00 
  802fac:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802faf:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  802fb2:	bf 06 00 00 00       	mov    $0x6,%edi
  802fb7:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  802fbe:	00 00 00 
  802fc1:	ff d0                	callq  *%rax
}
  802fc3:	c9                   	leaveq 
  802fc4:	c3                   	retq   

0000000000802fc5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802fc5:	55                   	push   %rbp
  802fc6:	48 89 e5             	mov    %rsp,%rbp
  802fc9:	48 83 ec 30          	sub    $0x30,%rsp
  802fcd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fd0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fd4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802fd7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802fda:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fe1:	00 00 00 
  802fe4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fe7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802fe9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ff0:	00 00 00 
  802ff3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ff6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802ff9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803000:	00 00 00 
  803003:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803006:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803009:	bf 07 00 00 00       	mov    $0x7,%edi
  80300e:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  803015:	00 00 00 
  803018:	ff d0                	callq  *%rax
  80301a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80301d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803021:	78 69                	js     80308c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803023:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80302a:	7f 08                	jg     803034 <nsipc_recv+0x6f>
  80302c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803032:	7e 35                	jle    803069 <nsipc_recv+0xa4>
  803034:	48 b9 22 49 80 00 00 	movabs $0x804922,%rcx
  80303b:	00 00 00 
  80303e:	48 ba 37 49 80 00 00 	movabs $0x804937,%rdx
  803045:	00 00 00 
  803048:	be 61 00 00 00       	mov    $0x61,%esi
  80304d:	48 bf 4c 49 80 00 00 	movabs $0x80494c,%rdi
  803054:	00 00 00 
  803057:	b8 00 00 00 00       	mov    $0x0,%eax
  80305c:	49 b8 18 3a 80 00 00 	movabs $0x803a18,%r8
  803063:	00 00 00 
  803066:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306c:	48 63 d0             	movslq %eax,%rdx
  80306f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803073:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80307a:	00 00 00 
  80307d:	48 89 c7             	mov    %rax,%rdi
  803080:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  803087:	00 00 00 
  80308a:	ff d0                	callq  *%rax
	}

	return r;
  80308c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80308f:	c9                   	leaveq 
  803090:	c3                   	retq   

0000000000803091 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803091:	55                   	push   %rbp
  803092:	48 89 e5             	mov    %rsp,%rbp
  803095:	48 83 ec 20          	sub    $0x20,%rsp
  803099:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80309c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030a0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8030a3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8030a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030ad:	00 00 00 
  8030b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030b3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8030b5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8030bc:	7e 35                	jle    8030f3 <nsipc_send+0x62>
  8030be:	48 b9 58 49 80 00 00 	movabs $0x804958,%rcx
  8030c5:	00 00 00 
  8030c8:	48 ba 37 49 80 00 00 	movabs $0x804937,%rdx
  8030cf:	00 00 00 
  8030d2:	be 6c 00 00 00       	mov    $0x6c,%esi
  8030d7:	48 bf 4c 49 80 00 00 	movabs $0x80494c,%rdi
  8030de:	00 00 00 
  8030e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e6:	49 b8 18 3a 80 00 00 	movabs $0x803a18,%r8
  8030ed:	00 00 00 
  8030f0:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8030f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030f6:	48 63 d0             	movslq %eax,%rdx
  8030f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fd:	48 89 c6             	mov    %rax,%rsi
  803100:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803107:	00 00 00 
  80310a:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  803111:	00 00 00 
  803114:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803116:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80311d:	00 00 00 
  803120:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803123:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803126:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80312d:	00 00 00 
  803130:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803133:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803136:	bf 08 00 00 00       	mov    $0x8,%edi
  80313b:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
}
  803147:	c9                   	leaveq 
  803148:	c3                   	retq   

0000000000803149 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
  80314d:	48 83 ec 10          	sub    $0x10,%rsp
  803151:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803154:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803157:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80315a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803161:	00 00 00 
  803164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803167:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803169:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803170:	00 00 00 
  803173:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803176:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803179:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803180:	00 00 00 
  803183:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803186:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803189:	bf 09 00 00 00       	mov    $0x9,%edi
  80318e:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
}
  80319a:	c9                   	leaveq 
  80319b:	c3                   	retq   

000000000080319c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80319c:	55                   	push   %rbp
  80319d:	48 89 e5             	mov    %rsp,%rbp
  8031a0:	53                   	push   %rbx
  8031a1:	48 83 ec 38          	sub    $0x38,%rsp
  8031a5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031a9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031ad:	48 89 c7             	mov    %rax,%rdi
  8031b0:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  8031b7:	00 00 00 
  8031ba:	ff d0                	callq  *%rax
  8031bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031c3:	0f 88 bf 01 00 00    	js     803388 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031cd:	ba 07 04 00 00       	mov    $0x407,%edx
  8031d2:	48 89 c6             	mov    %rax,%rsi
  8031d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8031da:	48 b8 18 1a 80 00 00 	movabs $0x801a18,%rax
  8031e1:	00 00 00 
  8031e4:	ff d0                	callq  *%rax
  8031e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ed:	0f 88 95 01 00 00    	js     803388 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8031f3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8031f7:	48 89 c7             	mov    %rax,%rdi
  8031fa:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  803201:	00 00 00 
  803204:	ff d0                	callq  *%rax
  803206:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803209:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80320d:	0f 88 5d 01 00 00    	js     803370 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803213:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803217:	ba 07 04 00 00       	mov    $0x407,%edx
  80321c:	48 89 c6             	mov    %rax,%rsi
  80321f:	bf 00 00 00 00       	mov    $0x0,%edi
  803224:	48 b8 18 1a 80 00 00 	movabs $0x801a18,%rax
  80322b:	00 00 00 
  80322e:	ff d0                	callq  *%rax
  803230:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803233:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803237:	0f 88 33 01 00 00    	js     803370 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80323d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803241:	48 89 c7             	mov    %rax,%rdi
  803244:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  80324b:	00 00 00 
  80324e:	ff d0                	callq  *%rax
  803250:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803254:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803258:	ba 07 04 00 00       	mov    $0x407,%edx
  80325d:	48 89 c6             	mov    %rax,%rsi
  803260:	bf 00 00 00 00       	mov    $0x0,%edi
  803265:	48 b8 18 1a 80 00 00 	movabs $0x801a18,%rax
  80326c:	00 00 00 
  80326f:	ff d0                	callq  *%rax
  803271:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803274:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803278:	0f 88 d9 00 00 00    	js     803357 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80327e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803282:	48 89 c7             	mov    %rax,%rdi
  803285:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  80328c:	00 00 00 
  80328f:	ff d0                	callq  *%rax
  803291:	48 89 c2             	mov    %rax,%rdx
  803294:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803298:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80329e:	48 89 d1             	mov    %rdx,%rcx
  8032a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a6:	48 89 c6             	mov    %rax,%rsi
  8032a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ae:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  8032b5:	00 00 00 
  8032b8:	ff d0                	callq  *%rax
  8032ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c1:	78 79                	js     80333c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8032c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8032ce:	00 00 00 
  8032d1:	8b 12                	mov    (%rdx),%edx
  8032d3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8032d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8032e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032e4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8032eb:	00 00 00 
  8032ee:	8b 12                	mov    (%rdx),%edx
  8032f0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8032f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8032fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803301:	48 89 c7             	mov    %rax,%rdi
  803304:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  80330b:	00 00 00 
  80330e:	ff d0                	callq  *%rax
  803310:	89 c2                	mov    %eax,%edx
  803312:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803316:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803318:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80331c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803320:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803324:	48 89 c7             	mov    %rax,%rdi
  803327:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  80332e:	00 00 00 
  803331:	ff d0                	callq  *%rax
  803333:	89 03                	mov    %eax,(%rbx)
	return 0;
  803335:	b8 00 00 00 00       	mov    $0x0,%eax
  80333a:	eb 4f                	jmp    80338b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80333c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80333d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803341:	48 89 c6             	mov    %rax,%rsi
  803344:	bf 00 00 00 00       	mov    $0x0,%edi
  803349:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
  803355:	eb 01                	jmp    803358 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803357:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803358:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335c:	48 89 c6             	mov    %rax,%rsi
  80335f:	bf 00 00 00 00       	mov    $0x0,%edi
  803364:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80336b:	00 00 00 
  80336e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803370:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803374:	48 89 c6             	mov    %rax,%rsi
  803377:	bf 00 00 00 00       	mov    $0x0,%edi
  80337c:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
err:
	return r;
  803388:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80338b:	48 83 c4 38          	add    $0x38,%rsp
  80338f:	5b                   	pop    %rbx
  803390:	5d                   	pop    %rbp
  803391:	c3                   	retq   

0000000000803392 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803392:	55                   	push   %rbp
  803393:	48 89 e5             	mov    %rsp,%rbp
  803396:	53                   	push   %rbx
  803397:	48 83 ec 28          	sub    $0x28,%rsp
  80339b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80339f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033a3:	eb 01                	jmp    8033a6 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8033a5:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033a6:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8033ad:	00 00 00 
  8033b0:	48 8b 00             	mov    (%rax),%rax
  8033b3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8033bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c0:	48 89 c7             	mov    %rax,%rdi
  8033c3:	48 b8 50 3d 80 00 00 	movabs $0x803d50,%rax
  8033ca:	00 00 00 
  8033cd:	ff d0                	callq  *%rax
  8033cf:	89 c3                	mov    %eax,%ebx
  8033d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d5:	48 89 c7             	mov    %rax,%rdi
  8033d8:	48 b8 50 3d 80 00 00 	movabs $0x803d50,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
  8033e4:	39 c3                	cmp    %eax,%ebx
  8033e6:	0f 94 c0             	sete   %al
  8033e9:	0f b6 c0             	movzbl %al,%eax
  8033ec:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8033ef:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8033f6:	00 00 00 
  8033f9:	48 8b 00             	mov    (%rax),%rax
  8033fc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803402:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803405:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803408:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80340b:	75 0a                	jne    803417 <_pipeisclosed+0x85>
			return ret;
  80340d:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803410:	48 83 c4 28          	add    $0x28,%rsp
  803414:	5b                   	pop    %rbx
  803415:	5d                   	pop    %rbp
  803416:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803417:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80341a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80341d:	74 86                	je     8033a5 <_pipeisclosed+0x13>
  80341f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803423:	75 80                	jne    8033a5 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803425:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80342c:	00 00 00 
  80342f:	48 8b 00             	mov    (%rax),%rax
  803432:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803438:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80343b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80343e:	89 c6                	mov    %eax,%esi
  803440:	48 bf 69 49 80 00 00 	movabs $0x804969,%rdi
  803447:	00 00 00 
  80344a:	b8 00 00 00 00       	mov    $0x0,%eax
  80344f:	49 b8 0f 05 80 00 00 	movabs $0x80050f,%r8
  803456:	00 00 00 
  803459:	41 ff d0             	callq  *%r8
	}
  80345c:	e9 44 ff ff ff       	jmpq   8033a5 <_pipeisclosed+0x13>

0000000000803461 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803461:	55                   	push   %rbp
  803462:	48 89 e5             	mov    %rsp,%rbp
  803465:	48 83 ec 30          	sub    $0x30,%rsp
  803469:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80346c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803470:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803473:	48 89 d6             	mov    %rdx,%rsi
  803476:	89 c7                	mov    %eax,%edi
  803478:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
  803484:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803487:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348b:	79 05                	jns    803492 <pipeisclosed+0x31>
		return r;
  80348d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803490:	eb 31                	jmp    8034c3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803496:	48 89 c7             	mov    %rax,%rdi
  803499:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  8034a0:	00 00 00 
  8034a3:	ff d0                	callq  *%rax
  8034a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034b1:	48 89 d6             	mov    %rdx,%rsi
  8034b4:	48 89 c7             	mov    %rax,%rdi
  8034b7:	48 b8 92 33 80 00 00 	movabs $0x803392,%rax
  8034be:	00 00 00 
  8034c1:	ff d0                	callq  *%rax
}
  8034c3:	c9                   	leaveq 
  8034c4:	c3                   	retq   

00000000008034c5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034c5:	55                   	push   %rbp
  8034c6:	48 89 e5             	mov    %rsp,%rbp
  8034c9:	48 83 ec 40          	sub    $0x40,%rsp
  8034cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034dd:	48 89 c7             	mov    %rax,%rdi
  8034e0:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  8034e7:	00 00 00 
  8034ea:	ff d0                	callq  *%rax
  8034ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034f4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034f8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034ff:	00 
  803500:	e9 97 00 00 00       	jmpq   80359c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803505:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80350a:	74 09                	je     803515 <devpipe_read+0x50>
				return i;
  80350c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803510:	e9 95 00 00 00       	jmpq   8035aa <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803515:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803519:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80351d:	48 89 d6             	mov    %rdx,%rsi
  803520:	48 89 c7             	mov    %rax,%rdi
  803523:	48 b8 92 33 80 00 00 	movabs $0x803392,%rax
  80352a:	00 00 00 
  80352d:	ff d0                	callq  *%rax
  80352f:	85 c0                	test   %eax,%eax
  803531:	74 07                	je     80353a <devpipe_read+0x75>
				return 0;
  803533:	b8 00 00 00 00       	mov    $0x0,%eax
  803538:	eb 70                	jmp    8035aa <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80353a:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  803541:	00 00 00 
  803544:	ff d0                	callq  *%rax
  803546:	eb 01                	jmp    803549 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803548:	90                   	nop
  803549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354d:	8b 10                	mov    (%rax),%edx
  80354f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803553:	8b 40 04             	mov    0x4(%rax),%eax
  803556:	39 c2                	cmp    %eax,%edx
  803558:	74 ab                	je     803505 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80355a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803562:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356a:	8b 00                	mov    (%rax),%eax
  80356c:	89 c2                	mov    %eax,%edx
  80356e:	c1 fa 1f             	sar    $0x1f,%edx
  803571:	c1 ea 1b             	shr    $0x1b,%edx
  803574:	01 d0                	add    %edx,%eax
  803576:	83 e0 1f             	and    $0x1f,%eax
  803579:	29 d0                	sub    %edx,%eax
  80357b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80357f:	48 98                	cltq   
  803581:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803586:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358c:	8b 00                	mov    (%rax),%eax
  80358e:	8d 50 01             	lea    0x1(%rax),%edx
  803591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803595:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803597:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80359c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035a4:	72 a2                	jb     803548 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035aa:	c9                   	leaveq 
  8035ab:	c3                   	retq   

00000000008035ac <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035ac:	55                   	push   %rbp
  8035ad:	48 89 e5             	mov    %rsp,%rbp
  8035b0:	48 83 ec 40          	sub    $0x40,%rsp
  8035b4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035b8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035bc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8035c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c4:	48 89 c7             	mov    %rax,%rdi
  8035c7:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
  8035d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035df:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035e6:	00 
  8035e7:	e9 93 00 00 00       	jmpq   80367f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8035ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f4:	48 89 d6             	mov    %rdx,%rsi
  8035f7:	48 89 c7             	mov    %rax,%rdi
  8035fa:	48 b8 92 33 80 00 00 	movabs $0x803392,%rax
  803601:	00 00 00 
  803604:	ff d0                	callq  *%rax
  803606:	85 c0                	test   %eax,%eax
  803608:	74 07                	je     803611 <devpipe_write+0x65>
				return 0;
  80360a:	b8 00 00 00 00       	mov    $0x0,%eax
  80360f:	eb 7c                	jmp    80368d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803611:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  803618:	00 00 00 
  80361b:	ff d0                	callq  *%rax
  80361d:	eb 01                	jmp    803620 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80361f:	90                   	nop
  803620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803624:	8b 40 04             	mov    0x4(%rax),%eax
  803627:	48 63 d0             	movslq %eax,%rdx
  80362a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362e:	8b 00                	mov    (%rax),%eax
  803630:	48 98                	cltq   
  803632:	48 83 c0 20          	add    $0x20,%rax
  803636:	48 39 c2             	cmp    %rax,%rdx
  803639:	73 b1                	jae    8035ec <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80363b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80363f:	8b 40 04             	mov    0x4(%rax),%eax
  803642:	89 c2                	mov    %eax,%edx
  803644:	c1 fa 1f             	sar    $0x1f,%edx
  803647:	c1 ea 1b             	shr    $0x1b,%edx
  80364a:	01 d0                	add    %edx,%eax
  80364c:	83 e0 1f             	and    $0x1f,%eax
  80364f:	29 d0                	sub    %edx,%eax
  803651:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803655:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803659:	48 01 ca             	add    %rcx,%rdx
  80365c:	0f b6 0a             	movzbl (%rdx),%ecx
  80365f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803663:	48 98                	cltq   
  803665:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366d:	8b 40 04             	mov    0x4(%rax),%eax
  803670:	8d 50 01             	lea    0x1(%rax),%edx
  803673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803677:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80367a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80367f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803683:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803687:	72 96                	jb     80361f <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80368d:	c9                   	leaveq 
  80368e:	c3                   	retq   

000000000080368f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80368f:	55                   	push   %rbp
  803690:	48 89 e5             	mov    %rsp,%rbp
  803693:	48 83 ec 20          	sub    $0x20,%rsp
  803697:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80369b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80369f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a3:	48 89 c7             	mov    %rax,%rdi
  8036a6:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  8036ad:	00 00 00 
  8036b0:	ff d0                	callq  *%rax
  8036b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8036b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ba:	48 be 7c 49 80 00 00 	movabs $0x80497c,%rsi
  8036c1:	00 00 00 
  8036c4:	48 89 c7             	mov    %rax,%rdi
  8036c7:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  8036ce:	00 00 00 
  8036d1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8036d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d7:	8b 50 04             	mov    0x4(%rax),%edx
  8036da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036de:	8b 00                	mov    (%rax),%eax
  8036e0:	29 c2                	sub    %eax,%edx
  8036e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8036ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036f0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8036f7:	00 00 00 
	stat->st_dev = &devpipe;
  8036fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036fe:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803705:	00 00 00 
  803708:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80370f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803714:	c9                   	leaveq 
  803715:	c3                   	retq   

0000000000803716 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803716:	55                   	push   %rbp
  803717:	48 89 e5             	mov    %rsp,%rbp
  80371a:	48 83 ec 10          	sub    $0x10,%rsp
  80371e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803722:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803726:	48 89 c6             	mov    %rax,%rsi
  803729:	bf 00 00 00 00       	mov    $0x0,%edi
  80372e:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803735:	00 00 00 
  803738:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80373a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373e:	48 89 c7             	mov    %rax,%rdi
  803741:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  803748:	00 00 00 
  80374b:	ff d0                	callq  *%rax
  80374d:	48 89 c6             	mov    %rax,%rsi
  803750:	bf 00 00 00 00       	mov    $0x0,%edi
  803755:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80375c:	00 00 00 
  80375f:	ff d0                	callq  *%rax
}
  803761:	c9                   	leaveq 
  803762:	c3                   	retq   
	...

0000000000803764 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803764:	55                   	push   %rbp
  803765:	48 89 e5             	mov    %rsp,%rbp
  803768:	48 83 ec 20          	sub    $0x20,%rsp
  80376c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80376f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803772:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803775:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803779:	be 01 00 00 00       	mov    $0x1,%esi
  80377e:	48 89 c7             	mov    %rax,%rdi
  803781:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  803788:	00 00 00 
  80378b:	ff d0                	callq  *%rax
}
  80378d:	c9                   	leaveq 
  80378e:	c3                   	retq   

000000000080378f <getchar>:

int
getchar(void)
{
  80378f:	55                   	push   %rbp
  803790:	48 89 e5             	mov    %rsp,%rbp
  803793:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803797:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80379b:	ba 01 00 00 00       	mov    $0x1,%edx
  8037a0:	48 89 c6             	mov    %rax,%rsi
  8037a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a8:	48 b8 80 22 80 00 00 	movabs $0x802280,%rax
  8037af:	00 00 00 
  8037b2:	ff d0                	callq  *%rax
  8037b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8037b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037bb:	79 05                	jns    8037c2 <getchar+0x33>
		return r;
  8037bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c0:	eb 14                	jmp    8037d6 <getchar+0x47>
	if (r < 1)
  8037c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c6:	7f 07                	jg     8037cf <getchar+0x40>
		return -E_EOF;
  8037c8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8037cd:	eb 07                	jmp    8037d6 <getchar+0x47>
	return c;
  8037cf:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8037d3:	0f b6 c0             	movzbl %al,%eax
}
  8037d6:	c9                   	leaveq 
  8037d7:	c3                   	retq   

00000000008037d8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8037d8:	55                   	push   %rbp
  8037d9:	48 89 e5             	mov    %rsp,%rbp
  8037dc:	48 83 ec 20          	sub    $0x20,%rsp
  8037e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ea:	48 89 d6             	mov    %rdx,%rsi
  8037ed:	89 c7                	mov    %eax,%edi
  8037ef:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8037f6:	00 00 00 
  8037f9:	ff d0                	callq  *%rax
  8037fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803802:	79 05                	jns    803809 <iscons+0x31>
		return r;
  803804:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803807:	eb 1a                	jmp    803823 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803809:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380d:	8b 10                	mov    (%rax),%edx
  80380f:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803816:	00 00 00 
  803819:	8b 00                	mov    (%rax),%eax
  80381b:	39 c2                	cmp    %eax,%edx
  80381d:	0f 94 c0             	sete   %al
  803820:	0f b6 c0             	movzbl %al,%eax
}
  803823:	c9                   	leaveq 
  803824:	c3                   	retq   

0000000000803825 <opencons>:

int
opencons(void)
{
  803825:	55                   	push   %rbp
  803826:	48 89 e5             	mov    %rsp,%rbp
  803829:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80382d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803831:	48 89 c7             	mov    %rax,%rdi
  803834:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  80383b:	00 00 00 
  80383e:	ff d0                	callq  *%rax
  803840:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803843:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803847:	79 05                	jns    80384e <opencons+0x29>
		return r;
  803849:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384c:	eb 5b                	jmp    8038a9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80384e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803852:	ba 07 04 00 00       	mov    $0x407,%edx
  803857:	48 89 c6             	mov    %rax,%rsi
  80385a:	bf 00 00 00 00       	mov    $0x0,%edi
  80385f:	48 b8 18 1a 80 00 00 	movabs $0x801a18,%rax
  803866:	00 00 00 
  803869:	ff d0                	callq  *%rax
  80386b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803872:	79 05                	jns    803879 <opencons+0x54>
		return r;
  803874:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803877:	eb 30                	jmp    8038a9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803884:	00 00 00 
  803887:	8b 12                	mov    (%rdx),%edx
  803889:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80388b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80388f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389a:	48 89 c7             	mov    %rax,%rdi
  80389d:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
}
  8038a9:	c9                   	leaveq 
  8038aa:	c3                   	retq   

00000000008038ab <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038ab:	55                   	push   %rbp
  8038ac:	48 89 e5             	mov    %rsp,%rbp
  8038af:	48 83 ec 30          	sub    $0x30,%rsp
  8038b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8038bf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038c4:	75 13                	jne    8038d9 <devcons_read+0x2e>
		return 0;
  8038c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038cb:	eb 49                	jmp    803916 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8038cd:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  8038d4:	00 00 00 
  8038d7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8038d9:	48 b8 1a 19 80 00 00 	movabs $0x80191a,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
  8038e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ec:	74 df                	je     8038cd <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8038ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f2:	79 05                	jns    8038f9 <devcons_read+0x4e>
		return c;
  8038f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f7:	eb 1d                	jmp    803916 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8038f9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8038fd:	75 07                	jne    803906 <devcons_read+0x5b>
		return 0;
  8038ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803904:	eb 10                	jmp    803916 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803906:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803909:	89 c2                	mov    %eax,%edx
  80390b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390f:	88 10                	mov    %dl,(%rax)
	return 1;
  803911:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803916:	c9                   	leaveq 
  803917:	c3                   	retq   

0000000000803918 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803918:	55                   	push   %rbp
  803919:	48 89 e5             	mov    %rsp,%rbp
  80391c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803923:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80392a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803931:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803938:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80393f:	eb 77                	jmp    8039b8 <devcons_write+0xa0>
		m = n - tot;
  803941:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803948:	89 c2                	mov    %eax,%edx
  80394a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394d:	89 d1                	mov    %edx,%ecx
  80394f:	29 c1                	sub    %eax,%ecx
  803951:	89 c8                	mov    %ecx,%eax
  803953:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803956:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803959:	83 f8 7f             	cmp    $0x7f,%eax
  80395c:	76 07                	jbe    803965 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80395e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803965:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803968:	48 63 d0             	movslq %eax,%rdx
  80396b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396e:	48 98                	cltq   
  803970:	48 89 c1             	mov    %rax,%rcx
  803973:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80397a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803981:	48 89 ce             	mov    %rcx,%rsi
  803984:	48 89 c7             	mov    %rax,%rdi
  803987:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  80398e:	00 00 00 
  803991:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803993:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803996:	48 63 d0             	movslq %eax,%rdx
  803999:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039a0:	48 89 d6             	mov    %rdx,%rsi
  8039a3:	48 89 c7             	mov    %rax,%rdi
  8039a6:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  8039ad:	00 00 00 
  8039b0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039b5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8039b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039bb:	48 98                	cltq   
  8039bd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8039c4:	0f 82 77 ff ff ff    	jb     803941 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8039ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039cd:	c9                   	leaveq 
  8039ce:	c3                   	retq   

00000000008039cf <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8039cf:	55                   	push   %rbp
  8039d0:	48 89 e5             	mov    %rsp,%rbp
  8039d3:	48 83 ec 08          	sub    $0x8,%rsp
  8039d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8039db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039e0:	c9                   	leaveq 
  8039e1:	c3                   	retq   

00000000008039e2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8039e2:	55                   	push   %rbp
  8039e3:	48 89 e5             	mov    %rsp,%rbp
  8039e6:	48 83 ec 10          	sub    $0x10,%rsp
  8039ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8039f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f6:	48 be 88 49 80 00 00 	movabs $0x804988,%rsi
  8039fd:	00 00 00 
  803a00:	48 89 c7             	mov    %rax,%rdi
  803a03:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  803a0a:	00 00 00 
  803a0d:	ff d0                	callq  *%rax
	return 0;
  803a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a14:	c9                   	leaveq 
  803a15:	c3                   	retq   
	...

0000000000803a18 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803a18:	55                   	push   %rbp
  803a19:	48 89 e5             	mov    %rsp,%rbp
  803a1c:	53                   	push   %rbx
  803a1d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a24:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803a2b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803a31:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803a38:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803a3f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803a46:	84 c0                	test   %al,%al
  803a48:	74 23                	je     803a6d <_panic+0x55>
  803a4a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803a51:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803a55:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803a59:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803a5d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803a61:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803a65:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803a69:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803a6d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803a74:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803a7b:	00 00 00 
  803a7e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803a85:	00 00 00 
  803a88:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a8c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803a93:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803a9a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803aa1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803aa8:	00 00 00 
  803aab:	48 8b 18             	mov    (%rax),%rbx
  803aae:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  803ab5:	00 00 00 
  803ab8:	ff d0                	callq  *%rax
  803aba:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803ac0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803ac7:	41 89 c8             	mov    %ecx,%r8d
  803aca:	48 89 d1             	mov    %rdx,%rcx
  803acd:	48 89 da             	mov    %rbx,%rdx
  803ad0:	89 c6                	mov    %eax,%esi
  803ad2:	48 bf 90 49 80 00 00 	movabs $0x804990,%rdi
  803ad9:	00 00 00 
  803adc:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae1:	49 b9 0f 05 80 00 00 	movabs $0x80050f,%r9
  803ae8:	00 00 00 
  803aeb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803aee:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803af5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803afc:	48 89 d6             	mov    %rdx,%rsi
  803aff:	48 89 c7             	mov    %rax,%rdi
  803b02:	48 b8 63 04 80 00 00 	movabs $0x800463,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
	cprintf("\n");
  803b0e:	48 bf b3 49 80 00 00 	movabs $0x8049b3,%rdi
  803b15:	00 00 00 
  803b18:	b8 00 00 00 00       	mov    $0x0,%eax
  803b1d:	48 ba 0f 05 80 00 00 	movabs $0x80050f,%rdx
  803b24:	00 00 00 
  803b27:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b29:	cc                   	int3   
  803b2a:	eb fd                	jmp    803b29 <_panic+0x111>

0000000000803b2c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b2c:	55                   	push   %rbp
  803b2d:	48 89 e5             	mov    %rsp,%rbp
  803b30:	48 83 ec 30          	sub    $0x30,%rsp
  803b34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b3c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  803b40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  803b47:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b4c:	74 18                	je     803b66 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  803b4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b52:	48 89 c7             	mov    %rax,%rdi
  803b55:	48 b8 41 1c 80 00 00 	movabs $0x801c41,%rax
  803b5c:	00 00 00 
  803b5f:	ff d0                	callq  *%rax
  803b61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b64:	eb 19                	jmp    803b7f <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  803b66:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  803b6d:	00 00 00 
  803b70:	48 b8 41 1c 80 00 00 	movabs $0x801c41,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
  803b7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  803b7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b83:	79 39                	jns    803bbe <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  803b85:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803b8a:	75 08                	jne    803b94 <ipc_recv+0x68>
  803b8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b90:	8b 00                	mov    (%rax),%eax
  803b92:	eb 05                	jmp    803b99 <ipc_recv+0x6d>
  803b94:	b8 00 00 00 00       	mov    $0x0,%eax
  803b99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b9d:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  803b9f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ba4:	75 08                	jne    803bae <ipc_recv+0x82>
  803ba6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803baa:	8b 00                	mov    (%rax),%eax
  803bac:	eb 05                	jmp    803bb3 <ipc_recv+0x87>
  803bae:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803bb7:	89 02                	mov    %eax,(%rdx)
		return r;
  803bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbc:	eb 53                	jmp    803c11 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  803bbe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803bc3:	74 19                	je     803bde <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  803bc5:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803bcc:	00 00 00 
  803bcf:	48 8b 00             	mov    (%rax),%rax
  803bd2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bdc:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  803bde:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803be3:	74 19                	je     803bfe <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803be5:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803bec:	00 00 00 
  803bef:	48 8b 00             	mov    (%rax),%rax
  803bf2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803bf8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bfc:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  803bfe:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803c05:	00 00 00 
  803c08:	48 8b 00             	mov    (%rax),%rax
  803c0b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  803c11:	c9                   	leaveq 
  803c12:	c3                   	retq   

0000000000803c13 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c13:	55                   	push   %rbp
  803c14:	48 89 e5             	mov    %rsp,%rbp
  803c17:	48 83 ec 30          	sub    $0x30,%rsp
  803c1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c1e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c21:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803c25:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  803c28:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  803c2f:	eb 59                	jmp    803c8a <ipc_send+0x77>
		if(pg) {
  803c31:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c36:	74 20                	je     803c58 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  803c38:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c3b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803c3e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803c42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c45:	89 c7                	mov    %eax,%edi
  803c47:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  803c4e:	00 00 00 
  803c51:	ff d0                	callq  *%rax
  803c53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c56:	eb 26                	jmp    803c7e <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  803c58:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c5b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c61:	89 d1                	mov    %edx,%ecx
  803c63:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  803c6a:	00 00 00 
  803c6d:	89 c7                	mov    %eax,%edi
  803c6f:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  803c76:	00 00 00 
  803c79:	ff d0                	callq  *%rax
  803c7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  803c7e:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  803c85:	00 00 00 
  803c88:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  803c8a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803c8e:	74 a1                	je     803c31 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  803c90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c94:	74 2a                	je     803cc0 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  803c96:	48 ba b8 49 80 00 00 	movabs $0x8049b8,%rdx
  803c9d:	00 00 00 
  803ca0:	be 49 00 00 00       	mov    $0x49,%esi
  803ca5:	48 bf e3 49 80 00 00 	movabs $0x8049e3,%rdi
  803cac:	00 00 00 
  803caf:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb4:	48 b9 18 3a 80 00 00 	movabs $0x803a18,%rcx
  803cbb:	00 00 00 
  803cbe:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  803cc0:	c9                   	leaveq 
  803cc1:	c3                   	retq   

0000000000803cc2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803cc2:	55                   	push   %rbp
  803cc3:	48 89 e5             	mov    %rsp,%rbp
  803cc6:	48 83 ec 18          	sub    $0x18,%rsp
  803cca:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cd4:	eb 6a                	jmp    803d40 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  803cd6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803cdd:	00 00 00 
  803ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce3:	48 63 d0             	movslq %eax,%rdx
  803ce6:	48 89 d0             	mov    %rdx,%rax
  803ce9:	48 c1 e0 02          	shl    $0x2,%rax
  803ced:	48 01 d0             	add    %rdx,%rax
  803cf0:	48 01 c0             	add    %rax,%rax
  803cf3:	48 01 d0             	add    %rdx,%rax
  803cf6:	48 c1 e0 05          	shl    $0x5,%rax
  803cfa:	48 01 c8             	add    %rcx,%rax
  803cfd:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d03:	8b 00                	mov    (%rax),%eax
  803d05:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d08:	75 32                	jne    803d3c <ipc_find_env+0x7a>
			return envs[i].env_id;
  803d0a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d11:	00 00 00 
  803d14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d17:	48 63 d0             	movslq %eax,%rdx
  803d1a:	48 89 d0             	mov    %rdx,%rax
  803d1d:	48 c1 e0 02          	shl    $0x2,%rax
  803d21:	48 01 d0             	add    %rdx,%rax
  803d24:	48 01 c0             	add    %rax,%rax
  803d27:	48 01 d0             	add    %rdx,%rax
  803d2a:	48 c1 e0 05          	shl    $0x5,%rax
  803d2e:	48 01 c8             	add    %rcx,%rax
  803d31:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d37:	8b 40 08             	mov    0x8(%rax),%eax
  803d3a:	eb 12                	jmp    803d4e <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803d3c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d40:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d47:	7e 8d                	jle    803cd6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d4e:	c9                   	leaveq 
  803d4f:	c3                   	retq   

0000000000803d50 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d50:	55                   	push   %rbp
  803d51:	48 89 e5             	mov    %rsp,%rbp
  803d54:	48 83 ec 18          	sub    $0x18,%rsp
  803d58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d60:	48 89 c2             	mov    %rax,%rdx
  803d63:	48 c1 ea 15          	shr    $0x15,%rdx
  803d67:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d6e:	01 00 00 
  803d71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d75:	83 e0 01             	and    $0x1,%eax
  803d78:	48 85 c0             	test   %rax,%rax
  803d7b:	75 07                	jne    803d84 <pageref+0x34>
		return 0;
  803d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d82:	eb 53                	jmp    803dd7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803d84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d88:	48 89 c2             	mov    %rax,%rdx
  803d8b:	48 c1 ea 0c          	shr    $0xc,%rdx
  803d8f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d96:	01 00 00 
  803d99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da5:	83 e0 01             	and    $0x1,%eax
  803da8:	48 85 c0             	test   %rax,%rax
  803dab:	75 07                	jne    803db4 <pageref+0x64>
		return 0;
  803dad:	b8 00 00 00 00       	mov    $0x0,%eax
  803db2:	eb 23                	jmp    803dd7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803db8:	48 89 c2             	mov    %rax,%rdx
  803dbb:	48 c1 ea 0c          	shr    $0xc,%rdx
  803dbf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803dc6:	00 00 00 
  803dc9:	48 c1 e2 04          	shl    $0x4,%rdx
  803dcd:	48 01 d0             	add    %rdx,%rax
  803dd0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803dd4:	0f b7 c0             	movzwl %ax,%eax
}
  803dd7:	c9                   	leaveq 
  803dd8:	c3                   	retq   
  803dd9:	00 00                	add    %al,(%rax)
	...

0000000000803ddc <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  803ddc:	55                   	push   %rbp
  803ddd:	48 89 e5             	mov    %rsp,%rbp
  803de0:	48 83 ec 20          	sub    $0x20,%rsp
  803de4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  803de8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803dec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803df0:	48 89 d6             	mov    %rdx,%rsi
  803df3:	48 89 c7             	mov    %rax,%rdi
  803df6:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  803dfd:	00 00 00 
  803e00:	ff d0                	callq  *%rax
  803e02:	85 c0                	test   %eax,%eax
  803e04:	74 05                	je     803e0b <inet_addr+0x2f>
    return (val.s_addr);
  803e06:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e09:	eb 05                	jmp    803e10 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  803e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803e10:	c9                   	leaveq 
  803e11:	c3                   	retq   

0000000000803e12 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  803e12:	55                   	push   %rbp
  803e13:	48 89 e5             	mov    %rsp,%rbp
  803e16:	53                   	push   %rbx
  803e17:	48 83 ec 48          	sub    $0x48,%rsp
  803e1b:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  803e1f:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  803e23:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803e27:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

  c = *cp;
  803e2b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803e2f:	0f b6 00             	movzbl (%rax),%eax
  803e32:	0f be c0             	movsbl %al,%eax
  803e35:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803e38:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803e3b:	3c 2f                	cmp    $0x2f,%al
  803e3d:	76 07                	jbe    803e46 <inet_aton+0x34>
  803e3f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803e42:	3c 39                	cmp    $0x39,%al
  803e44:	76 0a                	jbe    803e50 <inet_aton+0x3e>
      return (0);
  803e46:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4b:	e9 6a 02 00 00       	jmpq   8040ba <inet_aton+0x2a8>
    val = 0;
  803e50:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    base = 10;
  803e57:	c7 45 e8 0a 00 00 00 	movl   $0xa,-0x18(%rbp)
    if (c == '0') {
  803e5e:	83 7d e4 30          	cmpl   $0x30,-0x1c(%rbp)
  803e62:	75 40                	jne    803ea4 <inet_aton+0x92>
      c = *++cp;
  803e64:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803e69:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803e6d:	0f b6 00             	movzbl (%rax),%eax
  803e70:	0f be c0             	movsbl %al,%eax
  803e73:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if (c == 'x' || c == 'X') {
  803e76:	83 7d e4 78          	cmpl   $0x78,-0x1c(%rbp)
  803e7a:	74 06                	je     803e82 <inet_aton+0x70>
  803e7c:	83 7d e4 58          	cmpl   $0x58,-0x1c(%rbp)
  803e80:	75 1b                	jne    803e9d <inet_aton+0x8b>
        base = 16;
  803e82:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%rbp)
        c = *++cp;
  803e89:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803e8e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803e92:	0f b6 00             	movzbl (%rax),%eax
  803e95:	0f be c0             	movsbl %al,%eax
  803e98:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803e9b:	eb 07                	jmp    803ea4 <inet_aton+0x92>
      } else
        base = 8;
  803e9d:	c7 45 e8 08 00 00 00 	movl   $0x8,-0x18(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  803ea4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ea7:	3c 2f                	cmp    $0x2f,%al
  803ea9:	76 2f                	jbe    803eda <inet_aton+0xc8>
  803eab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803eae:	3c 39                	cmp    $0x39,%al
  803eb0:	77 28                	ja     803eda <inet_aton+0xc8>
        val = (val * base) + (int)(c - '0');
  803eb2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803eb5:	89 c2                	mov    %eax,%edx
  803eb7:	0f af 55 ec          	imul   -0x14(%rbp),%edx
  803ebb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ebe:	01 d0                	add    %edx,%eax
  803ec0:	83 e8 30             	sub    $0x30,%eax
  803ec3:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  803ec6:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803ecb:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803ecf:	0f b6 00             	movzbl (%rax),%eax
  803ed2:	0f be c0             	movsbl %al,%eax
  803ed5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  803ed8:	eb ca                	jmp    803ea4 <inet_aton+0x92>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  803eda:	83 7d e8 10          	cmpl   $0x10,-0x18(%rbp)
  803ede:	75 74                	jne    803f54 <inet_aton+0x142>
  803ee0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ee3:	3c 2f                	cmp    $0x2f,%al
  803ee5:	76 07                	jbe    803eee <inet_aton+0xdc>
  803ee7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803eea:	3c 39                	cmp    $0x39,%al
  803eec:	76 1c                	jbe    803f0a <inet_aton+0xf8>
  803eee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ef1:	3c 60                	cmp    $0x60,%al
  803ef3:	76 07                	jbe    803efc <inet_aton+0xea>
  803ef5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ef8:	3c 66                	cmp    $0x66,%al
  803efa:	76 0e                	jbe    803f0a <inet_aton+0xf8>
  803efc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803eff:	3c 40                	cmp    $0x40,%al
  803f01:	76 51                	jbe    803f54 <inet_aton+0x142>
  803f03:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f06:	3c 46                	cmp    $0x46,%al
  803f08:	77 4a                	ja     803f54 <inet_aton+0x142>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  803f0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f0d:	89 c2                	mov    %eax,%edx
  803f0f:	c1 e2 04             	shl    $0x4,%edx
  803f12:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f15:	8d 48 0a             	lea    0xa(%rax),%ecx
  803f18:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f1b:	3c 60                	cmp    $0x60,%al
  803f1d:	76 0e                	jbe    803f2d <inet_aton+0x11b>
  803f1f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f22:	3c 7a                	cmp    $0x7a,%al
  803f24:	77 07                	ja     803f2d <inet_aton+0x11b>
  803f26:	b8 61 00 00 00       	mov    $0x61,%eax
  803f2b:	eb 05                	jmp    803f32 <inet_aton+0x120>
  803f2d:	b8 41 00 00 00       	mov    $0x41,%eax
  803f32:	89 cb                	mov    %ecx,%ebx
  803f34:	29 c3                	sub    %eax,%ebx
  803f36:	89 d8                	mov    %ebx,%eax
  803f38:	09 d0                	or     %edx,%eax
  803f3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  803f3d:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803f42:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f46:	0f b6 00             	movzbl (%rax),%eax
  803f49:	0f be c0             	movsbl %al,%eax
  803f4c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else
        break;
    }
  803f4f:	e9 50 ff ff ff       	jmpq   803ea4 <inet_aton+0x92>
    if (c == '.') {
  803f54:	83 7d e4 2e          	cmpl   $0x2e,-0x1c(%rbp)
  803f58:	75 3d                	jne    803f97 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803f5a:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803f5e:	48 83 c0 0c          	add    $0xc,%rax
  803f62:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803f66:	72 0a                	jb     803f72 <inet_aton+0x160>
        return (0);
  803f68:	b8 00 00 00 00       	mov    $0x0,%eax
  803f6d:	e9 48 01 00 00       	jmpq   8040ba <inet_aton+0x2a8>
      *pp++ = val;
  803f72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f76:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f79:	89 10                	mov    %edx,(%rax)
  803f7b:	48 83 45 d8 04       	addq   $0x4,-0x28(%rbp)
      c = *++cp;
  803f80:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803f85:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f89:	0f b6 00             	movzbl (%rax),%eax
  803f8c:	0f be c0             	movsbl %al,%eax
  803f8f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    } else
      break;
  }
  803f92:	e9 a1 fe ff ff       	jmpq   803e38 <inet_aton+0x26>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  803f97:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  803f98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803f9c:	74 3c                	je     803fda <inet_aton+0x1c8>
  803f9e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fa1:	3c 1f                	cmp    $0x1f,%al
  803fa3:	76 2b                	jbe    803fd0 <inet_aton+0x1be>
  803fa5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fa8:	84 c0                	test   %al,%al
  803faa:	78 24                	js     803fd0 <inet_aton+0x1be>
  803fac:	83 7d e4 20          	cmpl   $0x20,-0x1c(%rbp)
  803fb0:	74 28                	je     803fda <inet_aton+0x1c8>
  803fb2:	83 7d e4 0c          	cmpl   $0xc,-0x1c(%rbp)
  803fb6:	74 22                	je     803fda <inet_aton+0x1c8>
  803fb8:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  803fbc:	74 1c                	je     803fda <inet_aton+0x1c8>
  803fbe:	83 7d e4 0d          	cmpl   $0xd,-0x1c(%rbp)
  803fc2:	74 16                	je     803fda <inet_aton+0x1c8>
  803fc4:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  803fc8:	74 10                	je     803fda <inet_aton+0x1c8>
  803fca:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%rbp)
  803fce:	74 0a                	je     803fda <inet_aton+0x1c8>
    return (0);
  803fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd5:	e9 e0 00 00 00       	jmpq   8040ba <inet_aton+0x2a8>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  803fda:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803fde:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803fe2:	48 89 d1             	mov    %rdx,%rcx
  803fe5:	48 29 c1             	sub    %rax,%rcx
  803fe8:	48 89 c8             	mov    %rcx,%rax
  803feb:	48 c1 f8 02          	sar    $0x2,%rax
  803fef:	83 c0 01             	add    $0x1,%eax
  803ff2:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  switch (n) {
  803ff5:	83 7d d4 04          	cmpl   $0x4,-0x2c(%rbp)
  803ff9:	0f 87 98 00 00 00    	ja     804097 <inet_aton+0x285>
  803fff:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804002:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804009:	00 
  80400a:	48 b8 f0 49 80 00 00 	movabs $0x8049f0,%rax
  804011:	00 00 00 
  804014:	48 01 d0             	add    %rdx,%rax
  804017:	48 8b 00             	mov    (%rax),%rax
  80401a:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  80401c:	b8 00 00 00 00       	mov    $0x0,%eax
  804021:	e9 94 00 00 00       	jmpq   8040ba <inet_aton+0x2a8>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804026:	81 7d ec ff ff ff 00 	cmpl   $0xffffff,-0x14(%rbp)
  80402d:	76 0a                	jbe    804039 <inet_aton+0x227>
      return (0);
  80402f:	b8 00 00 00 00       	mov    $0x0,%eax
  804034:	e9 81 00 00 00       	jmpq   8040ba <inet_aton+0x2a8>
    val |= parts[0] << 24;
  804039:	8b 45 c0             	mov    -0x40(%rbp),%eax
  80403c:	c1 e0 18             	shl    $0x18,%eax
  80403f:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804042:	eb 53                	jmp    804097 <inet_aton+0x285>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804044:	81 7d ec ff ff 00 00 	cmpl   $0xffff,-0x14(%rbp)
  80404b:	76 07                	jbe    804054 <inet_aton+0x242>
      return (0);
  80404d:	b8 00 00 00 00       	mov    $0x0,%eax
  804052:	eb 66                	jmp    8040ba <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804054:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804057:	89 c2                	mov    %eax,%edx
  804059:	c1 e2 18             	shl    $0x18,%edx
  80405c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80405f:	c1 e0 10             	shl    $0x10,%eax
  804062:	09 d0                	or     %edx,%eax
  804064:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804067:	eb 2e                	jmp    804097 <inet_aton+0x285>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804069:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%rbp)
  804070:	76 07                	jbe    804079 <inet_aton+0x267>
      return (0);
  804072:	b8 00 00 00 00       	mov    $0x0,%eax
  804077:	eb 41                	jmp    8040ba <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804079:	8b 45 c0             	mov    -0x40(%rbp),%eax
  80407c:	89 c2                	mov    %eax,%edx
  80407e:	c1 e2 18             	shl    $0x18,%edx
  804081:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804084:	c1 e0 10             	shl    $0x10,%eax
  804087:	09 c2                	or     %eax,%edx
  804089:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80408c:	c1 e0 08             	shl    $0x8,%eax
  80408f:	09 d0                	or     %edx,%eax
  804091:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804094:	eb 01                	jmp    804097 <inet_aton+0x285>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  804096:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804097:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  80409c:	74 17                	je     8040b5 <inet_aton+0x2a3>
    addr->s_addr = htonl(val);
  80409e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040a1:	89 c7                	mov    %eax,%edi
  8040a3:	48 b8 29 42 80 00 00 	movabs $0x804229,%rax
  8040aa:	00 00 00 
  8040ad:	ff d0                	callq  *%rax
  8040af:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8040b3:	89 02                	mov    %eax,(%rdx)
  return (1);
  8040b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8040ba:	48 83 c4 48          	add    $0x48,%rsp
  8040be:	5b                   	pop    %rbx
  8040bf:	5d                   	pop    %rbp
  8040c0:	c3                   	retq   

00000000008040c1 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8040c1:	55                   	push   %rbp
  8040c2:	48 89 e5             	mov    %rsp,%rbp
  8040c5:	48 83 ec 30          	sub    $0x30,%rsp
  8040c9:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8040cc:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8040cf:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  8040d2:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8040d9:	00 00 00 
  8040dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  8040e0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8040e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  8040e8:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  8040ec:	e9 d1 00 00 00       	jmpq   8041c2 <inet_ntoa+0x101>
    i = 0;
  8040f1:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  8040f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f9:	0f b6 08             	movzbl (%rax),%ecx
  8040fc:	0f b6 d1             	movzbl %cl,%edx
  8040ff:	89 d0                	mov    %edx,%eax
  804101:	c1 e0 02             	shl    $0x2,%eax
  804104:	01 d0                	add    %edx,%eax
  804106:	c1 e0 03             	shl    $0x3,%eax
  804109:	01 d0                	add    %edx,%eax
  80410b:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804112:	01 d0                	add    %edx,%eax
  804114:	66 c1 e8 08          	shr    $0x8,%ax
  804118:	c0 e8 03             	shr    $0x3,%al
  80411b:	88 45 ed             	mov    %al,-0x13(%rbp)
  80411e:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804122:	89 d0                	mov    %edx,%eax
  804124:	c1 e0 02             	shl    $0x2,%eax
  804127:	01 d0                	add    %edx,%eax
  804129:	01 c0                	add    %eax,%eax
  80412b:	89 ca                	mov    %ecx,%edx
  80412d:	28 c2                	sub    %al,%dl
  80412f:	89 d0                	mov    %edx,%eax
  804131:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  804134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804138:	0f b6 00             	movzbl (%rax),%eax
  80413b:	0f b6 d0             	movzbl %al,%edx
  80413e:	89 d0                	mov    %edx,%eax
  804140:	c1 e0 02             	shl    $0x2,%eax
  804143:	01 d0                	add    %edx,%eax
  804145:	c1 e0 03             	shl    $0x3,%eax
  804148:	01 d0                	add    %edx,%eax
  80414a:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804151:	01 d0                	add    %edx,%eax
  804153:	66 c1 e8 08          	shr    $0x8,%ax
  804157:	89 c2                	mov    %eax,%edx
  804159:	c0 ea 03             	shr    $0x3,%dl
  80415c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804160:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804162:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804166:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80416a:	83 c2 30             	add    $0x30,%edx
  80416d:	48 98                	cltq   
  80416f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
  804173:	80 45 ee 01          	addb   $0x1,-0x12(%rbp)
    } while(*ap);
  804177:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80417b:	0f b6 00             	movzbl (%rax),%eax
  80417e:	84 c0                	test   %al,%al
  804180:	0f 85 6f ff ff ff    	jne    8040f5 <inet_ntoa+0x34>
    while(i--)
  804186:	eb 16                	jmp    80419e <inet_ntoa+0xdd>
      *rp++ = inv[i];
  804188:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80418c:	48 98                	cltq   
  80418e:	0f b6 54 05 e0       	movzbl -0x20(%rbp,%rax,1),%edx
  804193:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804197:	88 10                	mov    %dl,(%rax)
  804199:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80419e:	80 7d ee 00          	cmpb   $0x0,-0x12(%rbp)
  8041a2:	0f 95 c0             	setne  %al
  8041a5:	80 6d ee 01          	subb   $0x1,-0x12(%rbp)
  8041a9:	84 c0                	test   %al,%al
  8041ab:	75 db                	jne    804188 <inet_ntoa+0xc7>
      *rp++ = inv[i];
    *rp++ = '.';
  8041ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b1:	c6 00 2e             	movb   $0x2e,(%rax)
  8041b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    ap++;
  8041b9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8041be:	80 45 ef 01          	addb   $0x1,-0x11(%rbp)
  8041c2:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  8041c6:	0f 86 25 ff ff ff    	jbe    8040f1 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  8041cc:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  8041d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d5:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  8041d8:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8041df:	00 00 00 
}
  8041e2:	c9                   	leaveq 
  8041e3:	c3                   	retq   

00000000008041e4 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8041e4:	55                   	push   %rbp
  8041e5:	48 89 e5             	mov    %rsp,%rbp
  8041e8:	48 83 ec 08          	sub    $0x8,%rsp
  8041ec:	89 f8                	mov    %edi,%eax
  8041ee:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8041f2:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8041f6:	c1 e0 08             	shl    $0x8,%eax
  8041f9:	89 c2                	mov    %eax,%edx
  8041fb:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8041ff:	66 c1 e8 08          	shr    $0x8,%ax
  804203:	09 d0                	or     %edx,%eax
}
  804205:	c9                   	leaveq 
  804206:	c3                   	retq   

0000000000804207 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804207:	55                   	push   %rbp
  804208:	48 89 e5             	mov    %rsp,%rbp
  80420b:	48 83 ec 08          	sub    $0x8,%rsp
  80420f:	89 f8                	mov    %edi,%eax
  804211:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  804215:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804219:	89 c7                	mov    %eax,%edi
  80421b:	48 b8 e4 41 80 00 00 	movabs $0x8041e4,%rax
  804222:	00 00 00 
  804225:	ff d0                	callq  *%rax
}
  804227:	c9                   	leaveq 
  804228:	c3                   	retq   

0000000000804229 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  804229:	55                   	push   %rbp
  80422a:	48 89 e5             	mov    %rsp,%rbp
  80422d:	48 83 ec 08          	sub    $0x8,%rsp
  804231:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  804234:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804237:	89 c2                	mov    %eax,%edx
  804239:	c1 e2 18             	shl    $0x18,%edx
    ((n & 0xff00) << 8) |
  80423c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80423f:	25 00 ff 00 00       	and    $0xff00,%eax
  804244:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804247:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  804249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424c:	25 00 00 ff 00       	and    $0xff0000,%eax
  804251:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804255:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  804257:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80425a:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80425d:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80425f:	c9                   	leaveq 
  804260:	c3                   	retq   

0000000000804261 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804261:	55                   	push   %rbp
  804262:	48 89 e5             	mov    %rsp,%rbp
  804265:	48 83 ec 08          	sub    $0x8,%rsp
  804269:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  80426c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80426f:	89 c7                	mov    %eax,%edi
  804271:	48 b8 29 42 80 00 00 	movabs $0x804229,%rax
  804278:	00 00 00 
  80427b:	ff d0                	callq  *%rax
}
  80427d:	c9                   	leaveq 
  80427e:	c3                   	retq   
