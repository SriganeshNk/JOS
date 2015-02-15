
obj/user/echosrv.debug:     file format elf64-x86-64


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
  80003c:	e8 fb 02 00 00       	callq  80033c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

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
  800057:	48 bf a0 42 80 00 00 	movabs $0x8042a0,%rdi
  80005e:	00 00 00 
  800061:	b8 00 00 00 00       	mov    $0x0,%eax
  800066:	48 ba 2f 05 80 00 00 	movabs $0x80052f,%rdx
  80006d:	00 00 00 
  800070:	ff d2                	callq  *%rdx
	exit();
  800072:	48 b8 e4 03 80 00 00 	movabs $0x8003e4,%rax
  800079:	00 00 00 
  80007c:	ff d0                	callq  *%rax
}
  80007e:	c9                   	leaveq 
  80007f:	c3                   	retq   

0000000000800080 <handle_client>:

void
handle_client(int sock)
{
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	48 83 ec 40          	sub    $0x40,%rsp
  800088:	89 7d cc             	mov    %edi,-0x34(%rbp)
	char buffer[BUFFSIZE];
	int received = -1;
  80008b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800092:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800096:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800099:	ba 20 00 00 00       	mov    $0x20,%edx
  80009e:	48 89 ce             	mov    %rcx,%rsi
  8000a1:	89 c7                	mov    %eax,%edi
  8000a3:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b6:	0f 89 8d 00 00 00    	jns    800149 <handle_client+0xc9>
		die("Failed to receive initial bytes from client");
  8000bc:	48 bf a8 42 80 00 00 	movabs $0x8042a8,%rdi
  8000c3:	00 00 00 
  8000c6:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000d2:	eb 75                	jmp    800149 <handle_client+0xc9>
		// Send back received data
		if (write(sock, buffer, received) != received)
  8000d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d7:	48 63 d0             	movslq %eax,%rdx
  8000da:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8000de:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8000e1:	48 89 ce             	mov    %rcx,%rsi
  8000e4:	89 c7                	mov    %eax,%edi
  8000e6:	48 b8 ee 23 80 00 00 	movabs $0x8023ee,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	callq  *%rax
  8000f2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000f5:	74 16                	je     80010d <handle_client+0x8d>
			die("Failed to send bytes to client");
  8000f7:	48 bf d8 42 80 00 00 	movabs $0x8042d8,%rdi
  8000fe:	00 00 00 
  800101:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80010d:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800111:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800114:	ba 20 00 00 00       	mov    $0x20,%edx
  800119:	48 89 ce             	mov    %rcx,%rsi
  80011c:	89 c7                	mov    %eax,%edi
  80011e:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  800125:	00 00 00 
  800128:	ff d0                	callq  *%rax
  80012a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80012d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800131:	79 16                	jns    800149 <handle_client+0xc9>
			die("Failed to receive additional bytes from client");
  800133:	48 bf f8 42 80 00 00 	movabs $0x8042f8,%rdi
  80013a:	00 00 00 
  80013d:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800144:	00 00 00 
  800147:	ff d0                	callq  *%rax
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  800149:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80014d:	7f 85                	jg     8000d4 <handle_client+0x54>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80014f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800152:	89 c7                	mov    %eax,%edi
  800154:	48 b8 7e 20 80 00 00 	movabs $0x80207e,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	callq  *%rax
}
  800160:	c9                   	leaveq 
  800161:	c3                   	retq   

0000000000800162 <umain>:

void
umain(int argc, char **argv)
{
  800162:	55                   	push   %rbp
  800163:	48 89 e5             	mov    %rsp,%rbp
  800166:	48 83 ec 70          	sub    $0x70,%rsp
  80016a:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  80016d:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
	int serversock, clientsock;
	struct sockaddr_in echoserver, echoclient;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  800171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800178:	ba 06 00 00 00       	mov    $0x6,%edx
  80017d:	be 01 00 00 00       	mov    $0x1,%esi
  800182:	bf 02 00 00 00       	mov    $0x2,%edi
  800187:	48 b8 25 2d 80 00 00 	movabs $0x802d25,%rax
  80018e:	00 00 00 
  800191:	ff d0                	callq  *%rax
  800193:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800196:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80019a:	79 16                	jns    8001b2 <umain+0x50>
		die("Failed to create socket");
  80019c:	48 bf 27 43 80 00 00 	movabs $0x804327,%rdi
  8001a3:	00 00 00 
  8001a6:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  8001b2:	48 bf 3f 43 80 00 00 	movabs $0x80433f,%rdi
  8001b9:	00 00 00 
  8001bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c1:	48 ba 2f 05 80 00 00 	movabs $0x80052f,%rdx
  8001c8:	00 00 00 
  8001cb:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8001cd:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001d1:	ba 10 00 00 00       	mov    $0x10,%edx
  8001d6:	be 00 00 00 00       	mov    $0x0,%esi
  8001db:	48 89 c7             	mov    %rax,%rdi
  8001de:	48 b8 97 13 80 00 00 	movabs $0x801397,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8001ea:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  8001ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f3:	48 b8 49 42 80 00 00 	movabs $0x804249,%rax
  8001fa:	00 00 00 
  8001fd:	ff d0                	callq  *%rax
  8001ff:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  800202:	bf 07 00 00 00       	mov    $0x7,%edi
  800207:	48 b8 04 42 80 00 00 	movabs $0x804204,%rax
  80020e:	00 00 00 
  800211:	ff d0                	callq  *%rax
  800213:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to bind\n");
  800217:	48 bf 4e 43 80 00 00 	movabs $0x80434e,%rdi
  80021e:	00 00 00 
  800221:	b8 00 00 00 00       	mov    $0x0,%eax
  800226:	48 ba 2f 05 80 00 00 	movabs $0x80052f,%rdx
  80022d:	00 00 00 
  800230:	ff d2                	callq  *%rdx

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800232:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800236:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800239:	ba 10 00 00 00       	mov    $0x10,%edx
  80023e:	48 89 ce             	mov    %rcx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 15 2b 80 00 00 	movabs $0x802b15,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	85 c0                	test   %eax,%eax
  800251:	79 16                	jns    800269 <umain+0x107>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800253:	48 bf 60 43 80 00 00 	movabs $0x804360,%rdi
  80025a:	00 00 00 
  80025d:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800269:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80026c:	be 05 00 00 00       	mov    $0x5,%esi
  800271:	89 c7                	mov    %eax,%edi
  800273:	48 b8 38 2c 80 00 00 	movabs $0x802c38,%rax
  80027a:	00 00 00 
  80027d:	ff d0                	callq  *%rax
  80027f:	85 c0                	test   %eax,%eax
  800281:	79 16                	jns    800299 <umain+0x137>
		die("Failed to listen on server socket");
  800283:	48 bf 88 43 80 00 00 	movabs $0x804388,%rdi
  80028a:	00 00 00 
  80028d:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800294:	00 00 00 
  800297:	ff d0                	callq  *%rax

	cprintf("bound\n");
  800299:	48 bf aa 43 80 00 00 	movabs $0x8043aa,%rdi
  8002a0:	00 00 00 
  8002a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a8:	48 ba 2f 05 80 00 00 	movabs $0x80052f,%rdx
  8002af:	00 00 00 
  8002b2:	ff d2                	callq  *%rdx

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8002b4:	c7 45 ac 10 00 00 00 	movl   $0x10,-0x54(%rbp)
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
  8002bb:	48 8d 55 ac          	lea    -0x54(%rbp),%rdx
	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
  8002bf:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  8002c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c6:	48 89 ce             	mov    %rcx,%rsi
  8002c9:	89 c7                	mov    %eax,%edi
  8002cb:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	callq  *%rax
  8002d7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002da:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002de:	79 16                	jns    8002f6 <umain+0x194>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8002e0:	48 bf b8 43 80 00 00 	movabs $0x8043b8,%rdi
  8002e7:	00 00 00 
  8002ea:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8002f1:	00 00 00 
  8002f4:	ff d0                	callq  *%rax
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8002f6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8002f9:	89 c7                	mov    %eax,%edi
  8002fb:	48 b8 e1 40 80 00 00 	movabs $0x8040e1,%rax
  800302:	00 00 00 
  800305:	ff d0                	callq  *%rax
  800307:	48 89 c6             	mov    %rax,%rsi
  80030a:	48 bf db 43 80 00 00 	movabs $0x8043db,%rdi
  800311:	00 00 00 
  800314:	b8 00 00 00 00       	mov    $0x0,%eax
  800319:	48 ba 2f 05 80 00 00 	movabs $0x80052f,%rdx
  800320:	00 00 00 
  800323:	ff d2                	callq  *%rdx
		handle_client(clientsock);
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	89 c7                	mov    %eax,%edi
  80032a:	48 b8 80 00 80 00 00 	movabs $0x800080,%rax
  800331:	00 00 00 
  800334:	ff d0                	callq  *%rax
	}
  800336:	e9 79 ff ff ff       	jmpq   8002b4 <umain+0x152>
	...

000000000080033c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033c:	55                   	push   %rbp
  80033d:	48 89 e5             	mov    %rsp,%rbp
  800340:	48 83 ec 10          	sub    $0x10,%rsp
  800344:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800347:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80034b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800352:	00 00 00 
  800355:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  80035c:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  800363:	00 00 00 
  800366:	ff d0                	callq  *%rax
  800368:	48 98                	cltq   
  80036a:	48 89 c2             	mov    %rax,%rdx
  80036d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800373:	48 89 d0             	mov    %rdx,%rax
  800376:	48 c1 e0 02          	shl    $0x2,%rax
  80037a:	48 01 d0             	add    %rdx,%rax
  80037d:	48 01 c0             	add    %rax,%rax
  800380:	48 01 d0             	add    %rdx,%rax
  800383:	48 c1 e0 05          	shl    $0x5,%rax
  800387:	48 89 c2             	mov    %rax,%rdx
  80038a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800391:	00 00 00 
  800394:	48 01 c2             	add    %rax,%rdx
  800397:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80039e:	00 00 00 
  8003a1:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003a8:	7e 14                	jle    8003be <libmain+0x82>
		binaryname = argv[0];
  8003aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ae:	48 8b 10             	mov    (%rax),%rdx
  8003b1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003b8:	00 00 00 
  8003bb:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c5:	48 89 d6             	mov    %rdx,%rsi
  8003c8:	89 c7                	mov    %eax,%edi
  8003ca:	48 b8 62 01 80 00 00 	movabs $0x800162,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003d6:	48 b8 e4 03 80 00 00 	movabs $0x8003e4,%rax
  8003dd:	00 00 00 
  8003e0:	ff d0                	callq  *%rax
}
  8003e2:	c9                   	leaveq 
  8003e3:	c3                   	retq   

00000000008003e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e4:	55                   	push   %rbp
  8003e5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003e8:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8003f9:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  800400:	00 00 00 
  800403:	ff d0                	callq  *%rax
}
  800405:	5d                   	pop    %rbp
  800406:	c3                   	retq   
	...

0000000000800408 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp
  80040c:	48 83 ec 10          	sub    $0x10,%rsp
  800410:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800413:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041b:	8b 00                	mov    (%rax),%eax
  80041d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800420:	89 d6                	mov    %edx,%esi
  800422:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800426:	48 63 d0             	movslq %eax,%rdx
  800429:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80042e:	8d 50 01             	lea    0x1(%rax),%edx
  800431:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800435:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043b:	8b 00                	mov    (%rax),%eax
  80043d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800442:	75 2c                	jne    800470 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800444:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800448:	8b 00                	mov    (%rax),%eax
  80044a:	48 98                	cltq   
  80044c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800450:	48 83 c2 08          	add    $0x8,%rdx
  800454:	48 89 c6             	mov    %rax,%rsi
  800457:	48 89 d7             	mov    %rdx,%rdi
  80045a:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  800461:	00 00 00 
  800464:	ff d0                	callq  *%rax
        b->idx = 0;
  800466:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800474:	8b 40 04             	mov    0x4(%rax),%eax
  800477:	8d 50 01             	lea    0x1(%rax),%edx
  80047a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800481:	c9                   	leaveq 
  800482:	c3                   	retq   

0000000000800483 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800483:	55                   	push   %rbp
  800484:	48 89 e5             	mov    %rsp,%rbp
  800487:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80048e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800495:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80049c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004a3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004aa:	48 8b 0a             	mov    (%rdx),%rcx
  8004ad:	48 89 08             	mov    %rcx,(%rax)
  8004b0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004b4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004b8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004bc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004c7:	00 00 00 
    b.cnt = 0;
  8004ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004d4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004db:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004e2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004e9:	48 89 c6             	mov    %rax,%rsi
  8004ec:	48 bf 08 04 80 00 00 	movabs $0x800408,%rdi
  8004f3:	00 00 00 
  8004f6:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800502:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800508:	48 98                	cltq   
  80050a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800511:	48 83 c2 08          	add    $0x8,%rdx
  800515:	48 89 c6             	mov    %rax,%rsi
  800518:	48 89 d7             	mov    %rdx,%rdi
  80051b:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  800522:	00 00 00 
  800525:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800527:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80052d:	c9                   	leaveq 
  80052e:	c3                   	retq   

000000000080052f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80052f:	55                   	push   %rbp
  800530:	48 89 e5             	mov    %rsp,%rbp
  800533:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80053a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800541:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800548:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80054f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800556:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80055d:	84 c0                	test   %al,%al
  80055f:	74 20                	je     800581 <cprintf+0x52>
  800561:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800565:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800569:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80056d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800571:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800575:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800579:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80057d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800581:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800588:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80058f:	00 00 00 
  800592:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800599:	00 00 00 
  80059c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005a7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005ae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005b5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005bc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005c3:	48 8b 0a             	mov    (%rdx),%rcx
  8005c6:	48 89 08             	mov    %rcx,(%rax)
  8005c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005d9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005e0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e7:	48 89 d6             	mov    %rdx,%rsi
  8005ea:	48 89 c7             	mov    %rax,%rdi
  8005ed:	48 b8 83 04 80 00 00 	movabs $0x800483,%rax
  8005f4:	00 00 00 
  8005f7:	ff d0                	callq  *%rax
  8005f9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005ff:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800605:	c9                   	leaveq 
  800606:	c3                   	retq   
	...

0000000000800608 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800608:	55                   	push   %rbp
  800609:	48 89 e5             	mov    %rsp,%rbp
  80060c:	48 83 ec 30          	sub    $0x30,%rsp
  800610:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800614:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800618:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80061c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80061f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800623:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800627:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80062a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80062e:	77 52                	ja     800682 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800630:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800633:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800637:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80063a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	ba 00 00 00 00       	mov    $0x0,%edx
  800647:	48 f7 75 d0          	divq   -0x30(%rbp)
  80064b:	48 89 c2             	mov    %rax,%rdx
  80064e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800651:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800654:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80065c:	41 89 f9             	mov    %edi,%r9d
  80065f:	48 89 c7             	mov    %rax,%rdi
  800662:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800669:	00 00 00 
  80066c:	ff d0                	callq  *%rax
  80066e:	eb 1c                	jmp    80068c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800670:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800674:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800677:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80067b:	48 89 d6             	mov    %rdx,%rsi
  80067e:	89 c7                	mov    %eax,%edi
  800680:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800682:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800686:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80068a:	7f e4                	jg     800670 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	ba 00 00 00 00       	mov    $0x0,%edx
  800698:	48 f7 f1             	div    %rcx
  80069b:	48 89 d0             	mov    %rdx,%rax
  80069e:	48 ba f0 45 80 00 00 	movabs $0x8045f0,%rdx
  8006a5:	00 00 00 
  8006a8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006ac:	0f be c0             	movsbl %al,%eax
  8006af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006b3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8006b7:	48 89 d6             	mov    %rdx,%rsi
  8006ba:	89 c7                	mov    %eax,%edi
  8006bc:	ff d1                	callq  *%rcx
}
  8006be:	c9                   	leaveq 
  8006bf:	c3                   	retq   

00000000008006c0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c0:	55                   	push   %rbp
  8006c1:	48 89 e5             	mov    %rsp,%rbp
  8006c4:	48 83 ec 20          	sub    $0x20,%rsp
  8006c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006cf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006d3:	7e 52                	jle    800727 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d9:	8b 00                	mov    (%rax),%eax
  8006db:	83 f8 30             	cmp    $0x30,%eax
  8006de:	73 24                	jae    800704 <getuint+0x44>
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	8b 00                	mov    (%rax),%eax
  8006ee:	89 c0                	mov    %eax,%eax
  8006f0:	48 01 d0             	add    %rdx,%rax
  8006f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f7:	8b 12                	mov    (%rdx),%edx
  8006f9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800700:	89 0a                	mov    %ecx,(%rdx)
  800702:	eb 17                	jmp    80071b <getuint+0x5b>
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070c:	48 89 d0             	mov    %rdx,%rax
  80070f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800713:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800717:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071b:	48 8b 00             	mov    (%rax),%rax
  80071e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800722:	e9 a3 00 00 00       	jmpq   8007ca <getuint+0x10a>
	else if (lflag)
  800727:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80072b:	74 4f                	je     80077c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80072d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800731:	8b 00                	mov    (%rax),%eax
  800733:	83 f8 30             	cmp    $0x30,%eax
  800736:	73 24                	jae    80075c <getuint+0x9c>
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	8b 00                	mov    (%rax),%eax
  800746:	89 c0                	mov    %eax,%eax
  800748:	48 01 d0             	add    %rdx,%rax
  80074b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074f:	8b 12                	mov    (%rdx),%edx
  800751:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800754:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800758:	89 0a                	mov    %ecx,(%rdx)
  80075a:	eb 17                	jmp    800773 <getuint+0xb3>
  80075c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800760:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800764:	48 89 d0             	mov    %rdx,%rax
  800767:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800773:	48 8b 00             	mov    (%rax),%rax
  800776:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077a:	eb 4e                	jmp    8007ca <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	8b 00                	mov    (%rax),%eax
  800782:	83 f8 30             	cmp    $0x30,%eax
  800785:	73 24                	jae    8007ab <getuint+0xeb>
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	8b 00                	mov    (%rax),%eax
  800795:	89 c0                	mov    %eax,%eax
  800797:	48 01 d0             	add    %rdx,%rax
  80079a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079e:	8b 12                	mov    (%rdx),%edx
  8007a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a7:	89 0a                	mov    %ecx,(%rdx)
  8007a9:	eb 17                	jmp    8007c2 <getuint+0x102>
  8007ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b3:	48 89 d0             	mov    %rdx,%rax
  8007b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c2:	8b 00                	mov    (%rax),%eax
  8007c4:	89 c0                	mov    %eax,%eax
  8007c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007ce:	c9                   	leaveq 
  8007cf:	c3                   	retq   

00000000008007d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d0:	55                   	push   %rbp
  8007d1:	48 89 e5             	mov    %rsp,%rbp
  8007d4:	48 83 ec 20          	sub    $0x20,%rsp
  8007d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007df:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e3:	7e 52                	jle    800837 <getint+0x67>
		x=va_arg(*ap, long long);
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	8b 00                	mov    (%rax),%eax
  8007eb:	83 f8 30             	cmp    $0x30,%eax
  8007ee:	73 24                	jae    800814 <getint+0x44>
  8007f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fc:	8b 00                	mov    (%rax),%eax
  8007fe:	89 c0                	mov    %eax,%eax
  800800:	48 01 d0             	add    %rdx,%rax
  800803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800807:	8b 12                	mov    (%rdx),%edx
  800809:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800810:	89 0a                	mov    %ecx,(%rdx)
  800812:	eb 17                	jmp    80082b <getint+0x5b>
  800814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800818:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081c:	48 89 d0             	mov    %rdx,%rax
  80081f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800823:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800827:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082b:	48 8b 00             	mov    (%rax),%rax
  80082e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800832:	e9 a3 00 00 00       	jmpq   8008da <getint+0x10a>
	else if (lflag)
  800837:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083b:	74 4f                	je     80088c <getint+0xbc>
		x=va_arg(*ap, long);
  80083d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800841:	8b 00                	mov    (%rax),%eax
  800843:	83 f8 30             	cmp    $0x30,%eax
  800846:	73 24                	jae    80086c <getint+0x9c>
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	8b 00                	mov    (%rax),%eax
  800856:	89 c0                	mov    %eax,%eax
  800858:	48 01 d0             	add    %rdx,%rax
  80085b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085f:	8b 12                	mov    (%rdx),%edx
  800861:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800864:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800868:	89 0a                	mov    %ecx,(%rdx)
  80086a:	eb 17                	jmp    800883 <getint+0xb3>
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800874:	48 89 d0             	mov    %rdx,%rax
  800877:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800883:	48 8b 00             	mov    (%rax),%rax
  800886:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088a:	eb 4e                	jmp    8008da <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80088c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800890:	8b 00                	mov    (%rax),%eax
  800892:	83 f8 30             	cmp    $0x30,%eax
  800895:	73 24                	jae    8008bb <getint+0xeb>
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	8b 00                	mov    (%rax),%eax
  8008a5:	89 c0                	mov    %eax,%eax
  8008a7:	48 01 d0             	add    %rdx,%rax
  8008aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ae:	8b 12                	mov    (%rdx),%edx
  8008b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b7:	89 0a                	mov    %ecx,(%rdx)
  8008b9:	eb 17                	jmp    8008d2 <getint+0x102>
  8008bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c3:	48 89 d0             	mov    %rdx,%rax
  8008c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d2:	8b 00                	mov    (%rax),%eax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008de:	c9                   	leaveq 
  8008df:	c3                   	retq   

