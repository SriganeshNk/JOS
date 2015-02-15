
obj/user/lsfd.debug:     file format elf64-x86-64


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
  80003c:	e8 7f 01 00 00       	callq  8001c0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800048:	48 bf 80 42 80 00 00 	movabs $0x804280,%rdi
  80004f:	00 00 00 
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	48 ba b3 03 80 00 00 	movabs $0x8003b3,%rdx
  80005e:	00 00 00 
  800061:	ff d2                	callq  *%rdx
	exit();
  800063:	48 b8 68 02 80 00 00 	movabs $0x800268,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
}
  80006f:	5d                   	pop    %rbp
  800070:	c3                   	retq   

0000000000800071 <umain>:

void
umain(int argc, char **argv)
{
  800071:	55                   	push   %rbp
  800072:	48 89 e5             	mov    %rsp,%rbp
  800075:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80007c:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800082:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800089:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800090:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800097:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009e:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a5:	48 89 ce             	mov    %rcx,%rsi
  8000a8:	48 89 c7             	mov    %rax,%rdi
  8000ab:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b7:	eb 1b                	jmp    8000d4 <umain+0x63>
		if (i == '1')
  8000b9:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bd:	75 09                	jne    8000c8 <umain+0x57>
			usefprint = 1;
  8000bf:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c6:	eb 0c                	jmp    8000d4 <umain+0x63>
		else
			usage();
  8000c8:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000db:	48 89 c7             	mov    %rax,%rdi
  8000de:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
  8000ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f1:	79 c6                	jns    8000b9 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000fa:	e9 b3 00 00 00       	jmpq   8001b2 <umain+0x141>
		if (fstat(i, &st) >= 0) {
  8000ff:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	48 89 d6             	mov    %rdx,%rsi
  80010c:	89 c7                	mov    %eax,%edi
  80010e:	48 b8 3b 27 80 00 00 	movabs $0x80273b,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
  80011a:	85 c0                	test   %eax,%eax
  80011c:	0f 88 8c 00 00 00    	js     8001ae <umain+0x13d>
			if (usefprint)
  800122:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800126:	74 4a                	je     800172 <umain+0x101>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012c:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800130:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800133:	8b 75 e4             	mov    -0x1c(%rbp),%esi
					i, st.st_name, st.st_isdir,
  800136:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80013d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800140:	48 89 0c 24          	mov    %rcx,(%rsp)
  800144:	41 89 f9             	mov    %edi,%r9d
  800147:	41 89 f0             	mov    %esi,%r8d
  80014a:	48 89 d1             	mov    %rdx,%rcx
  80014d:	89 c2                	mov    %eax,%edx
  80014f:	48 be 98 42 80 00 00 	movabs $0x804298,%rsi
  800156:	00 00 00 
  800159:	bf 01 00 00 00       	mov    $0x1,%edi
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 ba ac 2c 80 00 00 	movabs $0x802cac,%r10
  80016a:	00 00 00 
  80016d:	41 ff d2             	callq  *%r10
  800170:	eb 3c                	jmp    8001ae <umain+0x13d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800176:	48 8b 78 08          	mov    0x8(%rax),%rdi
  80017a:	8b 75 e0             	mov    -0x20(%rbp),%esi
  80017d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
					i, st.st_name, st.st_isdir,
  800180:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018a:	49 89 f9             	mov    %rdi,%r9
  80018d:	41 89 f0             	mov    %esi,%r8d
  800190:	89 c6                	mov    %eax,%esi
  800192:	48 bf 98 42 80 00 00 	movabs $0x804298,%rdi
  800199:	00 00 00 
  80019c:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a1:	49 ba b3 03 80 00 00 	movabs $0x8003b3,%r10
  8001a8:	00 00 00 
  8001ab:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001b6:	0f 8e 43 ff ff ff    	jle    8000ff <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001bc:	c9                   	leaveq 
  8001bd:	c3                   	retq   
	...

00000000008001c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c0:	55                   	push   %rbp
  8001c1:	48 89 e5             	mov    %rsp,%rbp
  8001c4:	48 83 ec 10          	sub    $0x10,%rsp
  8001c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001cf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001d6:	00 00 00 
  8001d9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8001e0:	48 b8 40 18 80 00 00 	movabs $0x801840,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax
  8001ec:	48 98                	cltq   
  8001ee:	48 89 c2             	mov    %rax,%rdx
  8001f1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001f7:	48 89 d0             	mov    %rdx,%rax
  8001fa:	48 c1 e0 02          	shl    $0x2,%rax
  8001fe:	48 01 d0             	add    %rdx,%rax
  800201:	48 01 c0             	add    %rax,%rax
  800204:	48 01 d0             	add    %rdx,%rax
  800207:	48 c1 e0 05          	shl    $0x5,%rax
  80020b:	48 89 c2             	mov    %rax,%rdx
  80020e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800215:	00 00 00 
  800218:	48 01 c2             	add    %rax,%rdx
  80021b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800222:	00 00 00 
  800225:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800228:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80022c:	7e 14                	jle    800242 <libmain+0x82>
		binaryname = argv[0];
  80022e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800232:	48 8b 10             	mov    (%rax),%rdx
  800235:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80023c:	00 00 00 
  80023f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800242:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800246:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800249:	48 89 d6             	mov    %rdx,%rsi
  80024c:	89 c7                	mov    %eax,%edi
  80024e:	48 b8 71 00 80 00 00 	movabs $0x800071,%rax
  800255:	00 00 00 
  800258:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80025a:	48 b8 68 02 80 00 00 	movabs $0x800268,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
}
  800266:	c9                   	leaveq 
  800267:	c3                   	retq   

0000000000800268 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800268:	55                   	push   %rbp
  800269:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80026c:	48 b8 2d 22 80 00 00 	movabs $0x80222d,%rax
  800273:	00 00 00 
  800276:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800278:	bf 00 00 00 00       	mov    $0x0,%edi
  80027d:	48 b8 fc 17 80 00 00 	movabs $0x8017fc,%rax
  800284:	00 00 00 
  800287:	ff d0                	callq  *%rax
}
  800289:	5d                   	pop    %rbp
  80028a:	c3                   	retq   
	...

000000000080028c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80028c:	55                   	push   %rbp
  80028d:	48 89 e5             	mov    %rsp,%rbp
  800290:	48 83 ec 10          	sub    $0x10,%rsp
  800294:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800297:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80029b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029f:	8b 00                	mov    (%rax),%eax
  8002a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002a4:	89 d6                	mov    %edx,%esi
  8002a6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8002aa:	48 63 d0             	movslq %eax,%rdx
  8002ad:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8002b2:	8d 50 01             	lea    0x1(%rax),%edx
  8002b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b9:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8002bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002bf:	8b 00                	mov    (%rax),%eax
  8002c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c6:	75 2c                	jne    8002f4 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8002c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002cc:	8b 00                	mov    (%rax),%eax
  8002ce:	48 98                	cltq   
  8002d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d4:	48 83 c2 08          	add    $0x8,%rdx
  8002d8:	48 89 c6             	mov    %rax,%rsi
  8002db:	48 89 d7             	mov    %rdx,%rdi
  8002de:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  8002e5:	00 00 00 
  8002e8:	ff d0                	callq  *%rax
        b->idx = 0;
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f8:	8b 40 04             	mov    0x4(%rax),%eax
  8002fb:	8d 50 01             	lea    0x1(%rax),%edx
  8002fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800302:	89 50 04             	mov    %edx,0x4(%rax)
}
  800305:	c9                   	leaveq 
  800306:	c3                   	retq   

0000000000800307 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800307:	55                   	push   %rbp
  800308:	48 89 e5             	mov    %rsp,%rbp
  80030b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800312:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800319:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800320:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800327:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80032e:	48 8b 0a             	mov    (%rdx),%rcx
  800331:	48 89 08             	mov    %rcx,(%rax)
  800334:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800338:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80033c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800340:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800344:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80034b:	00 00 00 
    b.cnt = 0;
  80034e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800355:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800358:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80035f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800366:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80036d:	48 89 c6             	mov    %rax,%rsi
  800370:	48 bf 8c 02 80 00 00 	movabs $0x80028c,%rdi
  800377:	00 00 00 
  80037a:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  800381:	00 00 00 
  800384:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800386:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80038c:	48 98                	cltq   
  80038e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800395:	48 83 c2 08          	add    $0x8,%rdx
  800399:	48 89 c6             	mov    %rax,%rsi
  80039c:	48 89 d7             	mov    %rdx,%rdi
  80039f:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  8003a6:	00 00 00 
  8003a9:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003b1:	c9                   	leaveq 
  8003b2:	c3                   	retq   

00000000008003b3 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003b3:	55                   	push   %rbp
  8003b4:	48 89 e5             	mov    %rsp,%rbp
  8003b7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003be:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003c5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003cc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003d3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003da:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003e1:	84 c0                	test   %al,%al
  8003e3:	74 20                	je     800405 <cprintf+0x52>
  8003e5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003e9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003ed:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003f1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003f5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003f9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003fd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800401:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800405:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80040c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800413:	00 00 00 
  800416:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80041d:	00 00 00 
  800420:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800424:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80042b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800432:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800439:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800440:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800447:	48 8b 0a             	mov    (%rdx),%rcx
  80044a:	48 89 08             	mov    %rcx,(%rax)
  80044d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800451:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800455:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800459:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80045d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800464:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80046b:	48 89 d6             	mov    %rdx,%rsi
  80046e:	48 89 c7             	mov    %rax,%rdi
  800471:	48 b8 07 03 80 00 00 	movabs $0x800307,%rax
  800478:	00 00 00 
  80047b:	ff d0                	callq  *%rax
  80047d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800483:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800489:	c9                   	leaveq 
  80048a:	c3                   	retq   
	...

000000000080048c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80048c:	55                   	push   %rbp
  80048d:	48 89 e5             	mov    %rsp,%rbp
  800490:	48 83 ec 30          	sub    $0x30,%rsp
  800494:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800498:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80049c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004a0:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8004a3:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8004a7:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004ae:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004b2:	77 52                	ja     800506 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004b4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004b7:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004bb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004be:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8004c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004cb:	48 f7 75 d0          	divq   -0x30(%rbp)
  8004cf:	48 89 c2             	mov    %rax,%rdx
  8004d2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8004d5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8004d8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8004dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e0:	41 89 f9             	mov    %edi,%r9d
  8004e3:	48 89 c7             	mov    %rax,%rdi
  8004e6:	48 b8 8c 04 80 00 00 	movabs $0x80048c,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	eb 1c                	jmp    800510 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004fb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004ff:	48 89 d6             	mov    %rdx,%rsi
  800502:	89 c7                	mov    %eax,%edi
  800504:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800506:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80050a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80050e:	7f e4                	jg     8004f4 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800510:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800517:	ba 00 00 00 00       	mov    $0x0,%edx
  80051c:	48 f7 f1             	div    %rcx
  80051f:	48 89 d0             	mov    %rdx,%rax
  800522:	48 ba d0 44 80 00 00 	movabs $0x8044d0,%rdx
  800529:	00 00 00 
  80052c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800530:	0f be c0             	movsbl %al,%eax
  800533:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800537:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80053b:	48 89 d6             	mov    %rdx,%rsi
  80053e:	89 c7                	mov    %eax,%edi
  800540:	ff d1                	callq  *%rcx
}
  800542:	c9                   	leaveq 
  800543:	c3                   	retq   

0000000000800544 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800544:	55                   	push   %rbp
  800545:	48 89 e5             	mov    %rsp,%rbp
  800548:	48 83 ec 20          	sub    $0x20,%rsp
  80054c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800550:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800553:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800557:	7e 52                	jle    8005ab <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055d:	8b 00                	mov    (%rax),%eax
  80055f:	83 f8 30             	cmp    $0x30,%eax
  800562:	73 24                	jae    800588 <getuint+0x44>
  800564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800568:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	8b 00                	mov    (%rax),%eax
  800572:	89 c0                	mov    %eax,%eax
  800574:	48 01 d0             	add    %rdx,%rax
  800577:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057b:	8b 12                	mov    (%rdx),%edx
  80057d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800580:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800584:	89 0a                	mov    %ecx,(%rdx)
  800586:	eb 17                	jmp    80059f <getuint+0x5b>
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800590:	48 89 d0             	mov    %rdx,%rax
  800593:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800597:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80059f:	48 8b 00             	mov    (%rax),%rax
  8005a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005a6:	e9 a3 00 00 00       	jmpq   80064e <getuint+0x10a>
	else if (lflag)
  8005ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005af:	74 4f                	je     800600 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	8b 00                	mov    (%rax),%eax
  8005b7:	83 f8 30             	cmp    $0x30,%eax
  8005ba:	73 24                	jae    8005e0 <getuint+0x9c>
  8005bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	8b 00                	mov    (%rax),%eax
  8005ca:	89 c0                	mov    %eax,%eax
  8005cc:	48 01 d0             	add    %rdx,%rax
  8005cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d3:	8b 12                	mov    (%rdx),%edx
  8005d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005dc:	89 0a                	mov    %ecx,(%rdx)
  8005de:	eb 17                	jmp    8005f7 <getuint+0xb3>
  8005e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e8:	48 89 d0             	mov    %rdx,%rax
  8005eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f7:	48 8b 00             	mov    (%rax),%rax
  8005fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005fe:	eb 4e                	jmp    80064e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	8b 00                	mov    (%rax),%eax
  800606:	83 f8 30             	cmp    $0x30,%eax
  800609:	73 24                	jae    80062f <getuint+0xeb>
  80060b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800617:	8b 00                	mov    (%rax),%eax
  800619:	89 c0                	mov    %eax,%eax
  80061b:	48 01 d0             	add    %rdx,%rax
  80061e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800622:	8b 12                	mov    (%rdx),%edx
  800624:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800627:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062b:	89 0a                	mov    %ecx,(%rdx)
  80062d:	eb 17                	jmp    800646 <getuint+0x102>
  80062f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800633:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800637:	48 89 d0             	mov    %rdx,%rax
  80063a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80063e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800642:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800646:	8b 00                	mov    (%rax),%eax
  800648:	89 c0                	mov    %eax,%eax
  80064a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80064e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800652:	c9                   	leaveq 
  800653:	c3                   	retq   

0000000000800654 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800654:	55                   	push   %rbp
  800655:	48 89 e5             	mov    %rsp,%rbp
  800658:	48 83 ec 20          	sub    $0x20,%rsp
  80065c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800660:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800663:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800667:	7e 52                	jle    8006bb <getint+0x67>
		x=va_arg(*ap, long long);
  800669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066d:	8b 00                	mov    (%rax),%eax
  80066f:	83 f8 30             	cmp    $0x30,%eax
  800672:	73 24                	jae    800698 <getint+0x44>
  800674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800678:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800680:	8b 00                	mov    (%rax),%eax
  800682:	89 c0                	mov    %eax,%eax
  800684:	48 01 d0             	add    %rdx,%rax
  800687:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068b:	8b 12                	mov    (%rdx),%edx
  80068d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800690:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800694:	89 0a                	mov    %ecx,(%rdx)
  800696:	eb 17                	jmp    8006af <getint+0x5b>
  800698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a0:	48 89 d0             	mov    %rdx,%rax
  8006a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006af:	48 8b 00             	mov    (%rax),%rax
  8006b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b6:	e9 a3 00 00 00       	jmpq   80075e <getint+0x10a>
	else if (lflag)
  8006bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006bf:	74 4f                	je     800710 <getint+0xbc>
		x=va_arg(*ap, long);
  8006c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c5:	8b 00                	mov    (%rax),%eax
  8006c7:	83 f8 30             	cmp    $0x30,%eax
  8006ca:	73 24                	jae    8006f0 <getint+0x9c>
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	8b 00                	mov    (%rax),%eax
  8006da:	89 c0                	mov    %eax,%eax
  8006dc:	48 01 d0             	add    %rdx,%rax
  8006df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e3:	8b 12                	mov    (%rdx),%edx
  8006e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ec:	89 0a                	mov    %ecx,(%rdx)
  8006ee:	eb 17                	jmp    800707 <getint+0xb3>
  8006f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f8:	48 89 d0             	mov    %rdx,%rax
  8006fb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800703:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800707:	48 8b 00             	mov    (%rax),%rax
  80070a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80070e:	eb 4e                	jmp    80075e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800714:	8b 00                	mov    (%rax),%eax
  800716:	83 f8 30             	cmp    $0x30,%eax
  800719:	73 24                	jae    80073f <getint+0xeb>
  80071b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800727:	8b 00                	mov    (%rax),%eax
  800729:	89 c0                	mov    %eax,%eax
  80072b:	48 01 d0             	add    %rdx,%rax
  80072e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800732:	8b 12                	mov    (%rdx),%edx
  800734:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800737:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073b:	89 0a                	mov    %ecx,(%rdx)
  80073d:	eb 17                	jmp    800756 <getint+0x102>
  80073f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800743:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800747:	48 89 d0             	mov    %rdx,%rax
  80074a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80074e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800752:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800756:	8b 00                	mov    (%rax),%eax
  800758:	48 98                	cltq   
  80075a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80075e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800762:	c9                   	leaveq 
  800763:	c3                   	retq   

