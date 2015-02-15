
obj/user/primes.debug:     file format elf64-x86-64


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
  80003c:	e8 97 01 00 00       	callq  8001d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	eb 01                	jmp    80004f <primeproc+0xb>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
		panic("fork: %e", id);
	if (id == 0)
		goto top;
  80004e:	90                   	nop
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800053:	ba 00 00 00 00       	mov    $0x0,%edx
  800058:	be 00 00 00 00       	mov    $0x0,%esi
  80005d:	48 89 c7             	mov    %rax,%rdi
  800060:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800076:	00 00 00 
  800079:	48 8b 00             	mov    (%rax),%rax
  80007c:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  800082:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800085:	89 c6                	mov    %eax,%esi
  800087:	48 bf 20 45 80 00 00 	movabs $0x804520,%rdi
  80008e:	00 00 00 
  800091:	b8 00 00 00 00       	mov    $0x0,%eax
  800096:	48 b9 df 04 80 00 00 	movabs $0x8004df,%rcx
  80009d:	00 00 00 
  8000a0:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  8000a2:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000b1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b5:	79 30                	jns    8000e7 <primeproc+0xa3>
		panic("fork: %e", id);
  8000b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000ba:	89 c1                	mov    %eax,%ecx
  8000bc:	48 ba 2c 45 80 00 00 	movabs $0x80452c,%rdx
  8000c3:	00 00 00 
  8000c6:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000cb:	48 bf 35 45 80 00 00 	movabs $0x804535,%rdi
  8000d2:	00 00 00 
  8000d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000da:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  8000e1:	00 00 00 
  8000e4:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000eb:	0f 84 5d ff ff ff    	je     80004e <primeproc+0xa>
  8000f1:	eb 01                	jmp    8000f4 <primeproc+0xb0>
	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
		if (i % p)
			ipc_send(id, i, 0, 0);
	}
  8000f3:	90                   	nop
	if (id == 0)
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000f4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000fd:	be 00 00 00 00       	mov    $0x0,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  80010c:	00 00 00 
  80010f:	ff d0                	callq  *%rax
  800111:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  800114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800117:	89 c2                	mov    %eax,%edx
  800119:	c1 fa 1f             	sar    $0x1f,%edx
  80011c:	f7 7d fc             	idivl  -0x4(%rbp)
  80011f:	89 d0                	mov    %edx,%eax
  800121:	85 c0                	test   %eax,%eax
  800123:	74 ce                	je     8000f3 <primeproc+0xaf>
			ipc_send(id, i, 0, 0);
  800125:	8b 75 f4             	mov    -0xc(%rbp),%esi
  800128:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80012b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	89 c7                	mov    %eax,%edi
  800137:	48 b8 83 25 80 00 00 	movabs $0x802583,%rax
  80013e:	00 00 00 
  800141:	ff d0                	callq  *%rax
	}
  800143:	eb ae                	jmp    8000f3 <primeproc+0xaf>

0000000000800145 <umain>:
}

void
umain(int argc, char **argv)
{
  800145:	55                   	push   %rbp
  800146:	48 89 e5             	mov    %rsp,%rbp
  800149:	48 83 ec 20          	sub    $0x20,%rsp
  80014d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800150:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  800154:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	callq  *%rax
  800160:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800163:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800167:	79 30                	jns    800199 <umain+0x54>
		panic("fork: %e", id);
  800169:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80016c:	89 c1                	mov    %eax,%ecx
  80016e:	48 ba 2c 45 80 00 00 	movabs $0x80452c,%rdx
  800175:	00 00 00 
  800178:	be 2d 00 00 00       	mov    $0x2d,%esi
  80017d:	48 bf 35 45 80 00 00 	movabs $0x804535,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  800193:	00 00 00 
  800196:	41 ff d0             	callq  *%r8
	if (id == 0)
  800199:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80019d:	75 0c                	jne    8001ab <umain+0x66>
		primeproc();
  80019f:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001ab:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001b2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c2:	89 c7                	mov    %eax,%edi
  8001c4:	48 b8 83 25 80 00 00 	movabs $0x802583,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001d4:	eb dc                	jmp    8001b2 <umain+0x6d>
	...

00000000008001d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d8:	55                   	push   %rbp
  8001d9:	48 89 e5             	mov    %rsp,%rbp
  8001dc:	48 83 ec 10          	sub    $0x10,%rsp
  8001e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001e7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001ee:	00 00 00 
  8001f1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8001f8:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	48 98                	cltq   
  800206:	48 89 c2             	mov    %rax,%rdx
  800209:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80020f:	48 89 d0             	mov    %rdx,%rax
  800212:	48 c1 e0 02          	shl    $0x2,%rax
  800216:	48 01 d0             	add    %rdx,%rax
  800219:	48 01 c0             	add    %rax,%rax
  80021c:	48 01 d0             	add    %rdx,%rax
  80021f:	48 c1 e0 05          	shl    $0x5,%rax
  800223:	48 89 c2             	mov    %rax,%rdx
  800226:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80022d:	00 00 00 
  800230:	48 01 c2             	add    %rax,%rdx
  800233:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80023a:	00 00 00 
  80023d:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800240:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800244:	7e 14                	jle    80025a <libmain+0x82>
		binaryname = argv[0];
  800246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024a:	48 8b 10             	mov    (%rax),%rdx
  80024d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800254:	00 00 00 
  800257:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80025a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80025e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800261:	48 89 d6             	mov    %rdx,%rsi
  800264:	89 c7                	mov    %eax,%edi
  800266:	48 b8 45 01 80 00 00 	movabs $0x800145,%rax
  80026d:	00 00 00 
  800270:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800272:	48 b8 80 02 80 00 00 	movabs $0x800280,%rax
  800279:	00 00 00 
  80027c:	ff d0                	callq  *%rax
}
  80027e:	c9                   	leaveq 
  80027f:	c3                   	retq   

0000000000800280 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800280:	55                   	push   %rbp
  800281:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800284:	48 b8 01 2a 80 00 00 	movabs $0x802a01,%rax
  80028b:	00 00 00 
  80028e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800290:	bf 00 00 00 00       	mov    $0x0,%edi
  800295:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  80029c:	00 00 00 
  80029f:	ff d0                	callq  *%rax
}
  8002a1:	5d                   	pop    %rbp
  8002a2:	c3                   	retq   
	...

00000000008002a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a4:	55                   	push   %rbp
  8002a5:	48 89 e5             	mov    %rsp,%rbp
  8002a8:	53                   	push   %rbx
  8002a9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002b0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002b7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002bd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002c4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002cb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002d2:	84 c0                	test   %al,%al
  8002d4:	74 23                	je     8002f9 <_panic+0x55>
  8002d6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002dd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002e1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002e5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002e9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002ed:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002f1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002f5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002f9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800300:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800307:	00 00 00 
  80030a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800311:	00 00 00 
  800314:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800318:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80031f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800326:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80032d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800334:	00 00 00 
  800337:	48 8b 18             	mov    (%rax),%rbx
  80033a:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  800341:	00 00 00 
  800344:	ff d0                	callq  *%rax
  800346:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80034c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800353:	41 89 c8             	mov    %ecx,%r8d
  800356:	48 89 d1             	mov    %rdx,%rcx
  800359:	48 89 da             	mov    %rbx,%rdx
  80035c:	89 c6                	mov    %eax,%esi
  80035e:	48 bf 50 45 80 00 00 	movabs $0x804550,%rdi
  800365:	00 00 00 
  800368:	b8 00 00 00 00       	mov    $0x0,%eax
  80036d:	49 b9 df 04 80 00 00 	movabs $0x8004df,%r9
  800374:	00 00 00 
  800377:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80037a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800381:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800388:	48 89 d6             	mov    %rdx,%rsi
  80038b:	48 89 c7             	mov    %rax,%rdi
  80038e:	48 b8 33 04 80 00 00 	movabs $0x800433,%rax
  800395:	00 00 00 
  800398:	ff d0                	callq  *%rax
	cprintf("\n");
  80039a:	48 bf 73 45 80 00 00 	movabs $0x804573,%rdi
  8003a1:	00 00 00 
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	48 ba df 04 80 00 00 	movabs $0x8004df,%rdx
  8003b0:	00 00 00 
  8003b3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003b5:	cc                   	int3   
  8003b6:	eb fd                	jmp    8003b5 <_panic+0x111>

00000000008003b8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003b8:	55                   	push   %rbp
  8003b9:	48 89 e5             	mov    %rsp,%rbp
  8003bc:	48 83 ec 10          	sub    $0x10,%rsp
  8003c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cb:	8b 00                	mov    (%rax),%eax
  8003cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003d0:	89 d6                	mov    %edx,%esi
  8003d2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003d6:	48 63 d0             	movslq %eax,%rdx
  8003d9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8003de:	8d 50 01             	lea    0x1(%rax),%edx
  8003e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e5:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8003e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003eb:	8b 00                	mov    (%rax),%eax
  8003ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f2:	75 2c                	jne    800420 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8003f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f8:	8b 00                	mov    (%rax),%eax
  8003fa:	48 98                	cltq   
  8003fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800400:	48 83 c2 08          	add    $0x8,%rdx
  800404:	48 89 c6             	mov    %rax,%rsi
  800407:	48 89 d7             	mov    %rdx,%rdi
  80040a:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  800411:	00 00 00 
  800414:	ff d0                	callq  *%rax
        b->idx = 0;
  800416:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800424:	8b 40 04             	mov    0x4(%rax),%eax
  800427:	8d 50 01             	lea    0x1(%rax),%edx
  80042a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800431:	c9                   	leaveq 
  800432:	c3                   	retq   

0000000000800433 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800433:	55                   	push   %rbp
  800434:	48 89 e5             	mov    %rsp,%rbp
  800437:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80043e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800445:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80044c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800453:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80045a:	48 8b 0a             	mov    (%rdx),%rcx
  80045d:	48 89 08             	mov    %rcx,(%rax)
  800460:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800464:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800468:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80046c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800470:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800477:	00 00 00 
    b.cnt = 0;
  80047a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800481:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800484:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80048b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800492:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800499:	48 89 c6             	mov    %rax,%rsi
  80049c:	48 bf b8 03 80 00 00 	movabs $0x8003b8,%rdi
  8004a3:	00 00 00 
  8004a6:	48 b8 90 08 80 00 00 	movabs $0x800890,%rax
  8004ad:	00 00 00 
  8004b0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004b2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004b8:	48 98                	cltq   
  8004ba:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004c1:	48 83 c2 08          	add    $0x8,%rdx
  8004c5:	48 89 c6             	mov    %rax,%rsi
  8004c8:	48 89 d7             	mov    %rdx,%rdi
  8004cb:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  8004d2:	00 00 00 
  8004d5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004dd:	c9                   	leaveq 
  8004de:	c3                   	retq   

00000000008004df <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004df:	55                   	push   %rbp
  8004e0:	48 89 e5             	mov    %rsp,%rbp
  8004e3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004ea:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004f1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004f8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004ff:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800506:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80050d:	84 c0                	test   %al,%al
  80050f:	74 20                	je     800531 <cprintf+0x52>
  800511:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800515:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800519:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80051d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800521:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800525:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800529:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80052d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800531:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800538:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80053f:	00 00 00 
  800542:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800549:	00 00 00 
  80054c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800550:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800557:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80055e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800565:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80056c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800573:	48 8b 0a             	mov    (%rdx),%rcx
  800576:	48 89 08             	mov    %rcx,(%rax)
  800579:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80057d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800581:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800585:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800589:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800590:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800597:	48 89 d6             	mov    %rdx,%rsi
  80059a:	48 89 c7             	mov    %rax,%rdi
  80059d:	48 b8 33 04 80 00 00 	movabs $0x800433,%rax
  8005a4:	00 00 00 
  8005a7:	ff d0                	callq  *%rax
  8005a9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005af:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005b5:	c9                   	leaveq 
  8005b6:	c3                   	retq   
	...

00000000008005b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b8:	55                   	push   %rbp
  8005b9:	48 89 e5             	mov    %rsp,%rbp
  8005bc:	48 83 ec 30          	sub    $0x30,%rsp
  8005c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005cc:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005cf:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005d3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005da:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005de:	77 52                	ja     800632 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005e0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005e3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005e7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005ea:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8005ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f7:	48 f7 75 d0          	divq   -0x30(%rbp)
  8005fb:	48 89 c2             	mov    %rax,%rdx
  8005fe:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800601:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800604:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060c:	41 89 f9             	mov    %edi,%r9d
  80060f:	48 89 c7             	mov    %rax,%rdi
  800612:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  800619:	00 00 00 
  80061c:	ff d0                	callq  *%rax
  80061e:	eb 1c                	jmp    80063c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800620:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800624:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800627:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80062b:	48 89 d6             	mov    %rdx,%rsi
  80062e:	89 c7                	mov    %eax,%edi
  800630:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800632:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800636:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80063a:	7f e4                	jg     800620 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80063c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80063f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800643:	ba 00 00 00 00       	mov    $0x0,%edx
  800648:	48 f7 f1             	div    %rcx
  80064b:	48 89 d0             	mov    %rdx,%rax
  80064e:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  800655:	00 00 00 
  800658:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80065c:	0f be c0             	movsbl %al,%eax
  80065f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800663:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800667:	48 89 d6             	mov    %rdx,%rsi
  80066a:	89 c7                	mov    %eax,%edi
  80066c:	ff d1                	callq  *%rcx
}
  80066e:	c9                   	leaveq 
  80066f:	c3                   	retq   