00000000008008e0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e0:	55                   	push   %rbp
  8008e1:	48 89 e5             	mov    %rsp,%rbp
  8008e4:	41 54                	push   %r12
  8008e6:	53                   	push   %rbx
  8008e7:	48 83 ec 60          	sub    $0x60,%rsp
  8008eb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008ef:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008f3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008fb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008ff:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800903:	48 8b 0a             	mov    (%rdx),%rcx
  800906:	48 89 08             	mov    %rcx,(%rax)
  800909:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80090d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800911:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800915:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800919:	eb 17                	jmp    800932 <vprintfmt+0x52>
			if (ch == '\0')
  80091b:	85 db                	test   %ebx,%ebx
  80091d:	0f 84 ea 04 00 00    	je     800e0d <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800923:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800927:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80092b:	48 89 c6             	mov    %rax,%rsi
  80092e:	89 df                	mov    %ebx,%edi
  800930:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800932:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800936:	0f b6 00             	movzbl (%rax),%eax
  800939:	0f b6 d8             	movzbl %al,%ebx
  80093c:	83 fb 25             	cmp    $0x25,%ebx
  80093f:	0f 95 c0             	setne  %al
  800942:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800947:	84 c0                	test   %al,%al
  800949:	75 d0                	jne    80091b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80094f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800956:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80095d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800964:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80096b:	eb 04                	jmp    800971 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80096d:	90                   	nop
  80096e:	eb 01                	jmp    800971 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800970:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800971:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800975:	0f b6 00             	movzbl (%rax),%eax
  800978:	0f b6 d8             	movzbl %al,%ebx
  80097b:	89 d8                	mov    %ebx,%eax
  80097d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800982:	83 e8 23             	sub    $0x23,%eax
  800985:	83 f8 55             	cmp    $0x55,%eax
  800988:	0f 87 4b 04 00 00    	ja     800dd9 <vprintfmt+0x4f9>
  80098e:	89 c0                	mov    %eax,%eax
  800990:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800997:	00 
  800998:	48 b8 18 46 80 00 00 	movabs $0x804618,%rax
  80099f:	00 00 00 
  8009a2:	48 01 d0             	add    %rdx,%rax
  8009a5:	48 8b 00             	mov    (%rax),%rax
  8009a8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009aa:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009ae:	eb c1                	jmp    800971 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009b4:	eb bb                	jmp    800971 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009bd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	c1 e0 02             	shl    $0x2,%eax
  8009c5:	01 d0                	add    %edx,%eax
  8009c7:	01 c0                	add    %eax,%eax
  8009c9:	01 d8                	add    %ebx,%eax
  8009cb:	83 e8 30             	sub    $0x30,%eax
  8009ce:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d5:	0f b6 00             	movzbl (%rax),%eax
  8009d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009db:	83 fb 2f             	cmp    $0x2f,%ebx
  8009de:	7e 63                	jle    800a43 <vprintfmt+0x163>
  8009e0:	83 fb 39             	cmp    $0x39,%ebx
  8009e3:	7f 5e                	jg     800a43 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ea:	eb d1                	jmp    8009bd <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8009ec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ef:	83 f8 30             	cmp    $0x30,%eax
  8009f2:	73 17                	jae    800a0b <vprintfmt+0x12b>
  8009f4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fb:	89 c0                	mov    %eax,%eax
  8009fd:	48 01 d0             	add    %rdx,%rax
  800a00:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a03:	83 c2 08             	add    $0x8,%edx
  800a06:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a09:	eb 0f                	jmp    800a1a <vprintfmt+0x13a>
  800a0b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0f:	48 89 d0             	mov    %rdx,%rax
  800a12:	48 83 c2 08          	add    $0x8,%rdx
  800a16:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1a:	8b 00                	mov    (%rax),%eax
  800a1c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a1f:	eb 23                	jmp    800a44 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800a21:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a25:	0f 89 42 ff ff ff    	jns    80096d <vprintfmt+0x8d>
				width = 0;
  800a2b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a32:	e9 36 ff ff ff       	jmpq   80096d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800a37:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a3e:	e9 2e ff ff ff       	jmpq   800971 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a43:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a44:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a48:	0f 89 22 ff ff ff    	jns    800970 <vprintfmt+0x90>
				width = precision, precision = -1;
  800a4e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a51:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a54:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a5b:	e9 10 ff ff ff       	jmpq   800970 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a60:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a64:	e9 08 ff ff ff       	jmpq   800971 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6c:	83 f8 30             	cmp    $0x30,%eax
  800a6f:	73 17                	jae    800a88 <vprintfmt+0x1a8>
  800a71:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a78:	89 c0                	mov    %eax,%eax
  800a7a:	48 01 d0             	add    %rdx,%rax
  800a7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a80:	83 c2 08             	add    $0x8,%edx
  800a83:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a86:	eb 0f                	jmp    800a97 <vprintfmt+0x1b7>
  800a88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8c:	48 89 d0             	mov    %rdx,%rax
  800a8f:	48 83 c2 08          	add    $0x8,%rdx
  800a93:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a97:	8b 00                	mov    (%rax),%eax
  800a99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800aa1:	48 89 d6             	mov    %rdx,%rsi
  800aa4:	89 c7                	mov    %eax,%edi
  800aa6:	ff d1                	callq  *%rcx
			break;
  800aa8:	e9 5a 03 00 00       	jmpq   800e07 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800aad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab0:	83 f8 30             	cmp    $0x30,%eax
  800ab3:	73 17                	jae    800acc <vprintfmt+0x1ec>
  800ab5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abc:	89 c0                	mov    %eax,%eax
  800abe:	48 01 d0             	add    %rdx,%rax
  800ac1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac4:	83 c2 08             	add    $0x8,%edx
  800ac7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aca:	eb 0f                	jmp    800adb <vprintfmt+0x1fb>
  800acc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad0:	48 89 d0             	mov    %rdx,%rax
  800ad3:	48 83 c2 08          	add    $0x8,%rdx
  800ad7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800adb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800add:	85 db                	test   %ebx,%ebx
  800adf:	79 02                	jns    800ae3 <vprintfmt+0x203>
				err = -err;
  800ae1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ae3:	83 fb 15             	cmp    $0x15,%ebx
  800ae6:	7f 16                	jg     800afe <vprintfmt+0x21e>
  800ae8:	48 b8 40 45 80 00 00 	movabs $0x804540,%rax
  800aef:	00 00 00 
  800af2:	48 63 d3             	movslq %ebx,%rdx
  800af5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800af9:	4d 85 e4             	test   %r12,%r12
  800afc:	75 2e                	jne    800b2c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800afe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b06:	89 d9                	mov    %ebx,%ecx
  800b08:	48 ba 01 46 80 00 00 	movabs $0x804601,%rdx
  800b0f:	00 00 00 
  800b12:	48 89 c7             	mov    %rax,%rdi
  800b15:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1a:	49 b8 17 0e 80 00 00 	movabs $0x800e17,%r8
  800b21:	00 00 00 
  800b24:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b27:	e9 db 02 00 00       	jmpq   800e07 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b2c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b34:	4c 89 e1             	mov    %r12,%rcx
  800b37:	48 ba 0a 46 80 00 00 	movabs $0x80460a,%rdx
  800b3e:	00 00 00 
  800b41:	48 89 c7             	mov    %rax,%rdi
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	49 b8 17 0e 80 00 00 	movabs $0x800e17,%r8
  800b50:	00 00 00 
  800b53:	41 ff d0             	callq  *%r8
			break;
  800b56:	e9 ac 02 00 00       	jmpq   800e07 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5e:	83 f8 30             	cmp    $0x30,%eax
  800b61:	73 17                	jae    800b7a <vprintfmt+0x29a>
  800b63:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6a:	89 c0                	mov    %eax,%eax
  800b6c:	48 01 d0             	add    %rdx,%rax
  800b6f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b72:	83 c2 08             	add    $0x8,%edx
  800b75:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b78:	eb 0f                	jmp    800b89 <vprintfmt+0x2a9>
  800b7a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b7e:	48 89 d0             	mov    %rdx,%rax
  800b81:	48 83 c2 08          	add    $0x8,%rdx
  800b85:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b89:	4c 8b 20             	mov    (%rax),%r12
  800b8c:	4d 85 e4             	test   %r12,%r12
  800b8f:	75 0a                	jne    800b9b <vprintfmt+0x2bb>
				p = "(null)";
  800b91:	49 bc 0d 46 80 00 00 	movabs $0x80460d,%r12
  800b98:	00 00 00 
			if (width > 0 && padc != '-')
  800b9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9f:	7e 7a                	jle    800c1b <vprintfmt+0x33b>
  800ba1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ba5:	74 74                	je     800c1b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800baa:	48 98                	cltq   
  800bac:	48 89 c6             	mov    %rax,%rsi
  800baf:	4c 89 e7             	mov    %r12,%rdi
  800bb2:	48 b8 c2 10 80 00 00 	movabs $0x8010c2,%rax
  800bb9:	00 00 00 
  800bbc:	ff d0                	callq  *%rax
  800bbe:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bc1:	eb 17                	jmp    800bda <vprintfmt+0x2fa>
					putch(padc, putdat);
  800bc3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800bc7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bcb:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800bcf:	48 89 d6             	mov    %rdx,%rsi
  800bd2:	89 c7                	mov    %eax,%edi
  800bd4:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bda:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bde:	7f e3                	jg     800bc3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be0:	eb 39                	jmp    800c1b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800be2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800be6:	74 1e                	je     800c06 <vprintfmt+0x326>
  800be8:	83 fb 1f             	cmp    $0x1f,%ebx
  800beb:	7e 05                	jle    800bf2 <vprintfmt+0x312>
  800bed:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf0:	7e 14                	jle    800c06 <vprintfmt+0x326>
					putch('?', putdat);
  800bf2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bf6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bfa:	48 89 c6             	mov    %rax,%rsi
  800bfd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c02:	ff d2                	callq  *%rdx
  800c04:	eb 0f                	jmp    800c15 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c06:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c0a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c0e:	48 89 c6             	mov    %rax,%rsi
  800c11:	89 df                	mov    %ebx,%edi
  800c13:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c15:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c19:	eb 01                	jmp    800c1c <vprintfmt+0x33c>
  800c1b:	90                   	nop
  800c1c:	41 0f b6 04 24       	movzbl (%r12),%eax
  800c21:	0f be d8             	movsbl %al,%ebx
  800c24:	85 db                	test   %ebx,%ebx
  800c26:	0f 95 c0             	setne  %al
  800c29:	49 83 c4 01          	add    $0x1,%r12
  800c2d:	84 c0                	test   %al,%al
  800c2f:	74 28                	je     800c59 <vprintfmt+0x379>
  800c31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c35:	78 ab                	js     800be2 <vprintfmt+0x302>
  800c37:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c3b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c3f:	79 a1                	jns    800be2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c41:	eb 16                	jmp    800c59 <vprintfmt+0x379>
				putch(' ', putdat);
  800c43:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c47:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c4b:	48 89 c6             	mov    %rax,%rsi
  800c4e:	bf 20 00 00 00       	mov    $0x20,%edi
  800c53:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c55:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c59:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5d:	7f e4                	jg     800c43 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c5f:	e9 a3 01 00 00       	jmpq   800e07 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c68:	be 03 00 00 00       	mov    $0x3,%esi
  800c6d:	48 89 c7             	mov    %rax,%rdi
  800c70:	48 b8 d0 07 80 00 00 	movabs $0x8007d0,%rax
  800c77:	00 00 00 
  800c7a:	ff d0                	callq  *%rax
  800c7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c84:	48 85 c0             	test   %rax,%rax
  800c87:	79 1d                	jns    800ca6 <vprintfmt+0x3c6>
				putch('-', putdat);
  800c89:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c8d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c91:	48 89 c6             	mov    %rax,%rsi
  800c94:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c99:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9f:	48 f7 d8             	neg    %rax
  800ca2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ca6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cad:	e9 e8 00 00 00       	jmpq   800d9a <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cb2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb6:	be 03 00 00 00       	mov    $0x3,%esi
  800cbb:	48 89 c7             	mov    %rax,%rdi
  800cbe:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  800cc5:	00 00 00 
  800cc8:	ff d0                	callq  *%rax
  800cca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cce:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cd5:	e9 c0 00 00 00       	jmpq   800d9a <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cda:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cde:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ce2:	48 89 c6             	mov    %rax,%rsi
  800ce5:	bf 58 00 00 00       	mov    $0x58,%edi
  800cea:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800cec:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cf0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cf4:	48 89 c6             	mov    %rax,%rsi
  800cf7:	bf 58 00 00 00       	mov    $0x58,%edi
  800cfc:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800cfe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d02:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d06:	48 89 c6             	mov    %rax,%rsi
  800d09:	bf 58 00 00 00       	mov    $0x58,%edi
  800d0e:	ff d2                	callq  *%rdx
			break;
  800d10:	e9 f2 00 00 00       	jmpq   800e07 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800d15:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d19:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d1d:	48 89 c6             	mov    %rax,%rsi
  800d20:	bf 30 00 00 00       	mov    $0x30,%edi
  800d25:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800d27:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d2b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d2f:	48 89 c6             	mov    %rax,%rsi
  800d32:	bf 78 00 00 00       	mov    $0x78,%edi
  800d37:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3c:	83 f8 30             	cmp    $0x30,%eax
  800d3f:	73 17                	jae    800d58 <vprintfmt+0x478>
  800d41:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d48:	89 c0                	mov    %eax,%eax
  800d4a:	48 01 d0             	add    %rdx,%rax
  800d4d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d50:	83 c2 08             	add    $0x8,%edx
  800d53:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d56:	eb 0f                	jmp    800d67 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800d58:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d5c:	48 89 d0             	mov    %rdx,%rax
  800d5f:	48 83 c2 08          	add    $0x8,%rdx
  800d63:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d67:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d6e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d75:	eb 23                	jmp    800d9a <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d77:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d7b:	be 03 00 00 00       	mov    $0x3,%esi
  800d80:	48 89 c7             	mov    %rax,%rdi
  800d83:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  800d8a:	00 00 00 
  800d8d:	ff d0                	callq  *%rax
  800d8f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d93:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d9a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d9f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800da2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800da5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db1:	45 89 c1             	mov    %r8d,%r9d
  800db4:	41 89 f8             	mov    %edi,%r8d
  800db7:	48 89 c7             	mov    %rax,%rdi
  800dba:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800dc1:	00 00 00 
  800dc4:	ff d0                	callq  *%rax
			break;
  800dc6:	eb 3f                	jmp    800e07 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dcc:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dd0:	48 89 c6             	mov    %rax,%rsi
  800dd3:	89 df                	mov    %ebx,%edi
  800dd5:	ff d2                	callq  *%rdx
			break;
  800dd7:	eb 2e                	jmp    800e07 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ddd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800de1:	48 89 c6             	mov    %rax,%rsi
  800de4:	bf 25 00 00 00       	mov    $0x25,%edi
  800de9:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800deb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800df0:	eb 05                	jmp    800df7 <vprintfmt+0x517>
  800df2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800df7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dfb:	48 83 e8 01          	sub    $0x1,%rax
  800dff:	0f b6 00             	movzbl (%rax),%eax
  800e02:	3c 25                	cmp    $0x25,%al
  800e04:	75 ec                	jne    800df2 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800e06:	90                   	nop
		}
	}
  800e07:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e08:	e9 25 fb ff ff       	jmpq   800932 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800e0d:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e0e:	48 83 c4 60          	add    $0x60,%rsp
  800e12:	5b                   	pop    %rbx
  800e13:	41 5c                	pop    %r12
  800e15:	5d                   	pop    %rbp
  800e16:	c3                   	retq   

0000000000800e17 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e17:	55                   	push   %rbp
  800e18:	48 89 e5             	mov    %rsp,%rbp
  800e1b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e22:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e29:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e30:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e37:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e3e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e45:	84 c0                	test   %al,%al
  800e47:	74 20                	je     800e69 <printfmt+0x52>
  800e49:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e4d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e51:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e55:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e59:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e5d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e61:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e65:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e69:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e70:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e77:	00 00 00 
  800e7a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e81:	00 00 00 
  800e84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e88:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e8f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e96:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e9d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ea4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800eab:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eb2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800eb9:	48 89 c7             	mov    %rax,%rdi
  800ebc:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  800ec3:	00 00 00 
  800ec6:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ec8:	c9                   	leaveq 
  800ec9:	c3                   	retq   

0000000000800eca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eca:	55                   	push   %rbp
  800ecb:	48 89 e5             	mov    %rsp,%rbp
  800ece:	48 83 ec 10          	sub    $0x10,%rsp
  800ed2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ed5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ed9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edd:	8b 40 10             	mov    0x10(%rax),%eax
  800ee0:	8d 50 01             	lea    0x1(%rax),%edx
  800ee3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eee:	48 8b 10             	mov    (%rax),%rdx
  800ef1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef5:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ef9:	48 39 c2             	cmp    %rax,%rdx
  800efc:	73 17                	jae    800f15 <sprintputch+0x4b>
		*b->buf++ = ch;
  800efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f02:	48 8b 00             	mov    (%rax),%rax
  800f05:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f08:	88 10                	mov    %dl,(%rax)
  800f0a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f12:	48 89 10             	mov    %rdx,(%rax)
}
  800f15:	c9                   	leaveq 
  800f16:	c3                   	retq   

0000000000800f17 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f17:	55                   	push   %rbp
  800f18:	48 89 e5             	mov    %rsp,%rbp
  800f1b:	48 83 ec 50          	sub    $0x50,%rsp
  800f1f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f23:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f26:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f2a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f2e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f32:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f36:	48 8b 0a             	mov    (%rdx),%rcx
  800f39:	48 89 08             	mov    %rcx,(%rax)
  800f3c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f40:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f44:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f48:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f4c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f50:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f54:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f57:	48 98                	cltq   
  800f59:	48 83 e8 01          	sub    $0x1,%rax
  800f5d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800f61:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f6c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f71:	74 06                	je     800f79 <vsnprintf+0x62>
  800f73:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f77:	7f 07                	jg     800f80 <vsnprintf+0x69>
		return -E_INVAL;
  800f79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7e:	eb 2f                	jmp    800faf <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f80:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f84:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f88:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f8c:	48 89 c6             	mov    %rax,%rsi
  800f8f:	48 bf ca 0e 80 00 00 	movabs $0x800eca,%rdi
  800f96:	00 00 00 
  800f99:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  800fa0:	00 00 00 
  800fa3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fa5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fa9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fac:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800faf:	c9                   	leaveq 
  800fb0:	c3                   	retq   

0000000000800fb1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb1:	55                   	push   %rbp
  800fb2:	48 89 e5             	mov    %rsp,%rbp
  800fb5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fbc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fc3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fc9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fd0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fd7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fde:	84 c0                	test   %al,%al
  800fe0:	74 20                	je     801002 <snprintf+0x51>
  800fe2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fe6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fea:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fee:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ff2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ff6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ffa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ffe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801002:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801009:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801010:	00 00 00 
  801013:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80101a:	00 00 00 
  80101d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801021:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801028:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80102f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801036:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80103d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801044:	48 8b 0a             	mov    (%rdx),%rcx
  801047:	48 89 08             	mov    %rcx,(%rax)
  80104a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80104e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801052:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801056:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80105a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801061:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801068:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80106e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801075:	48 89 c7             	mov    %rax,%rdi
  801078:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  80107f:	00 00 00 
  801082:	ff d0                	callq  *%rax
  801084:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80108a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801090:	c9                   	leaveq 
  801091:	c3                   	retq   
	...

0000000000801094 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	48 83 ec 18          	sub    $0x18,%rsp
  80109c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a7:	eb 09                	jmp    8010b2 <strlen+0x1e>
		n++;
  8010a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010ad:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b6:	0f b6 00             	movzbl (%rax),%eax
  8010b9:	84 c0                	test   %al,%al
  8010bb:	75 ec                	jne    8010a9 <strlen+0x15>
		n++;
	return n;
  8010bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010c0:	c9                   	leaveq 
  8010c1:	c3                   	retq   

00000000008010c2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010c2:	55                   	push   %rbp
  8010c3:	48 89 e5             	mov    %rsp,%rbp
  8010c6:	48 83 ec 20          	sub    $0x20,%rsp
  8010ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010d9:	eb 0e                	jmp    8010e9 <strnlen+0x27>
		n++;
  8010db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010df:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010e9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010ee:	74 0b                	je     8010fb <strnlen+0x39>
  8010f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f4:	0f b6 00             	movzbl (%rax),%eax
  8010f7:	84 c0                	test   %al,%al
  8010f9:	75 e0                	jne    8010db <strnlen+0x19>
		n++;
	return n;
  8010fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010fe:	c9                   	leaveq 
  8010ff:	c3                   	retq   

0000000000801100 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	48 83 ec 20          	sub    $0x20,%rsp
  801108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801114:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801118:	90                   	nop
  801119:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80111d:	0f b6 10             	movzbl (%rax),%edx
  801120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801124:	88 10                	mov    %dl,(%rax)
  801126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112a:	0f b6 00             	movzbl (%rax),%eax
  80112d:	84 c0                	test   %al,%al
  80112f:	0f 95 c0             	setne  %al
  801132:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801137:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80113c:	84 c0                	test   %al,%al
  80113e:	75 d9                	jne    801119 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801144:	c9                   	leaveq 
  801145:	c3                   	retq   

0000000000801146 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801146:	55                   	push   %rbp
  801147:	48 89 e5             	mov    %rsp,%rbp
  80114a:	48 83 ec 20          	sub    $0x20,%rsp
  80114e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801152:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	48 89 c7             	mov    %rax,%rdi
  80115d:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  801164:	00 00 00 
  801167:	ff d0                	callq  *%rax
  801169:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80116c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80116f:	48 98                	cltq   
  801171:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801175:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801179:	48 89 d6             	mov    %rdx,%rsi
  80117c:	48 89 c7             	mov    %rax,%rdi
  80117f:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  801186:	00 00 00 
  801189:	ff d0                	callq  *%rax
	return dst;
  80118b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80118f:	c9                   	leaveq 
  801190:	c3                   	retq   

0000000000801191 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801191:	55                   	push   %rbp
  801192:	48 89 e5             	mov    %rsp,%rbp
  801195:	48 83 ec 28          	sub    $0x28,%rsp
  801199:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011ad:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011b4:	00 
  8011b5:	eb 27                	jmp    8011de <strncpy+0x4d>
		*dst++ = *src;
  8011b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011bb:	0f b6 10             	movzbl (%rax),%edx
  8011be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c2:	88 10                	mov    %dl,(%rax)
  8011c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011cd:	0f b6 00             	movzbl (%rax),%eax
  8011d0:	84 c0                	test   %al,%al
  8011d2:	74 05                	je     8011d9 <strncpy+0x48>
			src++;
  8011d4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011e6:	72 cf                	jb     8011b7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011ec:	c9                   	leaveq 
  8011ed:	c3                   	retq   