0000000000800764 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800764:	55                   	push   %rbp
  800765:	48 89 e5             	mov    %rsp,%rbp
  800768:	41 54                	push   %r12
  80076a:	53                   	push   %rbx
  80076b:	48 83 ec 60          	sub    $0x60,%rsp
  80076f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800773:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800777:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80077b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80077f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800783:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800787:	48 8b 0a             	mov    (%rdx),%rcx
  80078a:	48 89 08             	mov    %rcx,(%rax)
  80078d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800791:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800795:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800799:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079d:	eb 17                	jmp    8007b6 <vprintfmt+0x52>
			if (ch == '\0')
  80079f:	85 db                	test   %ebx,%ebx
  8007a1:	0f 84 ea 04 00 00    	je     800c91 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  8007a7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8007ab:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8007af:	48 89 c6             	mov    %rax,%rsi
  8007b2:	89 df                	mov    %ebx,%edi
  8007b4:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007ba:	0f b6 00             	movzbl (%rax),%eax
  8007bd:	0f b6 d8             	movzbl %al,%ebx
  8007c0:	83 fb 25             	cmp    $0x25,%ebx
  8007c3:	0f 95 c0             	setne  %al
  8007c6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8007cb:	84 c0                	test   %al,%al
  8007cd:	75 d0                	jne    80079f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007cf:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007d3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007da:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8007ef:	eb 04                	jmp    8007f5 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8007f1:	90                   	nop
  8007f2:	eb 01                	jmp    8007f5 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8007f4:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007f9:	0f b6 00             	movzbl (%rax),%eax
  8007fc:	0f b6 d8             	movzbl %al,%ebx
  8007ff:	89 d8                	mov    %ebx,%eax
  800801:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800806:	83 e8 23             	sub    $0x23,%eax
  800809:	83 f8 55             	cmp    $0x55,%eax
  80080c:	0f 87 4b 04 00 00    	ja     800c5d <vprintfmt+0x4f9>
  800812:	89 c0                	mov    %eax,%eax
  800814:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80081b:	00 
  80081c:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  800823:	00 00 00 
  800826:	48 01 d0             	add    %rdx,%rax
  800829:	48 8b 00             	mov    (%rax),%rax
  80082c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80082e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800832:	eb c1                	jmp    8007f5 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800834:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800838:	eb bb                	jmp    8007f5 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80083a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800841:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800844:	89 d0                	mov    %edx,%eax
  800846:	c1 e0 02             	shl    $0x2,%eax
  800849:	01 d0                	add    %edx,%eax
  80084b:	01 c0                	add    %eax,%eax
  80084d:	01 d8                	add    %ebx,%eax
  80084f:	83 e8 30             	sub    $0x30,%eax
  800852:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800855:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800859:	0f b6 00             	movzbl (%rax),%eax
  80085c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085f:	83 fb 2f             	cmp    $0x2f,%ebx
  800862:	7e 63                	jle    8008c7 <vprintfmt+0x163>
  800864:	83 fb 39             	cmp    $0x39,%ebx
  800867:	7f 5e                	jg     8008c7 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800869:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80086e:	eb d1                	jmp    800841 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800870:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800873:	83 f8 30             	cmp    $0x30,%eax
  800876:	73 17                	jae    80088f <vprintfmt+0x12b>
  800878:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80087c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087f:	89 c0                	mov    %eax,%eax
  800881:	48 01 d0             	add    %rdx,%rax
  800884:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800887:	83 c2 08             	add    $0x8,%edx
  80088a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80088d:	eb 0f                	jmp    80089e <vprintfmt+0x13a>
  80088f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800893:	48 89 d0             	mov    %rdx,%rax
  800896:	48 83 c2 08          	add    $0x8,%rdx
  80089a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089e:	8b 00                	mov    (%rax),%eax
  8008a0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008a3:	eb 23                	jmp    8008c8 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8008a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008a9:	0f 89 42 ff ff ff    	jns    8007f1 <vprintfmt+0x8d>
				width = 0;
  8008af:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008b6:	e9 36 ff ff ff       	jmpq   8007f1 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8008bb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008c2:	e9 2e ff ff ff       	jmpq   8007f5 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008c7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008cc:	0f 89 22 ff ff ff    	jns    8007f4 <vprintfmt+0x90>
				width = precision, precision = -1;
  8008d2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008d5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008df:	e9 10 ff ff ff       	jmpq   8007f4 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008e4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008e8:	e9 08 ff ff ff       	jmpq   8007f5 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f0:	83 f8 30             	cmp    $0x30,%eax
  8008f3:	73 17                	jae    80090c <vprintfmt+0x1a8>
  8008f5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fc:	89 c0                	mov    %eax,%eax
  8008fe:	48 01 d0             	add    %rdx,%rax
  800901:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800904:	83 c2 08             	add    $0x8,%edx
  800907:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80090a:	eb 0f                	jmp    80091b <vprintfmt+0x1b7>
  80090c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800910:	48 89 d0             	mov    %rdx,%rax
  800913:	48 83 c2 08          	add    $0x8,%rdx
  800917:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80091b:	8b 00                	mov    (%rax),%eax
  80091d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800921:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800925:	48 89 d6             	mov    %rdx,%rsi
  800928:	89 c7                	mov    %eax,%edi
  80092a:	ff d1                	callq  *%rcx
			break;
  80092c:	e9 5a 03 00 00       	jmpq   800c8b <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800931:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800934:	83 f8 30             	cmp    $0x30,%eax
  800937:	73 17                	jae    800950 <vprintfmt+0x1ec>
  800939:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80093d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800940:	89 c0                	mov    %eax,%eax
  800942:	48 01 d0             	add    %rdx,%rax
  800945:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800948:	83 c2 08             	add    $0x8,%edx
  80094b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80094e:	eb 0f                	jmp    80095f <vprintfmt+0x1fb>
  800950:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800954:	48 89 d0             	mov    %rdx,%rax
  800957:	48 83 c2 08          	add    $0x8,%rdx
  80095b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80095f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800961:	85 db                	test   %ebx,%ebx
  800963:	79 02                	jns    800967 <vprintfmt+0x203>
				err = -err;
  800965:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800967:	83 fb 15             	cmp    $0x15,%ebx
  80096a:	7f 16                	jg     800982 <vprintfmt+0x21e>
  80096c:	48 b8 20 44 80 00 00 	movabs $0x804420,%rax
  800973:	00 00 00 
  800976:	48 63 d3             	movslq %ebx,%rdx
  800979:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80097d:	4d 85 e4             	test   %r12,%r12
  800980:	75 2e                	jne    8009b0 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800982:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800986:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098a:	89 d9                	mov    %ebx,%ecx
  80098c:	48 ba e1 44 80 00 00 	movabs $0x8044e1,%rdx
  800993:	00 00 00 
  800996:	48 89 c7             	mov    %rax,%rdi
  800999:	b8 00 00 00 00       	mov    $0x0,%eax
  80099e:	49 b8 9b 0c 80 00 00 	movabs $0x800c9b,%r8
  8009a5:	00 00 00 
  8009a8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ab:	e9 db 02 00 00       	jmpq   800c8b <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009b0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b8:	4c 89 e1             	mov    %r12,%rcx
  8009bb:	48 ba ea 44 80 00 00 	movabs $0x8044ea,%rdx
  8009c2:	00 00 00 
  8009c5:	48 89 c7             	mov    %rax,%rdi
  8009c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cd:	49 b8 9b 0c 80 00 00 	movabs $0x800c9b,%r8
  8009d4:	00 00 00 
  8009d7:	41 ff d0             	callq  *%r8
			break;
  8009da:	e9 ac 02 00 00       	jmpq   800c8b <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e2:	83 f8 30             	cmp    $0x30,%eax
  8009e5:	73 17                	jae    8009fe <vprintfmt+0x29a>
  8009e7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ee:	89 c0                	mov    %eax,%eax
  8009f0:	48 01 d0             	add    %rdx,%rax
  8009f3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f6:	83 c2 08             	add    $0x8,%edx
  8009f9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009fc:	eb 0f                	jmp    800a0d <vprintfmt+0x2a9>
  8009fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a02:	48 89 d0             	mov    %rdx,%rax
  800a05:	48 83 c2 08          	add    $0x8,%rdx
  800a09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a0d:	4c 8b 20             	mov    (%rax),%r12
  800a10:	4d 85 e4             	test   %r12,%r12
  800a13:	75 0a                	jne    800a1f <vprintfmt+0x2bb>
				p = "(null)";
  800a15:	49 bc ed 44 80 00 00 	movabs $0x8044ed,%r12
  800a1c:	00 00 00 
			if (width > 0 && padc != '-')
  800a1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a23:	7e 7a                	jle    800a9f <vprintfmt+0x33b>
  800a25:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a29:	74 74                	je     800a9f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a2b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a2e:	48 98                	cltq   
  800a30:	48 89 c6             	mov    %rax,%rsi
  800a33:	4c 89 e7             	mov    %r12,%rdi
  800a36:	48 b8 46 0f 80 00 00 	movabs $0x800f46,%rax
  800a3d:	00 00 00 
  800a40:	ff d0                	callq  *%rax
  800a42:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a45:	eb 17                	jmp    800a5e <vprintfmt+0x2fa>
					putch(padc, putdat);
  800a47:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800a4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4f:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a53:	48 89 d6             	mov    %rdx,%rsi
  800a56:	89 c7                	mov    %eax,%edi
  800a58:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a62:	7f e3                	jg     800a47 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a64:	eb 39                	jmp    800a9f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800a66:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a6a:	74 1e                	je     800a8a <vprintfmt+0x326>
  800a6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800a6f:	7e 05                	jle    800a76 <vprintfmt+0x312>
  800a71:	83 fb 7e             	cmp    $0x7e,%ebx
  800a74:	7e 14                	jle    800a8a <vprintfmt+0x326>
					putch('?', putdat);
  800a76:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a7a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a7e:	48 89 c6             	mov    %rax,%rsi
  800a81:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a86:	ff d2                	callq  *%rdx
  800a88:	eb 0f                	jmp    800a99 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800a8a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a8e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a92:	48 89 c6             	mov    %rax,%rsi
  800a95:	89 df                	mov    %ebx,%edi
  800a97:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a99:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a9d:	eb 01                	jmp    800aa0 <vprintfmt+0x33c>
  800a9f:	90                   	nop
  800aa0:	41 0f b6 04 24       	movzbl (%r12),%eax
  800aa5:	0f be d8             	movsbl %al,%ebx
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	0f 95 c0             	setne  %al
  800aad:	49 83 c4 01          	add    $0x1,%r12
  800ab1:	84 c0                	test   %al,%al
  800ab3:	74 28                	je     800add <vprintfmt+0x379>
  800ab5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ab9:	78 ab                	js     800a66 <vprintfmt+0x302>
  800abb:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800abf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ac3:	79 a1                	jns    800a66 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac5:	eb 16                	jmp    800add <vprintfmt+0x379>
				putch(' ', putdat);
  800ac7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800acb:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800acf:	48 89 c6             	mov    %rax,%rsi
  800ad2:	bf 20 00 00 00       	mov    $0x20,%edi
  800ad7:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800add:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ae1:	7f e4                	jg     800ac7 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800ae3:	e9 a3 01 00 00       	jmpq   800c8b <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ae8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aec:	be 03 00 00 00       	mov    $0x3,%esi
  800af1:	48 89 c7             	mov    %rax,%rdi
  800af4:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  800afb:	00 00 00 
  800afe:	ff d0                	callq  *%rax
  800b00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b08:	48 85 c0             	test   %rax,%rax
  800b0b:	79 1d                	jns    800b2a <vprintfmt+0x3c6>
				putch('-', putdat);
  800b0d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b11:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b15:	48 89 c6             	mov    %rax,%rsi
  800b18:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b1d:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b23:	48 f7 d8             	neg    %rax
  800b26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b2a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b31:	e9 e8 00 00 00       	jmpq   800c1e <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b36:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b3a:	be 03 00 00 00       	mov    $0x3,%esi
  800b3f:	48 89 c7             	mov    %rax,%rdi
  800b42:	48 b8 44 05 80 00 00 	movabs $0x800544,%rax
  800b49:	00 00 00 
  800b4c:	ff d0                	callq  *%rax
  800b4e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b52:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b59:	e9 c0 00 00 00       	jmpq   800c1e <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b5e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b62:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b66:	48 89 c6             	mov    %rax,%rsi
  800b69:	bf 58 00 00 00       	mov    $0x58,%edi
  800b6e:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800b70:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b74:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b78:	48 89 c6             	mov    %rax,%rsi
  800b7b:	bf 58 00 00 00       	mov    $0x58,%edi
  800b80:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800b82:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b86:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b8a:	48 89 c6             	mov    %rax,%rsi
  800b8d:	bf 58 00 00 00       	mov    $0x58,%edi
  800b92:	ff d2                	callq  *%rdx
			break;
  800b94:	e9 f2 00 00 00       	jmpq   800c8b <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800b99:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b9d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ba1:	48 89 c6             	mov    %rax,%rsi
  800ba4:	bf 30 00 00 00       	mov    $0x30,%edi
  800ba9:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800bab:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800baf:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bb3:	48 89 c6             	mov    %rax,%rsi
  800bb6:	bf 78 00 00 00       	mov    $0x78,%edi
  800bbb:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	83 f8 30             	cmp    $0x30,%eax
  800bc3:	73 17                	jae    800bdc <vprintfmt+0x478>
  800bc5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcc:	89 c0                	mov    %eax,%eax
  800bce:	48 01 d0             	add    %rdx,%rax
  800bd1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd4:	83 c2 08             	add    $0x8,%edx
  800bd7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bda:	eb 0f                	jmp    800beb <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800bdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be0:	48 89 d0             	mov    %rdx,%rax
  800be3:	48 83 c2 08          	add    $0x8,%rdx
  800be7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800beb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bf2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bf9:	eb 23                	jmp    800c1e <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bfb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bff:	be 03 00 00 00       	mov    $0x3,%esi
  800c04:	48 89 c7             	mov    %rax,%rdi
  800c07:	48 b8 44 05 80 00 00 	movabs $0x800544,%rax
  800c0e:	00 00 00 
  800c11:	ff d0                	callq  *%rax
  800c13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c17:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c1e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c23:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c26:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c2d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c35:	45 89 c1             	mov    %r8d,%r9d
  800c38:	41 89 f8             	mov    %edi,%r8d
  800c3b:	48 89 c7             	mov    %rax,%rdi
  800c3e:	48 b8 8c 04 80 00 00 	movabs $0x80048c,%rax
  800c45:	00 00 00 
  800c48:	ff d0                	callq  *%rax
			break;
  800c4a:	eb 3f                	jmp    800c8b <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c4c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c50:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c54:	48 89 c6             	mov    %rax,%rsi
  800c57:	89 df                	mov    %ebx,%edi
  800c59:	ff d2                	callq  *%rdx
			break;
  800c5b:	eb 2e                	jmp    800c8b <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c5d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c61:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c65:	48 89 c6             	mov    %rax,%rsi
  800c68:	bf 25 00 00 00       	mov    $0x25,%edi
  800c6d:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c6f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c74:	eb 05                	jmp    800c7b <vprintfmt+0x517>
  800c76:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c7b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c7f:	48 83 e8 01          	sub    $0x1,%rax
  800c83:	0f b6 00             	movzbl (%rax),%eax
  800c86:	3c 25                	cmp    $0x25,%al
  800c88:	75 ec                	jne    800c76 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800c8a:	90                   	nop
		}
	}
  800c8b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c8c:	e9 25 fb ff ff       	jmpq   8007b6 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800c91:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c92:	48 83 c4 60          	add    $0x60,%rsp
  800c96:	5b                   	pop    %rbx
  800c97:	41 5c                	pop    %r12
  800c99:	5d                   	pop    %rbp
  800c9a:	c3                   	retq   

0000000000800c9b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c9b:	55                   	push   %rbp
  800c9c:	48 89 e5             	mov    %rsp,%rbp
  800c9f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ca6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cad:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cb4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cbb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cc2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 20                	je     800ced <printfmt+0x52>
  800ccd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cd1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cd5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cd9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cdd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ce1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ce5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ce9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ced:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cf4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cfb:	00 00 00 
  800cfe:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d05:	00 00 00 
  800d08:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d0c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d13:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d1a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d21:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d28:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d2f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d36:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d3d:	48 89 c7             	mov    %rax,%rdi
  800d40:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  800d47:	00 00 00 
  800d4a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d4c:	c9                   	leaveq 
  800d4d:	c3                   	retq   

0000000000800d4e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d4e:	55                   	push   %rbp
  800d4f:	48 89 e5             	mov    %rsp,%rbp
  800d52:	48 83 ec 10          	sub    $0x10,%rsp
  800d56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d61:	8b 40 10             	mov    0x10(%rax),%eax
  800d64:	8d 50 01             	lea    0x1(%rax),%edx
  800d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d72:	48 8b 10             	mov    (%rax),%rdx
  800d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d79:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d7d:	48 39 c2             	cmp    %rax,%rdx
  800d80:	73 17                	jae    800d99 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d86:	48 8b 00             	mov    (%rax),%rax
  800d89:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d8c:	88 10                	mov    %dl,(%rax)
  800d8e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d96:	48 89 10             	mov    %rdx,(%rax)
}
  800d99:	c9                   	leaveq 
  800d9a:	c3                   	retq   

0000000000800d9b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9b:	55                   	push   %rbp
  800d9c:	48 89 e5             	mov    %rsp,%rbp
  800d9f:	48 83 ec 50          	sub    $0x50,%rsp
  800da3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800da7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800daa:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800dae:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800db2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800db6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800dba:	48 8b 0a             	mov    (%rdx),%rcx
  800dbd:	48 89 08             	mov    %rcx,(%rax)
  800dc0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dcc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dd4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dd8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ddb:	48 98                	cltq   
  800ddd:	48 83 e8 01          	sub    $0x1,%rax
  800de1:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800de5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800de9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800df0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800df5:	74 06                	je     800dfd <vsnprintf+0x62>
  800df7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dfb:	7f 07                	jg     800e04 <vsnprintf+0x69>
		return -E_INVAL;
  800dfd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e02:	eb 2f                	jmp    800e33 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e04:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e08:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e0c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e10:	48 89 c6             	mov    %rax,%rsi
  800e13:	48 bf 4e 0d 80 00 00 	movabs $0x800d4e,%rdi
  800e1a:	00 00 00 
  800e1d:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e30:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e33:	c9                   	leaveq 
  800e34:	c3                   	retq   

0000000000800e35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e35:	55                   	push   %rbp
  800e36:	48 89 e5             	mov    %rsp,%rbp
  800e39:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e40:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e47:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e4d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e54:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e5b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e62:	84 c0                	test   %al,%al
  800e64:	74 20                	je     800e86 <snprintf+0x51>
  800e66:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e6a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e6e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e72:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e76:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e7a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e7e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e82:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e86:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e8d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e94:	00 00 00 
  800e97:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e9e:	00 00 00 
  800ea1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ea5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800eac:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eb3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800eba:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ec1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ec8:	48 8b 0a             	mov    (%rdx),%rcx
  800ecb:	48 89 08             	mov    %rcx,(%rax)
  800ece:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eda:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ede:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ee5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800eec:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ef2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ef9:	48 89 c7             	mov    %rax,%rdi
  800efc:	48 b8 9b 0d 80 00 00 	movabs $0x800d9b,%rax
  800f03:	00 00 00 
  800f06:	ff d0                	callq  *%rax
  800f08:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f0e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f14:	c9                   	leaveq 
  800f15:	c3                   	retq   
	...

0000000000800f18 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f18:	55                   	push   %rbp
  800f19:	48 89 e5             	mov    %rsp,%rbp
  800f1c:	48 83 ec 18          	sub    $0x18,%rsp
  800f20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f2b:	eb 09                	jmp    800f36 <strlen+0x1e>
		n++;
  800f2d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f31:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3a:	0f b6 00             	movzbl (%rax),%eax
  800f3d:	84 c0                	test   %al,%al
  800f3f:	75 ec                	jne    800f2d <strlen+0x15>
		n++;
	return n;
  800f41:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f44:	c9                   	leaveq 
  800f45:	c3                   	retq   

0000000000800f46 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f46:	55                   	push   %rbp
  800f47:	48 89 e5             	mov    %rsp,%rbp
  800f4a:	48 83 ec 20          	sub    $0x20,%rsp
  800f4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f5d:	eb 0e                	jmp    800f6d <strnlen+0x27>
		n++;
  800f5f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f63:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f68:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f6d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f72:	74 0b                	je     800f7f <strnlen+0x39>
  800f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f78:	0f b6 00             	movzbl (%rax),%eax
  800f7b:	84 c0                	test   %al,%al
  800f7d:	75 e0                	jne    800f5f <strnlen+0x19>
		n++;
	return n;
  800f7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 20          	sub    $0x20,%rsp
  800f8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f9c:	90                   	nop
  800f9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa1:	0f b6 10             	movzbl (%rax),%edx
  800fa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa8:	88 10                	mov    %dl,(%rax)
  800faa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fae:	0f b6 00             	movzbl (%rax),%eax
  800fb1:	84 c0                	test   %al,%al
  800fb3:	0f 95 c0             	setne  %al
  800fb6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fbb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800fc0:	84 c0                	test   %al,%al
  800fc2:	75 d9                	jne    800f9d <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc8:	c9                   	leaveq 
  800fc9:	c3                   	retq   

0000000000800fca <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fca:	55                   	push   %rbp
  800fcb:	48 89 e5             	mov    %rsp,%rbp
  800fce:	48 83 ec 20          	sub    $0x20,%rsp
  800fd2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fde:	48 89 c7             	mov    %rax,%rdi
  800fe1:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  800fe8:	00 00 00 
  800feb:	ff d0                	callq  *%rax
  800fed:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ff0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ff3:	48 98                	cltq   
  800ff5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800ff9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ffd:	48 89 d6             	mov    %rdx,%rsi
  801000:	48 89 c7             	mov    %rax,%rdi
  801003:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  80100a:	00 00 00 
  80100d:	ff d0                	callq  *%rax
	return dst;
  80100f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801013:	c9                   	leaveq 
  801014:	c3                   	retq   

0000000000801015 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	48 83 ec 28          	sub    $0x28,%rsp
  80101d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801021:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801025:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801031:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801038:	00 
  801039:	eb 27                	jmp    801062 <strncpy+0x4d>
		*dst++ = *src;
  80103b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80103f:	0f b6 10             	movzbl (%rax),%edx
  801042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801046:	88 10                	mov    %dl,(%rax)
  801048:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80104d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801051:	0f b6 00             	movzbl (%rax),%eax
  801054:	84 c0                	test   %al,%al
  801056:	74 05                	je     80105d <strncpy+0x48>
			src++;
  801058:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80105d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801062:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801066:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80106a:	72 cf                	jb     80103b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80106c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801070:	c9                   	leaveq 
  801071:	c3                   	retq   

0000000000801072 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801072:	55                   	push   %rbp
  801073:	48 89 e5             	mov    %rsp,%rbp
  801076:	48 83 ec 28          	sub    $0x28,%rsp
  80107a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801082:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80108e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801093:	74 37                	je     8010cc <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801095:	eb 17                	jmp    8010ae <strlcpy+0x3c>
			*dst++ = *src++;
  801097:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80109b:	0f b6 10             	movzbl (%rax),%edx
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	88 10                	mov    %dl,(%rax)
  8010a4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010a9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ae:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010b8:	74 0b                	je     8010c5 <strlcpy+0x53>
  8010ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010be:	0f b6 00             	movzbl (%rax),%eax
  8010c1:	84 c0                	test   %al,%al
  8010c3:	75 d2                	jne    801097 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d4:	48 89 d1             	mov    %rdx,%rcx
  8010d7:	48 29 c1             	sub    %rax,%rcx
  8010da:	48 89 c8             	mov    %rcx,%rax
}
  8010dd:	c9                   	leaveq 
  8010de:	c3                   	retq   

00000000008010df <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010df:	55                   	push   %rbp
  8010e0:	48 89 e5             	mov    %rsp,%rbp
  8010e3:	48 83 ec 10          	sub    $0x10,%rsp
  8010e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010ef:	eb 0a                	jmp    8010fb <strcmp+0x1c>
		p++, q++;
  8010f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ff:	0f b6 00             	movzbl (%rax),%eax
  801102:	84 c0                	test   %al,%al
  801104:	74 12                	je     801118 <strcmp+0x39>
  801106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110a:	0f b6 10             	movzbl (%rax),%edx
  80110d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801111:	0f b6 00             	movzbl (%rax),%eax
  801114:	38 c2                	cmp    %al,%dl
  801116:	74 d9                	je     8010f1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111c:	0f b6 00             	movzbl (%rax),%eax
  80111f:	0f b6 d0             	movzbl %al,%edx
  801122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801126:	0f b6 00             	movzbl (%rax),%eax
  801129:	0f b6 c0             	movzbl %al,%eax
  80112c:	89 d1                	mov    %edx,%ecx
  80112e:	29 c1                	sub    %eax,%ecx
  801130:	89 c8                	mov    %ecx,%eax
}
  801132:	c9                   	leaveq 
  801133:	c3                   	retq   