0000000000800670 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800670:	55                   	push   %rbp
  800671:	48 89 e5             	mov    %rsp,%rbp
  800674:	48 83 ec 20          	sub    $0x20,%rsp
  800678:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80067c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80067f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800683:	7e 52                	jle    8006d7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800689:	8b 00                	mov    (%rax),%eax
  80068b:	83 f8 30             	cmp    $0x30,%eax
  80068e:	73 24                	jae    8006b4 <getuint+0x44>
  800690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800694:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069c:	8b 00                	mov    (%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 01 d0             	add    %rdx,%rax
  8006a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a7:	8b 12                	mov    (%rdx),%edx
  8006a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b0:	89 0a                	mov    %ecx,(%rdx)
  8006b2:	eb 17                	jmp    8006cb <getuint+0x5b>
  8006b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006bc:	48 89 d0             	mov    %rdx,%rax
  8006bf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cb:	48 8b 00             	mov    (%rax),%rax
  8006ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d2:	e9 a3 00 00 00       	jmpq   80077a <getuint+0x10a>
	else if (lflag)
  8006d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006db:	74 4f                	je     80072c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e1:	8b 00                	mov    (%rax),%eax
  8006e3:	83 f8 30             	cmp    $0x30,%eax
  8006e6:	73 24                	jae    80070c <getuint+0x9c>
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f4:	8b 00                	mov    (%rax),%eax
  8006f6:	89 c0                	mov    %eax,%eax
  8006f8:	48 01 d0             	add    %rdx,%rax
  8006fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ff:	8b 12                	mov    (%rdx),%edx
  800701:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800704:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800708:	89 0a                	mov    %ecx,(%rdx)
  80070a:	eb 17                	jmp    800723 <getuint+0xb3>
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800714:	48 89 d0             	mov    %rdx,%rax
  800717:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800723:	48 8b 00             	mov    (%rax),%rax
  800726:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072a:	eb 4e                	jmp    80077a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80072c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800730:	8b 00                	mov    (%rax),%eax
  800732:	83 f8 30             	cmp    $0x30,%eax
  800735:	73 24                	jae    80075b <getuint+0xeb>
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800743:	8b 00                	mov    (%rax),%eax
  800745:	89 c0                	mov    %eax,%eax
  800747:	48 01 d0             	add    %rdx,%rax
  80074a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074e:	8b 12                	mov    (%rdx),%edx
  800750:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800753:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800757:	89 0a                	mov    %ecx,(%rdx)
  800759:	eb 17                	jmp    800772 <getuint+0x102>
  80075b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800763:	48 89 d0             	mov    %rdx,%rax
  800766:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800772:	8b 00                	mov    (%rax),%eax
  800774:	89 c0                	mov    %eax,%eax
  800776:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80077a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80077e:	c9                   	leaveq 
  80077f:	c3                   	retq   

0000000000800780 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800780:	55                   	push   %rbp
  800781:	48 89 e5             	mov    %rsp,%rbp
  800784:	48 83 ec 20          	sub    $0x20,%rsp
  800788:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80078c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80078f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800793:	7e 52                	jle    8007e7 <getint+0x67>
		x=va_arg(*ap, long long);
  800795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800799:	8b 00                	mov    (%rax),%eax
  80079b:	83 f8 30             	cmp    $0x30,%eax
  80079e:	73 24                	jae    8007c4 <getint+0x44>
  8007a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ac:	8b 00                	mov    (%rax),%eax
  8007ae:	89 c0                	mov    %eax,%eax
  8007b0:	48 01 d0             	add    %rdx,%rax
  8007b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b7:	8b 12                	mov    (%rdx),%edx
  8007b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c0:	89 0a                	mov    %ecx,(%rdx)
  8007c2:	eb 17                	jmp    8007db <getint+0x5b>
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007cc:	48 89 d0             	mov    %rdx,%rax
  8007cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007db:	48 8b 00             	mov    (%rax),%rax
  8007de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e2:	e9 a3 00 00 00       	jmpq   80088a <getint+0x10a>
	else if (lflag)
  8007e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007eb:	74 4f                	je     80083c <getint+0xbc>
		x=va_arg(*ap, long);
  8007ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f1:	8b 00                	mov    (%rax),%eax
  8007f3:	83 f8 30             	cmp    $0x30,%eax
  8007f6:	73 24                	jae    80081c <getint+0x9c>
  8007f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800804:	8b 00                	mov    (%rax),%eax
  800806:	89 c0                	mov    %eax,%eax
  800808:	48 01 d0             	add    %rdx,%rax
  80080b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080f:	8b 12                	mov    (%rdx),%edx
  800811:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800818:	89 0a                	mov    %ecx,(%rdx)
  80081a:	eb 17                	jmp    800833 <getint+0xb3>
  80081c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800820:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800824:	48 89 d0             	mov    %rdx,%rax
  800827:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800833:	48 8b 00             	mov    (%rax),%rax
  800836:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083a:	eb 4e                	jmp    80088a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80083c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800840:	8b 00                	mov    (%rax),%eax
  800842:	83 f8 30             	cmp    $0x30,%eax
  800845:	73 24                	jae    80086b <getint+0xeb>
  800847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800853:	8b 00                	mov    (%rax),%eax
  800855:	89 c0                	mov    %eax,%eax
  800857:	48 01 d0             	add    %rdx,%rax
  80085a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085e:	8b 12                	mov    (%rdx),%edx
  800860:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800863:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800867:	89 0a                	mov    %ecx,(%rdx)
  800869:	eb 17                	jmp    800882 <getint+0x102>
  80086b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800873:	48 89 d0             	mov    %rdx,%rax
  800876:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800882:	8b 00                	mov    (%rax),%eax
  800884:	48 98                	cltq   
  800886:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80088a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80088e:	c9                   	leaveq 
  80088f:	c3                   	retq   

0000000000800890 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800890:	55                   	push   %rbp
  800891:	48 89 e5             	mov    %rsp,%rbp
  800894:	41 54                	push   %r12
  800896:	53                   	push   %rbx
  800897:	48 83 ec 60          	sub    $0x60,%rsp
  80089b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80089f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008a3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008ab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008af:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008b3:	48 8b 0a             	mov    (%rdx),%rcx
  8008b6:	48 89 08             	mov    %rcx,(%rax)
  8008b9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008bd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008c1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008c5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c9:	eb 17                	jmp    8008e2 <vprintfmt+0x52>
			if (ch == '\0')
  8008cb:	85 db                	test   %ebx,%ebx
  8008cd:	0f 84 ea 04 00 00    	je     800dbd <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  8008d3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8008d7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8008db:	48 89 c6             	mov    %rax,%rsi
  8008de:	89 df                	mov    %ebx,%edi
  8008e0:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e6:	0f b6 00             	movzbl (%rax),%eax
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	83 fb 25             	cmp    $0x25,%ebx
  8008ef:	0f 95 c0             	setne  %al
  8008f2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008f7:	84 c0                	test   %al,%al
  8008f9:	75 d0                	jne    8008cb <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008fb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008ff:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800906:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80090d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800914:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80091b:	eb 04                	jmp    800921 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80091d:	90                   	nop
  80091e:	eb 01                	jmp    800921 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800920:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800921:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800925:	0f b6 00             	movzbl (%rax),%eax
  800928:	0f b6 d8             	movzbl %al,%ebx
  80092b:	89 d8                	mov    %ebx,%eax
  80092d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800932:	83 e8 23             	sub    $0x23,%eax
  800935:	83 f8 55             	cmp    $0x55,%eax
  800938:	0f 87 4b 04 00 00    	ja     800d89 <vprintfmt+0x4f9>
  80093e:	89 c0                	mov    %eax,%eax
  800940:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800947:	00 
  800948:	48 b8 98 47 80 00 00 	movabs $0x804798,%rax
  80094f:	00 00 00 
  800952:	48 01 d0             	add    %rdx,%rax
  800955:	48 8b 00             	mov    (%rax),%rax
  800958:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80095a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80095e:	eb c1                	jmp    800921 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800960:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800964:	eb bb                	jmp    800921 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800966:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80096d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800970:	89 d0                	mov    %edx,%eax
  800972:	c1 e0 02             	shl    $0x2,%eax
  800975:	01 d0                	add    %edx,%eax
  800977:	01 c0                	add    %eax,%eax
  800979:	01 d8                	add    %ebx,%eax
  80097b:	83 e8 30             	sub    $0x30,%eax
  80097e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800981:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800985:	0f b6 00             	movzbl (%rax),%eax
  800988:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80098b:	83 fb 2f             	cmp    $0x2f,%ebx
  80098e:	7e 63                	jle    8009f3 <vprintfmt+0x163>
  800990:	83 fb 39             	cmp    $0x39,%ebx
  800993:	7f 5e                	jg     8009f3 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800995:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80099a:	eb d1                	jmp    80096d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80099c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099f:	83 f8 30             	cmp    $0x30,%eax
  8009a2:	73 17                	jae    8009bb <vprintfmt+0x12b>
  8009a4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ab:	89 c0                	mov    %eax,%eax
  8009ad:	48 01 d0             	add    %rdx,%rax
  8009b0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b3:	83 c2 08             	add    $0x8,%edx
  8009b6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009b9:	eb 0f                	jmp    8009ca <vprintfmt+0x13a>
  8009bb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009bf:	48 89 d0             	mov    %rdx,%rax
  8009c2:	48 83 c2 08          	add    $0x8,%rdx
  8009c6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ca:	8b 00                	mov    (%rax),%eax
  8009cc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009cf:	eb 23                	jmp    8009f4 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8009d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d5:	0f 89 42 ff ff ff    	jns    80091d <vprintfmt+0x8d>
				width = 0;
  8009db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009e2:	e9 36 ff ff ff       	jmpq   80091d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8009e7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009ee:	e9 2e ff ff ff       	jmpq   800921 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009f3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f8:	0f 89 22 ff ff ff    	jns    800920 <vprintfmt+0x90>
				width = precision, precision = -1;
  8009fe:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a01:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a04:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a0b:	e9 10 ff ff ff       	jmpq   800920 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a10:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a14:	e9 08 ff ff ff       	jmpq   800921 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1c:	83 f8 30             	cmp    $0x30,%eax
  800a1f:	73 17                	jae    800a38 <vprintfmt+0x1a8>
  800a21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a28:	89 c0                	mov    %eax,%eax
  800a2a:	48 01 d0             	add    %rdx,%rax
  800a2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a30:	83 c2 08             	add    $0x8,%edx
  800a33:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a36:	eb 0f                	jmp    800a47 <vprintfmt+0x1b7>
  800a38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3c:	48 89 d0             	mov    %rdx,%rax
  800a3f:	48 83 c2 08          	add    $0x8,%rdx
  800a43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a47:	8b 00                	mov    (%rax),%eax
  800a49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a51:	48 89 d6             	mov    %rdx,%rsi
  800a54:	89 c7                	mov    %eax,%edi
  800a56:	ff d1                	callq  *%rcx
			break;
  800a58:	e9 5a 03 00 00       	jmpq   800db7 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a60:	83 f8 30             	cmp    $0x30,%eax
  800a63:	73 17                	jae    800a7c <vprintfmt+0x1ec>
  800a65:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6c:	89 c0                	mov    %eax,%eax
  800a6e:	48 01 d0             	add    %rdx,%rax
  800a71:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a74:	83 c2 08             	add    $0x8,%edx
  800a77:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a7a:	eb 0f                	jmp    800a8b <vprintfmt+0x1fb>
  800a7c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a80:	48 89 d0             	mov    %rdx,%rax
  800a83:	48 83 c2 08          	add    $0x8,%rdx
  800a87:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a8b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	79 02                	jns    800a93 <vprintfmt+0x203>
				err = -err;
  800a91:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a93:	83 fb 15             	cmp    $0x15,%ebx
  800a96:	7f 16                	jg     800aae <vprintfmt+0x21e>
  800a98:	48 b8 c0 46 80 00 00 	movabs $0x8046c0,%rax
  800a9f:	00 00 00 
  800aa2:	48 63 d3             	movslq %ebx,%rdx
  800aa5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800aa9:	4d 85 e4             	test   %r12,%r12
  800aac:	75 2e                	jne    800adc <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800aae:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab6:	89 d9                	mov    %ebx,%ecx
  800ab8:	48 ba 81 47 80 00 00 	movabs $0x804781,%rdx
  800abf:	00 00 00 
  800ac2:	48 89 c7             	mov    %rax,%rdi
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	49 b8 c7 0d 80 00 00 	movabs $0x800dc7,%r8
  800ad1:	00 00 00 
  800ad4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad7:	e9 db 02 00 00       	jmpq   800db7 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800adc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ae0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae4:	4c 89 e1             	mov    %r12,%rcx
  800ae7:	48 ba 8a 47 80 00 00 	movabs $0x80478a,%rdx
  800aee:	00 00 00 
  800af1:	48 89 c7             	mov    %rax,%rdi
  800af4:	b8 00 00 00 00       	mov    $0x0,%eax
  800af9:	49 b8 c7 0d 80 00 00 	movabs $0x800dc7,%r8
  800b00:	00 00 00 
  800b03:	41 ff d0             	callq  *%r8
			break;
  800b06:	e9 ac 02 00 00       	jmpq   800db7 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0e:	83 f8 30             	cmp    $0x30,%eax
  800b11:	73 17                	jae    800b2a <vprintfmt+0x29a>
  800b13:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1a:	89 c0                	mov    %eax,%eax
  800b1c:	48 01 d0             	add    %rdx,%rax
  800b1f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b22:	83 c2 08             	add    $0x8,%edx
  800b25:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b28:	eb 0f                	jmp    800b39 <vprintfmt+0x2a9>
  800b2a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2e:	48 89 d0             	mov    %rdx,%rax
  800b31:	48 83 c2 08          	add    $0x8,%rdx
  800b35:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b39:	4c 8b 20             	mov    (%rax),%r12
  800b3c:	4d 85 e4             	test   %r12,%r12
  800b3f:	75 0a                	jne    800b4b <vprintfmt+0x2bb>
				p = "(null)";
  800b41:	49 bc 8d 47 80 00 00 	movabs $0x80478d,%r12
  800b48:	00 00 00 
			if (width > 0 && padc != '-')
  800b4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b4f:	7e 7a                	jle    800bcb <vprintfmt+0x33b>
  800b51:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b55:	74 74                	je     800bcb <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b57:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b5a:	48 98                	cltq   
  800b5c:	48 89 c6             	mov    %rax,%rsi
  800b5f:	4c 89 e7             	mov    %r12,%rdi
  800b62:	48 b8 72 10 80 00 00 	movabs $0x801072,%rax
  800b69:	00 00 00 
  800b6c:	ff d0                	callq  *%rax
  800b6e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b71:	eb 17                	jmp    800b8a <vprintfmt+0x2fa>
					putch(padc, putdat);
  800b73:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800b77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b7f:	48 89 d6             	mov    %rdx,%rsi
  800b82:	89 c7                	mov    %eax,%edi
  800b84:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b86:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b8e:	7f e3                	jg     800b73 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b90:	eb 39                	jmp    800bcb <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800b92:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b96:	74 1e                	je     800bb6 <vprintfmt+0x326>
  800b98:	83 fb 1f             	cmp    $0x1f,%ebx
  800b9b:	7e 05                	jle    800ba2 <vprintfmt+0x312>
  800b9d:	83 fb 7e             	cmp    $0x7e,%ebx
  800ba0:	7e 14                	jle    800bb6 <vprintfmt+0x326>
					putch('?', putdat);
  800ba2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ba6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800baa:	48 89 c6             	mov    %rax,%rsi
  800bad:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bb2:	ff d2                	callq  *%rdx
  800bb4:	eb 0f                	jmp    800bc5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800bb6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bba:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bbe:	48 89 c6             	mov    %rax,%rsi
  800bc1:	89 df                	mov    %ebx,%edi
  800bc3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bc9:	eb 01                	jmp    800bcc <vprintfmt+0x33c>
  800bcb:	90                   	nop
  800bcc:	41 0f b6 04 24       	movzbl (%r12),%eax
  800bd1:	0f be d8             	movsbl %al,%ebx
  800bd4:	85 db                	test   %ebx,%ebx
  800bd6:	0f 95 c0             	setne  %al
  800bd9:	49 83 c4 01          	add    $0x1,%r12
  800bdd:	84 c0                	test   %al,%al
  800bdf:	74 28                	je     800c09 <vprintfmt+0x379>
  800be1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800be5:	78 ab                	js     800b92 <vprintfmt+0x302>
  800be7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800beb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bef:	79 a1                	jns    800b92 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf1:	eb 16                	jmp    800c09 <vprintfmt+0x379>
				putch(' ', putdat);
  800bf3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bf7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bfb:	48 89 c6             	mov    %rax,%rsi
  800bfe:	bf 20 00 00 00       	mov    $0x20,%edi
  800c03:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c05:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c09:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c0d:	7f e4                	jg     800bf3 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c0f:	e9 a3 01 00 00       	jmpq   800db7 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c14:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c18:	be 03 00 00 00       	mov    $0x3,%esi
  800c1d:	48 89 c7             	mov    %rax,%rdi
  800c20:	48 b8 80 07 80 00 00 	movabs $0x800780,%rax
  800c27:	00 00 00 
  800c2a:	ff d0                	callq  *%rax
  800c2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c34:	48 85 c0             	test   %rax,%rax
  800c37:	79 1d                	jns    800c56 <vprintfmt+0x3c6>
				putch('-', putdat);
  800c39:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c3d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c41:	48 89 c6             	mov    %rax,%rsi
  800c44:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c49:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4f:	48 f7 d8             	neg    %rax
  800c52:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c56:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c5d:	e9 e8 00 00 00       	jmpq   800d4a <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c62:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c66:	be 03 00 00 00       	mov    $0x3,%esi
  800c6b:	48 89 c7             	mov    %rax,%rdi
  800c6e:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  800c75:	00 00 00 
  800c78:	ff d0                	callq  *%rax
  800c7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c7e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c85:	e9 c0 00 00 00       	jmpq   800d4a <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c8a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c8e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c92:	48 89 c6             	mov    %rax,%rsi
  800c95:	bf 58 00 00 00       	mov    $0x58,%edi
  800c9a:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800c9c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ca0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ca4:	48 89 c6             	mov    %rax,%rsi
  800ca7:	bf 58 00 00 00       	mov    $0x58,%edi
  800cac:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800cae:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cb2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cb6:	48 89 c6             	mov    %rax,%rsi
  800cb9:	bf 58 00 00 00       	mov    $0x58,%edi
  800cbe:	ff d2                	callq  *%rdx
			break;
  800cc0:	e9 f2 00 00 00       	jmpq   800db7 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800cc5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cc9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ccd:	48 89 c6             	mov    %rax,%rsi
  800cd0:	bf 30 00 00 00       	mov    $0x30,%edi
  800cd5:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800cd7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cdb:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cdf:	48 89 c6             	mov    %rax,%rsi
  800ce2:	bf 78 00 00 00       	mov    $0x78,%edi
  800ce7:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ce9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cec:	83 f8 30             	cmp    $0x30,%eax
  800cef:	73 17                	jae    800d08 <vprintfmt+0x478>
  800cf1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf8:	89 c0                	mov    %eax,%eax
  800cfa:	48 01 d0             	add    %rdx,%rax
  800cfd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d00:	83 c2 08             	add    $0x8,%edx
  800d03:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d06:	eb 0f                	jmp    800d17 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800d08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d0c:	48 89 d0             	mov    %rdx,%rax
  800d0f:	48 83 c2 08          	add    $0x8,%rdx
  800d13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d17:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d1e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d25:	eb 23                	jmp    800d4a <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d2b:	be 03 00 00 00       	mov    $0x3,%esi
  800d30:	48 89 c7             	mov    %rax,%rdi
  800d33:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  800d3a:	00 00 00 
  800d3d:	ff d0                	callq  *%rax
  800d3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d43:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d4a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d4f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d52:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d59:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d61:	45 89 c1             	mov    %r8d,%r9d
  800d64:	41 89 f8             	mov    %edi,%r8d
  800d67:	48 89 c7             	mov    %rax,%rdi
  800d6a:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  800d71:	00 00 00 
  800d74:	ff d0                	callq  *%rax
			break;
  800d76:	eb 3f                	jmp    800db7 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d78:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d7c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d80:	48 89 c6             	mov    %rax,%rsi
  800d83:	89 df                	mov    %ebx,%edi
  800d85:	ff d2                	callq  *%rdx
			break;
  800d87:	eb 2e                	jmp    800db7 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d89:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d8d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d91:	48 89 c6             	mov    %rax,%rsi
  800d94:	bf 25 00 00 00       	mov    $0x25,%edi
  800d99:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d9b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800da0:	eb 05                	jmp    800da7 <vprintfmt+0x517>
  800da2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800da7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dab:	48 83 e8 01          	sub    $0x1,%rax
  800daf:	0f b6 00             	movzbl (%rax),%eax
  800db2:	3c 25                	cmp    $0x25,%al
  800db4:	75 ec                	jne    800da2 <vprintfmt+0x512>
				/* do nothing */;
			break;
  800db6:	90                   	nop
		}
	}
  800db7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db8:	e9 25 fb ff ff       	jmpq   8008e2 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800dbd:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dbe:	48 83 c4 60          	add    $0x60,%rsp
  800dc2:	5b                   	pop    %rbx
  800dc3:	41 5c                	pop    %r12
  800dc5:	5d                   	pop    %rbp
  800dc6:	c3                   	retq   

0000000000800dc7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dc7:	55                   	push   %rbp
  800dc8:	48 89 e5             	mov    %rsp,%rbp
  800dcb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dd2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dd9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800de0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800de7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dee:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800df5:	84 c0                	test   %al,%al
  800df7:	74 20                	je     800e19 <printfmt+0x52>
  800df9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dfd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e01:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e05:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e09:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e0d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e11:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e15:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e19:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e20:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e27:	00 00 00 
  800e2a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e31:	00 00 00 
  800e34:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e38:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e3f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e46:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e4d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e54:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e5b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e62:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e69:	48 89 c7             	mov    %rax,%rdi
  800e6c:	48 b8 90 08 80 00 00 	movabs $0x800890,%rax
  800e73:	00 00 00 
  800e76:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e78:	c9                   	leaveq 
  800e79:	c3                   	retq   

0000000000800e7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e7a:	55                   	push   %rbp
  800e7b:	48 89 e5             	mov    %rsp,%rbp
  800e7e:	48 83 ec 10          	sub    $0x10,%rsp
  800e82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8d:	8b 40 10             	mov    0x10(%rax),%eax
  800e90:	8d 50 01             	lea    0x1(%rax),%edx
  800e93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e97:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9e:	48 8b 10             	mov    (%rax),%rdx
  800ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea5:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ea9:	48 39 c2             	cmp    %rax,%rdx
  800eac:	73 17                	jae    800ec5 <sprintputch+0x4b>
		*b->buf++ = ch;
  800eae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb2:	48 8b 00             	mov    (%rax),%rax
  800eb5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eb8:	88 10                	mov    %dl,(%rax)
  800eba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec2:	48 89 10             	mov    %rdx,(%rax)
}
  800ec5:	c9                   	leaveq 
  800ec6:	c3                   	retq   

0000000000800ec7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ec7:	55                   	push   %rbp
  800ec8:	48 89 e5             	mov    %rsp,%rbp
  800ecb:	48 83 ec 50          	sub    $0x50,%rsp
  800ecf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ed3:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ed6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800eda:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ede:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ee2:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ee6:	48 8b 0a             	mov    (%rdx),%rcx
  800ee9:	48 89 08             	mov    %rcx,(%rax)
  800eec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ef0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ef4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ef8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800efc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f00:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f04:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f07:	48 98                	cltq   
  800f09:	48 83 e8 01          	sub    $0x1,%rax
  800f0d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800f11:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f15:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f1c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f21:	74 06                	je     800f29 <vsnprintf+0x62>
  800f23:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f27:	7f 07                	jg     800f30 <vsnprintf+0x69>
		return -E_INVAL;
  800f29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2e:	eb 2f                	jmp    800f5f <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f30:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f34:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f38:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f3c:	48 89 c6             	mov    %rax,%rsi
  800f3f:	48 bf 7a 0e 80 00 00 	movabs $0x800e7a,%rdi
  800f46:	00 00 00 
  800f49:	48 b8 90 08 80 00 00 	movabs $0x800890,%rax
  800f50:	00 00 00 
  800f53:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f59:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f5c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f5f:	c9                   	leaveq 
  800f60:	c3                   	retq   

0000000000800f61 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f61:	55                   	push   %rbp
  800f62:	48 89 e5             	mov    %rsp,%rbp
  800f65:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f6c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f73:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f79:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f80:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f87:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f8e:	84 c0                	test   %al,%al
  800f90:	74 20                	je     800fb2 <snprintf+0x51>
  800f92:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f96:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f9a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f9e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fa6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800faa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fae:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fb9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fc0:	00 00 00 
  800fc3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fca:	00 00 00 
  800fcd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fd8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fdf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fe6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fed:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ff4:	48 8b 0a             	mov    (%rdx),%rcx
  800ff7:	48 89 08             	mov    %rcx,(%rax)
  800ffa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ffe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801002:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801006:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80100a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801011:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801018:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80101e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801025:	48 89 c7             	mov    %rax,%rdi
  801028:	48 b8 c7 0e 80 00 00 	movabs $0x800ec7,%rax
  80102f:	00 00 00 
  801032:	ff d0                	callq  *%rax
  801034:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80103a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801040:	c9                   	leaveq 
  801041:	c3                   	retq   
	...

0000000000801044 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801044:	55                   	push   %rbp
  801045:	48 89 e5             	mov    %rsp,%rbp
  801048:	48 83 ec 18          	sub    $0x18,%rsp
  80104c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801057:	eb 09                	jmp    801062 <strlen+0x1e>
		n++;
  801059:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80105d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801062:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801066:	0f b6 00             	movzbl (%rax),%eax
  801069:	84 c0                	test   %al,%al
  80106b:	75 ec                	jne    801059 <strlen+0x15>
		n++;
	return n;
  80106d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801070:	c9                   	leaveq 
  801071:	c3                   	retq   

0000000000801072 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801072:	55                   	push   %rbp
  801073:	48 89 e5             	mov    %rsp,%rbp
  801076:	48 83 ec 20          	sub    $0x20,%rsp
  80107a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801089:	eb 0e                	jmp    801099 <strnlen+0x27>
		n++;
  80108b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80108f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801094:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801099:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80109e:	74 0b                	je     8010ab <strnlen+0x39>
  8010a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a4:	0f b6 00             	movzbl (%rax),%eax
  8010a7:	84 c0                	test   %al,%al
  8010a9:	75 e0                	jne    80108b <strnlen+0x19>
		n++;
	return n;
  8010ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010ae:	c9                   	leaveq 
  8010af:	c3                   	retq   

00000000008010b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010b0:	55                   	push   %rbp
  8010b1:	48 89 e5             	mov    %rsp,%rbp
  8010b4:	48 83 ec 20          	sub    $0x20,%rsp
  8010b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010c8:	90                   	nop
  8010c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010cd:	0f b6 10             	movzbl (%rax),%edx
  8010d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d4:	88 10                	mov    %dl,(%rax)
  8010d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010da:	0f b6 00             	movzbl (%rax),%eax
  8010dd:	84 c0                	test   %al,%al
  8010df:	0f 95 c0             	setne  %al
  8010e2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8010ec:	84 c0                	test   %al,%al
  8010ee:	75 d9                	jne    8010c9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010f4:	c9                   	leaveq 
  8010f5:	c3                   	retq   

00000000008010f6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	48 83 ec 20          	sub    $0x20,%rsp
  8010fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801102:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801106:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110a:	48 89 c7             	mov    %rax,%rdi
  80110d:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  801114:	00 00 00 
  801117:	ff d0                	callq  *%rax
  801119:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80111c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80111f:	48 98                	cltq   
  801121:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801125:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801129:	48 89 d6             	mov    %rdx,%rsi
  80112c:	48 89 c7             	mov    %rax,%rdi
  80112f:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  801136:	00 00 00 
  801139:	ff d0                	callq  *%rax
	return dst;
  80113b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80113f:	c9                   	leaveq 
  801140:	c3                   	retq   

0000000000801141 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	48 83 ec 28          	sub    $0x28,%rsp
  801149:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801151:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801159:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80115d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801164:	00 
  801165:	eb 27                	jmp    80118e <strncpy+0x4d>
		*dst++ = *src;
  801167:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116b:	0f b6 10             	movzbl (%rax),%edx
  80116e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801172:	88 10                	mov    %dl,(%rax)
  801174:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801179:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80117d:	0f b6 00             	movzbl (%rax),%eax
  801180:	84 c0                	test   %al,%al
  801182:	74 05                	je     801189 <strncpy+0x48>
			src++;
  801184:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801189:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80118e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801192:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801196:	72 cf                	jb     801167 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801198:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80119c:	c9                   	leaveq 
  80119d:	c3                   	retq   

000000000080119e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80119e:	55                   	push   %rbp
  80119f:	48 89 e5             	mov    %rsp,%rbp
  8011a2:	48 83 ec 28          	sub    $0x28,%rsp
  8011a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011ba:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011bf:	74 37                	je     8011f8 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8011c1:	eb 17                	jmp    8011da <strlcpy+0x3c>
			*dst++ = *src++;
  8011c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c7:	0f b6 10             	movzbl (%rax),%edx
  8011ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ce:	88 10                	mov    %dl,(%rax)
  8011d0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011d5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011da:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011e4:	74 0b                	je     8011f1 <strlcpy+0x53>
  8011e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ea:	0f b6 00             	movzbl (%rax),%eax
  8011ed:	84 c0                	test   %al,%al
  8011ef:	75 d2                	jne    8011c3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801200:	48 89 d1             	mov    %rdx,%rcx
  801203:	48 29 c1             	sub    %rax,%rcx
  801206:	48 89 c8             	mov    %rcx,%rax
}
  801209:	c9                   	leaveq 
  80120a:	c3                   	retq   