00000000008011ee <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011ee:	55                   	push   %rbp
  8011ef:	48 89 e5             	mov    %rsp,%rbp
  8011f2:	48 83 ec 28          	sub    $0x28,%rsp
  8011f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801206:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80120a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80120f:	74 37                	je     801248 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801211:	eb 17                	jmp    80122a <strlcpy+0x3c>
			*dst++ = *src++;
  801213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801217:	0f b6 10             	movzbl (%rax),%edx
  80121a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121e:	88 10                	mov    %dl,(%rax)
  801220:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801225:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80122a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80122f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801234:	74 0b                	je     801241 <strlcpy+0x53>
  801236:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80123a:	0f b6 00             	movzbl (%rax),%eax
  80123d:	84 c0                	test   %al,%al
  80123f:	75 d2                	jne    801213 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801241:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801245:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801248:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80124c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801250:	48 89 d1             	mov    %rdx,%rcx
  801253:	48 29 c1             	sub    %rax,%rcx
  801256:	48 89 c8             	mov    %rcx,%rax
}
  801259:	c9                   	leaveq 
  80125a:	c3                   	retq   

000000000080125b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80125b:	55                   	push   %rbp
  80125c:	48 89 e5             	mov    %rsp,%rbp
  80125f:	48 83 ec 10          	sub    $0x10,%rsp
  801263:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801267:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80126b:	eb 0a                	jmp    801277 <strcmp+0x1c>
		p++, q++;
  80126d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801272:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127b:	0f b6 00             	movzbl (%rax),%eax
  80127e:	84 c0                	test   %al,%al
  801280:	74 12                	je     801294 <strcmp+0x39>
  801282:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801286:	0f b6 10             	movzbl (%rax),%edx
  801289:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128d:	0f b6 00             	movzbl (%rax),%eax
  801290:	38 c2                	cmp    %al,%dl
  801292:	74 d9                	je     80126d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801298:	0f b6 00             	movzbl (%rax),%eax
  80129b:	0f b6 d0             	movzbl %al,%edx
  80129e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a2:	0f b6 00             	movzbl (%rax),%eax
  8012a5:	0f b6 c0             	movzbl %al,%eax
  8012a8:	89 d1                	mov    %edx,%ecx
  8012aa:	29 c1                	sub    %eax,%ecx
  8012ac:	89 c8                	mov    %ecx,%eax
}
  8012ae:	c9                   	leaveq 
  8012af:	c3                   	retq   

00000000008012b0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	48 83 ec 18          	sub    $0x18,%rsp
  8012b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012c0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012c4:	eb 0f                	jmp    8012d5 <strncmp+0x25>
		n--, p++, q++;
  8012c6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012da:	74 1d                	je     8012f9 <strncmp+0x49>
  8012dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e0:	0f b6 00             	movzbl (%rax),%eax
  8012e3:	84 c0                	test   %al,%al
  8012e5:	74 12                	je     8012f9 <strncmp+0x49>
  8012e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012eb:	0f b6 10             	movzbl (%rax),%edx
  8012ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f2:	0f b6 00             	movzbl (%rax),%eax
  8012f5:	38 c2                	cmp    %al,%dl
  8012f7:	74 cd                	je     8012c6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012fe:	75 07                	jne    801307 <strncmp+0x57>
		return 0;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	eb 1a                	jmp    801321 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	0f b6 d0             	movzbl %al,%edx
  801311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801315:	0f b6 00             	movzbl (%rax),%eax
  801318:	0f b6 c0             	movzbl %al,%eax
  80131b:	89 d1                	mov    %edx,%ecx
  80131d:	29 c1                	sub    %eax,%ecx
  80131f:	89 c8                	mov    %ecx,%eax
}
  801321:	c9                   	leaveq 
  801322:	c3                   	retq   

0000000000801323 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801323:	55                   	push   %rbp
  801324:	48 89 e5             	mov    %rsp,%rbp
  801327:	48 83 ec 10          	sub    $0x10,%rsp
  80132b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80132f:	89 f0                	mov    %esi,%eax
  801331:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801334:	eb 17                	jmp    80134d <strchr+0x2a>
		if (*s == c)
  801336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133a:	0f b6 00             	movzbl (%rax),%eax
  80133d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801340:	75 06                	jne    801348 <strchr+0x25>
			return (char *) s;
  801342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801346:	eb 15                	jmp    80135d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801348:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	0f b6 00             	movzbl (%rax),%eax
  801354:	84 c0                	test   %al,%al
  801356:	75 de                	jne    801336 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135d:	c9                   	leaveq 
  80135e:	c3                   	retq   

000000000080135f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80135f:	55                   	push   %rbp
  801360:	48 89 e5             	mov    %rsp,%rbp
  801363:	48 83 ec 10          	sub    $0x10,%rsp
  801367:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136b:	89 f0                	mov    %esi,%eax
  80136d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801370:	eb 11                	jmp    801383 <strfind+0x24>
		if (*s == c)
  801372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80137c:	74 12                	je     801390 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80137e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801387:	0f b6 00             	movzbl (%rax),%eax
  80138a:	84 c0                	test   %al,%al
  80138c:	75 e4                	jne    801372 <strfind+0x13>
  80138e:	eb 01                	jmp    801391 <strfind+0x32>
		if (*s == c)
			break;
  801390:	90                   	nop
	return (char *) s;
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801395:	c9                   	leaveq 
  801396:	c3                   	retq   

0000000000801397 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801397:	55                   	push   %rbp
  801398:	48 89 e5             	mov    %rsp,%rbp
  80139b:	48 83 ec 18          	sub    $0x18,%rsp
  80139f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013af:	75 06                	jne    8013b7 <memset+0x20>
		return v;
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	eb 69                	jmp    801420 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	83 e0 03             	and    $0x3,%eax
  8013be:	48 85 c0             	test   %rax,%rax
  8013c1:	75 48                	jne    80140b <memset+0x74>
  8013c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c7:	83 e0 03             	and    $0x3,%eax
  8013ca:	48 85 c0             	test   %rax,%rax
  8013cd:	75 3c                	jne    80140b <memset+0x74>
		c &= 0xFF;
  8013cf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d9:	89 c2                	mov    %eax,%edx
  8013db:	c1 e2 18             	shl    $0x18,%edx
  8013de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e1:	c1 e0 10             	shl    $0x10,%eax
  8013e4:	09 c2                	or     %eax,%edx
  8013e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e9:	c1 e0 08             	shl    $0x8,%eax
  8013ec:	09 d0                	or     %edx,%eax
  8013ee:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f5:	48 89 c1             	mov    %rax,%rcx
  8013f8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801400:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801403:	48 89 d7             	mov    %rdx,%rdi
  801406:	fc                   	cld    
  801407:	f3 ab                	rep stos %eax,%es:(%rdi)
  801409:	eb 11                	jmp    80141c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80140b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801412:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801416:	48 89 d7             	mov    %rdx,%rdi
  801419:	fc                   	cld    
  80141a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801420:	c9                   	leaveq 
  801421:	c3                   	retq   

0000000000801422 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801422:	55                   	push   %rbp
  801423:	48 89 e5             	mov    %rsp,%rbp
  801426:	48 83 ec 28          	sub    $0x28,%rsp
  80142a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801432:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801436:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144e:	0f 83 88 00 00 00    	jae    8014dc <memmove+0xba>
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145c:	48 01 d0             	add    %rdx,%rax
  80145f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801463:	76 77                	jbe    8014dc <memmove+0xba>
		s += n;
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	83 e0 03             	and    $0x3,%eax
  80147c:	48 85 c0             	test   %rax,%rax
  80147f:	75 3b                	jne    8014bc <memmove+0x9a>
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	83 e0 03             	and    $0x3,%eax
  801488:	48 85 c0             	test   %rax,%rax
  80148b:	75 2f                	jne    8014bc <memmove+0x9a>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	83 e0 03             	and    $0x3,%eax
  801494:	48 85 c0             	test   %rax,%rax
  801497:	75 23                	jne    8014bc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149d:	48 83 e8 04          	sub    $0x4,%rax
  8014a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a5:	48 83 ea 04          	sub    $0x4,%rdx
  8014a9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ad:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014b1:	48 89 c7             	mov    %rax,%rdi
  8014b4:	48 89 d6             	mov    %rdx,%rsi
  8014b7:	fd                   	std    
  8014b8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014ba:	eb 1d                	jmp    8014d9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d0:	48 89 d7             	mov    %rdx,%rdi
  8014d3:	48 89 c1             	mov    %rax,%rcx
  8014d6:	fd                   	std    
  8014d7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014d9:	fc                   	cld    
  8014da:	eb 57                	jmp    801533 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e0:	83 e0 03             	and    $0x3,%eax
  8014e3:	48 85 c0             	test   %rax,%rax
  8014e6:	75 36                	jne    80151e <memmove+0xfc>
  8014e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ec:	83 e0 03             	and    $0x3,%eax
  8014ef:	48 85 c0             	test   %rax,%rax
  8014f2:	75 2a                	jne    80151e <memmove+0xfc>
  8014f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f8:	83 e0 03             	and    $0x3,%eax
  8014fb:	48 85 c0             	test   %rax,%rax
  8014fe:	75 1e                	jne    80151e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	48 89 c1             	mov    %rax,%rcx
  801507:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80150b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801513:	48 89 c7             	mov    %rax,%rdi
  801516:	48 89 d6             	mov    %rdx,%rsi
  801519:	fc                   	cld    
  80151a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80151c:	eb 15                	jmp    801533 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80151e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801522:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801526:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80152a:	48 89 c7             	mov    %rax,%rdi
  80152d:	48 89 d6             	mov    %rdx,%rsi
  801530:	fc                   	cld    
  801531:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801537:	c9                   	leaveq 
  801538:	c3                   	retq   

0000000000801539 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801539:	55                   	push   %rbp
  80153a:	48 89 e5             	mov    %rsp,%rbp
  80153d:	48 83 ec 18          	sub    $0x18,%rsp
  801541:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801545:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801549:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80154d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801551:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801559:	48 89 ce             	mov    %rcx,%rsi
  80155c:	48 89 c7             	mov    %rax,%rdi
  80155f:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 28          	sub    $0x28,%rsp
  801575:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80157d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801589:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80158d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801591:	eb 38                	jmp    8015cb <memcmp+0x5e>
		if (*s1 != *s2)
  801593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801597:	0f b6 10             	movzbl (%rax),%edx
  80159a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	38 c2                	cmp    %al,%dl
  8015a3:	74 1c                	je     8015c1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	0f b6 d0             	movzbl %al,%edx
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	0f b6 c0             	movzbl %al,%eax
  8015b9:	89 d1                	mov    %edx,%ecx
  8015bb:	29 c1                	sub    %eax,%ecx
  8015bd:	89 c8                	mov    %ecx,%eax
  8015bf:	eb 20                	jmp    8015e1 <memcmp+0x74>
		s1++, s2++;
  8015c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015cb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015d0:	0f 95 c0             	setne  %al
  8015d3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015d8:	84 c0                	test   %al,%al
  8015da:	75 b7                	jne    801593 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e1:	c9                   	leaveq 
  8015e2:	c3                   	retq   

00000000008015e3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	48 83 ec 28          	sub    $0x28,%rsp
  8015eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ef:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015fe:	48 01 d0             	add    %rdx,%rax
  801601:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801605:	eb 13                	jmp    80161a <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160b:	0f b6 10             	movzbl (%rax),%edx
  80160e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801611:	38 c2                	cmp    %al,%dl
  801613:	74 11                	je     801626 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801615:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80161a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801622:	72 e3                	jb     801607 <memfind+0x24>
  801624:	eb 01                	jmp    801627 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801626:	90                   	nop
	return (void *) s;
  801627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80162b:	c9                   	leaveq 
  80162c:	c3                   	retq   

000000000080162d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162d:	55                   	push   %rbp
  80162e:	48 89 e5             	mov    %rsp,%rbp
  801631:	48 83 ec 38          	sub    $0x38,%rsp
  801635:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801639:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80163d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801640:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801647:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80164e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80164f:	eb 05                	jmp    801656 <strtol+0x29>
		s++;
  801651:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165a:	0f b6 00             	movzbl (%rax),%eax
  80165d:	3c 20                	cmp    $0x20,%al
  80165f:	74 f0                	je     801651 <strtol+0x24>
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	0f b6 00             	movzbl (%rax),%eax
  801668:	3c 09                	cmp    $0x9,%al
  80166a:	74 e5                	je     801651 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	3c 2b                	cmp    $0x2b,%al
  801675:	75 07                	jne    80167e <strtol+0x51>
		s++;
  801677:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80167c:	eb 17                	jmp    801695 <strtol+0x68>
	else if (*s == '-')
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	3c 2d                	cmp    $0x2d,%al
  801687:	75 0c                	jne    801695 <strtol+0x68>
		s++, neg = 1;
  801689:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80168e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801695:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801699:	74 06                	je     8016a1 <strtol+0x74>
  80169b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80169f:	75 28                	jne    8016c9 <strtol+0x9c>
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 30                	cmp    $0x30,%al
  8016aa:	75 1d                	jne    8016c9 <strtol+0x9c>
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	48 83 c0 01          	add    $0x1,%rax
  8016b4:	0f b6 00             	movzbl (%rax),%eax
  8016b7:	3c 78                	cmp    $0x78,%al
  8016b9:	75 0e                	jne    8016c9 <strtol+0x9c>
		s += 2, base = 16;
  8016bb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016c0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016c7:	eb 2c                	jmp    8016f5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016cd:	75 19                	jne    8016e8 <strtol+0xbb>
  8016cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d3:	0f b6 00             	movzbl (%rax),%eax
  8016d6:	3c 30                	cmp    $0x30,%al
  8016d8:	75 0e                	jne    8016e8 <strtol+0xbb>
		s++, base = 8;
  8016da:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016df:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016e6:	eb 0d                	jmp    8016f5 <strtol+0xc8>
	else if (base == 0)
  8016e8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ec:	75 07                	jne    8016f5 <strtol+0xc8>
		base = 10;
  8016ee:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f9:	0f b6 00             	movzbl (%rax),%eax
  8016fc:	3c 2f                	cmp    $0x2f,%al
  8016fe:	7e 1d                	jle    80171d <strtol+0xf0>
  801700:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801704:	0f b6 00             	movzbl (%rax),%eax
  801707:	3c 39                	cmp    $0x39,%al
  801709:	7f 12                	jg     80171d <strtol+0xf0>
			dig = *s - '0';
  80170b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170f:	0f b6 00             	movzbl (%rax),%eax
  801712:	0f be c0             	movsbl %al,%eax
  801715:	83 e8 30             	sub    $0x30,%eax
  801718:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80171b:	eb 4e                	jmp    80176b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80171d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801721:	0f b6 00             	movzbl (%rax),%eax
  801724:	3c 60                	cmp    $0x60,%al
  801726:	7e 1d                	jle    801745 <strtol+0x118>
  801728:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172c:	0f b6 00             	movzbl (%rax),%eax
  80172f:	3c 7a                	cmp    $0x7a,%al
  801731:	7f 12                	jg     801745 <strtol+0x118>
			dig = *s - 'a' + 10;
  801733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801737:	0f b6 00             	movzbl (%rax),%eax
  80173a:	0f be c0             	movsbl %al,%eax
  80173d:	83 e8 57             	sub    $0x57,%eax
  801740:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801743:	eb 26                	jmp    80176b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801749:	0f b6 00             	movzbl (%rax),%eax
  80174c:	3c 40                	cmp    $0x40,%al
  80174e:	7e 47                	jle    801797 <strtol+0x16a>
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	0f b6 00             	movzbl (%rax),%eax
  801757:	3c 5a                	cmp    $0x5a,%al
  801759:	7f 3c                	jg     801797 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	0f b6 00             	movzbl (%rax),%eax
  801762:	0f be c0             	movsbl %al,%eax
  801765:	83 e8 37             	sub    $0x37,%eax
  801768:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80176b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80176e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801771:	7d 23                	jge    801796 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801773:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801778:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80177b:	48 98                	cltq   
  80177d:	48 89 c2             	mov    %rax,%rdx
  801780:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801785:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801788:	48 98                	cltq   
  80178a:	48 01 d0             	add    %rdx,%rax
  80178d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801791:	e9 5f ff ff ff       	jmpq   8016f5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801796:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801797:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80179c:	74 0b                	je     8017a9 <strtol+0x17c>
		*endptr = (char *) s;
  80179e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017a6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017ad:	74 09                	je     8017b8 <strtol+0x18b>
  8017af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b3:	48 f7 d8             	neg    %rax
  8017b6:	eb 04                	jmp    8017bc <strtol+0x18f>
  8017b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017bc:	c9                   	leaveq 
  8017bd:	c3                   	retq   

00000000008017be <strstr>:

char * strstr(const char *in, const char *str)
{
  8017be:	55                   	push   %rbp
  8017bf:	48 89 e5             	mov    %rsp,%rbp
  8017c2:	48 83 ec 30          	sub    $0x30,%rsp
  8017c6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d2:	0f b6 00             	movzbl (%rax),%eax
  8017d5:	88 45 ff             	mov    %al,-0x1(%rbp)
  8017d8:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  8017dd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017e1:	75 06                	jne    8017e9 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  8017e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e7:	eb 68                	jmp    801851 <strstr+0x93>

	len = strlen(str);
  8017e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ed:	48 89 c7             	mov    %rax,%rdi
  8017f0:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  8017f7:	00 00 00 
  8017fa:	ff d0                	callq  *%rax
  8017fc:	48 98                	cltq   
  8017fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801806:	0f b6 00             	movzbl (%rax),%eax
  801809:	88 45 ef             	mov    %al,-0x11(%rbp)
  80180c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801811:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801815:	75 07                	jne    80181e <strstr+0x60>
				return (char *) 0;
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
  80181c:	eb 33                	jmp    801851 <strstr+0x93>
		} while (sc != c);
  80181e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801822:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801825:	75 db                	jne    801802 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801827:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	48 89 ce             	mov    %rcx,%rsi
  801836:	48 89 c7             	mov    %rax,%rdi
  801839:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  801840:	00 00 00 
  801843:	ff d0                	callq  *%rax
  801845:	85 c0                	test   %eax,%eax
  801847:	75 b9                	jne    801802 <strstr+0x44>

	return (char *) (in - 1);
  801849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184d:	48 83 e8 01          	sub    $0x1,%rax
}
  801851:	c9                   	leaveq 
  801852:	c3                   	retq   
	...

0000000000801854 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801854:	55                   	push   %rbp
  801855:	48 89 e5             	mov    %rsp,%rbp
  801858:	53                   	push   %rbx
  801859:	48 83 ec 58          	sub    $0x58,%rsp
  80185d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801860:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801863:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801867:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80186b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80186f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801873:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801876:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801879:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80187d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801881:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801885:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801889:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80188d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801890:	4c 89 c3             	mov    %r8,%rbx
  801893:	cd 30                	int    $0x30
  801895:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801899:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80189d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018a5:	74 3e                	je     8018e5 <syscall+0x91>
  8018a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018ac:	7e 37                	jle    8018e5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018b2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018b5:	49 89 d0             	mov    %rdx,%r8
  8018b8:	89 c1                	mov    %eax,%ecx
  8018ba:	48 ba c8 48 80 00 00 	movabs $0x8048c8,%rdx
  8018c1:	00 00 00 
  8018c4:	be 23 00 00 00       	mov    $0x23,%esi
  8018c9:	48 bf e5 48 80 00 00 	movabs $0x8048e5,%rdi
  8018d0:	00 00 00 
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d8:	49 b9 38 3a 80 00 00 	movabs $0x803a38,%r9
  8018df:	00 00 00 
  8018e2:	41 ff d1             	callq  *%r9

	return ret;
  8018e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018e9:	48 83 c4 58          	add    $0x58,%rsp
  8018ed:	5b                   	pop    %rbx
  8018ee:	5d                   	pop    %rbp
  8018ef:	c3                   	retq   

00000000008018f0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018f0:	55                   	push   %rbp
  8018f1:	48 89 e5             	mov    %rsp,%rbp
  8018f4:	48 83 ec 20          	sub    $0x20,%rsp
  8018f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801900:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801904:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801908:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190f:	00 
  801910:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801916:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80191c:	48 89 d1             	mov    %rdx,%rcx
  80191f:	48 89 c2             	mov    %rax,%rdx
  801922:	be 00 00 00 00       	mov    $0x0,%esi
  801927:	bf 00 00 00 00       	mov    $0x0,%edi
  80192c:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801933:	00 00 00 
  801936:	ff d0                	callq  *%rax
}
  801938:	c9                   	leaveq 
  801939:	c3                   	retq   

000000000080193a <sys_cgetc>:

int
sys_cgetc(void)
{
  80193a:	55                   	push   %rbp
  80193b:	48 89 e5             	mov    %rsp,%rbp
  80193e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801942:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801949:	00 
  80194a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801950:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801956:	b9 00 00 00 00       	mov    $0x0,%ecx
  80195b:	ba 00 00 00 00       	mov    $0x0,%edx
  801960:	be 00 00 00 00       	mov    $0x0,%esi
  801965:	bf 01 00 00 00       	mov    $0x1,%edi
  80196a:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801971:	00 00 00 
  801974:	ff d0                	callq  *%rax
}
  801976:	c9                   	leaveq 
  801977:	c3                   	retq   

0000000000801978 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801978:	55                   	push   %rbp
  801979:	48 89 e5             	mov    %rsp,%rbp
  80197c:	48 83 ec 20          	sub    $0x20,%rsp
  801980:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801983:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801986:	48 98                	cltq   
  801988:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198f:	00 
  801990:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801996:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a1:	48 89 c2             	mov    %rax,%rdx
  8019a4:	be 01 00 00 00       	mov    $0x1,%esi
  8019a9:	bf 03 00 00 00       	mov    $0x3,%edi
  8019ae:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  8019b5:	00 00 00 
  8019b8:	ff d0                	callq  *%rax
}
  8019ba:	c9                   	leaveq 
  8019bb:	c3                   	retq   

00000000008019bc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019bc:	55                   	push   %rbp
  8019bd:	48 89 e5             	mov    %rsp,%rbp
  8019c0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cb:	00 
  8019cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e2:	be 00 00 00 00       	mov    $0x0,%esi
  8019e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8019ec:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  8019f3:	00 00 00 
  8019f6:	ff d0                	callq  *%rax
}
  8019f8:	c9                   	leaveq 
  8019f9:	c3                   	retq   

00000000008019fa <sys_yield>:

void
sys_yield(void)
{
  8019fa:	55                   	push   %rbp
  8019fb:	48 89 e5             	mov    %rsp,%rbp
  8019fe:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a02:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a09:	00 
  801a0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a16:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a20:	be 00 00 00 00       	mov    $0x0,%esi
  801a25:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a2a:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	callq  *%rax
}
  801a36:	c9                   	leaveq 
  801a37:	c3                   	retq   

0000000000801a38 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a38:	55                   	push   %rbp
  801a39:	48 89 e5             	mov    %rsp,%rbp
  801a3c:	48 83 ec 20          	sub    $0x20,%rsp
  801a40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a47:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a4d:	48 63 c8             	movslq %eax,%rcx
  801a50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a57:	48 98                	cltq   
  801a59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a60:	00 
  801a61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a67:	49 89 c8             	mov    %rcx,%r8
  801a6a:	48 89 d1             	mov    %rdx,%rcx
  801a6d:	48 89 c2             	mov    %rax,%rdx
  801a70:	be 01 00 00 00       	mov    $0x1,%esi
  801a75:	bf 04 00 00 00       	mov    $0x4,%edi
  801a7a:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	callq  *%rax
}
  801a86:	c9                   	leaveq 
  801a87:	c3                   	retq   

0000000000801a88 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a88:	55                   	push   %rbp
  801a89:	48 89 e5             	mov    %rsp,%rbp
  801a8c:	48 83 ec 30          	sub    $0x30,%rsp
  801a90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a97:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a9a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a9e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801aa2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801aa5:	48 63 c8             	movslq %eax,%rcx
  801aa8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aaf:	48 63 f0             	movslq %eax,%rsi
  801ab2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab9:	48 98                	cltq   
  801abb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801abf:	49 89 f9             	mov    %rdi,%r9
  801ac2:	49 89 f0             	mov    %rsi,%r8
  801ac5:	48 89 d1             	mov    %rdx,%rcx
  801ac8:	48 89 c2             	mov    %rax,%rdx
  801acb:	be 01 00 00 00       	mov    $0x1,%esi
  801ad0:	bf 05 00 00 00       	mov    $0x5,%edi
  801ad5:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801adc:	00 00 00 
  801adf:	ff d0                	callq  *%rax
}
  801ae1:	c9                   	leaveq 
  801ae2:	c3                   	retq   

0000000000801ae3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ae3:	55                   	push   %rbp
  801ae4:	48 89 e5             	mov    %rsp,%rbp
  801ae7:	48 83 ec 20          	sub    $0x20,%rsp
  801aeb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801af2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af9:	48 98                	cltq   
  801afb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b02:	00 
  801b03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0f:	48 89 d1             	mov    %rdx,%rcx
  801b12:	48 89 c2             	mov    %rax,%rdx
  801b15:	be 01 00 00 00       	mov    $0x1,%esi
  801b1a:	bf 06 00 00 00       	mov    $0x6,%edi
  801b1f:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801b26:	00 00 00 
  801b29:	ff d0                	callq  *%rax
}
  801b2b:	c9                   	leaveq 
  801b2c:	c3                   	retq   

0000000000801b2d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b2d:	55                   	push   %rbp
  801b2e:	48 89 e5             	mov    %rsp,%rbp
  801b31:	48 83 ec 20          	sub    $0x20,%rsp
  801b35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b38:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3e:	48 63 d0             	movslq %eax,%rdx
  801b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b44:	48 98                	cltq   
  801b46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b4d:	00 
  801b4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b5a:	48 89 d1             	mov    %rdx,%rcx
  801b5d:	48 89 c2             	mov    %rax,%rdx
  801b60:	be 01 00 00 00       	mov    $0x1,%esi
  801b65:	bf 08 00 00 00       	mov    $0x8,%edi
  801b6a:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 20          	sub    $0x20,%rsp
  801b80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8e:	48 98                	cltq   
  801b90:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b97:	00 
  801b98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba4:	48 89 d1             	mov    %rdx,%rcx
  801ba7:	48 89 c2             	mov    %rax,%rdx
  801baa:	be 01 00 00 00       	mov    $0x1,%esi
  801baf:	bf 09 00 00 00       	mov    $0x9,%edi
  801bb4:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801bbb:	00 00 00 
  801bbe:	ff d0                	callq  *%rax
}
  801bc0:	c9                   	leaveq 
  801bc1:	c3                   	retq   

0000000000801bc2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bc2:	55                   	push   %rbp
  801bc3:	48 89 e5             	mov    %rsp,%rbp
  801bc6:	48 83 ec 20          	sub    $0x20,%rsp
  801bca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd8:	48 98                	cltq   
  801bda:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be1:	00 
  801be2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bee:	48 89 d1             	mov    %rdx,%rcx
  801bf1:	48 89 c2             	mov    %rax,%rdx
  801bf4:	be 01 00 00 00       	mov    $0x1,%esi
  801bf9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bfe:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
}
  801c0a:	c9                   	leaveq 
  801c0b:	c3                   	retq   

0000000000801c0c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c0c:	55                   	push   %rbp
  801c0d:	48 89 e5             	mov    %rsp,%rbp
  801c10:	48 83 ec 30          	sub    $0x30,%rsp
  801c14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c1b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c1f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c25:	48 63 f0             	movslq %eax,%rsi
  801c28:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2f:	48 98                	cltq   
  801c31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3c:	00 
  801c3d:	49 89 f1             	mov    %rsi,%r9
  801c40:	49 89 c8             	mov    %rcx,%r8
  801c43:	48 89 d1             	mov    %rdx,%rcx
  801c46:	48 89 c2             	mov    %rax,%rdx
  801c49:	be 00 00 00 00       	mov    $0x0,%esi
  801c4e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c53:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	callq  *%rax
}
  801c5f:	c9                   	leaveq 
  801c60:	c3                   	retq   

0000000000801c61 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c61:	55                   	push   %rbp
  801c62:	48 89 e5             	mov    %rsp,%rbp
  801c65:	48 83 ec 20          	sub    $0x20,%rsp
  801c69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c78:	00 
  801c79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c85:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8a:	48 89 c2             	mov    %rax,%rdx
  801c8d:	be 01 00 00 00       	mov    $0x1,%esi
  801c92:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c97:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	callq  *%rax
}
  801ca3:	c9                   	leaveq 
  801ca4:	c3                   	retq   

0000000000801ca5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ca5:	55                   	push   %rbp
  801ca6:	48 89 e5             	mov    %rsp,%rbp
  801ca9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801cad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb4:	00 
  801cb5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccb:	be 00 00 00 00       	mov    $0x0,%esi
  801cd0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cd5:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
}
  801ce1:	c9                   	leaveq 
  801ce2:	c3                   	retq   

0000000000801ce3 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801ce3:	55                   	push   %rbp
  801ce4:	48 89 e5             	mov    %rsp,%rbp
  801ce7:	48 83 ec 30          	sub    $0x30,%rsp
  801ceb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cf2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cf5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cf9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801cfd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d00:	48 63 c8             	movslq %eax,%rcx
  801d03:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d0a:	48 63 f0             	movslq %eax,%rsi
  801d0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d14:	48 98                	cltq   
  801d16:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d1a:	49 89 f9             	mov    %rdi,%r9
  801d1d:	49 89 f0             	mov    %rsi,%r8
  801d20:	48 89 d1             	mov    %rdx,%rcx
  801d23:	48 89 c2             	mov    %rax,%rdx
  801d26:	be 00 00 00 00       	mov    $0x0,%esi
  801d2b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d30:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801d37:	00 00 00 
  801d3a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d3c:	c9                   	leaveq 
  801d3d:	c3                   	retq   

0000000000801d3e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d3e:	55                   	push   %rbp
  801d3f:	48 89 e5             	mov    %rsp,%rbp
  801d42:	48 83 ec 20          	sub    $0x20,%rsp
  801d46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5d:	00 
  801d5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d6a:	48 89 d1             	mov    %rdx,%rcx
  801d6d:	48 89 c2             	mov    %rax,%rdx
  801d70:	be 00 00 00 00       	mov    $0x0,%esi
  801d75:	bf 10 00 00 00       	mov    $0x10,%edi
  801d7a:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801d81:	00 00 00 
  801d84:	ff d0                	callq  *%rax
}
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	48 83 ec 08          	sub    $0x8,%rsp
  801d90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d98:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d9f:	ff ff ff 
  801da2:	48 01 d0             	add    %rdx,%rax
  801da5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801da9:	c9                   	leaveq 
  801daa:	c3                   	retq   

0000000000801dab <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dab:	55                   	push   %rbp
  801dac:	48 89 e5             	mov    %rsp,%rbp
  801daf:	48 83 ec 08          	sub    $0x8,%rsp
  801db3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801db7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbb:	48 89 c7             	mov    %rax,%rdi
  801dbe:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  801dc5:	00 00 00 
  801dc8:	ff d0                	callq  *%rax
  801dca:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801dd0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801dd4:	c9                   	leaveq 
  801dd5:	c3                   	retq   

0000000000801dd6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dd6:	55                   	push   %rbp
  801dd7:	48 89 e5             	mov    %rsp,%rbp
  801dda:	48 83 ec 18          	sub    $0x18,%rsp
  801dde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801de2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801de9:	eb 6b                	jmp    801e56 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dee:	48 98                	cltq   
  801df0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801df6:	48 c1 e0 0c          	shl    $0xc,%rax
  801dfa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e02:	48 89 c2             	mov    %rax,%rdx
  801e05:	48 c1 ea 15          	shr    $0x15,%rdx
  801e09:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e10:	01 00 00 
  801e13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e17:	83 e0 01             	and    $0x1,%eax
  801e1a:	48 85 c0             	test   %rax,%rax
  801e1d:	74 21                	je     801e40 <fd_alloc+0x6a>
  801e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e23:	48 89 c2             	mov    %rax,%rdx
  801e26:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e2a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e31:	01 00 00 
  801e34:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e38:	83 e0 01             	and    $0x1,%eax
  801e3b:	48 85 c0             	test   %rax,%rax
  801e3e:	75 12                	jne    801e52 <fd_alloc+0x7c>
			*fd_store = fd;
  801e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e48:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e50:	eb 1a                	jmp    801e6c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e52:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e56:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e5a:	7e 8f                	jle    801deb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e60:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e67:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e6c:	c9                   	leaveq 
  801e6d:	c3                   	retq   

0000000000801e6e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e6e:	55                   	push   %rbp
  801e6f:	48 89 e5             	mov    %rsp,%rbp
  801e72:	48 83 ec 20          	sub    $0x20,%rsp
  801e76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e81:	78 06                	js     801e89 <fd_lookup+0x1b>
  801e83:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e87:	7e 07                	jle    801e90 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e8e:	eb 6c                	jmp    801efc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e93:	48 98                	cltq   
  801e95:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e9b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ea3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea7:	48 89 c2             	mov    %rax,%rdx
  801eaa:	48 c1 ea 15          	shr    $0x15,%rdx
  801eae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801eb5:	01 00 00 
  801eb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebc:	83 e0 01             	and    $0x1,%eax
  801ebf:	48 85 c0             	test   %rax,%rax
  801ec2:	74 21                	je     801ee5 <fd_lookup+0x77>
  801ec4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec8:	48 89 c2             	mov    %rax,%rdx
  801ecb:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ecf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ed6:	01 00 00 
  801ed9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801edd:	83 e0 01             	and    $0x1,%eax
  801ee0:	48 85 c0             	test   %rax,%rax
  801ee3:	75 07                	jne    801eec <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ee5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eea:	eb 10                	jmp    801efc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801eec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ef0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ef4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efc:	c9                   	leaveq 
  801efd:	c3                   	retq   

0000000000801efe <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801efe:	55                   	push   %rbp
  801eff:	48 89 e5             	mov    %rsp,%rbp
  801f02:	48 83 ec 30          	sub    $0x30,%rsp
  801f06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f0a:	89 f0                	mov    %esi,%eax
  801f0c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f13:	48 89 c7             	mov    %rax,%rdi
  801f16:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  801f1d:	00 00 00 
  801f20:	ff d0                	callq  *%rax
  801f22:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f26:	48 89 d6             	mov    %rdx,%rsi
  801f29:	89 c7                	mov    %eax,%edi
  801f2b:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  801f32:	00 00 00 
  801f35:	ff d0                	callq  *%rax
  801f37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f3e:	78 0a                	js     801f4a <fd_close+0x4c>
	    || fd != fd2)
  801f40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f44:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f48:	74 12                	je     801f5c <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f4a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f4e:	74 05                	je     801f55 <fd_close+0x57>
  801f50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f53:	eb 05                	jmp    801f5a <fd_close+0x5c>
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5a:	eb 69                	jmp    801fc5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f60:	8b 00                	mov    (%rax),%eax
  801f62:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f66:	48 89 d6             	mov    %rdx,%rsi
  801f69:	89 c7                	mov    %eax,%edi
  801f6b:	48 b8 c7 1f 80 00 00 	movabs $0x801fc7,%rax
  801f72:	00 00 00 
  801f75:	ff d0                	callq  *%rax
  801f77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f7e:	78 2a                	js     801faa <fd_close+0xac>
		if (dev->dev_close)
  801f80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f84:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f88:	48 85 c0             	test   %rax,%rax
  801f8b:	74 16                	je     801fa3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f91:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801f95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f99:	48 89 c7             	mov    %rax,%rdi
  801f9c:	ff d2                	callq  *%rdx
  801f9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa1:	eb 07                	jmp    801faa <fd_close+0xac>
		else
			r = 0;
  801fa3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801faa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fae:	48 89 c6             	mov    %rax,%rsi
  801fb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb6:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  801fbd:	00 00 00 
  801fc0:	ff d0                	callq  *%rax
	return r;
  801fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fc5:	c9                   	leaveq 
  801fc6:	c3                   	retq   

0000000000801fc7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fc7:	55                   	push   %rbp
  801fc8:	48 89 e5             	mov    %rsp,%rbp
  801fcb:	48 83 ec 20          	sub    $0x20,%rsp
  801fcf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fd2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fdd:	eb 41                	jmp    802020 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fdf:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fe6:	00 00 00 
  801fe9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fec:	48 63 d2             	movslq %edx,%rdx
  801fef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ff3:	8b 00                	mov    (%rax),%eax
  801ff5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801ff8:	75 22                	jne    80201c <dev_lookup+0x55>
			*dev = devtab[i];
  801ffa:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802001:	00 00 00 
  802004:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802007:	48 63 d2             	movslq %edx,%rdx
  80200a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80200e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802012:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
  80201a:	eb 60                	jmp    80207c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80201c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802020:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802027:	00 00 00 
  80202a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80202d:	48 63 d2             	movslq %edx,%rdx
  802030:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802034:	48 85 c0             	test   %rax,%rax
  802037:	75 a6                	jne    801fdf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802039:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802040:	00 00 00 
  802043:	48 8b 00             	mov    (%rax),%rax
  802046:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80204c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80204f:	89 c6                	mov    %eax,%esi
  802051:	48 bf f8 48 80 00 00 	movabs $0x8048f8,%rdi
  802058:	00 00 00 
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
  802060:	48 b9 2f 05 80 00 00 	movabs $0x80052f,%rcx
  802067:	00 00 00 
  80206a:	ff d1                	callq  *%rcx
	*dev = 0;
  80206c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802070:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802077:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80207c:	c9                   	leaveq 
  80207d:	c3                   	retq   

000000000080207e <close>:

int
close(int fdnum)
{
  80207e:	55                   	push   %rbp
  80207f:	48 89 e5             	mov    %rsp,%rbp
  802082:	48 83 ec 20          	sub    $0x20,%rsp
  802086:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802089:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80208d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802090:	48 89 d6             	mov    %rdx,%rsi
  802093:	89 c7                	mov    %eax,%edi
  802095:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  80209c:	00 00 00 
  80209f:	ff d0                	callq  *%rax
  8020a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a8:	79 05                	jns    8020af <close+0x31>
		return r;
  8020aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ad:	eb 18                	jmp    8020c7 <close+0x49>
	else
		return fd_close(fd, 1);
  8020af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b3:	be 01 00 00 00       	mov    $0x1,%esi
  8020b8:	48 89 c7             	mov    %rax,%rdi
  8020bb:	48 b8 fe 1e 80 00 00 	movabs $0x801efe,%rax
  8020c2:	00 00 00 
  8020c5:	ff d0                	callq  *%rax
}
  8020c7:	c9                   	leaveq 
  8020c8:	c3                   	retq   

00000000008020c9 <close_all>:

void
close_all(void)
{
  8020c9:	55                   	push   %rbp
  8020ca:	48 89 e5             	mov    %rsp,%rbp
  8020cd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020d8:	eb 15                	jmp    8020ef <close_all+0x26>
		close(i);
  8020da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020dd:	89 c7                	mov    %eax,%edi
  8020df:	48 b8 7e 20 80 00 00 	movabs $0x80207e,%rax
  8020e6:	00 00 00 
  8020e9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020eb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020ef:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020f3:	7e e5                	jle    8020da <close_all+0x11>
		close(i);
}
  8020f5:	c9                   	leaveq 
  8020f6:	c3                   	retq   

00000000008020f7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020f7:	55                   	push   %rbp
  8020f8:	48 89 e5             	mov    %rsp,%rbp
  8020fb:	48 83 ec 40          	sub    $0x40,%rsp
  8020ff:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802102:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802105:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802109:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80210c:	48 89 d6             	mov    %rdx,%rsi
  80210f:	89 c7                	mov    %eax,%edi
  802111:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  802118:	00 00 00 
  80211b:	ff d0                	callq  *%rax
  80211d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802120:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802124:	79 08                	jns    80212e <dup+0x37>
		return r;
  802126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802129:	e9 70 01 00 00       	jmpq   80229e <dup+0x1a7>
	close(newfdnum);
  80212e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802131:	89 c7                	mov    %eax,%edi
  802133:	48 b8 7e 20 80 00 00 	movabs $0x80207e,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80213f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802142:	48 98                	cltq   
  802144:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80214a:	48 c1 e0 0c          	shl    $0xc,%rax
  80214e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802152:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802156:	48 89 c7             	mov    %rax,%rdi
  802159:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  802160:	00 00 00 
  802163:	ff d0                	callq  *%rax
  802165:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80216d:	48 89 c7             	mov    %rax,%rdi
  802170:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  802177:	00 00 00 
  80217a:	ff d0                	callq  *%rax
  80217c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802184:	48 89 c2             	mov    %rax,%rdx
  802187:	48 c1 ea 15          	shr    $0x15,%rdx
  80218b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802192:	01 00 00 
  802195:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802199:	83 e0 01             	and    $0x1,%eax
  80219c:	84 c0                	test   %al,%al
  80219e:	74 71                	je     802211 <dup+0x11a>
  8021a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a4:	48 89 c2             	mov    %rax,%rdx
  8021a7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021b2:	01 00 00 
  8021b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b9:	83 e0 01             	and    $0x1,%eax
  8021bc:	84 c0                	test   %al,%al
  8021be:	74 51                	je     802211 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c4:	48 89 c2             	mov    %rax,%rdx
  8021c7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021d2:	01 00 00 
  8021d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d9:	89 c1                	mov    %eax,%ecx
  8021db:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e9:	41 89 c8             	mov    %ecx,%r8d
  8021ec:	48 89 d1             	mov    %rdx,%rcx
  8021ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f4:	48 89 c6             	mov    %rax,%rsi
  8021f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fc:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  802203:	00 00 00 
  802206:	ff d0                	callq  *%rax
  802208:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80220f:	78 56                	js     802267 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802211:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802215:	48 89 c2             	mov    %rax,%rdx
  802218:	48 c1 ea 0c          	shr    $0xc,%rdx
  80221c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802223:	01 00 00 
  802226:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222a:	89 c1                	mov    %eax,%ecx
  80222c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802232:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802236:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80223a:	41 89 c8             	mov    %ecx,%r8d
  80223d:	48 89 d1             	mov    %rdx,%rcx
  802240:	ba 00 00 00 00       	mov    $0x0,%edx
  802245:	48 89 c6             	mov    %rax,%rsi
  802248:	bf 00 00 00 00       	mov    $0x0,%edi
  80224d:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  802254:	00 00 00 
  802257:	ff d0                	callq  *%rax
  802259:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802260:	78 08                	js     80226a <dup+0x173>
		goto err;

	return newfdnum;
  802262:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802265:	eb 37                	jmp    80229e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802267:	90                   	nop
  802268:	eb 01                	jmp    80226b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80226a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80226b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226f:	48 89 c6             	mov    %rax,%rsi
  802272:	bf 00 00 00 00       	mov    $0x0,%edi
  802277:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  80227e:	00 00 00 
  802281:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802283:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802287:	48 89 c6             	mov    %rax,%rsi
  80228a:	bf 00 00 00 00       	mov    $0x0,%edi
  80228f:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  802296:	00 00 00 
  802299:	ff d0                	callq  *%rax
	return r;
  80229b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80229e:	c9                   	leaveq 
  80229f:	c3                   	retq   

00000000008022a0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022a0:	55                   	push   %rbp
  8022a1:	48 89 e5             	mov    %rsp,%rbp
  8022a4:	48 83 ec 40          	sub    $0x40,%rsp
  8022a8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022af:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022b3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ba:	48 89 d6             	mov    %rdx,%rsi
  8022bd:	89 c7                	mov    %eax,%edi
  8022bf:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8022c6:	00 00 00 
  8022c9:	ff d0                	callq  *%rax
  8022cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d2:	78 24                	js     8022f8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d8:	8b 00                	mov    (%rax),%eax
  8022da:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022de:	48 89 d6             	mov    %rdx,%rsi
  8022e1:	89 c7                	mov    %eax,%edi
  8022e3:	48 b8 c7 1f 80 00 00 	movabs $0x801fc7,%rax
  8022ea:	00 00 00 
  8022ed:	ff d0                	callq  *%rax
  8022ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f6:	79 05                	jns    8022fd <read+0x5d>
		return r;
  8022f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fb:	eb 7a                	jmp    802377 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802301:	8b 40 08             	mov    0x8(%rax),%eax
  802304:	83 e0 03             	and    $0x3,%eax
  802307:	83 f8 01             	cmp    $0x1,%eax
  80230a:	75 3a                	jne    802346 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80230c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802313:	00 00 00 
  802316:	48 8b 00             	mov    (%rax),%rax
  802319:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80231f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802322:	89 c6                	mov    %eax,%esi
  802324:	48 bf 17 49 80 00 00 	movabs $0x804917,%rdi
  80232b:	00 00 00 
  80232e:	b8 00 00 00 00       	mov    $0x0,%eax
  802333:	48 b9 2f 05 80 00 00 	movabs $0x80052f,%rcx
  80233a:	00 00 00 
  80233d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80233f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802344:	eb 31                	jmp    802377 <read+0xd7>
	}
	if (!dev->dev_read)
  802346:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80234e:	48 85 c0             	test   %rax,%rax
  802351:	75 07                	jne    80235a <read+0xba>
		return -E_NOT_SUPP;
  802353:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802358:	eb 1d                	jmp    802377 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80235a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802366:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80236a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80236e:	48 89 ce             	mov    %rcx,%rsi
  802371:	48 89 c7             	mov    %rax,%rdi
  802374:	41 ff d0             	callq  *%r8
}
  802377:	c9                   	leaveq 
  802378:	c3                   	retq   

