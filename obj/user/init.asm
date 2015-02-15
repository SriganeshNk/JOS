
obj/user/init.debug:     file format elf64-x86-64


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
  80003c:	e8 5f 06 00 00       	callq  8006a0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800050:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int i, tot = 0;
  800053:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (i = 0; i < n; i++)
  80005a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800061:	eb 1a                	jmp    80007d <sum+0x39>
		tot ^= i * s[i];
  800063:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800066:	48 98                	cltq   
  800068:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80006c:	0f b6 00             	movzbl (%rax),%eax
  80006f:	0f be c0             	movsbl %al,%eax
  800072:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  800076:	31 45 f8             	xor    %eax,-0x8(%rbp)

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800079:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80007d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800080:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  800083:	7c de                	jl     800063 <sum+0x1f>
		tot ^= i * s[i];
	return tot;
  800085:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800088:	c9                   	leaveq 
  800089:	c3                   	retq   

000000000080008a <umain>:

void
umain(int argc, char **argv)
{
  80008a:	55                   	push   %rbp
  80008b:	48 89 e5             	mov    %rsp,%rbp
  80008e:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800095:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80009b:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  8000a2:	48 bf 60 4b 80 00 00 	movabs $0x804b60,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  8000b8:	00 00 00 
  8000bb:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000bd:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c4:	be 70 17 00 00       	mov    $0x1770,%esi
  8000c9:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8000d0:	00 00 00 
  8000d3:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8000da:	00 00 00 
  8000dd:	ff d0                	callq  *%rax
  8000df:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000e5:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000e8:	74 25                	je     80010f <umain+0x85>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8000ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000f0:	89 c6                	mov    %eax,%esi
  8000f2:	48 bf 70 4b 80 00 00 	movabs $0x804b70,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 b9 a7 09 80 00 00 	movabs $0x8009a7,%rcx
  800108:	00 00 00 
  80010b:	ff d1                	callq  *%rcx
  80010d:	eb 1b                	jmp    80012a <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  80010f:	48 bf a9 4b 80 00 00 	movabs $0x804ba9,%rdi
  800116:	00 00 00 
  800119:	b8 00 00 00 00       	mov    $0x0,%eax
  80011e:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  800125:	00 00 00 
  800128:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012a:	be 70 17 00 00       	mov    $0x1770,%esi
  80012f:	48 bf 20 90 80 00 00 	movabs $0x809020,%rdi
  800136:	00 00 00 
  800139:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800140:	00 00 00 
  800143:	ff d0                	callq  *%rax
  800145:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800148:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80014c:	74 22                	je     800170 <umain+0xe6>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  80014e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800151:	89 c6                	mov    %eax,%esi
  800153:	48 bf c0 4b 80 00 00 	movabs $0x804bc0,%rdi
  80015a:	00 00 00 
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  800169:	00 00 00 
  80016c:	ff d2                	callq  *%rdx
  80016e:	eb 1b                	jmp    80018b <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800170:	48 bf ef 4b 80 00 00 	movabs $0x804bef,%rdi
  800177:	00 00 00 
  80017a:	b8 00 00 00 00       	mov    $0x0,%eax
  80017f:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  800186:	00 00 00 
  800189:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800192:	48 be 05 4c 80 00 00 	movabs $0x804c05,%rsi
  800199:	00 00 00 
  80019c:	48 89 c7             	mov    %rax,%rdi
  80019f:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b2:	eb 70                	jmp    800224 <umain+0x19a>
		strcat(args, " '");
  8001b4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001bb:	48 be 11 4c 80 00 00 	movabs $0x804c11,%rsi
  8001c2:	00 00 00 
  8001c5:	48 89 c7             	mov    %rax,%rdi
  8001c8:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	callq  *%rax
		strcat(args, argv[i]);
  8001d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d7:	48 98                	cltq   
  8001d9:	48 c1 e0 03          	shl    $0x3,%rax
  8001dd:	48 03 85 e0 fe ff ff 	add    -0x120(%rbp),%rax
  8001e4:	48 8b 10             	mov    (%rax),%rdx
  8001e7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001ee:	48 89 d6             	mov    %rdx,%rsi
  8001f1:	48 89 c7             	mov    %rax,%rdi
  8001f4:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
		strcat(args, "'");
  800200:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800207:	48 be 14 4c 80 00 00 	movabs $0x804c14,%rsi
  80020e:	00 00 00 
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  800220:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800227:	3b 85 ec fe ff ff    	cmp    -0x114(%rbp),%eax
  80022d:	7c 85                	jl     8001b4 <umain+0x12a>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80022f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800236:	48 89 c6             	mov    %rax,%rsi
  800239:	48 bf 16 4c 80 00 00 	movabs $0x804c16,%rdi
  800240:	00 00 00 
  800243:	b8 00 00 00 00       	mov    $0x0,%eax
  800248:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  80024f:	00 00 00 
  800252:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800254:	48 bf 1a 4c 80 00 00 	movabs $0x804c1a,%rdi
  80025b:	00 00 00 
  80025e:	b8 00 00 00 00       	mov    $0x0,%eax
  800263:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  80026a:	00 00 00 
  80026d:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80026f:	bf 00 00 00 00       	mov    $0x0,%edi
  800274:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800280:	48 b8 ad 04 80 00 00 	movabs $0x8004ad,%rax
  800287:	00 00 00 
  80028a:	ff d0                	callq  *%rax
  80028c:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80028f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800293:	79 30                	jns    8002c5 <umain+0x23b>
		panic("opencons: %e", r);
  800295:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	48 ba 2c 4c 80 00 00 	movabs $0x804c2c,%rdx
  8002a1:	00 00 00 
  8002a4:	be 37 00 00 00       	mov    $0x37,%esi
  8002a9:	48 bf 39 4c 80 00 00 	movabs $0x804c39,%rdi
  8002b0:	00 00 00 
  8002b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b8:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  8002bf:	00 00 00 
  8002c2:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002c9:	74 30                	je     8002fb <umain+0x271>
		panic("first opencons used fd %d", r);
  8002cb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	48 ba 45 4c 80 00 00 	movabs $0x804c45,%rdx
  8002d7:	00 00 00 
  8002da:	be 39 00 00 00       	mov    $0x39,%esi
  8002df:	48 bf 39 4c 80 00 00 	movabs $0x804c39,%rdi
  8002e6:	00 00 00 
  8002e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ee:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  8002f5:	00 00 00 
  8002f8:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8002fb:	be 01 00 00 00       	mov    $0x1,%esi
  800300:	bf 00 00 00 00       	mov    $0x0,%edi
  800305:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  80030c:	00 00 00 
  80030f:	ff d0                	callq  *%rax
  800311:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800314:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800318:	79 30                	jns    80034a <umain+0x2c0>
		panic("dup: %e", r);
  80031a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80031d:	89 c1                	mov    %eax,%ecx
  80031f:	48 ba 5f 4c 80 00 00 	movabs $0x804c5f,%rdx
  800326:	00 00 00 
  800329:	be 3b 00 00 00       	mov    $0x3b,%esi
  80032e:	48 bf 39 4c 80 00 00 	movabs $0x804c39,%rdi
  800335:	00 00 00 
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  800344:	00 00 00 
  800347:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  80034a:	48 bf 67 4c 80 00 00 	movabs $0x804c67,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  800360:	00 00 00 
  800363:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800365:	ba 00 00 00 00       	mov    $0x0,%edx
  80036a:	48 be 7a 4c 80 00 00 	movabs $0x804c7a,%rsi
  800371:	00 00 00 
  800374:	48 bf 7d 4c 80 00 00 	movabs $0x804c7d,%rdi
  80037b:	00 00 00 
  80037e:	b8 00 00 00 00       	mov    $0x0,%eax
  800383:	48 b9 9b 31 80 00 00 	movabs $0x80319b,%rcx
  80038a:	00 00 00 
  80038d:	ff d1                	callq  *%rcx
  80038f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  800392:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800396:	79 23                	jns    8003bb <umain+0x331>
			cprintf("init: spawn sh: %e\n", r);
  800398:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80039b:	89 c6                	mov    %eax,%esi
  80039d:	48 bf 85 4c 80 00 00 	movabs $0x804c85,%rdi
  8003a4:	00 00 00 
  8003a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ac:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  8003b3:	00 00 00 
  8003b6:	ff d2                	callq  *%rdx
			continue;
  8003b8:	90                   	nop
		cprintf("init waiting\n");
		wait(r);
#ifdef VMM_GUEST
		break;
#endif
	}
  8003b9:	eb 8f                	jmp    80034a <umain+0x2c0>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		cprintf("init waiting\n");
  8003bb:	48 bf 99 4c 80 00 00 	movabs $0x804c99,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
		wait(r);
  8003d6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003d9:	89 c7                	mov    %eax,%edi
  8003db:	48 b8 04 48 80 00 00 	movabs $0x804804,%rax
  8003e2:	00 00 00 
  8003e5:	ff d0                	callq  *%rax
#ifdef VMM_GUEST
		break;
#endif
	}
  8003e7:	e9 5e ff ff ff       	jmpq   80034a <umain+0x2c0>

00000000008003ec <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003ec:	55                   	push   %rbp
  8003ed:	48 89 e5             	mov    %rsp,%rbp
  8003f0:	48 83 ec 20          	sub    $0x20,%rsp
  8003f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8003f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003fa:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8003fd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800401:	be 01 00 00 00       	mov    $0x1,%esi
  800406:	48 89 c7             	mov    %rax,%rdi
  800409:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  800410:	00 00 00 
  800413:	ff d0                	callq  *%rax
}
  800415:	c9                   	leaveq 
  800416:	c3                   	retq   

0000000000800417 <getchar>:

int
getchar(void)
{
  800417:	55                   	push   %rbp
  800418:	48 89 e5             	mov    %rsp,%rbp
  80041b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80041f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800423:	ba 01 00 00 00       	mov    $0x1,%edx
  800428:	48 89 c6             	mov    %rax,%rsi
  80042b:	bf 00 00 00 00       	mov    $0x0,%edi
  800430:	48 b8 18 27 80 00 00 	movabs $0x802718,%rax
  800437:	00 00 00 
  80043a:	ff d0                	callq  *%rax
  80043c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80043f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800443:	79 05                	jns    80044a <getchar+0x33>
		return r;
  800445:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800448:	eb 14                	jmp    80045e <getchar+0x47>
	if (r < 1)
  80044a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044e:	7f 07                	jg     800457 <getchar+0x40>
		return -E_EOF;
  800450:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800455:	eb 07                	jmp    80045e <getchar+0x47>
	return c;
  800457:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80045b:	0f b6 c0             	movzbl %al,%eax
}
  80045e:	c9                   	leaveq 
  80045f:	c3                   	retq   

0000000000800460 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800460:	55                   	push   %rbp
  800461:	48 89 e5             	mov    %rsp,%rbp
  800464:	48 83 ec 20          	sub    $0x20,%rsp
  800468:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80046b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80046f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800472:	48 89 d6             	mov    %rdx,%rsi
  800475:	89 c7                	mov    %eax,%edi
  800477:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  80047e:	00 00 00 
  800481:	ff d0                	callq  *%rax
  800483:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800486:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80048a:	79 05                	jns    800491 <iscons+0x31>
		return r;
  80048c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80048f:	eb 1a                	jmp    8004ab <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800495:	8b 10                	mov    (%rax),%edx
  800497:	48 b8 80 87 80 00 00 	movabs $0x808780,%rax
  80049e:	00 00 00 
  8004a1:	8b 00                	mov    (%rax),%eax
  8004a3:	39 c2                	cmp    %eax,%edx
  8004a5:	0f 94 c0             	sete   %al
  8004a8:	0f b6 c0             	movzbl %al,%eax
}
  8004ab:	c9                   	leaveq 
  8004ac:	c3                   	retq   

00000000008004ad <opencons>:

int
opencons(void)
{
  8004ad:	55                   	push   %rbp
  8004ae:	48 89 e5             	mov    %rsp,%rbp
  8004b1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004b5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004b9:	48 89 c7             	mov    %rax,%rdi
  8004bc:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  8004c3:	00 00 00 
  8004c6:	ff d0                	callq  *%rax
  8004c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004cf:	79 05                	jns    8004d6 <opencons+0x29>
		return r;
  8004d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d4:	eb 5b                	jmp    800531 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004da:	ba 07 04 00 00       	mov    $0x407,%edx
  8004df:	48 89 c6             	mov    %rax,%rsi
  8004e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8004e7:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  8004ee:	00 00 00 
  8004f1:	ff d0                	callq  *%rax
  8004f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004fa:	79 05                	jns    800501 <opencons+0x54>
		return r;
  8004fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ff:	eb 30                	jmp    800531 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800501:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800505:	48 ba 80 87 80 00 00 	movabs $0x808780,%rdx
  80050c:	00 00 00 
  80050f:	8b 12                	mov    (%rdx),%edx
  800511:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800517:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80051e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800522:	48 89 c7             	mov    %rax,%rdi
  800525:	48 b8 00 22 80 00 00 	movabs $0x802200,%rax
  80052c:	00 00 00 
  80052f:	ff d0                	callq  *%rax
}
  800531:	c9                   	leaveq 
  800532:	c3                   	retq   

0000000000800533 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800533:	55                   	push   %rbp
  800534:	48 89 e5             	mov    %rsp,%rbp
  800537:	48 83 ec 30          	sub    $0x30,%rsp
  80053b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80053f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800543:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800547:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80054c:	75 13                	jne    800561 <devcons_read+0x2e>
		return 0;
  80054e:	b8 00 00 00 00       	mov    $0x0,%eax
  800553:	eb 49                	jmp    80059e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800555:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  80055c:	00 00 00 
  80055f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800561:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  800568:	00 00 00 
  80056b:	ff d0                	callq  *%rax
  80056d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800570:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800574:	74 df                	je     800555 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  800576:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80057a:	79 05                	jns    800581 <devcons_read+0x4e>
		return c;
  80057c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80057f:	eb 1d                	jmp    80059e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  800581:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800585:	75 07                	jne    80058e <devcons_read+0x5b>
		return 0;
  800587:	b8 00 00 00 00       	mov    $0x0,%eax
  80058c:	eb 10                	jmp    80059e <devcons_read+0x6b>
	*(char*)vbuf = c;
  80058e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800591:	89 c2                	mov    %eax,%edx
  800593:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800597:	88 10                	mov    %dl,(%rax)
	return 1;
  800599:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80059e:	c9                   	leaveq 
  80059f:	c3                   	retq   

00000000008005a0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8005a0:	55                   	push   %rbp
  8005a1:	48 89 e5             	mov    %rsp,%rbp
  8005a4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005ab:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005b2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005b9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005c7:	eb 77                	jmp    800640 <devcons_write+0xa0>
		m = n - tot;
  8005c9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005d0:	89 c2                	mov    %eax,%edx
  8005d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005d5:	89 d1                	mov    %edx,%ecx
  8005d7:	29 c1                	sub    %eax,%ecx
  8005d9:	89 c8                	mov    %ecx,%eax
  8005db:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005e1:	83 f8 7f             	cmp    $0x7f,%eax
  8005e4:	76 07                	jbe    8005ed <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8005e6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005f0:	48 63 d0             	movslq %eax,%rdx
  8005f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005f6:	48 98                	cltq   
  8005f8:	48 89 c1             	mov    %rax,%rcx
  8005fb:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  800602:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800609:	48 89 ce             	mov    %rcx,%rsi
  80060c:	48 89 c7             	mov    %rax,%rdi
  80060f:	48 b8 9a 18 80 00 00 	movabs $0x80189a,%rax
  800616:	00 00 00 
  800619:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80061b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80061e:	48 63 d0             	movslq %eax,%rdx
  800621:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800628:	48 89 d6             	mov    %rdx,%rsi
  80062b:	48 89 c7             	mov    %rax,%rdi
  80062e:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  800635:	00 00 00 
  800638:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80063a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80063d:	01 45 fc             	add    %eax,-0x4(%rbp)
  800640:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800643:	48 98                	cltq   
  800645:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80064c:	0f 82 77 ff ff ff    	jb     8005c9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800652:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800655:	c9                   	leaveq 
  800656:	c3                   	retq   

0000000000800657 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800657:	55                   	push   %rbp
  800658:	48 89 e5             	mov    %rsp,%rbp
  80065b:	48 83 ec 08          	sub    $0x8,%rsp
  80065f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800663:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800668:	c9                   	leaveq 
  800669:	c3                   	retq   

000000000080066a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80066a:	55                   	push   %rbp
  80066b:	48 89 e5             	mov    %rsp,%rbp
  80066e:	48 83 ec 10          	sub    $0x10,%rsp
  800672:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800676:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80067a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067e:	48 be ac 4c 80 00 00 	movabs $0x804cac,%rsi
  800685:	00 00 00 
  800688:	48 89 c7             	mov    %rax,%rdi
  80068b:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  800692:	00 00 00 
  800695:	ff d0                	callq  *%rax
	return 0;
  800697:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80069c:	c9                   	leaveq 
  80069d:	c3                   	retq   
	...

00000000008006a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 83 ec 10          	sub    $0x10,%rsp
  8006a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8006af:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8006b6:	00 00 00 
  8006b9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  8006c0:	48 b8 34 1e 80 00 00 	movabs $0x801e34,%rax
  8006c7:	00 00 00 
  8006ca:	ff d0                	callq  *%rax
  8006cc:	48 98                	cltq   
  8006ce:	48 89 c2             	mov    %rax,%rdx
  8006d1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8006d7:	48 89 d0             	mov    %rdx,%rax
  8006da:	48 c1 e0 02          	shl    $0x2,%rax
  8006de:	48 01 d0             	add    %rdx,%rax
  8006e1:	48 01 c0             	add    %rax,%rax
  8006e4:	48 01 d0             	add    %rdx,%rax
  8006e7:	48 c1 e0 05          	shl    $0x5,%rax
  8006eb:	48 89 c2             	mov    %rax,%rdx
  8006ee:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8006f5:	00 00 00 
  8006f8:	48 01 c2             	add    %rax,%rdx
  8006fb:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  800702:	00 00 00 
  800705:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800708:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070c:	7e 14                	jle    800722 <libmain+0x82>
		binaryname = argv[0];
  80070e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800712:	48 8b 10             	mov    (%rax),%rdx
  800715:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  80071c:	00 00 00 
  80071f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800722:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800726:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800729:	48 89 d6             	mov    %rdx,%rsi
  80072c:	89 c7                	mov    %eax,%edi
  80072e:	48 b8 8a 00 80 00 00 	movabs $0x80008a,%rax
  800735:	00 00 00 
  800738:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80073a:	48 b8 48 07 80 00 00 	movabs $0x800748,%rax
  800741:	00 00 00 
  800744:	ff d0                	callq  *%rax
}
  800746:	c9                   	leaveq 
  800747:	c3                   	retq   

0000000000800748 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800748:	55                   	push   %rbp
  800749:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80074c:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  800753:	00 00 00 
  800756:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800758:	bf 00 00 00 00       	mov    $0x0,%edi
  80075d:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  800764:	00 00 00 
  800767:	ff d0                	callq  *%rax
}
  800769:	5d                   	pop    %rbp
  80076a:	c3                   	retq   
	...

000000000080076c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80076c:	55                   	push   %rbp
  80076d:	48 89 e5             	mov    %rsp,%rbp
  800770:	53                   	push   %rbx
  800771:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800778:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80077f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800785:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80078c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800793:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80079a:	84 c0                	test   %al,%al
  80079c:	74 23                	je     8007c1 <_panic+0x55>
  80079e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8007a5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8007a9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8007ad:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8007b1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8007b5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8007b9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8007bd:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8007c1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007c8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007cf:	00 00 00 
  8007d2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007d9:	00 00 00 
  8007dc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007e0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007e7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007ee:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007f5:	48 b8 b8 87 80 00 00 	movabs $0x8087b8,%rax
  8007fc:	00 00 00 
  8007ff:	48 8b 18             	mov    (%rax),%rbx
  800802:	48 b8 34 1e 80 00 00 	movabs $0x801e34,%rax
  800809:	00 00 00 
  80080c:	ff d0                	callq  *%rax
  80080e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800814:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80081b:	41 89 c8             	mov    %ecx,%r8d
  80081e:	48 89 d1             	mov    %rdx,%rcx
  800821:	48 89 da             	mov    %rbx,%rdx
  800824:	89 c6                	mov    %eax,%esi
  800826:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  80082d:	00 00 00 
  800830:	b8 00 00 00 00       	mov    $0x0,%eax
  800835:	49 b9 a7 09 80 00 00 	movabs $0x8009a7,%r9
  80083c:	00 00 00 
  80083f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800842:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800849:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800850:	48 89 d6             	mov    %rdx,%rsi
  800853:	48 89 c7             	mov    %rax,%rdi
  800856:	48 b8 fb 08 80 00 00 	movabs $0x8008fb,%rax
  80085d:	00 00 00 
  800860:	ff d0                	callq  *%rax
	cprintf("\n");
  800862:	48 bf e3 4c 80 00 00 	movabs $0x804ce3,%rdi
  800869:	00 00 00 
  80086c:	b8 00 00 00 00       	mov    $0x0,%eax
  800871:	48 ba a7 09 80 00 00 	movabs $0x8009a7,%rdx
  800878:	00 00 00 
  80087b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80087d:	cc                   	int3   
  80087e:	eb fd                	jmp    80087d <_panic+0x111>

0000000000800880 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800880:	55                   	push   %rbp
  800881:	48 89 e5             	mov    %rsp,%rbp
  800884:	48 83 ec 10          	sub    $0x10,%rsp
  800888:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80088b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80088f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800893:	8b 00                	mov    (%rax),%eax
  800895:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800898:	89 d6                	mov    %edx,%esi
  80089a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80089e:	48 63 d0             	movslq %eax,%rdx
  8008a1:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8008a6:	8d 50 01             	lea    0x1(%rax),%edx
  8008a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ad:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  8008af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b3:	8b 00                	mov    (%rax),%eax
  8008b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ba:	75 2c                	jne    8008e8 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  8008bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008c0:	8b 00                	mov    (%rax),%eax
  8008c2:	48 98                	cltq   
  8008c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008c8:	48 83 c2 08          	add    $0x8,%rdx
  8008cc:	48 89 c6             	mov    %rax,%rsi
  8008cf:	48 89 d7             	mov    %rdx,%rdi
  8008d2:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8008d9:	00 00 00 
  8008dc:	ff d0                	callq  *%rax
        b->idx = 0;
  8008de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008e2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8008e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ec:	8b 40 04             	mov    0x4(%rax),%eax
  8008ef:	8d 50 01             	lea    0x1(%rax),%edx
  8008f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008f6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008f9:	c9                   	leaveq 
  8008fa:	c3                   	retq   

00000000008008fb <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8008fb:	55                   	push   %rbp
  8008fc:	48 89 e5             	mov    %rsp,%rbp
  8008ff:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800906:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80090d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800914:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80091b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800922:	48 8b 0a             	mov    (%rdx),%rcx
  800925:	48 89 08             	mov    %rcx,(%rax)
  800928:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80092c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800930:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800934:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800938:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80093f:	00 00 00 
    b.cnt = 0;
  800942:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800949:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80094c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800953:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80095a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800961:	48 89 c6             	mov    %rax,%rsi
  800964:	48 bf 80 08 80 00 00 	movabs $0x800880,%rdi
  80096b:	00 00 00 
  80096e:	48 b8 58 0d 80 00 00 	movabs $0x800d58,%rax
  800975:	00 00 00 
  800978:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80097a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800980:	48 98                	cltq   
  800982:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800989:	48 83 c2 08          	add    $0x8,%rdx
  80098d:	48 89 c6             	mov    %rax,%rsi
  800990:	48 89 d7             	mov    %rdx,%rdi
  800993:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  80099a:	00 00 00 
  80099d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80099f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8009a5:	c9                   	leaveq 
  8009a6:	c3                   	retq   

00000000008009a7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8009a7:	55                   	push   %rbp
  8009a8:	48 89 e5             	mov    %rsp,%rbp
  8009ab:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8009b2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8009b9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8009c0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8009c7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009ce:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009d5:	84 c0                	test   %al,%al
  8009d7:	74 20                	je     8009f9 <cprintf+0x52>
  8009d9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009dd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009e1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009e5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009e9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009ed:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009f1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009f5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009f9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800a00:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800a07:	00 00 00 
  800a0a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800a11:	00 00 00 
  800a14:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800a18:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800a1f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800a26:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800a2d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a34:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a3b:	48 8b 0a             	mov    (%rdx),%rcx
  800a3e:	48 89 08             	mov    %rcx,(%rax)
  800a41:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a45:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a49:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a4d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800a51:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a58:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a5f:	48 89 d6             	mov    %rdx,%rsi
  800a62:	48 89 c7             	mov    %rax,%rdi
  800a65:	48 b8 fb 08 80 00 00 	movabs $0x8008fb,%rax
  800a6c:	00 00 00 
  800a6f:	ff d0                	callq  *%rax
  800a71:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800a77:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a7d:	c9                   	leaveq 
  800a7e:	c3                   	retq   
	...