000000000080120b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80120b:	55                   	push   %rbp
  80120c:	48 89 e5             	mov    %rsp,%rbp
  80120f:	48 83 ec 10          	sub    $0x10,%rsp
  801213:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801217:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80121b:	eb 0a                	jmp    801227 <strcmp+0x1c>
		p++, q++;
  80121d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801222:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122b:	0f b6 00             	movzbl (%rax),%eax
  80122e:	84 c0                	test   %al,%al
  801230:	74 12                	je     801244 <strcmp+0x39>
  801232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801236:	0f b6 10             	movzbl (%rax),%edx
  801239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	38 c2                	cmp    %al,%dl
  801242:	74 d9                	je     80121d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	0f b6 d0             	movzbl %al,%edx
  80124e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801252:	0f b6 00             	movzbl (%rax),%eax
  801255:	0f b6 c0             	movzbl %al,%eax
  801258:	89 d1                	mov    %edx,%ecx
  80125a:	29 c1                	sub    %eax,%ecx
  80125c:	89 c8                	mov    %ecx,%eax
}
  80125e:	c9                   	leaveq 
  80125f:	c3                   	retq   

0000000000801260 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	48 83 ec 18          	sub    $0x18,%rsp
  801268:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801270:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801274:	eb 0f                	jmp    801285 <strncmp+0x25>
		n--, p++, q++;
  801276:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80127b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801280:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801285:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80128a:	74 1d                	je     8012a9 <strncmp+0x49>
  80128c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801290:	0f b6 00             	movzbl (%rax),%eax
  801293:	84 c0                	test   %al,%al
  801295:	74 12                	je     8012a9 <strncmp+0x49>
  801297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129b:	0f b6 10             	movzbl (%rax),%edx
  80129e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a2:	0f b6 00             	movzbl (%rax),%eax
  8012a5:	38 c2                	cmp    %al,%dl
  8012a7:	74 cd                	je     801276 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ae:	75 07                	jne    8012b7 <strncmp+0x57>
		return 0;
  8012b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b5:	eb 1a                	jmp    8012d1 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bb:	0f b6 00             	movzbl (%rax),%eax
  8012be:	0f b6 d0             	movzbl %al,%edx
  8012c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c5:	0f b6 00             	movzbl (%rax),%eax
  8012c8:	0f b6 c0             	movzbl %al,%eax
  8012cb:	89 d1                	mov    %edx,%ecx
  8012cd:	29 c1                	sub    %eax,%ecx
  8012cf:	89 c8                	mov    %ecx,%eax
}
  8012d1:	c9                   	leaveq 
  8012d2:	c3                   	retq   

00000000008012d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012d3:	55                   	push   %rbp
  8012d4:	48 89 e5             	mov    %rsp,%rbp
  8012d7:	48 83 ec 10          	sub    $0x10,%rsp
  8012db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012df:	89 f0                	mov    %esi,%eax
  8012e1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012e4:	eb 17                	jmp    8012fd <strchr+0x2a>
		if (*s == c)
  8012e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ea:	0f b6 00             	movzbl (%rax),%eax
  8012ed:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f0:	75 06                	jne    8012f8 <strchr+0x25>
			return (char *) s;
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	eb 15                	jmp    80130d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801301:	0f b6 00             	movzbl (%rax),%eax
  801304:	84 c0                	test   %al,%al
  801306:	75 de                	jne    8012e6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801308:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130d:	c9                   	leaveq 
  80130e:	c3                   	retq   

000000000080130f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80130f:	55                   	push   %rbp
  801310:	48 89 e5             	mov    %rsp,%rbp
  801313:	48 83 ec 10          	sub    $0x10,%rsp
  801317:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131b:	89 f0                	mov    %esi,%eax
  80131d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801320:	eb 11                	jmp    801333 <strfind+0x24>
		if (*s == c)
  801322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801326:	0f b6 00             	movzbl (%rax),%eax
  801329:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80132c:	74 12                	je     801340 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80132e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801337:	0f b6 00             	movzbl (%rax),%eax
  80133a:	84 c0                	test   %al,%al
  80133c:	75 e4                	jne    801322 <strfind+0x13>
  80133e:	eb 01                	jmp    801341 <strfind+0x32>
		if (*s == c)
			break;
  801340:	90                   	nop
	return (char *) s;
  801341:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801345:	c9                   	leaveq 
  801346:	c3                   	retq   

0000000000801347 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	48 83 ec 18          	sub    $0x18,%rsp
  80134f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801353:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801356:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80135a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80135f:	75 06                	jne    801367 <memset+0x20>
		return v;
  801361:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801365:	eb 69                	jmp    8013d0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136b:	83 e0 03             	and    $0x3,%eax
  80136e:	48 85 c0             	test   %rax,%rax
  801371:	75 48                	jne    8013bb <memset+0x74>
  801373:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801377:	83 e0 03             	and    $0x3,%eax
  80137a:	48 85 c0             	test   %rax,%rax
  80137d:	75 3c                	jne    8013bb <memset+0x74>
		c &= 0xFF;
  80137f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801386:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801389:	89 c2                	mov    %eax,%edx
  80138b:	c1 e2 18             	shl    $0x18,%edx
  80138e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801391:	c1 e0 10             	shl    $0x10,%eax
  801394:	09 c2                	or     %eax,%edx
  801396:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801399:	c1 e0 08             	shl    $0x8,%eax
  80139c:	09 d0                	or     %edx,%eax
  80139e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a5:	48 89 c1             	mov    %rax,%rcx
  8013a8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b3:	48 89 d7             	mov    %rdx,%rdi
  8013b6:	fc                   	cld    
  8013b7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013b9:	eb 11                	jmp    8013cc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013c6:	48 89 d7             	mov    %rdx,%rdi
  8013c9:	fc                   	cld    
  8013ca:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013d0:	c9                   	leaveq 
  8013d1:	c3                   	retq   

00000000008013d2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013d2:	55                   	push   %rbp
  8013d3:	48 89 e5             	mov    %rsp,%rbp
  8013d6:	48 83 ec 28          	sub    $0x28,%rsp
  8013da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013fe:	0f 83 88 00 00 00    	jae    80148c <memmove+0xba>
  801404:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801408:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140c:	48 01 d0             	add    %rdx,%rax
  80140f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801413:	76 77                	jbe    80148c <memmove+0xba>
		s += n;
  801415:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801419:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80141d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801421:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	75 3b                	jne    80146c <memmove+0x9a>
  801431:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801435:	83 e0 03             	and    $0x3,%eax
  801438:	48 85 c0             	test   %rax,%rax
  80143b:	75 2f                	jne    80146c <memmove+0x9a>
  80143d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801441:	83 e0 03             	and    $0x3,%eax
  801444:	48 85 c0             	test   %rax,%rax
  801447:	75 23                	jne    80146c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144d:	48 83 e8 04          	sub    $0x4,%rax
  801451:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801455:	48 83 ea 04          	sub    $0x4,%rdx
  801459:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80145d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801461:	48 89 c7             	mov    %rax,%rdi
  801464:	48 89 d6             	mov    %rdx,%rsi
  801467:	fd                   	std    
  801468:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80146a:	eb 1d                	jmp    801489 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80146c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801470:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801474:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801478:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80147c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801480:	48 89 d7             	mov    %rdx,%rdi
  801483:	48 89 c1             	mov    %rax,%rcx
  801486:	fd                   	std    
  801487:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801489:	fc                   	cld    
  80148a:	eb 57                	jmp    8014e3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801490:	83 e0 03             	and    $0x3,%eax
  801493:	48 85 c0             	test   %rax,%rax
  801496:	75 36                	jne    8014ce <memmove+0xfc>
  801498:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149c:	83 e0 03             	and    $0x3,%eax
  80149f:	48 85 c0             	test   %rax,%rax
  8014a2:	75 2a                	jne    8014ce <memmove+0xfc>
  8014a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a8:	83 e0 03             	and    $0x3,%eax
  8014ab:	48 85 c0             	test   %rax,%rax
  8014ae:	75 1e                	jne    8014ce <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b4:	48 89 c1             	mov    %rax,%rcx
  8014b7:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c3:	48 89 c7             	mov    %rax,%rdi
  8014c6:	48 89 d6             	mov    %rdx,%rsi
  8014c9:	fc                   	cld    
  8014ca:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014cc:	eb 15                	jmp    8014e3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014da:	48 89 c7             	mov    %rax,%rdi
  8014dd:	48 89 d6             	mov    %rdx,%rsi
  8014e0:	fc                   	cld    
  8014e1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014e7:	c9                   	leaveq 
  8014e8:	c3                   	retq   

00000000008014e9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014e9:	55                   	push   %rbp
  8014ea:	48 89 e5             	mov    %rsp,%rbp
  8014ed:	48 83 ec 18          	sub    $0x18,%rsp
  8014f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801501:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801509:	48 89 ce             	mov    %rcx,%rsi
  80150c:	48 89 c7             	mov    %rax,%rdi
  80150f:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  801516:	00 00 00 
  801519:	ff d0                	callq  *%rax
}
  80151b:	c9                   	leaveq 
  80151c:	c3                   	retq   

000000000080151d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80151d:	55                   	push   %rbp
  80151e:	48 89 e5             	mov    %rsp,%rbp
  801521:	48 83 ec 28          	sub    $0x28,%rsp
  801525:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801529:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80152d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801535:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801539:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80153d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801541:	eb 38                	jmp    80157b <memcmp+0x5e>
		if (*s1 != *s2)
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801547:	0f b6 10             	movzbl (%rax),%edx
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	38 c2                	cmp    %al,%dl
  801553:	74 1c                	je     801571 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801559:	0f b6 00             	movzbl (%rax),%eax
  80155c:	0f b6 d0             	movzbl %al,%edx
  80155f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801563:	0f b6 00             	movzbl (%rax),%eax
  801566:	0f b6 c0             	movzbl %al,%eax
  801569:	89 d1                	mov    %edx,%ecx
  80156b:	29 c1                	sub    %eax,%ecx
  80156d:	89 c8                	mov    %ecx,%eax
  80156f:	eb 20                	jmp    801591 <memcmp+0x74>
		s1++, s2++;
  801571:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801576:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80157b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801580:	0f 95 c0             	setne  %al
  801583:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801588:	84 c0                	test   %al,%al
  80158a:	75 b7                	jne    801543 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80158c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801591:	c9                   	leaveq 
  801592:	c3                   	retq   

0000000000801593 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801593:	55                   	push   %rbp
  801594:	48 89 e5             	mov    %rsp,%rbp
  801597:	48 83 ec 28          	sub    $0x28,%rsp
  80159b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80159f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ae:	48 01 d0             	add    %rdx,%rax
  8015b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015b5:	eb 13                	jmp    8015ca <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bb:	0f b6 10             	movzbl (%rax),%edx
  8015be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015c1:	38 c2                	cmp    %al,%dl
  8015c3:	74 11                	je     8015d6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015c5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ce:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015d2:	72 e3                	jb     8015b7 <memfind+0x24>
  8015d4:	eb 01                	jmp    8015d7 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015d6:	90                   	nop
	return (void *) s;
  8015d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015db:	c9                   	leaveq 
  8015dc:	c3                   	retq   

00000000008015dd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015dd:	55                   	push   %rbp
  8015de:	48 89 e5             	mov    %rsp,%rbp
  8015e1:	48 83 ec 38          	sub    $0x38,%rsp
  8015e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015ed:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015f7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015fe:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ff:	eb 05                	jmp    801606 <strtol+0x29>
		s++;
  801601:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801606:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160a:	0f b6 00             	movzbl (%rax),%eax
  80160d:	3c 20                	cmp    $0x20,%al
  80160f:	74 f0                	je     801601 <strtol+0x24>
  801611:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801615:	0f b6 00             	movzbl (%rax),%eax
  801618:	3c 09                	cmp    $0x9,%al
  80161a:	74 e5                	je     801601 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80161c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801620:	0f b6 00             	movzbl (%rax),%eax
  801623:	3c 2b                	cmp    $0x2b,%al
  801625:	75 07                	jne    80162e <strtol+0x51>
		s++;
  801627:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162c:	eb 17                	jmp    801645 <strtol+0x68>
	else if (*s == '-')
  80162e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801632:	0f b6 00             	movzbl (%rax),%eax
  801635:	3c 2d                	cmp    $0x2d,%al
  801637:	75 0c                	jne    801645 <strtol+0x68>
		s++, neg = 1;
  801639:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80163e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801645:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801649:	74 06                	je     801651 <strtol+0x74>
  80164b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80164f:	75 28                	jne    801679 <strtol+0x9c>
  801651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	3c 30                	cmp    $0x30,%al
  80165a:	75 1d                	jne    801679 <strtol+0x9c>
  80165c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801660:	48 83 c0 01          	add    $0x1,%rax
  801664:	0f b6 00             	movzbl (%rax),%eax
  801667:	3c 78                	cmp    $0x78,%al
  801669:	75 0e                	jne    801679 <strtol+0x9c>
		s += 2, base = 16;
  80166b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801670:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801677:	eb 2c                	jmp    8016a5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801679:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167d:	75 19                	jne    801698 <strtol+0xbb>
  80167f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801683:	0f b6 00             	movzbl (%rax),%eax
  801686:	3c 30                	cmp    $0x30,%al
  801688:	75 0e                	jne    801698 <strtol+0xbb>
		s++, base = 8;
  80168a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80168f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801696:	eb 0d                	jmp    8016a5 <strtol+0xc8>
	else if (base == 0)
  801698:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80169c:	75 07                	jne    8016a5 <strtol+0xc8>
		base = 10;
  80169e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a9:	0f b6 00             	movzbl (%rax),%eax
  8016ac:	3c 2f                	cmp    $0x2f,%al
  8016ae:	7e 1d                	jle    8016cd <strtol+0xf0>
  8016b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b4:	0f b6 00             	movzbl (%rax),%eax
  8016b7:	3c 39                	cmp    $0x39,%al
  8016b9:	7f 12                	jg     8016cd <strtol+0xf0>
			dig = *s - '0';
  8016bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bf:	0f b6 00             	movzbl (%rax),%eax
  8016c2:	0f be c0             	movsbl %al,%eax
  8016c5:	83 e8 30             	sub    $0x30,%eax
  8016c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016cb:	eb 4e                	jmp    80171b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d1:	0f b6 00             	movzbl (%rax),%eax
  8016d4:	3c 60                	cmp    $0x60,%al
  8016d6:	7e 1d                	jle    8016f5 <strtol+0x118>
  8016d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dc:	0f b6 00             	movzbl (%rax),%eax
  8016df:	3c 7a                	cmp    $0x7a,%al
  8016e1:	7f 12                	jg     8016f5 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e7:	0f b6 00             	movzbl (%rax),%eax
  8016ea:	0f be c0             	movsbl %al,%eax
  8016ed:	83 e8 57             	sub    $0x57,%eax
  8016f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016f3:	eb 26                	jmp    80171b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f9:	0f b6 00             	movzbl (%rax),%eax
  8016fc:	3c 40                	cmp    $0x40,%al
  8016fe:	7e 47                	jle    801747 <strtol+0x16a>
  801700:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801704:	0f b6 00             	movzbl (%rax),%eax
  801707:	3c 5a                	cmp    $0x5a,%al
  801709:	7f 3c                	jg     801747 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80170b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170f:	0f b6 00             	movzbl (%rax),%eax
  801712:	0f be c0             	movsbl %al,%eax
  801715:	83 e8 37             	sub    $0x37,%eax
  801718:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80171b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80171e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801721:	7d 23                	jge    801746 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801723:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801728:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80172b:	48 98                	cltq   
  80172d:	48 89 c2             	mov    %rax,%rdx
  801730:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801735:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801738:	48 98                	cltq   
  80173a:	48 01 d0             	add    %rdx,%rax
  80173d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801741:	e9 5f ff ff ff       	jmpq   8016a5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801746:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801747:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80174c:	74 0b                	je     801759 <strtol+0x17c>
		*endptr = (char *) s;
  80174e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801752:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801756:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801759:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80175d:	74 09                	je     801768 <strtol+0x18b>
  80175f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801763:	48 f7 d8             	neg    %rax
  801766:	eb 04                	jmp    80176c <strtol+0x18f>
  801768:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80176c:	c9                   	leaveq 
  80176d:	c3                   	retq   

000000000080176e <strstr>:

char * strstr(const char *in, const char *str)
{
  80176e:	55                   	push   %rbp
  80176f:	48 89 e5             	mov    %rsp,%rbp
  801772:	48 83 ec 30          	sub    $0x30,%rsp
  801776:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80177a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80177e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	88 45 ff             	mov    %al,-0x1(%rbp)
  801788:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  80178d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801791:	75 06                	jne    801799 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801797:	eb 68                	jmp    801801 <strstr+0x93>

	len = strlen(str);
  801799:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80179d:	48 89 c7             	mov    %rax,%rdi
  8017a0:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  8017a7:	00 00 00 
  8017aa:	ff d0                	callq  *%rax
  8017ac:	48 98                	cltq   
  8017ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b6:	0f b6 00             	movzbl (%rax),%eax
  8017b9:	88 45 ef             	mov    %al,-0x11(%rbp)
  8017bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  8017c1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017c5:	75 07                	jne    8017ce <strstr+0x60>
				return (char *) 0;
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cc:	eb 33                	jmp    801801 <strstr+0x93>
		} while (sc != c);
  8017ce:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017d2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017d5:	75 db                	jne    8017b2 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  8017d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017db:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e3:	48 89 ce             	mov    %rcx,%rsi
  8017e6:	48 89 c7             	mov    %rax,%rdi
  8017e9:	48 b8 60 12 80 00 00 	movabs $0x801260,%rax
  8017f0:	00 00 00 
  8017f3:	ff d0                	callq  *%rax
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	75 b9                	jne    8017b2 <strstr+0x44>

	return (char *) (in - 1);
  8017f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fd:	48 83 e8 01          	sub    $0x1,%rax
}
  801801:	c9                   	leaveq 
  801802:	c3                   	retq   
	...

0000000000801804 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801804:	55                   	push   %rbp
  801805:	48 89 e5             	mov    %rsp,%rbp
  801808:	53                   	push   %rbx
  801809:	48 83 ec 58          	sub    $0x58,%rsp
  80180d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801810:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801813:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801817:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80181b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80181f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801823:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801826:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801829:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80182d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801831:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801835:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801839:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80183d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801840:	4c 89 c3             	mov    %r8,%rbx
  801843:	cd 30                	int    $0x30
  801845:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801849:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80184d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801851:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801855:	74 3e                	je     801895 <syscall+0x91>
  801857:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80185c:	7e 37                	jle    801895 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80185e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801862:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801865:	49 89 d0             	mov    %rdx,%r8
  801868:	89 c1                	mov    %eax,%ecx
  80186a:	48 ba 48 4a 80 00 00 	movabs $0x804a48,%rdx
  801871:	00 00 00 
  801874:	be 23 00 00 00       	mov    $0x23,%esi
  801879:	48 bf 65 4a 80 00 00 	movabs $0x804a65,%rdi
  801880:	00 00 00 
  801883:	b8 00 00 00 00       	mov    $0x0,%eax
  801888:	49 b9 a4 02 80 00 00 	movabs $0x8002a4,%r9
  80188f:	00 00 00 
  801892:	41 ff d1             	callq  *%r9

	return ret;
  801895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801899:	48 83 c4 58          	add    $0x58,%rsp
  80189d:	5b                   	pop    %rbx
  80189e:	5d                   	pop    %rbp
  80189f:	c3                   	retq   

00000000008018a0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018a0:	55                   	push   %rbp
  8018a1:	48 89 e5             	mov    %rsp,%rbp
  8018a4:	48 83 ec 20          	sub    $0x20,%rsp
  8018a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018bf:	00 
  8018c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cc:	48 89 d1             	mov    %rdx,%rcx
  8018cf:	48 89 c2             	mov    %rax,%rdx
  8018d2:	be 00 00 00 00       	mov    $0x0,%esi
  8018d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8018dc:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  8018e3:	00 00 00 
  8018e6:	ff d0                	callq  *%rax
}
  8018e8:	c9                   	leaveq 
  8018e9:	c3                   	retq   

00000000008018ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ea:	55                   	push   %rbp
  8018eb:	48 89 e5             	mov    %rsp,%rbp
  8018ee:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f9:	00 
  8018fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801900:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801906:	b9 00 00 00 00       	mov    $0x0,%ecx
  80190b:	ba 00 00 00 00       	mov    $0x0,%edx
  801910:	be 00 00 00 00       	mov    $0x0,%esi
  801915:	bf 01 00 00 00       	mov    $0x1,%edi
  80191a:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801921:	00 00 00 
  801924:	ff d0                	callq  *%rax
}
  801926:	c9                   	leaveq 
  801927:	c3                   	retq   

0000000000801928 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801928:	55                   	push   %rbp
  801929:	48 89 e5             	mov    %rsp,%rbp
  80192c:	48 83 ec 20          	sub    $0x20,%rsp
  801930:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801933:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801936:	48 98                	cltq   
  801938:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193f:	00 
  801940:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801946:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801951:	48 89 c2             	mov    %rax,%rdx
  801954:	be 01 00 00 00       	mov    $0x1,%esi
  801959:	bf 03 00 00 00       	mov    $0x3,%edi
  80195e:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801965:	00 00 00 
  801968:	ff d0                	callq  *%rax
}
  80196a:	c9                   	leaveq 
  80196b:	c3                   	retq   

000000000080196c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80196c:	55                   	push   %rbp
  80196d:	48 89 e5             	mov    %rsp,%rbp
  801970:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801974:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197b:	00 
  80197c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801982:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801988:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198d:	ba 00 00 00 00       	mov    $0x0,%edx
  801992:	be 00 00 00 00       	mov    $0x0,%esi
  801997:	bf 02 00 00 00       	mov    $0x2,%edi
  80199c:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  8019a3:	00 00 00 
  8019a6:	ff d0                	callq  *%rax
}
  8019a8:	c9                   	leaveq 
  8019a9:	c3                   	retq   

00000000008019aa <sys_yield>:

void
sys_yield(void)
{
  8019aa:	55                   	push   %rbp
  8019ab:	48 89 e5             	mov    %rsp,%rbp
  8019ae:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b9:	00 
  8019ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d0:	be 00 00 00 00       	mov    $0x0,%esi
  8019d5:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019da:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	callq  *%rax
}
  8019e6:	c9                   	leaveq 
  8019e7:	c3                   	retq   