0000000000802379 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802379:	55                   	push   %rbp
  80237a:	48 89 e5             	mov    %rsp,%rbp
  80237d:	48 83 ec 30          	sub    $0x30,%rsp
  802381:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802384:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802388:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80238c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802393:	eb 46                	jmp    8023db <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802398:	48 98                	cltq   
  80239a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80239e:	48 29 c2             	sub    %rax,%rdx
  8023a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a4:	48 98                	cltq   
  8023a6:	48 89 c1             	mov    %rax,%rcx
  8023a9:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8023ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023b0:	48 89 ce             	mov    %rcx,%rsi
  8023b3:	89 c7                	mov    %eax,%edi
  8023b5:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  8023bc:	00 00 00 
  8023bf:	ff d0                	callq  *%rax
  8023c1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023c4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023c8:	79 05                	jns    8023cf <readn+0x56>
			return m;
  8023ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023cd:	eb 1d                	jmp    8023ec <readn+0x73>
		if (m == 0)
  8023cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023d3:	74 13                	je     8023e8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023d8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023de:	48 98                	cltq   
  8023e0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023e4:	72 af                	jb     802395 <readn+0x1c>
  8023e6:	eb 01                	jmp    8023e9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023e8:	90                   	nop
	}
	return tot;
  8023e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023ec:	c9                   	leaveq 
  8023ed:	c3                   	retq   

00000000008023ee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023ee:	55                   	push   %rbp
  8023ef:	48 89 e5             	mov    %rsp,%rbp
  8023f2:	48 83 ec 40          	sub    $0x40,%rsp
  8023f6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023fd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802401:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802405:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802408:	48 89 d6             	mov    %rdx,%rsi
  80240b:	89 c7                	mov    %eax,%edi
  80240d:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  802414:	00 00 00 
  802417:	ff d0                	callq  *%rax
  802419:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80241c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802420:	78 24                	js     802446 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802426:	8b 00                	mov    (%rax),%eax
  802428:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80242c:	48 89 d6             	mov    %rdx,%rsi
  80242f:	89 c7                	mov    %eax,%edi
  802431:	48 b8 c7 1f 80 00 00 	movabs $0x801fc7,%rax
  802438:	00 00 00 
  80243b:	ff d0                	callq  *%rax
  80243d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802440:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802444:	79 05                	jns    80244b <write+0x5d>
		return r;
  802446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802449:	eb 79                	jmp    8024c4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80244b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244f:	8b 40 08             	mov    0x8(%rax),%eax
  802452:	83 e0 03             	and    $0x3,%eax
  802455:	85 c0                	test   %eax,%eax
  802457:	75 3a                	jne    802493 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802459:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802460:	00 00 00 
  802463:	48 8b 00             	mov    (%rax),%rax
  802466:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80246c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80246f:	89 c6                	mov    %eax,%esi
  802471:	48 bf 33 49 80 00 00 	movabs $0x804933,%rdi
  802478:	00 00 00 
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
  802480:	48 b9 2f 05 80 00 00 	movabs $0x80052f,%rcx
  802487:	00 00 00 
  80248a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80248c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802491:	eb 31                	jmp    8024c4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802497:	48 8b 40 18          	mov    0x18(%rax),%rax
  80249b:	48 85 c0             	test   %rax,%rax
  80249e:	75 07                	jne    8024a7 <write+0xb9>
		return -E_NOT_SUPP;
  8024a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024a5:	eb 1d                	jmp    8024c4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8024a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ab:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8024af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024b7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024bb:	48 89 ce             	mov    %rcx,%rsi
  8024be:	48 89 c7             	mov    %rax,%rdi
  8024c1:	41 ff d0             	callq  *%r8
}
  8024c4:	c9                   	leaveq 
  8024c5:	c3                   	retq   

00000000008024c6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024c6:	55                   	push   %rbp
  8024c7:	48 89 e5             	mov    %rsp,%rbp
  8024ca:	48 83 ec 18          	sub    $0x18,%rsp
  8024ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024d1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024db:	48 89 d6             	mov    %rdx,%rsi
  8024de:	89 c7                	mov    %eax,%edi
  8024e0:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8024e7:	00 00 00 
  8024ea:	ff d0                	callq  *%rax
  8024ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f3:	79 05                	jns    8024fa <seek+0x34>
		return r;
  8024f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f8:	eb 0f                	jmp    802509 <seek+0x43>
	fd->fd_offset = offset;
  8024fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802501:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802504:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802509:	c9                   	leaveq 
  80250a:	c3                   	retq   

000000000080250b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80250b:	55                   	push   %rbp
  80250c:	48 89 e5             	mov    %rsp,%rbp
  80250f:	48 83 ec 30          	sub    $0x30,%rsp
  802513:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802516:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802519:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80251d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802520:	48 89 d6             	mov    %rdx,%rsi
  802523:	89 c7                	mov    %eax,%edi
  802525:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  80252c:	00 00 00 
  80252f:	ff d0                	callq  *%rax
  802531:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802534:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802538:	78 24                	js     80255e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80253a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253e:	8b 00                	mov    (%rax),%eax
  802540:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802544:	48 89 d6             	mov    %rdx,%rsi
  802547:	89 c7                	mov    %eax,%edi
  802549:	48 b8 c7 1f 80 00 00 	movabs $0x801fc7,%rax
  802550:	00 00 00 
  802553:	ff d0                	callq  *%rax
  802555:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802558:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255c:	79 05                	jns    802563 <ftruncate+0x58>
		return r;
  80255e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802561:	eb 72                	jmp    8025d5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802563:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802567:	8b 40 08             	mov    0x8(%rax),%eax
  80256a:	83 e0 03             	and    $0x3,%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	75 3a                	jne    8025ab <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802571:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802578:	00 00 00 
  80257b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80257e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802584:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802587:	89 c6                	mov    %eax,%esi
  802589:	48 bf 50 49 80 00 00 	movabs $0x804950,%rdi
  802590:	00 00 00 
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
  802598:	48 b9 2f 05 80 00 00 	movabs $0x80052f,%rcx
  80259f:	00 00 00 
  8025a2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025a9:	eb 2a                	jmp    8025d5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025af:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025b3:	48 85 c0             	test   %rax,%rax
  8025b6:	75 07                	jne    8025bf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025bd:	eb 16                	jmp    8025d5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8025c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8025ce:	89 d6                	mov    %edx,%esi
  8025d0:	48 89 c7             	mov    %rax,%rdi
  8025d3:	ff d1                	callq  *%rcx
}
  8025d5:	c9                   	leaveq 
  8025d6:	c3                   	retq   

00000000008025d7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025d7:	55                   	push   %rbp
  8025d8:	48 89 e5             	mov    %rsp,%rbp
  8025db:	48 83 ec 30          	sub    $0x30,%rsp
  8025df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025e6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025ed:	48 89 d6             	mov    %rdx,%rsi
  8025f0:	89 c7                	mov    %eax,%edi
  8025f2:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8025f9:	00 00 00 
  8025fc:	ff d0                	callq  *%rax
  8025fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802601:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802605:	78 24                	js     80262b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260b:	8b 00                	mov    (%rax),%eax
  80260d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802611:	48 89 d6             	mov    %rdx,%rsi
  802614:	89 c7                	mov    %eax,%edi
  802616:	48 b8 c7 1f 80 00 00 	movabs $0x801fc7,%rax
  80261d:	00 00 00 
  802620:	ff d0                	callq  *%rax
  802622:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802625:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802629:	79 05                	jns    802630 <fstat+0x59>
		return r;
  80262b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262e:	eb 5e                	jmp    80268e <fstat+0xb7>
	if (!dev->dev_stat)
  802630:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802634:	48 8b 40 28          	mov    0x28(%rax),%rax
  802638:	48 85 c0             	test   %rax,%rax
  80263b:	75 07                	jne    802644 <fstat+0x6d>
		return -E_NOT_SUPP;
  80263d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802642:	eb 4a                	jmp    80268e <fstat+0xb7>
	stat->st_name[0] = 0;
  802644:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802648:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80264b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80264f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802656:	00 00 00 
	stat->st_isdir = 0;
  802659:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80265d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802664:	00 00 00 
	stat->st_dev = dev;
  802667:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80266b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80266f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802676:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80267a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80267e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802682:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802686:	48 89 d6             	mov    %rdx,%rsi
  802689:	48 89 c7             	mov    %rax,%rdi
  80268c:	ff d1                	callq  *%rcx
}
  80268e:	c9                   	leaveq 
  80268f:	c3                   	retq   

0000000000802690 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802690:	55                   	push   %rbp
  802691:	48 89 e5             	mov    %rsp,%rbp
  802694:	48 83 ec 20          	sub    $0x20,%rsp
  802698:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80269c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a4:	be 00 00 00 00       	mov    $0x0,%esi
  8026a9:	48 89 c7             	mov    %rax,%rdi
  8026ac:	48 b8 7f 27 80 00 00 	movabs $0x80277f,%rax
  8026b3:	00 00 00 
  8026b6:	ff d0                	callq  *%rax
  8026b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bf:	79 05                	jns    8026c6 <stat+0x36>
		return fd;
  8026c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c4:	eb 2f                	jmp    8026f5 <stat+0x65>
	r = fstat(fd, stat);
  8026c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cd:	48 89 d6             	mov    %rdx,%rsi
  8026d0:	89 c7                	mov    %eax,%edi
  8026d2:	48 b8 d7 25 80 00 00 	movabs $0x8025d7,%rax
  8026d9:	00 00 00 
  8026dc:	ff d0                	callq  *%rax
  8026de:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e4:	89 c7                	mov    %eax,%edi
  8026e6:	48 b8 7e 20 80 00 00 	movabs $0x80207e,%rax
  8026ed:	00 00 00 
  8026f0:	ff d0                	callq  *%rax
	return r;
  8026f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026f5:	c9                   	leaveq 
  8026f6:	c3                   	retq   
	...

00000000008026f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026f8:	55                   	push   %rbp
  8026f9:	48 89 e5             	mov    %rsp,%rbp
  8026fc:	48 83 ec 10          	sub    $0x10,%rsp
  802700:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802703:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802707:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80270e:	00 00 00 
  802711:	8b 00                	mov    (%rax),%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	75 1d                	jne    802734 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802717:	bf 01 00 00 00       	mov    $0x1,%edi
  80271c:	48 b8 e2 3c 80 00 00 	movabs $0x803ce2,%rax
  802723:	00 00 00 
  802726:	ff d0                	callq  *%rax
  802728:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80272f:	00 00 00 
  802732:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802734:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80273b:	00 00 00 
  80273e:	8b 00                	mov    (%rax),%eax
  802740:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802743:	b9 07 00 00 00       	mov    $0x7,%ecx
  802748:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80274f:	00 00 00 
  802752:	89 c7                	mov    %eax,%edi
  802754:	48 b8 33 3c 80 00 00 	movabs $0x803c33,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802760:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802764:	ba 00 00 00 00       	mov    $0x0,%edx
  802769:	48 89 c6             	mov    %rax,%rsi
  80276c:	bf 00 00 00 00       	mov    $0x0,%edi
  802771:	48 b8 4c 3b 80 00 00 	movabs $0x803b4c,%rax
  802778:	00 00 00 
  80277b:	ff d0                	callq  *%rax
}
  80277d:	c9                   	leaveq 
  80277e:	c3                   	retq   

000000000080277f <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  80277f:	55                   	push   %rbp
  802780:	48 89 e5             	mov    %rsp,%rbp
  802783:	48 83 ec 20          	sub    $0x20,%rsp
  802787:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80278b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  80278e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802792:	48 89 c7             	mov    %rax,%rdi
  802795:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  80279c:	00 00 00 
  80279f:	ff d0                	callq  *%rax
  8027a1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027a6:	7e 0a                	jle    8027b2 <open+0x33>
		return -E_BAD_PATH;
  8027a8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027ad:	e9 a5 00 00 00       	jmpq   802857 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  8027b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027b6:	48 89 c7             	mov    %rax,%rdi
  8027b9:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  8027c0:	00 00 00 
  8027c3:	ff d0                	callq  *%rax
  8027c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8027c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027cc:	79 08                	jns    8027d6 <open+0x57>
		return r;
  8027ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d1:	e9 81 00 00 00       	jmpq   802857 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  8027d6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027dd:	00 00 00 
  8027e0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027e3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8027e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ed:	48 89 c6             	mov    %rax,%rsi
  8027f0:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027f7:	00 00 00 
  8027fa:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  802801:	00 00 00 
  802804:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  802806:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280a:	48 89 c6             	mov    %rax,%rsi
  80280d:	bf 01 00 00 00       	mov    $0x1,%edi
  802812:	48 b8 f8 26 80 00 00 	movabs $0x8026f8,%rax
  802819:	00 00 00 
  80281c:	ff d0                	callq  *%rax
  80281e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802821:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802825:	79 1d                	jns    802844 <open+0xc5>
		fd_close(new_fd, 0);
  802827:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282b:	be 00 00 00 00       	mov    $0x0,%esi
  802830:	48 89 c7             	mov    %rax,%rdi
  802833:	48 b8 fe 1e 80 00 00 	movabs $0x801efe,%rax
  80283a:	00 00 00 
  80283d:	ff d0                	callq  *%rax
		return r;	
  80283f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802842:	eb 13                	jmp    802857 <open+0xd8>
	}
	return fd2num(new_fd);
  802844:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802848:	48 89 c7             	mov    %rax,%rdi
  80284b:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  802852:	00 00 00 
  802855:	ff d0                	callq  *%rax
}
  802857:	c9                   	leaveq 
  802858:	c3                   	retq   

0000000000802859 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802859:	55                   	push   %rbp
  80285a:	48 89 e5             	mov    %rsp,%rbp
  80285d:	48 83 ec 10          	sub    $0x10,%rsp
  802861:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802869:	8b 50 0c             	mov    0xc(%rax),%edx
  80286c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802873:	00 00 00 
  802876:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802878:	be 00 00 00 00       	mov    $0x0,%esi
  80287d:	bf 06 00 00 00       	mov    $0x6,%edi
  802882:	48 b8 f8 26 80 00 00 	movabs $0x8026f8,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax
}
  80288e:	c9                   	leaveq 
  80288f:	c3                   	retq   

0000000000802890 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802890:	55                   	push   %rbp
  802891:	48 89 e5             	mov    %rsp,%rbp
  802894:	48 83 ec 30          	sub    $0x30,%rsp
  802898:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80289c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  8028a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028b2:	00 00 00 
  8028b5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028be:	00 00 00 
  8028c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028c5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8028c9:	be 00 00 00 00       	mov    $0x0,%esi
  8028ce:	bf 03 00 00 00       	mov    $0x3,%edi
  8028d3:	48 b8 f8 26 80 00 00 	movabs $0x8026f8,%rax
  8028da:	00 00 00 
  8028dd:	ff d0                	callq  *%rax
  8028df:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8028e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e6:	7e 23                	jle    80290b <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8028e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028eb:	48 63 d0             	movslq %eax,%rdx
  8028ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028f9:	00 00 00 
  8028fc:	48 89 c7             	mov    %rax,%rdi
  8028ff:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  802906:	00 00 00 
  802909:	ff d0                	callq  *%rax
	}
	return nbytes;
  80290b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80290e:	c9                   	leaveq 
  80290f:	c3                   	retq   

0000000000802910 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802910:	55                   	push   %rbp
  802911:	48 89 e5             	mov    %rsp,%rbp
  802914:	48 83 ec 20          	sub    $0x20,%rsp
  802918:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80291c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802924:	8b 50 0c             	mov    0xc(%rax),%edx
  802927:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80292e:	00 00 00 
  802931:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802933:	be 00 00 00 00       	mov    $0x0,%esi
  802938:	bf 05 00 00 00       	mov    $0x5,%edi
  80293d:	48 b8 f8 26 80 00 00 	movabs $0x8026f8,%rax
  802944:	00 00 00 
  802947:	ff d0                	callq  *%rax
  802949:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802950:	79 05                	jns    802957 <devfile_stat+0x47>
		return r;
  802952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802955:	eb 56                	jmp    8029ad <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802957:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802962:	00 00 00 
  802965:	48 89 c7             	mov    %rax,%rdi
  802968:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802974:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80297b:	00 00 00 
  80297e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802984:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802988:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80298e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802995:	00 00 00 
  802998:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80299e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ad:	c9                   	leaveq 
  8029ae:	c3                   	retq   
	...

00000000008029b0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8029b0:	55                   	push   %rbp
  8029b1:	48 89 e5             	mov    %rsp,%rbp
  8029b4:	48 83 ec 20          	sub    $0x20,%rsp
  8029b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8029bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029c2:	48 89 d6             	mov    %rdx,%rsi
  8029c5:	89 c7                	mov    %eax,%edi
  8029c7:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8029ce:	00 00 00 
  8029d1:	ff d0                	callq  *%rax
  8029d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029da:	79 05                	jns    8029e1 <fd2sockid+0x31>
		return r;
  8029dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029df:	eb 24                	jmp    802a05 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8029e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e5:	8b 10                	mov    (%rax),%edx
  8029e7:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8029ee:	00 00 00 
  8029f1:	8b 00                	mov    (%rax),%eax
  8029f3:	39 c2                	cmp    %eax,%edx
  8029f5:	74 07                	je     8029fe <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8029f7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029fc:	eb 07                	jmp    802a05 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8029fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a02:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802a05:	c9                   	leaveq 
  802a06:	c3                   	retq   

0000000000802a07 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802a07:	55                   	push   %rbp
  802a08:	48 89 e5             	mov    %rsp,%rbp
  802a0b:	48 83 ec 20          	sub    $0x20,%rsp
  802a0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802a12:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802a16:	48 89 c7             	mov    %rax,%rdi
  802a19:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  802a20:	00 00 00 
  802a23:	ff d0                	callq  *%rax
  802a25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2c:	78 26                	js     802a54 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802a2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a32:	ba 07 04 00 00       	mov    $0x407,%edx
  802a37:	48 89 c6             	mov    %rax,%rsi
  802a3a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a3f:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a52:	79 16                	jns    802a6a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802a54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a57:	89 c7                	mov    %eax,%edi
  802a59:	48 b8 14 2f 80 00 00 	movabs $0x802f14,%rax
  802a60:	00 00 00 
  802a63:	ff d0                	callq  *%rax
		return r;
  802a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a68:	eb 3a                	jmp    802aa4 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6e:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802a75:	00 00 00 
  802a78:	8b 12                	mov    (%rdx),%edx
  802a7a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802a7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a80:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a8e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802a91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a95:	48 89 c7             	mov    %rax,%rdi
  802a98:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  802a9f:	00 00 00 
  802aa2:	ff d0                	callq  *%rax
}
  802aa4:	c9                   	leaveq 
  802aa5:	c3                   	retq   

0000000000802aa6 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802aa6:	55                   	push   %rbp
  802aa7:	48 89 e5             	mov    %rsp,%rbp
  802aaa:	48 83 ec 30          	sub    $0x30,%rsp
  802aae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ab1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ab5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ab9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802abc:	89 c7                	mov    %eax,%edi
  802abe:	48 b8 b0 29 80 00 00 	movabs $0x8029b0,%rax
  802ac5:	00 00 00 
  802ac8:	ff d0                	callq  *%rax
  802aca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad1:	79 05                	jns    802ad8 <accept+0x32>
		return r;
  802ad3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad6:	eb 3b                	jmp    802b13 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802ad8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802adc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae3:	48 89 ce             	mov    %rcx,%rsi
  802ae6:	89 c7                	mov    %eax,%edi
  802ae8:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	callq  *%rax
  802af4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afb:	79 05                	jns    802b02 <accept+0x5c>
		return r;
  802afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b00:	eb 11                	jmp    802b13 <accept+0x6d>
	return alloc_sockfd(r);
  802b02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b05:	89 c7                	mov    %eax,%edi
  802b07:	48 b8 07 2a 80 00 00 	movabs $0x802a07,%rax
  802b0e:	00 00 00 
  802b11:	ff d0                	callq  *%rax
}
  802b13:	c9                   	leaveq 
  802b14:	c3                   	retq   

0000000000802b15 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802b15:	55                   	push   %rbp
  802b16:	48 89 e5             	mov    %rsp,%rbp
  802b19:	48 83 ec 20          	sub    $0x20,%rsp
  802b1d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b20:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b24:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b2a:	89 c7                	mov    %eax,%edi
  802b2c:	48 b8 b0 29 80 00 00 	movabs $0x8029b0,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
  802b38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3f:	79 05                	jns    802b46 <bind+0x31>
		return r;
  802b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b44:	eb 1b                	jmp    802b61 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802b46:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b49:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b50:	48 89 ce             	mov    %rcx,%rsi
  802b53:	89 c7                	mov    %eax,%edi
  802b55:	48 b8 70 2e 80 00 00 	movabs $0x802e70,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
}
  802b61:	c9                   	leaveq 
  802b62:	c3                   	retq   

0000000000802b63 <shutdown>:

int
shutdown(int s, int how)
{
  802b63:	55                   	push   %rbp
  802b64:	48 89 e5             	mov    %rsp,%rbp
  802b67:	48 83 ec 20          	sub    $0x20,%rsp
  802b6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b6e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b74:	89 c7                	mov    %eax,%edi
  802b76:	48 b8 b0 29 80 00 00 	movabs $0x8029b0,%rax
  802b7d:	00 00 00 
  802b80:	ff d0                	callq  *%rax
  802b82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b89:	79 05                	jns    802b90 <shutdown+0x2d>
		return r;
  802b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8e:	eb 16                	jmp    802ba6 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802b90:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b96:	89 d6                	mov    %edx,%esi
  802b98:	89 c7                	mov    %eax,%edi
  802b9a:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  802ba1:	00 00 00 
  802ba4:	ff d0                	callq  *%rax
}
  802ba6:	c9                   	leaveq 
  802ba7:	c3                   	retq   

0000000000802ba8 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802ba8:	55                   	push   %rbp
  802ba9:	48 89 e5             	mov    %rsp,%rbp
  802bac:	48 83 ec 10          	sub    $0x10,%rsp
  802bb0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802bb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb8:	48 89 c7             	mov    %rax,%rdi
  802bbb:	48 b8 70 3d 80 00 00 	movabs $0x803d70,%rax
  802bc2:	00 00 00 
  802bc5:	ff d0                	callq  *%rax
  802bc7:	83 f8 01             	cmp    $0x1,%eax
  802bca:	75 17                	jne    802be3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802bcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd0:	8b 40 0c             	mov    0xc(%rax),%eax
  802bd3:	89 c7                	mov    %eax,%edi
  802bd5:	48 b8 14 2f 80 00 00 	movabs $0x802f14,%rax
  802bdc:	00 00 00 
  802bdf:	ff d0                	callq  *%rax
  802be1:	eb 05                	jmp    802be8 <devsock_close+0x40>
	else
		return 0;
  802be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be8:	c9                   	leaveq 
  802be9:	c3                   	retq   

0000000000802bea <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802bea:	55                   	push   %rbp
  802beb:	48 89 e5             	mov    %rsp,%rbp
  802bee:	48 83 ec 20          	sub    $0x20,%rsp
  802bf2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bf5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bf9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bfc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bff:	89 c7                	mov    %eax,%edi
  802c01:	48 b8 b0 29 80 00 00 	movabs $0x8029b0,%rax
  802c08:	00 00 00 
  802c0b:	ff d0                	callq  *%rax
  802c0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c14:	79 05                	jns    802c1b <connect+0x31>
		return r;
  802c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c19:	eb 1b                	jmp    802c36 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802c1b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c1e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c25:	48 89 ce             	mov    %rcx,%rsi
  802c28:	89 c7                	mov    %eax,%edi
  802c2a:	48 b8 41 2f 80 00 00 	movabs $0x802f41,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	callq  *%rax
}
  802c36:	c9                   	leaveq 
  802c37:	c3                   	retq   

0000000000802c38 <listen>:

int
listen(int s, int backlog)
{
  802c38:	55                   	push   %rbp
  802c39:	48 89 e5             	mov    %rsp,%rbp
  802c3c:	48 83 ec 20          	sub    $0x20,%rsp
  802c40:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c43:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c49:	89 c7                	mov    %eax,%edi
  802c4b:	48 b8 b0 29 80 00 00 	movabs $0x8029b0,%rax
  802c52:	00 00 00 
  802c55:	ff d0                	callq  *%rax
  802c57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5e:	79 05                	jns    802c65 <listen+0x2d>
		return r;
  802c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c63:	eb 16                	jmp    802c7b <listen+0x43>
	return nsipc_listen(r, backlog);
  802c65:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6b:	89 d6                	mov    %edx,%esi
  802c6d:	89 c7                	mov    %eax,%edi
  802c6f:	48 b8 a5 2f 80 00 00 	movabs $0x802fa5,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
}
  802c7b:	c9                   	leaveq 
  802c7c:	c3                   	retq   

0000000000802c7d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802c7d:	55                   	push   %rbp
  802c7e:	48 89 e5             	mov    %rsp,%rbp
  802c81:	48 83 ec 20          	sub    $0x20,%rsp
  802c85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c89:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c8d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c95:	89 c2                	mov    %eax,%edx
  802c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c9b:	8b 40 0c             	mov    0xc(%rax),%eax
  802c9e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802ca2:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ca7:	89 c7                	mov    %eax,%edi
  802ca9:	48 b8 e5 2f 80 00 00 	movabs $0x802fe5,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax
}
  802cb5:	c9                   	leaveq 
  802cb6:	c3                   	retq   

0000000000802cb7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802cb7:	55                   	push   %rbp
  802cb8:	48 89 e5             	mov    %rsp,%rbp
  802cbb:	48 83 ec 20          	sub    $0x20,%rsp
  802cbf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802cc7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccf:	89 c2                	mov    %eax,%edx
  802cd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd5:	8b 40 0c             	mov    0xc(%rax),%eax
  802cd8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802cdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ce1:	89 c7                	mov    %eax,%edi
  802ce3:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
}
  802cef:	c9                   	leaveq 
  802cf0:	c3                   	retq   

0000000000802cf1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802cf1:	55                   	push   %rbp
  802cf2:	48 89 e5             	mov    %rsp,%rbp
  802cf5:	48 83 ec 10          	sub    $0x10,%rsp
  802cf9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cfd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d05:	48 be 7b 49 80 00 00 	movabs $0x80497b,%rsi
  802d0c:	00 00 00 
  802d0f:	48 89 c7             	mov    %rax,%rdi
  802d12:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  802d19:	00 00 00 
  802d1c:	ff d0                	callq  *%rax
	return 0;
  802d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d23:	c9                   	leaveq 
  802d24:	c3                   	retq   

0000000000802d25 <socket>:

int
socket(int domain, int type, int protocol)
{
  802d25:	55                   	push   %rbp
  802d26:	48 89 e5             	mov    %rsp,%rbp
  802d29:	48 83 ec 20          	sub    $0x20,%rsp
  802d2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d30:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802d33:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802d36:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d39:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802d3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d3f:	89 ce                	mov    %ecx,%esi
  802d41:	89 c7                	mov    %eax,%edi
  802d43:	48 b8 69 31 80 00 00 	movabs $0x803169,%rax
  802d4a:	00 00 00 
  802d4d:	ff d0                	callq  *%rax
  802d4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d56:	79 05                	jns    802d5d <socket+0x38>
		return r;
  802d58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5b:	eb 11                	jmp    802d6e <socket+0x49>
	return alloc_sockfd(r);
  802d5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d60:	89 c7                	mov    %eax,%edi
  802d62:	48 b8 07 2a 80 00 00 	movabs $0x802a07,%rax
  802d69:	00 00 00 
  802d6c:	ff d0                	callq  *%rax
}
  802d6e:	c9                   	leaveq 
  802d6f:	c3                   	retq   

0000000000802d70 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802d70:	55                   	push   %rbp
  802d71:	48 89 e5             	mov    %rsp,%rbp
  802d74:	48 83 ec 10          	sub    $0x10,%rsp
  802d78:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802d7b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802d82:	00 00 00 
  802d85:	8b 00                	mov    (%rax),%eax
  802d87:	85 c0                	test   %eax,%eax
  802d89:	75 1d                	jne    802da8 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802d8b:	bf 02 00 00 00       	mov    $0x2,%edi
  802d90:	48 b8 e2 3c 80 00 00 	movabs $0x803ce2,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	callq  *%rax
  802d9c:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802da3:	00 00 00 
  802da6:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802da8:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802daf:	00 00 00 
  802db2:	8b 00                	mov    (%rax),%eax
  802db4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802db7:	b9 07 00 00 00       	mov    $0x7,%ecx
  802dbc:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802dc3:	00 00 00 
  802dc6:	89 c7                	mov    %eax,%edi
  802dc8:	48 b8 33 3c 80 00 00 	movabs $0x803c33,%rax
  802dcf:	00 00 00 
  802dd2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802dd4:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd9:	be 00 00 00 00       	mov    $0x0,%esi
  802dde:	bf 00 00 00 00       	mov    $0x0,%edi
  802de3:	48 b8 4c 3b 80 00 00 	movabs $0x803b4c,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
}
  802def:	c9                   	leaveq 
  802df0:	c3                   	retq   

0000000000802df1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802df1:	55                   	push   %rbp
  802df2:	48 89 e5             	mov    %rsp,%rbp
  802df5:	48 83 ec 30          	sub    $0x30,%rsp
  802df9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dfc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802e04:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e0b:	00 00 00 
  802e0e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e11:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802e13:	bf 01 00 00 00       	mov    $0x1,%edi
  802e18:	48 b8 70 2d 80 00 00 	movabs $0x802d70,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
  802e24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2b:	78 3e                	js     802e6b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802e2d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e34:	00 00 00 
  802e37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3f:	8b 40 10             	mov    0x10(%rax),%eax
  802e42:	89 c2                	mov    %eax,%edx
  802e44:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802e48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e4c:	48 89 ce             	mov    %rcx,%rsi
  802e4f:	48 89 c7             	mov    %rax,%rdi
  802e52:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  802e59:	00 00 00 
  802e5c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e62:	8b 50 10             	mov    0x10(%rax),%edx
  802e65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e69:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802e6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e6e:	c9                   	leaveq 
  802e6f:	c3                   	retq   

0000000000802e70 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e70:	55                   	push   %rbp
  802e71:	48 89 e5             	mov    %rsp,%rbp
  802e74:	48 83 ec 10          	sub    $0x10,%rsp
  802e78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e7f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802e82:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e89:	00 00 00 
  802e8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e8f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802e91:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e98:	48 89 c6             	mov    %rax,%rsi
  802e9b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802ea2:	00 00 00 
  802ea5:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  802eac:	00 00 00 
  802eaf:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802eb1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802eb8:	00 00 00 
  802ebb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ebe:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802ec1:	bf 02 00 00 00       	mov    $0x2,%edi
  802ec6:	48 b8 70 2d 80 00 00 	movabs $0x802d70,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
}
  802ed2:	c9                   	leaveq 
  802ed3:	c3                   	retq   

0000000000802ed4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
  802ed8:	48 83 ec 10          	sub    $0x10,%rsp
  802edc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802edf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802ee2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ee9:	00 00 00 
  802eec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802eef:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802ef1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ef8:	00 00 00 
  802efb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802f01:	bf 03 00 00 00       	mov    $0x3,%edi
  802f06:	48 b8 70 2d 80 00 00 	movabs $0x802d70,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
}
  802f12:	c9                   	leaveq 
  802f13:	c3                   	retq   

0000000000802f14 <nsipc_close>:

int
nsipc_close(int s)
{
  802f14:	55                   	push   %rbp
  802f15:	48 89 e5             	mov    %rsp,%rbp
  802f18:	48 83 ec 10          	sub    $0x10,%rsp
  802f1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802f1f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f26:	00 00 00 
  802f29:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f2c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802f2e:	bf 04 00 00 00       	mov    $0x4,%edi
  802f33:	48 b8 70 2d 80 00 00 	movabs $0x802d70,%rax
  802f3a:	00 00 00 
  802f3d:	ff d0                	callq  *%rax
}
  802f3f:	c9                   	leaveq 
  802f40:	c3                   	retq   

0000000000802f41 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f41:	55                   	push   %rbp
  802f42:	48 89 e5             	mov    %rsp,%rbp
  802f45:	48 83 ec 10          	sub    $0x10,%rsp
  802f49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f50:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802f53:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f5a:	00 00 00 
  802f5d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f60:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802f62:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f69:	48 89 c6             	mov    %rax,%rsi
  802f6c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802f73:	00 00 00 
  802f76:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  802f7d:	00 00 00 
  802f80:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  802f82:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f89:	00 00 00 
  802f8c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f8f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  802f92:	bf 05 00 00 00       	mov    $0x5,%edi
  802f97:	48 b8 70 2d 80 00 00 	movabs $0x802d70,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
}
  802fa3:	c9                   	leaveq 
  802fa4:	c3                   	retq   

0000000000802fa5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802fa5:	55                   	push   %rbp
  802fa6:	48 89 e5             	mov    %rsp,%rbp
  802fa9:	48 83 ec 10          	sub    $0x10,%rsp
  802fad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fb0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  802fb3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fba:	00 00 00 
  802fbd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fc0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  802fc2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fc9:	00 00 00 
  802fcc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fcf:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  802fd2:	bf 06 00 00 00       	mov    $0x6,%edi
  802fd7:	48 b8 70 2d 80 00 00 	movabs $0x802d70,%rax
  802fde:	00 00 00 
  802fe1:	ff d0                	callq  *%rax
}
  802fe3:	c9                   	leaveq 
  802fe4:	c3                   	retq   

0000000000802fe5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802fe5:	55                   	push   %rbp
  802fe6:	48 89 e5             	mov    %rsp,%rbp
  802fe9:	48 83 ec 30          	sub    $0x30,%rsp
  802fed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ff0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802ff7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802ffa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803001:	00 00 00 
  803004:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803007:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803009:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803010:	00 00 00 
  803013:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803016:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803019:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803020:	00 00 00 
  803023:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803026:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803029:	bf 07 00 00 00       	mov    $0x7,%edi
  80302e:	48 b8 70 2d 80 00 00 	movabs $0x802d70,%rax
  803035:	00 00 00 
  803038:	ff d0                	callq  *%rax
  80303a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80303d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803041:	78 69                	js     8030ac <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803043:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80304a:	7f 08                	jg     803054 <nsipc_recv+0x6f>
  80304c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803052:	7e 35                	jle    803089 <nsipc_recv+0xa4>
  803054:	48 b9 82 49 80 00 00 	movabs $0x804982,%rcx
  80305b:	00 00 00 
  80305e:	48 ba 97 49 80 00 00 	movabs $0x804997,%rdx
  803065:	00 00 00 
  803068:	be 61 00 00 00       	mov    $0x61,%esi
  80306d:	48 bf ac 49 80 00 00 	movabs $0x8049ac,%rdi
  803074:	00 00 00 
  803077:	b8 00 00 00 00       	mov    $0x0,%eax
  80307c:	49 b8 38 3a 80 00 00 	movabs $0x803a38,%r8
  803083:	00 00 00 
  803086:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308c:	48 63 d0             	movslq %eax,%rdx
  80308f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803093:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80309a:	00 00 00 
  80309d:	48 89 c7             	mov    %rax,%rdi
  8030a0:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  8030a7:	00 00 00 
  8030aa:	ff d0                	callq  *%rax
	}

	return r;
  8030ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030af:	c9                   	leaveq 
  8030b0:	c3                   	retq   

00000000008030b1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8030b1:	55                   	push   %rbp
  8030b2:	48 89 e5             	mov    %rsp,%rbp
  8030b5:	48 83 ec 20          	sub    $0x20,%rsp
  8030b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030c0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8030c3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8030c6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030cd:	00 00 00 
  8030d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030d3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8030d5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8030dc:	7e 35                	jle    803113 <nsipc_send+0x62>
  8030de:	48 b9 b8 49 80 00 00 	movabs $0x8049b8,%rcx
  8030e5:	00 00 00 
  8030e8:	48 ba 97 49 80 00 00 	movabs $0x804997,%rdx
  8030ef:	00 00 00 
  8030f2:	be 6c 00 00 00       	mov    $0x6c,%esi
  8030f7:	48 bf ac 49 80 00 00 	movabs $0x8049ac,%rdi
  8030fe:	00 00 00 
  803101:	b8 00 00 00 00       	mov    $0x0,%eax
  803106:	49 b8 38 3a 80 00 00 	movabs $0x803a38,%r8
  80310d:	00 00 00 
  803110:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803113:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803116:	48 63 d0             	movslq %eax,%rdx
  803119:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311d:	48 89 c6             	mov    %rax,%rsi
  803120:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803127:	00 00 00 
  80312a:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803131:	00 00 00 
  803134:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803136:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80313d:	00 00 00 
  803140:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803143:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803146:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80314d:	00 00 00 
  803150:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803153:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803156:	bf 08 00 00 00       	mov    $0x8,%edi
  80315b:	48 b8 70 2d 80 00 00 	movabs $0x802d70,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
}
  803167:	c9                   	leaveq 
  803168:	c3                   	retq   

0000000000803169 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803169:	55                   	push   %rbp
  80316a:	48 89 e5             	mov    %rsp,%rbp
  80316d:	48 83 ec 10          	sub    $0x10,%rsp
  803171:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803174:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803177:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80317a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803181:	00 00 00 
  803184:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803187:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803189:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803190:	00 00 00 
  803193:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803196:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803199:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031a0:	00 00 00 
  8031a3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031a6:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8031a9:	bf 09 00 00 00       	mov    $0x9,%edi
  8031ae:	48 b8 70 2d 80 00 00 	movabs $0x802d70,%rax
  8031b5:	00 00 00 
  8031b8:	ff d0                	callq  *%rax
}
  8031ba:	c9                   	leaveq 
  8031bb:	c3                   	retq   

00000000008031bc <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031bc:	55                   	push   %rbp
  8031bd:	48 89 e5             	mov    %rsp,%rbp
  8031c0:	53                   	push   %rbx
  8031c1:	48 83 ec 38          	sub    $0x38,%rsp
  8031c5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031c9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031cd:	48 89 c7             	mov    %rax,%rdi
  8031d0:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  8031d7:	00 00 00 
  8031da:	ff d0                	callq  *%rax
  8031dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031e3:	0f 88 bf 01 00 00    	js     8033a8 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ed:	ba 07 04 00 00       	mov    $0x407,%edx
  8031f2:	48 89 c6             	mov    %rax,%rsi
  8031f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8031fa:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803201:	00 00 00 
  803204:	ff d0                	callq  *%rax
  803206:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803209:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80320d:	0f 88 95 01 00 00    	js     8033a8 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803213:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803217:	48 89 c7             	mov    %rax,%rdi
  80321a:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  803221:	00 00 00 
  803224:	ff d0                	callq  *%rax
  803226:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803229:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80322d:	0f 88 5d 01 00 00    	js     803390 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803233:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803237:	ba 07 04 00 00       	mov    $0x407,%edx
  80323c:	48 89 c6             	mov    %rax,%rsi
  80323f:	bf 00 00 00 00       	mov    $0x0,%edi
  803244:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  80324b:	00 00 00 
  80324e:	ff d0                	callq  *%rax
  803250:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803253:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803257:	0f 88 33 01 00 00    	js     803390 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80325d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803261:	48 89 c7             	mov    %rax,%rdi
  803264:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
  803270:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803274:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803278:	ba 07 04 00 00       	mov    $0x407,%edx
  80327d:	48 89 c6             	mov    %rax,%rsi
  803280:	bf 00 00 00 00       	mov    $0x0,%edi
  803285:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  80328c:	00 00 00 
  80328f:	ff d0                	callq  *%rax
  803291:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803294:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803298:	0f 88 d9 00 00 00    	js     803377 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80329e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a2:	48 89 c7             	mov    %rax,%rdi
  8032a5:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8032ac:	00 00 00 
  8032af:	ff d0                	callq  *%rax
  8032b1:	48 89 c2             	mov    %rax,%rdx
  8032b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032b8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8032be:	48 89 d1             	mov    %rdx,%rcx
  8032c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8032c6:	48 89 c6             	mov    %rax,%rsi
  8032c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ce:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
  8032da:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032e1:	78 79                	js     80335c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8032e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8032ee:	00 00 00 
  8032f1:	8b 12                	mov    (%rdx),%edx
  8032f3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8032f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803300:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803304:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80330b:	00 00 00 
  80330e:	8b 12                	mov    (%rdx),%edx
  803310:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803312:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803316:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80331d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803321:	48 89 c7             	mov    %rax,%rdi
  803324:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  80332b:	00 00 00 
  80332e:	ff d0                	callq  *%rax
  803330:	89 c2                	mov    %eax,%edx
  803332:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803336:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803338:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80333c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803340:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803344:	48 89 c7             	mov    %rax,%rdi
  803347:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  80334e:	00 00 00 
  803351:	ff d0                	callq  *%rax
  803353:	89 03                	mov    %eax,(%rbx)
	return 0;
  803355:	b8 00 00 00 00       	mov    $0x0,%eax
  80335a:	eb 4f                	jmp    8033ab <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80335c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80335d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803361:	48 89 c6             	mov    %rax,%rsi
  803364:	bf 00 00 00 00       	mov    $0x0,%edi
  803369:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
  803375:	eb 01                	jmp    803378 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803377:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803378:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80337c:	48 89 c6             	mov    %rax,%rsi
  80337f:	bf 00 00 00 00       	mov    $0x0,%edi
  803384:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803390:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803394:	48 89 c6             	mov    %rax,%rsi
  803397:	bf 00 00 00 00       	mov    $0x0,%edi
  80339c:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  8033a3:	00 00 00 
  8033a6:	ff d0                	callq  *%rax
err:
	return r;
  8033a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033ab:	48 83 c4 38          	add    $0x38,%rsp
  8033af:	5b                   	pop    %rbx
  8033b0:	5d                   	pop    %rbp
  8033b1:	c3                   	retq   

00000000008033b2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8033b2:	55                   	push   %rbp
  8033b3:	48 89 e5             	mov    %rsp,%rbp
  8033b6:	53                   	push   %rbx
  8033b7:	48 83 ec 28          	sub    $0x28,%rsp
  8033bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033c3:	eb 01                	jmp    8033c6 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8033c5:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033c6:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8033cd:	00 00 00 
  8033d0:	48 8b 00             	mov    (%rax),%rax
  8033d3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8033dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e0:	48 89 c7             	mov    %rax,%rdi
  8033e3:	48 b8 70 3d 80 00 00 	movabs $0x803d70,%rax
  8033ea:	00 00 00 
  8033ed:	ff d0                	callq  *%rax
  8033ef:	89 c3                	mov    %eax,%ebx
  8033f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033f5:	48 89 c7             	mov    %rax,%rdi
  8033f8:	48 b8 70 3d 80 00 00 	movabs $0x803d70,%rax
  8033ff:	00 00 00 
  803402:	ff d0                	callq  *%rax
  803404:	39 c3                	cmp    %eax,%ebx
  803406:	0f 94 c0             	sete   %al
  803409:	0f b6 c0             	movzbl %al,%eax
  80340c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80340f:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803416:	00 00 00 
  803419:	48 8b 00             	mov    (%rax),%rax
  80341c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803422:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803425:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803428:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80342b:	75 0a                	jne    803437 <_pipeisclosed+0x85>
			return ret;
  80342d:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803430:	48 83 c4 28          	add    $0x28,%rsp
  803434:	5b                   	pop    %rbx
  803435:	5d                   	pop    %rbp
  803436:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803437:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80343a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80343d:	74 86                	je     8033c5 <_pipeisclosed+0x13>
  80343f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803443:	75 80                	jne    8033c5 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803445:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80344c:	00 00 00 
  80344f:	48 8b 00             	mov    (%rax),%rax
  803452:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803458:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80345b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80345e:	89 c6                	mov    %eax,%esi
  803460:	48 bf c9 49 80 00 00 	movabs $0x8049c9,%rdi
  803467:	00 00 00 
  80346a:	b8 00 00 00 00       	mov    $0x0,%eax
  80346f:	49 b8 2f 05 80 00 00 	movabs $0x80052f,%r8
  803476:	00 00 00 
  803479:	41 ff d0             	callq  *%r8
	}
  80347c:	e9 44 ff ff ff       	jmpq   8033c5 <_pipeisclosed+0x13>