0000000000801134 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801134:	55                   	push   %rbp
  801135:	48 89 e5             	mov    %rsp,%rbp
  801138:	48 83 ec 18          	sub    $0x18,%rsp
  80113c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801140:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801144:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801148:	eb 0f                	jmp    801159 <strncmp+0x25>
		n--, p++, q++;
  80114a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80114f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801154:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801159:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80115e:	74 1d                	je     80117d <strncmp+0x49>
  801160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801164:	0f b6 00             	movzbl (%rax),%eax
  801167:	84 c0                	test   %al,%al
  801169:	74 12                	je     80117d <strncmp+0x49>
  80116b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116f:	0f b6 10             	movzbl (%rax),%edx
  801172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801176:	0f b6 00             	movzbl (%rax),%eax
  801179:	38 c2                	cmp    %al,%dl
  80117b:	74 cd                	je     80114a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80117d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801182:	75 07                	jne    80118b <strncmp+0x57>
		return 0;
  801184:	b8 00 00 00 00       	mov    $0x0,%eax
  801189:	eb 1a                	jmp    8011a5 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80118b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118f:	0f b6 00             	movzbl (%rax),%eax
  801192:	0f b6 d0             	movzbl %al,%edx
  801195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801199:	0f b6 00             	movzbl (%rax),%eax
  80119c:	0f b6 c0             	movzbl %al,%eax
  80119f:	89 d1                	mov    %edx,%ecx
  8011a1:	29 c1                	sub    %eax,%ecx
  8011a3:	89 c8                	mov    %ecx,%eax
}
  8011a5:	c9                   	leaveq 
  8011a6:	c3                   	retq   

00000000008011a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a7:	55                   	push   %rbp
  8011a8:	48 89 e5             	mov    %rsp,%rbp
  8011ab:	48 83 ec 10          	sub    $0x10,%rsp
  8011af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b3:	89 f0                	mov    %esi,%eax
  8011b5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011b8:	eb 17                	jmp    8011d1 <strchr+0x2a>
		if (*s == c)
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c4:	75 06                	jne    8011cc <strchr+0x25>
			return (char *) s;
  8011c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ca:	eb 15                	jmp    8011e1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d5:	0f b6 00             	movzbl (%rax),%eax
  8011d8:	84 c0                	test   %al,%al
  8011da:	75 de                	jne    8011ba <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e1:	c9                   	leaveq 
  8011e2:	c3                   	retq   

00000000008011e3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011e3:	55                   	push   %rbp
  8011e4:	48 89 e5             	mov    %rsp,%rbp
  8011e7:	48 83 ec 10          	sub    $0x10,%rsp
  8011eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ef:	89 f0                	mov    %esi,%eax
  8011f1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011f4:	eb 11                	jmp    801207 <strfind+0x24>
		if (*s == c)
  8011f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801200:	74 12                	je     801214 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801202:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120b:	0f b6 00             	movzbl (%rax),%eax
  80120e:	84 c0                	test   %al,%al
  801210:	75 e4                	jne    8011f6 <strfind+0x13>
  801212:	eb 01                	jmp    801215 <strfind+0x32>
		if (*s == c)
			break;
  801214:	90                   	nop
	return (char *) s;
  801215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801219:	c9                   	leaveq 
  80121a:	c3                   	retq   

000000000080121b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80121b:	55                   	push   %rbp
  80121c:	48 89 e5             	mov    %rsp,%rbp
  80121f:	48 83 ec 18          	sub    $0x18,%rsp
  801223:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801227:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80122a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80122e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801233:	75 06                	jne    80123b <memset+0x20>
		return v;
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801239:	eb 69                	jmp    8012a4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	83 e0 03             	and    $0x3,%eax
  801242:	48 85 c0             	test   %rax,%rax
  801245:	75 48                	jne    80128f <memset+0x74>
  801247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124b:	83 e0 03             	and    $0x3,%eax
  80124e:	48 85 c0             	test   %rax,%rax
  801251:	75 3c                	jne    80128f <memset+0x74>
		c &= 0xFF;
  801253:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80125a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	c1 e2 18             	shl    $0x18,%edx
  801262:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801265:	c1 e0 10             	shl    $0x10,%eax
  801268:	09 c2                	or     %eax,%edx
  80126a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126d:	c1 e0 08             	shl    $0x8,%eax
  801270:	09 d0                	or     %edx,%eax
  801272:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801279:	48 89 c1             	mov    %rax,%rcx
  80127c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801280:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801284:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801287:	48 89 d7             	mov    %rdx,%rdi
  80128a:	fc                   	cld    
  80128b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80128d:	eb 11                	jmp    8012a0 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80128f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801293:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801296:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80129a:	48 89 d7             	mov    %rdx,%rdi
  80129d:	fc                   	cld    
  80129e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012a4:	c9                   	leaveq 
  8012a5:	c3                   	retq   

00000000008012a6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012a6:	55                   	push   %rbp
  8012a7:	48 89 e5             	mov    %rsp,%rbp
  8012aa:	48 83 ec 28          	sub    $0x28,%rsp
  8012ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ce:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012d2:	0f 83 88 00 00 00    	jae    801360 <memmove+0xba>
  8012d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e0:	48 01 d0             	add    %rdx,%rax
  8012e3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012e7:	76 77                	jbe    801360 <memmove+0xba>
		s += n;
  8012e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ed:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fd:	83 e0 03             	and    $0x3,%eax
  801300:	48 85 c0             	test   %rax,%rax
  801303:	75 3b                	jne    801340 <memmove+0x9a>
  801305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801309:	83 e0 03             	and    $0x3,%eax
  80130c:	48 85 c0             	test   %rax,%rax
  80130f:	75 2f                	jne    801340 <memmove+0x9a>
  801311:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801315:	83 e0 03             	and    $0x3,%eax
  801318:	48 85 c0             	test   %rax,%rax
  80131b:	75 23                	jne    801340 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80131d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801321:	48 83 e8 04          	sub    $0x4,%rax
  801325:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801329:	48 83 ea 04          	sub    $0x4,%rdx
  80132d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801331:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801335:	48 89 c7             	mov    %rax,%rdi
  801338:	48 89 d6             	mov    %rdx,%rsi
  80133b:	fd                   	std    
  80133c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80133e:	eb 1d                	jmp    80135d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801344:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801350:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801354:	48 89 d7             	mov    %rdx,%rdi
  801357:	48 89 c1             	mov    %rax,%rcx
  80135a:	fd                   	std    
  80135b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80135d:	fc                   	cld    
  80135e:	eb 57                	jmp    8013b7 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801364:	83 e0 03             	and    $0x3,%eax
  801367:	48 85 c0             	test   %rax,%rax
  80136a:	75 36                	jne    8013a2 <memmove+0xfc>
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	83 e0 03             	and    $0x3,%eax
  801373:	48 85 c0             	test   %rax,%rax
  801376:	75 2a                	jne    8013a2 <memmove+0xfc>
  801378:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137c:	83 e0 03             	and    $0x3,%eax
  80137f:	48 85 c0             	test   %rax,%rax
  801382:	75 1e                	jne    8013a2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801384:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801388:	48 89 c1             	mov    %rax,%rcx
  80138b:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80138f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801393:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801397:	48 89 c7             	mov    %rax,%rdi
  80139a:	48 89 d6             	mov    %rdx,%rsi
  80139d:	fc                   	cld    
  80139e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013a0:	eb 15                	jmp    8013b7 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013aa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ae:	48 89 c7             	mov    %rax,%rdi
  8013b1:	48 89 d6             	mov    %rdx,%rsi
  8013b4:	fc                   	cld    
  8013b5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013bb:	c9                   	leaveq 
  8013bc:	c3                   	retq   

00000000008013bd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013bd:	55                   	push   %rbp
  8013be:	48 89 e5             	mov    %rsp,%rbp
  8013c1:	48 83 ec 18          	sub    $0x18,%rsp
  8013c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013cd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dd:	48 89 ce             	mov    %rcx,%rsi
  8013e0:	48 89 c7             	mov    %rax,%rdi
  8013e3:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  8013ea:	00 00 00 
  8013ed:	ff d0                	callq  *%rax
}
  8013ef:	c9                   	leaveq 
  8013f0:	c3                   	retq   

00000000008013f1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013f1:	55                   	push   %rbp
  8013f2:	48 89 e5             	mov    %rsp,%rbp
  8013f5:	48 83 ec 28          	sub    $0x28,%rsp
  8013f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801401:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801409:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80140d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801411:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801415:	eb 38                	jmp    80144f <memcmp+0x5e>
		if (*s1 != *s2)
  801417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141b:	0f b6 10             	movzbl (%rax),%edx
  80141e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801422:	0f b6 00             	movzbl (%rax),%eax
  801425:	38 c2                	cmp    %al,%dl
  801427:	74 1c                	je     801445 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	0f b6 d0             	movzbl %al,%edx
  801433:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	0f b6 c0             	movzbl %al,%eax
  80143d:	89 d1                	mov    %edx,%ecx
  80143f:	29 c1                	sub    %eax,%ecx
  801441:	89 c8                	mov    %ecx,%eax
  801443:	eb 20                	jmp    801465 <memcmp+0x74>
		s1++, s2++;
  801445:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80144a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80144f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801454:	0f 95 c0             	setne  %al
  801457:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80145c:	84 c0                	test   %al,%al
  80145e:	75 b7                	jne    801417 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801460:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801465:	c9                   	leaveq 
  801466:	c3                   	retq   

0000000000801467 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801467:	55                   	push   %rbp
  801468:	48 89 e5             	mov    %rsp,%rbp
  80146b:	48 83 ec 28          	sub    $0x28,%rsp
  80146f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801473:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801476:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80147a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801482:	48 01 d0             	add    %rdx,%rax
  801485:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801489:	eb 13                	jmp    80149e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80148b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148f:	0f b6 10             	movzbl (%rax),%edx
  801492:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801495:	38 c2                	cmp    %al,%dl
  801497:	74 11                	je     8014aa <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801499:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80149e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014a6:	72 e3                	jb     80148b <memfind+0x24>
  8014a8:	eb 01                	jmp    8014ab <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014aa:	90                   	nop
	return (void *) s;
  8014ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014af:	c9                   	leaveq 
  8014b0:	c3                   	retq   

00000000008014b1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014b1:	55                   	push   %rbp
  8014b2:	48 89 e5             	mov    %rsp,%rbp
  8014b5:	48 83 ec 38          	sub    $0x38,%rsp
  8014b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014c1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014cb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014d2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d3:	eb 05                	jmp    8014da <strtol+0x29>
		s++;
  8014d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014de:	0f b6 00             	movzbl (%rax),%eax
  8014e1:	3c 20                	cmp    $0x20,%al
  8014e3:	74 f0                	je     8014d5 <strtol+0x24>
  8014e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e9:	0f b6 00             	movzbl (%rax),%eax
  8014ec:	3c 09                	cmp    $0x9,%al
  8014ee:	74 e5                	je     8014d5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f4:	0f b6 00             	movzbl (%rax),%eax
  8014f7:	3c 2b                	cmp    $0x2b,%al
  8014f9:	75 07                	jne    801502 <strtol+0x51>
		s++;
  8014fb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801500:	eb 17                	jmp    801519 <strtol+0x68>
	else if (*s == '-')
  801502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	3c 2d                	cmp    $0x2d,%al
  80150b:	75 0c                	jne    801519 <strtol+0x68>
		s++, neg = 1;
  80150d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801512:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801519:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80151d:	74 06                	je     801525 <strtol+0x74>
  80151f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801523:	75 28                	jne    80154d <strtol+0x9c>
  801525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	3c 30                	cmp    $0x30,%al
  80152e:	75 1d                	jne    80154d <strtol+0x9c>
  801530:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801534:	48 83 c0 01          	add    $0x1,%rax
  801538:	0f b6 00             	movzbl (%rax),%eax
  80153b:	3c 78                	cmp    $0x78,%al
  80153d:	75 0e                	jne    80154d <strtol+0x9c>
		s += 2, base = 16;
  80153f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801544:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80154b:	eb 2c                	jmp    801579 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80154d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801551:	75 19                	jne    80156c <strtol+0xbb>
  801553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801557:	0f b6 00             	movzbl (%rax),%eax
  80155a:	3c 30                	cmp    $0x30,%al
  80155c:	75 0e                	jne    80156c <strtol+0xbb>
		s++, base = 8;
  80155e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801563:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80156a:	eb 0d                	jmp    801579 <strtol+0xc8>
	else if (base == 0)
  80156c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801570:	75 07                	jne    801579 <strtol+0xc8>
		base = 10;
  801572:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	0f b6 00             	movzbl (%rax),%eax
  801580:	3c 2f                	cmp    $0x2f,%al
  801582:	7e 1d                	jle    8015a1 <strtol+0xf0>
  801584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	3c 39                	cmp    $0x39,%al
  80158d:	7f 12                	jg     8015a1 <strtol+0xf0>
			dig = *s - '0';
  80158f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801593:	0f b6 00             	movzbl (%rax),%eax
  801596:	0f be c0             	movsbl %al,%eax
  801599:	83 e8 30             	sub    $0x30,%eax
  80159c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80159f:	eb 4e                	jmp    8015ef <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a5:	0f b6 00             	movzbl (%rax),%eax
  8015a8:	3c 60                	cmp    $0x60,%al
  8015aa:	7e 1d                	jle    8015c9 <strtol+0x118>
  8015ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b0:	0f b6 00             	movzbl (%rax),%eax
  8015b3:	3c 7a                	cmp    $0x7a,%al
  8015b5:	7f 12                	jg     8015c9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bb:	0f b6 00             	movzbl (%rax),%eax
  8015be:	0f be c0             	movsbl %al,%eax
  8015c1:	83 e8 57             	sub    $0x57,%eax
  8015c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c7:	eb 26                	jmp    8015ef <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	0f b6 00             	movzbl (%rax),%eax
  8015d0:	3c 40                	cmp    $0x40,%al
  8015d2:	7e 47                	jle    80161b <strtol+0x16a>
  8015d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d8:	0f b6 00             	movzbl (%rax),%eax
  8015db:	3c 5a                	cmp    $0x5a,%al
  8015dd:	7f 3c                	jg     80161b <strtol+0x16a>
			dig = *s - 'A' + 10;
  8015df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	0f be c0             	movsbl %al,%eax
  8015e9:	83 e8 37             	sub    $0x37,%eax
  8015ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015f2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015f5:	7d 23                	jge    80161a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8015f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015ff:	48 98                	cltq   
  801601:	48 89 c2             	mov    %rax,%rdx
  801604:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801609:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80160c:	48 98                	cltq   
  80160e:	48 01 d0             	add    %rdx,%rax
  801611:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801615:	e9 5f ff ff ff       	jmpq   801579 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80161a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80161b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801620:	74 0b                	je     80162d <strtol+0x17c>
		*endptr = (char *) s;
  801622:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801626:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80162a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80162d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801631:	74 09                	je     80163c <strtol+0x18b>
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801637:	48 f7 d8             	neg    %rax
  80163a:	eb 04                	jmp    801640 <strtol+0x18f>
  80163c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801640:	c9                   	leaveq 
  801641:	c3                   	retq   

0000000000801642 <strstr>:

char * strstr(const char *in, const char *str)
{
  801642:	55                   	push   %rbp
  801643:	48 89 e5             	mov    %rsp,%rbp
  801646:	48 83 ec 30          	sub    $0x30,%rsp
  80164a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80164e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801652:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801656:	0f b6 00             	movzbl (%rax),%eax
  801659:	88 45 ff             	mov    %al,-0x1(%rbp)
  80165c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801661:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801665:	75 06                	jne    80166d <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	eb 68                	jmp    8016d5 <strstr+0x93>

	len = strlen(str);
  80166d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801671:	48 89 c7             	mov    %rax,%rdi
  801674:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  80167b:	00 00 00 
  80167e:	ff d0                	callq  *%rax
  801680:	48 98                	cltq   
  801682:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168a:	0f b6 00             	movzbl (%rax),%eax
  80168d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801690:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801695:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801699:	75 07                	jne    8016a2 <strstr+0x60>
				return (char *) 0;
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a0:	eb 33                	jmp    8016d5 <strstr+0x93>
		} while (sc != c);
  8016a2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016a6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016a9:	75 db                	jne    801686 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  8016ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016af:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	48 89 ce             	mov    %rcx,%rsi
  8016ba:	48 89 c7             	mov    %rax,%rdi
  8016bd:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  8016c4:	00 00 00 
  8016c7:	ff d0                	callq  *%rax
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	75 b9                	jne    801686 <strstr+0x44>

	return (char *) (in - 1);
  8016cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d1:	48 83 e8 01          	sub    $0x1,%rax
}
  8016d5:	c9                   	leaveq 
  8016d6:	c3                   	retq   
	...

00000000008016d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016d8:	55                   	push   %rbp
  8016d9:	48 89 e5             	mov    %rsp,%rbp
  8016dc:	53                   	push   %rbx
  8016dd:	48 83 ec 58          	sub    $0x58,%rsp
  8016e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016e4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016e7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016eb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016ef:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016f3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016fa:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8016fd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801701:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801705:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801709:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80170d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801711:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801714:	4c 89 c3             	mov    %r8,%rbx
  801717:	cd 30                	int    $0x30
  801719:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  80171d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801721:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801725:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801729:	74 3e                	je     801769 <syscall+0x91>
  80172b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801730:	7e 37                	jle    801769 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801732:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801736:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801739:	49 89 d0             	mov    %rdx,%r8
  80173c:	89 c1                	mov    %eax,%ecx
  80173e:	48 ba a8 47 80 00 00 	movabs $0x8047a8,%rdx
  801745:	00 00 00 
  801748:	be 23 00 00 00       	mov    $0x23,%esi
  80174d:	48 bf c5 47 80 00 00 	movabs $0x8047c5,%rdi
  801754:	00 00 00 
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	49 b9 a4 3e 80 00 00 	movabs $0x803ea4,%r9
  801763:	00 00 00 
  801766:	41 ff d1             	callq  *%r9

	return ret;
  801769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80176d:	48 83 c4 58          	add    $0x58,%rsp
  801771:	5b                   	pop    %rbx
  801772:	5d                   	pop    %rbp
  801773:	c3                   	retq   

0000000000801774 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801774:	55                   	push   %rbp
  801775:	48 89 e5             	mov    %rsp,%rbp
  801778:	48 83 ec 20          	sub    $0x20,%rsp
  80177c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801780:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801788:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801793:	00 
  801794:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017a0:	48 89 d1             	mov    %rdx,%rcx
  8017a3:	48 89 c2             	mov    %rax,%rdx
  8017a6:	be 00 00 00 00       	mov    $0x0,%esi
  8017ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8017b0:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8017b7:	00 00 00 
  8017ba:	ff d0                	callq  *%rax
}
  8017bc:	c9                   	leaveq 
  8017bd:	c3                   	retq   

00000000008017be <sys_cgetc>:

int
sys_cgetc(void)
{
  8017be:	55                   	push   %rbp
  8017bf:	48 89 e5             	mov    %rsp,%rbp
  8017c2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017cd:	00 
  8017ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017df:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e4:	be 00 00 00 00       	mov    $0x0,%esi
  8017e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8017ee:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8017f5:	00 00 00 
  8017f8:	ff d0                	callq  *%rax
}
  8017fa:	c9                   	leaveq 
  8017fb:	c3                   	retq   

00000000008017fc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017fc:	55                   	push   %rbp
  8017fd:	48 89 e5             	mov    %rsp,%rbp
  801800:	48 83 ec 20          	sub    $0x20,%rsp
  801804:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801807:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80180a:	48 98                	cltq   
  80180c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801813:	00 
  801814:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80181a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801820:	b9 00 00 00 00       	mov    $0x0,%ecx
  801825:	48 89 c2             	mov    %rax,%rdx
  801828:	be 01 00 00 00       	mov    $0x1,%esi
  80182d:	bf 03 00 00 00       	mov    $0x3,%edi
  801832:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801839:	00 00 00 
  80183c:	ff d0                	callq  *%rax
}
  80183e:	c9                   	leaveq 
  80183f:	c3                   	retq   

0000000000801840 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801840:	55                   	push   %rbp
  801841:	48 89 e5             	mov    %rsp,%rbp
  801844:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801848:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184f:	00 
  801850:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801856:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801861:	ba 00 00 00 00       	mov    $0x0,%edx
  801866:	be 00 00 00 00       	mov    $0x0,%esi
  80186b:	bf 02 00 00 00       	mov    $0x2,%edi
  801870:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801877:	00 00 00 
  80187a:	ff d0                	callq  *%rax
}
  80187c:	c9                   	leaveq 
  80187d:	c3                   	retq   

000000000080187e <sys_yield>:

void
sys_yield(void)
{
  80187e:	55                   	push   %rbp
  80187f:	48 89 e5             	mov    %rsp,%rbp
  801882:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801886:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80188d:	00 
  80188e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801894:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80189a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189f:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a4:	be 00 00 00 00       	mov    $0x0,%esi
  8018a9:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018ae:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8018b5:	00 00 00 
  8018b8:	ff d0                	callq  *%rax
}
  8018ba:	c9                   	leaveq 
  8018bb:	c3                   	retq   

00000000008018bc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018bc:	55                   	push   %rbp
  8018bd:	48 89 e5             	mov    %rsp,%rbp
  8018c0:	48 83 ec 20          	sub    $0x20,%rsp
  8018c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018cb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018d1:	48 63 c8             	movslq %eax,%rcx
  8018d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018db:	48 98                	cltq   
  8018dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e4:	00 
  8018e5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018eb:	49 89 c8             	mov    %rcx,%r8
  8018ee:	48 89 d1             	mov    %rdx,%rcx
  8018f1:	48 89 c2             	mov    %rax,%rdx
  8018f4:	be 01 00 00 00       	mov    $0x1,%esi
  8018f9:	bf 04 00 00 00       	mov    $0x4,%edi
  8018fe:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801905:	00 00 00 
  801908:	ff d0                	callq  *%rax
}
  80190a:	c9                   	leaveq 
  80190b:	c3                   	retq   

000000000080190c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80190c:	55                   	push   %rbp
  80190d:	48 89 e5             	mov    %rsp,%rbp
  801910:	48 83 ec 30          	sub    $0x30,%rsp
  801914:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801917:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80191b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80191e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801922:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801926:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801929:	48 63 c8             	movslq %eax,%rcx
  80192c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801930:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801933:	48 63 f0             	movslq %eax,%rsi
  801936:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193d:	48 98                	cltq   
  80193f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801943:	49 89 f9             	mov    %rdi,%r9
  801946:	49 89 f0             	mov    %rsi,%r8
  801949:	48 89 d1             	mov    %rdx,%rcx
  80194c:	48 89 c2             	mov    %rax,%rdx
  80194f:	be 01 00 00 00       	mov    $0x1,%esi
  801954:	bf 05 00 00 00       	mov    $0x5,%edi
  801959:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801960:	00 00 00 
  801963:	ff d0                	callq  *%rax
}
  801965:	c9                   	leaveq 
  801966:	c3                   	retq   

0000000000801967 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801967:	55                   	push   %rbp
  801968:	48 89 e5             	mov    %rsp,%rbp
  80196b:	48 83 ec 20          	sub    $0x20,%rsp
  80196f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801972:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801976:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197d:	48 98                	cltq   
  80197f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801986:	00 
  801987:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801993:	48 89 d1             	mov    %rdx,%rcx
  801996:	48 89 c2             	mov    %rax,%rdx
  801999:	be 01 00 00 00       	mov    $0x1,%esi
  80199e:	bf 06 00 00 00       	mov    $0x6,%edi
  8019a3:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8019aa:	00 00 00 
  8019ad:	ff d0                	callq  *%rax
}
  8019af:	c9                   	leaveq 
  8019b0:	c3                   	retq   

00000000008019b1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019b1:	55                   	push   %rbp
  8019b2:	48 89 e5             	mov    %rsp,%rbp
  8019b5:	48 83 ec 20          	sub    $0x20,%rsp
  8019b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019bc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c2:	48 63 d0             	movslq %eax,%rdx
  8019c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c8:	48 98                	cltq   
  8019ca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d1:	00 
  8019d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019de:	48 89 d1             	mov    %rdx,%rcx
  8019e1:	48 89 c2             	mov    %rax,%rdx
  8019e4:	be 01 00 00 00       	mov    $0x1,%esi
  8019e9:	bf 08 00 00 00       	mov    $0x8,%edi
  8019ee:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8019f5:	00 00 00 
  8019f8:	ff d0                	callq  *%rax
}
  8019fa:	c9                   	leaveq 
  8019fb:	c3                   	retq   

00000000008019fc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019fc:	55                   	push   %rbp
  8019fd:	48 89 e5             	mov    %rsp,%rbp
  801a00:	48 83 ec 20          	sub    $0x20,%rsp
  801a04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a12:	48 98                	cltq   
  801a14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1b:	00 
  801a1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a28:	48 89 d1             	mov    %rdx,%rcx
  801a2b:	48 89 c2             	mov    %rax,%rdx
  801a2e:	be 01 00 00 00       	mov    $0x1,%esi
  801a33:	bf 09 00 00 00       	mov    $0x9,%edi
  801a38:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801a3f:	00 00 00 
  801a42:	ff d0                	callq  *%rax
}
  801a44:	c9                   	leaveq 
  801a45:	c3                   	retq   

0000000000801a46 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a46:	55                   	push   %rbp
  801a47:	48 89 e5             	mov    %rsp,%rbp
  801a4a:	48 83 ec 20          	sub    $0x20,%rsp
  801a4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5c:	48 98                	cltq   
  801a5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a65:	00 
  801a66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a72:	48 89 d1             	mov    %rdx,%rcx
  801a75:	48 89 c2             	mov    %rax,%rdx
  801a78:	be 01 00 00 00       	mov    $0x1,%esi
  801a7d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a82:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801a89:	00 00 00 
  801a8c:	ff d0                	callq  *%rax
}
  801a8e:	c9                   	leaveq 
  801a8f:	c3                   	retq   

0000000000801a90 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a90:	55                   	push   %rbp
  801a91:	48 89 e5             	mov    %rsp,%rbp
  801a94:	48 83 ec 30          	sub    $0x30,%rsp
  801a98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a9f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801aa3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801aa6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa9:	48 63 f0             	movslq %eax,%rsi
  801aac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab3:	48 98                	cltq   
  801ab5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac0:	00 
  801ac1:	49 89 f1             	mov    %rsi,%r9
  801ac4:	49 89 c8             	mov    %rcx,%r8
  801ac7:	48 89 d1             	mov    %rdx,%rcx
  801aca:	48 89 c2             	mov    %rax,%rdx
  801acd:	be 00 00 00 00       	mov    $0x0,%esi
  801ad2:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ad7:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801ade:	00 00 00 
  801ae1:	ff d0                	callq  *%rax
}
  801ae3:	c9                   	leaveq 
  801ae4:	c3                   	retq   

0000000000801ae5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ae5:	55                   	push   %rbp
  801ae6:	48 89 e5             	mov    %rsp,%rbp
  801ae9:	48 83 ec 20          	sub    $0x20,%rsp
  801aed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801af1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afc:	00 
  801afd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b09:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b0e:	48 89 c2             	mov    %rax,%rdx
  801b11:	be 01 00 00 00       	mov    $0x1,%esi
  801b16:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b1b:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801b22:	00 00 00 
  801b25:	ff d0                	callq  *%rax
}
  801b27:	c9                   	leaveq 
  801b28:	c3                   	retq   

0000000000801b29 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801b29:	55                   	push   %rbp
  801b2a:	48 89 e5             	mov    %rsp,%rbp
  801b2d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b38:	00 
  801b39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4f:	be 00 00 00 00       	mov    $0x0,%esi
  801b54:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b59:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	callq  *%rax
}
  801b65:	c9                   	leaveq 
  801b66:	c3                   	retq   

0000000000801b67 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801b67:	55                   	push   %rbp
  801b68:	48 89 e5             	mov    %rsp,%rbp
  801b6b:	48 83 ec 30          	sub    $0x30,%rsp
  801b6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b76:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b79:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b7d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801b81:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b84:	48 63 c8             	movslq %eax,%rcx
  801b87:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b8e:	48 63 f0             	movslq %eax,%rsi
  801b91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b98:	48 98                	cltq   
  801b9a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b9e:	49 89 f9             	mov    %rdi,%r9
  801ba1:	49 89 f0             	mov    %rsi,%r8
  801ba4:	48 89 d1             	mov    %rdx,%rcx
  801ba7:	48 89 c2             	mov    %rax,%rdx
  801baa:	be 00 00 00 00       	mov    $0x0,%esi
  801baf:	bf 0f 00 00 00       	mov    $0xf,%edi
  801bb4:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801bbb:	00 00 00 
  801bbe:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801bc0:	c9                   	leaveq 
  801bc1:	c3                   	retq   

0000000000801bc2 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801bc2:	55                   	push   %rbp
  801bc3:	48 89 e5             	mov    %rsp,%rbp
  801bc6:	48 83 ec 20          	sub    $0x20,%rsp
  801bca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801bd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bda:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be1:	00 
  801be2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bee:	48 89 d1             	mov    %rdx,%rcx
  801bf1:	48 89 c2             	mov    %rax,%rdx
  801bf4:	be 00 00 00 00       	mov    $0x0,%esi
  801bf9:	bf 10 00 00 00       	mov    $0x10,%edi
  801bfe:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
}
  801c0a:	c9                   	leaveq 
  801c0b:	c3                   	retq   

0000000000801c0c <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801c0c:	55                   	push   %rbp
  801c0d:	48 89 e5             	mov    %rsp,%rbp
  801c10:	48 83 ec 18          	sub    $0x18,%rsp
  801c14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c1c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c28:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801c2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c33:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801c37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c3b:	8b 00                	mov    (%rax),%eax
  801c3d:	83 f8 01             	cmp    $0x1,%eax
  801c40:	7e 13                	jle    801c55 <argstart+0x49>
  801c42:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801c47:	74 0c                	je     801c55 <argstart+0x49>
  801c49:	48 b8 d3 47 80 00 00 	movabs $0x8047d3,%rax
  801c50:	00 00 00 
  801c53:	eb 05                	jmp    801c5a <argstart+0x4e>
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c5e:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c66:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c6d:	00 
}
  801c6e:	c9                   	leaveq 
  801c6f:	c3                   	retq   

0000000000801c70 <argnext>:

int
argnext(struct Argstate *args)
{
  801c70:	55                   	push   %rbp
  801c71:	48 89 e5             	mov    %rsp,%rbp
  801c74:	48 83 ec 20          	sub    $0x20,%rsp
  801c78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801c7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c80:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c87:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8c:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c90:	48 85 c0             	test   %rax,%rax
  801c93:	75 0a                	jne    801c9f <argnext+0x2f>
		return -1;
  801c95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c9a:	e9 24 01 00 00       	jmpq   801dc3 <argnext+0x153>

	if (!*args->curarg) {
  801c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca3:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ca7:	0f b6 00             	movzbl (%rax),%eax
  801caa:	84 c0                	test   %al,%al
  801cac:	0f 85 d5 00 00 00    	jne    801d87 <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801cb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb6:	48 8b 00             	mov    (%rax),%rax
  801cb9:	8b 00                	mov    (%rax),%eax
  801cbb:	83 f8 01             	cmp    $0x1,%eax
  801cbe:	0f 84 ee 00 00 00    	je     801db2 <argnext+0x142>
		    || args->argv[1][0] != '-'
  801cc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc8:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ccc:	48 83 c0 08          	add    $0x8,%rax
  801cd0:	48 8b 00             	mov    (%rax),%rax
  801cd3:	0f b6 00             	movzbl (%rax),%eax
  801cd6:	3c 2d                	cmp    $0x2d,%al
  801cd8:	0f 85 d4 00 00 00    	jne    801db2 <argnext+0x142>
		    || args->argv[1][1] == '\0')
  801cde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce2:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ce6:	48 83 c0 08          	add    $0x8,%rax
  801cea:	48 8b 00             	mov    (%rax),%rax
  801ced:	48 83 c0 01          	add    $0x1,%rax
  801cf1:	0f b6 00             	movzbl (%rax),%eax
  801cf4:	84 c0                	test   %al,%al
  801cf6:	0f 84 b6 00 00 00    	je     801db2 <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801cfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d00:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d04:	48 83 c0 08          	add    $0x8,%rax
  801d08:	48 8b 00             	mov    (%rax),%rax
  801d0b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d13:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d1b:	48 8b 00             	mov    (%rax),%rax
  801d1e:	8b 00                	mov    (%rax),%eax
  801d20:	83 e8 01             	sub    $0x1,%eax
  801d23:	48 98                	cltq   
  801d25:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801d2c:	00 
  801d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d31:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d35:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d41:	48 83 c0 08          	add    $0x8,%rax
  801d45:	48 89 ce             	mov    %rcx,%rsi
  801d48:	48 89 c7             	mov    %rax,%rdi
  801d4b:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  801d52:	00 00 00 
  801d55:	ff d0                	callq  *%rax
		(*args->argc)--;
  801d57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d5b:	48 8b 00             	mov    (%rax),%rax
  801d5e:	8b 10                	mov    (%rax),%edx
  801d60:	83 ea 01             	sub    $0x1,%edx
  801d63:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801d65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d69:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d6d:	0f b6 00             	movzbl (%rax),%eax
  801d70:	3c 2d                	cmp    $0x2d,%al
  801d72:	75 13                	jne    801d87 <argnext+0x117>
  801d74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d78:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d7c:	48 83 c0 01          	add    $0x1,%rax
  801d80:	0f b6 00             	movzbl (%rax),%eax
  801d83:	84 c0                	test   %al,%al
  801d85:	74 2a                	je     801db1 <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d8b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d8f:	0f b6 00             	movzbl (%rax),%eax
  801d92:	0f b6 c0             	movzbl %al,%eax
  801d95:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801d98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d9c:	48 8b 40 10          	mov    0x10(%rax),%rax
  801da0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801da4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801dac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801daf:	eb 12                	jmp    801dc3 <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  801db1:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

endofargs:
	args->curarg = 0;
  801db2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db6:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801dbd:	00 
	return -1;
  801dbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801dc3:	c9                   	leaveq 
  801dc4:	c3                   	retq   

0000000000801dc5 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801dc5:	55                   	push   %rbp
  801dc6:	48 89 e5             	mov    %rsp,%rbp
  801dc9:	48 83 ec 10          	sub    $0x10,%rsp
  801dcd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801dd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd5:	48 8b 40 18          	mov    0x18(%rax),%rax
  801dd9:	48 85 c0             	test   %rax,%rax
  801ddc:	74 0a                	je     801de8 <argvalue+0x23>
  801dde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de2:	48 8b 40 18          	mov    0x18(%rax),%rax
  801de6:	eb 13                	jmp    801dfb <argvalue+0x36>
  801de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dec:	48 89 c7             	mov    %rax,%rdi
  801def:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	callq  *%rax
}
  801dfb:	c9                   	leaveq 
  801dfc:	c3                   	retq   

0000000000801dfd <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	48 83 ec 10          	sub    $0x10,%rsp
  801e05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  801e09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0d:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e11:	48 85 c0             	test   %rax,%rax
  801e14:	75 0a                	jne    801e20 <argnextvalue+0x23>
		return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1b:	e9 c8 00 00 00       	jmpq   801ee8 <argnextvalue+0xeb>
	if (*args->curarg) {
  801e20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e24:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e28:	0f b6 00             	movzbl (%rax),%eax
  801e2b:	84 c0                	test   %al,%al
  801e2d:	74 27                	je     801e56 <argnextvalue+0x59>
		args->argvalue = args->curarg;
  801e2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e33:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801e37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e3b:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801e3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e43:	48 ba d3 47 80 00 00 	movabs $0x8047d3,%rdx
  801e4a:	00 00 00 
  801e4d:	48 89 50 10          	mov    %rdx,0x10(%rax)
  801e51:	e9 8a 00 00 00       	jmpq   801ee0 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  801e56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5a:	48 8b 00             	mov    (%rax),%rax
  801e5d:	8b 00                	mov    (%rax),%eax
  801e5f:	83 f8 01             	cmp    $0x1,%eax
  801e62:	7e 64                	jle    801ec8 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  801e64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e68:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e6c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801e70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e74:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7c:	48 8b 00             	mov    (%rax),%rax
  801e7f:	8b 00                	mov    (%rax),%eax
  801e81:	83 e8 01             	sub    $0x1,%eax
  801e84:	48 98                	cltq   
  801e86:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801e8d:	00 
  801e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e92:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e96:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801e9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e9e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ea2:	48 83 c0 08          	add    $0x8,%rax
  801ea6:	48 89 ce             	mov    %rcx,%rsi
  801ea9:	48 89 c7             	mov    %rax,%rdi
  801eac:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  801eb3:	00 00 00 
  801eb6:	ff d0                	callq  *%rax
		(*args->argc)--;
  801eb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ebc:	48 8b 00             	mov    (%rax),%rax
  801ebf:	8b 10                	mov    (%rax),%edx
  801ec1:	83 ea 01             	sub    $0x1,%edx
  801ec4:	89 10                	mov    %edx,(%rax)
  801ec6:	eb 18                	jmp    801ee0 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  801ec8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecc:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801ed3:	00 
		args->curarg = 0;
  801ed4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed8:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801edf:	00 
	}
	return (char*) args->argvalue;
  801ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee4:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801ee8:	c9                   	leaveq 
  801ee9:	c3                   	retq   
	...

0000000000801eec <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801eec:	55                   	push   %rbp
  801eed:	48 89 e5             	mov    %rsp,%rbp
  801ef0:	48 83 ec 08          	sub    $0x8,%rsp
  801ef4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ef8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801efc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f03:	ff ff ff 
  801f06:	48 01 d0             	add    %rdx,%rax
  801f09:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f0d:	c9                   	leaveq 
  801f0e:	c3                   	retq   

0000000000801f0f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f0f:	55                   	push   %rbp
  801f10:	48 89 e5             	mov    %rsp,%rbp
  801f13:	48 83 ec 08          	sub    $0x8,%rsp
  801f17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1f:	48 89 c7             	mov    %rax,%rdi
  801f22:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  801f29:	00 00 00 
  801f2c:	ff d0                	callq  *%rax
  801f2e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f34:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f38:	c9                   	leaveq 
  801f39:	c3                   	retq   

0000000000801f3a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f3a:	55                   	push   %rbp
  801f3b:	48 89 e5             	mov    %rsp,%rbp
  801f3e:	48 83 ec 18          	sub    $0x18,%rsp
  801f42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f4d:	eb 6b                	jmp    801fba <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f52:	48 98                	cltq   
  801f54:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f5a:	48 c1 e0 0c          	shl    $0xc,%rax
  801f5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f66:	48 89 c2             	mov    %rax,%rdx
  801f69:	48 c1 ea 15          	shr    $0x15,%rdx
  801f6d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f74:	01 00 00 
  801f77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7b:	83 e0 01             	and    $0x1,%eax
  801f7e:	48 85 c0             	test   %rax,%rax
  801f81:	74 21                	je     801fa4 <fd_alloc+0x6a>
  801f83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f87:	48 89 c2             	mov    %rax,%rdx
  801f8a:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f8e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f95:	01 00 00 
  801f98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9c:	83 e0 01             	and    $0x1,%eax
  801f9f:	48 85 c0             	test   %rax,%rax
  801fa2:	75 12                	jne    801fb6 <fd_alloc+0x7c>
			*fd_store = fd;
  801fa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fac:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	eb 1a                	jmp    801fd0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fb6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fba:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fbe:	7e 8f                	jle    801f4f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801fcb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801fd0:	c9                   	leaveq 
  801fd1:	c3                   	retq   

0000000000801fd2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fd2:	55                   	push   %rbp
  801fd3:	48 89 e5             	mov    %rsp,%rbp
  801fd6:	48 83 ec 20          	sub    $0x20,%rsp
  801fda:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fdd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fe1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fe5:	78 06                	js     801fed <fd_lookup+0x1b>
  801fe7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801feb:	7e 07                	jle    801ff4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ff2:	eb 6c                	jmp    802060 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ff4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff7:	48 98                	cltq   
  801ff9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fff:	48 c1 e0 0c          	shl    $0xc,%rax
  802003:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802007:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80200b:	48 89 c2             	mov    %rax,%rdx
  80200e:	48 c1 ea 15          	shr    $0x15,%rdx
  802012:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802019:	01 00 00 
  80201c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802020:	83 e0 01             	and    $0x1,%eax
  802023:	48 85 c0             	test   %rax,%rax
  802026:	74 21                	je     802049 <fd_lookup+0x77>
  802028:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80202c:	48 89 c2             	mov    %rax,%rdx
  80202f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802033:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80203a:	01 00 00 
  80203d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802041:	83 e0 01             	and    $0x1,%eax
  802044:	48 85 c0             	test   %rax,%rax
  802047:	75 07                	jne    802050 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802049:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80204e:	eb 10                	jmp    802060 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802050:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802054:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802058:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802060:	c9                   	leaveq 
  802061:	c3                   	retq   