0000000000800a80 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a80:	55                   	push   %rbp
  800a81:	48 89 e5             	mov    %rsp,%rbp
  800a84:	48 83 ec 30          	sub    $0x30,%rsp
  800a88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800a90:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800a94:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800a97:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800a9b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a9f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800aa2:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800aa6:	77 52                	ja     800afa <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800aa8:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800aab:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800aaf:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800ab2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aba:	ba 00 00 00 00       	mov    $0x0,%edx
  800abf:	48 f7 75 d0          	divq   -0x30(%rbp)
  800ac3:	48 89 c2             	mov    %rax,%rdx
  800ac6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ac9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800acc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ad4:	41 89 f9             	mov    %edi,%r9d
  800ad7:	48 89 c7             	mov    %rax,%rdi
  800ada:	48 b8 80 0a 80 00 00 	movabs $0x800a80,%rax
  800ae1:	00 00 00 
  800ae4:	ff d0                	callq  *%rax
  800ae6:	eb 1c                	jmp    800b04 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ae8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800aef:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800af3:	48 89 d6             	mov    %rdx,%rsi
  800af6:	89 c7                	mov    %eax,%edi
  800af8:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800afa:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800afe:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800b02:	7f e4                	jg     800ae8 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b04:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b10:	48 f7 f1             	div    %rcx
  800b13:	48 89 d0             	mov    %rdx,%rax
  800b16:	48 ba f0 4e 80 00 00 	movabs $0x804ef0,%rdx
  800b1d:	00 00 00 
  800b20:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800b24:	0f be c0             	movsbl %al,%eax
  800b27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b2b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800b2f:	48 89 d6             	mov    %rdx,%rsi
  800b32:	89 c7                	mov    %eax,%edi
  800b34:	ff d1                	callq  *%rcx
}
  800b36:	c9                   	leaveq 
  800b37:	c3                   	retq   

0000000000800b38 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b38:	55                   	push   %rbp
  800b39:	48 89 e5             	mov    %rsp,%rbp
  800b3c:	48 83 ec 20          	sub    $0x20,%rsp
  800b40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b44:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b47:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b4b:	7e 52                	jle    800b9f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b51:	8b 00                	mov    (%rax),%eax
  800b53:	83 f8 30             	cmp    $0x30,%eax
  800b56:	73 24                	jae    800b7c <getuint+0x44>
  800b58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b64:	8b 00                	mov    (%rax),%eax
  800b66:	89 c0                	mov    %eax,%eax
  800b68:	48 01 d0             	add    %rdx,%rax
  800b6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b6f:	8b 12                	mov    (%rdx),%edx
  800b71:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b78:	89 0a                	mov    %ecx,(%rdx)
  800b7a:	eb 17                	jmp    800b93 <getuint+0x5b>
  800b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b80:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b84:	48 89 d0             	mov    %rdx,%rax
  800b87:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b8f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b93:	48 8b 00             	mov    (%rax),%rax
  800b96:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b9a:	e9 a3 00 00 00       	jmpq   800c42 <getuint+0x10a>
	else if (lflag)
  800b9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ba3:	74 4f                	je     800bf4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba9:	8b 00                	mov    (%rax),%eax
  800bab:	83 f8 30             	cmp    $0x30,%eax
  800bae:	73 24                	jae    800bd4 <getuint+0x9c>
  800bb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbc:	8b 00                	mov    (%rax),%eax
  800bbe:	89 c0                	mov    %eax,%eax
  800bc0:	48 01 d0             	add    %rdx,%rax
  800bc3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc7:	8b 12                	mov    (%rdx),%edx
  800bc9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bcc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bd0:	89 0a                	mov    %ecx,(%rdx)
  800bd2:	eb 17                	jmp    800beb <getuint+0xb3>
  800bd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bdc:	48 89 d0             	mov    %rdx,%rax
  800bdf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800be3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800be7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800beb:	48 8b 00             	mov    (%rax),%rax
  800bee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bf2:	eb 4e                	jmp    800c42 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800bf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf8:	8b 00                	mov    (%rax),%eax
  800bfa:	83 f8 30             	cmp    $0x30,%eax
  800bfd:	73 24                	jae    800c23 <getuint+0xeb>
  800bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c03:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0b:	8b 00                	mov    (%rax),%eax
  800c0d:	89 c0                	mov    %eax,%eax
  800c0f:	48 01 d0             	add    %rdx,%rax
  800c12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c16:	8b 12                	mov    (%rdx),%edx
  800c18:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c1f:	89 0a                	mov    %ecx,(%rdx)
  800c21:	eb 17                	jmp    800c3a <getuint+0x102>
  800c23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c27:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c2b:	48 89 d0             	mov    %rdx,%rax
  800c2e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c36:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c3a:	8b 00                	mov    (%rax),%eax
  800c3c:	89 c0                	mov    %eax,%eax
  800c3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c46:	c9                   	leaveq 
  800c47:	c3                   	retq   

0000000000800c48 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c48:	55                   	push   %rbp
  800c49:	48 89 e5             	mov    %rsp,%rbp
  800c4c:	48 83 ec 20          	sub    $0x20,%rsp
  800c50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c54:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c57:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c5b:	7e 52                	jle    800caf <getint+0x67>
		x=va_arg(*ap, long long);
  800c5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c61:	8b 00                	mov    (%rax),%eax
  800c63:	83 f8 30             	cmp    $0x30,%eax
  800c66:	73 24                	jae    800c8c <getint+0x44>
  800c68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c74:	8b 00                	mov    (%rax),%eax
  800c76:	89 c0                	mov    %eax,%eax
  800c78:	48 01 d0             	add    %rdx,%rax
  800c7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c7f:	8b 12                	mov    (%rdx),%edx
  800c81:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c88:	89 0a                	mov    %ecx,(%rdx)
  800c8a:	eb 17                	jmp    800ca3 <getint+0x5b>
  800c8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c90:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c94:	48 89 d0             	mov    %rdx,%rax
  800c97:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c9f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ca3:	48 8b 00             	mov    (%rax),%rax
  800ca6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800caa:	e9 a3 00 00 00       	jmpq   800d52 <getint+0x10a>
	else if (lflag)
  800caf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800cb3:	74 4f                	je     800d04 <getint+0xbc>
		x=va_arg(*ap, long);
  800cb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb9:	8b 00                	mov    (%rax),%eax
  800cbb:	83 f8 30             	cmp    $0x30,%eax
  800cbe:	73 24                	jae    800ce4 <getint+0x9c>
  800cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccc:	8b 00                	mov    (%rax),%eax
  800cce:	89 c0                	mov    %eax,%eax
  800cd0:	48 01 d0             	add    %rdx,%rax
  800cd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd7:	8b 12                	mov    (%rdx),%edx
  800cd9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cdc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce0:	89 0a                	mov    %ecx,(%rdx)
  800ce2:	eb 17                	jmp    800cfb <getint+0xb3>
  800ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cec:	48 89 d0             	mov    %rdx,%rax
  800cef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800cf3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cfb:	48 8b 00             	mov    (%rax),%rax
  800cfe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d02:	eb 4e                	jmp    800d52 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800d04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d08:	8b 00                	mov    (%rax),%eax
  800d0a:	83 f8 30             	cmp    $0x30,%eax
  800d0d:	73 24                	jae    800d33 <getint+0xeb>
  800d0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d13:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1b:	8b 00                	mov    (%rax),%eax
  800d1d:	89 c0                	mov    %eax,%eax
  800d1f:	48 01 d0             	add    %rdx,%rax
  800d22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d26:	8b 12                	mov    (%rdx),%edx
  800d28:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d2f:	89 0a                	mov    %ecx,(%rdx)
  800d31:	eb 17                	jmp    800d4a <getint+0x102>
  800d33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d37:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d3b:	48 89 d0             	mov    %rdx,%rax
  800d3e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d42:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d46:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d4a:	8b 00                	mov    (%rax),%eax
  800d4c:	48 98                	cltq   
  800d4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d56:	c9                   	leaveq 
  800d57:	c3                   	retq   

0000000000800d58 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d58:	55                   	push   %rbp
  800d59:	48 89 e5             	mov    %rsp,%rbp
  800d5c:	41 54                	push   %r12
  800d5e:	53                   	push   %rbx
  800d5f:	48 83 ec 60          	sub    $0x60,%rsp
  800d63:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d67:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d6b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d6f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d77:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d7b:	48 8b 0a             	mov    (%rdx),%rcx
  800d7e:	48 89 08             	mov    %rcx,(%rax)
  800d81:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d85:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d89:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d8d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d91:	eb 17                	jmp    800daa <vprintfmt+0x52>
			if (ch == '\0')
  800d93:	85 db                	test   %ebx,%ebx
  800d95:	0f 84 ea 04 00 00    	je     801285 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800d9b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d9f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800da3:	48 89 c6             	mov    %rax,%rsi
  800da6:	89 df                	mov    %ebx,%edi
  800da8:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800daa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dae:	0f b6 00             	movzbl (%rax),%eax
  800db1:	0f b6 d8             	movzbl %al,%ebx
  800db4:	83 fb 25             	cmp    $0x25,%ebx
  800db7:	0f 95 c0             	setne  %al
  800dba:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800dbf:	84 c0                	test   %al,%al
  800dc1:	75 d0                	jne    800d93 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800dc7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800dce:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800dd5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800ddc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800de3:	eb 04                	jmp    800de9 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800de5:	90                   	nop
  800de6:	eb 01                	jmp    800de9 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800de8:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ded:	0f b6 00             	movzbl (%rax),%eax
  800df0:	0f b6 d8             	movzbl %al,%ebx
  800df3:	89 d8                	mov    %ebx,%eax
  800df5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800dfa:	83 e8 23             	sub    $0x23,%eax
  800dfd:	83 f8 55             	cmp    $0x55,%eax
  800e00:	0f 87 4b 04 00 00    	ja     801251 <vprintfmt+0x4f9>
  800e06:	89 c0                	mov    %eax,%eax
  800e08:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800e0f:	00 
  800e10:	48 b8 18 4f 80 00 00 	movabs $0x804f18,%rax
  800e17:	00 00 00 
  800e1a:	48 01 d0             	add    %rdx,%rax
  800e1d:	48 8b 00             	mov    (%rax),%rax
  800e20:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800e22:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800e26:	eb c1                	jmp    800de9 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e28:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800e2c:	eb bb                	jmp    800de9 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e2e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e35:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e38:	89 d0                	mov    %edx,%eax
  800e3a:	c1 e0 02             	shl    $0x2,%eax
  800e3d:	01 d0                	add    %edx,%eax
  800e3f:	01 c0                	add    %eax,%eax
  800e41:	01 d8                	add    %ebx,%eax
  800e43:	83 e8 30             	sub    $0x30,%eax
  800e46:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e49:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e4d:	0f b6 00             	movzbl (%rax),%eax
  800e50:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e53:	83 fb 2f             	cmp    $0x2f,%ebx
  800e56:	7e 63                	jle    800ebb <vprintfmt+0x163>
  800e58:	83 fb 39             	cmp    $0x39,%ebx
  800e5b:	7f 5e                	jg     800ebb <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e5d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e62:	eb d1                	jmp    800e35 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800e64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e67:	83 f8 30             	cmp    $0x30,%eax
  800e6a:	73 17                	jae    800e83 <vprintfmt+0x12b>
  800e6c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e73:	89 c0                	mov    %eax,%eax
  800e75:	48 01 d0             	add    %rdx,%rax
  800e78:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e7b:	83 c2 08             	add    $0x8,%edx
  800e7e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e81:	eb 0f                	jmp    800e92 <vprintfmt+0x13a>
  800e83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e87:	48 89 d0             	mov    %rdx,%rax
  800e8a:	48 83 c2 08          	add    $0x8,%rdx
  800e8e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e92:	8b 00                	mov    (%rax),%eax
  800e94:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e97:	eb 23                	jmp    800ebc <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800e99:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e9d:	0f 89 42 ff ff ff    	jns    800de5 <vprintfmt+0x8d>
				width = 0;
  800ea3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800eaa:	e9 36 ff ff ff       	jmpq   800de5 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800eaf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800eb6:	e9 2e ff ff ff       	jmpq   800de9 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ebb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ebc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ec0:	0f 89 22 ff ff ff    	jns    800de8 <vprintfmt+0x90>
				width = precision, precision = -1;
  800ec6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ec9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ecc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ed3:	e9 10 ff ff ff       	jmpq   800de8 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ed8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800edc:	e9 08 ff ff ff       	jmpq   800de9 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ee1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ee4:	83 f8 30             	cmp    $0x30,%eax
  800ee7:	73 17                	jae    800f00 <vprintfmt+0x1a8>
  800ee9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800eed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef0:	89 c0                	mov    %eax,%eax
  800ef2:	48 01 d0             	add    %rdx,%rax
  800ef5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ef8:	83 c2 08             	add    $0x8,%edx
  800efb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800efe:	eb 0f                	jmp    800f0f <vprintfmt+0x1b7>
  800f00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f04:	48 89 d0             	mov    %rdx,%rax
  800f07:	48 83 c2 08          	add    $0x8,%rdx
  800f0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f0f:	8b 00                	mov    (%rax),%eax
  800f11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f15:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800f19:	48 89 d6             	mov    %rdx,%rsi
  800f1c:	89 c7                	mov    %eax,%edi
  800f1e:	ff d1                	callq  *%rcx
			break;
  800f20:	e9 5a 03 00 00       	jmpq   80127f <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800f25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f28:	83 f8 30             	cmp    $0x30,%eax
  800f2b:	73 17                	jae    800f44 <vprintfmt+0x1ec>
  800f2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f34:	89 c0                	mov    %eax,%eax
  800f36:	48 01 d0             	add    %rdx,%rax
  800f39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f3c:	83 c2 08             	add    $0x8,%edx
  800f3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f42:	eb 0f                	jmp    800f53 <vprintfmt+0x1fb>
  800f44:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f48:	48 89 d0             	mov    %rdx,%rax
  800f4b:	48 83 c2 08          	add    $0x8,%rdx
  800f4f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f53:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f55:	85 db                	test   %ebx,%ebx
  800f57:	79 02                	jns    800f5b <vprintfmt+0x203>
				err = -err;
  800f59:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f5b:	83 fb 15             	cmp    $0x15,%ebx
  800f5e:	7f 16                	jg     800f76 <vprintfmt+0x21e>
  800f60:	48 b8 40 4e 80 00 00 	movabs $0x804e40,%rax
  800f67:	00 00 00 
  800f6a:	48 63 d3             	movslq %ebx,%rdx
  800f6d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f71:	4d 85 e4             	test   %r12,%r12
  800f74:	75 2e                	jne    800fa4 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800f76:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7e:	89 d9                	mov    %ebx,%ecx
  800f80:	48 ba 01 4f 80 00 00 	movabs $0x804f01,%rdx
  800f87:	00 00 00 
  800f8a:	48 89 c7             	mov    %rax,%rdi
  800f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f92:	49 b8 8f 12 80 00 00 	movabs $0x80128f,%r8
  800f99:	00 00 00 
  800f9c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9f:	e9 db 02 00 00       	jmpq   80127f <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fa8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fac:	4c 89 e1             	mov    %r12,%rcx
  800faf:	48 ba 0a 4f 80 00 00 	movabs $0x804f0a,%rdx
  800fb6:	00 00 00 
  800fb9:	48 89 c7             	mov    %rax,%rdi
  800fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc1:	49 b8 8f 12 80 00 00 	movabs $0x80128f,%r8
  800fc8:	00 00 00 
  800fcb:	41 ff d0             	callq  *%r8
			break;
  800fce:	e9 ac 02 00 00       	jmpq   80127f <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800fd3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fd6:	83 f8 30             	cmp    $0x30,%eax
  800fd9:	73 17                	jae    800ff2 <vprintfmt+0x29a>
  800fdb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fdf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fe2:	89 c0                	mov    %eax,%eax
  800fe4:	48 01 d0             	add    %rdx,%rax
  800fe7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fea:	83 c2 08             	add    $0x8,%edx
  800fed:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ff0:	eb 0f                	jmp    801001 <vprintfmt+0x2a9>
  800ff2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ff6:	48 89 d0             	mov    %rdx,%rax
  800ff9:	48 83 c2 08          	add    $0x8,%rdx
  800ffd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801001:	4c 8b 20             	mov    (%rax),%r12
  801004:	4d 85 e4             	test   %r12,%r12
  801007:	75 0a                	jne    801013 <vprintfmt+0x2bb>
				p = "(null)";
  801009:	49 bc 0d 4f 80 00 00 	movabs $0x804f0d,%r12
  801010:	00 00 00 
			if (width > 0 && padc != '-')
  801013:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801017:	7e 7a                	jle    801093 <vprintfmt+0x33b>
  801019:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80101d:	74 74                	je     801093 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80101f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801022:	48 98                	cltq   
  801024:	48 89 c6             	mov    %rax,%rsi
  801027:	4c 89 e7             	mov    %r12,%rdi
  80102a:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801031:	00 00 00 
  801034:	ff d0                	callq  *%rax
  801036:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801039:	eb 17                	jmp    801052 <vprintfmt+0x2fa>
					putch(padc, putdat);
  80103b:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  80103f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801043:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  801047:	48 89 d6             	mov    %rdx,%rsi
  80104a:	89 c7                	mov    %eax,%edi
  80104c:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80104e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801052:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801056:	7f e3                	jg     80103b <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801058:	eb 39                	jmp    801093 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  80105a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80105e:	74 1e                	je     80107e <vprintfmt+0x326>
  801060:	83 fb 1f             	cmp    $0x1f,%ebx
  801063:	7e 05                	jle    80106a <vprintfmt+0x312>
  801065:	83 fb 7e             	cmp    $0x7e,%ebx
  801068:	7e 14                	jle    80107e <vprintfmt+0x326>
					putch('?', putdat);
  80106a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80106e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801072:	48 89 c6             	mov    %rax,%rsi
  801075:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80107a:	ff d2                	callq  *%rdx
  80107c:	eb 0f                	jmp    80108d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  80107e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801082:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801086:	48 89 c6             	mov    %rax,%rsi
  801089:	89 df                	mov    %ebx,%edi
  80108b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80108d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801091:	eb 01                	jmp    801094 <vprintfmt+0x33c>
  801093:	90                   	nop
  801094:	41 0f b6 04 24       	movzbl (%r12),%eax
  801099:	0f be d8             	movsbl %al,%ebx
  80109c:	85 db                	test   %ebx,%ebx
  80109e:	0f 95 c0             	setne  %al
  8010a1:	49 83 c4 01          	add    $0x1,%r12
  8010a5:	84 c0                	test   %al,%al
  8010a7:	74 28                	je     8010d1 <vprintfmt+0x379>
  8010a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8010ad:	78 ab                	js     80105a <vprintfmt+0x302>
  8010af:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8010b3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8010b7:	79 a1                	jns    80105a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010b9:	eb 16                	jmp    8010d1 <vprintfmt+0x379>
				putch(' ', putdat);
  8010bb:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010bf:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8010c3:	48 89 c6             	mov    %rax,%rsi
  8010c6:	bf 20 00 00 00       	mov    $0x20,%edi
  8010cb:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010cd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010d5:	7f e4                	jg     8010bb <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  8010d7:	e9 a3 01 00 00       	jmpq   80127f <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8010dc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010e0:	be 03 00 00 00       	mov    $0x3,%esi
  8010e5:	48 89 c7             	mov    %rax,%rdi
  8010e8:	48 b8 48 0c 80 00 00 	movabs $0x800c48,%rax
  8010ef:	00 00 00 
  8010f2:	ff d0                	callq  *%rax
  8010f4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fc:	48 85 c0             	test   %rax,%rax
  8010ff:	79 1d                	jns    80111e <vprintfmt+0x3c6>
				putch('-', putdat);
  801101:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801105:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801109:	48 89 c6             	mov    %rax,%rsi
  80110c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801111:	ff d2                	callq  *%rdx
				num = -(long long) num;
  801113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801117:	48 f7 d8             	neg    %rax
  80111a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80111e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801125:	e9 e8 00 00 00       	jmpq   801212 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80112a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80112e:	be 03 00 00 00       	mov    $0x3,%esi
  801133:	48 89 c7             	mov    %rax,%rdi
  801136:	48 b8 38 0b 80 00 00 	movabs $0x800b38,%rax
  80113d:	00 00 00 
  801140:	ff d0                	callq  *%rax
  801142:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801146:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80114d:	e9 c0 00 00 00       	jmpq   801212 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801152:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801156:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80115a:	48 89 c6             	mov    %rax,%rsi
  80115d:	bf 58 00 00 00       	mov    $0x58,%edi
  801162:	ff d2                	callq  *%rdx
			putch('X', putdat);
  801164:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801168:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80116c:	48 89 c6             	mov    %rax,%rsi
  80116f:	bf 58 00 00 00       	mov    $0x58,%edi
  801174:	ff d2                	callq  *%rdx
			putch('X', putdat);
  801176:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80117a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80117e:	48 89 c6             	mov    %rax,%rsi
  801181:	bf 58 00 00 00       	mov    $0x58,%edi
  801186:	ff d2                	callq  *%rdx
			break;
  801188:	e9 f2 00 00 00       	jmpq   80127f <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  80118d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801191:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801195:	48 89 c6             	mov    %rax,%rsi
  801198:	bf 30 00 00 00       	mov    $0x30,%edi
  80119d:	ff d2                	callq  *%rdx
			putch('x', putdat);
  80119f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8011a3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8011a7:	48 89 c6             	mov    %rax,%rsi
  8011aa:	bf 78 00 00 00       	mov    $0x78,%edi
  8011af:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8011b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011b4:	83 f8 30             	cmp    $0x30,%eax
  8011b7:	73 17                	jae    8011d0 <vprintfmt+0x478>
  8011b9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011c0:	89 c0                	mov    %eax,%eax
  8011c2:	48 01 d0             	add    %rdx,%rax
  8011c5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011c8:	83 c2 08             	add    $0x8,%edx
  8011cb:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011ce:	eb 0f                	jmp    8011df <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  8011d0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011d4:	48 89 d0             	mov    %rdx,%rax
  8011d7:	48 83 c2 08          	add    $0x8,%rdx
  8011db:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011df:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011e2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8011e6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8011ed:	eb 23                	jmp    801212 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8011ef:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011f3:	be 03 00 00 00       	mov    $0x3,%esi
  8011f8:	48 89 c7             	mov    %rax,%rdi
  8011fb:	48 b8 38 0b 80 00 00 	movabs $0x800b38,%rax
  801202:	00 00 00 
  801205:	ff d0                	callq  *%rax
  801207:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80120b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801212:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801217:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80121a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80121d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801221:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801225:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801229:	45 89 c1             	mov    %r8d,%r9d
  80122c:	41 89 f8             	mov    %edi,%r8d
  80122f:	48 89 c7             	mov    %rax,%rdi
  801232:	48 b8 80 0a 80 00 00 	movabs $0x800a80,%rax
  801239:	00 00 00 
  80123c:	ff d0                	callq  *%rax
			break;
  80123e:	eb 3f                	jmp    80127f <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801240:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801244:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801248:	48 89 c6             	mov    %rax,%rsi
  80124b:	89 df                	mov    %ebx,%edi
  80124d:	ff d2                	callq  *%rdx
			break;
  80124f:	eb 2e                	jmp    80127f <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801251:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801255:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801259:	48 89 c6             	mov    %rax,%rsi
  80125c:	bf 25 00 00 00       	mov    $0x25,%edi
  801261:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801263:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801268:	eb 05                	jmp    80126f <vprintfmt+0x517>
  80126a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80126f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801273:	48 83 e8 01          	sub    $0x1,%rax
  801277:	0f b6 00             	movzbl (%rax),%eax
  80127a:	3c 25                	cmp    $0x25,%al
  80127c:	75 ec                	jne    80126a <vprintfmt+0x512>
				/* do nothing */;
			break;
  80127e:	90                   	nop
		}
	}
  80127f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801280:	e9 25 fb ff ff       	jmpq   800daa <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801285:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801286:	48 83 c4 60          	add    $0x60,%rsp
  80128a:	5b                   	pop    %rbx
  80128b:	41 5c                	pop    %r12
  80128d:	5d                   	pop    %rbp
  80128e:	c3                   	retq   

000000000080128f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80128f:	55                   	push   %rbp
  801290:	48 89 e5             	mov    %rsp,%rbp
  801293:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80129a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8012a1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8012a8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012af:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012b6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012bd:	84 c0                	test   %al,%al
  8012bf:	74 20                	je     8012e1 <printfmt+0x52>
  8012c1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012c5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012c9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012cd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012d1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012d5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012d9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012dd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012e1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8012e8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8012ef:	00 00 00 
  8012f2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8012f9:	00 00 00 
  8012fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801300:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801307:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80130e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801315:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80131c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801323:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80132a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801331:	48 89 c7             	mov    %rax,%rdi
  801334:	48 b8 58 0d 80 00 00 	movabs $0x800d58,%rax
  80133b:	00 00 00 
  80133e:	ff d0                	callq  *%rax
	va_end(ap);
}
  801340:	c9                   	leaveq 
  801341:	c3                   	retq   