0000000000803481 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803481:	55                   	push   %rbp
  803482:	48 89 e5             	mov    %rsp,%rbp
  803485:	48 83 ec 30          	sub    $0x30,%rsp
  803489:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80348c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803490:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803493:	48 89 d6             	mov    %rdx,%rsi
  803496:	89 c7                	mov    %eax,%edi
  803498:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
  8034a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ab:	79 05                	jns    8034b2 <pipeisclosed+0x31>
		return r;
  8034ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b0:	eb 31                	jmp    8034e3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8034b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b6:	48 89 c7             	mov    %rax,%rdi
  8034b9:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
  8034c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034d1:	48 89 d6             	mov    %rdx,%rsi
  8034d4:	48 89 c7             	mov    %rax,%rdi
  8034d7:	48 b8 b2 33 80 00 00 	movabs $0x8033b2,%rax
  8034de:	00 00 00 
  8034e1:	ff d0                	callq  *%rax
}
  8034e3:	c9                   	leaveq 
  8034e4:	c3                   	retq   

00000000008034e5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034e5:	55                   	push   %rbp
  8034e6:	48 89 e5             	mov    %rsp,%rbp
  8034e9:	48 83 ec 40          	sub    $0x40,%rsp
  8034ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034f5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034fd:	48 89 c7             	mov    %rax,%rdi
  803500:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
  80350c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803510:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803514:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803518:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80351f:	00 
  803520:	e9 97 00 00 00       	jmpq   8035bc <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803525:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80352a:	74 09                	je     803535 <devpipe_read+0x50>
				return i;
  80352c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803530:	e9 95 00 00 00       	jmpq   8035ca <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803535:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80353d:	48 89 d6             	mov    %rdx,%rsi
  803540:	48 89 c7             	mov    %rax,%rdi
  803543:	48 b8 b2 33 80 00 00 	movabs $0x8033b2,%rax
  80354a:	00 00 00 
  80354d:	ff d0                	callq  *%rax
  80354f:	85 c0                	test   %eax,%eax
  803551:	74 07                	je     80355a <devpipe_read+0x75>
				return 0;
  803553:	b8 00 00 00 00       	mov    $0x0,%eax
  803558:	eb 70                	jmp    8035ca <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80355a:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  803561:	00 00 00 
  803564:	ff d0                	callq  *%rax
  803566:	eb 01                	jmp    803569 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803568:	90                   	nop
  803569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356d:	8b 10                	mov    (%rax),%edx
  80356f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803573:	8b 40 04             	mov    0x4(%rax),%eax
  803576:	39 c2                	cmp    %eax,%edx
  803578:	74 ab                	je     803525 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80357a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80357e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803582:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803586:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358a:	8b 00                	mov    (%rax),%eax
  80358c:	89 c2                	mov    %eax,%edx
  80358e:	c1 fa 1f             	sar    $0x1f,%edx
  803591:	c1 ea 1b             	shr    $0x1b,%edx
  803594:	01 d0                	add    %edx,%eax
  803596:	83 e0 1f             	and    $0x1f,%eax
  803599:	29 d0                	sub    %edx,%eax
  80359b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80359f:	48 98                	cltq   
  8035a1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8035a6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8035a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ac:	8b 00                	mov    (%rax),%eax
  8035ae:	8d 50 01             	lea    0x1(%rax),%edx
  8035b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035c4:	72 a2                	jb     803568 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035ca:	c9                   	leaveq 
  8035cb:	c3                   	retq   

00000000008035cc <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035cc:	55                   	push   %rbp
  8035cd:	48 89 e5             	mov    %rsp,%rbp
  8035d0:	48 83 ec 40          	sub    $0x40,%rsp
  8035d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035dc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8035e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e4:	48 89 c7             	mov    %rax,%rdi
  8035e7:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8035ee:	00 00 00 
  8035f1:	ff d0                	callq  *%rax
  8035f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035fb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035ff:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803606:	00 
  803607:	e9 93 00 00 00       	jmpq   80369f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80360c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803614:	48 89 d6             	mov    %rdx,%rsi
  803617:	48 89 c7             	mov    %rax,%rdi
  80361a:	48 b8 b2 33 80 00 00 	movabs $0x8033b2,%rax
  803621:	00 00 00 
  803624:	ff d0                	callq  *%rax
  803626:	85 c0                	test   %eax,%eax
  803628:	74 07                	je     803631 <devpipe_write+0x65>
				return 0;
  80362a:	b8 00 00 00 00       	mov    $0x0,%eax
  80362f:	eb 7c                	jmp    8036ad <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803631:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  803638:	00 00 00 
  80363b:	ff d0                	callq  *%rax
  80363d:	eb 01                	jmp    803640 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80363f:	90                   	nop
  803640:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803644:	8b 40 04             	mov    0x4(%rax),%eax
  803647:	48 63 d0             	movslq %eax,%rdx
  80364a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364e:	8b 00                	mov    (%rax),%eax
  803650:	48 98                	cltq   
  803652:	48 83 c0 20          	add    $0x20,%rax
  803656:	48 39 c2             	cmp    %rax,%rdx
  803659:	73 b1                	jae    80360c <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80365b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365f:	8b 40 04             	mov    0x4(%rax),%eax
  803662:	89 c2                	mov    %eax,%edx
  803664:	c1 fa 1f             	sar    $0x1f,%edx
  803667:	c1 ea 1b             	shr    $0x1b,%edx
  80366a:	01 d0                	add    %edx,%eax
  80366c:	83 e0 1f             	and    $0x1f,%eax
  80366f:	29 d0                	sub    %edx,%eax
  803671:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803675:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803679:	48 01 ca             	add    %rcx,%rdx
  80367c:	0f b6 0a             	movzbl (%rdx),%ecx
  80367f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803683:	48 98                	cltq   
  803685:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368d:	8b 40 04             	mov    0x4(%rax),%eax
  803690:	8d 50 01             	lea    0x1(%rax),%edx
  803693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803697:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80369a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80369f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036a3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036a7:	72 96                	jb     80363f <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8036a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036ad:	c9                   	leaveq 
  8036ae:	c3                   	retq   

00000000008036af <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8036af:	55                   	push   %rbp
  8036b0:	48 89 e5             	mov    %rsp,%rbp
  8036b3:	48 83 ec 20          	sub    $0x20,%rsp
  8036b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c3:	48 89 c7             	mov    %rax,%rdi
  8036c6:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  8036cd:	00 00 00 
  8036d0:	ff d0                	callq  *%rax
  8036d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8036d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036da:	48 be dc 49 80 00 00 	movabs $0x8049dc,%rsi
  8036e1:	00 00 00 
  8036e4:	48 89 c7             	mov    %rax,%rdi
  8036e7:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8036f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f7:	8b 50 04             	mov    0x4(%rax),%edx
  8036fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036fe:	8b 00                	mov    (%rax),%eax
  803700:	29 c2                	sub    %eax,%edx
  803702:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803706:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80370c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803710:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803717:	00 00 00 
	stat->st_dev = &devpipe;
  80371a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80371e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803725:	00 00 00 
  803728:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80372f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803734:	c9                   	leaveq 
  803735:	c3                   	retq   

0000000000803736 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803736:	55                   	push   %rbp
  803737:	48 89 e5             	mov    %rsp,%rbp
  80373a:	48 83 ec 10          	sub    $0x10,%rsp
  80373e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803746:	48 89 c6             	mov    %rax,%rsi
  803749:	bf 00 00 00 00       	mov    $0x0,%edi
  80374e:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803755:	00 00 00 
  803758:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80375a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375e:	48 89 c7             	mov    %rax,%rdi
  803761:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  803768:	00 00 00 
  80376b:	ff d0                	callq  *%rax
  80376d:	48 89 c6             	mov    %rax,%rsi
  803770:	bf 00 00 00 00       	mov    $0x0,%edi
  803775:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  80377c:	00 00 00 
  80377f:	ff d0                	callq  *%rax
}
  803781:	c9                   	leaveq 
  803782:	c3                   	retq   
	...

0000000000803784 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803784:	55                   	push   %rbp
  803785:	48 89 e5             	mov    %rsp,%rbp
  803788:	48 83 ec 20          	sub    $0x20,%rsp
  80378c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80378f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803792:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803795:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803799:	be 01 00 00 00       	mov    $0x1,%esi
  80379e:	48 89 c7             	mov    %rax,%rdi
  8037a1:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  8037a8:	00 00 00 
  8037ab:	ff d0                	callq  *%rax
}
  8037ad:	c9                   	leaveq 
  8037ae:	c3                   	retq   

00000000008037af <getchar>:

int
getchar(void)
{
  8037af:	55                   	push   %rbp
  8037b0:	48 89 e5             	mov    %rsp,%rbp
  8037b3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8037b7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8037bb:	ba 01 00 00 00       	mov    $0x1,%edx
  8037c0:	48 89 c6             	mov    %rax,%rsi
  8037c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c8:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  8037cf:	00 00 00 
  8037d2:	ff d0                	callq  *%rax
  8037d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8037d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037db:	79 05                	jns    8037e2 <getchar+0x33>
		return r;
  8037dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e0:	eb 14                	jmp    8037f6 <getchar+0x47>
	if (r < 1)
  8037e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e6:	7f 07                	jg     8037ef <getchar+0x40>
		return -E_EOF;
  8037e8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8037ed:	eb 07                	jmp    8037f6 <getchar+0x47>
	return c;
  8037ef:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8037f3:	0f b6 c0             	movzbl %al,%eax
}
  8037f6:	c9                   	leaveq 
  8037f7:	c3                   	retq   

00000000008037f8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8037f8:	55                   	push   %rbp
  8037f9:	48 89 e5             	mov    %rsp,%rbp
  8037fc:	48 83 ec 20          	sub    $0x20,%rsp
  803800:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803803:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803807:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80380a:	48 89 d6             	mov    %rdx,%rsi
  80380d:	89 c7                	mov    %eax,%edi
  80380f:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  803816:	00 00 00 
  803819:	ff d0                	callq  *%rax
  80381b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80381e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803822:	79 05                	jns    803829 <iscons+0x31>
		return r;
  803824:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803827:	eb 1a                	jmp    803843 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803829:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80382d:	8b 10                	mov    (%rax),%edx
  80382f:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803836:	00 00 00 
  803839:	8b 00                	mov    (%rax),%eax
  80383b:	39 c2                	cmp    %eax,%edx
  80383d:	0f 94 c0             	sete   %al
  803840:	0f b6 c0             	movzbl %al,%eax
}
  803843:	c9                   	leaveq 
  803844:	c3                   	retq   

0000000000803845 <opencons>:

int
opencons(void)
{
  803845:	55                   	push   %rbp
  803846:	48 89 e5             	mov    %rsp,%rbp
  803849:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80384d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803851:	48 89 c7             	mov    %rax,%rdi
  803854:	48 b8 d6 1d 80 00 00 	movabs $0x801dd6,%rax
  80385b:	00 00 00 
  80385e:	ff d0                	callq  *%rax
  803860:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803863:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803867:	79 05                	jns    80386e <opencons+0x29>
		return r;
  803869:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80386c:	eb 5b                	jmp    8038c9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80386e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803872:	ba 07 04 00 00       	mov    $0x407,%edx
  803877:	48 89 c6             	mov    %rax,%rsi
  80387a:	bf 00 00 00 00       	mov    $0x0,%edi
  80387f:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803886:	00 00 00 
  803889:	ff d0                	callq  *%rax
  80388b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80388e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803892:	79 05                	jns    803899 <opencons+0x54>
		return r;
  803894:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803897:	eb 30                	jmp    8038c9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803899:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8038a4:	00 00 00 
  8038a7:	8b 12                	mov    (%rdx),%edx
  8038a9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8038ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8038b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ba:	48 89 c7             	mov    %rax,%rdi
  8038bd:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  8038c4:	00 00 00 
  8038c7:	ff d0                	callq  *%rax
}
  8038c9:	c9                   	leaveq 
  8038ca:	c3                   	retq   

00000000008038cb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038cb:	55                   	push   %rbp
  8038cc:	48 89 e5             	mov    %rsp,%rbp
  8038cf:	48 83 ec 30          	sub    $0x30,%rsp
  8038d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8038df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038e4:	75 13                	jne    8038f9 <devcons_read+0x2e>
		return 0;
  8038e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038eb:	eb 49                	jmp    803936 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8038ed:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  8038f4:	00 00 00 
  8038f7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8038f9:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  803900:	00 00 00 
  803903:	ff d0                	callq  *%rax
  803905:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803908:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80390c:	74 df                	je     8038ed <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80390e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803912:	79 05                	jns    803919 <devcons_read+0x4e>
		return c;
  803914:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803917:	eb 1d                	jmp    803936 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803919:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80391d:	75 07                	jne    803926 <devcons_read+0x5b>
		return 0;
  80391f:	b8 00 00 00 00       	mov    $0x0,%eax
  803924:	eb 10                	jmp    803936 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803929:	89 c2                	mov    %eax,%edx
  80392b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80392f:	88 10                	mov    %dl,(%rax)
	return 1;
  803931:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803936:	c9                   	leaveq 
  803937:	c3                   	retq   

0000000000803938 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803938:	55                   	push   %rbp
  803939:	48 89 e5             	mov    %rsp,%rbp
  80393c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803943:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80394a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803951:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803958:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80395f:	eb 77                	jmp    8039d8 <devcons_write+0xa0>
		m = n - tot;
  803961:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803968:	89 c2                	mov    %eax,%edx
  80396a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396d:	89 d1                	mov    %edx,%ecx
  80396f:	29 c1                	sub    %eax,%ecx
  803971:	89 c8                	mov    %ecx,%eax
  803973:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803976:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803979:	83 f8 7f             	cmp    $0x7f,%eax
  80397c:	76 07                	jbe    803985 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80397e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803985:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803988:	48 63 d0             	movslq %eax,%rdx
  80398b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398e:	48 98                	cltq   
  803990:	48 89 c1             	mov    %rax,%rcx
  803993:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80399a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039a1:	48 89 ce             	mov    %rcx,%rsi
  8039a4:	48 89 c7             	mov    %rax,%rdi
  8039a7:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  8039ae:	00 00 00 
  8039b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8039b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039b6:	48 63 d0             	movslq %eax,%rdx
  8039b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039c0:	48 89 d6             	mov    %rdx,%rsi
  8039c3:	48 89 c7             	mov    %rax,%rdi
  8039c6:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  8039cd:	00 00 00 
  8039d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8039d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039db:	48 98                	cltq   
  8039dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8039e4:	0f 82 77 ff ff ff    	jb     803961 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8039ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039ed:	c9                   	leaveq 
  8039ee:	c3                   	retq   

00000000008039ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8039ef:	55                   	push   %rbp
  8039f0:	48 89 e5             	mov    %rsp,%rbp
  8039f3:	48 83 ec 08          	sub    $0x8,%rsp
  8039f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8039fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a00:	c9                   	leaveq 
  803a01:	c3                   	retq   

0000000000803a02 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a02:	55                   	push   %rbp
  803a03:	48 89 e5             	mov    %rsp,%rbp
  803a06:	48 83 ec 10          	sub    $0x10,%rsp
  803a0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a16:	48 be e8 49 80 00 00 	movabs $0x8049e8,%rsi
  803a1d:	00 00 00 
  803a20:	48 89 c7             	mov    %rax,%rdi
  803a23:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  803a2a:	00 00 00 
  803a2d:	ff d0                	callq  *%rax
	return 0;
  803a2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a34:	c9                   	leaveq 
  803a35:	c3                   	retq   
	...

0000000000803a38 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803a38:	55                   	push   %rbp
  803a39:	48 89 e5             	mov    %rsp,%rbp
  803a3c:	53                   	push   %rbx
  803a3d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a44:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803a4b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803a51:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803a58:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803a5f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803a66:	84 c0                	test   %al,%al
  803a68:	74 23                	je     803a8d <_panic+0x55>
  803a6a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803a71:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803a75:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803a79:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803a7d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803a81:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803a85:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803a89:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803a8d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803a94:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803a9b:	00 00 00 
  803a9e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803aa5:	00 00 00 
  803aa8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803aac:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803ab3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803aba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803ac1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803ac8:	00 00 00 
  803acb:	48 8b 18             	mov    (%rax),%rbx
  803ace:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  803ad5:	00 00 00 
  803ad8:	ff d0                	callq  *%rax
  803ada:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803ae0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803ae7:	41 89 c8             	mov    %ecx,%r8d
  803aea:	48 89 d1             	mov    %rdx,%rcx
  803aed:	48 89 da             	mov    %rbx,%rdx
  803af0:	89 c6                	mov    %eax,%esi
  803af2:	48 bf f0 49 80 00 00 	movabs $0x8049f0,%rdi
  803af9:	00 00 00 
  803afc:	b8 00 00 00 00       	mov    $0x0,%eax
  803b01:	49 b9 2f 05 80 00 00 	movabs $0x80052f,%r9
  803b08:	00 00 00 
  803b0b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803b0e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803b15:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803b1c:	48 89 d6             	mov    %rdx,%rsi
  803b1f:	48 89 c7             	mov    %rax,%rdi
  803b22:	48 b8 83 04 80 00 00 	movabs $0x800483,%rax
  803b29:	00 00 00 
  803b2c:	ff d0                	callq  *%rax
	cprintf("\n");
  803b2e:	48 bf 13 4a 80 00 00 	movabs $0x804a13,%rdi
  803b35:	00 00 00 
  803b38:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3d:	48 ba 2f 05 80 00 00 	movabs $0x80052f,%rdx
  803b44:	00 00 00 
  803b47:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b49:	cc                   	int3   
  803b4a:	eb fd                	jmp    803b49 <_panic+0x111>

0000000000803b4c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b4c:	55                   	push   %rbp
  803b4d:	48 89 e5             	mov    %rsp,%rbp
  803b50:	48 83 ec 30          	sub    $0x30,%rsp
  803b54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b5c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  803b60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  803b67:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b6c:	74 18                	je     803b86 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  803b6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b72:	48 89 c7             	mov    %rax,%rdi
  803b75:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  803b7c:	00 00 00 
  803b7f:	ff d0                	callq  *%rax
  803b81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b84:	eb 19                	jmp    803b9f <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  803b86:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  803b8d:	00 00 00 
  803b90:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  803b97:	00 00 00 
  803b9a:	ff d0                	callq  *%rax
  803b9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  803b9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba3:	79 39                	jns    803bde <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  803ba5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803baa:	75 08                	jne    803bb4 <ipc_recv+0x68>
  803bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb0:	8b 00                	mov    (%rax),%eax
  803bb2:	eb 05                	jmp    803bb9 <ipc_recv+0x6d>
  803bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bbd:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  803bbf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bc4:	75 08                	jne    803bce <ipc_recv+0x82>
  803bc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bca:	8b 00                	mov    (%rax),%eax
  803bcc:	eb 05                	jmp    803bd3 <ipc_recv+0x87>
  803bce:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803bd7:	89 02                	mov    %eax,(%rdx)
		return r;
  803bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bdc:	eb 53                	jmp    803c31 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  803bde:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803be3:	74 19                	je     803bfe <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  803be5:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803bec:	00 00 00 
  803bef:	48 8b 00             	mov    (%rax),%rax
  803bf2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bfc:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  803bfe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c03:	74 19                	je     803c1e <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803c05:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803c0c:	00 00 00 
  803c0f:	48 8b 00             	mov    (%rax),%rax
  803c12:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803c18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1c:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  803c1e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803c25:	00 00 00 
  803c28:	48 8b 00             	mov    (%rax),%rax
  803c2b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  803c31:	c9                   	leaveq 
  803c32:	c3                   	retq   