00000000008019e8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	48 83 ec 20          	sub    $0x20,%rsp
  8019f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019fd:	48 63 c8             	movslq %eax,%rcx
  801a00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a07:	48 98                	cltq   
  801a09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a10:	00 
  801a11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a17:	49 89 c8             	mov    %rcx,%r8
  801a1a:	48 89 d1             	mov    %rdx,%rcx
  801a1d:	48 89 c2             	mov    %rax,%rdx
  801a20:	be 01 00 00 00       	mov    $0x1,%esi
  801a25:	bf 04 00 00 00       	mov    $0x4,%edi
  801a2a:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	callq  *%rax
}
  801a36:	c9                   	leaveq 
  801a37:	c3                   	retq   

0000000000801a38 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a38:	55                   	push   %rbp
  801a39:	48 89 e5             	mov    %rsp,%rbp
  801a3c:	48 83 ec 30          	sub    $0x30,%rsp
  801a40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a47:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a4a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a4e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a52:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a55:	48 63 c8             	movslq %eax,%rcx
  801a58:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a5f:	48 63 f0             	movslq %eax,%rsi
  801a62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a69:	48 98                	cltq   
  801a6b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a6f:	49 89 f9             	mov    %rdi,%r9
  801a72:	49 89 f0             	mov    %rsi,%r8
  801a75:	48 89 d1             	mov    %rdx,%rcx
  801a78:	48 89 c2             	mov    %rax,%rdx
  801a7b:	be 01 00 00 00       	mov    $0x1,%esi
  801a80:	bf 05 00 00 00       	mov    $0x5,%edi
  801a85:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801a8c:	00 00 00 
  801a8f:	ff d0                	callq  *%rax
}
  801a91:	c9                   	leaveq 
  801a92:	c3                   	retq   

0000000000801a93 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a93:	55                   	push   %rbp
  801a94:	48 89 e5             	mov    %rsp,%rbp
  801a97:	48 83 ec 20          	sub    $0x20,%rsp
  801a9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801aa2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa9:	48 98                	cltq   
  801aab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab2:	00 
  801ab3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abf:	48 89 d1             	mov    %rdx,%rcx
  801ac2:	48 89 c2             	mov    %rax,%rdx
  801ac5:	be 01 00 00 00       	mov    $0x1,%esi
  801aca:	bf 06 00 00 00       	mov    $0x6,%edi
  801acf:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801ad6:	00 00 00 
  801ad9:	ff d0                	callq  *%rax
}
  801adb:	c9                   	leaveq 
  801adc:	c3                   	retq   

0000000000801add <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801add:	55                   	push   %rbp
  801ade:	48 89 e5             	mov    %rsp,%rbp
  801ae1:	48 83 ec 20          	sub    $0x20,%rsp
  801ae5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801aeb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aee:	48 63 d0             	movslq %eax,%rdx
  801af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af4:	48 98                	cltq   
  801af6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afd:	00 
  801afe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0a:	48 89 d1             	mov    %rdx,%rcx
  801b0d:	48 89 c2             	mov    %rax,%rdx
  801b10:	be 01 00 00 00       	mov    $0x1,%esi
  801b15:	bf 08 00 00 00       	mov    $0x8,%edi
  801b1a:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801b21:	00 00 00 
  801b24:	ff d0                	callq  *%rax
}
  801b26:	c9                   	leaveq 
  801b27:	c3                   	retq   

0000000000801b28 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b28:	55                   	push   %rbp
  801b29:	48 89 e5             	mov    %rsp,%rbp
  801b2c:	48 83 ec 20          	sub    $0x20,%rsp
  801b30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3e:	48 98                	cltq   
  801b40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b47:	00 
  801b48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b54:	48 89 d1             	mov    %rdx,%rcx
  801b57:	48 89 c2             	mov    %rax,%rdx
  801b5a:	be 01 00 00 00       	mov    $0x1,%esi
  801b5f:	bf 09 00 00 00       	mov    $0x9,%edi
  801b64:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	callq  *%rax
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 20          	sub    $0x20,%rsp
  801b7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b88:	48 98                	cltq   
  801b8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b91:	00 
  801b92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9e:	48 89 d1             	mov    %rdx,%rcx
  801ba1:	48 89 c2             	mov    %rax,%rdx
  801ba4:	be 01 00 00 00       	mov    $0x1,%esi
  801ba9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bae:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801bb5:	00 00 00 
  801bb8:	ff d0                	callq  *%rax
}
  801bba:	c9                   	leaveq 
  801bbb:	c3                   	retq   

0000000000801bbc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	48 83 ec 30          	sub    $0x30,%rsp
  801bc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bcb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bcf:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd5:	48 63 f0             	movslq %eax,%rsi
  801bd8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bdf:	48 98                	cltq   
  801be1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bec:	00 
  801bed:	49 89 f1             	mov    %rsi,%r9
  801bf0:	49 89 c8             	mov    %rcx,%r8
  801bf3:	48 89 d1             	mov    %rdx,%rcx
  801bf6:	48 89 c2             	mov    %rax,%rdx
  801bf9:	be 00 00 00 00       	mov    $0x0,%esi
  801bfe:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c03:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	callq  *%rax
}
  801c0f:	c9                   	leaveq 
  801c10:	c3                   	retq   

0000000000801c11 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c11:	55                   	push   %rbp
  801c12:	48 89 e5             	mov    %rsp,%rbp
  801c15:	48 83 ec 20          	sub    $0x20,%rsp
  801c19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c21:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c28:	00 
  801c29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c35:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3a:	48 89 c2             	mov    %rax,%rdx
  801c3d:	be 01 00 00 00       	mov    $0x1,%esi
  801c42:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c47:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801c4e:	00 00 00 
  801c51:	ff d0                	callq  *%rax
}
  801c53:	c9                   	leaveq 
  801c54:	c3                   	retq   

0000000000801c55 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c55:	55                   	push   %rbp
  801c56:	48 89 e5             	mov    %rsp,%rbp
  801c59:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c5d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c64:	00 
  801c65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c71:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c76:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7b:	be 00 00 00 00       	mov    $0x0,%esi
  801c80:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c85:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801c8c:	00 00 00 
  801c8f:	ff d0                	callq  *%rax
}
  801c91:	c9                   	leaveq 
  801c92:	c3                   	retq   

0000000000801c93 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801c93:	55                   	push   %rbp
  801c94:	48 89 e5             	mov    %rsp,%rbp
  801c97:	48 83 ec 30          	sub    $0x30,%rsp
  801c9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ca2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ca5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ca9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801cad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cb0:	48 63 c8             	movslq %eax,%rcx
  801cb3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cba:	48 63 f0             	movslq %eax,%rsi
  801cbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc4:	48 98                	cltq   
  801cc6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801cca:	49 89 f9             	mov    %rdi,%r9
  801ccd:	49 89 f0             	mov    %rsi,%r8
  801cd0:	48 89 d1             	mov    %rdx,%rcx
  801cd3:	48 89 c2             	mov    %rax,%rdx
  801cd6:	be 00 00 00 00       	mov    $0x0,%esi
  801cdb:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ce0:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801ce7:	00 00 00 
  801cea:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801cec:	c9                   	leaveq 
  801ced:	c3                   	retq   

0000000000801cee <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801cee:	55                   	push   %rbp
  801cef:	48 89 e5             	mov    %rsp,%rbp
  801cf2:	48 83 ec 20          	sub    $0x20,%rsp
  801cf6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cfa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801cfe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0d:	00 
  801d0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d1a:	48 89 d1             	mov    %rdx,%rcx
  801d1d:	48 89 c2             	mov    %rax,%rdx
  801d20:	be 00 00 00 00       	mov    $0x0,%esi
  801d25:	bf 10 00 00 00       	mov    $0x10,%edi
  801d2a:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801d31:	00 00 00 
  801d34:	ff d0                	callq  *%rax
}
  801d36:	c9                   	leaveq 
  801d37:	c3                   	retq   

0000000000801d38 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d38:	55                   	push   %rbp
  801d39:	48 89 e5             	mov    %rsp,%rbp
  801d3c:	48 83 ec 40          	sub    $0x40,%rsp
  801d40:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d44:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d48:	48 8b 00             	mov    (%rax),%rax
  801d4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801d4f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d53:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d57:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  801d5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d5e:	48 89 c2             	mov    %rax,%rdx
  801d61:	48 c1 ea 0c          	shr    $0xc,%rdx
  801d65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d6c:	01 00 00 
  801d6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  801d77:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d7a:	83 e0 02             	and    $0x2,%eax
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	0f 84 4f 01 00 00    	je     801ed4 <pgfault+0x19c>
  801d85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d89:	48 89 c2             	mov    %rax,%rdx
  801d8c:	48 c1 ea 0c          	shr    $0xc,%rdx
  801d90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d97:	01 00 00 
  801d9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d9e:	25 00 08 00 00       	and    $0x800,%eax
  801da3:	48 85 c0             	test   %rax,%rax
  801da6:	0f 84 28 01 00 00    	je     801ed4 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  801dac:	ba 07 00 00 00       	mov    $0x7,%edx
  801db1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801db6:	bf 00 00 00 00       	mov    $0x0,%edi
  801dbb:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  801dc2:	00 00 00 
  801dc5:	ff d0                	callq  *%rax
  801dc7:	85 c0                	test   %eax,%eax
  801dc9:	0f 85 db 00 00 00    	jne    801eaa <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  801dcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801dd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ddb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801de1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  801de5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de9:	ba 00 10 00 00       	mov    $0x1000,%edx
  801dee:	48 89 c6             	mov    %rax,%rsi
  801df1:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801df6:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  801e02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e06:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e0c:	48 89 c1             	mov    %rax,%rcx
  801e0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e14:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e19:	bf 00 00 00 00       	mov    $0x0,%edi
  801e1e:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  801e25:	00 00 00 
  801e28:	ff d0                	callq  *%rax
  801e2a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801e2d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801e31:	79 2a                	jns    801e5d <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  801e33:	48 ba 78 4a 80 00 00 	movabs $0x804a78,%rdx
  801e3a:	00 00 00 
  801e3d:	be 28 00 00 00       	mov    $0x28,%esi
  801e42:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  801e49:	00 00 00 
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e51:	48 b9 a4 02 80 00 00 	movabs $0x8002a4,%rcx
  801e58:	00 00 00 
  801e5b:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  801e5d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e62:	bf 00 00 00 00       	mov    $0x0,%edi
  801e67:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  801e6e:	00 00 00 
  801e71:	ff d0                	callq  *%rax
  801e73:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  801e76:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801e7a:	0f 89 84 00 00 00    	jns    801f04 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  801e80:	48 ba b0 4a 80 00 00 	movabs $0x804ab0,%rdx
  801e87:	00 00 00 
  801e8a:	be 2c 00 00 00       	mov    $0x2c,%esi
  801e8f:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  801e96:	00 00 00 
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9e:	48 b9 a4 02 80 00 00 	movabs $0x8002a4,%rcx
  801ea5:	00 00 00 
  801ea8:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  801eaa:	48 ba e0 4a 80 00 00 	movabs $0x804ae0,%rdx
  801eb1:	00 00 00 
  801eb4:	be 31 00 00 00       	mov    $0x31,%esi
  801eb9:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  801ec0:	00 00 00 
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec8:	48 b9 a4 02 80 00 00 	movabs $0x8002a4,%rcx
  801ecf:	00 00 00 
  801ed2:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  801ed4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ed7:	89 c1                	mov    %eax,%ecx
  801ed9:	48 ba 0a 4b 80 00 00 	movabs $0x804b0a,%rdx
  801ee0:	00 00 00 
  801ee3:	be 35 00 00 00       	mov    $0x35,%esi
  801ee8:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  801eef:	00 00 00 
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  801efe:	00 00 00 
  801f01:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  801f04:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  801f05:	c9                   	leaveq 
  801f06:	c3                   	retq   

0000000000801f07 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f07:	55                   	push   %rbp
  801f08:	48 89 e5             	mov    %rsp,%rbp
  801f0b:	48 83 ec 30          	sub    $0x30,%rsp
  801f0f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801f12:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  801f15:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f1c:	01 00 00 
  801f1f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801f22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  801f2a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801f2d:	48 c1 e0 0c          	shl    $0xc,%rax
  801f31:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  801f35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f39:	25 07 0e 00 00       	and    $0xe07,%eax
  801f3e:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  801f41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f44:	25 00 04 00 00       	and    $0x400,%eax
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	74 62                	je     801faf <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  801f4d:	8b 75 ec             	mov    -0x14(%rbp),%esi
  801f50:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f54:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5b:	41 89 f0             	mov    %esi,%r8d
  801f5e:	48 89 c6             	mov    %rax,%rsi
  801f61:	bf 00 00 00 00       	mov    $0x0,%edi
  801f66:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  801f6d:	00 00 00 
  801f70:	ff d0                	callq  *%rax
  801f72:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  801f75:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801f79:	0f 89 78 01 00 00    	jns    8020f7 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  801f7f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f82:	89 c1                	mov    %eax,%ecx
  801f84:	48 ba 28 4b 80 00 00 	movabs $0x804b28,%rdx
  801f8b:	00 00 00 
  801f8e:	be 4f 00 00 00       	mov    $0x4f,%esi
  801f93:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  801f9a:	00 00 00 
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa2:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  801fa9:	00 00 00 
  801fac:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  801faf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fb2:	25 00 08 00 00       	and    $0x800,%eax
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	75 0e                	jne    801fc9 <duppage+0xc2>
  801fbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fbe:	83 e0 02             	and    $0x2,%eax
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	0f 84 d0 00 00 00    	je     802099 <duppage+0x192>
		perm &= ~PTE_W;
  801fc9:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  801fcd:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  801fd4:	8b 75 ec             	mov    -0x14(%rbp),%esi
  801fd7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fdb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fe2:	41 89 f0             	mov    %esi,%r8d
  801fe5:	48 89 c6             	mov    %rax,%rsi
  801fe8:	bf 00 00 00 00       	mov    $0x0,%edi
  801fed:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	callq  *%rax
  801ff9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  801ffc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802000:	79 30                	jns    802032 <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  802002:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802005:	89 c1                	mov    %eax,%ecx
  802007:	48 ba 28 4b 80 00 00 	movabs $0x804b28,%rdx
  80200e:	00 00 00 
  802011:	be 57 00 00 00       	mov    $0x57,%esi
  802016:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  80201d:	00 00 00 
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  80202c:	00 00 00 
  80202f:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  802032:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802035:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80203d:	41 89 c8             	mov    %ecx,%r8d
  802040:	48 89 d1             	mov    %rdx,%rcx
  802043:	ba 00 00 00 00       	mov    $0x0,%edx
  802048:	48 89 c6             	mov    %rax,%rsi
  80204b:	bf 00 00 00 00       	mov    $0x0,%edi
  802050:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802057:	00 00 00 
  80205a:	ff d0                	callq  *%rax
  80205c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  80205f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802063:	0f 89 8e 00 00 00    	jns    8020f7 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  802069:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80206c:	89 c1                	mov    %eax,%ecx
  80206e:	48 ba 28 4b 80 00 00 	movabs $0x804b28,%rdx
  802075:	00 00 00 
  802078:	be 5b 00 00 00       	mov    $0x5b,%esi
  80207d:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  802084:	00 00 00 
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
  80208c:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  802093:	00 00 00 
  802096:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  802099:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80209c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020a0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a7:	41 89 f0             	mov    %esi,%r8d
  8020aa:	48 89 c6             	mov    %rax,%rsi
  8020ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b2:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  8020b9:	00 00 00 
  8020bc:	ff d0                	callq  *%rax
  8020be:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8020c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8020c5:	79 30                	jns    8020f7 <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  8020c7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020ca:	89 c1                	mov    %eax,%ecx
  8020cc:	48 ba 28 4b 80 00 00 	movabs $0x804b28,%rdx
  8020d3:	00 00 00 
  8020d6:	be 61 00 00 00       	mov    $0x61,%esi
  8020db:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  8020e2:	00 00 00 
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ea:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  8020f1:	00 00 00 
  8020f4:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fc:	c9                   	leaveq 
  8020fd:	c3                   	retq   

00000000008020fe <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8020fe:	55                   	push   %rbp
  8020ff:	48 89 e5             	mov    %rsp,%rbp
  802102:	53                   	push   %rbx
  802103:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  802107:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  80210e:	48 bf 38 1d 80 00 00 	movabs $0x801d38,%rdi
  802115:	00 00 00 
  802118:	48 b8 70 43 80 00 00 	movabs $0x804370,%rax
  80211f:	00 00 00 
  802122:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802124:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  80212b:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80212e:	cd 30                	int    $0x30
  802130:	89 c3                	mov    %eax,%ebx
  802132:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802135:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  802138:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  80213b:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  80213f:	79 30                	jns    802171 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  802141:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802144:	89 c1                	mov    %eax,%ecx
  802146:	48 ba 4b 4b 80 00 00 	movabs $0x804b4b,%rdx
  80214d:	00 00 00 
  802150:	be 80 00 00 00       	mov    $0x80,%esi
  802155:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  80215c:	00 00 00 
  80215f:	b8 00 00 00 00       	mov    $0x0,%eax
  802164:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  80216b:	00 00 00 
  80216e:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  802171:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  802175:	75 52                	jne    8021c9 <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  802177:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  80217e:	00 00 00 
  802181:	ff d0                	callq  *%rax
  802183:	48 98                	cltq   
  802185:	48 89 c2             	mov    %rax,%rdx
  802188:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80218e:	48 89 d0             	mov    %rdx,%rax
  802191:	48 c1 e0 02          	shl    $0x2,%rax
  802195:	48 01 d0             	add    %rdx,%rax
  802198:	48 01 c0             	add    %rax,%rax
  80219b:	48 01 d0             	add    %rdx,%rax
  80219e:	48 c1 e0 05          	shl    $0x5,%rax
  8021a2:	48 89 c2             	mov    %rax,%rdx
  8021a5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8021ac:	00 00 00 
  8021af:	48 01 c2             	add    %rax,%rdx
  8021b2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021b9:	00 00 00 
  8021bc:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c4:	e9 9d 02 00 00       	jmpq   802466 <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  8021c9:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8021cc:	ba 07 00 00 00       	mov    $0x7,%edx
  8021d1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8021d6:	89 c7                	mov    %eax,%edi
  8021d8:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  8021df:	00 00 00 
  8021e2:	ff d0                	callq  *%rax
  8021e4:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8021e7:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8021eb:	79 30                	jns    80221d <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  8021ed:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8021f0:	89 c1                	mov    %eax,%ecx
  8021f2:	48 ba 4b 4b 80 00 00 	movabs $0x804b4b,%rdx
  8021f9:	00 00 00 
  8021fc:	be 88 00 00 00       	mov    $0x88,%esi
  802201:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  802208:	00 00 00 
  80220b:	b8 00 00 00 00       	mov    $0x0,%eax
  802210:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  802217:	00 00 00 
  80221a:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  80221d:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  802224:	00 
	uint64_t each_pte = 0;
  802225:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80222c:	00 
	uint64_t each_pdpe = 0;
  80222d:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  802234:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802235:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80223c:	00 
  80223d:	e9 73 01 00 00       	jmpq   8023b5 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  802242:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802249:	01 00 00 
  80224c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802250:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802254:	83 e0 01             	and    $0x1,%eax
  802257:	84 c0                	test   %al,%al
  802259:	0f 84 41 01 00 00    	je     8023a0 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  80225f:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  802266:	00 
  802267:	e9 24 01 00 00       	jmpq   802390 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  80226c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802273:	01 00 00 
  802276:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80227a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80227e:	83 e0 01             	and    $0x1,%eax
  802281:	84 c0                	test   %al,%al
  802283:	0f 84 ed 00 00 00    	je     802376 <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  802289:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802290:	00 
  802291:	e9 d0 00 00 00       	jmpq   802366 <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  802296:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80229d:	01 00 00 
  8022a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a8:	83 e0 01             	and    $0x1,%eax
  8022ab:	84 c0                	test   %al,%al
  8022ad:	0f 84 99 00 00 00    	je     80234c <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8022b3:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8022ba:	00 
  8022bb:	eb 7f                	jmp    80233c <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  8022bd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c4:	01 00 00 
  8022c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022cf:	83 e0 01             	and    $0x1,%eax
  8022d2:	84 c0                	test   %al,%al
  8022d4:	74 5c                	je     802332 <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  8022d6:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  8022dd:	00 
  8022de:	74 52                	je     802332 <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  8022e0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8022e4:	89 c2                	mov    %eax,%edx
  8022e6:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8022e9:	89 d6                	mov    %edx,%esi
  8022eb:	89 c7                	mov    %eax,%edi
  8022ed:	48 b8 07 1f 80 00 00 	movabs $0x801f07,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
  8022f9:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  8022fc:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802300:	79 30                	jns    802332 <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  802302:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802305:	89 c1                	mov    %eax,%ecx
  802307:	48 ba 4b 4b 80 00 00 	movabs $0x804b4b,%rdx
  80230e:	00 00 00 
  802311:	be a0 00 00 00       	mov    $0xa0,%esi
  802316:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  80231d:	00 00 00 
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
  802325:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  80232c:	00 00 00 
  80232f:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802332:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  802337:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  80233c:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  802343:	00 
  802344:	0f 86 73 ff ff ff    	jbe    8022bd <fork+0x1bf>
  80234a:	eb 10                	jmp    80235c <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  80234c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802350:	48 83 c0 01          	add    $0x1,%rax
  802354:	48 c1 e0 09          	shl    $0x9,%rax
  802358:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  80235c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802361:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  802366:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  80236d:	00 
  80236e:	0f 86 22 ff ff ff    	jbe    802296 <fork+0x198>
  802374:	eb 10                	jmp    802386 <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  802376:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80237a:	48 83 c0 01          	add    $0x1,%rax
  80237e:	48 c1 e0 09          	shl    $0x9,%rax
  802382:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  802386:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80238b:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  802390:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  802397:	00 
  802398:	0f 86 ce fe ff ff    	jbe    80226c <fork+0x16e>
  80239e:	eb 10                	jmp    8023b0 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  8023a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a4:	48 83 c0 01          	add    $0x1,%rax
  8023a8:	48 c1 e0 09          	shl    $0x9,%rax
  8023ac:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8023b0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8023b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8023ba:	0f 84 82 fe ff ff    	je     802242 <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8023c0:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8023c3:	48 be 08 44 80 00 00 	movabs $0x804408,%rsi
  8023ca:	00 00 00 
  8023cd:	89 c7                	mov    %eax,%edi
  8023cf:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8023d6:	00 00 00 
  8023d9:	ff d0                	callq  *%rax
  8023db:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  8023de:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8023e2:	79 30                	jns    802414 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  8023e4:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8023e7:	89 c1                	mov    %eax,%ecx
  8023e9:	48 ba 4b 4b 80 00 00 	movabs $0x804b4b,%rdx
  8023f0:	00 00 00 
  8023f3:	be bd 00 00 00       	mov    $0xbd,%esi
  8023f8:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  8023ff:	00 00 00 
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  80240e:	00 00 00 
  802411:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  802414:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802417:	be 02 00 00 00       	mov    $0x2,%esi
  80241c:	89 c7                	mov    %eax,%edi
  80241e:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  802425:	00 00 00 
  802428:	ff d0                	callq  *%rax
  80242a:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80242d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802431:	79 30                	jns    802463 <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  802433:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802436:	89 c1                	mov    %eax,%ecx
  802438:	48 ba 4b 4b 80 00 00 	movabs $0x804b4b,%rdx
  80243f:	00 00 00 
  802442:	be c1 00 00 00       	mov    $0xc1,%esi
  802447:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  80244e:	00 00 00 
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
  802456:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  80245d:	00 00 00 
  802460:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  802463:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  802466:	48 83 c4 68          	add    $0x68,%rsp
  80246a:	5b                   	pop    %rbx
  80246b:	5d                   	pop    %rbp
  80246c:	c3                   	retq   