0000000000801342 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	48 83 ec 10          	sub    $0x10,%rsp
  80134a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80134d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801351:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801355:	8b 40 10             	mov    0x10(%rax),%eax
  801358:	8d 50 01             	lea    0x1(%rax),%edx
  80135b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801362:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801366:	48 8b 10             	mov    (%rax),%rdx
  801369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801371:	48 39 c2             	cmp    %rax,%rdx
  801374:	73 17                	jae    80138d <sprintputch+0x4b>
		*b->buf++ = ch;
  801376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137a:	48 8b 00             	mov    (%rax),%rax
  80137d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801380:	88 10                	mov    %dl,(%rax)
  801382:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138a:	48 89 10             	mov    %rdx,(%rax)
}
  80138d:	c9                   	leaveq 
  80138e:	c3                   	retq   

000000000080138f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80138f:	55                   	push   %rbp
  801390:	48 89 e5             	mov    %rsp,%rbp
  801393:	48 83 ec 50          	sub    $0x50,%rsp
  801397:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80139b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80139e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8013a2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8013a6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8013aa:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8013ae:	48 8b 0a             	mov    (%rdx),%rcx
  8013b1:	48 89 08             	mov    %rcx,(%rax)
  8013b4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013b8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013bc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013c0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013c8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8013cc:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8013cf:	48 98                	cltq   
  8013d1:	48 83 e8 01          	sub    $0x1,%rax
  8013d5:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8013d9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8013dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8013e4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8013e9:	74 06                	je     8013f1 <vsnprintf+0x62>
  8013eb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8013ef:	7f 07                	jg     8013f8 <vsnprintf+0x69>
		return -E_INVAL;
  8013f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f6:	eb 2f                	jmp    801427 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8013f8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013fc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801400:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801404:	48 89 c6             	mov    %rax,%rsi
  801407:	48 bf 42 13 80 00 00 	movabs $0x801342,%rdi
  80140e:	00 00 00 
  801411:	48 b8 58 0d 80 00 00 	movabs $0x800d58,%rax
  801418:	00 00 00 
  80141b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80141d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801421:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801424:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801427:	c9                   	leaveq 
  801428:	c3                   	retq   

0000000000801429 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801429:	55                   	push   %rbp
  80142a:	48 89 e5             	mov    %rsp,%rbp
  80142d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801434:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80143b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801441:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801448:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80144f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801456:	84 c0                	test   %al,%al
  801458:	74 20                	je     80147a <snprintf+0x51>
  80145a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80145e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801462:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801466:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80146a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80146e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801472:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801476:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80147a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801481:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801488:	00 00 00 
  80148b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801492:	00 00 00 
  801495:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801499:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014a0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014a7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8014ae:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014b5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014bc:	48 8b 0a             	mov    (%rdx),%rcx
  8014bf:	48 89 08             	mov    %rcx,(%rax)
  8014c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8014d2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8014d9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8014e0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8014e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014ed:	48 89 c7             	mov    %rax,%rdi
  8014f0:	48 b8 8f 13 80 00 00 	movabs $0x80138f,%rax
  8014f7:	00 00 00 
  8014fa:	ff d0                	callq  *%rax
  8014fc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801502:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801508:	c9                   	leaveq 
  801509:	c3                   	retq   
	...

000000000080150c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80150c:	55                   	push   %rbp
  80150d:	48 89 e5             	mov    %rsp,%rbp
  801510:	48 83 ec 18          	sub    $0x18,%rsp
  801514:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80151f:	eb 09                	jmp    80152a <strlen+0x1e>
		n++;
  801521:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801525:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80152a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152e:	0f b6 00             	movzbl (%rax),%eax
  801531:	84 c0                	test   %al,%al
  801533:	75 ec                	jne    801521 <strlen+0x15>
		n++;
	return n;
  801535:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801538:	c9                   	leaveq 
  801539:	c3                   	retq   

000000000080153a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80153a:	55                   	push   %rbp
  80153b:	48 89 e5             	mov    %rsp,%rbp
  80153e:	48 83 ec 20          	sub    $0x20,%rsp
  801542:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801546:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80154a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801551:	eb 0e                	jmp    801561 <strnlen+0x27>
		n++;
  801553:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801557:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80155c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801561:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801566:	74 0b                	je     801573 <strnlen+0x39>
  801568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156c:	0f b6 00             	movzbl (%rax),%eax
  80156f:	84 c0                	test   %al,%al
  801571:	75 e0                	jne    801553 <strnlen+0x19>
		n++;
	return n;
  801573:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801576:	c9                   	leaveq 
  801577:	c3                   	retq   

0000000000801578 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801578:	55                   	push   %rbp
  801579:	48 89 e5             	mov    %rsp,%rbp
  80157c:	48 83 ec 20          	sub    $0x20,%rsp
  801580:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801584:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801590:	90                   	nop
  801591:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801595:	0f b6 10             	movzbl (%rax),%edx
  801598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159c:	88 10                	mov    %dl,(%rax)
  80159e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a2:	0f b6 00             	movzbl (%rax),%eax
  8015a5:	84 c0                	test   %al,%al
  8015a7:	0f 95 c0             	setne  %al
  8015aa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015af:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8015b4:	84 c0                	test   %al,%al
  8015b6:	75 d9                	jne    801591 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8015b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015bc:	c9                   	leaveq 
  8015bd:	c3                   	retq   

00000000008015be <strcat>:

char *
strcat(char *dst, const char *src)
{
  8015be:	55                   	push   %rbp
  8015bf:	48 89 e5             	mov    %rsp,%rbp
  8015c2:	48 83 ec 20          	sub    $0x20,%rsp
  8015c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8015ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d2:	48 89 c7             	mov    %rax,%rdi
  8015d5:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  8015dc:	00 00 00 
  8015df:	ff d0                	callq  *%rax
  8015e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8015e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015e7:	48 98                	cltq   
  8015e9:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8015ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015f1:	48 89 d6             	mov    %rdx,%rsi
  8015f4:	48 89 c7             	mov    %rax,%rdi
  8015f7:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  8015fe:	00 00 00 
  801601:	ff d0                	callq  *%rax
	return dst;
  801603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801607:	c9                   	leaveq 
  801608:	c3                   	retq   

0000000000801609 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801609:	55                   	push   %rbp
  80160a:	48 89 e5             	mov    %rsp,%rbp
  80160d:	48 83 ec 28          	sub    $0x28,%rsp
  801611:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801615:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801619:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80161d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801621:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801625:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80162c:	00 
  80162d:	eb 27                	jmp    801656 <strncpy+0x4d>
		*dst++ = *src;
  80162f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801633:	0f b6 10             	movzbl (%rax),%edx
  801636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163a:	88 10                	mov    %dl,(%rax)
  80163c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801641:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801645:	0f b6 00             	movzbl (%rax),%eax
  801648:	84 c0                	test   %al,%al
  80164a:	74 05                	je     801651 <strncpy+0x48>
			src++;
  80164c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801651:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801656:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80165e:	72 cf                	jb     80162f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801664:	c9                   	leaveq 
  801665:	c3                   	retq   

0000000000801666 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801666:	55                   	push   %rbp
  801667:	48 89 e5             	mov    %rsp,%rbp
  80166a:	48 83 ec 28          	sub    $0x28,%rsp
  80166e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801672:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801676:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80167a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801682:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801687:	74 37                	je     8016c0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801689:	eb 17                	jmp    8016a2 <strlcpy+0x3c>
			*dst++ = *src++;
  80168b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80168f:	0f b6 10             	movzbl (%rax),%edx
  801692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801696:	88 10                	mov    %dl,(%rax)
  801698:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80169d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8016a7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8016ac:	74 0b                	je     8016b9 <strlcpy+0x53>
  8016ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016b2:	0f b6 00             	movzbl (%rax),%eax
  8016b5:	84 c0                	test   %al,%al
  8016b7:	75 d2                	jne    80168b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8016b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8016c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c8:	48 89 d1             	mov    %rdx,%rcx
  8016cb:	48 29 c1             	sub    %rax,%rcx
  8016ce:	48 89 c8             	mov    %rcx,%rax
}
  8016d1:	c9                   	leaveq 
  8016d2:	c3                   	retq   

00000000008016d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016d3:	55                   	push   %rbp
  8016d4:	48 89 e5             	mov    %rsp,%rbp
  8016d7:	48 83 ec 10          	sub    $0x10,%rsp
  8016db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8016e3:	eb 0a                	jmp    8016ef <strcmp+0x1c>
		p++, q++;
  8016e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ea:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f3:	0f b6 00             	movzbl (%rax),%eax
  8016f6:	84 c0                	test   %al,%al
  8016f8:	74 12                	je     80170c <strcmp+0x39>
  8016fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016fe:	0f b6 10             	movzbl (%rax),%edx
  801701:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801705:	0f b6 00             	movzbl (%rax),%eax
  801708:	38 c2                	cmp    %al,%dl
  80170a:	74 d9                	je     8016e5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80170c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171a:	0f b6 00             	movzbl (%rax),%eax
  80171d:	0f b6 c0             	movzbl %al,%eax
  801720:	89 d1                	mov    %edx,%ecx
  801722:	29 c1                	sub    %eax,%ecx
  801724:	89 c8                	mov    %ecx,%eax
}
  801726:	c9                   	leaveq 
  801727:	c3                   	retq   

0000000000801728 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801728:	55                   	push   %rbp
  801729:	48 89 e5             	mov    %rsp,%rbp
  80172c:	48 83 ec 18          	sub    $0x18,%rsp
  801730:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801734:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801738:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80173c:	eb 0f                	jmp    80174d <strncmp+0x25>
		n--, p++, q++;
  80173e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801743:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801748:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80174d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801752:	74 1d                	je     801771 <strncmp+0x49>
  801754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801758:	0f b6 00             	movzbl (%rax),%eax
  80175b:	84 c0                	test   %al,%al
  80175d:	74 12                	je     801771 <strncmp+0x49>
  80175f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801763:	0f b6 10             	movzbl (%rax),%edx
  801766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80176a:	0f b6 00             	movzbl (%rax),%eax
  80176d:	38 c2                	cmp    %al,%dl
  80176f:	74 cd                	je     80173e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801771:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801776:	75 07                	jne    80177f <strncmp+0x57>
		return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
  80177d:	eb 1a                	jmp    801799 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80177f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801783:	0f b6 00             	movzbl (%rax),%eax
  801786:	0f b6 d0             	movzbl %al,%edx
  801789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80178d:	0f b6 00             	movzbl (%rax),%eax
  801790:	0f b6 c0             	movzbl %al,%eax
  801793:	89 d1                	mov    %edx,%ecx
  801795:	29 c1                	sub    %eax,%ecx
  801797:	89 c8                	mov    %ecx,%eax
}
  801799:	c9                   	leaveq 
  80179a:	c3                   	retq   

000000000080179b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80179b:	55                   	push   %rbp
  80179c:	48 89 e5             	mov    %rsp,%rbp
  80179f:	48 83 ec 10          	sub    $0x10,%rsp
  8017a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017a7:	89 f0                	mov    %esi,%eax
  8017a9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017ac:	eb 17                	jmp    8017c5 <strchr+0x2a>
		if (*s == c)
  8017ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b2:	0f b6 00             	movzbl (%rax),%eax
  8017b5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017b8:	75 06                	jne    8017c0 <strchr+0x25>
			return (char *) s;
  8017ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017be:	eb 15                	jmp    8017d5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8017c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c9:	0f b6 00             	movzbl (%rax),%eax
  8017cc:	84 c0                	test   %al,%al
  8017ce:	75 de                	jne    8017ae <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8017d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d5:	c9                   	leaveq 
  8017d6:	c3                   	retq   

00000000008017d7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017d7:	55                   	push   %rbp
  8017d8:	48 89 e5             	mov    %rsp,%rbp
  8017db:	48 83 ec 10          	sub    $0x10,%rsp
  8017df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017e3:	89 f0                	mov    %esi,%eax
  8017e5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017e8:	eb 11                	jmp    8017fb <strfind+0x24>
		if (*s == c)
  8017ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ee:	0f b6 00             	movzbl (%rax),%eax
  8017f1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017f4:	74 12                	je     801808 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ff:	0f b6 00             	movzbl (%rax),%eax
  801802:	84 c0                	test   %al,%al
  801804:	75 e4                	jne    8017ea <strfind+0x13>
  801806:	eb 01                	jmp    801809 <strfind+0x32>
		if (*s == c)
			break;
  801808:	90                   	nop
	return (char *) s;
  801809:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80180d:	c9                   	leaveq 
  80180e:	c3                   	retq   

000000000080180f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80180f:	55                   	push   %rbp
  801810:	48 89 e5             	mov    %rsp,%rbp
  801813:	48 83 ec 18          	sub    $0x18,%rsp
  801817:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80181b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80181e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801822:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801827:	75 06                	jne    80182f <memset+0x20>
		return v;
  801829:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182d:	eb 69                	jmp    801898 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80182f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801833:	83 e0 03             	and    $0x3,%eax
  801836:	48 85 c0             	test   %rax,%rax
  801839:	75 48                	jne    801883 <memset+0x74>
  80183b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183f:	83 e0 03             	and    $0x3,%eax
  801842:	48 85 c0             	test   %rax,%rax
  801845:	75 3c                	jne    801883 <memset+0x74>
		c &= 0xFF;
  801847:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80184e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801851:	89 c2                	mov    %eax,%edx
  801853:	c1 e2 18             	shl    $0x18,%edx
  801856:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801859:	c1 e0 10             	shl    $0x10,%eax
  80185c:	09 c2                	or     %eax,%edx
  80185e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801861:	c1 e0 08             	shl    $0x8,%eax
  801864:	09 d0                	or     %edx,%eax
  801866:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80186d:	48 89 c1             	mov    %rax,%rcx
  801870:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801874:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801878:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80187b:	48 89 d7             	mov    %rdx,%rdi
  80187e:	fc                   	cld    
  80187f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801881:	eb 11                	jmp    801894 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801883:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801887:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80188a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80188e:	48 89 d7             	mov    %rdx,%rdi
  801891:	fc                   	cld    
  801892:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801894:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801898:	c9                   	leaveq 
  801899:	c3                   	retq   

000000000080189a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80189a:	55                   	push   %rbp
  80189b:	48 89 e5             	mov    %rsp,%rbp
  80189e:	48 83 ec 28          	sub    $0x28,%rsp
  8018a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8018ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8018b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8018be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018c6:	0f 83 88 00 00 00    	jae    801954 <memmove+0xba>
  8018cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018d4:	48 01 d0             	add    %rdx,%rax
  8018d7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018db:	76 77                	jbe    801954 <memmove+0xba>
		s += n;
  8018dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8018e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f1:	83 e0 03             	and    $0x3,%eax
  8018f4:	48 85 c0             	test   %rax,%rax
  8018f7:	75 3b                	jne    801934 <memmove+0x9a>
  8018f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018fd:	83 e0 03             	and    $0x3,%eax
  801900:	48 85 c0             	test   %rax,%rax
  801903:	75 2f                	jne    801934 <memmove+0x9a>
  801905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801909:	83 e0 03             	and    $0x3,%eax
  80190c:	48 85 c0             	test   %rax,%rax
  80190f:	75 23                	jne    801934 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801915:	48 83 e8 04          	sub    $0x4,%rax
  801919:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80191d:	48 83 ea 04          	sub    $0x4,%rdx
  801921:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801925:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801929:	48 89 c7             	mov    %rax,%rdi
  80192c:	48 89 d6             	mov    %rdx,%rsi
  80192f:	fd                   	std    
  801930:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801932:	eb 1d                	jmp    801951 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801934:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801938:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80193c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801940:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801944:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801948:	48 89 d7             	mov    %rdx,%rdi
  80194b:	48 89 c1             	mov    %rax,%rcx
  80194e:	fd                   	std    
  80194f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801951:	fc                   	cld    
  801952:	eb 57                	jmp    8019ab <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801958:	83 e0 03             	and    $0x3,%eax
  80195b:	48 85 c0             	test   %rax,%rax
  80195e:	75 36                	jne    801996 <memmove+0xfc>
  801960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801964:	83 e0 03             	and    $0x3,%eax
  801967:	48 85 c0             	test   %rax,%rax
  80196a:	75 2a                	jne    801996 <memmove+0xfc>
  80196c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801970:	83 e0 03             	and    $0x3,%eax
  801973:	48 85 c0             	test   %rax,%rax
  801976:	75 1e                	jne    801996 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801978:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197c:	48 89 c1             	mov    %rax,%rcx
  80197f:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801983:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801987:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80198b:	48 89 c7             	mov    %rax,%rdi
  80198e:	48 89 d6             	mov    %rdx,%rsi
  801991:	fc                   	cld    
  801992:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801994:	eb 15                	jmp    8019ab <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80199a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80199e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8019a2:	48 89 c7             	mov    %rax,%rdi
  8019a5:	48 89 d6             	mov    %rdx,%rsi
  8019a8:	fc                   	cld    
  8019a9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8019ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019af:	c9                   	leaveq 
  8019b0:	c3                   	retq   

00000000008019b1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019b1:	55                   	push   %rbp
  8019b2:	48 89 e5             	mov    %rsp,%rbp
  8019b5:	48 83 ec 18          	sub    $0x18,%rsp
  8019b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8019c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019c9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8019cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d1:	48 89 ce             	mov    %rcx,%rsi
  8019d4:	48 89 c7             	mov    %rax,%rdi
  8019d7:	48 b8 9a 18 80 00 00 	movabs $0x80189a,%rax
  8019de:	00 00 00 
  8019e1:	ff d0                	callq  *%rax
}
  8019e3:	c9                   	leaveq 
  8019e4:	c3                   	retq   

00000000008019e5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019e5:	55                   	push   %rbp
  8019e6:	48 89 e5             	mov    %rsp,%rbp
  8019e9:	48 83 ec 28          	sub    $0x28,%rsp
  8019ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801a01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a05:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801a09:	eb 38                	jmp    801a43 <memcmp+0x5e>
		if (*s1 != *s2)
  801a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0f:	0f b6 10             	movzbl (%rax),%edx
  801a12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a16:	0f b6 00             	movzbl (%rax),%eax
  801a19:	38 c2                	cmp    %al,%dl
  801a1b:	74 1c                	je     801a39 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801a1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a21:	0f b6 00             	movzbl (%rax),%eax
  801a24:	0f b6 d0             	movzbl %al,%edx
  801a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a2b:	0f b6 00             	movzbl (%rax),%eax
  801a2e:	0f b6 c0             	movzbl %al,%eax
  801a31:	89 d1                	mov    %edx,%ecx
  801a33:	29 c1                	sub    %eax,%ecx
  801a35:	89 c8                	mov    %ecx,%eax
  801a37:	eb 20                	jmp    801a59 <memcmp+0x74>
		s1++, s2++;
  801a39:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a3e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a43:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a48:	0f 95 c0             	setne  %al
  801a4b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a50:	84 c0                	test   %al,%al
  801a52:	75 b7                	jne    801a0b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a59:	c9                   	leaveq 
  801a5a:	c3                   	retq   

0000000000801a5b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a5b:	55                   	push   %rbp
  801a5c:	48 89 e5             	mov    %rsp,%rbp
  801a5f:	48 83 ec 28          	sub    $0x28,%rsp
  801a63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a67:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a76:	48 01 d0             	add    %rdx,%rax
  801a79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a7d:	eb 13                	jmp    801a92 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a83:	0f b6 10             	movzbl (%rax),%edx
  801a86:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a89:	38 c2                	cmp    %al,%dl
  801a8b:	74 11                	je     801a9e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a8d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a96:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a9a:	72 e3                	jb     801a7f <memfind+0x24>
  801a9c:	eb 01                	jmp    801a9f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a9e:	90                   	nop
	return (void *) s;
  801a9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801aa3:	c9                   	leaveq 
  801aa4:	c3                   	retq   

0000000000801aa5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801aa5:	55                   	push   %rbp
  801aa6:	48 89 e5             	mov    %rsp,%rbp
  801aa9:	48 83 ec 38          	sub    $0x38,%rsp
  801aad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ab1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801ab5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801ab8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801abf:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801ac6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ac7:	eb 05                	jmp    801ace <strtol+0x29>
		s++;
  801ac9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ace:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad2:	0f b6 00             	movzbl (%rax),%eax
  801ad5:	3c 20                	cmp    $0x20,%al
  801ad7:	74 f0                	je     801ac9 <strtol+0x24>
  801ad9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801add:	0f b6 00             	movzbl (%rax),%eax
  801ae0:	3c 09                	cmp    $0x9,%al
  801ae2:	74 e5                	je     801ac9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ae4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae8:	0f b6 00             	movzbl (%rax),%eax
  801aeb:	3c 2b                	cmp    $0x2b,%al
  801aed:	75 07                	jne    801af6 <strtol+0x51>
		s++;
  801aef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801af4:	eb 17                	jmp    801b0d <strtol+0x68>
	else if (*s == '-')
  801af6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afa:	0f b6 00             	movzbl (%rax),%eax
  801afd:	3c 2d                	cmp    $0x2d,%al
  801aff:	75 0c                	jne    801b0d <strtol+0x68>
		s++, neg = 1;
  801b01:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b06:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801b0d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b11:	74 06                	je     801b19 <strtol+0x74>
  801b13:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801b17:	75 28                	jne    801b41 <strtol+0x9c>
  801b19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b1d:	0f b6 00             	movzbl (%rax),%eax
  801b20:	3c 30                	cmp    $0x30,%al
  801b22:	75 1d                	jne    801b41 <strtol+0x9c>
  801b24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b28:	48 83 c0 01          	add    $0x1,%rax
  801b2c:	0f b6 00             	movzbl (%rax),%eax
  801b2f:	3c 78                	cmp    $0x78,%al
  801b31:	75 0e                	jne    801b41 <strtol+0x9c>
		s += 2, base = 16;
  801b33:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801b38:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801b3f:	eb 2c                	jmp    801b6d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801b41:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b45:	75 19                	jne    801b60 <strtol+0xbb>
  801b47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4b:	0f b6 00             	movzbl (%rax),%eax
  801b4e:	3c 30                	cmp    $0x30,%al
  801b50:	75 0e                	jne    801b60 <strtol+0xbb>
		s++, base = 8;
  801b52:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b57:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b5e:	eb 0d                	jmp    801b6d <strtol+0xc8>
	else if (base == 0)
  801b60:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b64:	75 07                	jne    801b6d <strtol+0xc8>
		base = 10;
  801b66:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b71:	0f b6 00             	movzbl (%rax),%eax
  801b74:	3c 2f                	cmp    $0x2f,%al
  801b76:	7e 1d                	jle    801b95 <strtol+0xf0>
  801b78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b7c:	0f b6 00             	movzbl (%rax),%eax
  801b7f:	3c 39                	cmp    $0x39,%al
  801b81:	7f 12                	jg     801b95 <strtol+0xf0>
			dig = *s - '0';
  801b83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b87:	0f b6 00             	movzbl (%rax),%eax
  801b8a:	0f be c0             	movsbl %al,%eax
  801b8d:	83 e8 30             	sub    $0x30,%eax
  801b90:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b93:	eb 4e                	jmp    801be3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b99:	0f b6 00             	movzbl (%rax),%eax
  801b9c:	3c 60                	cmp    $0x60,%al
  801b9e:	7e 1d                	jle    801bbd <strtol+0x118>
  801ba0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba4:	0f b6 00             	movzbl (%rax),%eax
  801ba7:	3c 7a                	cmp    $0x7a,%al
  801ba9:	7f 12                	jg     801bbd <strtol+0x118>
			dig = *s - 'a' + 10;
  801bab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801baf:	0f b6 00             	movzbl (%rax),%eax
  801bb2:	0f be c0             	movsbl %al,%eax
  801bb5:	83 e8 57             	sub    $0x57,%eax
  801bb8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bbb:	eb 26                	jmp    801be3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801bbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc1:	0f b6 00             	movzbl (%rax),%eax
  801bc4:	3c 40                	cmp    $0x40,%al
  801bc6:	7e 47                	jle    801c0f <strtol+0x16a>
  801bc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bcc:	0f b6 00             	movzbl (%rax),%eax
  801bcf:	3c 5a                	cmp    $0x5a,%al
  801bd1:	7f 3c                	jg     801c0f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801bd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bd7:	0f b6 00             	movzbl (%rax),%eax
  801bda:	0f be c0             	movsbl %al,%eax
  801bdd:	83 e8 37             	sub    $0x37,%eax
  801be0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801be3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801be6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801be9:	7d 23                	jge    801c0e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801beb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801bf0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801bf3:	48 98                	cltq   
  801bf5:	48 89 c2             	mov    %rax,%rdx
  801bf8:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801bfd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c00:	48 98                	cltq   
  801c02:	48 01 d0             	add    %rdx,%rax
  801c05:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801c09:	e9 5f ff ff ff       	jmpq   801b6d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801c0e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801c0f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801c14:	74 0b                	je     801c21 <strtol+0x17c>
		*endptr = (char *) s;
  801c16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c1a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c1e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801c21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c25:	74 09                	je     801c30 <strtol+0x18b>
  801c27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c2b:	48 f7 d8             	neg    %rax
  801c2e:	eb 04                	jmp    801c34 <strtol+0x18f>
  801c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c34:	c9                   	leaveq 
  801c35:	c3                   	retq   