0000000000802062 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802062:	55                   	push   %rbp
  802063:	48 89 e5             	mov    %rsp,%rbp
  802066:	48 83 ec 30          	sub    $0x30,%rsp
  80206a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80206e:	89 f0                	mov    %esi,%eax
  802070:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802073:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802077:	48 89 c7             	mov    %rax,%rdi
  80207a:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  802081:	00 00 00 
  802084:	ff d0                	callq  *%rax
  802086:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80208a:	48 89 d6             	mov    %rdx,%rsi
  80208d:	89 c7                	mov    %eax,%edi
  80208f:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802096:	00 00 00 
  802099:	ff d0                	callq  *%rax
  80209b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80209e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a2:	78 0a                	js     8020ae <fd_close+0x4c>
	    || fd != fd2)
  8020a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020ac:	74 12                	je     8020c0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8020ae:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020b2:	74 05                	je     8020b9 <fd_close+0x57>
  8020b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b7:	eb 05                	jmp    8020be <fd_close+0x5c>
  8020b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020be:	eb 69                	jmp    802129 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c4:	8b 00                	mov    (%rax),%eax
  8020c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020ca:	48 89 d6             	mov    %rdx,%rsi
  8020cd:	89 c7                	mov    %eax,%edi
  8020cf:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	callq  *%rax
  8020db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e2:	78 2a                	js     80210e <fd_close+0xac>
		if (dev->dev_close)
  8020e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020ec:	48 85 c0             	test   %rax,%rax
  8020ef:	74 16                	je     802107 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8020f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8020f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020fd:	48 89 c7             	mov    %rax,%rdi
  802100:	ff d2                	callq  *%rdx
  802102:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802105:	eb 07                	jmp    80210e <fd_close+0xac>
		else
			r = 0;
  802107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80210e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802112:	48 89 c6             	mov    %rax,%rsi
  802115:	bf 00 00 00 00       	mov    $0x0,%edi
  80211a:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  802121:	00 00 00 
  802124:	ff d0                	callq  *%rax
	return r;
  802126:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802129:	c9                   	leaveq 
  80212a:	c3                   	retq   

000000000080212b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	48 83 ec 20          	sub    $0x20,%rsp
  802133:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802136:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80213a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802141:	eb 41                	jmp    802184 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802143:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80214a:	00 00 00 
  80214d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802150:	48 63 d2             	movslq %edx,%rdx
  802153:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802157:	8b 00                	mov    (%rax),%eax
  802159:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80215c:	75 22                	jne    802180 <dev_lookup+0x55>
			*dev = devtab[i];
  80215e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802165:	00 00 00 
  802168:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80216b:	48 63 d2             	movslq %edx,%rdx
  80216e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802172:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802176:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
  80217e:	eb 60                	jmp    8021e0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802180:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802184:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80218b:	00 00 00 
  80218e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802191:	48 63 d2             	movslq %edx,%rdx
  802194:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802198:	48 85 c0             	test   %rax,%rax
  80219b:	75 a6                	jne    802143 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80219d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021a4:	00 00 00 
  8021a7:	48 8b 00             	mov    (%rax),%rax
  8021aa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021b3:	89 c6                	mov    %eax,%esi
  8021b5:	48 bf d8 47 80 00 00 	movabs $0x8047d8,%rdi
  8021bc:	00 00 00 
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c4:	48 b9 b3 03 80 00 00 	movabs $0x8003b3,%rcx
  8021cb:	00 00 00 
  8021ce:	ff d1                	callq  *%rcx
	*dev = 0;
  8021d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021d4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8021db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021e0:	c9                   	leaveq 
  8021e1:	c3                   	retq   

00000000008021e2 <close>:

int
close(int fdnum)
{
  8021e2:	55                   	push   %rbp
  8021e3:	48 89 e5             	mov    %rsp,%rbp
  8021e6:	48 83 ec 20          	sub    $0x20,%rsp
  8021ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021f4:	48 89 d6             	mov    %rdx,%rsi
  8021f7:	89 c7                	mov    %eax,%edi
  8021f9:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802200:	00 00 00 
  802203:	ff d0                	callq  *%rax
  802205:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802208:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80220c:	79 05                	jns    802213 <close+0x31>
		return r;
  80220e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802211:	eb 18                	jmp    80222b <close+0x49>
	else
		return fd_close(fd, 1);
  802213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802217:	be 01 00 00 00       	mov    $0x1,%esi
  80221c:	48 89 c7             	mov    %rax,%rdi
  80221f:	48 b8 62 20 80 00 00 	movabs $0x802062,%rax
  802226:	00 00 00 
  802229:	ff d0                	callq  *%rax
}
  80222b:	c9                   	leaveq 
  80222c:	c3                   	retq   

000000000080222d <close_all>:

void
close_all(void)
{
  80222d:	55                   	push   %rbp
  80222e:	48 89 e5             	mov    %rsp,%rbp
  802231:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80223c:	eb 15                	jmp    802253 <close_all+0x26>
		close(i);
  80223e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802241:	89 c7                	mov    %eax,%edi
  802243:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  80224a:	00 00 00 
  80224d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80224f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802253:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802257:	7e e5                	jle    80223e <close_all+0x11>
		close(i);
}
  802259:	c9                   	leaveq 
  80225a:	c3                   	retq   

000000000080225b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80225b:	55                   	push   %rbp
  80225c:	48 89 e5             	mov    %rsp,%rbp
  80225f:	48 83 ec 40          	sub    $0x40,%rsp
  802263:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802266:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802269:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80226d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802270:	48 89 d6             	mov    %rdx,%rsi
  802273:	89 c7                	mov    %eax,%edi
  802275:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  80227c:	00 00 00 
  80227f:	ff d0                	callq  *%rax
  802281:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802284:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802288:	79 08                	jns    802292 <dup+0x37>
		return r;
  80228a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228d:	e9 70 01 00 00       	jmpq   802402 <dup+0x1a7>
	close(newfdnum);
  802292:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802295:	89 c7                	mov    %eax,%edi
  802297:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8022a3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a6:	48 98                	cltq   
  8022a8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022ae:	48 c1 e0 0c          	shl    $0xc,%rax
  8022b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ba:	48 89 c7             	mov    %rax,%rdi
  8022bd:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  8022c4:	00 00 00 
  8022c7:	ff d0                	callq  *%rax
  8022c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d1:	48 89 c7             	mov    %rax,%rdi
  8022d4:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  8022db:	00 00 00 
  8022de:	ff d0                	callq  *%rax
  8022e0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8022e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e8:	48 89 c2             	mov    %rax,%rdx
  8022eb:	48 c1 ea 15          	shr    $0x15,%rdx
  8022ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022f6:	01 00 00 
  8022f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022fd:	83 e0 01             	and    $0x1,%eax
  802300:	84 c0                	test   %al,%al
  802302:	74 71                	je     802375 <dup+0x11a>
  802304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802308:	48 89 c2             	mov    %rax,%rdx
  80230b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80230f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802316:	01 00 00 
  802319:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231d:	83 e0 01             	and    $0x1,%eax
  802320:	84 c0                	test   %al,%al
  802322:	74 51                	je     802375 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802328:	48 89 c2             	mov    %rax,%rdx
  80232b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80232f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802336:	01 00 00 
  802339:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233d:	89 c1                	mov    %eax,%ecx
  80233f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802345:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234d:	41 89 c8             	mov    %ecx,%r8d
  802350:	48 89 d1             	mov    %rdx,%rcx
  802353:	ba 00 00 00 00       	mov    $0x0,%edx
  802358:	48 89 c6             	mov    %rax,%rsi
  80235b:	bf 00 00 00 00       	mov    $0x0,%edi
  802360:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  802367:	00 00 00 
  80236a:	ff d0                	callq  *%rax
  80236c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802373:	78 56                	js     8023cb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802379:	48 89 c2             	mov    %rax,%rdx
  80237c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802380:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802387:	01 00 00 
  80238a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238e:	89 c1                	mov    %eax,%ecx
  802390:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80239a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80239e:	41 89 c8             	mov    %ecx,%r8d
  8023a1:	48 89 d1             	mov    %rdx,%rcx
  8023a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a9:	48 89 c6             	mov    %rax,%rsi
  8023ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b1:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  8023b8:	00 00 00 
  8023bb:	ff d0                	callq  *%rax
  8023bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c4:	78 08                	js     8023ce <dup+0x173>
		goto err;

	return newfdnum;
  8023c6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023c9:	eb 37                	jmp    802402 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8023cb:	90                   	nop
  8023cc:	eb 01                	jmp    8023cf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8023ce:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8023cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d3:	48 89 c6             	mov    %rax,%rsi
  8023d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023db:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023eb:	48 89 c6             	mov    %rax,%rsi
  8023ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f3:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  8023fa:	00 00 00 
  8023fd:	ff d0                	callq  *%rax
	return r;
  8023ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802402:	c9                   	leaveq 
  802403:	c3                   	retq   

0000000000802404 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802404:	55                   	push   %rbp
  802405:	48 89 e5             	mov    %rsp,%rbp
  802408:	48 83 ec 40          	sub    $0x40,%rsp
  80240c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80240f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802413:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802417:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80241b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80241e:	48 89 d6             	mov    %rdx,%rsi
  802421:	89 c7                	mov    %eax,%edi
  802423:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  80242a:	00 00 00 
  80242d:	ff d0                	callq  *%rax
  80242f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802432:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802436:	78 24                	js     80245c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802438:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243c:	8b 00                	mov    (%rax),%eax
  80243e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802442:	48 89 d6             	mov    %rdx,%rsi
  802445:	89 c7                	mov    %eax,%edi
  802447:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  80244e:	00 00 00 
  802451:	ff d0                	callq  *%rax
  802453:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802456:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245a:	79 05                	jns    802461 <read+0x5d>
		return r;
  80245c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245f:	eb 7a                	jmp    8024db <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802465:	8b 40 08             	mov    0x8(%rax),%eax
  802468:	83 e0 03             	and    $0x3,%eax
  80246b:	83 f8 01             	cmp    $0x1,%eax
  80246e:	75 3a                	jne    8024aa <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802470:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802477:	00 00 00 
  80247a:	48 8b 00             	mov    (%rax),%rax
  80247d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802483:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802486:	89 c6                	mov    %eax,%esi
  802488:	48 bf f7 47 80 00 00 	movabs $0x8047f7,%rdi
  80248f:	00 00 00 
  802492:	b8 00 00 00 00       	mov    $0x0,%eax
  802497:	48 b9 b3 03 80 00 00 	movabs $0x8003b3,%rcx
  80249e:	00 00 00 
  8024a1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024a8:	eb 31                	jmp    8024db <read+0xd7>
	}
	if (!dev->dev_read)
  8024aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ae:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024b2:	48 85 c0             	test   %rax,%rax
  8024b5:	75 07                	jne    8024be <read+0xba>
		return -E_NOT_SUPP;
  8024b7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024bc:	eb 1d                	jmp    8024db <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8024be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8024c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024ce:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024d2:	48 89 ce             	mov    %rcx,%rsi
  8024d5:	48 89 c7             	mov    %rax,%rdi
  8024d8:	41 ff d0             	callq  *%r8
}
  8024db:	c9                   	leaveq 
  8024dc:	c3                   	retq   

00000000008024dd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024dd:	55                   	push   %rbp
  8024de:	48 89 e5             	mov    %rsp,%rbp
  8024e1:	48 83 ec 30          	sub    $0x30,%rsp
  8024e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024f7:	eb 46                	jmp    80253f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fc:	48 98                	cltq   
  8024fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802502:	48 29 c2             	sub    %rax,%rdx
  802505:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802508:	48 98                	cltq   
  80250a:	48 89 c1             	mov    %rax,%rcx
  80250d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802511:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802514:	48 89 ce             	mov    %rcx,%rsi
  802517:	89 c7                	mov    %eax,%edi
  802519:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  802520:	00 00 00 
  802523:	ff d0                	callq  *%rax
  802525:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802528:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80252c:	79 05                	jns    802533 <readn+0x56>
			return m;
  80252e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802531:	eb 1d                	jmp    802550 <readn+0x73>
		if (m == 0)
  802533:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802537:	74 13                	je     80254c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802539:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80253c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80253f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802542:	48 98                	cltq   
  802544:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802548:	72 af                	jb     8024f9 <readn+0x1c>
  80254a:	eb 01                	jmp    80254d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80254c:	90                   	nop
	}
	return tot;
  80254d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802550:	c9                   	leaveq 
  802551:	c3                   	retq   

0000000000802552 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802552:	55                   	push   %rbp
  802553:	48 89 e5             	mov    %rsp,%rbp
  802556:	48 83 ec 40          	sub    $0x40,%rsp
  80255a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80255d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802561:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802565:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802569:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80256c:	48 89 d6             	mov    %rdx,%rsi
  80256f:	89 c7                	mov    %eax,%edi
  802571:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax
  80257d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802584:	78 24                	js     8025aa <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258a:	8b 00                	mov    (%rax),%eax
  80258c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802590:	48 89 d6             	mov    %rdx,%rsi
  802593:	89 c7                	mov    %eax,%edi
  802595:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  80259c:	00 00 00 
  80259f:	ff d0                	callq  *%rax
  8025a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a8:	79 05                	jns    8025af <write+0x5d>
		return r;
  8025aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ad:	eb 79                	jmp    802628 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b3:	8b 40 08             	mov    0x8(%rax),%eax
  8025b6:	83 e0 03             	and    $0x3,%eax
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	75 3a                	jne    8025f7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025c4:	00 00 00 
  8025c7:	48 8b 00             	mov    (%rax),%rax
  8025ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025d3:	89 c6                	mov    %eax,%esi
  8025d5:	48 bf 13 48 80 00 00 	movabs $0x804813,%rdi
  8025dc:	00 00 00 
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e4:	48 b9 b3 03 80 00 00 	movabs $0x8003b3,%rcx
  8025eb:	00 00 00 
  8025ee:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025f5:	eb 31                	jmp    802628 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025ff:	48 85 c0             	test   %rax,%rax
  802602:	75 07                	jne    80260b <write+0xb9>
		return -E_NOT_SUPP;
  802604:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802609:	eb 1d                	jmp    802628 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80260b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802617:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80261b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80261f:	48 89 ce             	mov    %rcx,%rsi
  802622:	48 89 c7             	mov    %rax,%rdi
  802625:	41 ff d0             	callq  *%r8
}
  802628:	c9                   	leaveq 
  802629:	c3                   	retq   

000000000080262a <seek>:

int
seek(int fdnum, off_t offset)
{
  80262a:	55                   	push   %rbp
  80262b:	48 89 e5             	mov    %rsp,%rbp
  80262e:	48 83 ec 18          	sub    $0x18,%rsp
  802632:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802635:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802638:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80263c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80263f:	48 89 d6             	mov    %rdx,%rsi
  802642:	89 c7                	mov    %eax,%edi
  802644:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  80264b:	00 00 00 
  80264e:	ff d0                	callq  *%rax
  802650:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802653:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802657:	79 05                	jns    80265e <seek+0x34>
		return r;
  802659:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265c:	eb 0f                	jmp    80266d <seek+0x43>
	fd->fd_offset = offset;
  80265e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802662:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802665:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802668:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266d:	c9                   	leaveq 
  80266e:	c3                   	retq   

000000000080266f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80266f:	55                   	push   %rbp
  802670:	48 89 e5             	mov    %rsp,%rbp
  802673:	48 83 ec 30          	sub    $0x30,%rsp
  802677:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80267a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80267d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802681:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802684:	48 89 d6             	mov    %rdx,%rsi
  802687:	89 c7                	mov    %eax,%edi
  802689:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802690:	00 00 00 
  802693:	ff d0                	callq  *%rax
  802695:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802698:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269c:	78 24                	js     8026c2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80269e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a2:	8b 00                	mov    (%rax),%eax
  8026a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a8:	48 89 d6             	mov    %rdx,%rsi
  8026ab:	89 c7                	mov    %eax,%edi
  8026ad:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	callq  *%rax
  8026b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c0:	79 05                	jns    8026c7 <ftruncate+0x58>
		return r;
  8026c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c5:	eb 72                	jmp    802739 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026cb:	8b 40 08             	mov    0x8(%rax),%eax
  8026ce:	83 e0 03             	and    $0x3,%eax
  8026d1:	85 c0                	test   %eax,%eax
  8026d3:	75 3a                	jne    80270f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8026d5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026dc:	00 00 00 
  8026df:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026eb:	89 c6                	mov    %eax,%esi
  8026ed:	48 bf 30 48 80 00 00 	movabs $0x804830,%rdi
  8026f4:	00 00 00 
  8026f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fc:	48 b9 b3 03 80 00 00 	movabs $0x8003b3,%rcx
  802703:	00 00 00 
  802706:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802708:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80270d:	eb 2a                	jmp    802739 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80270f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802713:	48 8b 40 30          	mov    0x30(%rax),%rax
  802717:	48 85 c0             	test   %rax,%rax
  80271a:	75 07                	jne    802723 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80271c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802721:	eb 16                	jmp    802739 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802723:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802727:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80272b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80272f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802732:	89 d6                	mov    %edx,%esi
  802734:	48 89 c7             	mov    %rax,%rdi
  802737:	ff d1                	callq  *%rcx
}
  802739:	c9                   	leaveq 
  80273a:	c3                   	retq   

000000000080273b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80273b:	55                   	push   %rbp
  80273c:	48 89 e5             	mov    %rsp,%rbp
  80273f:	48 83 ec 30          	sub    $0x30,%rsp
  802743:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802746:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80274a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80274e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802751:	48 89 d6             	mov    %rdx,%rsi
  802754:	89 c7                	mov    %eax,%edi
  802756:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  80275d:	00 00 00 
  802760:	ff d0                	callq  *%rax
  802762:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802765:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802769:	78 24                	js     80278f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80276b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276f:	8b 00                	mov    (%rax),%eax
  802771:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802775:	48 89 d6             	mov    %rdx,%rsi
  802778:	89 c7                	mov    %eax,%edi
  80277a:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  802781:	00 00 00 
  802784:	ff d0                	callq  *%rax
  802786:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802789:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278d:	79 05                	jns    802794 <fstat+0x59>
		return r;
  80278f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802792:	eb 5e                	jmp    8027f2 <fstat+0xb7>
	if (!dev->dev_stat)
  802794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802798:	48 8b 40 28          	mov    0x28(%rax),%rax
  80279c:	48 85 c0             	test   %rax,%rax
  80279f:	75 07                	jne    8027a8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8027a1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027a6:	eb 4a                	jmp    8027f2 <fstat+0xb7>
	stat->st_name[0] = 0;
  8027a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ac:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8027af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027b3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8027ba:	00 00 00 
	stat->st_isdir = 0;
  8027bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027c1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027c8:	00 00 00 
	stat->st_dev = dev;
  8027cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027d3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8027da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027de:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8027e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8027ea:	48 89 d6             	mov    %rdx,%rsi
  8027ed:	48 89 c7             	mov    %rax,%rdi
  8027f0:	ff d1                	callq  *%rcx
}
  8027f2:	c9                   	leaveq 
  8027f3:	c3                   	retq   

00000000008027f4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027f4:	55                   	push   %rbp
  8027f5:	48 89 e5             	mov    %rsp,%rbp
  8027f8:	48 83 ec 20          	sub    $0x20,%rsp
  8027fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802800:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802808:	be 00 00 00 00       	mov    $0x0,%esi
  80280d:	48 89 c7             	mov    %rax,%rdi
  802810:	48 b8 e3 28 80 00 00 	movabs $0x8028e3,%rax
  802817:	00 00 00 
  80281a:	ff d0                	callq  *%rax
  80281c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802823:	79 05                	jns    80282a <stat+0x36>
		return fd;
  802825:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802828:	eb 2f                	jmp    802859 <stat+0x65>
	r = fstat(fd, stat);
  80282a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80282e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802831:	48 89 d6             	mov    %rdx,%rsi
  802834:	89 c7                	mov    %eax,%edi
  802836:	48 b8 3b 27 80 00 00 	movabs $0x80273b,%rax
  80283d:	00 00 00 
  802840:	ff d0                	callq  *%rax
  802842:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802848:	89 c7                	mov    %eax,%edi
  80284a:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  802851:	00 00 00 
  802854:	ff d0                	callq  *%rax
	return r;
  802856:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802859:	c9                   	leaveq 
  80285a:	c3                   	retq   
	...

000000000080285c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80285c:	55                   	push   %rbp
  80285d:	48 89 e5             	mov    %rsp,%rbp
  802860:	48 83 ec 10          	sub    $0x10,%rsp
  802864:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802867:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80286b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802872:	00 00 00 
  802875:	8b 00                	mov    (%rax),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	75 1d                	jne    802898 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80287b:	bf 01 00 00 00       	mov    $0x1,%edi
  802880:	48 b8 4e 41 80 00 00 	movabs $0x80414e,%rax
  802887:	00 00 00 
  80288a:	ff d0                	callq  *%rax
  80288c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802893:	00 00 00 
  802896:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802898:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80289f:	00 00 00 
  8028a2:	8b 00                	mov    (%rax),%eax
  8028a4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028a7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8028ac:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8028b3:	00 00 00 
  8028b6:	89 c7                	mov    %eax,%edi
  8028b8:	48 b8 9f 40 80 00 00 	movabs $0x80409f,%rax
  8028bf:	00 00 00 
  8028c2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8028c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8028cd:	48 89 c6             	mov    %rax,%rsi
  8028d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d5:	48 b8 b8 3f 80 00 00 	movabs $0x803fb8,%rax
  8028dc:	00 00 00 
  8028df:	ff d0                	callq  *%rax
}
  8028e1:	c9                   	leaveq 
  8028e2:	c3                   	retq   