000000000080246d <sfork>:

// Challenge!
int
sfork(void)
{
  80246d:	55                   	push   %rbp
  80246e:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802471:	48 ba 64 4b 80 00 00 	movabs $0x804b64,%rdx
  802478:	00 00 00 
  80247b:	be cc 00 00 00       	mov    $0xcc,%esi
  802480:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  802487:	00 00 00 
  80248a:	b8 00 00 00 00       	mov    $0x0,%eax
  80248f:	48 b9 a4 02 80 00 00 	movabs $0x8002a4,%rcx
  802496:	00 00 00 
  802499:	ff d1                	callq  *%rcx
	...

000000000080249c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80249c:	55                   	push   %rbp
  80249d:	48 89 e5             	mov    %rsp,%rbp
  8024a0:	48 83 ec 30          	sub    $0x30,%rsp
  8024a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  8024b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8024b7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8024bc:	74 18                	je     8024d6 <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8024be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024c2:	48 89 c7             	mov    %rax,%rdi
  8024c5:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  8024cc:	00 00 00 
  8024cf:	ff d0                	callq  *%rax
  8024d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d4:	eb 19                	jmp    8024ef <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8024d6:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8024dd:	00 00 00 
  8024e0:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  8024e7:	00 00 00 
  8024ea:	ff d0                	callq  *%rax
  8024ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  8024ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f3:	79 39                	jns    80252e <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  8024f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8024fa:	75 08                	jne    802504 <ipc_recv+0x68>
  8024fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802500:	8b 00                	mov    (%rax),%eax
  802502:	eb 05                	jmp    802509 <ipc_recv+0x6d>
  802504:	b8 00 00 00 00       	mov    $0x0,%eax
  802509:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80250d:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  80250f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802514:	75 08                	jne    80251e <ipc_recv+0x82>
  802516:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80251a:	8b 00                	mov    (%rax),%eax
  80251c:	eb 05                	jmp    802523 <ipc_recv+0x87>
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802527:	89 02                	mov    %eax,(%rdx)
		return r;
  802529:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252c:	eb 53                	jmp    802581 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  80252e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802533:	74 19                	je     80254e <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  802535:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80253c:	00 00 00 
  80253f:	48 8b 00             	mov    (%rax),%rax
  802542:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254c:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  80254e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802553:	74 19                	je     80256e <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  802555:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80255c:	00 00 00 
  80255f:	48 8b 00             	mov    (%rax),%rax
  802562:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80256c:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  80256e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802575:	00 00 00 
  802578:	48 8b 00             	mov    (%rax),%rax
  80257b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  802581:	c9                   	leaveq 
  802582:	c3                   	retq   

0000000000802583 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802583:	55                   	push   %rbp
  802584:	48 89 e5             	mov    %rsp,%rbp
  802587:	48 83 ec 30          	sub    $0x30,%rsp
  80258b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80258e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802591:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802595:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  802598:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  80259f:	eb 59                	jmp    8025fa <ipc_send+0x77>
		if(pg) {
  8025a1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8025a6:	74 20                	je     8025c8 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8025a8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8025ab:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8025ae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025b5:	89 c7                	mov    %eax,%edi
  8025b7:	48 b8 bc 1b 80 00 00 	movabs $0x801bbc,%rax
  8025be:	00 00 00 
  8025c1:	ff d0                	callq  *%rax
  8025c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c6:	eb 26                	jmp    8025ee <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8025c8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8025cb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025d1:	89 d1                	mov    %edx,%ecx
  8025d3:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8025da:	00 00 00 
  8025dd:	89 c7                	mov    %eax,%edi
  8025df:	48 b8 bc 1b 80 00 00 	movabs $0x801bbc,%rax
  8025e6:	00 00 00 
  8025e9:	ff d0                	callq  *%rax
  8025eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  8025ee:	48 b8 aa 19 80 00 00 	movabs $0x8019aa,%rax
  8025f5:	00 00 00 
  8025f8:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  8025fa:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8025fe:	74 a1                	je     8025a1 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  802600:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802604:	74 2a                	je     802630 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  802606:	48 ba 80 4b 80 00 00 	movabs $0x804b80,%rdx
  80260d:	00 00 00 
  802610:	be 49 00 00 00       	mov    $0x49,%esi
  802615:	48 bf ab 4b 80 00 00 	movabs $0x804bab,%rdi
  80261c:	00 00 00 
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
  802624:	48 b9 a4 02 80 00 00 	movabs $0x8002a4,%rcx
  80262b:	00 00 00 
  80262e:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  802630:	c9                   	leaveq 
  802631:	c3                   	retq   

0000000000802632 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802632:	55                   	push   %rbp
  802633:	48 89 e5             	mov    %rsp,%rbp
  802636:	48 83 ec 18          	sub    $0x18,%rsp
  80263a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80263d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802644:	eb 6a                	jmp    8026b0 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  802646:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80264d:	00 00 00 
  802650:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802653:	48 63 d0             	movslq %eax,%rdx
  802656:	48 89 d0             	mov    %rdx,%rax
  802659:	48 c1 e0 02          	shl    $0x2,%rax
  80265d:	48 01 d0             	add    %rdx,%rax
  802660:	48 01 c0             	add    %rax,%rax
  802663:	48 01 d0             	add    %rdx,%rax
  802666:	48 c1 e0 05          	shl    $0x5,%rax
  80266a:	48 01 c8             	add    %rcx,%rax
  80266d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802673:	8b 00                	mov    (%rax),%eax
  802675:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802678:	75 32                	jne    8026ac <ipc_find_env+0x7a>
			return envs[i].env_id;
  80267a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802681:	00 00 00 
  802684:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802687:	48 63 d0             	movslq %eax,%rdx
  80268a:	48 89 d0             	mov    %rdx,%rax
  80268d:	48 c1 e0 02          	shl    $0x2,%rax
  802691:	48 01 d0             	add    %rdx,%rax
  802694:	48 01 c0             	add    %rax,%rax
  802697:	48 01 d0             	add    %rdx,%rax
  80269a:	48 c1 e0 05          	shl    $0x5,%rax
  80269e:	48 01 c8             	add    %rcx,%rax
  8026a1:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8026a7:	8b 40 08             	mov    0x8(%rax),%eax
  8026aa:	eb 12                	jmp    8026be <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8026ac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026b0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8026b7:	7e 8d                	jle    802646 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026be:	c9                   	leaveq 
  8026bf:	c3                   	retq   

00000000008026c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026c0:	55                   	push   %rbp
  8026c1:	48 89 e5             	mov    %rsp,%rbp
  8026c4:	48 83 ec 08          	sub    $0x8,%rsp
  8026c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026d0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026d7:	ff ff ff 
  8026da:	48 01 d0             	add    %rdx,%rax
  8026dd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026e1:	c9                   	leaveq 
  8026e2:	c3                   	retq   

00000000008026e3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026e3:	55                   	push   %rbp
  8026e4:	48 89 e5             	mov    %rsp,%rbp
  8026e7:	48 83 ec 08          	sub    $0x8,%rsp
  8026eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f3:	48 89 c7             	mov    %rax,%rdi
  8026f6:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax
  802702:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802708:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80270c:	c9                   	leaveq 
  80270d:	c3                   	retq   

000000000080270e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80270e:	55                   	push   %rbp
  80270f:	48 89 e5             	mov    %rsp,%rbp
  802712:	48 83 ec 18          	sub    $0x18,%rsp
  802716:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80271a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802721:	eb 6b                	jmp    80278e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802726:	48 98                	cltq   
  802728:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80272e:	48 c1 e0 0c          	shl    $0xc,%rax
  802732:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802736:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273a:	48 89 c2             	mov    %rax,%rdx
  80273d:	48 c1 ea 15          	shr    $0x15,%rdx
  802741:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802748:	01 00 00 
  80274b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274f:	83 e0 01             	and    $0x1,%eax
  802752:	48 85 c0             	test   %rax,%rax
  802755:	74 21                	je     802778 <fd_alloc+0x6a>
  802757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275b:	48 89 c2             	mov    %rax,%rdx
  80275e:	48 c1 ea 0c          	shr    $0xc,%rdx
  802762:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802769:	01 00 00 
  80276c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802770:	83 e0 01             	and    $0x1,%eax
  802773:	48 85 c0             	test   %rax,%rax
  802776:	75 12                	jne    80278a <fd_alloc+0x7c>
			*fd_store = fd;
  802778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802780:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	eb 1a                	jmp    8027a4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80278a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80278e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802792:	7e 8f                	jle    802723 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802798:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80279f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027a4:	c9                   	leaveq 
  8027a5:	c3                   	retq   

00000000008027a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027a6:	55                   	push   %rbp
  8027a7:	48 89 e5             	mov    %rsp,%rbp
  8027aa:	48 83 ec 20          	sub    $0x20,%rsp
  8027ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027b9:	78 06                	js     8027c1 <fd_lookup+0x1b>
  8027bb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027bf:	7e 07                	jle    8027c8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027c6:	eb 6c                	jmp    802834 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027cb:	48 98                	cltq   
  8027cd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027d3:	48 c1 e0 0c          	shl    $0xc,%rax
  8027d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027df:	48 89 c2             	mov    %rax,%rdx
  8027e2:	48 c1 ea 15          	shr    $0x15,%rdx
  8027e6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027ed:	01 00 00 
  8027f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f4:	83 e0 01             	and    $0x1,%eax
  8027f7:	48 85 c0             	test   %rax,%rax
  8027fa:	74 21                	je     80281d <fd_lookup+0x77>
  8027fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802800:	48 89 c2             	mov    %rax,%rdx
  802803:	48 c1 ea 0c          	shr    $0xc,%rdx
  802807:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80280e:	01 00 00 
  802811:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802815:	83 e0 01             	and    $0x1,%eax
  802818:	48 85 c0             	test   %rax,%rax
  80281b:	75 07                	jne    802824 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80281d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802822:	eb 10                	jmp    802834 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802824:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802828:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80282c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80282f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802834:	c9                   	leaveq 
  802835:	c3                   	retq   

0000000000802836 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802836:	55                   	push   %rbp
  802837:	48 89 e5             	mov    %rsp,%rbp
  80283a:	48 83 ec 30          	sub    $0x30,%rsp
  80283e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802842:	89 f0                	mov    %esi,%eax
  802844:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802847:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284b:	48 89 c7             	mov    %rax,%rdi
  80284e:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  802855:	00 00 00 
  802858:	ff d0                	callq  *%rax
  80285a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80285e:	48 89 d6             	mov    %rdx,%rsi
  802861:	89 c7                	mov    %eax,%edi
  802863:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  80286a:	00 00 00 
  80286d:	ff d0                	callq  *%rax
  80286f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802872:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802876:	78 0a                	js     802882 <fd_close+0x4c>
	    || fd != fd2)
  802878:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802880:	74 12                	je     802894 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802882:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802886:	74 05                	je     80288d <fd_close+0x57>
  802888:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288b:	eb 05                	jmp    802892 <fd_close+0x5c>
  80288d:	b8 00 00 00 00       	mov    $0x0,%eax
  802892:	eb 69                	jmp    8028fd <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802894:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802898:	8b 00                	mov    (%rax),%eax
  80289a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80289e:	48 89 d6             	mov    %rdx,%rsi
  8028a1:	89 c7                	mov    %eax,%edi
  8028a3:	48 b8 ff 28 80 00 00 	movabs $0x8028ff,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
  8028af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b6:	78 2a                	js     8028e2 <fd_close+0xac>
		if (dev->dev_close)
  8028b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028bc:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028c0:	48 85 c0             	test   %rax,%rax
  8028c3:	74 16                	je     8028db <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8028c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c9:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8028cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028d1:	48 89 c7             	mov    %rax,%rdi
  8028d4:	ff d2                	callq  *%rdx
  8028d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d9:	eb 07                	jmp    8028e2 <fd_close+0xac>
		else
			r = 0;
  8028db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e6:	48 89 c6             	mov    %rax,%rsi
  8028e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ee:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  8028f5:	00 00 00 
  8028f8:	ff d0                	callq  *%rax
	return r;
  8028fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028fd:	c9                   	leaveq 
  8028fe:	c3                   	retq   

00000000008028ff <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8028ff:	55                   	push   %rbp
  802900:	48 89 e5             	mov    %rsp,%rbp
  802903:	48 83 ec 20          	sub    $0x20,%rsp
  802907:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80290a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80290e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802915:	eb 41                	jmp    802958 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802917:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80291e:	00 00 00 
  802921:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802924:	48 63 d2             	movslq %edx,%rdx
  802927:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292b:	8b 00                	mov    (%rax),%eax
  80292d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802930:	75 22                	jne    802954 <dev_lookup+0x55>
			*dev = devtab[i];
  802932:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802939:	00 00 00 
  80293c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80293f:	48 63 d2             	movslq %edx,%rdx
  802942:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802946:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80294d:	b8 00 00 00 00       	mov    $0x0,%eax
  802952:	eb 60                	jmp    8029b4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802954:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802958:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80295f:	00 00 00 
  802962:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802965:	48 63 d2             	movslq %edx,%rdx
  802968:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296c:	48 85 c0             	test   %rax,%rax
  80296f:	75 a6                	jne    802917 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802971:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802978:	00 00 00 
  80297b:	48 8b 00             	mov    (%rax),%rax
  80297e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802984:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802987:	89 c6                	mov    %eax,%esi
  802989:	48 bf b8 4b 80 00 00 	movabs $0x804bb8,%rdi
  802990:	00 00 00 
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	48 b9 df 04 80 00 00 	movabs $0x8004df,%rcx
  80299f:	00 00 00 
  8029a2:	ff d1                	callq  *%rcx
	*dev = 0;
  8029a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029b4:	c9                   	leaveq 
  8029b5:	c3                   	retq   

00000000008029b6 <close>:

int
close(int fdnum)
{
  8029b6:	55                   	push   %rbp
  8029b7:	48 89 e5             	mov    %rsp,%rbp
  8029ba:	48 83 ec 20          	sub    $0x20,%rsp
  8029be:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029c1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029c8:	48 89 d6             	mov    %rdx,%rsi
  8029cb:	89 c7                	mov    %eax,%edi
  8029cd:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  8029d4:	00 00 00 
  8029d7:	ff d0                	callq  *%rax
  8029d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e0:	79 05                	jns    8029e7 <close+0x31>
		return r;
  8029e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e5:	eb 18                	jmp    8029ff <close+0x49>
	else
		return fd_close(fd, 1);
  8029e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029eb:	be 01 00 00 00       	mov    $0x1,%esi
  8029f0:	48 89 c7             	mov    %rax,%rdi
  8029f3:	48 b8 36 28 80 00 00 	movabs $0x802836,%rax
  8029fa:	00 00 00 
  8029fd:	ff d0                	callq  *%rax
}
  8029ff:	c9                   	leaveq 
  802a00:	c3                   	retq   

0000000000802a01 <close_all>:

void
close_all(void)
{
  802a01:	55                   	push   %rbp
  802a02:	48 89 e5             	mov    %rsp,%rbp
  802a05:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a10:	eb 15                	jmp    802a27 <close_all+0x26>
		close(i);
  802a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a15:	89 c7                	mov    %eax,%edi
  802a17:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a23:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a27:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a2b:	7e e5                	jle    802a12 <close_all+0x11>
		close(i);
}
  802a2d:	c9                   	leaveq 
  802a2e:	c3                   	retq   

0000000000802a2f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a2f:	55                   	push   %rbp
  802a30:	48 89 e5             	mov    %rsp,%rbp
  802a33:	48 83 ec 40          	sub    $0x40,%rsp
  802a37:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a3a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a3d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a41:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a44:	48 89 d6             	mov    %rdx,%rsi
  802a47:	89 c7                	mov    %eax,%edi
  802a49:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802a50:	00 00 00 
  802a53:	ff d0                	callq  *%rax
  802a55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5c:	79 08                	jns    802a66 <dup+0x37>
		return r;
  802a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a61:	e9 70 01 00 00       	jmpq   802bd6 <dup+0x1a7>
	close(newfdnum);
  802a66:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a69:	89 c7                	mov    %eax,%edi
  802a6b:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a77:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a7a:	48 98                	cltq   
  802a7c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a82:	48 c1 e0 0c          	shl    $0xc,%rax
  802a86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a8e:	48 89 c7             	mov    %rax,%rdi
  802a91:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  802a98:	00 00 00 
  802a9b:	ff d0                	callq  *%rax
  802a9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802aa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa5:	48 89 c7             	mov    %rax,%rdi
  802aa8:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  802aaf:	00 00 00 
  802ab2:	ff d0                	callq  *%rax
  802ab4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abc:	48 89 c2             	mov    %rax,%rdx
  802abf:	48 c1 ea 15          	shr    $0x15,%rdx
  802ac3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802aca:	01 00 00 
  802acd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ad1:	83 e0 01             	and    $0x1,%eax
  802ad4:	84 c0                	test   %al,%al
  802ad6:	74 71                	je     802b49 <dup+0x11a>
  802ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802adc:	48 89 c2             	mov    %rax,%rdx
  802adf:	48 c1 ea 0c          	shr    $0xc,%rdx
  802ae3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802aea:	01 00 00 
  802aed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802af1:	83 e0 01             	and    $0x1,%eax
  802af4:	84 c0                	test   %al,%al
  802af6:	74 51                	je     802b49 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802af8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afc:	48 89 c2             	mov    %rax,%rdx
  802aff:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b03:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b0a:	01 00 00 
  802b0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b11:	89 c1                	mov    %eax,%ecx
  802b13:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802b19:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b21:	41 89 c8             	mov    %ecx,%r8d
  802b24:	48 89 d1             	mov    %rdx,%rcx
  802b27:	ba 00 00 00 00       	mov    $0x0,%edx
  802b2c:	48 89 c6             	mov    %rax,%rsi
  802b2f:	bf 00 00 00 00       	mov    $0x0,%edi
  802b34:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802b3b:	00 00 00 
  802b3e:	ff d0                	callq  *%rax
  802b40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b47:	78 56                	js     802b9f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b4d:	48 89 c2             	mov    %rax,%rdx
  802b50:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b54:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b5b:	01 00 00 
  802b5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b62:	89 c1                	mov    %eax,%ecx
  802b64:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802b6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b72:	41 89 c8             	mov    %ecx,%r8d
  802b75:	48 89 d1             	mov    %rdx,%rcx
  802b78:	ba 00 00 00 00       	mov    $0x0,%edx
  802b7d:	48 89 c6             	mov    %rax,%rsi
  802b80:	bf 00 00 00 00       	mov    $0x0,%edi
  802b85:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802b8c:	00 00 00 
  802b8f:	ff d0                	callq  *%rax
  802b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b98:	78 08                	js     802ba2 <dup+0x173>
		goto err;

	return newfdnum;
  802b9a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b9d:	eb 37                	jmp    802bd6 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802b9f:	90                   	nop
  802ba0:	eb 01                	jmp    802ba3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802ba2:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba7:	48 89 c6             	mov    %rax,%rsi
  802baa:	bf 00 00 00 00       	mov    $0x0,%edi
  802baf:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  802bb6:	00 00 00 
  802bb9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bbb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bbf:	48 89 c6             	mov    %rax,%rsi
  802bc2:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc7:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  802bce:	00 00 00 
  802bd1:	ff d0                	callq  *%rax
	return r;
  802bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bd6:	c9                   	leaveq 
  802bd7:	c3                   	retq   

0000000000802bd8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bd8:	55                   	push   %rbp
  802bd9:	48 89 e5             	mov    %rsp,%rbp
  802bdc:	48 83 ec 40          	sub    $0x40,%rsp
  802be0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802be3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802be7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802beb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bf2:	48 89 d6             	mov    %rdx,%rsi
  802bf5:	89 c7                	mov    %eax,%edi
  802bf7:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802bfe:	00 00 00 
  802c01:	ff d0                	callq  *%rax
  802c03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0a:	78 24                	js     802c30 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c10:	8b 00                	mov    (%rax),%eax
  802c12:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c16:	48 89 d6             	mov    %rdx,%rsi
  802c19:	89 c7                	mov    %eax,%edi
  802c1b:	48 b8 ff 28 80 00 00 	movabs $0x8028ff,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
  802c27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2e:	79 05                	jns    802c35 <read+0x5d>
		return r;
  802c30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c33:	eb 7a                	jmp    802caf <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c39:	8b 40 08             	mov    0x8(%rax),%eax
  802c3c:	83 e0 03             	and    $0x3,%eax
  802c3f:	83 f8 01             	cmp    $0x1,%eax
  802c42:	75 3a                	jne    802c7e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c44:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c4b:	00 00 00 
  802c4e:	48 8b 00             	mov    (%rax),%rax
  802c51:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c57:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c5a:	89 c6                	mov    %eax,%esi
  802c5c:	48 bf d7 4b 80 00 00 	movabs $0x804bd7,%rdi
  802c63:	00 00 00 
  802c66:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6b:	48 b9 df 04 80 00 00 	movabs $0x8004df,%rcx
  802c72:	00 00 00 
  802c75:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c7c:	eb 31                	jmp    802caf <read+0xd7>
	}
	if (!dev->dev_read)
  802c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c82:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c86:	48 85 c0             	test   %rax,%rax
  802c89:	75 07                	jne    802c92 <read+0xba>
		return -E_NOT_SUPP;
  802c8b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c90:	eb 1d                	jmp    802caf <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802c92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c96:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802c9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ca2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ca6:	48 89 ce             	mov    %rcx,%rsi
  802ca9:	48 89 c7             	mov    %rax,%rdi
  802cac:	41 ff d0             	callq  *%r8
}
  802caf:	c9                   	leaveq 
  802cb0:	c3                   	retq   