0000000000801c36 <strstr>:

char * strstr(const char *in, const char *str)
{
  801c36:	55                   	push   %rbp
  801c37:	48 89 e5             	mov    %rsp,%rbp
  801c3a:	48 83 ec 30          	sub    $0x30,%rsp
  801c3e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c42:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801c46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c4a:	0f b6 00             	movzbl (%rax),%eax
  801c4d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801c50:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801c55:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c59:	75 06                	jne    801c61 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801c5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5f:	eb 68                	jmp    801cc9 <strstr+0x93>

	len = strlen(str);
  801c61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c65:	48 89 c7             	mov    %rax,%rdi
  801c68:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	callq  *%rax
  801c74:	48 98                	cltq   
  801c76:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801c7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7e:	0f b6 00             	movzbl (%rax),%eax
  801c81:	88 45 ef             	mov    %al,-0x11(%rbp)
  801c84:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801c89:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c8d:	75 07                	jne    801c96 <strstr+0x60>
				return (char *) 0;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c94:	eb 33                	jmp    801cc9 <strstr+0x93>
		} while (sc != c);
  801c96:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c9a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c9d:	75 db                	jne    801c7a <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801c9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ca7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cab:	48 89 ce             	mov    %rcx,%rsi
  801cae:	48 89 c7             	mov    %rax,%rdi
  801cb1:	48 b8 28 17 80 00 00 	movabs $0x801728,%rax
  801cb8:	00 00 00 
  801cbb:	ff d0                	callq  *%rax
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	75 b9                	jne    801c7a <strstr+0x44>

	return (char *) (in - 1);
  801cc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc5:	48 83 e8 01          	sub    $0x1,%rax
}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   
	...

0000000000801ccc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	53                   	push   %rbx
  801cd1:	48 83 ec 58          	sub    $0x58,%rsp
  801cd5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801cd8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801cdb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801cdf:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801ce3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801ce7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ceb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cee:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801cf1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801cf5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801cf9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801cfd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801d01:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801d05:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801d08:	4c 89 c3             	mov    %r8,%rbx
  801d0b:	cd 30                	int    $0x30
  801d0d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801d11:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801d15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801d19:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801d1d:	74 3e                	je     801d5d <syscall+0x91>
  801d1f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d24:	7e 37                	jle    801d5d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801d26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d2a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d2d:	49 89 d0             	mov    %rdx,%r8
  801d30:	89 c1                	mov    %eax,%ecx
  801d32:	48 ba c8 51 80 00 00 	movabs $0x8051c8,%rdx
  801d39:	00 00 00 
  801d3c:	be 23 00 00 00       	mov    $0x23,%esi
  801d41:	48 bf e5 51 80 00 00 	movabs $0x8051e5,%rdi
  801d48:	00 00 00 
  801d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d50:	49 b9 6c 07 80 00 00 	movabs $0x80076c,%r9
  801d57:	00 00 00 
  801d5a:	41 ff d1             	callq  *%r9

	return ret;
  801d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d61:	48 83 c4 58          	add    $0x58,%rsp
  801d65:	5b                   	pop    %rbx
  801d66:	5d                   	pop    %rbp
  801d67:	c3                   	retq   

0000000000801d68 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d68:	55                   	push   %rbp
  801d69:	48 89 e5             	mov    %rsp,%rbp
  801d6c:	48 83 ec 20          	sub    $0x20,%rsp
  801d70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d87:	00 
  801d88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d94:	48 89 d1             	mov    %rdx,%rcx
  801d97:	48 89 c2             	mov    %rax,%rdx
  801d9a:	be 00 00 00 00       	mov    $0x0,%esi
  801d9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801da4:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801dab:	00 00 00 
  801dae:	ff d0                	callq  *%rax
}
  801db0:	c9                   	leaveq 
  801db1:	c3                   	retq   

0000000000801db2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801db2:	55                   	push   %rbp
  801db3:	48 89 e5             	mov    %rsp,%rbp
  801db6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801dba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc1:	00 
  801dc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dce:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd8:	be 00 00 00 00       	mov    $0x0,%esi
  801ddd:	bf 01 00 00 00       	mov    $0x1,%edi
  801de2:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801de9:	00 00 00 
  801dec:	ff d0                	callq  *%rax
}
  801dee:	c9                   	leaveq 
  801def:	c3                   	retq   

0000000000801df0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801df0:	55                   	push   %rbp
  801df1:	48 89 e5             	mov    %rsp,%rbp
  801df4:	48 83 ec 20          	sub    $0x20,%rsp
  801df8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801dfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dfe:	48 98                	cltq   
  801e00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e07:	00 
  801e08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e14:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e19:	48 89 c2             	mov    %rax,%rdx
  801e1c:	be 01 00 00 00       	mov    $0x1,%esi
  801e21:	bf 03 00 00 00       	mov    $0x3,%edi
  801e26:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801e2d:	00 00 00 
  801e30:	ff d0                	callq  *%rax
}
  801e32:	c9                   	leaveq 
  801e33:	c3                   	retq   

0000000000801e34 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801e34:	55                   	push   %rbp
  801e35:	48 89 e5             	mov    %rsp,%rbp
  801e38:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801e3c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e43:	00 
  801e44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e50:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e55:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5a:	be 00 00 00 00       	mov    $0x0,%esi
  801e5f:	bf 02 00 00 00       	mov    $0x2,%edi
  801e64:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801e6b:	00 00 00 
  801e6e:	ff d0                	callq  *%rax
}
  801e70:	c9                   	leaveq 
  801e71:	c3                   	retq   

0000000000801e72 <sys_yield>:

void
sys_yield(void)
{
  801e72:	55                   	push   %rbp
  801e73:	48 89 e5             	mov    %rsp,%rbp
  801e76:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e81:	00 
  801e82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e93:	ba 00 00 00 00       	mov    $0x0,%edx
  801e98:	be 00 00 00 00       	mov    $0x0,%esi
  801e9d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ea2:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801ea9:	00 00 00 
  801eac:	ff d0                	callq  *%rax
}
  801eae:	c9                   	leaveq 
  801eaf:	c3                   	retq   

0000000000801eb0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801eb0:	55                   	push   %rbp
  801eb1:	48 89 e5             	mov    %rsp,%rbp
  801eb4:	48 83 ec 20          	sub    $0x20,%rsp
  801eb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ebb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ebf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ec2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ec5:	48 63 c8             	movslq %eax,%rcx
  801ec8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ecc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ecf:	48 98                	cltq   
  801ed1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ed8:	00 
  801ed9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801edf:	49 89 c8             	mov    %rcx,%r8
  801ee2:	48 89 d1             	mov    %rdx,%rcx
  801ee5:	48 89 c2             	mov    %rax,%rdx
  801ee8:	be 01 00 00 00       	mov    $0x1,%esi
  801eed:	bf 04 00 00 00       	mov    $0x4,%edi
  801ef2:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	callq  *%rax
}
  801efe:	c9                   	leaveq 
  801eff:	c3                   	retq   

0000000000801f00 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801f00:	55                   	push   %rbp
  801f01:	48 89 e5             	mov    %rsp,%rbp
  801f04:	48 83 ec 30          	sub    $0x30,%rsp
  801f08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f0f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f12:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f16:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801f1a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f1d:	48 63 c8             	movslq %eax,%rcx
  801f20:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f27:	48 63 f0             	movslq %eax,%rsi
  801f2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f31:	48 98                	cltq   
  801f33:	48 89 0c 24          	mov    %rcx,(%rsp)
  801f37:	49 89 f9             	mov    %rdi,%r9
  801f3a:	49 89 f0             	mov    %rsi,%r8
  801f3d:	48 89 d1             	mov    %rdx,%rcx
  801f40:	48 89 c2             	mov    %rax,%rdx
  801f43:	be 01 00 00 00       	mov    $0x1,%esi
  801f48:	bf 05 00 00 00       	mov    $0x5,%edi
  801f4d:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801f54:	00 00 00 
  801f57:	ff d0                	callq  *%rax
}
  801f59:	c9                   	leaveq 
  801f5a:	c3                   	retq   

0000000000801f5b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f5b:	55                   	push   %rbp
  801f5c:	48 89 e5             	mov    %rsp,%rbp
  801f5f:	48 83 ec 20          	sub    $0x20,%rsp
  801f63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f71:	48 98                	cltq   
  801f73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f7a:	00 
  801f7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f87:	48 89 d1             	mov    %rdx,%rcx
  801f8a:	48 89 c2             	mov    %rax,%rdx
  801f8d:	be 01 00 00 00       	mov    $0x1,%esi
  801f92:	bf 06 00 00 00       	mov    $0x6,%edi
  801f97:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801f9e:	00 00 00 
  801fa1:	ff d0                	callq  *%rax
}
  801fa3:	c9                   	leaveq 
  801fa4:	c3                   	retq   

0000000000801fa5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801fa5:	55                   	push   %rbp
  801fa6:	48 89 e5             	mov    %rsp,%rbp
  801fa9:	48 83 ec 20          	sub    $0x20,%rsp
  801fad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fb0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801fb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fb6:	48 63 d0             	movslq %eax,%rdx
  801fb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fbc:	48 98                	cltq   
  801fbe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fc5:	00 
  801fc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fcc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd2:	48 89 d1             	mov    %rdx,%rcx
  801fd5:	48 89 c2             	mov    %rax,%rdx
  801fd8:	be 01 00 00 00       	mov    $0x1,%esi
  801fdd:	bf 08 00 00 00       	mov    $0x8,%edi
  801fe2:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  801fe9:	00 00 00 
  801fec:	ff d0                	callq  *%rax
}
  801fee:	c9                   	leaveq 
  801fef:	c3                   	retq   

0000000000801ff0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ff0:	55                   	push   %rbp
  801ff1:	48 89 e5             	mov    %rsp,%rbp
  801ff4:	48 83 ec 20          	sub    $0x20,%rsp
  801ff8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ffb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802003:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802006:	48 98                	cltq   
  802008:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80200f:	00 
  802010:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802016:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80201c:	48 89 d1             	mov    %rdx,%rcx
  80201f:	48 89 c2             	mov    %rax,%rdx
  802022:	be 01 00 00 00       	mov    $0x1,%esi
  802027:	bf 09 00 00 00       	mov    $0x9,%edi
  80202c:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  802033:	00 00 00 
  802036:	ff d0                	callq  *%rax
}
  802038:	c9                   	leaveq 
  802039:	c3                   	retq   

000000000080203a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80203a:	55                   	push   %rbp
  80203b:	48 89 e5             	mov    %rsp,%rbp
  80203e:	48 83 ec 20          	sub    $0x20,%rsp
  802042:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802045:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802049:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80204d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802050:	48 98                	cltq   
  802052:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802059:	00 
  80205a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802060:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802066:	48 89 d1             	mov    %rdx,%rcx
  802069:	48 89 c2             	mov    %rax,%rdx
  80206c:	be 01 00 00 00       	mov    $0x1,%esi
  802071:	bf 0a 00 00 00       	mov    $0xa,%edi
  802076:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  80207d:	00 00 00 
  802080:	ff d0                	callq  *%rax
}
  802082:	c9                   	leaveq 
  802083:	c3                   	retq   

0000000000802084 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802084:	55                   	push   %rbp
  802085:	48 89 e5             	mov    %rsp,%rbp
  802088:	48 83 ec 30          	sub    $0x30,%rsp
  80208c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80208f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802093:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802097:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80209a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80209d:	48 63 f0             	movslq %eax,%rsi
  8020a0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a7:	48 98                	cltq   
  8020a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020b4:	00 
  8020b5:	49 89 f1             	mov    %rsi,%r9
  8020b8:	49 89 c8             	mov    %rcx,%r8
  8020bb:	48 89 d1             	mov    %rdx,%rcx
  8020be:	48 89 c2             	mov    %rax,%rdx
  8020c1:	be 00 00 00 00       	mov    $0x0,%esi
  8020c6:	bf 0c 00 00 00       	mov    $0xc,%edi
  8020cb:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  8020d2:	00 00 00 
  8020d5:	ff d0                	callq  *%rax
}
  8020d7:	c9                   	leaveq 
  8020d8:	c3                   	retq   

00000000008020d9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8020d9:	55                   	push   %rbp
  8020da:	48 89 e5             	mov    %rsp,%rbp
  8020dd:	48 83 ec 20          	sub    $0x20,%rsp
  8020e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8020e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020f0:	00 
  8020f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  802102:	48 89 c2             	mov    %rax,%rdx
  802105:	be 01 00 00 00       	mov    $0x1,%esi
  80210a:	bf 0d 00 00 00       	mov    $0xd,%edi
  80210f:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  802116:	00 00 00 
  802119:	ff d0                	callq  *%rax
}
  80211b:	c9                   	leaveq 
  80211c:	c3                   	retq   

000000000080211d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80211d:	55                   	push   %rbp
  80211e:	48 89 e5             	mov    %rsp,%rbp
  802121:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802125:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80212c:	00 
  80212d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802133:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802139:	b9 00 00 00 00       	mov    $0x0,%ecx
  80213e:	ba 00 00 00 00       	mov    $0x0,%edx
  802143:	be 00 00 00 00       	mov    $0x0,%esi
  802148:	bf 0e 00 00 00       	mov    $0xe,%edi
  80214d:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  802154:	00 00 00 
  802157:	ff d0                	callq  *%rax
}
  802159:	c9                   	leaveq 
  80215a:	c3                   	retq   

000000000080215b <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80215b:	55                   	push   %rbp
  80215c:	48 89 e5             	mov    %rsp,%rbp
  80215f:	48 83 ec 30          	sub    $0x30,%rsp
  802163:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802166:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80216a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80216d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802171:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802175:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802178:	48 63 c8             	movslq %eax,%rcx
  80217b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80217f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802182:	48 63 f0             	movslq %eax,%rsi
  802185:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802189:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80218c:	48 98                	cltq   
  80218e:	48 89 0c 24          	mov    %rcx,(%rsp)
  802192:	49 89 f9             	mov    %rdi,%r9
  802195:	49 89 f0             	mov    %rsi,%r8
  802198:	48 89 d1             	mov    %rdx,%rcx
  80219b:	48 89 c2             	mov    %rax,%rdx
  80219e:	be 00 00 00 00       	mov    $0x0,%esi
  8021a3:	bf 0f 00 00 00       	mov    $0xf,%edi
  8021a8:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  8021af:	00 00 00 
  8021b2:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8021b4:	c9                   	leaveq 
  8021b5:	c3                   	retq   

00000000008021b6 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8021b6:	55                   	push   %rbp
  8021b7:	48 89 e5             	mov    %rsp,%rbp
  8021ba:	48 83 ec 20          	sub    $0x20,%rsp
  8021be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8021c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8021c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021d5:	00 
  8021d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021e2:	48 89 d1             	mov    %rdx,%rcx
  8021e5:	48 89 c2             	mov    %rax,%rdx
  8021e8:	be 00 00 00 00       	mov    $0x0,%esi
  8021ed:	bf 10 00 00 00       	mov    $0x10,%edi
  8021f2:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  8021f9:	00 00 00 
  8021fc:	ff d0                	callq  *%rax
}
  8021fe:	c9                   	leaveq 
  8021ff:	c3                   	retq   

0000000000802200 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802200:	55                   	push   %rbp
  802201:	48 89 e5             	mov    %rsp,%rbp
  802204:	48 83 ec 08          	sub    $0x8,%rsp
  802208:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80220c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802210:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802217:	ff ff ff 
  80221a:	48 01 d0             	add    %rdx,%rax
  80221d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802221:	c9                   	leaveq 
  802222:	c3                   	retq   

0000000000802223 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802223:	55                   	push   %rbp
  802224:	48 89 e5             	mov    %rsp,%rbp
  802227:	48 83 ec 08          	sub    $0x8,%rsp
  80222b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80222f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802233:	48 89 c7             	mov    %rax,%rdi
  802236:	48 b8 00 22 80 00 00 	movabs $0x802200,%rax
  80223d:	00 00 00 
  802240:	ff d0                	callq  *%rax
  802242:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802248:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80224c:	c9                   	leaveq 
  80224d:	c3                   	retq   

000000000080224e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80224e:	55                   	push   %rbp
  80224f:	48 89 e5             	mov    %rsp,%rbp
  802252:	48 83 ec 18          	sub    $0x18,%rsp
  802256:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80225a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802261:	eb 6b                	jmp    8022ce <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802263:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802266:	48 98                	cltq   
  802268:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80226e:	48 c1 e0 0c          	shl    $0xc,%rax
  802272:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802276:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80227a:	48 89 c2             	mov    %rax,%rdx
  80227d:	48 c1 ea 15          	shr    $0x15,%rdx
  802281:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802288:	01 00 00 
  80228b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228f:	83 e0 01             	and    $0x1,%eax
  802292:	48 85 c0             	test   %rax,%rax
  802295:	74 21                	je     8022b8 <fd_alloc+0x6a>
  802297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80229b:	48 89 c2             	mov    %rax,%rdx
  80229e:	48 c1 ea 0c          	shr    $0xc,%rdx
  8022a2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a9:	01 00 00 
  8022ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b0:	83 e0 01             	and    $0x1,%eax
  8022b3:	48 85 c0             	test   %rax,%rax
  8022b6:	75 12                	jne    8022ca <fd_alloc+0x7c>
			*fd_store = fd;
  8022b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022c0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c8:	eb 1a                	jmp    8022e4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022ce:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022d2:	7e 8f                	jle    802263 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8022d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8022df:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022e4:	c9                   	leaveq 
  8022e5:	c3                   	retq   

00000000008022e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022e6:	55                   	push   %rbp
  8022e7:	48 89 e5             	mov    %rsp,%rbp
  8022ea:	48 83 ec 20          	sub    $0x20,%rsp
  8022ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022f9:	78 06                	js     802301 <fd_lookup+0x1b>
  8022fb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022ff:	7e 07                	jle    802308 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802301:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802306:	eb 6c                	jmp    802374 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802308:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80230b:	48 98                	cltq   
  80230d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802313:	48 c1 e0 0c          	shl    $0xc,%rax
  802317:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80231b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80231f:	48 89 c2             	mov    %rax,%rdx
  802322:	48 c1 ea 15          	shr    $0x15,%rdx
  802326:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80232d:	01 00 00 
  802330:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802334:	83 e0 01             	and    $0x1,%eax
  802337:	48 85 c0             	test   %rax,%rax
  80233a:	74 21                	je     80235d <fd_lookup+0x77>
  80233c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802340:	48 89 c2             	mov    %rax,%rdx
  802343:	48 c1 ea 0c          	shr    $0xc,%rdx
  802347:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80234e:	01 00 00 
  802351:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802355:	83 e0 01             	and    $0x1,%eax
  802358:	48 85 c0             	test   %rax,%rax
  80235b:	75 07                	jne    802364 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80235d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802362:	eb 10                	jmp    802374 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802364:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802368:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80236c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802374:	c9                   	leaveq 
  802375:	c3                   	retq   

0000000000802376 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802376:	55                   	push   %rbp
  802377:	48 89 e5             	mov    %rsp,%rbp
  80237a:	48 83 ec 30          	sub    $0x30,%rsp
  80237e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802382:	89 f0                	mov    %esi,%eax
  802384:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238b:	48 89 c7             	mov    %rax,%rdi
  80238e:	48 b8 00 22 80 00 00 	movabs $0x802200,%rax
  802395:	00 00 00 
  802398:	ff d0                	callq  *%rax
  80239a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80239e:	48 89 d6             	mov    %rdx,%rsi
  8023a1:	89 c7                	mov    %eax,%edi
  8023a3:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  8023aa:	00 00 00 
  8023ad:	ff d0                	callq  *%rax
  8023af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b6:	78 0a                	js     8023c2 <fd_close+0x4c>
	    || fd != fd2)
  8023b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023bc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023c0:	74 12                	je     8023d4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023c2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8023c6:	74 05                	je     8023cd <fd_close+0x57>
  8023c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cb:	eb 05                	jmp    8023d2 <fd_close+0x5c>
  8023cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d2:	eb 69                	jmp    80243d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023d8:	8b 00                	mov    (%rax),%eax
  8023da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023de:	48 89 d6             	mov    %rdx,%rsi
  8023e1:	89 c7                	mov    %eax,%edi
  8023e3:	48 b8 3f 24 80 00 00 	movabs $0x80243f,%rax
  8023ea:	00 00 00 
  8023ed:	ff d0                	callq  *%rax
  8023ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f6:	78 2a                	js     802422 <fd_close+0xac>
		if (dev->dev_close)
  8023f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fc:	48 8b 40 20          	mov    0x20(%rax),%rax
  802400:	48 85 c0             	test   %rax,%rax
  802403:	74 16                	je     80241b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802409:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80240d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802411:	48 89 c7             	mov    %rax,%rdi
  802414:	ff d2                	callq  *%rdx
  802416:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802419:	eb 07                	jmp    802422 <fd_close+0xac>
		else
			r = 0;
  80241b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802422:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802426:	48 89 c6             	mov    %rax,%rsi
  802429:	bf 00 00 00 00       	mov    $0x0,%edi
  80242e:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  802435:	00 00 00 
  802438:	ff d0                	callq  *%rax
	return r;
  80243a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80243d:	c9                   	leaveq 
  80243e:	c3                   	retq   

000000000080243f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80243f:	55                   	push   %rbp
  802440:	48 89 e5             	mov    %rsp,%rbp
  802443:	48 83 ec 20          	sub    $0x20,%rsp
  802447:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80244a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80244e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802455:	eb 41                	jmp    802498 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802457:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  80245e:	00 00 00 
  802461:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802464:	48 63 d2             	movslq %edx,%rdx
  802467:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80246b:	8b 00                	mov    (%rax),%eax
  80246d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802470:	75 22                	jne    802494 <dev_lookup+0x55>
			*dev = devtab[i];
  802472:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  802479:	00 00 00 
  80247c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80247f:	48 63 d2             	movslq %edx,%rdx
  802482:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802486:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80248a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
  802492:	eb 60                	jmp    8024f4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802494:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802498:	48 b8 c0 87 80 00 00 	movabs $0x8087c0,%rax
  80249f:	00 00 00 
  8024a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024a5:	48 63 d2             	movslq %edx,%rdx
  8024a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ac:	48 85 c0             	test   %rax,%rax
  8024af:	75 a6                	jne    802457 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8024b1:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8024b8:	00 00 00 
  8024bb:	48 8b 00             	mov    (%rax),%rax
  8024be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024c4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024c7:	89 c6                	mov    %eax,%esi
  8024c9:	48 bf f8 51 80 00 00 	movabs $0x8051f8,%rdi
  8024d0:	00 00 00 
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d8:	48 b9 a7 09 80 00 00 	movabs $0x8009a7,%rcx
  8024df:	00 00 00 
  8024e2:	ff d1                	callq  *%rcx
	*dev = 0;
  8024e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024e8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024f4:	c9                   	leaveq 
  8024f5:	c3                   	retq   

00000000008024f6 <close>:

int
close(int fdnum)
{
  8024f6:	55                   	push   %rbp
  8024f7:	48 89 e5             	mov    %rsp,%rbp
  8024fa:	48 83 ec 20          	sub    $0x20,%rsp
  8024fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802501:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802505:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802508:	48 89 d6             	mov    %rdx,%rsi
  80250b:	89 c7                	mov    %eax,%edi
  80250d:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  802514:	00 00 00 
  802517:	ff d0                	callq  *%rax
  802519:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802520:	79 05                	jns    802527 <close+0x31>
		return r;
  802522:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802525:	eb 18                	jmp    80253f <close+0x49>
	else
		return fd_close(fd, 1);
  802527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252b:	be 01 00 00 00       	mov    $0x1,%esi
  802530:	48 89 c7             	mov    %rax,%rdi
  802533:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  80253a:	00 00 00 
  80253d:	ff d0                	callq  *%rax
}
  80253f:	c9                   	leaveq 
  802540:	c3                   	retq   

0000000000802541 <close_all>:

void
close_all(void)
{
  802541:	55                   	push   %rbp
  802542:	48 89 e5             	mov    %rsp,%rbp
  802545:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802549:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802550:	eb 15                	jmp    802567 <close_all+0x26>
		close(i);
  802552:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802555:	89 c7                	mov    %eax,%edi
  802557:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  80255e:	00 00 00 
  802561:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802563:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802567:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80256b:	7e e5                	jle    802552 <close_all+0x11>
		close(i);
}
  80256d:	c9                   	leaveq 
  80256e:	c3                   	retq   