00000000008028e3 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  8028e3:	55                   	push   %rbp
  8028e4:	48 89 e5             	mov    %rsp,%rbp
  8028e7:	48 83 ec 20          	sub    $0x20,%rsp
  8028eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028ef:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  8028f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f6:	48 89 c7             	mov    %rax,%rdi
  8028f9:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  802900:	00 00 00 
  802903:	ff d0                	callq  *%rax
  802905:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80290a:	7e 0a                	jle    802916 <open+0x33>
		return -E_BAD_PATH;
  80290c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802911:	e9 a5 00 00 00       	jmpq   8029bb <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802916:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80291a:	48 89 c7             	mov    %rax,%rdi
  80291d:	48 b8 3a 1f 80 00 00 	movabs $0x801f3a,%rax
  802924:	00 00 00 
  802927:	ff d0                	callq  *%rax
  802929:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  80292c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802930:	79 08                	jns    80293a <open+0x57>
		return r;
  802932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802935:	e9 81 00 00 00       	jmpq   8029bb <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80293a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802941:	00 00 00 
  802944:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802947:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80294d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802951:	48 89 c6             	mov    %rax,%rsi
  802954:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80295b:	00 00 00 
  80295e:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  802965:	00 00 00 
  802968:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80296a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296e:	48 89 c6             	mov    %rax,%rsi
  802971:	bf 01 00 00 00       	mov    $0x1,%edi
  802976:	48 b8 5c 28 80 00 00 	movabs $0x80285c,%rax
  80297d:	00 00 00 
  802980:	ff d0                	callq  *%rax
  802982:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802985:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802989:	79 1d                	jns    8029a8 <open+0xc5>
		fd_close(new_fd, 0);
  80298b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298f:	be 00 00 00 00       	mov    $0x0,%esi
  802994:	48 89 c7             	mov    %rax,%rdi
  802997:	48 b8 62 20 80 00 00 	movabs $0x802062,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
		return r;	
  8029a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a6:	eb 13                	jmp    8029bb <open+0xd8>
	}
	return fd2num(new_fd);
  8029a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ac:	48 89 c7             	mov    %rax,%rdi
  8029af:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  8029b6:	00 00 00 
  8029b9:	ff d0                	callq  *%rax
}
  8029bb:	c9                   	leaveq 
  8029bc:	c3                   	retq   

00000000008029bd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029bd:	55                   	push   %rbp
  8029be:	48 89 e5             	mov    %rsp,%rbp
  8029c1:	48 83 ec 10          	sub    $0x10,%rsp
  8029c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029cd:	8b 50 0c             	mov    0xc(%rax),%edx
  8029d0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d7:	00 00 00 
  8029da:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029dc:	be 00 00 00 00       	mov    $0x0,%esi
  8029e1:	bf 06 00 00 00       	mov    $0x6,%edi
  8029e6:	48 b8 5c 28 80 00 00 	movabs $0x80285c,%rax
  8029ed:	00 00 00 
  8029f0:	ff d0                	callq  *%rax
}
  8029f2:	c9                   	leaveq 
  8029f3:	c3                   	retq   

00000000008029f4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029f4:	55                   	push   %rbp
  8029f5:	48 89 e5             	mov    %rsp,%rbp
  8029f8:	48 83 ec 30          	sub    $0x30,%rsp
  8029fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0c:	8b 50 0c             	mov    0xc(%rax),%edx
  802a0f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a16:	00 00 00 
  802a19:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a1b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a22:	00 00 00 
  802a25:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a29:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  802a2d:	be 00 00 00 00       	mov    $0x0,%esi
  802a32:	bf 03 00 00 00       	mov    $0x3,%edi
  802a37:	48 b8 5c 28 80 00 00 	movabs $0x80285c,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
  802a43:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802a46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4a:	7e 23                	jle    802a6f <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  802a4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4f:	48 63 d0             	movslq %eax,%rdx
  802a52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a56:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a5d:	00 00 00 
  802a60:	48 89 c7             	mov    %rax,%rdi
  802a63:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  802a6a:	00 00 00 
  802a6d:	ff d0                	callq  *%rax
	}
	return nbytes;
  802a6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a72:	c9                   	leaveq 
  802a73:	c3                   	retq   

0000000000802a74 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a74:	55                   	push   %rbp
  802a75:	48 89 e5             	mov    %rsp,%rbp
  802a78:	48 83 ec 20          	sub    $0x20,%rsp
  802a7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a80:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a88:	8b 50 0c             	mov    0xc(%rax),%edx
  802a8b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a92:	00 00 00 
  802a95:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a97:	be 00 00 00 00       	mov    $0x0,%esi
  802a9c:	bf 05 00 00 00       	mov    $0x5,%edi
  802aa1:	48 b8 5c 28 80 00 00 	movabs $0x80285c,%rax
  802aa8:	00 00 00 
  802aab:	ff d0                	callq  *%rax
  802aad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab4:	79 05                	jns    802abb <devfile_stat+0x47>
		return r;
  802ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab9:	eb 56                	jmp    802b11 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802abb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802abf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ac6:	00 00 00 
  802ac9:	48 89 c7             	mov    %rax,%rdi
  802acc:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ad8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802adf:	00 00 00 
  802ae2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ae8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aec:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802af2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802af9:	00 00 00 
  802afc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b06:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b11:	c9                   	leaveq 
  802b12:	c3                   	retq   
	...

0000000000802b14 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802b14:	55                   	push   %rbp
  802b15:	48 89 e5             	mov    %rsp,%rbp
  802b18:	48 83 ec 20          	sub    $0x20,%rsp
  802b1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802b20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b24:	8b 40 0c             	mov    0xc(%rax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	7e 67                	jle    802b92 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2f:	8b 40 04             	mov    0x4(%rax),%eax
  802b32:	48 63 d0             	movslq %eax,%rdx
  802b35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b39:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802b3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b41:	8b 00                	mov    (%rax),%eax
  802b43:	48 89 ce             	mov    %rcx,%rsi
  802b46:	89 c7                	mov    %eax,%edi
  802b48:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
  802b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5b:	7e 13                	jle    802b70 <writebuf+0x5c>
			b->result += result;
  802b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b61:	8b 40 08             	mov    0x8(%rax),%eax
  802b64:	89 c2                	mov    %eax,%edx
  802b66:	03 55 fc             	add    -0x4(%rbp),%edx
  802b69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6d:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b74:	8b 40 04             	mov    0x4(%rax),%eax
  802b77:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802b7a:	74 16                	je     802b92 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b85:	89 c2                	mov    %eax,%edx
  802b87:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  802b8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8f:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802b92:	c9                   	leaveq 
  802b93:	c3                   	retq   

0000000000802b94 <putch>:

static void
putch(int ch, void *thunk)
{
  802b94:	55                   	push   %rbp
  802b95:	48 89 e5             	mov    %rsp,%rbp
  802b98:	48 83 ec 20          	sub    $0x20,%rsp
  802b9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802ba3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802baf:	8b 40 04             	mov    0x4(%rax),%eax
  802bb2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802bb5:	89 d6                	mov    %edx,%esi
  802bb7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802bbb:	48 63 d0             	movslq %eax,%rdx
  802bbe:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  802bc3:	8d 50 01             	lea    0x1(%rax),%edx
  802bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bca:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  802bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd1:	8b 40 04             	mov    0x4(%rax),%eax
  802bd4:	3d 00 01 00 00       	cmp    $0x100,%eax
  802bd9:	75 1e                	jne    802bf9 <putch+0x65>
		writebuf(b);
  802bdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bdf:	48 89 c7             	mov    %rax,%rdi
  802be2:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	callq  *%rax
		b->idx = 0;
  802bee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802bf9:	c9                   	leaveq 
  802bfa:	c3                   	retq   

0000000000802bfb <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802bfb:	55                   	push   %rbp
  802bfc:	48 89 e5             	mov    %rsp,%rbp
  802bff:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802c06:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802c0c:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802c13:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802c1a:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802c20:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802c26:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802c2d:	00 00 00 
	b.result = 0;
  802c30:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802c37:	00 00 00 
	b.error = 1;
  802c3a:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802c41:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802c44:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802c4b:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802c52:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802c59:	48 89 c6             	mov    %rax,%rsi
  802c5c:	48 bf 94 2b 80 00 00 	movabs $0x802b94,%rdi
  802c63:	00 00 00 
  802c66:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802c72:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	7e 16                	jle    802c92 <vfprintf+0x97>
		writebuf(&b);
  802c7c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802c83:	48 89 c7             	mov    %rax,%rdi
  802c86:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  802c8d:	00 00 00 
  802c90:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802c92:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802c98:	85 c0                	test   %eax,%eax
  802c9a:	74 08                	je     802ca4 <vfprintf+0xa9>
  802c9c:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ca2:	eb 06                	jmp    802caa <vfprintf+0xaf>
  802ca4:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802caa:	c9                   	leaveq 
  802cab:	c3                   	retq   

0000000000802cac <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802cac:	55                   	push   %rbp
  802cad:	48 89 e5             	mov    %rsp,%rbp
  802cb0:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802cb7:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802cbd:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802cc4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ccb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802cd2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802cd9:	84 c0                	test   %al,%al
  802cdb:	74 20                	je     802cfd <fprintf+0x51>
  802cdd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ce1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802ce5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802ce9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802ced:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802cf1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802cf5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802cf9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802cfd:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802d04:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802d0b:	00 00 00 
  802d0e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802d15:	00 00 00 
  802d18:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d1c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802d23:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802d2a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802d31:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802d38:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802d3f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802d45:	48 89 ce             	mov    %rcx,%rsi
  802d48:	89 c7                	mov    %eax,%edi
  802d4a:	48 b8 fb 2b 80 00 00 	movabs $0x802bfb,%rax
  802d51:	00 00 00 
  802d54:	ff d0                	callq  *%rax
  802d56:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802d5c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802d62:	c9                   	leaveq 
  802d63:	c3                   	retq   

0000000000802d64 <printf>:

int
printf(const char *fmt, ...)
{
  802d64:	55                   	push   %rbp
  802d65:	48 89 e5             	mov    %rsp,%rbp
  802d68:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802d6f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802d76:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802d7d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802d84:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802d8b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802d92:	84 c0                	test   %al,%al
  802d94:	74 20                	je     802db6 <printf+0x52>
  802d96:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802d9a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802d9e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802da2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802da6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802daa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802dae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802db2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802db6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802dbd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802dc4:	00 00 00 
  802dc7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802dce:	00 00 00 
  802dd1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802dd5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802ddc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802de3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802dea:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802df1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802df8:	48 89 c6             	mov    %rax,%rsi
  802dfb:	bf 01 00 00 00       	mov    $0x1,%edi
  802e00:	48 b8 fb 2b 80 00 00 	movabs $0x802bfb,%rax
  802e07:	00 00 00 
  802e0a:	ff d0                	callq  *%rax
  802e0c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802e12:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802e18:	c9                   	leaveq 
  802e19:	c3                   	retq   
	...

0000000000802e1c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e1c:	55                   	push   %rbp
  802e1d:	48 89 e5             	mov    %rsp,%rbp
  802e20:	48 83 ec 20          	sub    $0x20,%rsp
  802e24:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e27:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e2b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e2e:	48 89 d6             	mov    %rdx,%rsi
  802e31:	89 c7                	mov    %eax,%edi
  802e33:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802e3a:	00 00 00 
  802e3d:	ff d0                	callq  *%rax
  802e3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e46:	79 05                	jns    802e4d <fd2sockid+0x31>
		return r;
  802e48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4b:	eb 24                	jmp    802e71 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e51:	8b 10                	mov    (%rax),%edx
  802e53:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802e5a:	00 00 00 
  802e5d:	8b 00                	mov    (%rax),%eax
  802e5f:	39 c2                	cmp    %eax,%edx
  802e61:	74 07                	je     802e6a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802e63:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e68:	eb 07                	jmp    802e71 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e6e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802e71:	c9                   	leaveq 
  802e72:	c3                   	retq   

0000000000802e73 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802e73:	55                   	push   %rbp
  802e74:	48 89 e5             	mov    %rsp,%rbp
  802e77:	48 83 ec 20          	sub    $0x20,%rsp
  802e7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802e7e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e82:	48 89 c7             	mov    %rax,%rdi
  802e85:	48 b8 3a 1f 80 00 00 	movabs $0x801f3a,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
  802e91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e98:	78 26                	js     802ec0 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9e:	ba 07 04 00 00       	mov    $0x407,%edx
  802ea3:	48 89 c6             	mov    %rax,%rsi
  802ea6:	bf 00 00 00 00       	mov    $0x0,%edi
  802eab:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  802eb2:	00 00 00 
  802eb5:	ff d0                	callq  *%rax
  802eb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebe:	79 16                	jns    802ed6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802ec0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ec3:	89 c7                	mov    %eax,%edi
  802ec5:	48 b8 80 33 80 00 00 	movabs $0x803380,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
		return r;
  802ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed4:	eb 3a                	jmp    802f10 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802ed6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eda:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802ee1:	00 00 00 
  802ee4:	8b 12                	mov    (%rdx),%edx
  802ee6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802ee8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eec:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802ef3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802efa:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802efd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f01:	48 89 c7             	mov    %rax,%rdi
  802f04:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
}
  802f10:	c9                   	leaveq 
  802f11:	c3                   	retq   

0000000000802f12 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f12:	55                   	push   %rbp
  802f13:	48 89 e5             	mov    %rsp,%rbp
  802f16:	48 83 ec 30          	sub    $0x30,%rsp
  802f1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f21:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f28:	89 c7                	mov    %eax,%edi
  802f2a:	48 b8 1c 2e 80 00 00 	movabs $0x802e1c,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	callq  *%rax
  802f36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3d:	79 05                	jns    802f44 <accept+0x32>
		return r;
  802f3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f42:	eb 3b                	jmp    802f7f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f44:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f48:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4f:	48 89 ce             	mov    %rcx,%rsi
  802f52:	89 c7                	mov    %eax,%edi
  802f54:	48 b8 5d 32 80 00 00 	movabs $0x80325d,%rax
  802f5b:	00 00 00 
  802f5e:	ff d0                	callq  *%rax
  802f60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f67:	79 05                	jns    802f6e <accept+0x5c>
		return r;
  802f69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6c:	eb 11                	jmp    802f7f <accept+0x6d>
	return alloc_sockfd(r);
  802f6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f71:	89 c7                	mov    %eax,%edi
  802f73:	48 b8 73 2e 80 00 00 	movabs $0x802e73,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
}
  802f7f:	c9                   	leaveq 
  802f80:	c3                   	retq   

0000000000802f81 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f81:	55                   	push   %rbp
  802f82:	48 89 e5             	mov    %rsp,%rbp
  802f85:	48 83 ec 20          	sub    $0x20,%rsp
  802f89:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f90:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f96:	89 c7                	mov    %eax,%edi
  802f98:	48 b8 1c 2e 80 00 00 	movabs $0x802e1c,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax
  802fa4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fab:	79 05                	jns    802fb2 <bind+0x31>
		return r;
  802fad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb0:	eb 1b                	jmp    802fcd <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802fb2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fb5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbc:	48 89 ce             	mov    %rcx,%rsi
  802fbf:	89 c7                	mov    %eax,%edi
  802fc1:	48 b8 dc 32 80 00 00 	movabs $0x8032dc,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
}
  802fcd:	c9                   	leaveq 
  802fce:	c3                   	retq   

0000000000802fcf <shutdown>:

int
shutdown(int s, int how)
{
  802fcf:	55                   	push   %rbp
  802fd0:	48 89 e5             	mov    %rsp,%rbp
  802fd3:	48 83 ec 20          	sub    $0x20,%rsp
  802fd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fda:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fdd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fe0:	89 c7                	mov    %eax,%edi
  802fe2:	48 b8 1c 2e 80 00 00 	movabs $0x802e1c,%rax
  802fe9:	00 00 00 
  802fec:	ff d0                	callq  *%rax
  802fee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff5:	79 05                	jns    802ffc <shutdown+0x2d>
		return r;
  802ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffa:	eb 16                	jmp    803012 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802ffc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803002:	89 d6                	mov    %edx,%esi
  803004:	89 c7                	mov    %eax,%edi
  803006:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
}
  803012:	c9                   	leaveq 
  803013:	c3                   	retq   

0000000000803014 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803014:	55                   	push   %rbp
  803015:	48 89 e5             	mov    %rsp,%rbp
  803018:	48 83 ec 10          	sub    $0x10,%rsp
  80301c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803020:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803024:	48 89 c7             	mov    %rax,%rdi
  803027:	48 b8 dc 41 80 00 00 	movabs $0x8041dc,%rax
  80302e:	00 00 00 
  803031:	ff d0                	callq  *%rax
  803033:	83 f8 01             	cmp    $0x1,%eax
  803036:	75 17                	jne    80304f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803038:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80303c:	8b 40 0c             	mov    0xc(%rax),%eax
  80303f:	89 c7                	mov    %eax,%edi
  803041:	48 b8 80 33 80 00 00 	movabs $0x803380,%rax
  803048:	00 00 00 
  80304b:	ff d0                	callq  *%rax
  80304d:	eb 05                	jmp    803054 <devsock_close+0x40>
	else
		return 0;
  80304f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803054:	c9                   	leaveq 
  803055:	c3                   	retq   

0000000000803056 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803056:	55                   	push   %rbp
  803057:	48 89 e5             	mov    %rsp,%rbp
  80305a:	48 83 ec 20          	sub    $0x20,%rsp
  80305e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803061:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803065:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803068:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80306b:	89 c7                	mov    %eax,%edi
  80306d:	48 b8 1c 2e 80 00 00 	movabs $0x802e1c,%rax
  803074:	00 00 00 
  803077:	ff d0                	callq  *%rax
  803079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803080:	79 05                	jns    803087 <connect+0x31>
		return r;
  803082:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803085:	eb 1b                	jmp    8030a2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803087:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80308a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80308e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803091:	48 89 ce             	mov    %rcx,%rsi
  803094:	89 c7                	mov    %eax,%edi
  803096:	48 b8 ad 33 80 00 00 	movabs $0x8033ad,%rax
  80309d:	00 00 00 
  8030a0:	ff d0                	callq  *%rax
}
  8030a2:	c9                   	leaveq 
  8030a3:	c3                   	retq   

00000000008030a4 <listen>:

int
listen(int s, int backlog)
{
  8030a4:	55                   	push   %rbp
  8030a5:	48 89 e5             	mov    %rsp,%rbp
  8030a8:	48 83 ec 20          	sub    $0x20,%rsp
  8030ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030af:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b5:	89 c7                	mov    %eax,%edi
  8030b7:	48 b8 1c 2e 80 00 00 	movabs $0x802e1c,%rax
  8030be:	00 00 00 
  8030c1:	ff d0                	callq  *%rax
  8030c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ca:	79 05                	jns    8030d1 <listen+0x2d>
		return r;
  8030cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cf:	eb 16                	jmp    8030e7 <listen+0x43>
	return nsipc_listen(r, backlog);
  8030d1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d7:	89 d6                	mov    %edx,%esi
  8030d9:	89 c7                	mov    %eax,%edi
  8030db:	48 b8 11 34 80 00 00 	movabs $0x803411,%rax
  8030e2:	00 00 00 
  8030e5:	ff d0                	callq  *%rax
}
  8030e7:	c9                   	leaveq 
  8030e8:	c3                   	retq   

00000000008030e9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8030e9:	55                   	push   %rbp
  8030ea:	48 89 e5             	mov    %rsp,%rbp
  8030ed:	48 83 ec 20          	sub    $0x20,%rsp
  8030f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803101:	89 c2                	mov    %eax,%edx
  803103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803107:	8b 40 0c             	mov    0xc(%rax),%eax
  80310a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80310e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803113:	89 c7                	mov    %eax,%edi
  803115:	48 b8 51 34 80 00 00 	movabs $0x803451,%rax
  80311c:	00 00 00 
  80311f:	ff d0                	callq  *%rax
}
  803121:	c9                   	leaveq 
  803122:	c3                   	retq   

0000000000803123 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803123:	55                   	push   %rbp
  803124:	48 89 e5             	mov    %rsp,%rbp
  803127:	48 83 ec 20          	sub    $0x20,%rsp
  80312b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80312f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803133:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313b:	89 c2                	mov    %eax,%edx
  80313d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803141:	8b 40 0c             	mov    0xc(%rax),%eax
  803144:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803148:	b9 00 00 00 00       	mov    $0x0,%ecx
  80314d:	89 c7                	mov    %eax,%edi
  80314f:	48 b8 1d 35 80 00 00 	movabs $0x80351d,%rax
  803156:	00 00 00 
  803159:	ff d0                	callq  *%rax
}
  80315b:	c9                   	leaveq 
  80315c:	c3                   	retq   

000000000080315d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80315d:	55                   	push   %rbp
  80315e:	48 89 e5             	mov    %rsp,%rbp
  803161:	48 83 ec 10          	sub    $0x10,%rsp
  803165:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803169:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80316d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803171:	48 be 5b 48 80 00 00 	movabs $0x80485b,%rsi
  803178:	00 00 00 
  80317b:	48 89 c7             	mov    %rax,%rdi
  80317e:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  803185:	00 00 00 
  803188:	ff d0                	callq  *%rax
	return 0;
  80318a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80318f:	c9                   	leaveq 
  803190:	c3                   	retq   