0000000000802cb1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cb1:	55                   	push   %rbp
  802cb2:	48 89 e5             	mov    %rsp,%rbp
  802cb5:	48 83 ec 30          	sub    $0x30,%rsp
  802cb9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cbc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cc0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ccb:	eb 46                	jmp    802d13 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd0:	48 98                	cltq   
  802cd2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cd6:	48 29 c2             	sub    %rax,%rdx
  802cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdc:	48 98                	cltq   
  802cde:	48 89 c1             	mov    %rax,%rcx
  802ce1:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802ce5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ce8:	48 89 ce             	mov    %rcx,%rsi
  802ceb:	89 c7                	mov    %eax,%edi
  802ced:	48 b8 d8 2b 80 00 00 	movabs $0x802bd8,%rax
  802cf4:	00 00 00 
  802cf7:	ff d0                	callq  *%rax
  802cf9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802cfc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d00:	79 05                	jns    802d07 <readn+0x56>
			return m;
  802d02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d05:	eb 1d                	jmp    802d24 <readn+0x73>
		if (m == 0)
  802d07:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d0b:	74 13                	je     802d20 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d10:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d16:	48 98                	cltq   
  802d18:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d1c:	72 af                	jb     802ccd <readn+0x1c>
  802d1e:	eb 01                	jmp    802d21 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802d20:	90                   	nop
	}
	return tot;
  802d21:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d24:	c9                   	leaveq 
  802d25:	c3                   	retq   

0000000000802d26 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d26:	55                   	push   %rbp
  802d27:	48 89 e5             	mov    %rsp,%rbp
  802d2a:	48 83 ec 40          	sub    $0x40,%rsp
  802d2e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d31:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d35:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d39:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d3d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d40:	48 89 d6             	mov    %rdx,%rsi
  802d43:	89 c7                	mov    %eax,%edi
  802d45:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802d4c:	00 00 00 
  802d4f:	ff d0                	callq  *%rax
  802d51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d58:	78 24                	js     802d7e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5e:	8b 00                	mov    (%rax),%eax
  802d60:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d64:	48 89 d6             	mov    %rdx,%rsi
  802d67:	89 c7                	mov    %eax,%edi
  802d69:	48 b8 ff 28 80 00 00 	movabs $0x8028ff,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
  802d75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7c:	79 05                	jns    802d83 <write+0x5d>
		return r;
  802d7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d81:	eb 79                	jmp    802dfc <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d87:	8b 40 08             	mov    0x8(%rax),%eax
  802d8a:	83 e0 03             	and    $0x3,%eax
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	75 3a                	jne    802dcb <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d91:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d98:	00 00 00 
  802d9b:	48 8b 00             	mov    (%rax),%rax
  802d9e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802da4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802da7:	89 c6                	mov    %eax,%esi
  802da9:	48 bf f3 4b 80 00 00 	movabs $0x804bf3,%rdi
  802db0:	00 00 00 
  802db3:	b8 00 00 00 00       	mov    $0x0,%eax
  802db8:	48 b9 df 04 80 00 00 	movabs $0x8004df,%rcx
  802dbf:	00 00 00 
  802dc2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802dc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dc9:	eb 31                	jmp    802dfc <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcf:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dd3:	48 85 c0             	test   %rax,%rax
  802dd6:	75 07                	jne    802ddf <write+0xb9>
		return -E_NOT_SUPP;
  802dd8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ddd:	eb 1d                	jmp    802dfc <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802ddf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de3:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802de7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802deb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802def:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802df3:	48 89 ce             	mov    %rcx,%rsi
  802df6:	48 89 c7             	mov    %rax,%rdi
  802df9:	41 ff d0             	callq  *%r8
}
  802dfc:	c9                   	leaveq 
  802dfd:	c3                   	retq   

0000000000802dfe <seek>:

int
seek(int fdnum, off_t offset)
{
  802dfe:	55                   	push   %rbp
  802dff:	48 89 e5             	mov    %rsp,%rbp
  802e02:	48 83 ec 18          	sub    $0x18,%rsp
  802e06:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e09:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e0c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e13:	48 89 d6             	mov    %rdx,%rsi
  802e16:	89 c7                	mov    %eax,%edi
  802e18:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
  802e24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2b:	79 05                	jns    802e32 <seek+0x34>
		return r;
  802e2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e30:	eb 0f                	jmp    802e41 <seek+0x43>
	fd->fd_offset = offset;
  802e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e36:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e39:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e41:	c9                   	leaveq 
  802e42:	c3                   	retq   

0000000000802e43 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e43:	55                   	push   %rbp
  802e44:	48 89 e5             	mov    %rsp,%rbp
  802e47:	48 83 ec 30          	sub    $0x30,%rsp
  802e4b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e4e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e51:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e55:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e58:	48 89 d6             	mov    %rdx,%rsi
  802e5b:	89 c7                	mov    %eax,%edi
  802e5d:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802e64:	00 00 00 
  802e67:	ff d0                	callq  *%rax
  802e69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e70:	78 24                	js     802e96 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e76:	8b 00                	mov    (%rax),%eax
  802e78:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e7c:	48 89 d6             	mov    %rdx,%rsi
  802e7f:	89 c7                	mov    %eax,%edi
  802e81:	48 b8 ff 28 80 00 00 	movabs $0x8028ff,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
  802e8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e94:	79 05                	jns    802e9b <ftruncate+0x58>
		return r;
  802e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e99:	eb 72                	jmp    802f0d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9f:	8b 40 08             	mov    0x8(%rax),%eax
  802ea2:	83 e0 03             	and    $0x3,%eax
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	75 3a                	jne    802ee3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ea9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802eb0:	00 00 00 
  802eb3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802eb6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ebc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ebf:	89 c6                	mov    %eax,%esi
  802ec1:	48 bf 10 4c 80 00 00 	movabs $0x804c10,%rdi
  802ec8:	00 00 00 
  802ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed0:	48 b9 df 04 80 00 00 	movabs $0x8004df,%rcx
  802ed7:	00 00 00 
  802eda:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802edc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ee1:	eb 2a                	jmp    802f0d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ee3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee7:	48 8b 40 30          	mov    0x30(%rax),%rax
  802eeb:	48 85 c0             	test   %rax,%rax
  802eee:	75 07                	jne    802ef7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ef0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ef5:	eb 16                	jmp    802f0d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ef7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efb:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802eff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f03:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802f06:	89 d6                	mov    %edx,%esi
  802f08:	48 89 c7             	mov    %rax,%rdi
  802f0b:	ff d1                	callq  *%rcx
}
  802f0d:	c9                   	leaveq 
  802f0e:	c3                   	retq   

0000000000802f0f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f0f:	55                   	push   %rbp
  802f10:	48 89 e5             	mov    %rsp,%rbp
  802f13:	48 83 ec 30          	sub    $0x30,%rsp
  802f17:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f1a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f1e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f22:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f25:	48 89 d6             	mov    %rdx,%rsi
  802f28:	89 c7                	mov    %eax,%edi
  802f2a:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	callq  *%rax
  802f36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3d:	78 24                	js     802f63 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f43:	8b 00                	mov    (%rax),%eax
  802f45:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f49:	48 89 d6             	mov    %rdx,%rsi
  802f4c:	89 c7                	mov    %eax,%edi
  802f4e:	48 b8 ff 28 80 00 00 	movabs $0x8028ff,%rax
  802f55:	00 00 00 
  802f58:	ff d0                	callq  *%rax
  802f5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f61:	79 05                	jns    802f68 <fstat+0x59>
		return r;
  802f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f66:	eb 5e                	jmp    802fc6 <fstat+0xb7>
	if (!dev->dev_stat)
  802f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f70:	48 85 c0             	test   %rax,%rax
  802f73:	75 07                	jne    802f7c <fstat+0x6d>
		return -E_NOT_SUPP;
  802f75:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f7a:	eb 4a                	jmp    802fc6 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f80:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f87:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f8e:	00 00 00 
	stat->st_isdir = 0;
  802f91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f95:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f9c:	00 00 00 
	stat->st_dev = dev;
  802f9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fa3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb2:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802fb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fba:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802fbe:	48 89 d6             	mov    %rdx,%rsi
  802fc1:	48 89 c7             	mov    %rax,%rdi
  802fc4:	ff d1                	callq  *%rcx
}
  802fc6:	c9                   	leaveq 
  802fc7:	c3                   	retq   

0000000000802fc8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fc8:	55                   	push   %rbp
  802fc9:	48 89 e5             	mov    %rsp,%rbp
  802fcc:	48 83 ec 20          	sub    $0x20,%rsp
  802fd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fd4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802fd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fdc:	be 00 00 00 00       	mov    $0x0,%esi
  802fe1:	48 89 c7             	mov    %rax,%rdi
  802fe4:	48 b8 b7 30 80 00 00 	movabs $0x8030b7,%rax
  802feb:	00 00 00 
  802fee:	ff d0                	callq  *%rax
  802ff0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff7:	79 05                	jns    802ffe <stat+0x36>
		return fd;
  802ff9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffc:	eb 2f                	jmp    80302d <stat+0x65>
	r = fstat(fd, stat);
  802ffe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803002:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803005:	48 89 d6             	mov    %rdx,%rsi
  803008:	89 c7                	mov    %eax,%edi
  80300a:	48 b8 0f 2f 80 00 00 	movabs $0x802f0f,%rax
  803011:	00 00 00 
  803014:	ff d0                	callq  *%rax
  803016:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803019:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301c:	89 c7                	mov    %eax,%edi
  80301e:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  803025:	00 00 00 
  803028:	ff d0                	callq  *%rax
	return r;
  80302a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80302d:	c9                   	leaveq 
  80302e:	c3                   	retq   
	...

0000000000803030 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803030:	55                   	push   %rbp
  803031:	48 89 e5             	mov    %rsp,%rbp
  803034:	48 83 ec 10          	sub    $0x10,%rsp
  803038:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80303b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80303f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803046:	00 00 00 
  803049:	8b 00                	mov    (%rax),%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	75 1d                	jne    80306c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80304f:	bf 01 00 00 00       	mov    $0x1,%edi
  803054:	48 b8 32 26 80 00 00 	movabs $0x802632,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
  803060:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  803067:	00 00 00 
  80306a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80306c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803073:	00 00 00 
  803076:	8b 00                	mov    (%rax),%eax
  803078:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80307b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803080:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803087:	00 00 00 
  80308a:	89 c7                	mov    %eax,%edi
  80308c:	48 b8 83 25 80 00 00 	movabs $0x802583,%rax
  803093:	00 00 00 
  803096:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803098:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309c:	ba 00 00 00 00       	mov    $0x0,%edx
  8030a1:	48 89 c6             	mov    %rax,%rsi
  8030a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8030a9:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
}
  8030b5:	c9                   	leaveq 
  8030b6:	c3                   	retq   

00000000008030b7 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  8030b7:	55                   	push   %rbp
  8030b8:	48 89 e5             	mov    %rsp,%rbp
  8030bb:	48 83 ec 20          	sub    $0x20,%rsp
  8030bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030c3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  8030c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ca:	48 89 c7             	mov    %rax,%rdi
  8030cd:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  8030d4:	00 00 00 
  8030d7:	ff d0                	callq  *%rax
  8030d9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030de:	7e 0a                	jle    8030ea <open+0x33>
		return -E_BAD_PATH;
  8030e0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030e5:	e9 a5 00 00 00       	jmpq   80318f <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  8030ea:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030ee:	48 89 c7             	mov    %rax,%rdi
  8030f1:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  8030f8:	00 00 00 
  8030fb:	ff d0                	callq  *%rax
  8030fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803100:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803104:	79 08                	jns    80310e <open+0x57>
		return r;
  803106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803109:	e9 81 00 00 00       	jmpq   80318f <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  80310e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803115:	00 00 00 
  803118:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80311b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  803121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803125:	48 89 c6             	mov    %rax,%rsi
  803128:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80312f:	00 00 00 
  803132:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  80313e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803142:	48 89 c6             	mov    %rax,%rsi
  803145:	bf 01 00 00 00       	mov    $0x1,%edi
  80314a:	48 b8 30 30 80 00 00 	movabs $0x803030,%rax
  803151:	00 00 00 
  803154:	ff d0                	callq  *%rax
  803156:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  803159:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315d:	79 1d                	jns    80317c <open+0xc5>
		fd_close(new_fd, 0);
  80315f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803163:	be 00 00 00 00       	mov    $0x0,%esi
  803168:	48 89 c7             	mov    %rax,%rdi
  80316b:	48 b8 36 28 80 00 00 	movabs $0x802836,%rax
  803172:	00 00 00 
  803175:	ff d0                	callq  *%rax
		return r;	
  803177:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317a:	eb 13                	jmp    80318f <open+0xd8>
	}
	return fd2num(new_fd);
  80317c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803180:	48 89 c7             	mov    %rax,%rdi
  803183:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
}
  80318f:	c9                   	leaveq 
  803190:	c3                   	retq   

0000000000803191 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803191:	55                   	push   %rbp
  803192:	48 89 e5             	mov    %rsp,%rbp
  803195:	48 83 ec 10          	sub    $0x10,%rsp
  803199:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80319d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a1:	8b 50 0c             	mov    0xc(%rax),%edx
  8031a4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031ab:	00 00 00 
  8031ae:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031b0:	be 00 00 00 00       	mov    $0x0,%esi
  8031b5:	bf 06 00 00 00       	mov    $0x6,%edi
  8031ba:	48 b8 30 30 80 00 00 	movabs $0x803030,%rax
  8031c1:	00 00 00 
  8031c4:	ff d0                	callq  *%rax
}
  8031c6:	c9                   	leaveq 
  8031c7:	c3                   	retq   

00000000008031c8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031c8:	55                   	push   %rbp
  8031c9:	48 89 e5             	mov    %rsp,%rbp
  8031cc:	48 83 ec 30          	sub    $0x30,%rsp
  8031d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  8031dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e0:	8b 50 0c             	mov    0xc(%rax),%edx
  8031e3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031ea:	00 00 00 
  8031ed:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8031ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031f6:	00 00 00 
  8031f9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031fd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  803201:	be 00 00 00 00       	mov    $0x0,%esi
  803206:	bf 03 00 00 00       	mov    $0x3,%edi
  80320b:	48 b8 30 30 80 00 00 	movabs $0x803030,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
  803217:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  80321a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321e:	7e 23                	jle    803243 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  803220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803223:	48 63 d0             	movslq %eax,%rdx
  803226:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80322a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803231:	00 00 00 
  803234:	48 89 c7             	mov    %rax,%rdi
  803237:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  80323e:	00 00 00 
  803241:	ff d0                	callq  *%rax
	}
	return nbytes;
  803243:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803246:	c9                   	leaveq 
  803247:	c3                   	retq   

0000000000803248 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803248:	55                   	push   %rbp
  803249:	48 89 e5             	mov    %rsp,%rbp
  80324c:	48 83 ec 20          	sub    $0x20,%rsp
  803250:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803254:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80325c:	8b 50 0c             	mov    0xc(%rax),%edx
  80325f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803266:	00 00 00 
  803269:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80326b:	be 00 00 00 00       	mov    $0x0,%esi
  803270:	bf 05 00 00 00       	mov    $0x5,%edi
  803275:	48 b8 30 30 80 00 00 	movabs $0x803030,%rax
  80327c:	00 00 00 
  80327f:	ff d0                	callq  *%rax
  803281:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803284:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803288:	79 05                	jns    80328f <devfile_stat+0x47>
		return r;
  80328a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328d:	eb 56                	jmp    8032e5 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80328f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803293:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80329a:	00 00 00 
  80329d:	48 89 c7             	mov    %rax,%rdi
  8032a0:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  8032a7:	00 00 00 
  8032aa:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032b3:	00 00 00 
  8032b6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032c6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032cd:	00 00 00 
  8032d0:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8032d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032da:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8032e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032e5:	c9                   	leaveq 
  8032e6:	c3                   	retq   
	...

00000000008032e8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8032e8:	55                   	push   %rbp
  8032e9:	48 89 e5             	mov    %rsp,%rbp
  8032ec:	48 83 ec 20          	sub    $0x20,%rsp
  8032f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8032f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032fa:	48 89 d6             	mov    %rdx,%rsi
  8032fd:	89 c7                	mov    %eax,%edi
  8032ff:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  803306:	00 00 00 
  803309:	ff d0                	callq  *%rax
  80330b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803312:	79 05                	jns    803319 <fd2sockid+0x31>
		return r;
  803314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803317:	eb 24                	jmp    80333d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331d:	8b 10                	mov    (%rax),%edx
  80331f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803326:	00 00 00 
  803329:	8b 00                	mov    (%rax),%eax
  80332b:	39 c2                	cmp    %eax,%edx
  80332d:	74 07                	je     803336 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80332f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803334:	eb 07                	jmp    80333d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80333d:	c9                   	leaveq 
  80333e:	c3                   	retq   

000000000080333f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80333f:	55                   	push   %rbp
  803340:	48 89 e5             	mov    %rsp,%rbp
  803343:	48 83 ec 20          	sub    $0x20,%rsp
  803347:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80334a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80334e:	48 89 c7             	mov    %rax,%rdi
  803351:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  803358:	00 00 00 
  80335b:	ff d0                	callq  *%rax
  80335d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803360:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803364:	78 26                	js     80338c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803366:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80336a:	ba 07 04 00 00       	mov    $0x407,%edx
  80336f:	48 89 c6             	mov    %rax,%rsi
  803372:	bf 00 00 00 00       	mov    $0x0,%edi
  803377:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
  803383:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803386:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80338a:	79 16                	jns    8033a2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80338c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80338f:	89 c7                	mov    %eax,%edi
  803391:	48 b8 4c 38 80 00 00 	movabs $0x80384c,%rax
  803398:	00 00 00 
  80339b:	ff d0                	callq  *%rax
		return r;
  80339d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a0:	eb 3a                	jmp    8033dc <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8033a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a6:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8033ad:	00 00 00 
  8033b0:	8b 12                	mov    (%rdx),%edx
  8033b2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8033b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8033bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033c6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8033c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cd:	48 89 c7             	mov    %rax,%rdi
  8033d0:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  8033d7:	00 00 00 
  8033da:	ff d0                	callq  *%rax
}
  8033dc:	c9                   	leaveq 
  8033dd:	c3                   	retq   

00000000008033de <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8033de:	55                   	push   %rbp
  8033df:	48 89 e5             	mov    %rsp,%rbp
  8033e2:	48 83 ec 30          	sub    $0x30,%rsp
  8033e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033f4:	89 c7                	mov    %eax,%edi
  8033f6:	48 b8 e8 32 80 00 00 	movabs $0x8032e8,%rax
  8033fd:	00 00 00 
  803400:	ff d0                	callq  *%rax
  803402:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803405:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803409:	79 05                	jns    803410 <accept+0x32>
		return r;
  80340b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340e:	eb 3b                	jmp    80344b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803410:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803414:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341b:	48 89 ce             	mov    %rcx,%rsi
  80341e:	89 c7                	mov    %eax,%edi
  803420:	48 b8 29 37 80 00 00 	movabs $0x803729,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803433:	79 05                	jns    80343a <accept+0x5c>
		return r;
  803435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803438:	eb 11                	jmp    80344b <accept+0x6d>
	return alloc_sockfd(r);
  80343a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343d:	89 c7                	mov    %eax,%edi
  80343f:	48 b8 3f 33 80 00 00 	movabs $0x80333f,%rax
  803446:	00 00 00 
  803449:	ff d0                	callq  *%rax
}
  80344b:	c9                   	leaveq 
  80344c:	c3                   	retq   