000000000080256f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80256f:	55                   	push   %rbp
  802570:	48 89 e5             	mov    %rsp,%rbp
  802573:	48 83 ec 40          	sub    $0x40,%rsp
  802577:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80257a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80257d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802581:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802584:	48 89 d6             	mov    %rdx,%rsi
  802587:	89 c7                	mov    %eax,%edi
  802589:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  802590:	00 00 00 
  802593:	ff d0                	callq  *%rax
  802595:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802598:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259c:	79 08                	jns    8025a6 <dup+0x37>
		return r;
  80259e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a1:	e9 70 01 00 00       	jmpq   802716 <dup+0x1a7>
	close(newfdnum);
  8025a6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025a9:	89 c7                	mov    %eax,%edi
  8025ab:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  8025b2:	00 00 00 
  8025b5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025b7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025ba:	48 98                	cltq   
  8025bc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025c2:	48 c1 e0 0c          	shl    $0xc,%rax
  8025c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8025ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025ce:	48 89 c7             	mov    %rax,%rdi
  8025d1:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8025d8:	00 00 00 
  8025db:	ff d0                	callq  *%rax
  8025dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e5:	48 89 c7             	mov    %rax,%rdi
  8025e8:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8025ef:	00 00 00 
  8025f2:	ff d0                	callq  *%rax
  8025f4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fc:	48 89 c2             	mov    %rax,%rdx
  8025ff:	48 c1 ea 15          	shr    $0x15,%rdx
  802603:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80260a:	01 00 00 
  80260d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802611:	83 e0 01             	and    $0x1,%eax
  802614:	84 c0                	test   %al,%al
  802616:	74 71                	je     802689 <dup+0x11a>
  802618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261c:	48 89 c2             	mov    %rax,%rdx
  80261f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802623:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80262a:	01 00 00 
  80262d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802631:	83 e0 01             	and    $0x1,%eax
  802634:	84 c0                	test   %al,%al
  802636:	74 51                	je     802689 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263c:	48 89 c2             	mov    %rax,%rdx
  80263f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802643:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80264a:	01 00 00 
  80264d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802651:	89 c1                	mov    %eax,%ecx
  802653:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802659:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80265d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802661:	41 89 c8             	mov    %ecx,%r8d
  802664:	48 89 d1             	mov    %rdx,%rcx
  802667:	ba 00 00 00 00       	mov    $0x0,%edx
  80266c:	48 89 c6             	mov    %rax,%rsi
  80266f:	bf 00 00 00 00       	mov    $0x0,%edi
  802674:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	callq  *%rax
  802680:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802683:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802687:	78 56                	js     8026df <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80268d:	48 89 c2             	mov    %rax,%rdx
  802690:	48 c1 ea 0c          	shr    $0xc,%rdx
  802694:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80269b:	01 00 00 
  80269e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a2:	89 c1                	mov    %eax,%ecx
  8026a4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8026aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026b2:	41 89 c8             	mov    %ecx,%r8d
  8026b5:	48 89 d1             	mov    %rdx,%rcx
  8026b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bd:	48 89 c6             	mov    %rax,%rsi
  8026c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c5:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  8026cc:	00 00 00 
  8026cf:	ff d0                	callq  *%rax
  8026d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d8:	78 08                	js     8026e2 <dup+0x173>
		goto err;

	return newfdnum;
  8026da:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026dd:	eb 37                	jmp    802716 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8026df:	90                   	nop
  8026e0:	eb 01                	jmp    8026e3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8026e2:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8026e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e7:	48 89 c6             	mov    %rax,%rsi
  8026ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ef:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  8026f6:	00 00 00 
  8026f9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ff:	48 89 c6             	mov    %rax,%rsi
  802702:	bf 00 00 00 00       	mov    $0x0,%edi
  802707:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  80270e:	00 00 00 
  802711:	ff d0                	callq  *%rax
	return r;
  802713:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802716:	c9                   	leaveq 
  802717:	c3                   	retq   

0000000000802718 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802718:	55                   	push   %rbp
  802719:	48 89 e5             	mov    %rsp,%rbp
  80271c:	48 83 ec 40          	sub    $0x40,%rsp
  802720:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802723:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802727:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80272b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80272f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802732:	48 89 d6             	mov    %rdx,%rsi
  802735:	89 c7                	mov    %eax,%edi
  802737:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  80273e:	00 00 00 
  802741:	ff d0                	callq  *%rax
  802743:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802746:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80274a:	78 24                	js     802770 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80274c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802750:	8b 00                	mov    (%rax),%eax
  802752:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802756:	48 89 d6             	mov    %rdx,%rsi
  802759:	89 c7                	mov    %eax,%edi
  80275b:	48 b8 3f 24 80 00 00 	movabs $0x80243f,%rax
  802762:	00 00 00 
  802765:	ff d0                	callq  *%rax
  802767:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276e:	79 05                	jns    802775 <read+0x5d>
		return r;
  802770:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802773:	eb 7a                	jmp    8027ef <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802779:	8b 40 08             	mov    0x8(%rax),%eax
  80277c:	83 e0 03             	and    $0x3,%eax
  80277f:	83 f8 01             	cmp    $0x1,%eax
  802782:	75 3a                	jne    8027be <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802784:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  80278b:	00 00 00 
  80278e:	48 8b 00             	mov    (%rax),%rax
  802791:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802797:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80279a:	89 c6                	mov    %eax,%esi
  80279c:	48 bf 17 52 80 00 00 	movabs $0x805217,%rdi
  8027a3:	00 00 00 
  8027a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ab:	48 b9 a7 09 80 00 00 	movabs $0x8009a7,%rcx
  8027b2:	00 00 00 
  8027b5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027bc:	eb 31                	jmp    8027ef <read+0xd7>
	}
	if (!dev->dev_read)
  8027be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027c6:	48 85 c0             	test   %rax,%rax
  8027c9:	75 07                	jne    8027d2 <read+0xba>
		return -E_NOT_SUPP;
  8027cb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027d0:	eb 1d                	jmp    8027ef <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8027d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d6:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8027da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027de:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027e2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027e6:	48 89 ce             	mov    %rcx,%rsi
  8027e9:	48 89 c7             	mov    %rax,%rdi
  8027ec:	41 ff d0             	callq  *%r8
}
  8027ef:	c9                   	leaveq 
  8027f0:	c3                   	retq   

00000000008027f1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027f1:	55                   	push   %rbp
  8027f2:	48 89 e5             	mov    %rsp,%rbp
  8027f5:	48 83 ec 30          	sub    $0x30,%rsp
  8027f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802800:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802804:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80280b:	eb 46                	jmp    802853 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80280d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802810:	48 98                	cltq   
  802812:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802816:	48 29 c2             	sub    %rax,%rdx
  802819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281c:	48 98                	cltq   
  80281e:	48 89 c1             	mov    %rax,%rcx
  802821:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802825:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802828:	48 89 ce             	mov    %rcx,%rsi
  80282b:	89 c7                	mov    %eax,%edi
  80282d:	48 b8 18 27 80 00 00 	movabs $0x802718,%rax
  802834:	00 00 00 
  802837:	ff d0                	callq  *%rax
  802839:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80283c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802840:	79 05                	jns    802847 <readn+0x56>
			return m;
  802842:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802845:	eb 1d                	jmp    802864 <readn+0x73>
		if (m == 0)
  802847:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80284b:	74 13                	je     802860 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80284d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802850:	01 45 fc             	add    %eax,-0x4(%rbp)
  802853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802856:	48 98                	cltq   
  802858:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80285c:	72 af                	jb     80280d <readn+0x1c>
  80285e:	eb 01                	jmp    802861 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802860:	90                   	nop
	}
	return tot;
  802861:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802864:	c9                   	leaveq 
  802865:	c3                   	retq   

0000000000802866 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802866:	55                   	push   %rbp
  802867:	48 89 e5             	mov    %rsp,%rbp
  80286a:	48 83 ec 40          	sub    $0x40,%rsp
  80286e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802871:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802875:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802879:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80287d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802880:	48 89 d6             	mov    %rdx,%rsi
  802883:	89 c7                	mov    %eax,%edi
  802885:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  80288c:	00 00 00 
  80288f:	ff d0                	callq  *%rax
  802891:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802894:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802898:	78 24                	js     8028be <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80289a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289e:	8b 00                	mov    (%rax),%eax
  8028a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028a4:	48 89 d6             	mov    %rdx,%rsi
  8028a7:	89 c7                	mov    %eax,%edi
  8028a9:	48 b8 3f 24 80 00 00 	movabs $0x80243f,%rax
  8028b0:	00 00 00 
  8028b3:	ff d0                	callq  *%rax
  8028b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028bc:	79 05                	jns    8028c3 <write+0x5d>
		return r;
  8028be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c1:	eb 79                	jmp    80293c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c7:	8b 40 08             	mov    0x8(%rax),%eax
  8028ca:	83 e0 03             	and    $0x3,%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	75 3a                	jne    80290b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8028d1:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8028d8:	00 00 00 
  8028db:	48 8b 00             	mov    (%rax),%rax
  8028de:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028e4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028e7:	89 c6                	mov    %eax,%esi
  8028e9:	48 bf 33 52 80 00 00 	movabs $0x805233,%rdi
  8028f0:	00 00 00 
  8028f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f8:	48 b9 a7 09 80 00 00 	movabs $0x8009a7,%rcx
  8028ff:	00 00 00 
  802902:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802904:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802909:	eb 31                	jmp    80293c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80290b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802913:	48 85 c0             	test   %rax,%rax
  802916:	75 07                	jne    80291f <write+0xb9>
		return -E_NOT_SUPP;
  802918:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80291d:	eb 1d                	jmp    80293c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80291f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802923:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80292f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802933:	48 89 ce             	mov    %rcx,%rsi
  802936:	48 89 c7             	mov    %rax,%rdi
  802939:	41 ff d0             	callq  *%r8
}
  80293c:	c9                   	leaveq 
  80293d:	c3                   	retq   

000000000080293e <seek>:

int
seek(int fdnum, off_t offset)
{
  80293e:	55                   	push   %rbp
  80293f:	48 89 e5             	mov    %rsp,%rbp
  802942:	48 83 ec 18          	sub    $0x18,%rsp
  802946:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802949:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80294c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802950:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802953:	48 89 d6             	mov    %rdx,%rsi
  802956:	89 c7                	mov    %eax,%edi
  802958:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
  802964:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802967:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296b:	79 05                	jns    802972 <seek+0x34>
		return r;
  80296d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802970:	eb 0f                	jmp    802981 <seek+0x43>
	fd->fd_offset = offset;
  802972:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802976:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802979:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80297c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802981:	c9                   	leaveq 
  802982:	c3                   	retq   

0000000000802983 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802983:	55                   	push   %rbp
  802984:	48 89 e5             	mov    %rsp,%rbp
  802987:	48 83 ec 30          	sub    $0x30,%rsp
  80298b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80298e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802991:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802995:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802998:	48 89 d6             	mov    %rdx,%rsi
  80299b:	89 c7                	mov    %eax,%edi
  80299d:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  8029a4:	00 00 00 
  8029a7:	ff d0                	callq  *%rax
  8029a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b0:	78 24                	js     8029d6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b6:	8b 00                	mov    (%rax),%eax
  8029b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029bc:	48 89 d6             	mov    %rdx,%rsi
  8029bf:	89 c7                	mov    %eax,%edi
  8029c1:	48 b8 3f 24 80 00 00 	movabs $0x80243f,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	callq  *%rax
  8029cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d4:	79 05                	jns    8029db <ftruncate+0x58>
		return r;
  8029d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d9:	eb 72                	jmp    802a4d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029df:	8b 40 08             	mov    0x8(%rax),%eax
  8029e2:	83 e0 03             	and    $0x3,%eax
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	75 3a                	jne    802a23 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029e9:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8029f0:	00 00 00 
  8029f3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029ff:	89 c6                	mov    %eax,%esi
  802a01:	48 bf 50 52 80 00 00 	movabs $0x805250,%rdi
  802a08:	00 00 00 
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a10:	48 b9 a7 09 80 00 00 	movabs $0x8009a7,%rcx
  802a17:	00 00 00 
  802a1a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a21:	eb 2a                	jmp    802a4d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a27:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a2b:	48 85 c0             	test   %rax,%rax
  802a2e:	75 07                	jne    802a37 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a30:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a35:	eb 16                	jmp    802a4d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a43:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802a46:	89 d6                	mov    %edx,%esi
  802a48:	48 89 c7             	mov    %rax,%rdi
  802a4b:	ff d1                	callq  *%rcx
}
  802a4d:	c9                   	leaveq 
  802a4e:	c3                   	retq   

0000000000802a4f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a4f:	55                   	push   %rbp
  802a50:	48 89 e5             	mov    %rsp,%rbp
  802a53:	48 83 ec 30          	sub    $0x30,%rsp
  802a57:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a5a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a5e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a62:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a65:	48 89 d6             	mov    %rdx,%rsi
  802a68:	89 c7                	mov    %eax,%edi
  802a6a:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  802a71:	00 00 00 
  802a74:	ff d0                	callq  *%rax
  802a76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7d:	78 24                	js     802aa3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a83:	8b 00                	mov    (%rax),%eax
  802a85:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a89:	48 89 d6             	mov    %rdx,%rsi
  802a8c:	89 c7                	mov    %eax,%edi
  802a8e:	48 b8 3f 24 80 00 00 	movabs $0x80243f,%rax
  802a95:	00 00 00 
  802a98:	ff d0                	callq  *%rax
  802a9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa1:	79 05                	jns    802aa8 <fstat+0x59>
		return r;
  802aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa6:	eb 5e                	jmp    802b06 <fstat+0xb7>
	if (!dev->dev_stat)
  802aa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aac:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ab0:	48 85 c0             	test   %rax,%rax
  802ab3:	75 07                	jne    802abc <fstat+0x6d>
		return -E_NOT_SUPP;
  802ab5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aba:	eb 4a                	jmp    802b06 <fstat+0xb7>
	stat->st_name[0] = 0;
  802abc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ac0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ac3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ac7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ace:	00 00 00 
	stat->st_isdir = 0;
  802ad1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ad5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802adc:	00 00 00 
	stat->st_dev = dev;
  802adf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ae3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ae7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802aee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af2:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802afe:	48 89 d6             	mov    %rdx,%rsi
  802b01:	48 89 c7             	mov    %rax,%rdi
  802b04:	ff d1                	callq  *%rcx
}
  802b06:	c9                   	leaveq 
  802b07:	c3                   	retq   

0000000000802b08 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b08:	55                   	push   %rbp
  802b09:	48 89 e5             	mov    %rsp,%rbp
  802b0c:	48 83 ec 20          	sub    $0x20,%rsp
  802b10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b1c:	be 00 00 00 00       	mov    $0x0,%esi
  802b21:	48 89 c7             	mov    %rax,%rdi
  802b24:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  802b2b:	00 00 00 
  802b2e:	ff d0                	callq  *%rax
  802b30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b37:	79 05                	jns    802b3e <stat+0x36>
		return fd;
  802b39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3c:	eb 2f                	jmp    802b6d <stat+0x65>
	r = fstat(fd, stat);
  802b3e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b45:	48 89 d6             	mov    %rdx,%rsi
  802b48:	89 c7                	mov    %eax,%edi
  802b4a:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  802b51:	00 00 00 
  802b54:	ff d0                	callq  *%rax
  802b56:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5c:	89 c7                	mov    %eax,%edi
  802b5e:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  802b65:	00 00 00 
  802b68:	ff d0                	callq  *%rax
	return r;
  802b6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b6d:	c9                   	leaveq 
  802b6e:	c3                   	retq   
	...

0000000000802b70 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b70:	55                   	push   %rbp
  802b71:	48 89 e5             	mov    %rsp,%rbp
  802b74:	48 83 ec 10          	sub    $0x10,%rsp
  802b78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b7f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b86:	00 00 00 
  802b89:	8b 00                	mov    (%rax),%eax
  802b8b:	85 c0                	test   %eax,%eax
  802b8d:	75 1d                	jne    802bac <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b8f:	bf 01 00 00 00       	mov    $0x1,%edi
  802b94:	48 b8 46 4a 80 00 00 	movabs $0x804a46,%rax
  802b9b:	00 00 00 
  802b9e:	ff d0                	callq  *%rax
  802ba0:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802ba7:	00 00 00 
  802baa:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802bac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bb3:	00 00 00 
  802bb6:	8b 00                	mov    (%rax),%eax
  802bb8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802bbb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802bc0:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  802bc7:	00 00 00 
  802bca:	89 c7                	mov    %eax,%edi
  802bcc:	48 b8 97 49 80 00 00 	movabs $0x804997,%rax
  802bd3:	00 00 00 
  802bd6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802bd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdc:	ba 00 00 00 00       	mov    $0x0,%edx
  802be1:	48 89 c6             	mov    %rax,%rsi
  802be4:	bf 00 00 00 00       	mov    $0x0,%edi
  802be9:	48 b8 b0 48 80 00 00 	movabs $0x8048b0,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
}
  802bf5:	c9                   	leaveq 
  802bf6:	c3                   	retq   

0000000000802bf7 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802bf7:	55                   	push   %rbp
  802bf8:	48 89 e5             	mov    %rsp,%rbp
  802bfb:	48 83 ec 20          	sub    $0x20,%rsp
  802bff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c03:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802c06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0a:	48 89 c7             	mov    %rax,%rdi
  802c0d:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  802c14:	00 00 00 
  802c17:	ff d0                	callq  *%rax
  802c19:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c1e:	7e 0a                	jle    802c2a <open+0x33>
		return -E_BAD_PATH;
  802c20:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c25:	e9 a5 00 00 00       	jmpq   802ccf <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802c2a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c2e:	48 89 c7             	mov    %rax,%rdi
  802c31:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  802c38:	00 00 00 
  802c3b:	ff d0                	callq  *%rax
  802c3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802c40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c44:	79 08                	jns    802c4e <open+0x57>
		return r;
  802c46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c49:	e9 81 00 00 00       	jmpq   802ccf <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  802c4e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802c55:	00 00 00 
  802c58:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802c5b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c65:	48 89 c6             	mov    %rax,%rsi
  802c68:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  802c6f:	00 00 00 
  802c72:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  802c79:	00 00 00 
  802c7c:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  802c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c82:	48 89 c6             	mov    %rax,%rsi
  802c85:	bf 01 00 00 00       	mov    $0x1,%edi
  802c8a:	48 b8 70 2b 80 00 00 	movabs $0x802b70,%rax
  802c91:	00 00 00 
  802c94:	ff d0                	callq  *%rax
  802c96:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802c99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c9d:	79 1d                	jns    802cbc <open+0xc5>
		fd_close(new_fd, 0);
  802c9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca3:	be 00 00 00 00       	mov    $0x0,%esi
  802ca8:	48 89 c7             	mov    %rax,%rdi
  802cab:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  802cb2:	00 00 00 
  802cb5:	ff d0                	callq  *%rax
		return r;	
  802cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cba:	eb 13                	jmp    802ccf <open+0xd8>
	}
	return fd2num(new_fd);
  802cbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc0:	48 89 c7             	mov    %rax,%rdi
  802cc3:	48 b8 00 22 80 00 00 	movabs $0x802200,%rax
  802cca:	00 00 00 
  802ccd:	ff d0                	callq  *%rax
}
  802ccf:	c9                   	leaveq 
  802cd0:	c3                   	retq   

0000000000802cd1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802cd1:	55                   	push   %rbp
  802cd2:	48 89 e5             	mov    %rsp,%rbp
  802cd5:	48 83 ec 10          	sub    $0x10,%rsp
  802cd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802cdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce1:	8b 50 0c             	mov    0xc(%rax),%edx
  802ce4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802ceb:	00 00 00 
  802cee:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802cf0:	be 00 00 00 00       	mov    $0x0,%esi
  802cf5:	bf 06 00 00 00       	mov    $0x6,%edi
  802cfa:	48 b8 70 2b 80 00 00 	movabs $0x802b70,%rax
  802d01:	00 00 00 
  802d04:	ff d0                	callq  *%rax
}
  802d06:	c9                   	leaveq 
  802d07:	c3                   	retq   

0000000000802d08 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d08:	55                   	push   %rbp
  802d09:	48 89 e5             	mov    %rsp,%rbp
  802d0c:	48 83 ec 30          	sub    $0x30,%rsp
  802d10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802d1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d20:	8b 50 0c             	mov    0xc(%rax),%edx
  802d23:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d2a:	00 00 00 
  802d2d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d2f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802d36:	00 00 00 
  802d39:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d3d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  802d41:	be 00 00 00 00       	mov    $0x0,%esi
  802d46:	bf 03 00 00 00       	mov    $0x3,%edi
  802d4b:	48 b8 70 2b 80 00 00 	movabs $0x802b70,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax
  802d57:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802d5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5e:	7e 23                	jle    802d83 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  802d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d63:	48 63 d0             	movslq %eax,%rdx
  802d66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d6a:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802d71:	00 00 00 
  802d74:	48 89 c7             	mov    %rax,%rdi
  802d77:	48 b8 9a 18 80 00 00 	movabs $0x80189a,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
	}
	return nbytes;
  802d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d86:	c9                   	leaveq 
  802d87:	c3                   	retq   

0000000000802d88 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d88:	55                   	push   %rbp
  802d89:	48 89 e5             	mov    %rsp,%rbp
  802d8c:	48 83 ec 20          	sub    $0x20,%rsp
  802d90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9c:	8b 50 0c             	mov    0xc(%rax),%edx
  802d9f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802da6:	00 00 00 
  802da9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802dab:	be 00 00 00 00       	mov    $0x0,%esi
  802db0:	bf 05 00 00 00       	mov    $0x5,%edi
  802db5:	48 b8 70 2b 80 00 00 	movabs $0x802b70,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	callq  *%rax
  802dc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc8:	79 05                	jns    802dcf <devfile_stat+0x47>
		return r;
  802dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcd:	eb 56                	jmp    802e25 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd3:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  802dda:	00 00 00 
  802ddd:	48 89 c7             	mov    %rax,%rdi
  802de0:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  802de7:	00 00 00 
  802dea:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802dec:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802df3:	00 00 00 
  802df6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802dfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e00:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e06:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  802e0d:	00 00 00 
  802e10:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e1a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e25:	c9                   	leaveq 
  802e26:	c3                   	retq   
	...