0000000000803191 <socket>:

int
socket(int domain, int type, int protocol)
{
  803191:	55                   	push   %rbp
  803192:	48 89 e5             	mov    %rsp,%rbp
  803195:	48 83 ec 20          	sub    $0x20,%rsp
  803199:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80319c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80319f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8031a2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8031a5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031ab:	89 ce                	mov    %ecx,%esi
  8031ad:	89 c7                	mov    %eax,%edi
  8031af:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
  8031bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c2:	79 05                	jns    8031c9 <socket+0x38>
		return r;
  8031c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c7:	eb 11                	jmp    8031da <socket+0x49>
	return alloc_sockfd(r);
  8031c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cc:	89 c7                	mov    %eax,%edi
  8031ce:	48 b8 73 2e 80 00 00 	movabs $0x802e73,%rax
  8031d5:	00 00 00 
  8031d8:	ff d0                	callq  *%rax
}
  8031da:	c9                   	leaveq 
  8031db:	c3                   	retq   

00000000008031dc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8031dc:	55                   	push   %rbp
  8031dd:	48 89 e5             	mov    %rsp,%rbp
  8031e0:	48 83 ec 10          	sub    $0x10,%rsp
  8031e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8031e7:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8031ee:	00 00 00 
  8031f1:	8b 00                	mov    (%rax),%eax
  8031f3:	85 c0                	test   %eax,%eax
  8031f5:	75 1d                	jne    803214 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8031f7:	bf 02 00 00 00       	mov    $0x2,%edi
  8031fc:	48 b8 4e 41 80 00 00 	movabs $0x80414e,%rax
  803203:	00 00 00 
  803206:	ff d0                	callq  *%rax
  803208:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80320f:	00 00 00 
  803212:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803214:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80321b:	00 00 00 
  80321e:	8b 00                	mov    (%rax),%eax
  803220:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803223:	b9 07 00 00 00       	mov    $0x7,%ecx
  803228:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80322f:	00 00 00 
  803232:	89 c7                	mov    %eax,%edi
  803234:	48 b8 9f 40 80 00 00 	movabs $0x80409f,%rax
  80323b:	00 00 00 
  80323e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803240:	ba 00 00 00 00       	mov    $0x0,%edx
  803245:	be 00 00 00 00       	mov    $0x0,%esi
  80324a:	bf 00 00 00 00       	mov    $0x0,%edi
  80324f:	48 b8 b8 3f 80 00 00 	movabs $0x803fb8,%rax
  803256:	00 00 00 
  803259:	ff d0                	callq  *%rax
}
  80325b:	c9                   	leaveq 
  80325c:	c3                   	retq   

000000000080325d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80325d:	55                   	push   %rbp
  80325e:	48 89 e5             	mov    %rsp,%rbp
  803261:	48 83 ec 30          	sub    $0x30,%rsp
  803265:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803268:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80326c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803270:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803277:	00 00 00 
  80327a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80327d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80327f:	bf 01 00 00 00       	mov    $0x1,%edi
  803284:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  80328b:	00 00 00 
  80328e:	ff d0                	callq  *%rax
  803290:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803293:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803297:	78 3e                	js     8032d7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803299:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032a0:	00 00 00 
  8032a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8032a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ab:	8b 40 10             	mov    0x10(%rax),%eax
  8032ae:	89 c2                	mov    %eax,%edx
  8032b0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8032b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032b8:	48 89 ce             	mov    %rcx,%rsi
  8032bb:	48 89 c7             	mov    %rax,%rdi
  8032be:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8032ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ce:	8b 50 10             	mov    0x10(%rax),%edx
  8032d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8032d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032da:	c9                   	leaveq 
  8032db:	c3                   	retq   

00000000008032dc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032dc:	55                   	push   %rbp
  8032dd:	48 89 e5             	mov    %rsp,%rbp
  8032e0:	48 83 ec 10          	sub    $0x10,%rsp
  8032e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032eb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8032ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032f5:	00 00 00 
  8032f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032fb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032fd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803304:	48 89 c6             	mov    %rax,%rsi
  803307:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80330e:	00 00 00 
  803311:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  803318:	00 00 00 
  80331b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80331d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803324:	00 00 00 
  803327:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80332a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80332d:	bf 02 00 00 00       	mov    $0x2,%edi
  803332:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  803339:	00 00 00 
  80333c:	ff d0                	callq  *%rax
}
  80333e:	c9                   	leaveq 
  80333f:	c3                   	retq   

0000000000803340 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803340:	55                   	push   %rbp
  803341:	48 89 e5             	mov    %rsp,%rbp
  803344:	48 83 ec 10          	sub    $0x10,%rsp
  803348:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80334b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80334e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803355:	00 00 00 
  803358:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80335b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80335d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803364:	00 00 00 
  803367:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80336a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80336d:	bf 03 00 00 00       	mov    $0x3,%edi
  803372:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  803379:	00 00 00 
  80337c:	ff d0                	callq  *%rax
}
  80337e:	c9                   	leaveq 
  80337f:	c3                   	retq   

0000000000803380 <nsipc_close>:

int
nsipc_close(int s)
{
  803380:	55                   	push   %rbp
  803381:	48 89 e5             	mov    %rsp,%rbp
  803384:	48 83 ec 10          	sub    $0x10,%rsp
  803388:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80338b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803392:	00 00 00 
  803395:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803398:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80339a:	bf 04 00 00 00       	mov    $0x4,%edi
  80339f:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  8033a6:	00 00 00 
  8033a9:	ff d0                	callq  *%rax
}
  8033ab:	c9                   	leaveq 
  8033ac:	c3                   	retq   

00000000008033ad <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033ad:	55                   	push   %rbp
  8033ae:	48 89 e5             	mov    %rsp,%rbp
  8033b1:	48 83 ec 10          	sub    $0x10,%rsp
  8033b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033bc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8033bf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033c6:	00 00 00 
  8033c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033cc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8033ce:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d5:	48 89 c6             	mov    %rax,%rsi
  8033d8:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8033df:	00 00 00 
  8033e2:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8033ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033f5:	00 00 00 
  8033f8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033fb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8033fe:	bf 05 00 00 00       	mov    $0x5,%edi
  803403:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  80340a:	00 00 00 
  80340d:	ff d0                	callq  *%rax
}
  80340f:	c9                   	leaveq 
  803410:	c3                   	retq   

0000000000803411 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803411:	55                   	push   %rbp
  803412:	48 89 e5             	mov    %rsp,%rbp
  803415:	48 83 ec 10          	sub    $0x10,%rsp
  803419:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80341c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80341f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803426:	00 00 00 
  803429:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80342c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80342e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803435:	00 00 00 
  803438:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80343b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80343e:	bf 06 00 00 00       	mov    $0x6,%edi
  803443:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  80344a:	00 00 00 
  80344d:	ff d0                	callq  *%rax
}
  80344f:	c9                   	leaveq 
  803450:	c3                   	retq   

0000000000803451 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803451:	55                   	push   %rbp
  803452:	48 89 e5             	mov    %rsp,%rbp
  803455:	48 83 ec 30          	sub    $0x30,%rsp
  803459:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80345c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803460:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803463:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803466:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80346d:	00 00 00 
  803470:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803473:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803475:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80347c:	00 00 00 
  80347f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803482:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803485:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80348c:	00 00 00 
  80348f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803492:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803495:	bf 07 00 00 00       	mov    $0x7,%edi
  80349a:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
  8034a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ad:	78 69                	js     803518 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8034af:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8034b6:	7f 08                	jg     8034c0 <nsipc_recv+0x6f>
  8034b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8034be:	7e 35                	jle    8034f5 <nsipc_recv+0xa4>
  8034c0:	48 b9 62 48 80 00 00 	movabs $0x804862,%rcx
  8034c7:	00 00 00 
  8034ca:	48 ba 77 48 80 00 00 	movabs $0x804877,%rdx
  8034d1:	00 00 00 
  8034d4:	be 61 00 00 00       	mov    $0x61,%esi
  8034d9:	48 bf 8c 48 80 00 00 	movabs $0x80488c,%rdi
  8034e0:	00 00 00 
  8034e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e8:	49 b8 a4 3e 80 00 00 	movabs $0x803ea4,%r8
  8034ef:	00 00 00 
  8034f2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8034f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f8:	48 63 d0             	movslq %eax,%rdx
  8034fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034ff:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803506:	00 00 00 
  803509:	48 89 c7             	mov    %rax,%rdi
  80350c:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
	}

	return r;
  803518:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80351b:	c9                   	leaveq 
  80351c:	c3                   	retq   

000000000080351d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80351d:	55                   	push   %rbp
  80351e:	48 89 e5             	mov    %rsp,%rbp
  803521:	48 83 ec 20          	sub    $0x20,%rsp
  803525:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803528:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80352c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80352f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803532:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803539:	00 00 00 
  80353c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80353f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803541:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803548:	7e 35                	jle    80357f <nsipc_send+0x62>
  80354a:	48 b9 98 48 80 00 00 	movabs $0x804898,%rcx
  803551:	00 00 00 
  803554:	48 ba 77 48 80 00 00 	movabs $0x804877,%rdx
  80355b:	00 00 00 
  80355e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803563:	48 bf 8c 48 80 00 00 	movabs $0x80488c,%rdi
  80356a:	00 00 00 
  80356d:	b8 00 00 00 00       	mov    $0x0,%eax
  803572:	49 b8 a4 3e 80 00 00 	movabs $0x803ea4,%r8
  803579:	00 00 00 
  80357c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80357f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803582:	48 63 d0             	movslq %eax,%rdx
  803585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803589:	48 89 c6             	mov    %rax,%rsi
  80358c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803593:	00 00 00 
  803596:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  80359d:	00 00 00 
  8035a0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8035a2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035a9:	00 00 00 
  8035ac:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035af:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8035b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035b9:	00 00 00 
  8035bc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035bf:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8035c2:	bf 08 00 00 00       	mov    $0x8,%edi
  8035c7:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
}
  8035d3:	c9                   	leaveq 
  8035d4:	c3                   	retq   

00000000008035d5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8035d5:	55                   	push   %rbp
  8035d6:	48 89 e5             	mov    %rsp,%rbp
  8035d9:	48 83 ec 10          	sub    $0x10,%rsp
  8035dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035e0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8035e3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8035e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035ed:	00 00 00 
  8035f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035f3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8035f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035fc:	00 00 00 
  8035ff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803602:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803605:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80360c:	00 00 00 
  80360f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803612:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803615:	bf 09 00 00 00       	mov    $0x9,%edi
  80361a:	48 b8 dc 31 80 00 00 	movabs $0x8031dc,%rax
  803621:	00 00 00 
  803624:	ff d0                	callq  *%rax
}
  803626:	c9                   	leaveq 
  803627:	c3                   	retq   

0000000000803628 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803628:	55                   	push   %rbp
  803629:	48 89 e5             	mov    %rsp,%rbp
  80362c:	53                   	push   %rbx
  80362d:	48 83 ec 38          	sub    $0x38,%rsp
  803631:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803635:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803639:	48 89 c7             	mov    %rax,%rdi
  80363c:	48 b8 3a 1f 80 00 00 	movabs $0x801f3a,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
  803648:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80364b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80364f:	0f 88 bf 01 00 00    	js     803814 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803655:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803659:	ba 07 04 00 00       	mov    $0x407,%edx
  80365e:	48 89 c6             	mov    %rax,%rsi
  803661:	bf 00 00 00 00       	mov    $0x0,%edi
  803666:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  80366d:	00 00 00 
  803670:	ff d0                	callq  *%rax
  803672:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803675:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803679:	0f 88 95 01 00 00    	js     803814 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80367f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803683:	48 89 c7             	mov    %rax,%rdi
  803686:	48 b8 3a 1f 80 00 00 	movabs $0x801f3a,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
  803692:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803695:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803699:	0f 88 5d 01 00 00    	js     8037fc <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80369f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036a3:	ba 07 04 00 00       	mov    $0x407,%edx
  8036a8:	48 89 c6             	mov    %rax,%rsi
  8036ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b0:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  8036b7:	00 00 00 
  8036ba:	ff d0                	callq  *%rax
  8036bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036c3:	0f 88 33 01 00 00    	js     8037fc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8036c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036cd:	48 89 c7             	mov    %rax,%rdi
  8036d0:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  8036d7:	00 00 00 
  8036da:	ff d0                	callq  *%rax
  8036dc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e4:	ba 07 04 00 00       	mov    $0x407,%edx
  8036e9:	48 89 c6             	mov    %rax,%rsi
  8036ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8036f1:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
  8036fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803700:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803704:	0f 88 d9 00 00 00    	js     8037e3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80370a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80370e:	48 89 c7             	mov    %rax,%rdi
  803711:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  803718:	00 00 00 
  80371b:	ff d0                	callq  *%rax
  80371d:	48 89 c2             	mov    %rax,%rdx
  803720:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803724:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80372a:	48 89 d1             	mov    %rdx,%rcx
  80372d:	ba 00 00 00 00       	mov    $0x0,%edx
  803732:	48 89 c6             	mov    %rax,%rsi
  803735:	bf 00 00 00 00       	mov    $0x0,%edi
  80373a:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
  803746:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803749:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80374d:	78 79                	js     8037c8 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80374f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803753:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80375a:	00 00 00 
  80375d:	8b 12                	mov    (%rdx),%edx
  80375f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803765:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80376c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803770:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803777:	00 00 00 
  80377a:	8b 12                	mov    (%rdx),%edx
  80377c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80377e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803782:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80378d:	48 89 c7             	mov    %rax,%rdi
  803790:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  803797:	00 00 00 
  80379a:	ff d0                	callq  *%rax
  80379c:	89 c2                	mov    %eax,%edx
  80379e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037a2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8037a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037a8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8037ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037b0:	48 89 c7             	mov    %rax,%rdi
  8037b3:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  8037ba:	00 00 00 
  8037bd:	ff d0                	callq  *%rax
  8037bf:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c6:	eb 4f                	jmp    803817 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8037c8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8037c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037cd:	48 89 c6             	mov    %rax,%rsi
  8037d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d5:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
  8037e1:	eb 01                	jmp    8037e4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8037e3:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8037e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e8:	48 89 c6             	mov    %rax,%rsi
  8037eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f0:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  8037f7:	00 00 00 
  8037fa:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803800:	48 89 c6             	mov    %rax,%rsi
  803803:	bf 00 00 00 00       	mov    $0x0,%edi
  803808:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  80380f:	00 00 00 
  803812:	ff d0                	callq  *%rax
err:
	return r;
  803814:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803817:	48 83 c4 38          	add    $0x38,%rsp
  80381b:	5b                   	pop    %rbx
  80381c:	5d                   	pop    %rbp
  80381d:	c3                   	retq   

000000000080381e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80381e:	55                   	push   %rbp
  80381f:	48 89 e5             	mov    %rsp,%rbp
  803822:	53                   	push   %rbx
  803823:	48 83 ec 28          	sub    $0x28,%rsp
  803827:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80382b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80382f:	eb 01                	jmp    803832 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803831:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803832:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803839:	00 00 00 
  80383c:	48 8b 00             	mov    (%rax),%rax
  80383f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803845:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384c:	48 89 c7             	mov    %rax,%rdi
  80384f:	48 b8 dc 41 80 00 00 	movabs $0x8041dc,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
  80385b:	89 c3                	mov    %eax,%ebx
  80385d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803861:	48 89 c7             	mov    %rax,%rdi
  803864:	48 b8 dc 41 80 00 00 	movabs $0x8041dc,%rax
  80386b:	00 00 00 
  80386e:	ff d0                	callq  *%rax
  803870:	39 c3                	cmp    %eax,%ebx
  803872:	0f 94 c0             	sete   %al
  803875:	0f b6 c0             	movzbl %al,%eax
  803878:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80387b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803882:	00 00 00 
  803885:	48 8b 00             	mov    (%rax),%rax
  803888:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80388e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803891:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803894:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803897:	75 0a                	jne    8038a3 <_pipeisclosed+0x85>
			return ret;
  803899:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80389c:	48 83 c4 28          	add    $0x28,%rsp
  8038a0:	5b                   	pop    %rbx
  8038a1:	5d                   	pop    %rbp
  8038a2:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8038a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038a9:	74 86                	je     803831 <_pipeisclosed+0x13>
  8038ab:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8038af:	75 80                	jne    803831 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8038b1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038b8:	00 00 00 
  8038bb:	48 8b 00             	mov    (%rax),%rax
  8038be:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8038c4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ca:	89 c6                	mov    %eax,%esi
  8038cc:	48 bf a9 48 80 00 00 	movabs $0x8048a9,%rdi
  8038d3:	00 00 00 
  8038d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038db:	49 b8 b3 03 80 00 00 	movabs $0x8003b3,%r8
  8038e2:	00 00 00 
  8038e5:	41 ff d0             	callq  *%r8
	}
  8038e8:	e9 44 ff ff ff       	jmpq   803831 <_pipeisclosed+0x13>

00000000008038ed <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8038ed:	55                   	push   %rbp
  8038ee:	48 89 e5             	mov    %rsp,%rbp
  8038f1:	48 83 ec 30          	sub    $0x30,%rsp
  8038f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038f8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038fc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038ff:	48 89 d6             	mov    %rdx,%rsi
  803902:	89 c7                	mov    %eax,%edi
  803904:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  80390b:	00 00 00 
  80390e:	ff d0                	callq  *%rax
  803910:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803913:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803917:	79 05                	jns    80391e <pipeisclosed+0x31>
		return r;
  803919:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391c:	eb 31                	jmp    80394f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80391e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803922:	48 89 c7             	mov    %rax,%rdi
  803925:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  80392c:	00 00 00 
  80392f:	ff d0                	callq  *%rax
  803931:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803939:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80393d:	48 89 d6             	mov    %rdx,%rsi
  803940:	48 89 c7             	mov    %rax,%rdi
  803943:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  80394a:	00 00 00 
  80394d:	ff d0                	callq  *%rax
}
  80394f:	c9                   	leaveq 
  803950:	c3                   	retq   

0000000000803951 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803951:	55                   	push   %rbp
  803952:	48 89 e5             	mov    %rsp,%rbp
  803955:	48 83 ec 40          	sub    $0x40,%rsp
  803959:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80395d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803961:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803969:	48 89 c7             	mov    %rax,%rdi
  80396c:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  803973:	00 00 00 
  803976:	ff d0                	callq  *%rax
  803978:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80397c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803980:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803984:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80398b:	00 
  80398c:	e9 97 00 00 00       	jmpq   803a28 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803991:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803996:	74 09                	je     8039a1 <devpipe_read+0x50>
				return i;
  803998:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80399c:	e9 95 00 00 00       	jmpq   803a36 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8039a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039a9:	48 89 d6             	mov    %rdx,%rsi
  8039ac:	48 89 c7             	mov    %rax,%rdi
  8039af:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
  8039bb:	85 c0                	test   %eax,%eax
  8039bd:	74 07                	je     8039c6 <devpipe_read+0x75>
				return 0;
  8039bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c4:	eb 70                	jmp    803a36 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039c6:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  8039cd:	00 00 00 
  8039d0:	ff d0                	callq  *%rax
  8039d2:	eb 01                	jmp    8039d5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8039d4:	90                   	nop
  8039d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d9:	8b 10                	mov    (%rax),%edx
  8039db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039df:	8b 40 04             	mov    0x4(%rax),%eax
  8039e2:	39 c2                	cmp    %eax,%edx
  8039e4:	74 ab                	je     803991 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039ee:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f6:	8b 00                	mov    (%rax),%eax
  8039f8:	89 c2                	mov    %eax,%edx
  8039fa:	c1 fa 1f             	sar    $0x1f,%edx
  8039fd:	c1 ea 1b             	shr    $0x1b,%edx
  803a00:	01 d0                	add    %edx,%eax
  803a02:	83 e0 1f             	and    $0x1f,%eax
  803a05:	29 d0                	sub    %edx,%eax
  803a07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a0b:	48 98                	cltq   
  803a0d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a12:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a18:	8b 00                	mov    (%rax),%eax
  803a1a:	8d 50 01             	lea    0x1(%rax),%edx
  803a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a21:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a23:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a2c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a30:	72 a2                	jb     8039d4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a36:	c9                   	leaveq 
  803a37:	c3                   	retq   