000000000080344d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80344d:	55                   	push   %rbp
  80344e:	48 89 e5             	mov    %rsp,%rbp
  803451:	48 83 ec 20          	sub    $0x20,%rsp
  803455:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803458:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80345c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80345f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803462:	89 c7                	mov    %eax,%edi
  803464:	48 b8 e8 32 80 00 00 	movabs $0x8032e8,%rax
  80346b:	00 00 00 
  80346e:	ff d0                	callq  *%rax
  803470:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803473:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803477:	79 05                	jns    80347e <bind+0x31>
		return r;
  803479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347c:	eb 1b                	jmp    803499 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80347e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803481:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803485:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803488:	48 89 ce             	mov    %rcx,%rsi
  80348b:	89 c7                	mov    %eax,%edi
  80348d:	48 b8 a8 37 80 00 00 	movabs $0x8037a8,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
}
  803499:	c9                   	leaveq 
  80349a:	c3                   	retq   

000000000080349b <shutdown>:

int
shutdown(int s, int how)
{
  80349b:	55                   	push   %rbp
  80349c:	48 89 e5             	mov    %rsp,%rbp
  80349f:	48 83 ec 20          	sub    $0x20,%rsp
  8034a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034a6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ac:	89 c7                	mov    %eax,%edi
  8034ae:	48 b8 e8 32 80 00 00 	movabs $0x8032e8,%rax
  8034b5:	00 00 00 
  8034b8:	ff d0                	callq  *%rax
  8034ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c1:	79 05                	jns    8034c8 <shutdown+0x2d>
		return r;
  8034c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c6:	eb 16                	jmp    8034de <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8034c8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ce:	89 d6                	mov    %edx,%esi
  8034d0:	89 c7                	mov    %eax,%edi
  8034d2:	48 b8 0c 38 80 00 00 	movabs $0x80380c,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
}
  8034de:	c9                   	leaveq 
  8034df:	c3                   	retq   

00000000008034e0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8034e0:	55                   	push   %rbp
  8034e1:	48 89 e5             	mov    %rsp,%rbp
  8034e4:	48 83 ec 10          	sub    $0x10,%rsp
  8034e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8034ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f0:	48 89 c7             	mov    %rax,%rdi
  8034f3:	48 b8 8c 44 80 00 00 	movabs $0x80448c,%rax
  8034fa:	00 00 00 
  8034fd:	ff d0                	callq  *%rax
  8034ff:	83 f8 01             	cmp    $0x1,%eax
  803502:	75 17                	jne    80351b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803508:	8b 40 0c             	mov    0xc(%rax),%eax
  80350b:	89 c7                	mov    %eax,%edi
  80350d:	48 b8 4c 38 80 00 00 	movabs $0x80384c,%rax
  803514:	00 00 00 
  803517:	ff d0                	callq  *%rax
  803519:	eb 05                	jmp    803520 <devsock_close+0x40>
	else
		return 0;
  80351b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803520:	c9                   	leaveq 
  803521:	c3                   	retq   

0000000000803522 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803522:	55                   	push   %rbp
  803523:	48 89 e5             	mov    %rsp,%rbp
  803526:	48 83 ec 20          	sub    $0x20,%rsp
  80352a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80352d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803531:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803534:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803537:	89 c7                	mov    %eax,%edi
  803539:	48 b8 e8 32 80 00 00 	movabs $0x8032e8,%rax
  803540:	00 00 00 
  803543:	ff d0                	callq  *%rax
  803545:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803548:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354c:	79 05                	jns    803553 <connect+0x31>
		return r;
  80354e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803551:	eb 1b                	jmp    80356e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803553:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803556:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80355a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355d:	48 89 ce             	mov    %rcx,%rsi
  803560:	89 c7                	mov    %eax,%edi
  803562:	48 b8 79 38 80 00 00 	movabs $0x803879,%rax
  803569:	00 00 00 
  80356c:	ff d0                	callq  *%rax
}
  80356e:	c9                   	leaveq 
  80356f:	c3                   	retq   

0000000000803570 <listen>:

int
listen(int s, int backlog)
{
  803570:	55                   	push   %rbp
  803571:	48 89 e5             	mov    %rsp,%rbp
  803574:	48 83 ec 20          	sub    $0x20,%rsp
  803578:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80357b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80357e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803581:	89 c7                	mov    %eax,%edi
  803583:	48 b8 e8 32 80 00 00 	movabs $0x8032e8,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
  80358f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803592:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803596:	79 05                	jns    80359d <listen+0x2d>
		return r;
  803598:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359b:	eb 16                	jmp    8035b3 <listen+0x43>
	return nsipc_listen(r, backlog);
  80359d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a3:	89 d6                	mov    %edx,%esi
  8035a5:	89 c7                	mov    %eax,%edi
  8035a7:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  8035ae:	00 00 00 
  8035b1:	ff d0                	callq  *%rax
}
  8035b3:	c9                   	leaveq 
  8035b4:	c3                   	retq   

00000000008035b5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8035b5:	55                   	push   %rbp
  8035b6:	48 89 e5             	mov    %rsp,%rbp
  8035b9:	48 83 ec 20          	sub    $0x20,%rsp
  8035bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8035c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035cd:	89 c2                	mov    %eax,%edx
  8035cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d3:	8b 40 0c             	mov    0xc(%rax),%eax
  8035d6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8035da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8035df:	89 c7                	mov    %eax,%edi
  8035e1:	48 b8 1d 39 80 00 00 	movabs $0x80391d,%rax
  8035e8:	00 00 00 
  8035eb:	ff d0                	callq  *%rax
}
  8035ed:	c9                   	leaveq 
  8035ee:	c3                   	retq   

00000000008035ef <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8035ef:	55                   	push   %rbp
  8035f0:	48 89 e5             	mov    %rsp,%rbp
  8035f3:	48 83 ec 20          	sub    $0x20,%rsp
  8035f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803607:	89 c2                	mov    %eax,%edx
  803609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80360d:	8b 40 0c             	mov    0xc(%rax),%eax
  803610:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803614:	b9 00 00 00 00       	mov    $0x0,%ecx
  803619:	89 c7                	mov    %eax,%edi
  80361b:	48 b8 e9 39 80 00 00 	movabs $0x8039e9,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
}
  803627:	c9                   	leaveq 
  803628:	c3                   	retq   

0000000000803629 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803629:	55                   	push   %rbp
  80362a:	48 89 e5             	mov    %rsp,%rbp
  80362d:	48 83 ec 10          	sub    $0x10,%rsp
  803631:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803635:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803639:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80363d:	48 be 3b 4c 80 00 00 	movabs $0x804c3b,%rsi
  803644:	00 00 00 
  803647:	48 89 c7             	mov    %rax,%rdi
  80364a:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  803651:	00 00 00 
  803654:	ff d0                	callq  *%rax
	return 0;
  803656:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80365b:	c9                   	leaveq 
  80365c:	c3                   	retq   

000000000080365d <socket>:

int
socket(int domain, int type, int protocol)
{
  80365d:	55                   	push   %rbp
  80365e:	48 89 e5             	mov    %rsp,%rbp
  803661:	48 83 ec 20          	sub    $0x20,%rsp
  803665:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803668:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80366b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80366e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803671:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803674:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803677:	89 ce                	mov    %ecx,%esi
  803679:	89 c7                	mov    %eax,%edi
  80367b:	48 b8 a1 3a 80 00 00 	movabs $0x803aa1,%rax
  803682:	00 00 00 
  803685:	ff d0                	callq  *%rax
  803687:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80368a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80368e:	79 05                	jns    803695 <socket+0x38>
		return r;
  803690:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803693:	eb 11                	jmp    8036a6 <socket+0x49>
	return alloc_sockfd(r);
  803695:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803698:	89 c7                	mov    %eax,%edi
  80369a:	48 b8 3f 33 80 00 00 	movabs $0x80333f,%rax
  8036a1:	00 00 00 
  8036a4:	ff d0                	callq  *%rax
}
  8036a6:	c9                   	leaveq 
  8036a7:	c3                   	retq   

00000000008036a8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	48 83 ec 10          	sub    $0x10,%rsp
  8036b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8036b3:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8036ba:	00 00 00 
  8036bd:	8b 00                	mov    (%rax),%eax
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	75 1d                	jne    8036e0 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8036c3:	bf 02 00 00 00       	mov    $0x2,%edi
  8036c8:	48 b8 32 26 80 00 00 	movabs $0x802632,%rax
  8036cf:	00 00 00 
  8036d2:	ff d0                	callq  *%rax
  8036d4:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8036db:	00 00 00 
  8036de:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8036e0:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8036e7:	00 00 00 
  8036ea:	8b 00                	mov    (%rax),%eax
  8036ec:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8036ef:	b9 07 00 00 00       	mov    $0x7,%ecx
  8036f4:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8036fb:	00 00 00 
  8036fe:	89 c7                	mov    %eax,%edi
  803700:	48 b8 83 25 80 00 00 	movabs $0x802583,%rax
  803707:	00 00 00 
  80370a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80370c:	ba 00 00 00 00       	mov    $0x0,%edx
  803711:	be 00 00 00 00       	mov    $0x0,%esi
  803716:	bf 00 00 00 00       	mov    $0x0,%edi
  80371b:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  803722:	00 00 00 
  803725:	ff d0                	callq  *%rax
}
  803727:	c9                   	leaveq 
  803728:	c3                   	retq   

0000000000803729 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803729:	55                   	push   %rbp
  80372a:	48 89 e5             	mov    %rsp,%rbp
  80372d:	48 83 ec 30          	sub    $0x30,%rsp
  803731:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803734:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803738:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80373c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803743:	00 00 00 
  803746:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803749:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80374b:	bf 01 00 00 00       	mov    $0x1,%edi
  803750:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  803757:	00 00 00 
  80375a:	ff d0                	callq  *%rax
  80375c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80375f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803763:	78 3e                	js     8037a3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803765:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80376c:	00 00 00 
  80376f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803773:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803777:	8b 40 10             	mov    0x10(%rax),%eax
  80377a:	89 c2                	mov    %eax,%edx
  80377c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803780:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803784:	48 89 ce             	mov    %rcx,%rsi
  803787:	48 89 c7             	mov    %rax,%rdi
  80378a:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379a:	8b 50 10             	mov    0x10(%rax),%edx
  80379d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037a1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8037a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037a6:	c9                   	leaveq 
  8037a7:	c3                   	retq   

00000000008037a8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037a8:	55                   	push   %rbp
  8037a9:	48 89 e5             	mov    %rsp,%rbp
  8037ac:	48 83 ec 10          	sub    $0x10,%rsp
  8037b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037b7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8037ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037c1:	00 00 00 
  8037c4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037c7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8037c9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d0:	48 89 c6             	mov    %rax,%rsi
  8037d3:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037da:	00 00 00 
  8037dd:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  8037e4:	00 00 00 
  8037e7:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8037e9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037f0:	00 00 00 
  8037f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037f6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8037f9:	bf 02 00 00 00       	mov    $0x2,%edi
  8037fe:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  803805:	00 00 00 
  803808:	ff d0                	callq  *%rax
}
  80380a:	c9                   	leaveq 
  80380b:	c3                   	retq   

000000000080380c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80380c:	55                   	push   %rbp
  80380d:	48 89 e5             	mov    %rsp,%rbp
  803810:	48 83 ec 10          	sub    $0x10,%rsp
  803814:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803817:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80381a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803821:	00 00 00 
  803824:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803827:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803829:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803830:	00 00 00 
  803833:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803836:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803839:	bf 03 00 00 00       	mov    $0x3,%edi
  80383e:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  803845:	00 00 00 
  803848:	ff d0                	callq  *%rax
}
  80384a:	c9                   	leaveq 
  80384b:	c3                   	retq   

000000000080384c <nsipc_close>:

int
nsipc_close(int s)
{
  80384c:	55                   	push   %rbp
  80384d:	48 89 e5             	mov    %rsp,%rbp
  803850:	48 83 ec 10          	sub    $0x10,%rsp
  803854:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803857:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80385e:	00 00 00 
  803861:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803864:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803866:	bf 04 00 00 00       	mov    $0x4,%edi
  80386b:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
}
  803877:	c9                   	leaveq 
  803878:	c3                   	retq   

0000000000803879 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803879:	55                   	push   %rbp
  80387a:	48 89 e5             	mov    %rsp,%rbp
  80387d:	48 83 ec 10          	sub    $0x10,%rsp
  803881:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803884:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803888:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80388b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803892:	00 00 00 
  803895:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803898:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80389a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80389d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a1:	48 89 c6             	mov    %rax,%rsi
  8038a4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8038ab:	00 00 00 
  8038ae:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  8038b5:	00 00 00 
  8038b8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8038ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038c1:	00 00 00 
  8038c4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038c7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8038ca:	bf 05 00 00 00       	mov    $0x5,%edi
  8038cf:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
}
  8038db:	c9                   	leaveq 
  8038dc:	c3                   	retq   

00000000008038dd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8038dd:	55                   	push   %rbp
  8038de:	48 89 e5             	mov    %rsp,%rbp
  8038e1:	48 83 ec 10          	sub    $0x10,%rsp
  8038e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038e8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8038eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f2:	00 00 00 
  8038f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038f8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8038fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803901:	00 00 00 
  803904:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803907:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80390a:	bf 06 00 00 00       	mov    $0x6,%edi
  80390f:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  803916:	00 00 00 
  803919:	ff d0                	callq  *%rax
}
  80391b:	c9                   	leaveq 
  80391c:	c3                   	retq   

000000000080391d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80391d:	55                   	push   %rbp
  80391e:	48 89 e5             	mov    %rsp,%rbp
  803921:	48 83 ec 30          	sub    $0x30,%rsp
  803925:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803928:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80392c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80392f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803932:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803939:	00 00 00 
  80393c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80393f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803941:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803948:	00 00 00 
  80394b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80394e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803951:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803958:	00 00 00 
  80395b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80395e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803961:	bf 07 00 00 00       	mov    $0x7,%edi
  803966:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  80396d:	00 00 00 
  803970:	ff d0                	callq  *%rax
  803972:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803975:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803979:	78 69                	js     8039e4 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80397b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803982:	7f 08                	jg     80398c <nsipc_recv+0x6f>
  803984:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803987:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80398a:	7e 35                	jle    8039c1 <nsipc_recv+0xa4>
  80398c:	48 b9 42 4c 80 00 00 	movabs $0x804c42,%rcx
  803993:	00 00 00 
  803996:	48 ba 57 4c 80 00 00 	movabs $0x804c57,%rdx
  80399d:	00 00 00 
  8039a0:	be 61 00 00 00       	mov    $0x61,%esi
  8039a5:	48 bf 6c 4c 80 00 00 	movabs $0x804c6c,%rdi
  8039ac:	00 00 00 
  8039af:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b4:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  8039bb:	00 00 00 
  8039be:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8039c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c4:	48 63 d0             	movslq %eax,%rdx
  8039c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039cb:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8039d2:	00 00 00 
  8039d5:	48 89 c7             	mov    %rax,%rdi
  8039d8:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  8039df:	00 00 00 
  8039e2:	ff d0                	callq  *%rax
	}

	return r;
  8039e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039e7:	c9                   	leaveq 
  8039e8:	c3                   	retq   

00000000008039e9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8039e9:	55                   	push   %rbp
  8039ea:	48 89 e5             	mov    %rsp,%rbp
  8039ed:	48 83 ec 20          	sub    $0x20,%rsp
  8039f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8039fb:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8039fe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a05:	00 00 00 
  803a08:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a0b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803a0d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803a14:	7e 35                	jle    803a4b <nsipc_send+0x62>
  803a16:	48 b9 78 4c 80 00 00 	movabs $0x804c78,%rcx
  803a1d:	00 00 00 
  803a20:	48 ba 57 4c 80 00 00 	movabs $0x804c57,%rdx
  803a27:	00 00 00 
  803a2a:	be 6c 00 00 00       	mov    $0x6c,%esi
  803a2f:	48 bf 6c 4c 80 00 00 	movabs $0x804c6c,%rdi
  803a36:	00 00 00 
  803a39:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3e:	49 b8 a4 02 80 00 00 	movabs $0x8002a4,%r8
  803a45:	00 00 00 
  803a48:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a4e:	48 63 d0             	movslq %eax,%rdx
  803a51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a55:	48 89 c6             	mov    %rax,%rsi
  803a58:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803a5f:	00 00 00 
  803a62:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  803a69:	00 00 00 
  803a6c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803a6e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a75:	00 00 00 
  803a78:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a7b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803a7e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a85:	00 00 00 
  803a88:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a8b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803a8e:	bf 08 00 00 00       	mov    $0x8,%edi
  803a93:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  803a9a:	00 00 00 
  803a9d:	ff d0                	callq  *%rax
}
  803a9f:	c9                   	leaveq 
  803aa0:	c3                   	retq   

0000000000803aa1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803aa1:	55                   	push   %rbp
  803aa2:	48 89 e5             	mov    %rsp,%rbp
  803aa5:	48 83 ec 10          	sub    $0x10,%rsp
  803aa9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803aac:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803aaf:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ab2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ab9:	00 00 00 
  803abc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803abf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ac1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ac8:	00 00 00 
  803acb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ace:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803ad1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ad8:	00 00 00 
  803adb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803ade:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803ae1:	bf 09 00 00 00       	mov    $0x9,%edi
  803ae6:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  803aed:	00 00 00 
  803af0:	ff d0                	callq  *%rax
}
  803af2:	c9                   	leaveq 
  803af3:	c3                   	retq   

0000000000803af4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803af4:	55                   	push   %rbp
  803af5:	48 89 e5             	mov    %rsp,%rbp
  803af8:	53                   	push   %rbx
  803af9:	48 83 ec 38          	sub    $0x38,%rsp
  803afd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803b01:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803b05:	48 89 c7             	mov    %rax,%rdi
  803b08:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  803b0f:	00 00 00 
  803b12:	ff d0                	callq  *%rax
  803b14:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b17:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b1b:	0f 88 bf 01 00 00    	js     803ce0 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b25:	ba 07 04 00 00       	mov    $0x407,%edx
  803b2a:	48 89 c6             	mov    %rax,%rsi
  803b2d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b32:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  803b39:	00 00 00 
  803b3c:	ff d0                	callq  *%rax
  803b3e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b41:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b45:	0f 88 95 01 00 00    	js     803ce0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803b4b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803b4f:	48 89 c7             	mov    %rax,%rdi
  803b52:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  803b59:	00 00 00 
  803b5c:	ff d0                	callq  *%rax
  803b5e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b61:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b65:	0f 88 5d 01 00 00    	js     803cc8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b6f:	ba 07 04 00 00       	mov    $0x407,%edx
  803b74:	48 89 c6             	mov    %rax,%rsi
  803b77:	bf 00 00 00 00       	mov    $0x0,%edi
  803b7c:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  803b83:	00 00 00 
  803b86:	ff d0                	callq  *%rax
  803b88:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b8f:	0f 88 33 01 00 00    	js     803cc8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803b95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b99:	48 89 c7             	mov    %rax,%rdi
  803b9c:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  803ba3:	00 00 00 
  803ba6:	ff d0                	callq  *%rax
  803ba8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bb0:	ba 07 04 00 00       	mov    $0x407,%edx
  803bb5:	48 89 c6             	mov    %rax,%rsi
  803bb8:	bf 00 00 00 00       	mov    $0x0,%edi
  803bbd:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  803bc4:	00 00 00 
  803bc7:	ff d0                	callq  *%rax
  803bc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bcc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bd0:	0f 88 d9 00 00 00    	js     803caf <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bda:	48 89 c7             	mov    %rax,%rdi
  803bdd:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
  803be9:	48 89 c2             	mov    %rax,%rdx
  803bec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bf0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803bf6:	48 89 d1             	mov    %rdx,%rcx
  803bf9:	ba 00 00 00 00       	mov    $0x0,%edx
  803bfe:	48 89 c6             	mov    %rax,%rsi
  803c01:	bf 00 00 00 00       	mov    $0x0,%edi
  803c06:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803c0d:	00 00 00 
  803c10:	ff d0                	callq  *%rax
  803c12:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c15:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c19:	78 79                	js     803c94 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803c1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c26:	00 00 00 
  803c29:	8b 12                	mov    (%rdx),%edx
  803c2b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803c2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803c38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c3c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c43:	00 00 00 
  803c46:	8b 12                	mov    (%rdx),%edx
  803c48:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803c4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c4e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803c55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c59:	48 89 c7             	mov    %rax,%rdi
  803c5c:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  803c63:	00 00 00 
  803c66:	ff d0                	callq  *%rax
  803c68:	89 c2                	mov    %eax,%edx
  803c6a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c6e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803c70:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c74:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803c78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c7c:	48 89 c7             	mov    %rax,%rdi
  803c7f:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  803c86:	00 00 00 
  803c89:	ff d0                	callq  *%rax
  803c8b:	89 03                	mov    %eax,(%rbx)
	return 0;
  803c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c92:	eb 4f                	jmp    803ce3 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803c94:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803c95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c99:	48 89 c6             	mov    %rax,%rsi
  803c9c:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca1:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  803ca8:	00 00 00 
  803cab:	ff d0                	callq  *%rax
  803cad:	eb 01                	jmp    803cb0 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803caf:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803cb0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cb4:	48 89 c6             	mov    %rax,%rsi
  803cb7:	bf 00 00 00 00       	mov    $0x0,%edi
  803cbc:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  803cc3:	00 00 00 
  803cc6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803cc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ccc:	48 89 c6             	mov    %rax,%rsi
  803ccf:	bf 00 00 00 00       	mov    $0x0,%edi
  803cd4:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  803cdb:	00 00 00 
  803cde:	ff d0                	callq  *%rax
err:
	return r;
  803ce0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ce3:	48 83 c4 38          	add    $0x38,%rsp
  803ce7:	5b                   	pop    %rbx
  803ce8:	5d                   	pop    %rbp
  803ce9:	c3                   	retq   