0000000000802e28 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802e28:	55                   	push   %rbp
  802e29:	48 89 e5             	mov    %rsp,%rbp
  802e2c:	53                   	push   %rbx
  802e2d:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  802e34:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  802e3b:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802e42:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  802e49:	be 00 00 00 00       	mov    $0x0,%esi
  802e4e:	48 89 c7             	mov    %rax,%rdi
  802e51:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  802e58:	00 00 00 
  802e5b:	ff d0                	callq  *%rax
  802e5d:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802e60:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802e64:	79 08                	jns    802e6e <spawn+0x46>
		return r;
  802e66:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e69:	e9 23 03 00 00       	jmpq   803191 <spawn+0x369>
	fd = r;
  802e6e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e71:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802e74:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  802e7b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802e7f:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  802e86:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e89:	ba 00 02 00 00       	mov    $0x200,%edx
  802e8e:	48 89 ce             	mov    %rcx,%rsi
  802e91:	89 c7                	mov    %eax,%edi
  802e93:	48 b8 f1 27 80 00 00 	movabs $0x8027f1,%rax
  802e9a:	00 00 00 
  802e9d:	ff d0                	callq  *%rax
  802e9f:	3d 00 02 00 00       	cmp    $0x200,%eax
  802ea4:	75 0d                	jne    802eb3 <spawn+0x8b>
            || elf->e_magic != ELF_MAGIC) {
  802ea6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802eaa:	8b 00                	mov    (%rax),%eax
  802eac:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802eb1:	74 43                	je     802ef6 <spawn+0xce>
		close(fd);
  802eb3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802eb6:	89 c7                	mov    %eax,%edi
  802eb8:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802ec4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ec8:	8b 00                	mov    (%rax),%eax
  802eca:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802ecf:	89 c6                	mov    %eax,%esi
  802ed1:	48 bf 78 52 80 00 00 	movabs $0x805278,%rdi
  802ed8:	00 00 00 
  802edb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee0:	48 b9 a7 09 80 00 00 	movabs $0x8009a7,%rcx
  802ee7:	00 00 00 
  802eea:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802eec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802ef1:	e9 9b 02 00 00       	jmpq   803191 <spawn+0x369>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802ef6:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  802efd:	00 00 00 
  802f00:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  802f06:	cd 30                	int    $0x30
  802f08:	89 c3                	mov    %eax,%ebx
  802f0a:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802f0d:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802f10:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802f13:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802f17:	79 08                	jns    802f21 <spawn+0xf9>
		return r;
  802f19:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f1c:	e9 70 02 00 00       	jmpq   803191 <spawn+0x369>
	child = r;
  802f21:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f24:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802f27:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802f2a:	25 ff 03 00 00       	and    $0x3ff,%eax
  802f2f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802f36:	00 00 00 
  802f39:	48 63 d0             	movslq %eax,%rdx
  802f3c:	48 89 d0             	mov    %rdx,%rax
  802f3f:	48 c1 e0 02          	shl    $0x2,%rax
  802f43:	48 01 d0             	add    %rdx,%rax
  802f46:	48 01 c0             	add    %rax,%rax
  802f49:	48 01 d0             	add    %rdx,%rax
  802f4c:	48 c1 e0 05          	shl    $0x5,%rax
  802f50:	48 01 c8             	add    %rcx,%rax
  802f53:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  802f5a:	48 89 c6             	mov    %rax,%rsi
  802f5d:	b8 18 00 00 00       	mov    $0x18,%eax
  802f62:	48 89 d7             	mov    %rdx,%rdi
  802f65:	48 89 c1             	mov    %rax,%rcx
  802f68:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802f6b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f6f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f73:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802f7a:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  802f81:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802f88:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  802f8f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802f92:	48 89 ce             	mov    %rcx,%rsi
  802f95:	89 c7                	mov    %eax,%edi
  802f97:	48 b8 e9 33 80 00 00 	movabs $0x8033e9,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
  802fa3:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802fa6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802faa:	79 08                	jns    802fb4 <spawn+0x18c>
		return r;
  802fac:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802faf:	e9 dd 01 00 00       	jmpq   803191 <spawn+0x369>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802fb4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802fb8:	48 8b 40 20          	mov    0x20(%rax),%rax
  802fbc:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  802fc3:	48 01 d0             	add    %rdx,%rax
  802fc6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802fca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802fd1:	eb 7a                	jmp    80304d <spawn+0x225>
		if (ph->p_type != ELF_PROG_LOAD)
  802fd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd7:	8b 00                	mov    (%rax),%eax
  802fd9:	83 f8 01             	cmp    $0x1,%eax
  802fdc:	75 65                	jne    803043 <spawn+0x21b>
			continue;
		perm = PTE_P | PTE_U;
  802fde:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802fe5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe9:	8b 40 04             	mov    0x4(%rax),%eax
  802fec:	83 e0 02             	and    $0x2,%eax
  802fef:	85 c0                	test   %eax,%eax
  802ff1:	74 04                	je     802ff7 <spawn+0x1cf>
			perm |= PTE_W;
  802ff3:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802ff7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ffb:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802fff:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803002:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803006:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80300a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80300e:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803012:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803016:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80301a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80301d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803020:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803023:	89 3c 24             	mov    %edi,(%rsp)
  803026:	89 c7                	mov    %eax,%edi
  803028:	48 b8 59 36 80 00 00 	movabs $0x803659,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803037:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80303b:	0f 88 2a 01 00 00    	js     80316b <spawn+0x343>
  803041:	eb 01                	jmp    803044 <spawn+0x21c>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  803043:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803044:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  803048:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  80304d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803051:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803055:	0f b7 c0             	movzwl %ax,%eax
  803058:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80305b:	0f 8f 72 ff ff ff    	jg     802fd3 <spawn+0x1ab>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803061:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803064:	89 c7                	mov    %eax,%edi
  803066:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
	fd = -1;
  803072:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803079:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80307c:	89 c7                	mov    %eax,%edi
  80307e:	48 b8 40 38 80 00 00 	movabs $0x803840,%rax
  803085:	00 00 00 
  803088:	ff d0                	callq  *%rax
  80308a:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80308d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803091:	79 30                	jns    8030c3 <spawn+0x29b>
		panic("copy_shared_pages: %e", r);
  803093:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803096:	89 c1                	mov    %eax,%ecx
  803098:	48 ba 92 52 80 00 00 	movabs $0x805292,%rdx
  80309f:	00 00 00 
  8030a2:	be 82 00 00 00       	mov    $0x82,%esi
  8030a7:	48 bf a8 52 80 00 00 	movabs $0x8052a8,%rdi
  8030ae:	00 00 00 
  8030b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b6:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  8030bd:	00 00 00 
  8030c0:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8030c3:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  8030ca:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8030cd:	48 89 d6             	mov    %rdx,%rsi
  8030d0:	89 c7                	mov    %eax,%edi
  8030d2:	48 b8 f0 1f 80 00 00 	movabs $0x801ff0,%rax
  8030d9:	00 00 00 
  8030dc:	ff d0                	callq  *%rax
  8030de:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8030e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8030e5:	79 30                	jns    803117 <spawn+0x2ef>
		panic("sys_env_set_trapframe: %e", r);
  8030e7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8030ea:	89 c1                	mov    %eax,%ecx
  8030ec:	48 ba b4 52 80 00 00 	movabs $0x8052b4,%rdx
  8030f3:	00 00 00 
  8030f6:	be 85 00 00 00       	mov    $0x85,%esi
  8030fb:	48 bf a8 52 80 00 00 	movabs $0x8052a8,%rdi
  803102:	00 00 00 
  803105:	b8 00 00 00 00       	mov    $0x0,%eax
  80310a:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  803111:	00 00 00 
  803114:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803117:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80311a:	be 02 00 00 00       	mov    $0x2,%esi
  80311f:	89 c7                	mov    %eax,%edi
  803121:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  803128:	00 00 00 
  80312b:	ff d0                	callq  *%rax
  80312d:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803130:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803134:	79 30                	jns    803166 <spawn+0x33e>
		panic("sys_env_set_status: %e", r);
  803136:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803139:	89 c1                	mov    %eax,%ecx
  80313b:	48 ba ce 52 80 00 00 	movabs $0x8052ce,%rdx
  803142:	00 00 00 
  803145:	be 88 00 00 00       	mov    $0x88,%esi
  80314a:	48 bf a8 52 80 00 00 	movabs $0x8052a8,%rdi
  803151:	00 00 00 
  803154:	b8 00 00 00 00       	mov    $0x0,%eax
  803159:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  803160:	00 00 00 
  803163:	41 ff d0             	callq  *%r8

	return child;
  803166:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803169:	eb 26                	jmp    803191 <spawn+0x369>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80316b:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  80316c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80316f:	89 c7                	mov    %eax,%edi
  803171:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  803178:	00 00 00 
  80317b:	ff d0                	callq  *%rax
	close(fd);
  80317d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803180:	89 c7                	mov    %eax,%edi
  803182:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  803189:	00 00 00 
  80318c:	ff d0                	callq  *%rax
	return r;
  80318e:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  803191:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  803198:	5b                   	pop    %rbx
  803199:	5d                   	pop    %rbp
  80319a:	c3                   	retq   

000000000080319b <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80319b:	55                   	push   %rbp
  80319c:	48 89 e5             	mov    %rsp,%rbp
  80319f:	53                   	push   %rbx
  8031a0:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  8031a7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8031ae:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  8031b5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8031bc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8031c3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8031ca:	84 c0                	test   %al,%al
  8031cc:	74 23                	je     8031f1 <spawnl+0x56>
  8031ce:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8031d5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8031d9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8031dd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8031e1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8031e5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8031e9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8031ed:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8031f1:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8031f8:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  8031ff:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803202:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  803209:	00 00 00 
  80320c:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  803213:	00 00 00 
  803216:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80321a:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  803221:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  803228:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80322f:	eb 07                	jmp    803238 <spawnl+0x9d>
		argc++;
  803231:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803238:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  80323e:	83 f8 30             	cmp    $0x30,%eax
  803241:	73 23                	jae    803266 <spawnl+0xcb>
  803243:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  80324a:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803250:	89 c0                	mov    %eax,%eax
  803252:	48 01 d0             	add    %rdx,%rax
  803255:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  80325b:	83 c2 08             	add    $0x8,%edx
  80325e:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  803264:	eb 15                	jmp    80327b <spawnl+0xe0>
  803266:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80326d:	48 89 d0             	mov    %rdx,%rax
  803270:	48 83 c2 08          	add    $0x8,%rdx
  803274:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  80327b:	48 8b 00             	mov    (%rax),%rax
  80327e:	48 85 c0             	test   %rax,%rax
  803281:	75 ae                	jne    803231 <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803283:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803289:	83 c0 02             	add    $0x2,%eax
  80328c:	48 89 e2             	mov    %rsp,%rdx
  80328f:	48 89 d3             	mov    %rdx,%rbx
  803292:	48 63 d0             	movslq %eax,%rdx
  803295:	48 83 ea 01          	sub    $0x1,%rdx
  803299:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  8032a0:	48 98                	cltq   
  8032a2:	48 c1 e0 03          	shl    $0x3,%rax
  8032a6:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  8032aa:	b8 10 00 00 00       	mov    $0x10,%eax
  8032af:	48 83 e8 01          	sub    $0x1,%rax
  8032b3:	48 01 d0             	add    %rdx,%rax
  8032b6:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  8032bd:	10 00 00 00 
  8032c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8032c6:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  8032cd:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8032d1:	48 29 c4             	sub    %rax,%rsp
  8032d4:	48 89 e0             	mov    %rsp,%rax
  8032d7:	48 83 c0 0f          	add    $0xf,%rax
  8032db:	48 c1 e8 04          	shr    $0x4,%rax
  8032df:	48 c1 e0 04          	shl    $0x4,%rax
  8032e3:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  8032ea:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8032f1:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  8032f8:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8032fb:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803301:	8d 50 01             	lea    0x1(%rax),%edx
  803304:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80330b:	48 63 d2             	movslq %edx,%rdx
  80330e:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803315:	00 

	va_start(vl, arg0);
  803316:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  80331d:	00 00 00 
  803320:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  803327:	00 00 00 
  80332a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80332e:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  803335:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  80333c:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803343:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  80334a:	00 00 00 
  80334d:	eb 63                	jmp    8033b2 <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  80334f:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  803355:	8d 70 01             	lea    0x1(%rax),%esi
  803358:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  80335e:	83 f8 30             	cmp    $0x30,%eax
  803361:	73 23                	jae    803386 <spawnl+0x1eb>
  803363:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  80336a:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803370:	89 c0                	mov    %eax,%eax
  803372:	48 01 d0             	add    %rdx,%rax
  803375:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  80337b:	83 c2 08             	add    $0x8,%edx
  80337e:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  803384:	eb 15                	jmp    80339b <spawnl+0x200>
  803386:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80338d:	48 89 d0             	mov    %rdx,%rax
  803390:	48 83 c2 08          	add    $0x8,%rdx
  803394:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  80339b:	48 8b 08             	mov    (%rax),%rcx
  80339e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8033a5:	89 f2                	mov    %esi,%edx
  8033a7:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8033ab:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  8033b2:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  8033b8:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  8033be:	77 8f                	ja     80334f <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8033c0:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  8033c7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8033ce:	48 89 d6             	mov    %rdx,%rsi
  8033d1:	48 89 c7             	mov    %rax,%rdi
  8033d4:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  8033db:	00 00 00 
  8033de:	ff d0                	callq  *%rax
  8033e0:	48 89 dc             	mov    %rbx,%rsp
}
  8033e3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8033e7:	c9                   	leaveq 
  8033e8:	c3                   	retq   

00000000008033e9 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8033e9:	55                   	push   %rbp
  8033ea:	48 89 e5             	mov    %rsp,%rbp
  8033ed:	48 83 ec 50          	sub    $0x50,%rsp
  8033f1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8033f4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8033f8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8033fc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803403:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80340b:	eb 2c                	jmp    803439 <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  80340d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803410:	48 98                	cltq   
  803412:	48 c1 e0 03          	shl    $0x3,%rax
  803416:	48 03 45 c0          	add    -0x40(%rbp),%rax
  80341a:	48 8b 00             	mov    (%rax),%rax
  80341d:	48 89 c7             	mov    %rax,%rdi
  803420:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	83 c0 01             	add    $0x1,%eax
  80342f:	48 98                	cltq   
  803431:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803435:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803439:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80343c:	48 98                	cltq   
  80343e:	48 c1 e0 03          	shl    $0x3,%rax
  803442:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803446:	48 8b 00             	mov    (%rax),%rax
  803449:	48 85 c0             	test   %rax,%rax
  80344c:	75 bf                	jne    80340d <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80344e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803452:	48 f7 d8             	neg    %rax
  803455:	48 05 00 10 40 00    	add    $0x401000,%rax
  80345b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80345f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803463:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80346b:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80346f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803472:	83 c2 01             	add    $0x1,%edx
  803475:	c1 e2 03             	shl    $0x3,%edx
  803478:	48 63 d2             	movslq %edx,%rdx
  80347b:	48 f7 da             	neg    %rdx
  80347e:	48 01 d0             	add    %rdx,%rax
  803481:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803485:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803489:	48 83 e8 10          	sub    $0x10,%rax
  80348d:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803493:	77 0a                	ja     80349f <init_stack+0xb6>
		return -E_NO_MEM;
  803495:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80349a:	e9 b8 01 00 00       	jmpq   803657 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80349f:	ba 07 00 00 00       	mov    $0x7,%edx
  8034a4:	be 00 00 40 00       	mov    $0x400000,%esi
  8034a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ae:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  8034b5:	00 00 00 
  8034b8:	ff d0                	callq  *%rax
  8034ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034c1:	79 08                	jns    8034cb <init_stack+0xe2>
		return r;
  8034c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c6:	e9 8c 01 00 00       	jmpq   803657 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8034cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8034d2:	eb 73                	jmp    803547 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  8034d4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034d7:	48 98                	cltq   
  8034d9:	48 c1 e0 03          	shl    $0x3,%rax
  8034dd:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8034e1:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  8034e6:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  8034ea:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8034f1:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  8034f4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034f7:	48 98                	cltq   
  8034f9:	48 c1 e0 03          	shl    $0x3,%rax
  8034fd:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803501:	48 8b 10             	mov    (%rax),%rdx
  803504:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803508:	48 89 d6             	mov    %rdx,%rsi
  80350b:	48 89 c7             	mov    %rax,%rdi
  80350e:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80351a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80351d:	48 98                	cltq   
  80351f:	48 c1 e0 03          	shl    $0x3,%rax
  803523:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803527:	48 8b 00             	mov    (%rax),%rax
  80352a:	48 89 c7             	mov    %rax,%rdi
  80352d:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  803534:	00 00 00 
  803537:	ff d0                	callq  *%rax
  803539:	48 98                	cltq   
  80353b:	48 83 c0 01          	add    $0x1,%rax
  80353f:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803543:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803547:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80354a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80354d:	7c 85                	jl     8034d4 <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80354f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803552:	48 98                	cltq   
  803554:	48 c1 e0 03          	shl    $0x3,%rax
  803558:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80355c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803563:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80356a:	00 
  80356b:	74 35                	je     8035a2 <init_stack+0x1b9>
  80356d:	48 b9 e8 52 80 00 00 	movabs $0x8052e8,%rcx
  803574:	00 00 00 
  803577:	48 ba 0e 53 80 00 00 	movabs $0x80530e,%rdx
  80357e:	00 00 00 
  803581:	be f1 00 00 00       	mov    $0xf1,%esi
  803586:	48 bf a8 52 80 00 00 	movabs $0x8052a8,%rdi
  80358d:	00 00 00 
  803590:	b8 00 00 00 00       	mov    $0x0,%eax
  803595:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  80359c:	00 00 00 
  80359f:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8035a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035a6:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8035aa:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8035af:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8035b3:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8035b9:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8035bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035c0:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8035c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035c7:	48 98                	cltq   
  8035c9:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8035cc:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  8035d1:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8035d5:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8035db:	48 89 c2             	mov    %rax,%rdx
  8035de:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8035e2:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8035e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8035e8:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8035ee:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8035f3:	89 c2                	mov    %eax,%edx
  8035f5:	be 00 00 40 00       	mov    $0x400000,%esi
  8035fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ff:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  803606:	00 00 00 
  803609:	ff d0                	callq  *%rax
  80360b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80360e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803612:	78 26                	js     80363a <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803614:	be 00 00 40 00       	mov    $0x400000,%esi
  803619:	bf 00 00 00 00       	mov    $0x0,%edi
  80361e:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  803625:	00 00 00 
  803628:	ff d0                	callq  *%rax
  80362a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80362d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803631:	78 0a                	js     80363d <init_stack+0x254>
		goto error;

	return 0;
  803633:	b8 00 00 00 00       	mov    $0x0,%eax
  803638:	eb 1d                	jmp    803657 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  80363a:	90                   	nop
  80363b:	eb 01                	jmp    80363e <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  80363d:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80363e:	be 00 00 40 00       	mov    $0x400000,%esi
  803643:	bf 00 00 00 00       	mov    $0x0,%edi
  803648:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  80364f:	00 00 00 
  803652:	ff d0                	callq  *%rax
	return r;
  803654:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803657:	c9                   	leaveq 
  803658:	c3                   	retq   

0000000000803659 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803659:	55                   	push   %rbp
  80365a:	48 89 e5             	mov    %rsp,%rbp
  80365d:	48 83 ec 50          	sub    $0x50,%rsp
  803661:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803664:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803668:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80366c:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80366f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803673:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803677:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367b:	25 ff 0f 00 00       	and    $0xfff,%eax
  803680:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803683:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803687:	74 21                	je     8036aa <map_segment+0x51>
		va -= i;
  803689:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368c:	48 98                	cltq   
  80368e:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803692:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803695:	48 98                	cltq   
  803697:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80369b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369e:	48 98                	cltq   
  8036a0:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8036a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a7:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8036aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036b1:	e9 74 01 00 00       	jmpq   80382a <map_segment+0x1d1>
		if (i >= filesz) {
  8036b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b9:	48 98                	cltq   
  8036bb:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8036bf:	72 38                	jb     8036f9 <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8036c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c4:	48 98                	cltq   
  8036c6:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8036ca:	48 89 c1             	mov    %rax,%rcx
  8036cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036d0:	8b 55 10             	mov    0x10(%rbp),%edx
  8036d3:	48 89 ce             	mov    %rcx,%rsi
  8036d6:	89 c7                	mov    %eax,%edi
  8036d8:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  8036df:	00 00 00 
  8036e2:	ff d0                	callq  *%rax
  8036e4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036eb:	0f 89 32 01 00 00    	jns    803823 <map_segment+0x1ca>
				return r;
  8036f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036f4:	e9 45 01 00 00       	jmpq   80383e <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8036f9:	ba 07 00 00 00       	mov    $0x7,%edx
  8036fe:	be 00 00 40 00       	mov    $0x400000,%esi
  803703:	bf 00 00 00 00       	mov    $0x0,%edi
  803708:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  80370f:	00 00 00 
  803712:	ff d0                	callq  *%rax
  803714:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803717:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80371b:	79 08                	jns    803725 <map_segment+0xcc>
				return r;
  80371d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803720:	e9 19 01 00 00       	jmpq   80383e <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803728:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80372b:	01 c2                	add    %eax,%edx
  80372d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803730:	89 d6                	mov    %edx,%esi
  803732:	89 c7                	mov    %eax,%edi
  803734:	48 b8 3e 29 80 00 00 	movabs $0x80293e,%rax
  80373b:	00 00 00 
  80373e:	ff d0                	callq  *%rax
  803740:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803743:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803747:	79 08                	jns    803751 <map_segment+0xf8>
				return r;
  803749:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80374c:	e9 ed 00 00 00       	jmpq   80383e <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803751:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803758:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375b:	48 98                	cltq   
  80375d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803761:	48 89 d1             	mov    %rdx,%rcx
  803764:	48 29 c1             	sub    %rax,%rcx
  803767:	48 89 c8             	mov    %rcx,%rax
  80376a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80376e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803771:	48 63 d0             	movslq %eax,%rdx
  803774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803778:	48 39 c2             	cmp    %rax,%rdx
  80377b:	48 0f 47 d0          	cmova  %rax,%rdx
  80377f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803782:	be 00 00 40 00       	mov    $0x400000,%esi
  803787:	89 c7                	mov    %eax,%edi
  803789:	48 b8 f1 27 80 00 00 	movabs $0x8027f1,%rax
  803790:	00 00 00 
  803793:	ff d0                	callq  *%rax
  803795:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803798:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80379c:	79 08                	jns    8037a6 <map_segment+0x14d>
				return r;
  80379e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037a1:	e9 98 00 00 00       	jmpq   80383e <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8037a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a9:	48 98                	cltq   
  8037ab:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8037af:	48 89 c2             	mov    %rax,%rdx
  8037b2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037b5:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8037b9:	48 89 d1             	mov    %rdx,%rcx
  8037bc:	89 c2                	mov    %eax,%edx
  8037be:	be 00 00 40 00       	mov    $0x400000,%esi
  8037c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c8:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  8037cf:	00 00 00 
  8037d2:	ff d0                	callq  *%rax
  8037d4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8037d7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8037db:	79 30                	jns    80380d <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  8037dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037e0:	89 c1                	mov    %eax,%ecx
  8037e2:	48 ba 23 53 80 00 00 	movabs $0x805323,%rdx
  8037e9:	00 00 00 
  8037ec:	be 24 01 00 00       	mov    $0x124,%esi
  8037f1:	48 bf a8 52 80 00 00 	movabs $0x8052a8,%rdi
  8037f8:	00 00 00 
  8037fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803800:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  803807:	00 00 00 
  80380a:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80380d:	be 00 00 40 00       	mov    $0x400000,%esi
  803812:	bf 00 00 00 00       	mov    $0x0,%edi
  803817:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  80381e:	00 00 00 
  803821:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803823:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80382a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382d:	48 98                	cltq   
  80382f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803833:	0f 82 7d fe ff ff    	jb     8036b6 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80383e:	c9                   	leaveq 
  80383f:	c3                   	retq   

0000000000803840 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803840:	55                   	push   %rbp
  803841:	48 89 e5             	mov    %rsp,%rbp
  803844:	48 83 ec 60          	sub    $0x60,%rsp
  803848:	89 7d ac             	mov    %edi,-0x54(%rbp)
	// LAB 5: Your code here.
	int r = 0;
  80384b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
 	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
  803852:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803859:	00 
    uint64_t each_pte = 0;
  80385a:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803861:	00 
    uint64_t each_pdpe = 0;
  803862:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803869:	00 
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  80386a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803871:	00 
  803872:	e9 a5 01 00 00       	jmpq   803a1c <copy_shared_pages+0x1dc>
        if(uvpml4e[pml] & PTE_P) {
  803877:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80387e:	01 00 00 
  803881:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803885:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803889:	83 e0 01             	and    $0x1,%eax
  80388c:	84 c0                	test   %al,%al
  80388e:	0f 84 73 01 00 00    	je     803a07 <copy_shared_pages+0x1c7>

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  803894:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80389b:	00 
  80389c:	e9 56 01 00 00       	jmpq   8039f7 <copy_shared_pages+0x1b7>
                if(uvpde[each_pdpe] & PTE_P) {
  8038a1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8038a8:	01 00 00 
  8038ab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8038af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038b3:	83 e0 01             	and    $0x1,%eax
  8038b6:	84 c0                	test   %al,%al
  8038b8:	0f 84 1f 01 00 00    	je     8039dd <copy_shared_pages+0x19d>

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8038be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8038c5:	00 
  8038c6:	e9 02 01 00 00       	jmpq   8039cd <copy_shared_pages+0x18d>
                        if(uvpd[each_pde] & PTE_P) {
  8038cb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038d2:	01 00 00 
  8038d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038dd:	83 e0 01             	and    $0x1,%eax
  8038e0:	84 c0                	test   %al,%al
  8038e2:	0f 84 cb 00 00 00    	je     8039b3 <copy_shared_pages+0x173>

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8038e8:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8038ef:	00 
  8038f0:	e9 ae 00 00 00       	jmpq   8039a3 <copy_shared_pages+0x163>
                                if(uvpt[each_pte] & PTE_SHARE) {
  8038f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038fc:	01 00 00 
  8038ff:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803903:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803907:	25 00 04 00 00       	and    $0x400,%eax
  80390c:	48 85 c0             	test   %rax,%rax
  80390f:	0f 84 84 00 00 00    	je     803999 <copy_shared_pages+0x159>
				
									int perm = uvpt[each_pte] & PTE_SYSCALL;
  803915:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80391c:	01 00 00 
  80391f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803923:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803927:	25 07 0e 00 00       	and    $0xe07,%eax
  80392c:	89 45 c0             	mov    %eax,-0x40(%rbp)
									void* addr = (void*) (each_pte * PGSIZE);
  80392f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803933:	48 c1 e0 0c          	shl    $0xc,%rax
  803937:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
									r = sys_page_map(0, addr, child, addr, perm);
  80393b:	8b 75 c0             	mov    -0x40(%rbp),%esi
  80393e:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  803942:	8b 55 ac             	mov    -0x54(%rbp),%edx
  803945:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803949:	41 89 f0             	mov    %esi,%r8d
  80394c:	48 89 c6             	mov    %rax,%rsi
  80394f:	bf 00 00 00 00       	mov    $0x0,%edi
  803954:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  80395b:	00 00 00 
  80395e:	ff d0                	callq  *%rax
  803960:	89 45 c4             	mov    %eax,-0x3c(%rbp)
                                    if (r < 0)
  803963:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803967:	79 30                	jns    803999 <copy_shared_pages+0x159>
                             	       panic("\n couldn't call fork %e\n", r);
  803969:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80396c:	89 c1                	mov    %eax,%ecx
  80396e:	48 ba 40 53 80 00 00 	movabs $0x805340,%rdx
  803975:	00 00 00 
  803978:	be 48 01 00 00       	mov    $0x148,%esi
  80397d:	48 bf a8 52 80 00 00 	movabs $0x8052a8,%rdi
  803984:	00 00 00 
  803987:	b8 00 00 00 00       	mov    $0x0,%eax
  80398c:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  803993:	00 00 00 
  803996:	41 ff d0             	callq  *%r8
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
                        if(uvpd[each_pde] & PTE_P) {

                            for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  803999:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80399e:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8039a3:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8039aa:	00 
  8039ab:	0f 86 44 ff ff ff    	jbe    8038f5 <copy_shared_pages+0xb5>
  8039b1:	eb 10                	jmp    8039c3 <copy_shared_pages+0x183>
                             	       panic("\n couldn't call fork %e\n", r);
                                }
                            }
                        }
          				else {
                            each_pte = (each_pde+1)*NPTENTRIES;
  8039b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b7:	48 83 c0 01          	add    $0x1,%rax
  8039bb:	48 c1 e0 09          	shl    $0x9,%rax
  8039bf:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
                if(uvpde[each_pdpe] & PTE_P) {

                    for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  8039c3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8039c8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8039cd:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  8039d4:	00 
  8039d5:	0f 86 f0 fe ff ff    	jbe    8038cb <copy_shared_pages+0x8b>
  8039db:	eb 10                	jmp    8039ed <copy_shared_pages+0x1ad>
                        }
                    }

                }
                else {
                    each_pde = (each_pdpe+1)* NPDENTRIES;
  8039dd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039e1:	48 83 c0 01          	add    $0x1,%rax
  8039e5:	48 c1 e0 09          	shl    $0x9,%rax
  8039e9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
        if(uvpml4e[pml] & PTE_P) {

            for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  8039ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  8039f2:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8039f7:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  8039fe:	00 
  8039ff:	0f 86 9c fe ff ff    	jbe    8038a1 <copy_shared_pages+0x61>
  803a05:	eb 10                	jmp    803a17 <copy_shared_pages+0x1d7>
                }

            }
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
  803a07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a0b:	48 83 c0 01          	add    $0x1,%rax
  803a0f:	48 c1 e0 09          	shl    $0x9,%rax
  803a13:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t pde;
    uint64_t pte;
    uint64_t each_pde = 0;
    uint64_t each_pte = 0;
    uint64_t each_pdpe = 0;
    for(pml = 0; pml < VPML4E(UTOP); pml++) {
  803a17:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a1c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a21:	0f 84 50 fe ff ff    	je     803877 <copy_shared_pages+0x37>
        }
        else {
            each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}
	return 0;
  803a27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a2c:	c9                   	leaveq 
  803a2d:	c3                   	retq   
	...

0000000000803a30 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803a30:	55                   	push   %rbp
  803a31:	48 89 e5             	mov    %rsp,%rbp
  803a34:	48 83 ec 20          	sub    $0x20,%rsp
  803a38:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803a3b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a42:	48 89 d6             	mov    %rdx,%rsi
  803a45:	89 c7                	mov    %eax,%edi
  803a47:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  803a4e:	00 00 00 
  803a51:	ff d0                	callq  *%rax
  803a53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a5a:	79 05                	jns    803a61 <fd2sockid+0x31>
		return r;
  803a5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5f:	eb 24                	jmp    803a85 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803a61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a65:	8b 10                	mov    (%rax),%edx
  803a67:	48 b8 40 88 80 00 00 	movabs $0x808840,%rax
  803a6e:	00 00 00 
  803a71:	8b 00                	mov    (%rax),%eax
  803a73:	39 c2                	cmp    %eax,%edx
  803a75:	74 07                	je     803a7e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803a77:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803a7c:	eb 07                	jmp    803a85 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803a7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a82:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803a85:	c9                   	leaveq 
  803a86:	c3                   	retq   

0000000000803a87 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803a87:	55                   	push   %rbp
  803a88:	48 89 e5             	mov    %rsp,%rbp
  803a8b:	48 83 ec 20          	sub    $0x20,%rsp
  803a8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803a92:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803a96:	48 89 c7             	mov    %rax,%rdi
  803a99:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  803aa0:	00 00 00 
  803aa3:	ff d0                	callq  *%rax
  803aa5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aac:	78 26                	js     803ad4 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803aae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab2:	ba 07 04 00 00       	mov    $0x407,%edx
  803ab7:	48 89 c6             	mov    %rax,%rsi
  803aba:	bf 00 00 00 00       	mov    $0x0,%edi
  803abf:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  803ac6:	00 00 00 
  803ac9:	ff d0                	callq  *%rax
  803acb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ace:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad2:	79 16                	jns    803aea <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803ad4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ad7:	89 c7                	mov    %eax,%edi
  803ad9:	48 b8 94 3f 80 00 00 	movabs $0x803f94,%rax
  803ae0:	00 00 00 
  803ae3:	ff d0                	callq  *%rax
		return r;
  803ae5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae8:	eb 3a                	jmp    803b24 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803aea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aee:	48 ba 40 88 80 00 00 	movabs $0x808840,%rdx
  803af5:	00 00 00 
  803af8:	8b 12                	mov    (%rdx),%edx
  803afa:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803afc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b00:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803b07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b0e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803b11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b15:	48 89 c7             	mov    %rax,%rdi
  803b18:	48 b8 00 22 80 00 00 	movabs $0x802200,%rax
  803b1f:	00 00 00 
  803b22:	ff d0                	callq  *%rax
}
  803b24:	c9                   	leaveq 
  803b25:	c3                   	retq   

0000000000803b26 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b26:	55                   	push   %rbp
  803b27:	48 89 e5             	mov    %rsp,%rbp
  803b2a:	48 83 ec 30          	sub    $0x30,%rsp
  803b2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b35:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b3c:	89 c7                	mov    %eax,%edi
  803b3e:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803b45:	00 00 00 
  803b48:	ff d0                	callq  *%rax
  803b4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b51:	79 05                	jns    803b58 <accept+0x32>
		return r;
  803b53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b56:	eb 3b                	jmp    803b93 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803b58:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b5c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803b60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b63:	48 89 ce             	mov    %rcx,%rsi
  803b66:	89 c7                	mov    %eax,%edi
  803b68:	48 b8 71 3e 80 00 00 	movabs $0x803e71,%rax
  803b6f:	00 00 00 
  803b72:	ff d0                	callq  *%rax
  803b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b7b:	79 05                	jns    803b82 <accept+0x5c>
		return r;
  803b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b80:	eb 11                	jmp    803b93 <accept+0x6d>
	return alloc_sockfd(r);
  803b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b85:	89 c7                	mov    %eax,%edi
  803b87:	48 b8 87 3a 80 00 00 	movabs $0x803a87,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
}
  803b93:	c9                   	leaveq 
  803b94:	c3                   	retq   