0000000000803c33 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c33:	55                   	push   %rbp
  803c34:	48 89 e5             	mov    %rsp,%rbp
  803c37:	48 83 ec 30          	sub    $0x30,%rsp
  803c3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c3e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c41:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803c45:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  803c48:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  803c4f:	eb 59                	jmp    803caa <ipc_send+0x77>
		if(pg) {
  803c51:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c56:	74 20                	je     803c78 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  803c58:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c5b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803c5e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803c62:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c65:	89 c7                	mov    %eax,%edi
  803c67:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  803c6e:	00 00 00 
  803c71:	ff d0                	callq  *%rax
  803c73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c76:	eb 26                	jmp    803c9e <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  803c78:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c7b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c81:	89 d1                	mov    %edx,%ecx
  803c83:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  803c8a:	00 00 00 
  803c8d:	89 c7                	mov    %eax,%edi
  803c8f:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  803c96:	00 00 00 
  803c99:	ff d0                	callq  *%rax
  803c9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  803c9e:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  803ca5:	00 00 00 
  803ca8:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  803caa:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803cae:	74 a1                	je     803c51 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  803cb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb4:	74 2a                	je     803ce0 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  803cb6:	48 ba 18 4a 80 00 00 	movabs $0x804a18,%rdx
  803cbd:	00 00 00 
  803cc0:	be 49 00 00 00       	mov    $0x49,%esi
  803cc5:	48 bf 43 4a 80 00 00 	movabs $0x804a43,%rdi
  803ccc:	00 00 00 
  803ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd4:	48 b9 38 3a 80 00 00 	movabs $0x803a38,%rcx
  803cdb:	00 00 00 
  803cde:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  803ce0:	c9                   	leaveq 
  803ce1:	c3                   	retq   

0000000000803ce2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ce2:	55                   	push   %rbp
  803ce3:	48 89 e5             	mov    %rsp,%rbp
  803ce6:	48 83 ec 18          	sub    $0x18,%rsp
  803cea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ced:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cf4:	eb 6a                	jmp    803d60 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  803cf6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803cfd:	00 00 00 
  803d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d03:	48 63 d0             	movslq %eax,%rdx
  803d06:	48 89 d0             	mov    %rdx,%rax
  803d09:	48 c1 e0 02          	shl    $0x2,%rax
  803d0d:	48 01 d0             	add    %rdx,%rax
  803d10:	48 01 c0             	add    %rax,%rax
  803d13:	48 01 d0             	add    %rdx,%rax
  803d16:	48 c1 e0 05          	shl    $0x5,%rax
  803d1a:	48 01 c8             	add    %rcx,%rax
  803d1d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d23:	8b 00                	mov    (%rax),%eax
  803d25:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d28:	75 32                	jne    803d5c <ipc_find_env+0x7a>
			return envs[i].env_id;
  803d2a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d31:	00 00 00 
  803d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d37:	48 63 d0             	movslq %eax,%rdx
  803d3a:	48 89 d0             	mov    %rdx,%rax
  803d3d:	48 c1 e0 02          	shl    $0x2,%rax
  803d41:	48 01 d0             	add    %rdx,%rax
  803d44:	48 01 c0             	add    %rax,%rax
  803d47:	48 01 d0             	add    %rdx,%rax
  803d4a:	48 c1 e0 05          	shl    $0x5,%rax
  803d4e:	48 01 c8             	add    %rcx,%rax
  803d51:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d57:	8b 40 08             	mov    0x8(%rax),%eax
  803d5a:	eb 12                	jmp    803d6e <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803d5c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d60:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d67:	7e 8d                	jle    803cf6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d6e:	c9                   	leaveq 
  803d6f:	c3                   	retq   

0000000000803d70 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d70:	55                   	push   %rbp
  803d71:	48 89 e5             	mov    %rsp,%rbp
  803d74:	48 83 ec 18          	sub    $0x18,%rsp
  803d78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d80:	48 89 c2             	mov    %rax,%rdx
  803d83:	48 c1 ea 15          	shr    $0x15,%rdx
  803d87:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d8e:	01 00 00 
  803d91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d95:	83 e0 01             	and    $0x1,%eax
  803d98:	48 85 c0             	test   %rax,%rax
  803d9b:	75 07                	jne    803da4 <pageref+0x34>
		return 0;
  803d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803da2:	eb 53                	jmp    803df7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803da4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803da8:	48 89 c2             	mov    %rax,%rdx
  803dab:	48 c1 ea 0c          	shr    $0xc,%rdx
  803daf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803db6:	01 00 00 
  803db9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dbd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803dc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dc5:	83 e0 01             	and    $0x1,%eax
  803dc8:	48 85 c0             	test   %rax,%rax
  803dcb:	75 07                	jne    803dd4 <pageref+0x64>
		return 0;
  803dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd2:	eb 23                	jmp    803df7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dd8:	48 89 c2             	mov    %rax,%rdx
  803ddb:	48 c1 ea 0c          	shr    $0xc,%rdx
  803ddf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803de6:	00 00 00 
  803de9:	48 c1 e2 04          	shl    $0x4,%rdx
  803ded:	48 01 d0             	add    %rdx,%rax
  803df0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803df4:	0f b7 c0             	movzwl %ax,%eax
}
  803df7:	c9                   	leaveq 
  803df8:	c3                   	retq   
  803df9:	00 00                	add    %al,(%rax)
	...

0000000000803dfc <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  803dfc:	55                   	push   %rbp
  803dfd:	48 89 e5             	mov    %rsp,%rbp
  803e00:	48 83 ec 20          	sub    $0x20,%rsp
  803e04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  803e08:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e10:	48 89 d6             	mov    %rdx,%rsi
  803e13:	48 89 c7             	mov    %rax,%rdi
  803e16:	48 b8 32 3e 80 00 00 	movabs $0x803e32,%rax
  803e1d:	00 00 00 
  803e20:	ff d0                	callq  *%rax
  803e22:	85 c0                	test   %eax,%eax
  803e24:	74 05                	je     803e2b <inet_addr+0x2f>
    return (val.s_addr);
  803e26:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e29:	eb 05                	jmp    803e30 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  803e2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803e30:	c9                   	leaveq 
  803e31:	c3                   	retq   

0000000000803e32 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  803e32:	55                   	push   %rbp
  803e33:	48 89 e5             	mov    %rsp,%rbp
  803e36:	53                   	push   %rbx
  803e37:	48 83 ec 48          	sub    $0x48,%rsp
  803e3b:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  803e3f:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  803e43:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803e47:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

  c = *cp;
  803e4b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803e4f:	0f b6 00             	movzbl (%rax),%eax
  803e52:	0f be c0             	movsbl %al,%eax
  803e55:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803e58:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803e5b:	3c 2f                	cmp    $0x2f,%al
  803e5d:	76 07                	jbe    803e66 <inet_aton+0x34>
  803e5f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803e62:	3c 39                	cmp    $0x39,%al
  803e64:	76 0a                	jbe    803e70 <inet_aton+0x3e>
      return (0);
  803e66:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6b:	e9 6a 02 00 00       	jmpq   8040da <inet_aton+0x2a8>
    val = 0;
  803e70:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    base = 10;
  803e77:	c7 45 e8 0a 00 00 00 	movl   $0xa,-0x18(%rbp)
    if (c == '0') {
  803e7e:	83 7d e4 30          	cmpl   $0x30,-0x1c(%rbp)
  803e82:	75 40                	jne    803ec4 <inet_aton+0x92>
      c = *++cp;
  803e84:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803e89:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803e8d:	0f b6 00             	movzbl (%rax),%eax
  803e90:	0f be c0             	movsbl %al,%eax
  803e93:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if (c == 'x' || c == 'X') {
  803e96:	83 7d e4 78          	cmpl   $0x78,-0x1c(%rbp)
  803e9a:	74 06                	je     803ea2 <inet_aton+0x70>
  803e9c:	83 7d e4 58          	cmpl   $0x58,-0x1c(%rbp)
  803ea0:	75 1b                	jne    803ebd <inet_aton+0x8b>
        base = 16;
  803ea2:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%rbp)
        c = *++cp;
  803ea9:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803eae:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803eb2:	0f b6 00             	movzbl (%rax),%eax
  803eb5:	0f be c0             	movsbl %al,%eax
  803eb8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803ebb:	eb 07                	jmp    803ec4 <inet_aton+0x92>
      } else
        base = 8;
  803ebd:	c7 45 e8 08 00 00 00 	movl   $0x8,-0x18(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  803ec4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ec7:	3c 2f                	cmp    $0x2f,%al
  803ec9:	76 2f                	jbe    803efa <inet_aton+0xc8>
  803ecb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ece:	3c 39                	cmp    $0x39,%al
  803ed0:	77 28                	ja     803efa <inet_aton+0xc8>
        val = (val * base) + (int)(c - '0');
  803ed2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ed5:	89 c2                	mov    %eax,%edx
  803ed7:	0f af 55 ec          	imul   -0x14(%rbp),%edx
  803edb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803ede:	01 d0                	add    %edx,%eax
  803ee0:	83 e8 30             	sub    $0x30,%eax
  803ee3:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  803ee6:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803eeb:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803eef:	0f b6 00             	movzbl (%rax),%eax
  803ef2:	0f be c0             	movsbl %al,%eax
  803ef5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  803ef8:	eb ca                	jmp    803ec4 <inet_aton+0x92>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  803efa:	83 7d e8 10          	cmpl   $0x10,-0x18(%rbp)
  803efe:	75 74                	jne    803f74 <inet_aton+0x142>
  803f00:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f03:	3c 2f                	cmp    $0x2f,%al
  803f05:	76 07                	jbe    803f0e <inet_aton+0xdc>
  803f07:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f0a:	3c 39                	cmp    $0x39,%al
  803f0c:	76 1c                	jbe    803f2a <inet_aton+0xf8>
  803f0e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f11:	3c 60                	cmp    $0x60,%al
  803f13:	76 07                	jbe    803f1c <inet_aton+0xea>
  803f15:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f18:	3c 66                	cmp    $0x66,%al
  803f1a:	76 0e                	jbe    803f2a <inet_aton+0xf8>
  803f1c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f1f:	3c 40                	cmp    $0x40,%al
  803f21:	76 51                	jbe    803f74 <inet_aton+0x142>
  803f23:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f26:	3c 46                	cmp    $0x46,%al
  803f28:	77 4a                	ja     803f74 <inet_aton+0x142>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  803f2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f2d:	89 c2                	mov    %eax,%edx
  803f2f:	c1 e2 04             	shl    $0x4,%edx
  803f32:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f35:	8d 48 0a             	lea    0xa(%rax),%ecx
  803f38:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f3b:	3c 60                	cmp    $0x60,%al
  803f3d:	76 0e                	jbe    803f4d <inet_aton+0x11b>
  803f3f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803f42:	3c 7a                	cmp    $0x7a,%al
  803f44:	77 07                	ja     803f4d <inet_aton+0x11b>
  803f46:	b8 61 00 00 00       	mov    $0x61,%eax
  803f4b:	eb 05                	jmp    803f52 <inet_aton+0x120>
  803f4d:	b8 41 00 00 00       	mov    $0x41,%eax
  803f52:	89 cb                	mov    %ecx,%ebx
  803f54:	29 c3                	sub    %eax,%ebx
  803f56:	89 d8                	mov    %ebx,%eax
  803f58:	09 d0                	or     %edx,%eax
  803f5a:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  803f5d:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803f62:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f66:	0f b6 00             	movzbl (%rax),%eax
  803f69:	0f be c0             	movsbl %al,%eax
  803f6c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else
        break;
    }
  803f6f:	e9 50 ff ff ff       	jmpq   803ec4 <inet_aton+0x92>
    if (c == '.') {
  803f74:	83 7d e4 2e          	cmpl   $0x2e,-0x1c(%rbp)
  803f78:	75 3d                	jne    803fb7 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803f7a:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803f7e:	48 83 c0 0c          	add    $0xc,%rax
  803f82:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803f86:	72 0a                	jb     803f92 <inet_aton+0x160>
        return (0);
  803f88:	b8 00 00 00 00       	mov    $0x0,%eax
  803f8d:	e9 48 01 00 00       	jmpq   8040da <inet_aton+0x2a8>
      *pp++ = val;
  803f92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f96:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f99:	89 10                	mov    %edx,(%rax)
  803f9b:	48 83 45 d8 04       	addq   $0x4,-0x28(%rbp)
      c = *++cp;
  803fa0:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  803fa5:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803fa9:	0f b6 00             	movzbl (%rax),%eax
  803fac:	0f be c0             	movsbl %al,%eax
  803faf:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    } else
      break;
  }
  803fb2:	e9 a1 fe ff ff       	jmpq   803e58 <inet_aton+0x26>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  803fb7:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  803fb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803fbc:	74 3c                	je     803ffa <inet_aton+0x1c8>
  803fbe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fc1:	3c 1f                	cmp    $0x1f,%al
  803fc3:	76 2b                	jbe    803ff0 <inet_aton+0x1be>
  803fc5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803fc8:	84 c0                	test   %al,%al
  803fca:	78 24                	js     803ff0 <inet_aton+0x1be>
  803fcc:	83 7d e4 20          	cmpl   $0x20,-0x1c(%rbp)
  803fd0:	74 28                	je     803ffa <inet_aton+0x1c8>
  803fd2:	83 7d e4 0c          	cmpl   $0xc,-0x1c(%rbp)
  803fd6:	74 22                	je     803ffa <inet_aton+0x1c8>
  803fd8:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  803fdc:	74 1c                	je     803ffa <inet_aton+0x1c8>
  803fde:	83 7d e4 0d          	cmpl   $0xd,-0x1c(%rbp)
  803fe2:	74 16                	je     803ffa <inet_aton+0x1c8>
  803fe4:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  803fe8:	74 10                	je     803ffa <inet_aton+0x1c8>
  803fea:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%rbp)
  803fee:	74 0a                	je     803ffa <inet_aton+0x1c8>
    return (0);
  803ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff5:	e9 e0 00 00 00       	jmpq   8040da <inet_aton+0x2a8>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  803ffa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803ffe:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804002:	48 89 d1             	mov    %rdx,%rcx
  804005:	48 29 c1             	sub    %rax,%rcx
  804008:	48 89 c8             	mov    %rcx,%rax
  80400b:	48 c1 f8 02          	sar    $0x2,%rax
  80400f:	83 c0 01             	add    $0x1,%eax
  804012:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  switch (n) {
  804015:	83 7d d4 04          	cmpl   $0x4,-0x2c(%rbp)
  804019:	0f 87 98 00 00 00    	ja     8040b7 <inet_aton+0x285>
  80401f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804022:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804029:	00 
  80402a:	48 b8 50 4a 80 00 00 	movabs $0x804a50,%rax
  804031:	00 00 00 
  804034:	48 01 d0             	add    %rdx,%rax
  804037:	48 8b 00             	mov    (%rax),%rax
  80403a:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  80403c:	b8 00 00 00 00       	mov    $0x0,%eax
  804041:	e9 94 00 00 00       	jmpq   8040da <inet_aton+0x2a8>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804046:	81 7d ec ff ff ff 00 	cmpl   $0xffffff,-0x14(%rbp)
  80404d:	76 0a                	jbe    804059 <inet_aton+0x227>
      return (0);
  80404f:	b8 00 00 00 00       	mov    $0x0,%eax
  804054:	e9 81 00 00 00       	jmpq   8040da <inet_aton+0x2a8>
    val |= parts[0] << 24;
  804059:	8b 45 c0             	mov    -0x40(%rbp),%eax
  80405c:	c1 e0 18             	shl    $0x18,%eax
  80405f:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804062:	eb 53                	jmp    8040b7 <inet_aton+0x285>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804064:	81 7d ec ff ff 00 00 	cmpl   $0xffff,-0x14(%rbp)
  80406b:	76 07                	jbe    804074 <inet_aton+0x242>
      return (0);
  80406d:	b8 00 00 00 00       	mov    $0x0,%eax
  804072:	eb 66                	jmp    8040da <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804074:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804077:	89 c2                	mov    %eax,%edx
  804079:	c1 e2 18             	shl    $0x18,%edx
  80407c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80407f:	c1 e0 10             	shl    $0x10,%eax
  804082:	09 d0                	or     %edx,%eax
  804084:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804087:	eb 2e                	jmp    8040b7 <inet_aton+0x285>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804089:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%rbp)
  804090:	76 07                	jbe    804099 <inet_aton+0x267>
      return (0);
  804092:	b8 00 00 00 00       	mov    $0x0,%eax
  804097:	eb 41                	jmp    8040da <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804099:	8b 45 c0             	mov    -0x40(%rbp),%eax
  80409c:	89 c2                	mov    %eax,%edx
  80409e:	c1 e2 18             	shl    $0x18,%edx
  8040a1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8040a4:	c1 e0 10             	shl    $0x10,%eax
  8040a7:	09 c2                	or     %eax,%edx
  8040a9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8040ac:	c1 e0 08             	shl    $0x8,%eax
  8040af:	09 d0                	or     %edx,%eax
  8040b1:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  8040b4:	eb 01                	jmp    8040b7 <inet_aton+0x285>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  8040b6:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8040b7:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  8040bc:	74 17                	je     8040d5 <inet_aton+0x2a3>
    addr->s_addr = htonl(val);
  8040be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040c1:	89 c7                	mov    %eax,%edi
  8040c3:	48 b8 49 42 80 00 00 	movabs $0x804249,%rax
  8040ca:	00 00 00 
  8040cd:	ff d0                	callq  *%rax
  8040cf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8040d3:	89 02                	mov    %eax,(%rdx)
  return (1);
  8040d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8040da:	48 83 c4 48          	add    $0x48,%rsp
  8040de:	5b                   	pop    %rbx
  8040df:	5d                   	pop    %rbp
  8040e0:	c3                   	retq   

00000000008040e1 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8040e1:	55                   	push   %rbp
  8040e2:	48 89 e5             	mov    %rsp,%rbp
  8040e5:	48 83 ec 30          	sub    $0x30,%rsp
  8040e9:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8040ec:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8040ef:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  8040f2:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8040f9:	00 00 00 
  8040fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804100:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804104:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804108:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  80410c:	e9 d1 00 00 00       	jmpq   8041e2 <inet_ntoa+0x101>
    i = 0;
  804111:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  804115:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804119:	0f b6 08             	movzbl (%rax),%ecx
  80411c:	0f b6 d1             	movzbl %cl,%edx
  80411f:	89 d0                	mov    %edx,%eax
  804121:	c1 e0 02             	shl    $0x2,%eax
  804124:	01 d0                	add    %edx,%eax
  804126:	c1 e0 03             	shl    $0x3,%eax
  804129:	01 d0                	add    %edx,%eax
  80412b:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804132:	01 d0                	add    %edx,%eax
  804134:	66 c1 e8 08          	shr    $0x8,%ax
  804138:	c0 e8 03             	shr    $0x3,%al
  80413b:	88 45 ed             	mov    %al,-0x13(%rbp)
  80413e:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804142:	89 d0                	mov    %edx,%eax
  804144:	c1 e0 02             	shl    $0x2,%eax
  804147:	01 d0                	add    %edx,%eax
  804149:	01 c0                	add    %eax,%eax
  80414b:	89 ca                	mov    %ecx,%edx
  80414d:	28 c2                	sub    %al,%dl
  80414f:	89 d0                	mov    %edx,%eax
  804151:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  804154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804158:	0f b6 00             	movzbl (%rax),%eax
  80415b:	0f b6 d0             	movzbl %al,%edx
  80415e:	89 d0                	mov    %edx,%eax
  804160:	c1 e0 02             	shl    $0x2,%eax
  804163:	01 d0                	add    %edx,%eax
  804165:	c1 e0 03             	shl    $0x3,%eax
  804168:	01 d0                	add    %edx,%eax
  80416a:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804171:	01 d0                	add    %edx,%eax
  804173:	66 c1 e8 08          	shr    $0x8,%ax
  804177:	89 c2                	mov    %eax,%edx
  804179:	c0 ea 03             	shr    $0x3,%dl
  80417c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804180:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804182:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804186:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80418a:	83 c2 30             	add    $0x30,%edx
  80418d:	48 98                	cltq   
  80418f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
  804193:	80 45 ee 01          	addb   $0x1,-0x12(%rbp)
    } while(*ap);
  804197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80419b:	0f b6 00             	movzbl (%rax),%eax
  80419e:	84 c0                	test   %al,%al
  8041a0:	0f 85 6f ff ff ff    	jne    804115 <inet_ntoa+0x34>
    while(i--)
  8041a6:	eb 16                	jmp    8041be <inet_ntoa+0xdd>
      *rp++ = inv[i];
  8041a8:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8041ac:	48 98                	cltq   
  8041ae:	0f b6 54 05 e0       	movzbl -0x20(%rbp,%rax,1),%edx
  8041b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b7:	88 10                	mov    %dl,(%rax)
  8041b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8041be:	80 7d ee 00          	cmpb   $0x0,-0x12(%rbp)
  8041c2:	0f 95 c0             	setne  %al
  8041c5:	80 6d ee 01          	subb   $0x1,-0x12(%rbp)
  8041c9:	84 c0                	test   %al,%al
  8041cb:	75 db                	jne    8041a8 <inet_ntoa+0xc7>
      *rp++ = inv[i];
    *rp++ = '.';
  8041cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d1:	c6 00 2e             	movb   $0x2e,(%rax)
  8041d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    ap++;
  8041d9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8041de:	80 45 ef 01          	addb   $0x1,-0x11(%rbp)
  8041e2:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  8041e6:	0f 86 25 ff ff ff    	jbe    804111 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  8041ec:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  8041f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041f5:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  8041f8:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8041ff:	00 00 00 
}
  804202:	c9                   	leaveq 
  804203:	c3                   	retq   

0000000000804204 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804204:	55                   	push   %rbp
  804205:	48 89 e5             	mov    %rsp,%rbp
  804208:	48 83 ec 08          	sub    $0x8,%rsp
  80420c:	89 f8                	mov    %edi,%eax
  80420e:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804212:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804216:	c1 e0 08             	shl    $0x8,%eax
  804219:	89 c2                	mov    %eax,%edx
  80421b:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80421f:	66 c1 e8 08          	shr    $0x8,%ax
  804223:	09 d0                	or     %edx,%eax
}
  804225:	c9                   	leaveq 
  804226:	c3                   	retq   

0000000000804227 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804227:	55                   	push   %rbp
  804228:	48 89 e5             	mov    %rsp,%rbp
  80422b:	48 83 ec 08          	sub    $0x8,%rsp
  80422f:	89 f8                	mov    %edi,%eax
  804231:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  804235:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804239:	89 c7                	mov    %eax,%edi
  80423b:	48 b8 04 42 80 00 00 	movabs $0x804204,%rax
  804242:	00 00 00 
  804245:	ff d0                	callq  *%rax
}
  804247:	c9                   	leaveq 
  804248:	c3                   	retq   

0000000000804249 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  804249:	55                   	push   %rbp
  80424a:	48 89 e5             	mov    %rsp,%rbp
  80424d:	48 83 ec 08          	sub    $0x8,%rsp
  804251:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  804254:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804257:	89 c2                	mov    %eax,%edx
  804259:	c1 e2 18             	shl    $0x18,%edx
    ((n & 0xff00) << 8) |
  80425c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80425f:	25 00 ff 00 00       	and    $0xff00,%eax
  804264:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804267:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  804269:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80426c:	25 00 00 ff 00       	and    $0xff0000,%eax
  804271:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804275:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  804277:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427a:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80427d:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80427f:	c9                   	leaveq 
  804280:	c3                   	retq   

0000000000804281 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804281:	55                   	push   %rbp
  804282:	48 89 e5             	mov    %rsp,%rbp
  804285:	48 83 ec 08          	sub    $0x8,%rsp
  804289:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  80428c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80428f:	89 c7                	mov    %eax,%edi
  804291:	48 b8 49 42 80 00 00 	movabs $0x804249,%rax
  804298:	00 00 00 
  80429b:	ff d0                	callq  *%rax
}
  80429d:	c9                   	leaveq 
  80429e:	c3                   	retq   