0000000000803cea <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803cea:	55                   	push   %rbp
  803ceb:	48 89 e5             	mov    %rsp,%rbp
  803cee:	53                   	push   %rbx
  803cef:	48 83 ec 28          	sub    $0x28,%rsp
  803cf3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cf7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cfb:	eb 01                	jmp    803cfe <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803cfd:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803cfe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d05:	00 00 00 
  803d08:	48 8b 00             	mov    (%rax),%rax
  803d0b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d11:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803d14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d18:	48 89 c7             	mov    %rax,%rdi
  803d1b:	48 b8 8c 44 80 00 00 	movabs $0x80448c,%rax
  803d22:	00 00 00 
  803d25:	ff d0                	callq  *%rax
  803d27:	89 c3                	mov    %eax,%ebx
  803d29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d2d:	48 89 c7             	mov    %rax,%rdi
  803d30:	48 b8 8c 44 80 00 00 	movabs $0x80448c,%rax
  803d37:	00 00 00 
  803d3a:	ff d0                	callq  *%rax
  803d3c:	39 c3                	cmp    %eax,%ebx
  803d3e:	0f 94 c0             	sete   %al
  803d41:	0f b6 c0             	movzbl %al,%eax
  803d44:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803d47:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d4e:	00 00 00 
  803d51:	48 8b 00             	mov    (%rax),%rax
  803d54:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d5a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803d5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d60:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d63:	75 0a                	jne    803d6f <_pipeisclosed+0x85>
			return ret;
  803d65:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803d68:	48 83 c4 28          	add    $0x28,%rsp
  803d6c:	5b                   	pop    %rbx
  803d6d:	5d                   	pop    %rbp
  803d6e:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803d6f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d72:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d75:	74 86                	je     803cfd <_pipeisclosed+0x13>
  803d77:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803d7b:	75 80                	jne    803cfd <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803d7d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d84:	00 00 00 
  803d87:	48 8b 00             	mov    (%rax),%rax
  803d8a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803d90:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d96:	89 c6                	mov    %eax,%esi
  803d98:	48 bf 89 4c 80 00 00 	movabs $0x804c89,%rdi
  803d9f:	00 00 00 
  803da2:	b8 00 00 00 00       	mov    $0x0,%eax
  803da7:	49 b8 df 04 80 00 00 	movabs $0x8004df,%r8
  803dae:	00 00 00 
  803db1:	41 ff d0             	callq  *%r8
	}
  803db4:	e9 44 ff ff ff       	jmpq   803cfd <_pipeisclosed+0x13>

0000000000803db9 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803db9:	55                   	push   %rbp
  803dba:	48 89 e5             	mov    %rsp,%rbp
  803dbd:	48 83 ec 30          	sub    $0x30,%rsp
  803dc1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dc4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803dc8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803dcb:	48 89 d6             	mov    %rdx,%rsi
  803dce:	89 c7                	mov    %eax,%edi
  803dd0:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  803dd7:	00 00 00 
  803dda:	ff d0                	callq  *%rax
  803ddc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ddf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de3:	79 05                	jns    803dea <pipeisclosed+0x31>
		return r;
  803de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de8:	eb 31                	jmp    803e1b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803dea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dee:	48 89 c7             	mov    %rax,%rdi
  803df1:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  803df8:	00 00 00 
  803dfb:	ff d0                	callq  *%rax
  803dfd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803e01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e09:	48 89 d6             	mov    %rdx,%rsi
  803e0c:	48 89 c7             	mov    %rax,%rdi
  803e0f:	48 b8 ea 3c 80 00 00 	movabs $0x803cea,%rax
  803e16:	00 00 00 
  803e19:	ff d0                	callq  *%rax
}
  803e1b:	c9                   	leaveq 
  803e1c:	c3                   	retq   

0000000000803e1d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e1d:	55                   	push   %rbp
  803e1e:	48 89 e5             	mov    %rsp,%rbp
  803e21:	48 83 ec 40          	sub    $0x40,%rsp
  803e25:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e29:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e2d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e35:	48 89 c7             	mov    %rax,%rdi
  803e38:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  803e3f:	00 00 00 
  803e42:	ff d0                	callq  *%rax
  803e44:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e48:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e50:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e57:	00 
  803e58:	e9 97 00 00 00       	jmpq   803ef4 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e5d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e62:	74 09                	je     803e6d <devpipe_read+0x50>
				return i;
  803e64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e68:	e9 95 00 00 00       	jmpq   803f02 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e75:	48 89 d6             	mov    %rdx,%rsi
  803e78:	48 89 c7             	mov    %rax,%rdi
  803e7b:	48 b8 ea 3c 80 00 00 	movabs $0x803cea,%rax
  803e82:	00 00 00 
  803e85:	ff d0                	callq  *%rax
  803e87:	85 c0                	test   %eax,%eax
  803e89:	74 07                	je     803e92 <devpipe_read+0x75>
				return 0;
  803e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e90:	eb 70                	jmp    803f02 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e92:	48 b8 aa 19 80 00 00 	movabs $0x8019aa,%rax
  803e99:	00 00 00 
  803e9c:	ff d0                	callq  *%rax
  803e9e:	eb 01                	jmp    803ea1 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803ea0:	90                   	nop
  803ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea5:	8b 10                	mov    (%rax),%edx
  803ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eab:	8b 40 04             	mov    0x4(%rax),%eax
  803eae:	39 c2                	cmp    %eax,%edx
  803eb0:	74 ab                	je     803e5d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803eb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803eba:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec2:	8b 00                	mov    (%rax),%eax
  803ec4:	89 c2                	mov    %eax,%edx
  803ec6:	c1 fa 1f             	sar    $0x1f,%edx
  803ec9:	c1 ea 1b             	shr    $0x1b,%edx
  803ecc:	01 d0                	add    %edx,%eax
  803ece:	83 e0 1f             	and    $0x1f,%eax
  803ed1:	29 d0                	sub    %edx,%eax
  803ed3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ed7:	48 98                	cltq   
  803ed9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803ede:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee4:	8b 00                	mov    (%rax),%eax
  803ee6:	8d 50 01             	lea    0x1(%rax),%edx
  803ee9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eed:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803eef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ef4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ef8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803efc:	72 a2                	jb     803ea0 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803efe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f02:	c9                   	leaveq 
  803f03:	c3                   	retq   

0000000000803f04 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f04:	55                   	push   %rbp
  803f05:	48 89 e5             	mov    %rsp,%rbp
  803f08:	48 83 ec 40          	sub    $0x40,%rsp
  803f0c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f10:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f14:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803f18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f1c:	48 89 c7             	mov    %rax,%rdi
  803f1f:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  803f26:	00 00 00 
  803f29:	ff d0                	callq  *%rax
  803f2b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f37:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f3e:	00 
  803f3f:	e9 93 00 00 00       	jmpq   803fd7 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803f44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f4c:	48 89 d6             	mov    %rdx,%rsi
  803f4f:	48 89 c7             	mov    %rax,%rdi
  803f52:	48 b8 ea 3c 80 00 00 	movabs $0x803cea,%rax
  803f59:	00 00 00 
  803f5c:	ff d0                	callq  *%rax
  803f5e:	85 c0                	test   %eax,%eax
  803f60:	74 07                	je     803f69 <devpipe_write+0x65>
				return 0;
  803f62:	b8 00 00 00 00       	mov    $0x0,%eax
  803f67:	eb 7c                	jmp    803fe5 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803f69:	48 b8 aa 19 80 00 00 	movabs $0x8019aa,%rax
  803f70:	00 00 00 
  803f73:	ff d0                	callq  *%rax
  803f75:	eb 01                	jmp    803f78 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803f77:	90                   	nop
  803f78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f7c:	8b 40 04             	mov    0x4(%rax),%eax
  803f7f:	48 63 d0             	movslq %eax,%rdx
  803f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f86:	8b 00                	mov    (%rax),%eax
  803f88:	48 98                	cltq   
  803f8a:	48 83 c0 20          	add    $0x20,%rax
  803f8e:	48 39 c2             	cmp    %rax,%rdx
  803f91:	73 b1                	jae    803f44 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803f93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f97:	8b 40 04             	mov    0x4(%rax),%eax
  803f9a:	89 c2                	mov    %eax,%edx
  803f9c:	c1 fa 1f             	sar    $0x1f,%edx
  803f9f:	c1 ea 1b             	shr    $0x1b,%edx
  803fa2:	01 d0                	add    %edx,%eax
  803fa4:	83 e0 1f             	and    $0x1f,%eax
  803fa7:	29 d0                	sub    %edx,%eax
  803fa9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803fad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803fb1:	48 01 ca             	add    %rcx,%rdx
  803fb4:	0f b6 0a             	movzbl (%rdx),%ecx
  803fb7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fbb:	48 98                	cltq   
  803fbd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc5:	8b 40 04             	mov    0x4(%rax),%eax
  803fc8:	8d 50 01             	lea    0x1(%rax),%edx
  803fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fcf:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803fd2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fdb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803fdf:	72 96                	jb     803f77 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803fe1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803fe5:	c9                   	leaveq 
  803fe6:	c3                   	retq   

0000000000803fe7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803fe7:	55                   	push   %rbp
  803fe8:	48 89 e5             	mov    %rsp,%rbp
  803feb:	48 83 ec 20          	sub    $0x20,%rsp
  803fef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ff3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ffb:	48 89 c7             	mov    %rax,%rdi
  803ffe:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  804005:	00 00 00 
  804008:	ff d0                	callq  *%rax
  80400a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80400e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804012:	48 be 9c 4c 80 00 00 	movabs $0x804c9c,%rsi
  804019:	00 00 00 
  80401c:	48 89 c7             	mov    %rax,%rdi
  80401f:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  804026:	00 00 00 
  804029:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80402b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80402f:	8b 50 04             	mov    0x4(%rax),%edx
  804032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804036:	8b 00                	mov    (%rax),%eax
  804038:	29 c2                	sub    %eax,%edx
  80403a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80403e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804044:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804048:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80404f:	00 00 00 
	stat->st_dev = &devpipe;
  804052:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804056:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80405d:	00 00 00 
  804060:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  804067:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80406c:	c9                   	leaveq 
  80406d:	c3                   	retq   

000000000080406e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80406e:	55                   	push   %rbp
  80406f:	48 89 e5             	mov    %rsp,%rbp
  804072:	48 83 ec 10          	sub    $0x10,%rsp
  804076:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80407a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80407e:	48 89 c6             	mov    %rax,%rsi
  804081:	bf 00 00 00 00       	mov    $0x0,%edi
  804086:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  80408d:	00 00 00 
  804090:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804096:	48 89 c7             	mov    %rax,%rdi
  804099:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  8040a0:	00 00 00 
  8040a3:	ff d0                	callq  *%rax
  8040a5:	48 89 c6             	mov    %rax,%rsi
  8040a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ad:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  8040b4:	00 00 00 
  8040b7:	ff d0                	callq  *%rax
}
  8040b9:	c9                   	leaveq 
  8040ba:	c3                   	retq   
	...

00000000008040bc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8040bc:	55                   	push   %rbp
  8040bd:	48 89 e5             	mov    %rsp,%rbp
  8040c0:	48 83 ec 20          	sub    $0x20,%rsp
  8040c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8040c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040ca:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8040cd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8040d1:	be 01 00 00 00       	mov    $0x1,%esi
  8040d6:	48 89 c7             	mov    %rax,%rdi
  8040d9:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  8040e0:	00 00 00 
  8040e3:	ff d0                	callq  *%rax
}
  8040e5:	c9                   	leaveq 
  8040e6:	c3                   	retq   

00000000008040e7 <getchar>:

int
getchar(void)
{
  8040e7:	55                   	push   %rbp
  8040e8:	48 89 e5             	mov    %rsp,%rbp
  8040eb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8040ef:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8040f3:	ba 01 00 00 00       	mov    $0x1,%edx
  8040f8:	48 89 c6             	mov    %rax,%rsi
  8040fb:	bf 00 00 00 00       	mov    $0x0,%edi
  804100:	48 b8 d8 2b 80 00 00 	movabs $0x802bd8,%rax
  804107:	00 00 00 
  80410a:	ff d0                	callq  *%rax
  80410c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80410f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804113:	79 05                	jns    80411a <getchar+0x33>
		return r;
  804115:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804118:	eb 14                	jmp    80412e <getchar+0x47>
	if (r < 1)
  80411a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80411e:	7f 07                	jg     804127 <getchar+0x40>
		return -E_EOF;
  804120:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804125:	eb 07                	jmp    80412e <getchar+0x47>
	return c;
  804127:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80412b:	0f b6 c0             	movzbl %al,%eax
}
  80412e:	c9                   	leaveq 
  80412f:	c3                   	retq   

0000000000804130 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804130:	55                   	push   %rbp
  804131:	48 89 e5             	mov    %rsp,%rbp
  804134:	48 83 ec 20          	sub    $0x20,%rsp
  804138:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80413b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80413f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804142:	48 89 d6             	mov    %rdx,%rsi
  804145:	89 c7                	mov    %eax,%edi
  804147:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  80414e:	00 00 00 
  804151:	ff d0                	callq  *%rax
  804153:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804156:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80415a:	79 05                	jns    804161 <iscons+0x31>
		return r;
  80415c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415f:	eb 1a                	jmp    80417b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804161:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804165:	8b 10                	mov    (%rax),%edx
  804167:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80416e:	00 00 00 
  804171:	8b 00                	mov    (%rax),%eax
  804173:	39 c2                	cmp    %eax,%edx
  804175:	0f 94 c0             	sete   %al
  804178:	0f b6 c0             	movzbl %al,%eax
}
  80417b:	c9                   	leaveq 
  80417c:	c3                   	retq   

000000000080417d <opencons>:

int
opencons(void)
{
  80417d:	55                   	push   %rbp
  80417e:	48 89 e5             	mov    %rsp,%rbp
  804181:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804185:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804189:	48 89 c7             	mov    %rax,%rdi
  80418c:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  804193:	00 00 00 
  804196:	ff d0                	callq  *%rax
  804198:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80419b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80419f:	79 05                	jns    8041a6 <opencons+0x29>
		return r;
  8041a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041a4:	eb 5b                	jmp    804201 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8041a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8041af:	48 89 c6             	mov    %rax,%rsi
  8041b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8041b7:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  8041be:	00 00 00 
  8041c1:	ff d0                	callq  *%rax
  8041c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ca:	79 05                	jns    8041d1 <opencons+0x54>
		return r;
  8041cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041cf:	eb 30                	jmp    804201 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8041d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d5:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8041dc:	00 00 00 
  8041df:	8b 12                	mov    (%rdx),%edx
  8041e1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8041e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8041ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041f2:	48 89 c7             	mov    %rax,%rdi
  8041f5:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  8041fc:	00 00 00 
  8041ff:	ff d0                	callq  *%rax
}
  804201:	c9                   	leaveq 
  804202:	c3                   	retq   

0000000000804203 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804203:	55                   	push   %rbp
  804204:	48 89 e5             	mov    %rsp,%rbp
  804207:	48 83 ec 30          	sub    $0x30,%rsp
  80420b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80420f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804213:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804217:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80421c:	75 13                	jne    804231 <devcons_read+0x2e>
		return 0;
  80421e:	b8 00 00 00 00       	mov    $0x0,%eax
  804223:	eb 49                	jmp    80426e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804225:	48 b8 aa 19 80 00 00 	movabs $0x8019aa,%rax
  80422c:	00 00 00 
  80422f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804231:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  804238:	00 00 00 
  80423b:	ff d0                	callq  *%rax
  80423d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804240:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804244:	74 df                	je     804225 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804246:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80424a:	79 05                	jns    804251 <devcons_read+0x4e>
		return c;
  80424c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424f:	eb 1d                	jmp    80426e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804251:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804255:	75 07                	jne    80425e <devcons_read+0x5b>
		return 0;
  804257:	b8 00 00 00 00       	mov    $0x0,%eax
  80425c:	eb 10                	jmp    80426e <devcons_read+0x6b>
	*(char*)vbuf = c;
  80425e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804261:	89 c2                	mov    %eax,%edx
  804263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804267:	88 10                	mov    %dl,(%rax)
	return 1;
  804269:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80426e:	c9                   	leaveq 
  80426f:	c3                   	retq   

0000000000804270 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804270:	55                   	push   %rbp
  804271:	48 89 e5             	mov    %rsp,%rbp
  804274:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80427b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804282:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804289:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804290:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804297:	eb 77                	jmp    804310 <devcons_write+0xa0>
		m = n - tot;
  804299:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8042a0:	89 c2                	mov    %eax,%edx
  8042a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a5:	89 d1                	mov    %edx,%ecx
  8042a7:	29 c1                	sub    %eax,%ecx
  8042a9:	89 c8                	mov    %ecx,%eax
  8042ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8042ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042b1:	83 f8 7f             	cmp    $0x7f,%eax
  8042b4:	76 07                	jbe    8042bd <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8042b6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8042bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042c0:	48 63 d0             	movslq %eax,%rdx
  8042c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c6:	48 98                	cltq   
  8042c8:	48 89 c1             	mov    %rax,%rcx
  8042cb:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8042d2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042d9:	48 89 ce             	mov    %rcx,%rsi
  8042dc:	48 89 c7             	mov    %rax,%rdi
  8042df:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  8042e6:	00 00 00 
  8042e9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8042eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042ee:	48 63 d0             	movslq %eax,%rdx
  8042f1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042f8:	48 89 d6             	mov    %rdx,%rsi
  8042fb:	48 89 c7             	mov    %rax,%rdi
  8042fe:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  804305:	00 00 00 
  804308:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80430a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80430d:	01 45 fc             	add    %eax,-0x4(%rbp)
  804310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804313:	48 98                	cltq   
  804315:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80431c:	0f 82 77 ff ff ff    	jb     804299 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804322:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804325:	c9                   	leaveq 
  804326:	c3                   	retq   

0000000000804327 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804327:	55                   	push   %rbp
  804328:	48 89 e5             	mov    %rsp,%rbp
  80432b:	48 83 ec 08          	sub    $0x8,%rsp
  80432f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804333:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804338:	c9                   	leaveq 
  804339:	c3                   	retq   

000000000080433a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80433a:	55                   	push   %rbp
  80433b:	48 89 e5             	mov    %rsp,%rbp
  80433e:	48 83 ec 10          	sub    $0x10,%rsp
  804342:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80434a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80434e:	48 be a8 4c 80 00 00 	movabs $0x804ca8,%rsi
  804355:	00 00 00 
  804358:	48 89 c7             	mov    %rax,%rdi
  80435b:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  804362:	00 00 00 
  804365:	ff d0                	callq  *%rax
	return 0;
  804367:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80436c:	c9                   	leaveq 
  80436d:	c3                   	retq   
	...

0000000000804370 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804370:	55                   	push   %rbp
  804371:	48 89 e5             	mov    %rsp,%rbp
  804374:	48 83 ec 10          	sub    $0x10,%rsp
  804378:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80437c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804383:	00 00 00 
  804386:	48 8b 00             	mov    (%rax),%rax
  804389:	48 85 c0             	test   %rax,%rax
  80438c:	75 66                	jne    8043f4 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  80438e:	ba 07 00 00 00       	mov    $0x7,%edx
  804393:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804398:	bf 00 00 00 00       	mov    $0x0,%edi
  80439d:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  8043a4:	00 00 00 
  8043a7:	ff d0                	callq  *%rax
  8043a9:	85 c0                	test   %eax,%eax
  8043ab:	75 1d                	jne    8043ca <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8043ad:	48 be 08 44 80 00 00 	movabs $0x804408,%rsi
  8043b4:	00 00 00 
  8043b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8043bc:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8043c3:	00 00 00 
  8043c6:	ff d0                	callq  *%rax
  8043c8:	eb 2a                	jmp    8043f4 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  8043ca:	48 ba af 4c 80 00 00 	movabs $0x804caf,%rdx
  8043d1:	00 00 00 
  8043d4:	be 23 00 00 00       	mov    $0x23,%esi
  8043d9:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  8043e0:	00 00 00 
  8043e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e8:	48 b9 a4 02 80 00 00 	movabs $0x8002a4,%rcx
  8043ef:	00 00 00 
  8043f2:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8043f4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043fb:	00 00 00 
  8043fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804402:	48 89 10             	mov    %rdx,(%rax)
}
  804405:	c9                   	leaveq 
  804406:	c3                   	retq   
	...

0000000000804408 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804408:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80440b:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804412:	00 00 00 
call *%rax
  804415:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  804417:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  80441b:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  804420:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  804427:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  804428:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  80442c:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  80442f:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  804436:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  804437:	4c 8b 3c 24          	mov    (%rsp),%r15
  80443b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804440:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804445:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80444a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80444f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804454:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804459:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80445e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804463:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804468:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80446d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804472:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804477:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80447c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804481:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  804485:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  804489:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  80448a:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  80448b:	c3                   	retq   

000000000080448c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80448c:	55                   	push   %rbp
  80448d:	48 89 e5             	mov    %rsp,%rbp
  804490:	48 83 ec 18          	sub    $0x18,%rsp
  804494:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80449c:	48 89 c2             	mov    %rax,%rdx
  80449f:	48 c1 ea 15          	shr    $0x15,%rdx
  8044a3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044aa:	01 00 00 
  8044ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044b1:	83 e0 01             	and    $0x1,%eax
  8044b4:	48 85 c0             	test   %rax,%rax
  8044b7:	75 07                	jne    8044c0 <pageref+0x34>
		return 0;
  8044b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8044be:	eb 53                	jmp    804513 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8044c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044c4:	48 89 c2             	mov    %rax,%rdx
  8044c7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8044cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044d2:	01 00 00 
  8044d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8044dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044e1:	83 e0 01             	and    $0x1,%eax
  8044e4:	48 85 c0             	test   %rax,%rax
  8044e7:	75 07                	jne    8044f0 <pageref+0x64>
		return 0;
  8044e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ee:	eb 23                	jmp    804513 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8044f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f4:	48 89 c2             	mov    %rax,%rdx
  8044f7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8044fb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804502:	00 00 00 
  804505:	48 c1 e2 04          	shl    $0x4,%rdx
  804509:	48 01 d0             	add    %rdx,%rax
  80450c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804510:	0f b7 c0             	movzwl %ax,%eax
}
  804513:	c9                   	leaveq 
  804514:	c3                   	retq   