0000000000803b95 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b95:	55                   	push   %rbp
  803b96:	48 89 e5             	mov    %rsp,%rbp
  803b99:	48 83 ec 20          	sub    $0x20,%rsp
  803b9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ba0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ba4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ba7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803baa:	89 c7                	mov    %eax,%edi
  803bac:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803bb3:	00 00 00 
  803bb6:	ff d0                	callq  *%rax
  803bb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bbf:	79 05                	jns    803bc6 <bind+0x31>
		return r;
  803bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc4:	eb 1b                	jmp    803be1 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803bc6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803bc9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803bcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd0:	48 89 ce             	mov    %rcx,%rsi
  803bd3:	89 c7                	mov    %eax,%edi
  803bd5:	48 b8 f0 3e 80 00 00 	movabs $0x803ef0,%rax
  803bdc:	00 00 00 
  803bdf:	ff d0                	callq  *%rax
}
  803be1:	c9                   	leaveq 
  803be2:	c3                   	retq   

0000000000803be3 <shutdown>:

int
shutdown(int s, int how)
{
  803be3:	55                   	push   %rbp
  803be4:	48 89 e5             	mov    %rsp,%rbp
  803be7:	48 83 ec 20          	sub    $0x20,%rsp
  803beb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bee:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bf1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bf4:	89 c7                	mov    %eax,%edi
  803bf6:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803bfd:	00 00 00 
  803c00:	ff d0                	callq  *%rax
  803c02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c09:	79 05                	jns    803c10 <shutdown+0x2d>
		return r;
  803c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c0e:	eb 16                	jmp    803c26 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803c10:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c16:	89 d6                	mov    %edx,%esi
  803c18:	89 c7                	mov    %eax,%edi
  803c1a:	48 b8 54 3f 80 00 00 	movabs $0x803f54,%rax
  803c21:	00 00 00 
  803c24:	ff d0                	callq  *%rax
}
  803c26:	c9                   	leaveq 
  803c27:	c3                   	retq   

0000000000803c28 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803c28:	55                   	push   %rbp
  803c29:	48 89 e5             	mov    %rsp,%rbp
  803c2c:	48 83 ec 10          	sub    $0x10,%rsp
  803c30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803c34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c38:	48 89 c7             	mov    %rax,%rdi
  803c3b:	48 b8 d4 4a 80 00 00 	movabs $0x804ad4,%rax
  803c42:	00 00 00 
  803c45:	ff d0                	callq  *%rax
  803c47:	83 f8 01             	cmp    $0x1,%eax
  803c4a:	75 17                	jne    803c63 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803c4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c50:	8b 40 0c             	mov    0xc(%rax),%eax
  803c53:	89 c7                	mov    %eax,%edi
  803c55:	48 b8 94 3f 80 00 00 	movabs $0x803f94,%rax
  803c5c:	00 00 00 
  803c5f:	ff d0                	callq  *%rax
  803c61:	eb 05                	jmp    803c68 <devsock_close+0x40>
	else
		return 0;
  803c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c68:	c9                   	leaveq 
  803c69:	c3                   	retq   

0000000000803c6a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c6a:	55                   	push   %rbp
  803c6b:	48 89 e5             	mov    %rsp,%rbp
  803c6e:	48 83 ec 20          	sub    $0x20,%rsp
  803c72:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c79:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c7f:	89 c7                	mov    %eax,%edi
  803c81:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803c88:	00 00 00 
  803c8b:	ff d0                	callq  *%rax
  803c8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c94:	79 05                	jns    803c9b <connect+0x31>
		return r;
  803c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c99:	eb 1b                	jmp    803cb6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803c9b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c9e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ca2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca5:	48 89 ce             	mov    %rcx,%rsi
  803ca8:	89 c7                	mov    %eax,%edi
  803caa:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  803cb1:	00 00 00 
  803cb4:	ff d0                	callq  *%rax
}
  803cb6:	c9                   	leaveq 
  803cb7:	c3                   	retq   

0000000000803cb8 <listen>:

int
listen(int s, int backlog)
{
  803cb8:	55                   	push   %rbp
  803cb9:	48 89 e5             	mov    %rsp,%rbp
  803cbc:	48 83 ec 20          	sub    $0x20,%rsp
  803cc0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cc3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803cc6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cc9:	89 c7                	mov    %eax,%edi
  803ccb:	48 b8 30 3a 80 00 00 	movabs $0x803a30,%rax
  803cd2:	00 00 00 
  803cd5:	ff d0                	callq  *%rax
  803cd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cde:	79 05                	jns    803ce5 <listen+0x2d>
		return r;
  803ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce3:	eb 16                	jmp    803cfb <listen+0x43>
	return nsipc_listen(r, backlog);
  803ce5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ceb:	89 d6                	mov    %edx,%esi
  803ced:	89 c7                	mov    %eax,%edi
  803cef:	48 b8 25 40 80 00 00 	movabs $0x804025,%rax
  803cf6:	00 00 00 
  803cf9:	ff d0                	callq  *%rax
}
  803cfb:	c9                   	leaveq 
  803cfc:	c3                   	retq   

0000000000803cfd <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803cfd:	55                   	push   %rbp
  803cfe:	48 89 e5             	mov    %rsp,%rbp
  803d01:	48 83 ec 20          	sub    $0x20,%rsp
  803d05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d0d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803d11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d15:	89 c2                	mov    %eax,%edx
  803d17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d1b:	8b 40 0c             	mov    0xc(%rax),%eax
  803d1e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803d22:	b9 00 00 00 00       	mov    $0x0,%ecx
  803d27:	89 c7                	mov    %eax,%edi
  803d29:	48 b8 65 40 80 00 00 	movabs $0x804065,%rax
  803d30:	00 00 00 
  803d33:	ff d0                	callq  *%rax
}
  803d35:	c9                   	leaveq 
  803d36:	c3                   	retq   

0000000000803d37 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803d37:	55                   	push   %rbp
  803d38:	48 89 e5             	mov    %rsp,%rbp
  803d3b:	48 83 ec 20          	sub    $0x20,%rsp
  803d3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d47:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803d4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d4f:	89 c2                	mov    %eax,%edx
  803d51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d55:	8b 40 0c             	mov    0xc(%rax),%eax
  803d58:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803d5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803d61:	89 c7                	mov    %eax,%edi
  803d63:	48 b8 31 41 80 00 00 	movabs $0x804131,%rax
  803d6a:	00 00 00 
  803d6d:	ff d0                	callq  *%rax
}
  803d6f:	c9                   	leaveq 
  803d70:	c3                   	retq   

0000000000803d71 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803d71:	55                   	push   %rbp
  803d72:	48 89 e5             	mov    %rsp,%rbp
  803d75:	48 83 ec 10          	sub    $0x10,%rsp
  803d79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d85:	48 be 5e 53 80 00 00 	movabs $0x80535e,%rsi
  803d8c:	00 00 00 
  803d8f:	48 89 c7             	mov    %rax,%rdi
  803d92:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  803d99:	00 00 00 
  803d9c:	ff d0                	callq  *%rax
	return 0;
  803d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803da3:	c9                   	leaveq 
  803da4:	c3                   	retq   

0000000000803da5 <socket>:

int
socket(int domain, int type, int protocol)
{
  803da5:	55                   	push   %rbp
  803da6:	48 89 e5             	mov    %rsp,%rbp
  803da9:	48 83 ec 20          	sub    $0x20,%rsp
  803dad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803db0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803db3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803db6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803db9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803dbc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dbf:	89 ce                	mov    %ecx,%esi
  803dc1:	89 c7                	mov    %eax,%edi
  803dc3:	48 b8 e9 41 80 00 00 	movabs $0x8041e9,%rax
  803dca:	00 00 00 
  803dcd:	ff d0                	callq  *%rax
  803dcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd6:	79 05                	jns    803ddd <socket+0x38>
		return r;
  803dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ddb:	eb 11                	jmp    803dee <socket+0x49>
	return alloc_sockfd(r);
  803ddd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de0:	89 c7                	mov    %eax,%edi
  803de2:	48 b8 87 3a 80 00 00 	movabs $0x803a87,%rax
  803de9:	00 00 00 
  803dec:	ff d0                	callq  *%rax
}
  803dee:	c9                   	leaveq 
  803def:	c3                   	retq   

0000000000803df0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803df0:	55                   	push   %rbp
  803df1:	48 89 e5             	mov    %rsp,%rbp
  803df4:	48 83 ec 10          	sub    $0x10,%rsp
  803df8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803dfb:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803e02:	00 00 00 
  803e05:	8b 00                	mov    (%rax),%eax
  803e07:	85 c0                	test   %eax,%eax
  803e09:	75 1d                	jne    803e28 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803e0b:	bf 02 00 00 00       	mov    $0x2,%edi
  803e10:	48 b8 46 4a 80 00 00 	movabs $0x804a46,%rax
  803e17:	00 00 00 
  803e1a:	ff d0                	callq  *%rax
  803e1c:	48 ba 04 90 80 00 00 	movabs $0x809004,%rdx
  803e23:	00 00 00 
  803e26:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803e28:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803e2f:	00 00 00 
  803e32:	8b 00                	mov    (%rax),%eax
  803e34:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803e37:	b9 07 00 00 00       	mov    $0x7,%ecx
  803e3c:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  803e43:	00 00 00 
  803e46:	89 c7                	mov    %eax,%edi
  803e48:	48 b8 97 49 80 00 00 	movabs $0x804997,%rax
  803e4f:	00 00 00 
  803e52:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803e54:	ba 00 00 00 00       	mov    $0x0,%edx
  803e59:	be 00 00 00 00       	mov    $0x0,%esi
  803e5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e63:	48 b8 b0 48 80 00 00 	movabs $0x8048b0,%rax
  803e6a:	00 00 00 
  803e6d:	ff d0                	callq  *%rax
}
  803e6f:	c9                   	leaveq 
  803e70:	c3                   	retq   

0000000000803e71 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803e71:	55                   	push   %rbp
  803e72:	48 89 e5             	mov    %rsp,%rbp
  803e75:	48 83 ec 30          	sub    $0x30,%rsp
  803e79:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e80:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803e84:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803e8b:	00 00 00 
  803e8e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e91:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803e93:	bf 01 00 00 00       	mov    $0x1,%edi
  803e98:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  803e9f:	00 00 00 
  803ea2:	ff d0                	callq  *%rax
  803ea4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ea7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eab:	78 3e                	js     803eeb <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803ead:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803eb4:	00 00 00 
  803eb7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803ebb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ebf:	8b 40 10             	mov    0x10(%rax),%eax
  803ec2:	89 c2                	mov    %eax,%edx
  803ec4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803ec8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ecc:	48 89 ce             	mov    %rcx,%rsi
  803ecf:	48 89 c7             	mov    %rax,%rdi
  803ed2:	48 b8 9a 18 80 00 00 	movabs $0x80189a,%rax
  803ed9:	00 00 00 
  803edc:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803ede:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee2:	8b 50 10             	mov    0x10(%rax),%edx
  803ee5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ee9:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803eeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803eee:	c9                   	leaveq 
  803eef:	c3                   	retq   

0000000000803ef0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803ef0:	55                   	push   %rbp
  803ef1:	48 89 e5             	mov    %rsp,%rbp
  803ef4:	48 83 ec 10          	sub    $0x10,%rsp
  803ef8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803efb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803eff:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803f02:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f09:	00 00 00 
  803f0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f0f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803f11:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f18:	48 89 c6             	mov    %rax,%rsi
  803f1b:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  803f22:	00 00 00 
  803f25:	48 b8 9a 18 80 00 00 	movabs $0x80189a,%rax
  803f2c:	00 00 00 
  803f2f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803f31:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f38:	00 00 00 
  803f3b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f3e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803f41:	bf 02 00 00 00       	mov    $0x2,%edi
  803f46:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  803f4d:	00 00 00 
  803f50:	ff d0                	callq  *%rax
}
  803f52:	c9                   	leaveq 
  803f53:	c3                   	retq   

0000000000803f54 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803f54:	55                   	push   %rbp
  803f55:	48 89 e5             	mov    %rsp,%rbp
  803f58:	48 83 ec 10          	sub    $0x10,%rsp
  803f5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f5f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803f62:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f69:	00 00 00 
  803f6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f6f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803f71:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803f78:	00 00 00 
  803f7b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f7e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803f81:	bf 03 00 00 00       	mov    $0x3,%edi
  803f86:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  803f8d:	00 00 00 
  803f90:	ff d0                	callq  *%rax
}
  803f92:	c9                   	leaveq 
  803f93:	c3                   	retq   

0000000000803f94 <nsipc_close>:

int
nsipc_close(int s)
{
  803f94:	55                   	push   %rbp
  803f95:	48 89 e5             	mov    %rsp,%rbp
  803f98:	48 83 ec 10          	sub    $0x10,%rsp
  803f9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803f9f:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803fa6:	00 00 00 
  803fa9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fac:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803fae:	bf 04 00 00 00       	mov    $0x4,%edi
  803fb3:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  803fba:	00 00 00 
  803fbd:	ff d0                	callq  *%rax
}
  803fbf:	c9                   	leaveq 
  803fc0:	c3                   	retq   

0000000000803fc1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803fc1:	55                   	push   %rbp
  803fc2:	48 89 e5             	mov    %rsp,%rbp
  803fc5:	48 83 ec 10          	sub    $0x10,%rsp
  803fc9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fcc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803fd0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803fd3:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  803fda:	00 00 00 
  803fdd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fe0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803fe2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fe5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe9:	48 89 c6             	mov    %rax,%rsi
  803fec:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  803ff3:	00 00 00 
  803ff6:	48 b8 9a 18 80 00 00 	movabs $0x80189a,%rax
  803ffd:	00 00 00 
  804000:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804002:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804009:	00 00 00 
  80400c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80400f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804012:	bf 05 00 00 00       	mov    $0x5,%edi
  804017:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  80401e:	00 00 00 
  804021:	ff d0                	callq  *%rax
}
  804023:	c9                   	leaveq 
  804024:	c3                   	retq   

0000000000804025 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804025:	55                   	push   %rbp
  804026:	48 89 e5             	mov    %rsp,%rbp
  804029:	48 83 ec 10          	sub    $0x10,%rsp
  80402d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804030:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804033:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80403a:	00 00 00 
  80403d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804040:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804042:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804049:	00 00 00 
  80404c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80404f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804052:	bf 06 00 00 00       	mov    $0x6,%edi
  804057:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  80405e:	00 00 00 
  804061:	ff d0                	callq  *%rax
}
  804063:	c9                   	leaveq 
  804064:	c3                   	retq   

0000000000804065 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804065:	55                   	push   %rbp
  804066:	48 89 e5             	mov    %rsp,%rbp
  804069:	48 83 ec 30          	sub    $0x30,%rsp
  80406d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804070:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804074:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804077:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80407a:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804081:	00 00 00 
  804084:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804087:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804089:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804090:	00 00 00 
  804093:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804096:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804099:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8040a0:	00 00 00 
  8040a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8040a6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8040a9:	bf 07 00 00 00       	mov    $0x7,%edi
  8040ae:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  8040b5:	00 00 00 
  8040b8:	ff d0                	callq  *%rax
  8040ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040c1:	78 69                	js     80412c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8040c3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8040ca:	7f 08                	jg     8040d4 <nsipc_recv+0x6f>
  8040cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040cf:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8040d2:	7e 35                	jle    804109 <nsipc_recv+0xa4>
  8040d4:	48 b9 65 53 80 00 00 	movabs $0x805365,%rcx
  8040db:	00 00 00 
  8040de:	48 ba 7a 53 80 00 00 	movabs $0x80537a,%rdx
  8040e5:	00 00 00 
  8040e8:	be 61 00 00 00       	mov    $0x61,%esi
  8040ed:	48 bf 8f 53 80 00 00 	movabs $0x80538f,%rdi
  8040f4:	00 00 00 
  8040f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8040fc:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  804103:	00 00 00 
  804106:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804109:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80410c:	48 63 d0             	movslq %eax,%rdx
  80410f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804113:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  80411a:	00 00 00 
  80411d:	48 89 c7             	mov    %rax,%rdi
  804120:	48 b8 9a 18 80 00 00 	movabs $0x80189a,%rax
  804127:	00 00 00 
  80412a:	ff d0                	callq  *%rax
	}

	return r;
  80412c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80412f:	c9                   	leaveq 
  804130:	c3                   	retq   

0000000000804131 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804131:	55                   	push   %rbp
  804132:	48 89 e5             	mov    %rsp,%rbp
  804135:	48 83 ec 20          	sub    $0x20,%rsp
  804139:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80413c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804140:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804143:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804146:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80414d:	00 00 00 
  804150:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804153:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804155:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80415c:	7e 35                	jle    804193 <nsipc_send+0x62>
  80415e:	48 b9 9b 53 80 00 00 	movabs $0x80539b,%rcx
  804165:	00 00 00 
  804168:	48 ba 7a 53 80 00 00 	movabs $0x80537a,%rdx
  80416f:	00 00 00 
  804172:	be 6c 00 00 00       	mov    $0x6c,%esi
  804177:	48 bf 8f 53 80 00 00 	movabs $0x80538f,%rdi
  80417e:	00 00 00 
  804181:	b8 00 00 00 00       	mov    $0x0,%eax
  804186:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  80418d:	00 00 00 
  804190:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804193:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804196:	48 63 d0             	movslq %eax,%rdx
  804199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80419d:	48 89 c6             	mov    %rax,%rsi
  8041a0:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  8041a7:	00 00 00 
  8041aa:	48 b8 9a 18 80 00 00 	movabs $0x80189a,%rax
  8041b1:	00 00 00 
  8041b4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8041b6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8041bd:	00 00 00 
  8041c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8041c3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8041c6:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8041cd:	00 00 00 
  8041d0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8041d3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8041d6:	bf 08 00 00 00       	mov    $0x8,%edi
  8041db:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  8041e2:	00 00 00 
  8041e5:	ff d0                	callq  *%rax
}
  8041e7:	c9                   	leaveq 
  8041e8:	c3                   	retq   

00000000008041e9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8041e9:	55                   	push   %rbp
  8041ea:	48 89 e5             	mov    %rsp,%rbp
  8041ed:	48 83 ec 10          	sub    $0x10,%rsp
  8041f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041f4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8041f7:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8041fa:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804201:	00 00 00 
  804204:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804207:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804209:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804210:	00 00 00 
  804213:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804216:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804219:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804220:	00 00 00 
  804223:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804226:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804229:	bf 09 00 00 00       	mov    $0x9,%edi
  80422e:	48 b8 f0 3d 80 00 00 	movabs $0x803df0,%rax
  804235:	00 00 00 
  804238:	ff d0                	callq  *%rax
}
  80423a:	c9                   	leaveq 
  80423b:	c3                   	retq   