0000000000803a38 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a38:	55                   	push   %rbp
  803a39:	48 89 e5             	mov    %rsp,%rbp
  803a3c:	48 83 ec 40          	sub    $0x40,%rsp
  803a40:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a44:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a48:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a50:	48 89 c7             	mov    %rax,%rdi
  803a53:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  803a5a:	00 00 00 
  803a5d:	ff d0                	callq  *%rax
  803a5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a6b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a72:	00 
  803a73:	e9 93 00 00 00       	jmpq   803b0b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a80:	48 89 d6             	mov    %rdx,%rsi
  803a83:	48 89 c7             	mov    %rax,%rdi
  803a86:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
  803a92:	85 c0                	test   %eax,%eax
  803a94:	74 07                	je     803a9d <devpipe_write+0x65>
				return 0;
  803a96:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9b:	eb 7c                	jmp    803b19 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a9d:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  803aa4:	00 00 00 
  803aa7:	ff d0                	callq  *%rax
  803aa9:	eb 01                	jmp    803aac <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803aab:	90                   	nop
  803aac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab0:	8b 40 04             	mov    0x4(%rax),%eax
  803ab3:	48 63 d0             	movslq %eax,%rdx
  803ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aba:	8b 00                	mov    (%rax),%eax
  803abc:	48 98                	cltq   
  803abe:	48 83 c0 20          	add    $0x20,%rax
  803ac2:	48 39 c2             	cmp    %rax,%rdx
  803ac5:	73 b1                	jae    803a78 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ac7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803acb:	8b 40 04             	mov    0x4(%rax),%eax
  803ace:	89 c2                	mov    %eax,%edx
  803ad0:	c1 fa 1f             	sar    $0x1f,%edx
  803ad3:	c1 ea 1b             	shr    $0x1b,%edx
  803ad6:	01 d0                	add    %edx,%eax
  803ad8:	83 e0 1f             	and    $0x1f,%eax
  803adb:	29 d0                	sub    %edx,%eax
  803add:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ae1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ae5:	48 01 ca             	add    %rcx,%rdx
  803ae8:	0f b6 0a             	movzbl (%rdx),%ecx
  803aeb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aef:	48 98                	cltq   
  803af1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803af5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af9:	8b 40 04             	mov    0x4(%rax),%eax
  803afc:	8d 50 01             	lea    0x1(%rax),%edx
  803aff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b03:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b06:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b0f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b13:	72 96                	jb     803aab <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b19:	c9                   	leaveq 
  803b1a:	c3                   	retq   

0000000000803b1b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b1b:	55                   	push   %rbp
  803b1c:	48 89 e5             	mov    %rsp,%rbp
  803b1f:	48 83 ec 20          	sub    $0x20,%rsp
  803b23:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b27:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b2f:	48 89 c7             	mov    %rax,%rdi
  803b32:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  803b39:	00 00 00 
  803b3c:	ff d0                	callq  *%rax
  803b3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b46:	48 be bc 48 80 00 00 	movabs $0x8048bc,%rsi
  803b4d:	00 00 00 
  803b50:	48 89 c7             	mov    %rax,%rdi
  803b53:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  803b5a:	00 00 00 
  803b5d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b63:	8b 50 04             	mov    0x4(%rax),%edx
  803b66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b6a:	8b 00                	mov    (%rax),%eax
  803b6c:	29 c2                	sub    %eax,%edx
  803b6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b72:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b7c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b83:	00 00 00 
	stat->st_dev = &devpipe;
  803b86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b8a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b91:	00 00 00 
  803b94:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803b9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ba0:	c9                   	leaveq 
  803ba1:	c3                   	retq   

0000000000803ba2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ba2:	55                   	push   %rbp
  803ba3:	48 89 e5             	mov    %rsp,%rbp
  803ba6:	48 83 ec 10          	sub    $0x10,%rsp
  803baa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803bae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb2:	48 89 c6             	mov    %rax,%rsi
  803bb5:	bf 00 00 00 00       	mov    $0x0,%edi
  803bba:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  803bc1:	00 00 00 
  803bc4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bca:	48 89 c7             	mov    %rax,%rdi
  803bcd:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  803bd4:	00 00 00 
  803bd7:	ff d0                	callq  *%rax
  803bd9:	48 89 c6             	mov    %rax,%rsi
  803bdc:	bf 00 00 00 00       	mov    $0x0,%edi
  803be1:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  803be8:	00 00 00 
  803beb:	ff d0                	callq  *%rax
}
  803bed:	c9                   	leaveq 
  803bee:	c3                   	retq   
	...

0000000000803bf0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bf0:	55                   	push   %rbp
  803bf1:	48 89 e5             	mov    %rsp,%rbp
  803bf4:	48 83 ec 20          	sub    $0x20,%rsp
  803bf8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bfb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bfe:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c01:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c05:	be 01 00 00 00       	mov    $0x1,%esi
  803c0a:	48 89 c7             	mov    %rax,%rdi
  803c0d:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  803c14:	00 00 00 
  803c17:	ff d0                	callq  *%rax
}
  803c19:	c9                   	leaveq 
  803c1a:	c3                   	retq   

0000000000803c1b <getchar>:

int
getchar(void)
{
  803c1b:	55                   	push   %rbp
  803c1c:	48 89 e5             	mov    %rsp,%rbp
  803c1f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c23:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c27:	ba 01 00 00 00       	mov    $0x1,%edx
  803c2c:	48 89 c6             	mov    %rax,%rsi
  803c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c34:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  803c3b:	00 00 00 
  803c3e:	ff d0                	callq  *%rax
  803c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c47:	79 05                	jns    803c4e <getchar+0x33>
		return r;
  803c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4c:	eb 14                	jmp    803c62 <getchar+0x47>
	if (r < 1)
  803c4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c52:	7f 07                	jg     803c5b <getchar+0x40>
		return -E_EOF;
  803c54:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c59:	eb 07                	jmp    803c62 <getchar+0x47>
	return c;
  803c5b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c5f:	0f b6 c0             	movzbl %al,%eax
}
  803c62:	c9                   	leaveq 
  803c63:	c3                   	retq   

0000000000803c64 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c64:	55                   	push   %rbp
  803c65:	48 89 e5             	mov    %rsp,%rbp
  803c68:	48 83 ec 20          	sub    $0x20,%rsp
  803c6c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c6f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c76:	48 89 d6             	mov    %rdx,%rsi
  803c79:	89 c7                	mov    %eax,%edi
  803c7b:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
  803c87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c8e:	79 05                	jns    803c95 <iscons+0x31>
		return r;
  803c90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c93:	eb 1a                	jmp    803caf <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c99:	8b 10                	mov    (%rax),%edx
  803c9b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803ca2:	00 00 00 
  803ca5:	8b 00                	mov    (%rax),%eax
  803ca7:	39 c2                	cmp    %eax,%edx
  803ca9:	0f 94 c0             	sete   %al
  803cac:	0f b6 c0             	movzbl %al,%eax
}
  803caf:	c9                   	leaveq 
  803cb0:	c3                   	retq   

0000000000803cb1 <opencons>:

int
opencons(void)
{
  803cb1:	55                   	push   %rbp
  803cb2:	48 89 e5             	mov    %rsp,%rbp
  803cb5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803cb9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803cbd:	48 89 c7             	mov    %rax,%rdi
  803cc0:	48 b8 3a 1f 80 00 00 	movabs $0x801f3a,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
  803ccc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ccf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd3:	79 05                	jns    803cda <opencons+0x29>
		return r;
  803cd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd8:	eb 5b                	jmp    803d35 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803cda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cde:	ba 07 04 00 00       	mov    $0x407,%edx
  803ce3:	48 89 c6             	mov    %rax,%rsi
  803ce6:	bf 00 00 00 00       	mov    $0x0,%edi
  803ceb:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  803cf2:	00 00 00 
  803cf5:	ff d0                	callq  *%rax
  803cf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cfe:	79 05                	jns    803d05 <opencons+0x54>
		return r;
  803d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d03:	eb 30                	jmp    803d35 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d09:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d10:	00 00 00 
  803d13:	8b 12                	mov    (%rdx),%edx
  803d15:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d26:	48 89 c7             	mov    %rax,%rdi
  803d29:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  803d30:	00 00 00 
  803d33:	ff d0                	callq  *%rax
}
  803d35:	c9                   	leaveq 
  803d36:	c3                   	retq   

0000000000803d37 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d37:	55                   	push   %rbp
  803d38:	48 89 e5             	mov    %rsp,%rbp
  803d3b:	48 83 ec 30          	sub    $0x30,%rsp
  803d3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d47:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d4b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d50:	75 13                	jne    803d65 <devcons_read+0x2e>
		return 0;
  803d52:	b8 00 00 00 00       	mov    $0x0,%eax
  803d57:	eb 49                	jmp    803da2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803d59:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  803d60:	00 00 00 
  803d63:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d65:	48 b8 be 17 80 00 00 	movabs $0x8017be,%rax
  803d6c:	00 00 00 
  803d6f:	ff d0                	callq  *%rax
  803d71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d78:	74 df                	je     803d59 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803d7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d7e:	79 05                	jns    803d85 <devcons_read+0x4e>
		return c;
  803d80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d83:	eb 1d                	jmp    803da2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803d85:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d89:	75 07                	jne    803d92 <devcons_read+0x5b>
		return 0;
  803d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d90:	eb 10                	jmp    803da2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803d92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d95:	89 c2                	mov    %eax,%edx
  803d97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d9b:	88 10                	mov    %dl,(%rax)
	return 1;
  803d9d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803da2:	c9                   	leaveq 
  803da3:	c3                   	retq   

0000000000803da4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803da4:	55                   	push   %rbp
  803da5:	48 89 e5             	mov    %rsp,%rbp
  803da8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803daf:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803db6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803dbd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803dc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dcb:	eb 77                	jmp    803e44 <devcons_write+0xa0>
		m = n - tot;
  803dcd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803dd4:	89 c2                	mov    %eax,%edx
  803dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd9:	89 d1                	mov    %edx,%ecx
  803ddb:	29 c1                	sub    %eax,%ecx
  803ddd:	89 c8                	mov    %ecx,%eax
  803ddf:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803de2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de5:	83 f8 7f             	cmp    $0x7f,%eax
  803de8:	76 07                	jbe    803df1 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803dea:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803df1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803df4:	48 63 d0             	movslq %eax,%rdx
  803df7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dfa:	48 98                	cltq   
  803dfc:	48 89 c1             	mov    %rax,%rcx
  803dff:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803e06:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e0d:	48 89 ce             	mov    %rcx,%rsi
  803e10:	48 89 c7             	mov    %rax,%rdi
  803e13:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  803e1a:	00 00 00 
  803e1d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e22:	48 63 d0             	movslq %eax,%rdx
  803e25:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e2c:	48 89 d6             	mov    %rdx,%rsi
  803e2f:	48 89 c7             	mov    %rax,%rdi
  803e32:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  803e39:	00 00 00 
  803e3c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e41:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e47:	48 98                	cltq   
  803e49:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e50:	0f 82 77 ff ff ff    	jb     803dcd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e59:	c9                   	leaveq 
  803e5a:	c3                   	retq   

0000000000803e5b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e5b:	55                   	push   %rbp
  803e5c:	48 89 e5             	mov    %rsp,%rbp
  803e5f:	48 83 ec 08          	sub    $0x8,%rsp
  803e63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e6c:	c9                   	leaveq 
  803e6d:	c3                   	retq   

0000000000803e6e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e6e:	55                   	push   %rbp
  803e6f:	48 89 e5             	mov    %rsp,%rbp
  803e72:	48 83 ec 10          	sub    $0x10,%rsp
  803e76:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e82:	48 be c8 48 80 00 00 	movabs $0x8048c8,%rsi
  803e89:	00 00 00 
  803e8c:	48 89 c7             	mov    %rax,%rdi
  803e8f:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  803e96:	00 00 00 
  803e99:	ff d0                	callq  *%rax
	return 0;
  803e9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ea0:	c9                   	leaveq 
  803ea1:	c3                   	retq   
	...

0000000000803ea4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803ea4:	55                   	push   %rbp
  803ea5:	48 89 e5             	mov    %rsp,%rbp
  803ea8:	53                   	push   %rbx
  803ea9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803eb0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803eb7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803ebd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803ec4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803ecb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803ed2:	84 c0                	test   %al,%al
  803ed4:	74 23                	je     803ef9 <_panic+0x55>
  803ed6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803edd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803ee1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803ee5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803ee9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803eed:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803ef1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803ef5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803ef9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803f00:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803f07:	00 00 00 
  803f0a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803f11:	00 00 00 
  803f14:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803f18:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803f1f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803f26:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803f2d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803f34:	00 00 00 
  803f37:	48 8b 18             	mov    (%rax),%rbx
  803f3a:	48 b8 40 18 80 00 00 	movabs $0x801840,%rax
  803f41:	00 00 00 
  803f44:	ff d0                	callq  *%rax
  803f46:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803f4c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803f53:	41 89 c8             	mov    %ecx,%r8d
  803f56:	48 89 d1             	mov    %rdx,%rcx
  803f59:	48 89 da             	mov    %rbx,%rdx
  803f5c:	89 c6                	mov    %eax,%esi
  803f5e:	48 bf d0 48 80 00 00 	movabs $0x8048d0,%rdi
  803f65:	00 00 00 
  803f68:	b8 00 00 00 00       	mov    $0x0,%eax
  803f6d:	49 b9 b3 03 80 00 00 	movabs $0x8003b3,%r9
  803f74:	00 00 00 
  803f77:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803f7a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803f81:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803f88:	48 89 d6             	mov    %rdx,%rsi
  803f8b:	48 89 c7             	mov    %rax,%rdi
  803f8e:	48 b8 07 03 80 00 00 	movabs $0x800307,%rax
  803f95:	00 00 00 
  803f98:	ff d0                	callq  *%rax
	cprintf("\n");
  803f9a:	48 bf f3 48 80 00 00 	movabs $0x8048f3,%rdi
  803fa1:	00 00 00 
  803fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa9:	48 ba b3 03 80 00 00 	movabs $0x8003b3,%rdx
  803fb0:	00 00 00 
  803fb3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803fb5:	cc                   	int3   
  803fb6:	eb fd                	jmp    803fb5 <_panic+0x111>

0000000000803fb8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803fb8:	55                   	push   %rbp
  803fb9:	48 89 e5             	mov    %rsp,%rbp
  803fbc:	48 83 ec 30          	sub    $0x30,%rsp
  803fc0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fc4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fc8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  803fcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  803fd3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fd8:	74 18                	je     803ff2 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  803fda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fde:	48 89 c7             	mov    %rax,%rdi
  803fe1:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  803fe8:	00 00 00 
  803feb:	ff d0                	callq  *%rax
  803fed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ff0:	eb 19                	jmp    80400b <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  803ff2:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  803ff9:	00 00 00 
  803ffc:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  804003:	00 00 00 
  804006:	ff d0                	callq  *%rax
  804008:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  80400b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400f:	79 39                	jns    80404a <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  804011:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804016:	75 08                	jne    804020 <ipc_recv+0x68>
  804018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80401c:	8b 00                	mov    (%rax),%eax
  80401e:	eb 05                	jmp    804025 <ipc_recv+0x6d>
  804020:	b8 00 00 00 00       	mov    $0x0,%eax
  804025:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804029:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  80402b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804030:	75 08                	jne    80403a <ipc_recv+0x82>
  804032:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804036:	8b 00                	mov    (%rax),%eax
  804038:	eb 05                	jmp    80403f <ipc_recv+0x87>
  80403a:	b8 00 00 00 00       	mov    $0x0,%eax
  80403f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804043:	89 02                	mov    %eax,(%rdx)
		return r;
  804045:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804048:	eb 53                	jmp    80409d <ipc_recv+0xe5>
	}
	if(from_env_store) {
  80404a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80404f:	74 19                	je     80406a <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  804051:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804058:	00 00 00 
  80405b:	48 8b 00             	mov    (%rax),%rax
  80405e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804068:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  80406a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80406f:	74 19                	je     80408a <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  804071:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804078:	00 00 00 
  80407b:	48 8b 00             	mov    (%rax),%rax
  80407e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804084:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804088:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  80408a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804091:	00 00 00 
  804094:	48 8b 00             	mov    (%rax),%rax
  804097:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  80409d:	c9                   	leaveq 
  80409e:	c3                   	retq   

000000000080409f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80409f:	55                   	push   %rbp
  8040a0:	48 89 e5             	mov    %rsp,%rbp
  8040a3:	48 83 ec 30          	sub    $0x30,%rsp
  8040a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040aa:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8040ad:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8040b1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8040b4:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8040bb:	eb 59                	jmp    804116 <ipc_send+0x77>
		if(pg) {
  8040bd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8040c2:	74 20                	je     8040e4 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8040c4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8040c7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8040ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040d1:	89 c7                	mov    %eax,%edi
  8040d3:	48 b8 90 1a 80 00 00 	movabs $0x801a90,%rax
  8040da:	00 00 00 
  8040dd:	ff d0                	callq  *%rax
  8040df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040e2:	eb 26                	jmp    80410a <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8040e4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8040e7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8040ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040ed:	89 d1                	mov    %edx,%ecx
  8040ef:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8040f6:	00 00 00 
  8040f9:	89 c7                	mov    %eax,%edi
  8040fb:	48 b8 90 1a 80 00 00 	movabs $0x801a90,%rax
  804102:	00 00 00 
  804105:	ff d0                	callq  *%rax
  804107:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  80410a:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  804111:	00 00 00 
  804114:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  804116:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80411a:	74 a1                	je     8040bd <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  80411c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804120:	74 2a                	je     80414c <ipc_send+0xad>
		panic("something went wrong with sending the page");
  804122:	48 ba f8 48 80 00 00 	movabs $0x8048f8,%rdx
  804129:	00 00 00 
  80412c:	be 49 00 00 00       	mov    $0x49,%esi
  804131:	48 bf 23 49 80 00 00 	movabs $0x804923,%rdi
  804138:	00 00 00 
  80413b:	b8 00 00 00 00       	mov    $0x0,%eax
  804140:	48 b9 a4 3e 80 00 00 	movabs $0x803ea4,%rcx
  804147:	00 00 00 
  80414a:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  80414c:	c9                   	leaveq 
  80414d:	c3                   	retq   

000000000080414e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80414e:	55                   	push   %rbp
  80414f:	48 89 e5             	mov    %rsp,%rbp
  804152:	48 83 ec 18          	sub    $0x18,%rsp
  804156:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804160:	eb 6a                	jmp    8041cc <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  804162:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804169:	00 00 00 
  80416c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416f:	48 63 d0             	movslq %eax,%rdx
  804172:	48 89 d0             	mov    %rdx,%rax
  804175:	48 c1 e0 02          	shl    $0x2,%rax
  804179:	48 01 d0             	add    %rdx,%rax
  80417c:	48 01 c0             	add    %rax,%rax
  80417f:	48 01 d0             	add    %rdx,%rax
  804182:	48 c1 e0 05          	shl    $0x5,%rax
  804186:	48 01 c8             	add    %rcx,%rax
  804189:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80418f:	8b 00                	mov    (%rax),%eax
  804191:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804194:	75 32                	jne    8041c8 <ipc_find_env+0x7a>
			return envs[i].env_id;
  804196:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80419d:	00 00 00 
  8041a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041a3:	48 63 d0             	movslq %eax,%rdx
  8041a6:	48 89 d0             	mov    %rdx,%rax
  8041a9:	48 c1 e0 02          	shl    $0x2,%rax
  8041ad:	48 01 d0             	add    %rdx,%rax
  8041b0:	48 01 c0             	add    %rax,%rax
  8041b3:	48 01 d0             	add    %rdx,%rax
  8041b6:	48 c1 e0 05          	shl    $0x5,%rax
  8041ba:	48 01 c8             	add    %rcx,%rax
  8041bd:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8041c3:	8b 40 08             	mov    0x8(%rax),%eax
  8041c6:	eb 12                	jmp    8041da <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8041c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8041cc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8041d3:	7e 8d                	jle    804162 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8041d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041da:	c9                   	leaveq 
  8041db:	c3                   	retq   

00000000008041dc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8041dc:	55                   	push   %rbp
  8041dd:	48 89 e5             	mov    %rsp,%rbp
  8041e0:	48 83 ec 18          	sub    $0x18,%rsp
  8041e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8041e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041ec:	48 89 c2             	mov    %rax,%rdx
  8041ef:	48 c1 ea 15          	shr    $0x15,%rdx
  8041f3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8041fa:	01 00 00 
  8041fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804201:	83 e0 01             	and    $0x1,%eax
  804204:	48 85 c0             	test   %rax,%rax
  804207:	75 07                	jne    804210 <pageref+0x34>
		return 0;
  804209:	b8 00 00 00 00       	mov    $0x0,%eax
  80420e:	eb 53                	jmp    804263 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804214:	48 89 c2             	mov    %rax,%rdx
  804217:	48 c1 ea 0c          	shr    $0xc,%rdx
  80421b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804222:	01 00 00 
  804225:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804229:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80422d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804231:	83 e0 01             	and    $0x1,%eax
  804234:	48 85 c0             	test   %rax,%rax
  804237:	75 07                	jne    804240 <pageref+0x64>
		return 0;
  804239:	b8 00 00 00 00       	mov    $0x0,%eax
  80423e:	eb 23                	jmp    804263 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804240:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804244:	48 89 c2             	mov    %rax,%rdx
  804247:	48 c1 ea 0c          	shr    $0xc,%rdx
  80424b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804252:	00 00 00 
  804255:	48 c1 e2 04          	shl    $0x4,%rdx
  804259:	48 01 d0             	add    %rdx,%rax
  80425c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804260:	0f b7 c0             	movzwl %ax,%eax
}
  804263:	c9                   	leaveq 
  804264:	c3                   	retq   