000000000080423c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80423c:	55                   	push   %rbp
  80423d:	48 89 e5             	mov    %rsp,%rbp
  804240:	53                   	push   %rbx
  804241:	48 83 ec 38          	sub    $0x38,%rsp
  804245:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804249:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80424d:	48 89 c7             	mov    %rax,%rdi
  804250:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  804257:	00 00 00 
  80425a:	ff d0                	callq  *%rax
  80425c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80425f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804263:	0f 88 bf 01 00 00    	js     804428 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80426d:	ba 07 04 00 00       	mov    $0x407,%edx
  804272:	48 89 c6             	mov    %rax,%rsi
  804275:	bf 00 00 00 00       	mov    $0x0,%edi
  80427a:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  804281:	00 00 00 
  804284:	ff d0                	callq  *%rax
  804286:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804289:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80428d:	0f 88 95 01 00 00    	js     804428 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804293:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804297:	48 89 c7             	mov    %rax,%rdi
  80429a:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  8042a1:	00 00 00 
  8042a4:	ff d0                	callq  *%rax
  8042a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042ad:	0f 88 5d 01 00 00    	js     804410 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042b7:	ba 07 04 00 00       	mov    $0x407,%edx
  8042bc:	48 89 c6             	mov    %rax,%rsi
  8042bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8042c4:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  8042cb:	00 00 00 
  8042ce:	ff d0                	callq  *%rax
  8042d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042d7:	0f 88 33 01 00 00    	js     804410 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8042dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042e1:	48 89 c7             	mov    %rax,%rdi
  8042e4:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8042eb:	00 00 00 
  8042ee:	ff d0                	callq  *%rax
  8042f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042f8:	ba 07 04 00 00       	mov    $0x407,%edx
  8042fd:	48 89 c6             	mov    %rax,%rsi
  804300:	bf 00 00 00 00       	mov    $0x0,%edi
  804305:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  80430c:	00 00 00 
  80430f:	ff d0                	callq  *%rax
  804311:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804314:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804318:	0f 88 d9 00 00 00    	js     8043f7 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80431e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804322:	48 89 c7             	mov    %rax,%rdi
  804325:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80432c:	00 00 00 
  80432f:	ff d0                	callq  *%rax
  804331:	48 89 c2             	mov    %rax,%rdx
  804334:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804338:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80433e:	48 89 d1             	mov    %rdx,%rcx
  804341:	ba 00 00 00 00       	mov    $0x0,%edx
  804346:	48 89 c6             	mov    %rax,%rsi
  804349:	bf 00 00 00 00       	mov    $0x0,%edi
  80434e:	48 b8 00 1f 80 00 00 	movabs $0x801f00,%rax
  804355:	00 00 00 
  804358:	ff d0                	callq  *%rax
  80435a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80435d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804361:	78 79                	js     8043dc <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804363:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804367:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  80436e:	00 00 00 
  804371:	8b 12                	mov    (%rdx),%edx
  804373:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804379:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804380:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804384:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  80438b:	00 00 00 
  80438e:	8b 12                	mov    (%rdx),%edx
  804390:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804392:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804396:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80439d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043a1:	48 89 c7             	mov    %rax,%rdi
  8043a4:	48 b8 00 22 80 00 00 	movabs $0x802200,%rax
  8043ab:	00 00 00 
  8043ae:	ff d0                	callq  *%rax
  8043b0:	89 c2                	mov    %eax,%edx
  8043b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043b6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8043b8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043bc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8043c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043c4:	48 89 c7             	mov    %rax,%rdi
  8043c7:	48 b8 00 22 80 00 00 	movabs $0x802200,%rax
  8043ce:	00 00 00 
  8043d1:	ff d0                	callq  *%rax
  8043d3:	89 03                	mov    %eax,(%rbx)
	return 0;
  8043d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8043da:	eb 4f                	jmp    80442b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8043dc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8043dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043e1:	48 89 c6             	mov    %rax,%rsi
  8043e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8043e9:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  8043f0:	00 00 00 
  8043f3:	ff d0                	callq  *%rax
  8043f5:	eb 01                	jmp    8043f8 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8043f7:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8043f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043fc:	48 89 c6             	mov    %rax,%rsi
  8043ff:	bf 00 00 00 00       	mov    $0x0,%edi
  804404:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  80440b:	00 00 00 
  80440e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804414:	48 89 c6             	mov    %rax,%rsi
  804417:	bf 00 00 00 00       	mov    $0x0,%edi
  80441c:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  804423:	00 00 00 
  804426:	ff d0                	callq  *%rax
err:
	return r;
  804428:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80442b:	48 83 c4 38          	add    $0x38,%rsp
  80442f:	5b                   	pop    %rbx
  804430:	5d                   	pop    %rbp
  804431:	c3                   	retq   

0000000000804432 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804432:	55                   	push   %rbp
  804433:	48 89 e5             	mov    %rsp,%rbp
  804436:	53                   	push   %rbx
  804437:	48 83 ec 28          	sub    $0x28,%rsp
  80443b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80443f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804443:	eb 01                	jmp    804446 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  804445:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804446:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  80444d:	00 00 00 
  804450:	48 8b 00             	mov    (%rax),%rax
  804453:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804459:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80445c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804460:	48 89 c7             	mov    %rax,%rdi
  804463:	48 b8 d4 4a 80 00 00 	movabs $0x804ad4,%rax
  80446a:	00 00 00 
  80446d:	ff d0                	callq  *%rax
  80446f:	89 c3                	mov    %eax,%ebx
  804471:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804475:	48 89 c7             	mov    %rax,%rdi
  804478:	48 b8 d4 4a 80 00 00 	movabs $0x804ad4,%rax
  80447f:	00 00 00 
  804482:	ff d0                	callq  *%rax
  804484:	39 c3                	cmp    %eax,%ebx
  804486:	0f 94 c0             	sete   %al
  804489:	0f b6 c0             	movzbl %al,%eax
  80448c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80448f:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804496:	00 00 00 
  804499:	48 8b 00             	mov    (%rax),%rax
  80449c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044a2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8044a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044a8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044ab:	75 0a                	jne    8044b7 <_pipeisclosed+0x85>
			return ret;
  8044ad:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8044b0:	48 83 c4 28          	add    $0x28,%rsp
  8044b4:	5b                   	pop    %rbx
  8044b5:	5d                   	pop    %rbp
  8044b6:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8044b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044ba:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044bd:	74 86                	je     804445 <_pipeisclosed+0x13>
  8044bf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8044c3:	75 80                	jne    804445 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8044c5:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  8044cc:	00 00 00 
  8044cf:	48 8b 00             	mov    (%rax),%rax
  8044d2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8044d8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8044db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044de:	89 c6                	mov    %eax,%esi
  8044e0:	48 bf ac 53 80 00 00 	movabs $0x8053ac,%rdi
  8044e7:	00 00 00 
  8044ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ef:	49 b8 a7 09 80 00 00 	movabs $0x8009a7,%r8
  8044f6:	00 00 00 
  8044f9:	41 ff d0             	callq  *%r8
	}
  8044fc:	e9 44 ff ff ff       	jmpq   804445 <_pipeisclosed+0x13>

0000000000804501 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804501:	55                   	push   %rbp
  804502:	48 89 e5             	mov    %rsp,%rbp
  804505:	48 83 ec 30          	sub    $0x30,%rsp
  804509:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80450c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804510:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804513:	48 89 d6             	mov    %rdx,%rsi
  804516:	89 c7                	mov    %eax,%edi
  804518:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  80451f:	00 00 00 
  804522:	ff d0                	callq  *%rax
  804524:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804527:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80452b:	79 05                	jns    804532 <pipeisclosed+0x31>
		return r;
  80452d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804530:	eb 31                	jmp    804563 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804536:	48 89 c7             	mov    %rax,%rdi
  804539:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  804540:	00 00 00 
  804543:	ff d0                	callq  *%rax
  804545:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80454d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804551:	48 89 d6             	mov    %rdx,%rsi
  804554:	48 89 c7             	mov    %rax,%rdi
  804557:	48 b8 32 44 80 00 00 	movabs $0x804432,%rax
  80455e:	00 00 00 
  804561:	ff d0                	callq  *%rax
}
  804563:	c9                   	leaveq 
  804564:	c3                   	retq   

0000000000804565 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804565:	55                   	push   %rbp
  804566:	48 89 e5             	mov    %rsp,%rbp
  804569:	48 83 ec 40          	sub    $0x40,%rsp
  80456d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804571:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804575:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80457d:	48 89 c7             	mov    %rax,%rdi
  804580:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  804587:	00 00 00 
  80458a:	ff d0                	callq  *%rax
  80458c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804590:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804594:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804598:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80459f:	00 
  8045a0:	e9 97 00 00 00       	jmpq   80463c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8045a5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8045aa:	74 09                	je     8045b5 <devpipe_read+0x50>
				return i;
  8045ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045b0:	e9 95 00 00 00       	jmpq   80464a <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8045b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045bd:	48 89 d6             	mov    %rdx,%rsi
  8045c0:	48 89 c7             	mov    %rax,%rdi
  8045c3:	48 b8 32 44 80 00 00 	movabs $0x804432,%rax
  8045ca:	00 00 00 
  8045cd:	ff d0                	callq  *%rax
  8045cf:	85 c0                	test   %eax,%eax
  8045d1:	74 07                	je     8045da <devpipe_read+0x75>
				return 0;
  8045d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8045d8:	eb 70                	jmp    80464a <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8045da:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  8045e1:	00 00 00 
  8045e4:	ff d0                	callq  *%rax
  8045e6:	eb 01                	jmp    8045e9 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8045e8:	90                   	nop
  8045e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045ed:	8b 10                	mov    (%rax),%edx
  8045ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045f3:	8b 40 04             	mov    0x4(%rax),%eax
  8045f6:	39 c2                	cmp    %eax,%edx
  8045f8:	74 ab                	je     8045a5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8045fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804602:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80460a:	8b 00                	mov    (%rax),%eax
  80460c:	89 c2                	mov    %eax,%edx
  80460e:	c1 fa 1f             	sar    $0x1f,%edx
  804611:	c1 ea 1b             	shr    $0x1b,%edx
  804614:	01 d0                	add    %edx,%eax
  804616:	83 e0 1f             	and    $0x1f,%eax
  804619:	29 d0                	sub    %edx,%eax
  80461b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80461f:	48 98                	cltq   
  804621:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804626:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80462c:	8b 00                	mov    (%rax),%eax
  80462e:	8d 50 01             	lea    0x1(%rax),%edx
  804631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804635:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804637:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80463c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804640:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804644:	72 a2                	jb     8045e8 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80464a:	c9                   	leaveq 
  80464b:	c3                   	retq   

000000000080464c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80464c:	55                   	push   %rbp
  80464d:	48 89 e5             	mov    %rsp,%rbp
  804650:	48 83 ec 40          	sub    $0x40,%rsp
  804654:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804658:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80465c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804660:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804664:	48 89 c7             	mov    %rax,%rdi
  804667:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80466e:	00 00 00 
  804671:	ff d0                	callq  *%rax
  804673:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804677:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80467b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80467f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804686:	00 
  804687:	e9 93 00 00 00       	jmpq   80471f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80468c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804694:	48 89 d6             	mov    %rdx,%rsi
  804697:	48 89 c7             	mov    %rax,%rdi
  80469a:	48 b8 32 44 80 00 00 	movabs $0x804432,%rax
  8046a1:	00 00 00 
  8046a4:	ff d0                	callq  *%rax
  8046a6:	85 c0                	test   %eax,%eax
  8046a8:	74 07                	je     8046b1 <devpipe_write+0x65>
				return 0;
  8046aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8046af:	eb 7c                	jmp    80472d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8046b1:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  8046b8:	00 00 00 
  8046bb:	ff d0                	callq  *%rax
  8046bd:	eb 01                	jmp    8046c0 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8046bf:	90                   	nop
  8046c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c4:	8b 40 04             	mov    0x4(%rax),%eax
  8046c7:	48 63 d0             	movslq %eax,%rdx
  8046ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ce:	8b 00                	mov    (%rax),%eax
  8046d0:	48 98                	cltq   
  8046d2:	48 83 c0 20          	add    $0x20,%rax
  8046d6:	48 39 c2             	cmp    %rax,%rdx
  8046d9:	73 b1                	jae    80468c <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8046db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046df:	8b 40 04             	mov    0x4(%rax),%eax
  8046e2:	89 c2                	mov    %eax,%edx
  8046e4:	c1 fa 1f             	sar    $0x1f,%edx
  8046e7:	c1 ea 1b             	shr    $0x1b,%edx
  8046ea:	01 d0                	add    %edx,%eax
  8046ec:	83 e0 1f             	and    $0x1f,%eax
  8046ef:	29 d0                	sub    %edx,%eax
  8046f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8046f9:	48 01 ca             	add    %rcx,%rdx
  8046fc:	0f b6 0a             	movzbl (%rdx),%ecx
  8046ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804703:	48 98                	cltq   
  804705:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80470d:	8b 40 04             	mov    0x4(%rax),%eax
  804710:	8d 50 01             	lea    0x1(%rax),%edx
  804713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804717:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80471a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80471f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804723:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804727:	72 96                	jb     8046bf <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804729:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80472d:	c9                   	leaveq 
  80472e:	c3                   	retq   

000000000080472f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80472f:	55                   	push   %rbp
  804730:	48 89 e5             	mov    %rsp,%rbp
  804733:	48 83 ec 20          	sub    $0x20,%rsp
  804737:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80473b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80473f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804743:	48 89 c7             	mov    %rax,%rdi
  804746:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80474d:	00 00 00 
  804750:	ff d0                	callq  *%rax
  804752:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804756:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80475a:	48 be bf 53 80 00 00 	movabs $0x8053bf,%rsi
  804761:	00 00 00 
  804764:	48 89 c7             	mov    %rax,%rdi
  804767:	48 b8 78 15 80 00 00 	movabs $0x801578,%rax
  80476e:	00 00 00 
  804771:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804777:	8b 50 04             	mov    0x4(%rax),%edx
  80477a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80477e:	8b 00                	mov    (%rax),%eax
  804780:	29 c2                	sub    %eax,%edx
  804782:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804786:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80478c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804790:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804797:	00 00 00 
	stat->st_dev = &devpipe;
  80479a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80479e:	48 ba 80 88 80 00 00 	movabs $0x808880,%rdx
  8047a5:	00 00 00 
  8047a8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8047af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047b4:	c9                   	leaveq 
  8047b5:	c3                   	retq   

00000000008047b6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8047b6:	55                   	push   %rbp
  8047b7:	48 89 e5             	mov    %rsp,%rbp
  8047ba:	48 83 ec 10          	sub    $0x10,%rsp
  8047be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8047c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047c6:	48 89 c6             	mov    %rax,%rsi
  8047c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8047ce:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  8047d5:	00 00 00 
  8047d8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8047da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047de:	48 89 c7             	mov    %rax,%rdi
  8047e1:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8047e8:	00 00 00 
  8047eb:	ff d0                	callq  *%rax
  8047ed:	48 89 c6             	mov    %rax,%rsi
  8047f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8047f5:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  8047fc:	00 00 00 
  8047ff:	ff d0                	callq  *%rax
}
  804801:	c9                   	leaveq 
  804802:	c3                   	retq   
	...

0000000000804804 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804804:	55                   	push   %rbp
  804805:	48 89 e5             	mov    %rsp,%rbp
  804808:	48 83 ec 20          	sub    $0x20,%rsp
  80480c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80480f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804813:	75 35                	jne    80484a <wait+0x46>
  804815:	48 b9 c6 53 80 00 00 	movabs $0x8053c6,%rcx
  80481c:	00 00 00 
  80481f:	48 ba d1 53 80 00 00 	movabs $0x8053d1,%rdx
  804826:	00 00 00 
  804829:	be 09 00 00 00       	mov    $0x9,%esi
  80482e:	48 bf e6 53 80 00 00 	movabs $0x8053e6,%rdi
  804835:	00 00 00 
  804838:	b8 00 00 00 00       	mov    $0x0,%eax
  80483d:	49 b8 6c 07 80 00 00 	movabs $0x80076c,%r8
  804844:	00 00 00 
  804847:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80484a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80484d:	48 98                	cltq   
  80484f:	48 89 c2             	mov    %rax,%rdx
  804852:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  804858:	48 89 d0             	mov    %rdx,%rax
  80485b:	48 c1 e0 02          	shl    $0x2,%rax
  80485f:	48 01 d0             	add    %rdx,%rax
  804862:	48 01 c0             	add    %rax,%rax
  804865:	48 01 d0             	add    %rdx,%rax
  804868:	48 c1 e0 05          	shl    $0x5,%rax
  80486c:	48 89 c2             	mov    %rax,%rdx
  80486f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804876:	00 00 00 
  804879:	48 01 d0             	add    %rdx,%rax
  80487c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804880:	eb 0c                	jmp    80488e <wait+0x8a>
		sys_yield();
  804882:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  804889:	00 00 00 
  80488c:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80488e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804892:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804898:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80489b:	75 0e                	jne    8048ab <wait+0xa7>
  80489d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048a1:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8048a7:	85 c0                	test   %eax,%eax
  8048a9:	75 d7                	jne    804882 <wait+0x7e>
		sys_yield();
}
  8048ab:	c9                   	leaveq 
  8048ac:	c3                   	retq   
  8048ad:	00 00                	add    %al,(%rax)
	...

00000000008048b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8048b0:	55                   	push   %rbp
  8048b1:	48 89 e5             	mov    %rsp,%rbp
  8048b4:	48 83 ec 30          	sub    $0x30,%rsp
  8048b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8048bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8048c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  8048c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  8048cb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8048d0:	74 18                	je     8048ea <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  8048d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048d6:	48 89 c7             	mov    %rax,%rdi
  8048d9:	48 b8 d9 20 80 00 00 	movabs $0x8020d9,%rax
  8048e0:	00 00 00 
  8048e3:	ff d0                	callq  *%rax
  8048e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048e8:	eb 19                	jmp    804903 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  8048ea:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  8048f1:	00 00 00 
  8048f4:	48 b8 d9 20 80 00 00 	movabs $0x8020d9,%rax
  8048fb:	00 00 00 
  8048fe:	ff d0                	callq  *%rax
  804900:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  804903:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804907:	79 39                	jns    804942 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  804909:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80490e:	75 08                	jne    804918 <ipc_recv+0x68>
  804910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804914:	8b 00                	mov    (%rax),%eax
  804916:	eb 05                	jmp    80491d <ipc_recv+0x6d>
  804918:	b8 00 00 00 00       	mov    $0x0,%eax
  80491d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804921:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  804923:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804928:	75 08                	jne    804932 <ipc_recv+0x82>
  80492a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80492e:	8b 00                	mov    (%rax),%eax
  804930:	eb 05                	jmp    804937 <ipc_recv+0x87>
  804932:	b8 00 00 00 00       	mov    $0x0,%eax
  804937:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80493b:	89 02                	mov    %eax,(%rdx)
		return r;
  80493d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804940:	eb 53                	jmp    804995 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  804942:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804947:	74 19                	je     804962 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  804949:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804950:	00 00 00 
  804953:	48 8b 00             	mov    (%rax),%rax
  804956:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80495c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804960:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  804962:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804967:	74 19                	je     804982 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  804969:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804970:	00 00 00 
  804973:	48 8b 00             	mov    (%rax),%rax
  804976:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80497c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804980:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  804982:	48 b8 90 a7 80 00 00 	movabs $0x80a790,%rax
  804989:	00 00 00 
  80498c:	48 8b 00             	mov    (%rax),%rax
  80498f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  804995:	c9                   	leaveq 
  804996:	c3                   	retq   

0000000000804997 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804997:	55                   	push   %rbp
  804998:	48 89 e5             	mov    %rsp,%rbp
  80499b:	48 83 ec 30          	sub    $0x30,%rsp
  80499f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8049a2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8049a5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8049a9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  8049ac:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  8049b3:	eb 59                	jmp    804a0e <ipc_send+0x77>
		if(pg) {
  8049b5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8049ba:	74 20                	je     8049dc <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  8049bc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8049bf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8049c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8049c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049c9:	89 c7                	mov    %eax,%edi
  8049cb:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  8049d2:	00 00 00 
  8049d5:	ff d0                	callq  *%rax
  8049d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049da:	eb 26                	jmp    804a02 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  8049dc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8049df:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8049e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049e5:	89 d1                	mov    %edx,%ecx
  8049e7:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8049ee:	00 00 00 
  8049f1:	89 c7                	mov    %eax,%edi
  8049f3:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  8049fa:	00 00 00 
  8049fd:	ff d0                	callq  *%rax
  8049ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  804a02:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  804a09:	00 00 00 
  804a0c:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  804a0e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804a12:	74 a1                	je     8049b5 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  804a14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a18:	74 2a                	je     804a44 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  804a1a:	48 ba f8 53 80 00 00 	movabs $0x8053f8,%rdx
  804a21:	00 00 00 
  804a24:	be 49 00 00 00       	mov    $0x49,%esi
  804a29:	48 bf 23 54 80 00 00 	movabs $0x805423,%rdi
  804a30:	00 00 00 
  804a33:	b8 00 00 00 00       	mov    $0x0,%eax
  804a38:	48 b9 6c 07 80 00 00 	movabs $0x80076c,%rcx
  804a3f:	00 00 00 
  804a42:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  804a44:	c9                   	leaveq 
  804a45:	c3                   	retq   

0000000000804a46 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804a46:	55                   	push   %rbp
  804a47:	48 89 e5             	mov    %rsp,%rbp
  804a4a:	48 83 ec 18          	sub    $0x18,%rsp
  804a4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804a51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a58:	eb 6a                	jmp    804ac4 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  804a5a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804a61:	00 00 00 
  804a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a67:	48 63 d0             	movslq %eax,%rdx
  804a6a:	48 89 d0             	mov    %rdx,%rax
  804a6d:	48 c1 e0 02          	shl    $0x2,%rax
  804a71:	48 01 d0             	add    %rdx,%rax
  804a74:	48 01 c0             	add    %rax,%rax
  804a77:	48 01 d0             	add    %rdx,%rax
  804a7a:	48 c1 e0 05          	shl    $0x5,%rax
  804a7e:	48 01 c8             	add    %rcx,%rax
  804a81:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804a87:	8b 00                	mov    (%rax),%eax
  804a89:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804a8c:	75 32                	jne    804ac0 <ipc_find_env+0x7a>
			return envs[i].env_id;
  804a8e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804a95:	00 00 00 
  804a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a9b:	48 63 d0             	movslq %eax,%rdx
  804a9e:	48 89 d0             	mov    %rdx,%rax
  804aa1:	48 c1 e0 02          	shl    $0x2,%rax
  804aa5:	48 01 d0             	add    %rdx,%rax
  804aa8:	48 01 c0             	add    %rax,%rax
  804aab:	48 01 d0             	add    %rdx,%rax
  804aae:	48 c1 e0 05          	shl    $0x5,%rax
  804ab2:	48 01 c8             	add    %rcx,%rax
  804ab5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804abb:	8b 40 08             	mov    0x8(%rax),%eax
  804abe:	eb 12                	jmp    804ad2 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804ac0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804ac4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804acb:	7e 8d                	jle    804a5a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ad2:	c9                   	leaveq 
  804ad3:	c3                   	retq   

0000000000804ad4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804ad4:	55                   	push   %rbp
  804ad5:	48 89 e5             	mov    %rsp,%rbp
  804ad8:	48 83 ec 18          	sub    $0x18,%rsp
  804adc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ae4:	48 89 c2             	mov    %rax,%rdx
  804ae7:	48 c1 ea 15          	shr    $0x15,%rdx
  804aeb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804af2:	01 00 00 
  804af5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804af9:	83 e0 01             	and    $0x1,%eax
  804afc:	48 85 c0             	test   %rax,%rax
  804aff:	75 07                	jne    804b08 <pageref+0x34>
		return 0;
  804b01:	b8 00 00 00 00       	mov    $0x0,%eax
  804b06:	eb 53                	jmp    804b5b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804b08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b0c:	48 89 c2             	mov    %rax,%rdx
  804b0f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804b13:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804b1a:	01 00 00 
  804b1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b29:	83 e0 01             	and    $0x1,%eax
  804b2c:	48 85 c0             	test   %rax,%rax
  804b2f:	75 07                	jne    804b38 <pageref+0x64>
		return 0;
  804b31:	b8 00 00 00 00       	mov    $0x0,%eax
  804b36:	eb 23                	jmp    804b5b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b3c:	48 89 c2             	mov    %rax,%rdx
  804b3f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804b43:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804b4a:	00 00 00 
  804b4d:	48 c1 e2 04          	shl    $0x4,%rdx
  804b51:	48 01 d0             	add    %rdx,%rax
  804b54:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804b58:	0f b7 c0             	movzwl %ax,%eax
}
  804b5b:	c9                   	leaveq 
  804b5c:	c3                   	retq   
