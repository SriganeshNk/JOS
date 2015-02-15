
obj/user/testkbd.debug:     file format elf64-x86-64


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
  80003c:	e8 2f 04 00 00       	callq  800470 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80005a:	eb 10                	jmp    80006c <umain+0x28>
		sys_yield();
  80005c:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800068:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006c:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  800070:	7e ea                	jle    80005c <umain+0x18>
		sys_yield();

	close(0);
  800072:	bf 00 00 00 00       	mov    $0x0,%edi
  800077:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800083:	48 b8 7d 02 80 00 00 	movabs $0x80027d,%rax
  80008a:	00 00 00 
  80008d:	ff d0                	callq  *%rax
  80008f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800092:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800096:	79 30                	jns    8000c8 <umain+0x84>
		panic("opencons: %e", r);
  800098:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009b:	89 c1                	mov    %eax,%ecx
  80009d:	48 ba 00 41 80 00 00 	movabs $0x804100,%rdx
  8000a4:	00 00 00 
  8000a7:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ac:	48 bf 0d 41 80 00 00 	movabs $0x80410d,%rdi
  8000b3:	00 00 00 
  8000b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bb:	49 b8 3c 05 80 00 00 	movabs $0x80053c,%r8
  8000c2:	00 00 00 
  8000c5:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	74 30                	je     8000fe <umain+0xba>
		panic("first opencons used fd %d", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 1c 41 80 00 00 	movabs $0x80411c,%rdx
  8000da:	00 00 00 
  8000dd:	be 11 00 00 00       	mov    $0x11,%esi
  8000e2:	48 bf 0d 41 80 00 00 	movabs $0x80410d,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 3c 05 80 00 00 	movabs $0x80053c,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fe:	be 01 00 00 00       	mov    $0x1,%esi
  800103:	bf 00 00 00 00       	mov    $0x0,%edi
  800108:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  80010f:	00 00 00 
  800112:	ff d0                	callq  *%rax
  800114:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800117:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011b:	79 30                	jns    80014d <umain+0x109>
		panic("dup: %e", r);
  80011d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800120:	89 c1                	mov    %eax,%ecx
  800122:	48 ba 36 41 80 00 00 	movabs $0x804136,%rdx
  800129:	00 00 00 
  80012c:	be 13 00 00 00       	mov    $0x13,%esi
  800131:	48 bf 0d 41 80 00 00 	movabs $0x80410d,%rdi
  800138:	00 00 00 
  80013b:	b8 00 00 00 00       	mov    $0x0,%eax
  800140:	49 b8 3c 05 80 00 00 	movabs $0x80053c,%r8
  800147:	00 00 00 
  80014a:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014d:	48 bf 3e 41 80 00 00 	movabs $0x80413e,%rdi
  800154:	00 00 00 
  800157:	48 b8 dc 12 80 00 00 	movabs $0x8012dc,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800167:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016c:	74 29                	je     800197 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800172:	48 89 c2             	mov    %rax,%rdx
  800175:	48 be 4c 41 80 00 00 	movabs $0x80414c,%rsi
  80017c:	00 00 00 
  80017f:	bf 01 00 00 00       	mov    $0x1,%edi
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 b9 f0 2e 80 00 00 	movabs $0x802ef0,%rcx
  800190:	00 00 00 
  800193:	ff d1                	callq  *%rcx
		else
			fprintf(1, "(end of file received)\n");
	}
  800195:	eb b6                	jmp    80014d <umain+0x109>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  800197:	48 be 50 41 80 00 00 	movabs $0x804150,%rsi
  80019e:	00 00 00 
  8001a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ab:	48 ba f0 2e 80 00 00 	movabs $0x802ef0,%rdx
  8001b2:	00 00 00 
  8001b5:	ff d2                	callq  *%rdx
	}
  8001b7:	eb 94                	jmp    80014d <umain+0x109>
  8001b9:	00 00                	add    %al,(%rax)
	...

00000000008001bc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001bc:	55                   	push   %rbp
  8001bd:	48 89 e5             	mov    %rsp,%rbp
  8001c0:	48 83 ec 20          	sub    $0x20,%rsp
  8001c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ca:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001cd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001d1:	be 01 00 00 00       	mov    $0x1,%esi
  8001d6:	48 89 c7             	mov    %rax,%rdi
  8001d9:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	callq  *%rax
}
  8001e5:	c9                   	leaveq 
  8001e6:	c3                   	retq   

00000000008001e7 <getchar>:

int
getchar(void)
{
  8001e7:	55                   	push   %rbp
  8001e8:	48 89 e5             	mov    %rsp,%rbp
  8001eb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001ef:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001f3:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f8:	48 89 c6             	mov    %rax,%rsi
  8001fb:	bf 00 00 00 00       	mov    $0x0,%edi
  800200:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
  80020c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800213:	79 05                	jns    80021a <getchar+0x33>
		return r;
  800215:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800218:	eb 14                	jmp    80022e <getchar+0x47>
	if (r < 1)
  80021a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021e:	7f 07                	jg     800227 <getchar+0x40>
		return -E_EOF;
  800220:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800225:	eb 07                	jmp    80022e <getchar+0x47>
	return c;
  800227:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80022b:	0f b6 c0             	movzbl %al,%eax
}
  80022e:	c9                   	leaveq 
  80022f:	c3                   	retq   

0000000000800230 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800230:	55                   	push   %rbp
  800231:	48 89 e5             	mov    %rsp,%rbp
  800234:	48 83 ec 20          	sub    $0x20,%rsp
  800238:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80023b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800242:	48 89 d6             	mov    %rdx,%rsi
  800245:	89 c7                	mov    %eax,%edi
  800247:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  80024e:	00 00 00 
  800251:	ff d0                	callq  *%rax
  800253:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800256:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80025a:	79 05                	jns    800261 <iscons+0x31>
		return r;
  80025c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025f:	eb 1a                	jmp    80027b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800265:	8b 10                	mov    (%rax),%edx
  800267:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80026e:	00 00 00 
  800271:	8b 00                	mov    (%rax),%eax
  800273:	39 c2                	cmp    %eax,%edx
  800275:	0f 94 c0             	sete   %al
  800278:	0f b6 c0             	movzbl %al,%eax
}
  80027b:	c9                   	leaveq 
  80027c:	c3                   	retq   

000000000080027d <opencons>:

int
opencons(void)
{
  80027d:	55                   	push   %rbp
  80027e:	48 89 e5             	mov    %rsp,%rbp
  800281:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800285:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800289:	48 89 c7             	mov    %rax,%rdi
  80028c:	48 b8 7e 21 80 00 00 	movabs $0x80217e,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
  800298:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80029b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029f:	79 05                	jns    8002a6 <opencons+0x29>
		return r;
  8002a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a4:	eb 5b                	jmp    800301 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8002af:	48 89 c6             	mov    %rax,%rsi
  8002b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b7:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002ca:	79 05                	jns    8002d1 <opencons+0x54>
		return r;
  8002cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cf:	eb 30                	jmp    800301 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d5:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8002dc:	00 00 00 
  8002df:	8b 12                	mov    (%rdx),%edx
  8002e1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f2:	48 89 c7             	mov    %rax,%rdi
  8002f5:	48 b8 30 21 80 00 00 	movabs $0x802130,%rax
  8002fc:	00 00 00 
  8002ff:	ff d0                	callq  *%rax
}
  800301:	c9                   	leaveq 
  800302:	c3                   	retq   

0000000000800303 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800303:	55                   	push   %rbp
  800304:	48 89 e5             	mov    %rsp,%rbp
  800307:	48 83 ec 30          	sub    $0x30,%rsp
  80030b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800313:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800317:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80031c:	75 13                	jne    800331 <devcons_read+0x2e>
		return 0;
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
  800323:	eb 49                	jmp    80036e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800325:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  80032c:	00 00 00 
  80032f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800331:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  800338:	00 00 00 
  80033b:	ff d0                	callq  *%rax
  80033d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800340:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800344:	74 df                	je     800325 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  800346:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80034a:	79 05                	jns    800351 <devcons_read+0x4e>
		return c;
  80034c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034f:	eb 1d                	jmp    80036e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  800351:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800355:	75 07                	jne    80035e <devcons_read+0x5b>
		return 0;
  800357:	b8 00 00 00 00       	mov    $0x0,%eax
  80035c:	eb 10                	jmp    80036e <devcons_read+0x6b>
	*(char*)vbuf = c;
  80035e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800361:	89 c2                	mov    %eax,%edx
  800363:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800367:	88 10                	mov    %dl,(%rax)
	return 1;
  800369:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036e:	c9                   	leaveq 
  80036f:	c3                   	retq   

0000000000800370 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800370:	55                   	push   %rbp
  800371:	48 89 e5             	mov    %rsp,%rbp
  800374:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80037b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800382:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800389:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800397:	eb 77                	jmp    800410 <devcons_write+0xa0>
		m = n - tot;
  800399:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a5:	89 d1                	mov    %edx,%ecx
  8003a7:	29 c1                	sub    %eax,%ecx
  8003a9:	89 c8                	mov    %ecx,%eax
  8003ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003b1:	83 f8 7f             	cmp    $0x7f,%eax
  8003b4:	76 07                	jbe    8003bd <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8003b6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003c0:	48 63 d0             	movslq %eax,%rdx
  8003c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c6:	48 98                	cltq   
  8003c8:	48 89 c1             	mov    %rax,%rcx
  8003cb:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8003d2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d9:	48 89 ce             	mov    %rcx,%rsi
  8003dc:	48 89 c7             	mov    %rax,%rdi
  8003df:	48 b8 ca 17 80 00 00 	movabs $0x8017ca,%rax
  8003e6:	00 00 00 
  8003e9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ee:	48 63 d0             	movslq %eax,%rdx
  8003f1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f8:	48 89 d6             	mov    %rdx,%rsi
  8003fb:	48 89 c7             	mov    %rax,%rdi
  8003fe:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  800405:	00 00 00 
  800408:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80040a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040d:	01 45 fc             	add    %eax,-0x4(%rbp)
  800410:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800413:	48 98                	cltq   
  800415:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80041c:	0f 82 77 ff ff ff    	jb     800399 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800422:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800425:	c9                   	leaveq 
  800426:	c3                   	retq   

0000000000800427 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800427:	55                   	push   %rbp
  800428:	48 89 e5             	mov    %rsp,%rbp
  80042b:	48 83 ec 08          	sub    $0x8,%rsp
  80042f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800433:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800438:	c9                   	leaveq 
  800439:	c3                   	retq   

000000000080043a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80043a:	55                   	push   %rbp
  80043b:	48 89 e5             	mov    %rsp,%rbp
  80043e:	48 83 ec 10          	sub    $0x10,%rsp
  800442:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80044a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044e:	48 be 6d 41 80 00 00 	movabs $0x80416d,%rsi
  800455:	00 00 00 
  800458:	48 89 c7             	mov    %rax,%rdi
  80045b:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax
	return 0;
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80046c:	c9                   	leaveq 
  80046d:	c3                   	retq   
	...

0000000000800470 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800470:	55                   	push   %rbp
  800471:	48 89 e5             	mov    %rsp,%rbp
  800474:	48 83 ec 10          	sub    $0x10,%rsp
  800478:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80047b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80047f:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  800486:	00 00 00 
  800489:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800490:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  800497:	00 00 00 
  80049a:	ff d0                	callq  *%rax
  80049c:	48 98                	cltq   
  80049e:	48 89 c2             	mov    %rax,%rdx
  8004a1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8004a7:	48 89 d0             	mov    %rdx,%rax
  8004aa:	48 c1 e0 02          	shl    $0x2,%rax
  8004ae:	48 01 d0             	add    %rdx,%rax
  8004b1:	48 01 c0             	add    %rax,%rax
  8004b4:	48 01 d0             	add    %rdx,%rax
  8004b7:	48 c1 e0 05          	shl    $0x5,%rax
  8004bb:	48 89 c2             	mov    %rax,%rdx
  8004be:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8004c5:	00 00 00 
  8004c8:	48 01 c2             	add    %rax,%rdx
  8004cb:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8004d2:	00 00 00 
  8004d5:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004dc:	7e 14                	jle    8004f2 <libmain+0x82>
		binaryname = argv[0];
  8004de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e2:	48 8b 10             	mov    (%rax),%rdx
  8004e5:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8004ec:	00 00 00 
  8004ef:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f9:	48 89 d6             	mov    %rdx,%rsi
  8004fc:	89 c7                	mov    %eax,%edi
  8004fe:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800505:	00 00 00 
  800508:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80050a:	48 b8 18 05 80 00 00 	movabs $0x800518,%rax
  800511:	00 00 00 
  800514:	ff d0                	callq  *%rax
}
  800516:	c9                   	leaveq 
  800517:	c3                   	retq   

0000000000800518 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800518:	55                   	push   %rbp
  800519:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80051c:	48 b8 71 24 80 00 00 	movabs $0x802471,%rax
  800523:	00 00 00 
  800526:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800528:	bf 00 00 00 00       	mov    $0x0,%edi
  80052d:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  800534:	00 00 00 
  800537:	ff d0                	callq  *%rax
}
  800539:	5d                   	pop    %rbp
  80053a:	c3                   	retq   
	...

000000000080053c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80053c:	55                   	push   %rbp
  80053d:	48 89 e5             	mov    %rsp,%rbp
  800540:	53                   	push   %rbx
  800541:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800548:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80054f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800555:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80055c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800563:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80056a:	84 c0                	test   %al,%al
  80056c:	74 23                	je     800591 <_panic+0x55>
  80056e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800575:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800579:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80057d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800581:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800585:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800589:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80058d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800591:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800598:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80059f:	00 00 00 
  8005a2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8005a9:	00 00 00 
  8005ac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005b0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8005b7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005be:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005c5:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8005cc:	00 00 00 
  8005cf:	48 8b 18             	mov    (%rax),%rbx
  8005d2:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  8005d9:	00 00 00 
  8005dc:	ff d0                	callq  *%rax
  8005de:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005e4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005eb:	41 89 c8             	mov    %ecx,%r8d
  8005ee:	48 89 d1             	mov    %rdx,%rcx
  8005f1:	48 89 da             	mov    %rbx,%rdx
  8005f4:	89 c6                	mov    %eax,%esi
  8005f6:	48 bf 80 41 80 00 00 	movabs $0x804180,%rdi
  8005fd:	00 00 00 
  800600:	b8 00 00 00 00       	mov    $0x0,%eax
  800605:	49 b9 77 07 80 00 00 	movabs $0x800777,%r9
  80060c:	00 00 00 
  80060f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800612:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800619:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800620:	48 89 d6             	mov    %rdx,%rsi
  800623:	48 89 c7             	mov    %rax,%rdi
  800626:	48 b8 cb 06 80 00 00 	movabs $0x8006cb,%rax
  80062d:	00 00 00 
  800630:	ff d0                	callq  *%rax
	cprintf("\n");
  800632:	48 bf a3 41 80 00 00 	movabs $0x8041a3,%rdi
  800639:	00 00 00 
  80063c:	b8 00 00 00 00       	mov    $0x0,%eax
  800641:	48 ba 77 07 80 00 00 	movabs $0x800777,%rdx
  800648:	00 00 00 
  80064b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80064d:	cc                   	int3   
  80064e:	eb fd                	jmp    80064d <_panic+0x111>

0000000000800650 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800650:	55                   	push   %rbp
  800651:	48 89 e5             	mov    %rsp,%rbp
  800654:	48 83 ec 10          	sub    $0x10,%rsp
  800658:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80065b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80065f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800663:	8b 00                	mov    (%rax),%eax
  800665:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800668:	89 d6                	mov    %edx,%esi
  80066a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80066e:	48 63 d0             	movslq %eax,%rdx
  800671:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800676:	8d 50 01             	lea    0x1(%rax),%edx
  800679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067d:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  80067f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	3d ff 00 00 00       	cmp    $0xff,%eax
  80068a:	75 2c                	jne    8006b8 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  80068c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800690:	8b 00                	mov    (%rax),%eax
  800692:	48 98                	cltq   
  800694:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800698:	48 83 c2 08          	add    $0x8,%rdx
  80069c:	48 89 c6             	mov    %rax,%rsi
  80069f:	48 89 d7             	mov    %rdx,%rdi
  8006a2:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  8006a9:	00 00 00 
  8006ac:	ff d0                	callq  *%rax
        b->idx = 0;
  8006ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8006b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006bc:	8b 40 04             	mov    0x4(%rax),%eax
  8006bf:	8d 50 01             	lea    0x1(%rax),%edx
  8006c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006c6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006c9:	c9                   	leaveq 
  8006ca:	c3                   	retq   

00000000008006cb <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006cb:	55                   	push   %rbp
  8006cc:	48 89 e5             	mov    %rsp,%rbp
  8006cf:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006d6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006dd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006e4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006eb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006f2:	48 8b 0a             	mov    (%rdx),%rcx
  8006f5:	48 89 08             	mov    %rcx,(%rax)
  8006f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006fc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800700:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800704:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800708:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80070f:	00 00 00 
    b.cnt = 0;
  800712:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800719:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80071c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800723:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80072a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800731:	48 89 c6             	mov    %rax,%rsi
  800734:	48 bf 50 06 80 00 00 	movabs $0x800650,%rdi
  80073b:	00 00 00 
  80073e:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  800745:	00 00 00 
  800748:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80074a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800750:	48 98                	cltq   
  800752:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800759:	48 83 c2 08          	add    $0x8,%rdx
  80075d:	48 89 c6             	mov    %rax,%rsi
  800760:	48 89 d7             	mov    %rdx,%rdi
  800763:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  80076a:	00 00 00 
  80076d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80076f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800775:	c9                   	leaveq 
  800776:	c3                   	retq   

0000000000800777 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800777:	55                   	push   %rbp
  800778:	48 89 e5             	mov    %rsp,%rbp
  80077b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800782:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800789:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800790:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800797:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80079e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8007a5:	84 c0                	test   %al,%al
  8007a7:	74 20                	je     8007c9 <cprintf+0x52>
  8007a9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8007ad:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8007b1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8007b5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8007b9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007bd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007c1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007c5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007c9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007d0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007d7:	00 00 00 
  8007da:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007e1:	00 00 00 
  8007e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007e8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007ef:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007f6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007fd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800804:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80080b:	48 8b 0a             	mov    (%rdx),%rcx
  80080e:	48 89 08             	mov    %rcx,(%rax)
  800811:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800815:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800819:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80081d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800821:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800828:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80082f:	48 89 d6             	mov    %rdx,%rsi
  800832:	48 89 c7             	mov    %rax,%rdi
  800835:	48 b8 cb 06 80 00 00 	movabs $0x8006cb,%rax
  80083c:	00 00 00 
  80083f:	ff d0                	callq  *%rax
  800841:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800847:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80084d:	c9                   	leaveq 
  80084e:	c3                   	retq   
	...

0000000000800850 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800850:	55                   	push   %rbp
  800851:	48 89 e5             	mov    %rsp,%rbp
  800854:	48 83 ec 30          	sub    $0x30,%rsp
  800858:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80085c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800860:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800864:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800867:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80086b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80086f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800872:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800876:	77 52                	ja     8008ca <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800878:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80087b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80087f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800882:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088a:	ba 00 00 00 00       	mov    $0x0,%edx
  80088f:	48 f7 75 d0          	divq   -0x30(%rbp)
  800893:	48 89 c2             	mov    %rax,%rdx
  800896:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800899:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80089c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8008a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008a4:	41 89 f9             	mov    %edi,%r9d
  8008a7:	48 89 c7             	mov    %rax,%rdi
  8008aa:	48 b8 50 08 80 00 00 	movabs $0x800850,%rax
  8008b1:	00 00 00 
  8008b4:	ff d0                	callq  *%rax
  8008b6:	eb 1c                	jmp    8008d4 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8008bf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8008c3:	48 89 d6             	mov    %rdx,%rsi
  8008c6:	89 c7                	mov    %eax,%edi
  8008c8:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008ca:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008d2:	7f e4                	jg     8008b8 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008db:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e0:	48 f7 f1             	div    %rcx
  8008e3:	48 89 d0             	mov    %rdx,%rax
  8008e6:	48 ba b0 43 80 00 00 	movabs $0x8043b0,%rdx
  8008ed:	00 00 00 
  8008f0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008f4:	0f be c0             	movsbl %al,%eax
  8008f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008fb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8008ff:	48 89 d6             	mov    %rdx,%rsi
  800902:	89 c7                	mov    %eax,%edi
  800904:	ff d1                	callq  *%rcx
}
  800906:	c9                   	leaveq 
  800907:	c3                   	retq   

0000000000800908 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800908:	55                   	push   %rbp
  800909:	48 89 e5             	mov    %rsp,%rbp
  80090c:	48 83 ec 20          	sub    $0x20,%rsp
  800910:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800914:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800917:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80091b:	7e 52                	jle    80096f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80091d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800921:	8b 00                	mov    (%rax),%eax
  800923:	83 f8 30             	cmp    $0x30,%eax
  800926:	73 24                	jae    80094c <getuint+0x44>
  800928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800934:	8b 00                	mov    (%rax),%eax
  800936:	89 c0                	mov    %eax,%eax
  800938:	48 01 d0             	add    %rdx,%rax
  80093b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093f:	8b 12                	mov    (%rdx),%edx
  800941:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800944:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800948:	89 0a                	mov    %ecx,(%rdx)
  80094a:	eb 17                	jmp    800963 <getuint+0x5b>
  80094c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800950:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800954:	48 89 d0             	mov    %rdx,%rax
  800957:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800963:	48 8b 00             	mov    (%rax),%rax
  800966:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80096a:	e9 a3 00 00 00       	jmpq   800a12 <getuint+0x10a>
	else if (lflag)
  80096f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800973:	74 4f                	je     8009c4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800975:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800979:	8b 00                	mov    (%rax),%eax
  80097b:	83 f8 30             	cmp    $0x30,%eax
  80097e:	73 24                	jae    8009a4 <getuint+0x9c>
  800980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800984:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098c:	8b 00                	mov    (%rax),%eax
  80098e:	89 c0                	mov    %eax,%eax
  800990:	48 01 d0             	add    %rdx,%rax
  800993:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800997:	8b 12                	mov    (%rdx),%edx
  800999:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a0:	89 0a                	mov    %ecx,(%rdx)
  8009a2:	eb 17                	jmp    8009bb <getuint+0xb3>
  8009a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ac:	48 89 d0             	mov    %rdx,%rax
  8009af:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009bb:	48 8b 00             	mov    (%rax),%rax
  8009be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009c2:	eb 4e                	jmp    800a12 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c8:	8b 00                	mov    (%rax),%eax
  8009ca:	83 f8 30             	cmp    $0x30,%eax
  8009cd:	73 24                	jae    8009f3 <getuint+0xeb>
  8009cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009db:	8b 00                	mov    (%rax),%eax
  8009dd:	89 c0                	mov    %eax,%eax
  8009df:	48 01 d0             	add    %rdx,%rax
  8009e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e6:	8b 12                	mov    (%rdx),%edx
  8009e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ef:	89 0a                	mov    %ecx,(%rdx)
  8009f1:	eb 17                	jmp    800a0a <getuint+0x102>
  8009f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009fb:	48 89 d0             	mov    %rdx,%rax
  8009fe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a06:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a0a:	8b 00                	mov    (%rax),%eax
  800a0c:	89 c0                	mov    %eax,%eax
  800a0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a16:	c9                   	leaveq 
  800a17:	c3                   	retq   

0000000000800a18 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a18:	55                   	push   %rbp
  800a19:	48 89 e5             	mov    %rsp,%rbp
  800a1c:	48 83 ec 20          	sub    $0x20,%rsp
  800a20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a24:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a27:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a2b:	7e 52                	jle    800a7f <getint+0x67>
		x=va_arg(*ap, long long);
  800a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a31:	8b 00                	mov    (%rax),%eax
  800a33:	83 f8 30             	cmp    $0x30,%eax
  800a36:	73 24                	jae    800a5c <getint+0x44>
  800a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a44:	8b 00                	mov    (%rax),%eax
  800a46:	89 c0                	mov    %eax,%eax
  800a48:	48 01 d0             	add    %rdx,%rax
  800a4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4f:	8b 12                	mov    (%rdx),%edx
  800a51:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a58:	89 0a                	mov    %ecx,(%rdx)
  800a5a:	eb 17                	jmp    800a73 <getint+0x5b>
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a64:	48 89 d0             	mov    %rdx,%rax
  800a67:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a73:	48 8b 00             	mov    (%rax),%rax
  800a76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a7a:	e9 a3 00 00 00       	jmpq   800b22 <getint+0x10a>
	else if (lflag)
  800a7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a83:	74 4f                	je     800ad4 <getint+0xbc>
		x=va_arg(*ap, long);
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	8b 00                	mov    (%rax),%eax
  800a8b:	83 f8 30             	cmp    $0x30,%eax
  800a8e:	73 24                	jae    800ab4 <getint+0x9c>
  800a90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a94:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9c:	8b 00                	mov    (%rax),%eax
  800a9e:	89 c0                	mov    %eax,%eax
  800aa0:	48 01 d0             	add    %rdx,%rax
  800aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa7:	8b 12                	mov    (%rdx),%edx
  800aa9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab0:	89 0a                	mov    %ecx,(%rdx)
  800ab2:	eb 17                	jmp    800acb <getint+0xb3>
  800ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800abc:	48 89 d0             	mov    %rdx,%rax
  800abf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ac3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800acb:	48 8b 00             	mov    (%rax),%rax
  800ace:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ad2:	eb 4e                	jmp    800b22 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad8:	8b 00                	mov    (%rax),%eax
  800ada:	83 f8 30             	cmp    $0x30,%eax
  800add:	73 24                	jae    800b03 <getint+0xeb>
  800adf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aeb:	8b 00                	mov    (%rax),%eax
  800aed:	89 c0                	mov    %eax,%eax
  800aef:	48 01 d0             	add    %rdx,%rax
  800af2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af6:	8b 12                	mov    (%rdx),%edx
  800af8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800afb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aff:	89 0a                	mov    %ecx,(%rdx)
  800b01:	eb 17                	jmp    800b1a <getint+0x102>
  800b03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b07:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b0b:	48 89 d0             	mov    %rdx,%rax
  800b0e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b16:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b1a:	8b 00                	mov    (%rax),%eax
  800b1c:	48 98                	cltq   
  800b1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b26:	c9                   	leaveq 
  800b27:	c3                   	retq   

0000000000800b28 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b28:	55                   	push   %rbp
  800b29:	48 89 e5             	mov    %rsp,%rbp
  800b2c:	41 54                	push   %r12
  800b2e:	53                   	push   %rbx
  800b2f:	48 83 ec 60          	sub    $0x60,%rsp
  800b33:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b37:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b3b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b3f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b43:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b47:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b4b:	48 8b 0a             	mov    (%rdx),%rcx
  800b4e:	48 89 08             	mov    %rcx,(%rax)
  800b51:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b55:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b59:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b5d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b61:	eb 17                	jmp    800b7a <vprintfmt+0x52>
			if (ch == '\0')
  800b63:	85 db                	test   %ebx,%ebx
  800b65:	0f 84 ea 04 00 00    	je     801055 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800b6b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b6f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b73:	48 89 c6             	mov    %rax,%rsi
  800b76:	89 df                	mov    %ebx,%edi
  800b78:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b7e:	0f b6 00             	movzbl (%rax),%eax
  800b81:	0f b6 d8             	movzbl %al,%ebx
  800b84:	83 fb 25             	cmp    $0x25,%ebx
  800b87:	0f 95 c0             	setne  %al
  800b8a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b8f:	84 c0                	test   %al,%al
  800b91:	75 d0                	jne    800b63 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b93:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b97:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b9e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800ba5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800bac:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800bb3:	eb 04                	jmp    800bb9 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800bb5:	90                   	nop
  800bb6:	eb 01                	jmp    800bb9 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800bb8:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bb9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bbd:	0f b6 00             	movzbl (%rax),%eax
  800bc0:	0f b6 d8             	movzbl %al,%ebx
  800bc3:	89 d8                	mov    %ebx,%eax
  800bc5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800bca:	83 e8 23             	sub    $0x23,%eax
  800bcd:	83 f8 55             	cmp    $0x55,%eax
  800bd0:	0f 87 4b 04 00 00    	ja     801021 <vprintfmt+0x4f9>
  800bd6:	89 c0                	mov    %eax,%eax
  800bd8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bdf:	00 
  800be0:	48 b8 d8 43 80 00 00 	movabs $0x8043d8,%rax
  800be7:	00 00 00 
  800bea:	48 01 d0             	add    %rdx,%rax
  800bed:	48 8b 00             	mov    (%rax),%rax
  800bf0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bf2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bf6:	eb c1                	jmp    800bb9 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bf8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bfc:	eb bb                	jmp    800bb9 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bfe:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c05:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c08:	89 d0                	mov    %edx,%eax
  800c0a:	c1 e0 02             	shl    $0x2,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d8                	add    %ebx,%eax
  800c13:	83 e8 30             	sub    $0x30,%eax
  800c16:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c19:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c1d:	0f b6 00             	movzbl (%rax),%eax
  800c20:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c23:	83 fb 2f             	cmp    $0x2f,%ebx
  800c26:	7e 63                	jle    800c8b <vprintfmt+0x163>
  800c28:	83 fb 39             	cmp    $0x39,%ebx
  800c2b:	7f 5e                	jg     800c8b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c32:	eb d1                	jmp    800c05 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800c34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c37:	83 f8 30             	cmp    $0x30,%eax
  800c3a:	73 17                	jae    800c53 <vprintfmt+0x12b>
  800c3c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c43:	89 c0                	mov    %eax,%eax
  800c45:	48 01 d0             	add    %rdx,%rax
  800c48:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c4b:	83 c2 08             	add    $0x8,%edx
  800c4e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c51:	eb 0f                	jmp    800c62 <vprintfmt+0x13a>
  800c53:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c57:	48 89 d0             	mov    %rdx,%rax
  800c5a:	48 83 c2 08          	add    $0x8,%rdx
  800c5e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c62:	8b 00                	mov    (%rax),%eax
  800c64:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c67:	eb 23                	jmp    800c8c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800c69:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c6d:	0f 89 42 ff ff ff    	jns    800bb5 <vprintfmt+0x8d>
				width = 0;
  800c73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c7a:	e9 36 ff ff ff       	jmpq   800bb5 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800c7f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c86:	e9 2e ff ff ff       	jmpq   800bb9 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c8b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c90:	0f 89 22 ff ff ff    	jns    800bb8 <vprintfmt+0x90>
				width = precision, precision = -1;
  800c96:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c99:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c9c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ca3:	e9 10 ff ff ff       	jmpq   800bb8 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ca8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800cac:	e9 08 ff ff ff       	jmpq   800bb9 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800cb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb4:	83 f8 30             	cmp    $0x30,%eax
  800cb7:	73 17                	jae    800cd0 <vprintfmt+0x1a8>
  800cb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc0:	89 c0                	mov    %eax,%eax
  800cc2:	48 01 d0             	add    %rdx,%rax
  800cc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc8:	83 c2 08             	add    $0x8,%edx
  800ccb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cce:	eb 0f                	jmp    800cdf <vprintfmt+0x1b7>
  800cd0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd4:	48 89 d0             	mov    %rdx,%rax
  800cd7:	48 83 c2 08          	add    $0x8,%rdx
  800cdb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cdf:	8b 00                	mov    (%rax),%eax
  800ce1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce5:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800ce9:	48 89 d6             	mov    %rdx,%rsi
  800cec:	89 c7                	mov    %eax,%edi
  800cee:	ff d1                	callq  *%rcx
			break;
  800cf0:	e9 5a 03 00 00       	jmpq   80104f <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cf5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf8:	83 f8 30             	cmp    $0x30,%eax
  800cfb:	73 17                	jae    800d14 <vprintfmt+0x1ec>
  800cfd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d04:	89 c0                	mov    %eax,%eax
  800d06:	48 01 d0             	add    %rdx,%rax
  800d09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d0c:	83 c2 08             	add    $0x8,%edx
  800d0f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d12:	eb 0f                	jmp    800d23 <vprintfmt+0x1fb>
  800d14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d18:	48 89 d0             	mov    %rdx,%rax
  800d1b:	48 83 c2 08          	add    $0x8,%rdx
  800d1f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d23:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d25:	85 db                	test   %ebx,%ebx
  800d27:	79 02                	jns    800d2b <vprintfmt+0x203>
				err = -err;
  800d29:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d2b:	83 fb 15             	cmp    $0x15,%ebx
  800d2e:	7f 16                	jg     800d46 <vprintfmt+0x21e>
  800d30:	48 b8 00 43 80 00 00 	movabs $0x804300,%rax
  800d37:	00 00 00 
  800d3a:	48 63 d3             	movslq %ebx,%rdx
  800d3d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d41:	4d 85 e4             	test   %r12,%r12
  800d44:	75 2e                	jne    800d74 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800d46:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4e:	89 d9                	mov    %ebx,%ecx
  800d50:	48 ba c1 43 80 00 00 	movabs $0x8043c1,%rdx
  800d57:	00 00 00 
  800d5a:	48 89 c7             	mov    %rax,%rdi
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	49 b8 5f 10 80 00 00 	movabs $0x80105f,%r8
  800d69:	00 00 00 
  800d6c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d6f:	e9 db 02 00 00       	jmpq   80104f <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d74:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7c:	4c 89 e1             	mov    %r12,%rcx
  800d7f:	48 ba ca 43 80 00 00 	movabs $0x8043ca,%rdx
  800d86:	00 00 00 
  800d89:	48 89 c7             	mov    %rax,%rdi
  800d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d91:	49 b8 5f 10 80 00 00 	movabs $0x80105f,%r8
  800d98:	00 00 00 
  800d9b:	41 ff d0             	callq  *%r8
			break;
  800d9e:	e9 ac 02 00 00       	jmpq   80104f <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800da3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da6:	83 f8 30             	cmp    $0x30,%eax
  800da9:	73 17                	jae    800dc2 <vprintfmt+0x29a>
  800dab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800daf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db2:	89 c0                	mov    %eax,%eax
  800db4:	48 01 d0             	add    %rdx,%rax
  800db7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dba:	83 c2 08             	add    $0x8,%edx
  800dbd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dc0:	eb 0f                	jmp    800dd1 <vprintfmt+0x2a9>
  800dc2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc6:	48 89 d0             	mov    %rdx,%rax
  800dc9:	48 83 c2 08          	add    $0x8,%rdx
  800dcd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd1:	4c 8b 20             	mov    (%rax),%r12
  800dd4:	4d 85 e4             	test   %r12,%r12
  800dd7:	75 0a                	jne    800de3 <vprintfmt+0x2bb>
				p = "(null)";
  800dd9:	49 bc cd 43 80 00 00 	movabs $0x8043cd,%r12
  800de0:	00 00 00 
			if (width > 0 && padc != '-')
  800de3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800de7:	7e 7a                	jle    800e63 <vprintfmt+0x33b>
  800de9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ded:	74 74                	je     800e63 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800def:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800df2:	48 98                	cltq   
  800df4:	48 89 c6             	mov    %rax,%rsi
  800df7:	4c 89 e7             	mov    %r12,%rdi
  800dfa:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  800e01:	00 00 00 
  800e04:	ff d0                	callq  *%rax
  800e06:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e09:	eb 17                	jmp    800e22 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800e0b:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800e0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e13:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800e17:	48 89 d6             	mov    %rdx,%rsi
  800e1a:	89 c7                	mov    %eax,%edi
  800e1c:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e26:	7f e3                	jg     800e0b <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e28:	eb 39                	jmp    800e63 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e2e:	74 1e                	je     800e4e <vprintfmt+0x326>
  800e30:	83 fb 1f             	cmp    $0x1f,%ebx
  800e33:	7e 05                	jle    800e3a <vprintfmt+0x312>
  800e35:	83 fb 7e             	cmp    $0x7e,%ebx
  800e38:	7e 14                	jle    800e4e <vprintfmt+0x326>
					putch('?', putdat);
  800e3a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e3e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e42:	48 89 c6             	mov    %rax,%rsi
  800e45:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e4a:	ff d2                	callq  *%rdx
  800e4c:	eb 0f                	jmp    800e5d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800e4e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e52:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e56:	48 89 c6             	mov    %rax,%rsi
  800e59:	89 df                	mov    %ebx,%edi
  800e5b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e5d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e61:	eb 01                	jmp    800e64 <vprintfmt+0x33c>
  800e63:	90                   	nop
  800e64:	41 0f b6 04 24       	movzbl (%r12),%eax
  800e69:	0f be d8             	movsbl %al,%ebx
  800e6c:	85 db                	test   %ebx,%ebx
  800e6e:	0f 95 c0             	setne  %al
  800e71:	49 83 c4 01          	add    $0x1,%r12
  800e75:	84 c0                	test   %al,%al
  800e77:	74 28                	je     800ea1 <vprintfmt+0x379>
  800e79:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e7d:	78 ab                	js     800e2a <vprintfmt+0x302>
  800e7f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e83:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e87:	79 a1                	jns    800e2a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e89:	eb 16                	jmp    800ea1 <vprintfmt+0x379>
				putch(' ', putdat);
  800e8b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e8f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e93:	48 89 c6             	mov    %rax,%rsi
  800e96:	bf 20 00 00 00       	mov    $0x20,%edi
  800e9b:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e9d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ea1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ea5:	7f e4                	jg     800e8b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800ea7:	e9 a3 01 00 00       	jmpq   80104f <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800eac:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eb0:	be 03 00 00 00       	mov    $0x3,%esi
  800eb5:	48 89 c7             	mov    %rax,%rdi
  800eb8:	48 b8 18 0a 80 00 00 	movabs $0x800a18,%rax
  800ebf:	00 00 00 
  800ec2:	ff d0                	callq  *%rax
  800ec4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ec8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ecc:	48 85 c0             	test   %rax,%rax
  800ecf:	79 1d                	jns    800eee <vprintfmt+0x3c6>
				putch('-', putdat);
  800ed1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ed5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ed9:	48 89 c6             	mov    %rax,%rsi
  800edc:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ee1:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800ee3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee7:	48 f7 d8             	neg    %rax
  800eea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eee:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ef5:	e9 e8 00 00 00       	jmpq   800fe2 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800efa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800efe:	be 03 00 00 00       	mov    $0x3,%esi
  800f03:	48 89 c7             	mov    %rax,%rdi
  800f06:	48 b8 08 09 80 00 00 	movabs $0x800908,%rax
  800f0d:	00 00 00 
  800f10:	ff d0                	callq  *%rax
  800f12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f16:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f1d:	e9 c0 00 00 00       	jmpq   800fe2 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f22:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f26:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f2a:	48 89 c6             	mov    %rax,%rsi
  800f2d:	bf 58 00 00 00       	mov    $0x58,%edi
  800f32:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800f34:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f38:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f3c:	48 89 c6             	mov    %rax,%rsi
  800f3f:	bf 58 00 00 00       	mov    $0x58,%edi
  800f44:	ff d2                	callq  *%rdx
			putch('X', putdat);
  800f46:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f4a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f4e:	48 89 c6             	mov    %rax,%rsi
  800f51:	bf 58 00 00 00       	mov    $0x58,%edi
  800f56:	ff d2                	callq  *%rdx
			break;
  800f58:	e9 f2 00 00 00       	jmpq   80104f <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  800f5d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f61:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f65:	48 89 c6             	mov    %rax,%rsi
  800f68:	bf 30 00 00 00       	mov    $0x30,%edi
  800f6d:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800f6f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f73:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f77:	48 89 c6             	mov    %rax,%rsi
  800f7a:	bf 78 00 00 00       	mov    $0x78,%edi
  800f7f:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f84:	83 f8 30             	cmp    $0x30,%eax
  800f87:	73 17                	jae    800fa0 <vprintfmt+0x478>
  800f89:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f90:	89 c0                	mov    %eax,%eax
  800f92:	48 01 d0             	add    %rdx,%rax
  800f95:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f98:	83 c2 08             	add    $0x8,%edx
  800f9b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f9e:	eb 0f                	jmp    800faf <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  800fa0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fa4:	48 89 d0             	mov    %rdx,%rax
  800fa7:	48 83 c2 08          	add    $0x8,%rdx
  800fab:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800faf:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fb2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800fb6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fbd:	eb 23                	jmp    800fe2 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800fbf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fc3:	be 03 00 00 00       	mov    $0x3,%esi
  800fc8:	48 89 c7             	mov    %rax,%rdi
  800fcb:	48 b8 08 09 80 00 00 	movabs $0x800908,%rax
  800fd2:	00 00 00 
  800fd5:	ff d0                	callq  *%rax
  800fd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fdb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fe2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fe7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fea:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ff1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ff5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ff9:	45 89 c1             	mov    %r8d,%r9d
  800ffc:	41 89 f8             	mov    %edi,%r8d
  800fff:	48 89 c7             	mov    %rax,%rdi
  801002:	48 b8 50 08 80 00 00 	movabs $0x800850,%rax
  801009:	00 00 00 
  80100c:	ff d0                	callq  *%rax
			break;
  80100e:	eb 3f                	jmp    80104f <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801010:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801014:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801018:	48 89 c6             	mov    %rax,%rsi
  80101b:	89 df                	mov    %ebx,%edi
  80101d:	ff d2                	callq  *%rdx
			break;
  80101f:	eb 2e                	jmp    80104f <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801021:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801025:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801029:	48 89 c6             	mov    %rax,%rsi
  80102c:	bf 25 00 00 00       	mov    $0x25,%edi
  801031:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801033:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801038:	eb 05                	jmp    80103f <vprintfmt+0x517>
  80103a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80103f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801043:	48 83 e8 01          	sub    $0x1,%rax
  801047:	0f b6 00             	movzbl (%rax),%eax
  80104a:	3c 25                	cmp    $0x25,%al
  80104c:	75 ec                	jne    80103a <vprintfmt+0x512>
				/* do nothing */;
			break;
  80104e:	90                   	nop
		}
	}
  80104f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801050:	e9 25 fb ff ff       	jmpq   800b7a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801055:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801056:	48 83 c4 60          	add    $0x60,%rsp
  80105a:	5b                   	pop    %rbx
  80105b:	41 5c                	pop    %r12
  80105d:	5d                   	pop    %rbp
  80105e:	c3                   	retq   

000000000080105f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80105f:	55                   	push   %rbp
  801060:	48 89 e5             	mov    %rsp,%rbp
  801063:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80106a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801071:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801078:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80107f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801086:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80108d:	84 c0                	test   %al,%al
  80108f:	74 20                	je     8010b1 <printfmt+0x52>
  801091:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801095:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801099:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80109d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010a1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010a5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010a9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010ad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010b1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010b8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010bf:	00 00 00 
  8010c2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010c9:	00 00 00 
  8010cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010d0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010d7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010de:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010e5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010ec:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010f3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010fa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801101:	48 89 c7             	mov    %rax,%rdi
  801104:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  80110b:	00 00 00 
  80110e:	ff d0                	callq  *%rax
	va_end(ap);
}
  801110:	c9                   	leaveq 
  801111:	c3                   	retq   

0000000000801112 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801112:	55                   	push   %rbp
  801113:	48 89 e5             	mov    %rsp,%rbp
  801116:	48 83 ec 10          	sub    $0x10,%rsp
  80111a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80111d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801121:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801125:	8b 40 10             	mov    0x10(%rax),%eax
  801128:	8d 50 01             	lea    0x1(%rax),%edx
  80112b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80112f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801132:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801136:	48 8b 10             	mov    (%rax),%rdx
  801139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80113d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801141:	48 39 c2             	cmp    %rax,%rdx
  801144:	73 17                	jae    80115d <sprintputch+0x4b>
		*b->buf++ = ch;
  801146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80114a:	48 8b 00             	mov    (%rax),%rax
  80114d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801150:	88 10                	mov    %dl,(%rax)
  801152:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115a:	48 89 10             	mov    %rdx,(%rax)
}
  80115d:	c9                   	leaveq 
  80115e:	c3                   	retq   

000000000080115f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80115f:	55                   	push   %rbp
  801160:	48 89 e5             	mov    %rsp,%rbp
  801163:	48 83 ec 50          	sub    $0x50,%rsp
  801167:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80116b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80116e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801172:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801176:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80117a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80117e:	48 8b 0a             	mov    (%rdx),%rcx
  801181:	48 89 08             	mov    %rcx,(%rax)
  801184:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801188:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80118c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801190:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801194:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801198:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80119c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80119f:	48 98                	cltq   
  8011a1:	48 83 e8 01          	sub    $0x1,%rax
  8011a5:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8011a9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011b4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011b9:	74 06                	je     8011c1 <vsnprintf+0x62>
  8011bb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011bf:	7f 07                	jg     8011c8 <vsnprintf+0x69>
		return -E_INVAL;
  8011c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c6:	eb 2f                	jmp    8011f7 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011c8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011cc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011d0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011d4:	48 89 c6             	mov    %rax,%rsi
  8011d7:	48 bf 12 11 80 00 00 	movabs $0x801112,%rdi
  8011de:	00 00 00 
  8011e1:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  8011e8:	00 00 00 
  8011eb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011f1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011f4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011f7:	c9                   	leaveq 
  8011f8:	c3                   	retq   

00000000008011f9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011f9:	55                   	push   %rbp
  8011fa:	48 89 e5             	mov    %rsp,%rbp
  8011fd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801204:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80120b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801211:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801218:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80121f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801226:	84 c0                	test   %al,%al
  801228:	74 20                	je     80124a <snprintf+0x51>
  80122a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80122e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801232:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801236:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80123a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80123e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801242:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801246:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80124a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801251:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801258:	00 00 00 
  80125b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801262:	00 00 00 
  801265:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801269:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801270:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801277:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80127e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801285:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80128c:	48 8b 0a             	mov    (%rdx),%rcx
  80128f:	48 89 08             	mov    %rcx,(%rax)
  801292:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801296:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80129a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80129e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012a2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012a9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012b0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012b6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012bd:	48 89 c7             	mov    %rax,%rdi
  8012c0:	48 b8 5f 11 80 00 00 	movabs $0x80115f,%rax
  8012c7:	00 00 00 
  8012ca:	ff d0                	callq  *%rax
  8012cc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012d2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012d8:	c9                   	leaveq 
  8012d9:	c3                   	retq   
	...

00000000008012dc <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	48 83 ec 20          	sub    $0x20,%rsp
  8012e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ed:	74 27                	je     801316 <readline+0x3a>
		fprintf(1, "%s", prompt);
  8012ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f3:	48 89 c2             	mov    %rax,%rdx
  8012f6:	48 be 88 46 80 00 00 	movabs $0x804688,%rsi
  8012fd:	00 00 00 
  801300:	bf 01 00 00 00       	mov    $0x1,%edi
  801305:	b8 00 00 00 00       	mov    $0x0,%eax
  80130a:	48 b9 f0 2e 80 00 00 	movabs $0x802ef0,%rcx
  801311:	00 00 00 
  801314:	ff d1                	callq  *%rcx
#endif

	i = 0;
  801316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  80131d:	bf 00 00 00 00       	mov    $0x0,%edi
  801322:	48 b8 30 02 80 00 00 	movabs $0x800230,%rax
  801329:	00 00 00 
  80132c:	ff d0                	callq  *%rax
  80132e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801331:	eb 01                	jmp    801334 <readline+0x58>
			if (echoing)
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
  801333:	90                   	nop
#endif

	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
  801334:	48 b8 e7 01 80 00 00 	movabs $0x8001e7,%rax
  80133b:	00 00 00 
  80133e:	ff d0                	callq  *%rax
  801340:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  801343:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801347:	79 30                	jns    801379 <readline+0x9d>
			if (c != -E_EOF)
  801349:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  80134d:	74 20                	je     80136f <readline+0x93>
				cprintf("read error: %e\n", c);
  80134f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801352:	89 c6                	mov    %eax,%esi
  801354:	48 bf 8b 46 80 00 00 	movabs $0x80468b,%rdi
  80135b:	00 00 00 
  80135e:	b8 00 00 00 00       	mov    $0x0,%eax
  801363:	48 ba 77 07 80 00 00 	movabs $0x800777,%rdx
  80136a:	00 00 00 
  80136d:	ff d2                	callq  *%rdx
			return NULL;
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
  801374:	e9 c0 00 00 00       	jmpq   801439 <readline+0x15d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801379:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  80137d:	74 06                	je     801385 <readline+0xa9>
  80137f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  801383:	75 26                	jne    8013ab <readline+0xcf>
  801385:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801389:	7e 20                	jle    8013ab <readline+0xcf>
			if (echoing)
  80138b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80138f:	74 11                	je     8013a2 <readline+0xc6>
				cputchar('\b');
  801391:	bf 08 00 00 00       	mov    $0x8,%edi
  801396:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  80139d:	00 00 00 
  8013a0:	ff d0                	callq  *%rax
			i--;
  8013a2:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  8013a6:	e9 89 00 00 00       	jmpq   801434 <readline+0x158>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013ab:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8013af:	7e 3d                	jle    8013ee <readline+0x112>
  8013b1:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  8013b8:	7f 34                	jg     8013ee <readline+0x112>
			if (echoing)
  8013ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013be:	74 11                	je     8013d1 <readline+0xf5>
				cputchar(c);
  8013c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c3:	89 c7                	mov    %eax,%edi
  8013c5:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  8013cc:	00 00 00 
  8013cf:	ff d0                	callq  *%rax
			buf[i++] = c;
  8013d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d4:	89 c1                	mov    %eax,%ecx
  8013d6:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8013dd:	00 00 00 
  8013e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013e3:	48 98                	cltq   
  8013e5:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8013e8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8013ec:	eb 46                	jmp    801434 <readline+0x158>
		} else if (c == '\n' || c == '\r') {
  8013ee:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8013f2:	74 0a                	je     8013fe <readline+0x122>
  8013f4:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8013f8:	0f 85 35 ff ff ff    	jne    801333 <readline+0x57>
			if (echoing)
  8013fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801402:	74 11                	je     801415 <readline+0x139>
				cputchar('\n');
  801404:	bf 0a 00 00 00       	mov    $0xa,%edi
  801409:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  801410:	00 00 00 
  801413:	ff d0                	callq  *%rax
			buf[i] = 0;
  801415:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80141c:	00 00 00 
  80141f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801422:	48 98                	cltq   
  801424:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  801428:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80142f:	00 00 00 
  801432:	eb 05                	jmp    801439 <readline+0x15d>
		}
	}
  801434:	e9 fa fe ff ff       	jmpq   801333 <readline+0x57>
}
  801439:	c9                   	leaveq 
  80143a:	c3                   	retq   
	...

000000000080143c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80143c:	55                   	push   %rbp
  80143d:	48 89 e5             	mov    %rsp,%rbp
  801440:	48 83 ec 18          	sub    $0x18,%rsp
  801444:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801448:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80144f:	eb 09                	jmp    80145a <strlen+0x1e>
		n++;
  801451:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801455:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80145a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	84 c0                	test   %al,%al
  801463:	75 ec                	jne    801451 <strlen+0x15>
		n++;
	return n;
  801465:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801468:	c9                   	leaveq 
  801469:	c3                   	retq   

000000000080146a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80146a:	55                   	push   %rbp
  80146b:	48 89 e5             	mov    %rsp,%rbp
  80146e:	48 83 ec 20          	sub    $0x20,%rsp
  801472:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801476:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80147a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801481:	eb 0e                	jmp    801491 <strnlen+0x27>
		n++;
  801483:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801487:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80148c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801491:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801496:	74 0b                	je     8014a3 <strnlen+0x39>
  801498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149c:	0f b6 00             	movzbl (%rax),%eax
  80149f:	84 c0                	test   %al,%al
  8014a1:	75 e0                	jne    801483 <strnlen+0x19>
		n++;
	return n;
  8014a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014a6:	c9                   	leaveq 
  8014a7:	c3                   	retq   

00000000008014a8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014a8:	55                   	push   %rbp
  8014a9:	48 89 e5             	mov    %rsp,%rbp
  8014ac:	48 83 ec 20          	sub    $0x20,%rsp
  8014b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8014b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8014c0:	90                   	nop
  8014c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014c5:	0f b6 10             	movzbl (%rax),%edx
  8014c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cc:	88 10                	mov    %dl,(%rax)
  8014ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	84 c0                	test   %al,%al
  8014d7:	0f 95 c0             	setne  %al
  8014da:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014df:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8014e4:	84 c0                	test   %al,%al
  8014e6:	75 d9                	jne    8014c1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8014e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014ec:	c9                   	leaveq 
  8014ed:	c3                   	retq   

00000000008014ee <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014ee:	55                   	push   %rbp
  8014ef:	48 89 e5             	mov    %rsp,%rbp
  8014f2:	48 83 ec 20          	sub    $0x20,%rsp
  8014f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801502:	48 89 c7             	mov    %rax,%rdi
  801505:	48 b8 3c 14 80 00 00 	movabs $0x80143c,%rax
  80150c:	00 00 00 
  80150f:	ff d0                	callq  *%rax
  801511:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801514:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801517:	48 98                	cltq   
  801519:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80151d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801521:	48 89 d6             	mov    %rdx,%rsi
  801524:	48 89 c7             	mov    %rax,%rdi
  801527:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  80152e:	00 00 00 
  801531:	ff d0                	callq  *%rax
	return dst;
  801533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801537:	c9                   	leaveq 
  801538:	c3                   	retq   

0000000000801539 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801539:	55                   	push   %rbp
  80153a:	48 89 e5             	mov    %rsp,%rbp
  80153d:	48 83 ec 28          	sub    $0x28,%rsp
  801541:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801545:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801549:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80154d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801551:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801555:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80155c:	00 
  80155d:	eb 27                	jmp    801586 <strncpy+0x4d>
		*dst++ = *src;
  80155f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801563:	0f b6 10             	movzbl (%rax),%edx
  801566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156a:	88 10                	mov    %dl,(%rax)
  80156c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801571:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801575:	0f b6 00             	movzbl (%rax),%eax
  801578:	84 c0                	test   %al,%al
  80157a:	74 05                	je     801581 <strncpy+0x48>
			src++;
  80157c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801581:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80158e:	72 cf                	jb     80155f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801594:	c9                   	leaveq 
  801595:	c3                   	retq   

0000000000801596 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801596:	55                   	push   %rbp
  801597:	48 89 e5             	mov    %rsp,%rbp
  80159a:	48 83 ec 28          	sub    $0x28,%rsp
  80159e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8015aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8015b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015b7:	74 37                	je     8015f0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8015b9:	eb 17                	jmp    8015d2 <strlcpy+0x3c>
			*dst++ = *src++;
  8015bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015bf:	0f b6 10             	movzbl (%rax),%edx
  8015c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c6:	88 10                	mov    %dl,(%rax)
  8015c8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015cd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015d2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015dc:	74 0b                	je     8015e9 <strlcpy+0x53>
  8015de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015e2:	0f b6 00             	movzbl (%rax),%eax
  8015e5:	84 c0                	test   %al,%al
  8015e7:	75 d2                	jne    8015bb <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ed:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f8:	48 89 d1             	mov    %rdx,%rcx
  8015fb:	48 29 c1             	sub    %rax,%rcx
  8015fe:	48 89 c8             	mov    %rcx,%rax
}
  801601:	c9                   	leaveq 
  801602:	c3                   	retq   

0000000000801603 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801603:	55                   	push   %rbp
  801604:	48 89 e5             	mov    %rsp,%rbp
  801607:	48 83 ec 10          	sub    $0x10,%rsp
  80160b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80160f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801613:	eb 0a                	jmp    80161f <strcmp+0x1c>
		p++, q++;
  801615:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80161a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80161f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	84 c0                	test   %al,%al
  801628:	74 12                	je     80163c <strcmp+0x39>
  80162a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162e:	0f b6 10             	movzbl (%rax),%edx
  801631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	38 c2                	cmp    %al,%dl
  80163a:	74 d9                	je     801615 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80163c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801640:	0f b6 00             	movzbl (%rax),%eax
  801643:	0f b6 d0             	movzbl %al,%edx
  801646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	0f b6 c0             	movzbl %al,%eax
  801650:	89 d1                	mov    %edx,%ecx
  801652:	29 c1                	sub    %eax,%ecx
  801654:	89 c8                	mov    %ecx,%eax
}
  801656:	c9                   	leaveq 
  801657:	c3                   	retq   

0000000000801658 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801658:	55                   	push   %rbp
  801659:	48 89 e5             	mov    %rsp,%rbp
  80165c:	48 83 ec 18          	sub    $0x18,%rsp
  801660:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801664:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801668:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80166c:	eb 0f                	jmp    80167d <strncmp+0x25>
		n--, p++, q++;
  80166e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801673:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801678:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80167d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801682:	74 1d                	je     8016a1 <strncmp+0x49>
  801684:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	84 c0                	test   %al,%al
  80168d:	74 12                	je     8016a1 <strncmp+0x49>
  80168f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801693:	0f b6 10             	movzbl (%rax),%edx
  801696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	38 c2                	cmp    %al,%dl
  80169f:	74 cd                	je     80166e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8016a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016a6:	75 07                	jne    8016af <strncmp+0x57>
		return 0;
  8016a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ad:	eb 1a                	jmp    8016c9 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b3:	0f b6 00             	movzbl (%rax),%eax
  8016b6:	0f b6 d0             	movzbl %al,%edx
  8016b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	0f b6 c0             	movzbl %al,%eax
  8016c3:	89 d1                	mov    %edx,%ecx
  8016c5:	29 c1                	sub    %eax,%ecx
  8016c7:	89 c8                	mov    %ecx,%eax
}
  8016c9:	c9                   	leaveq 
  8016ca:	c3                   	retq   

00000000008016cb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016cb:	55                   	push   %rbp
  8016cc:	48 89 e5             	mov    %rsp,%rbp
  8016cf:	48 83 ec 10          	sub    $0x10,%rsp
  8016d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d7:	89 f0                	mov    %esi,%eax
  8016d9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016dc:	eb 17                	jmp    8016f5 <strchr+0x2a>
		if (*s == c)
  8016de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e2:	0f b6 00             	movzbl (%rax),%eax
  8016e5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016e8:	75 06                	jne    8016f0 <strchr+0x25>
			return (char *) s;
  8016ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ee:	eb 15                	jmp    801705 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f9:	0f b6 00             	movzbl (%rax),%eax
  8016fc:	84 c0                	test   %al,%al
  8016fe:	75 de                	jne    8016de <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801705:	c9                   	leaveq 
  801706:	c3                   	retq   

0000000000801707 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801707:	55                   	push   %rbp
  801708:	48 89 e5             	mov    %rsp,%rbp
  80170b:	48 83 ec 10          	sub    $0x10,%rsp
  80170f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801713:	89 f0                	mov    %esi,%eax
  801715:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801718:	eb 11                	jmp    80172b <strfind+0x24>
		if (*s == c)
  80171a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171e:	0f b6 00             	movzbl (%rax),%eax
  801721:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801724:	74 12                	je     801738 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801726:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80172b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172f:	0f b6 00             	movzbl (%rax),%eax
  801732:	84 c0                	test   %al,%al
  801734:	75 e4                	jne    80171a <strfind+0x13>
  801736:	eb 01                	jmp    801739 <strfind+0x32>
		if (*s == c)
			break;
  801738:	90                   	nop
	return (char *) s;
  801739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80173d:	c9                   	leaveq 
  80173e:	c3                   	retq   

000000000080173f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 18          	sub    $0x18,%rsp
  801747:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80174b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80174e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801752:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801757:	75 06                	jne    80175f <memset+0x20>
		return v;
  801759:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175d:	eb 69                	jmp    8017c8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80175f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801763:	83 e0 03             	and    $0x3,%eax
  801766:	48 85 c0             	test   %rax,%rax
  801769:	75 48                	jne    8017b3 <memset+0x74>
  80176b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176f:	83 e0 03             	and    $0x3,%eax
  801772:	48 85 c0             	test   %rax,%rax
  801775:	75 3c                	jne    8017b3 <memset+0x74>
		c &= 0xFF;
  801777:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80177e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801781:	89 c2                	mov    %eax,%edx
  801783:	c1 e2 18             	shl    $0x18,%edx
  801786:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801789:	c1 e0 10             	shl    $0x10,%eax
  80178c:	09 c2                	or     %eax,%edx
  80178e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801791:	c1 e0 08             	shl    $0x8,%eax
  801794:	09 d0                	or     %edx,%eax
  801796:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80179d:	48 89 c1             	mov    %rax,%rcx
  8017a0:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8017a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017ab:	48 89 d7             	mov    %rdx,%rdi
  8017ae:	fc                   	cld    
  8017af:	f3 ab                	rep stos %eax,%es:(%rdi)
  8017b1:	eb 11                	jmp    8017c4 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017ba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8017be:	48 89 d7             	mov    %rdx,%rdi
  8017c1:	fc                   	cld    
  8017c2:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8017c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017c8:	c9                   	leaveq 
  8017c9:	c3                   	retq   

00000000008017ca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017ca:	55                   	push   %rbp
  8017cb:	48 89 e5             	mov    %rsp,%rbp
  8017ce:	48 83 ec 28          	sub    $0x28,%rsp
  8017d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8017de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8017e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017f6:	0f 83 88 00 00 00    	jae    801884 <memmove+0xba>
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801804:	48 01 d0             	add    %rdx,%rax
  801807:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80180b:	76 77                	jbe    801884 <memmove+0xba>
		s += n;
  80180d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801811:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801819:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80181d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801821:	83 e0 03             	and    $0x3,%eax
  801824:	48 85 c0             	test   %rax,%rax
  801827:	75 3b                	jne    801864 <memmove+0x9a>
  801829:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182d:	83 e0 03             	and    $0x3,%eax
  801830:	48 85 c0             	test   %rax,%rax
  801833:	75 2f                	jne    801864 <memmove+0x9a>
  801835:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801839:	83 e0 03             	and    $0x3,%eax
  80183c:	48 85 c0             	test   %rax,%rax
  80183f:	75 23                	jne    801864 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801841:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801845:	48 83 e8 04          	sub    $0x4,%rax
  801849:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80184d:	48 83 ea 04          	sub    $0x4,%rdx
  801851:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801855:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801859:	48 89 c7             	mov    %rax,%rdi
  80185c:	48 89 d6             	mov    %rdx,%rsi
  80185f:	fd                   	std    
  801860:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801862:	eb 1d                	jmp    801881 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801868:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80186c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801870:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801878:	48 89 d7             	mov    %rdx,%rdi
  80187b:	48 89 c1             	mov    %rax,%rcx
  80187e:	fd                   	std    
  80187f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801881:	fc                   	cld    
  801882:	eb 57                	jmp    8018db <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801884:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801888:	83 e0 03             	and    $0x3,%eax
  80188b:	48 85 c0             	test   %rax,%rax
  80188e:	75 36                	jne    8018c6 <memmove+0xfc>
  801890:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801894:	83 e0 03             	and    $0x3,%eax
  801897:	48 85 c0             	test   %rax,%rax
  80189a:	75 2a                	jne    8018c6 <memmove+0xfc>
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	83 e0 03             	and    $0x3,%eax
  8018a3:	48 85 c0             	test   %rax,%rax
  8018a6:	75 1e                	jne    8018c6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ac:	48 89 c1             	mov    %rax,%rcx
  8018af:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8018b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018bb:	48 89 c7             	mov    %rax,%rdi
  8018be:	48 89 d6             	mov    %rdx,%rsi
  8018c1:	fc                   	cld    
  8018c2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018c4:	eb 15                	jmp    8018db <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018ce:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018d2:	48 89 c7             	mov    %rax,%rdi
  8018d5:	48 89 d6             	mov    %rdx,%rsi
  8018d8:	fc                   	cld    
  8018d9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8018db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018df:	c9                   	leaveq 
  8018e0:	c3                   	retq   

00000000008018e1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018e1:	55                   	push   %rbp
  8018e2:	48 89 e5             	mov    %rsp,%rbp
  8018e5:	48 83 ec 18          	sub    $0x18,%rsp
  8018e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801901:	48 89 ce             	mov    %rcx,%rsi
  801904:	48 89 c7             	mov    %rax,%rdi
  801907:	48 b8 ca 17 80 00 00 	movabs $0x8017ca,%rax
  80190e:	00 00 00 
  801911:	ff d0                	callq  *%rax
}
  801913:	c9                   	leaveq 
  801914:	c3                   	retq   

0000000000801915 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	48 83 ec 28          	sub    $0x28,%rsp
  80191d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801921:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801925:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80192d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801931:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801935:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801939:	eb 38                	jmp    801973 <memcmp+0x5e>
		if (*s1 != *s2)
  80193b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80193f:	0f b6 10             	movzbl (%rax),%edx
  801942:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801946:	0f b6 00             	movzbl (%rax),%eax
  801949:	38 c2                	cmp    %al,%dl
  80194b:	74 1c                	je     801969 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80194d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801951:	0f b6 00             	movzbl (%rax),%eax
  801954:	0f b6 d0             	movzbl %al,%edx
  801957:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195b:	0f b6 00             	movzbl (%rax),%eax
  80195e:	0f b6 c0             	movzbl %al,%eax
  801961:	89 d1                	mov    %edx,%ecx
  801963:	29 c1                	sub    %eax,%ecx
  801965:	89 c8                	mov    %ecx,%eax
  801967:	eb 20                	jmp    801989 <memcmp+0x74>
		s1++, s2++;
  801969:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80196e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801973:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801978:	0f 95 c0             	setne  %al
  80197b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801980:	84 c0                	test   %al,%al
  801982:	75 b7                	jne    80193b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801984:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801989:	c9                   	leaveq 
  80198a:	c3                   	retq   

000000000080198b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80198b:	55                   	push   %rbp
  80198c:	48 89 e5             	mov    %rsp,%rbp
  80198f:	48 83 ec 28          	sub    $0x28,%rsp
  801993:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801997:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80199a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80199e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019a6:	48 01 d0             	add    %rdx,%rax
  8019a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8019ad:	eb 13                	jmp    8019c2 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b3:	0f b6 10             	movzbl (%rax),%edx
  8019b6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019b9:	38 c2                	cmp    %al,%dl
  8019bb:	74 11                	je     8019ce <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8019c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8019ca:	72 e3                	jb     8019af <memfind+0x24>
  8019cc:	eb 01                	jmp    8019cf <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019ce:	90                   	nop
	return (void *) s;
  8019cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019d3:	c9                   	leaveq 
  8019d4:	c3                   	retq   

00000000008019d5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019d5:	55                   	push   %rbp
  8019d6:	48 89 e5             	mov    %rsp,%rbp
  8019d9:	48 83 ec 38          	sub    $0x38,%rsp
  8019dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019e5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8019e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8019ef:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019f6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019f7:	eb 05                	jmp    8019fe <strtol+0x29>
		s++;
  8019f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a02:	0f b6 00             	movzbl (%rax),%eax
  801a05:	3c 20                	cmp    $0x20,%al
  801a07:	74 f0                	je     8019f9 <strtol+0x24>
  801a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0d:	0f b6 00             	movzbl (%rax),%eax
  801a10:	3c 09                	cmp    $0x9,%al
  801a12:	74 e5                	je     8019f9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a18:	0f b6 00             	movzbl (%rax),%eax
  801a1b:	3c 2b                	cmp    $0x2b,%al
  801a1d:	75 07                	jne    801a26 <strtol+0x51>
		s++;
  801a1f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a24:	eb 17                	jmp    801a3d <strtol+0x68>
	else if (*s == '-')
  801a26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2a:	0f b6 00             	movzbl (%rax),%eax
  801a2d:	3c 2d                	cmp    $0x2d,%al
  801a2f:	75 0c                	jne    801a3d <strtol+0x68>
		s++, neg = 1;
  801a31:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a3d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a41:	74 06                	je     801a49 <strtol+0x74>
  801a43:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801a47:	75 28                	jne    801a71 <strtol+0x9c>
  801a49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4d:	0f b6 00             	movzbl (%rax),%eax
  801a50:	3c 30                	cmp    $0x30,%al
  801a52:	75 1d                	jne    801a71 <strtol+0x9c>
  801a54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a58:	48 83 c0 01          	add    $0x1,%rax
  801a5c:	0f b6 00             	movzbl (%rax),%eax
  801a5f:	3c 78                	cmp    $0x78,%al
  801a61:	75 0e                	jne    801a71 <strtol+0x9c>
		s += 2, base = 16;
  801a63:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a68:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a6f:	eb 2c                	jmp    801a9d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a71:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a75:	75 19                	jne    801a90 <strtol+0xbb>
  801a77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7b:	0f b6 00             	movzbl (%rax),%eax
  801a7e:	3c 30                	cmp    $0x30,%al
  801a80:	75 0e                	jne    801a90 <strtol+0xbb>
		s++, base = 8;
  801a82:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a87:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a8e:	eb 0d                	jmp    801a9d <strtol+0xc8>
	else if (base == 0)
  801a90:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a94:	75 07                	jne    801a9d <strtol+0xc8>
		base = 10;
  801a96:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa1:	0f b6 00             	movzbl (%rax),%eax
  801aa4:	3c 2f                	cmp    $0x2f,%al
  801aa6:	7e 1d                	jle    801ac5 <strtol+0xf0>
  801aa8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aac:	0f b6 00             	movzbl (%rax),%eax
  801aaf:	3c 39                	cmp    $0x39,%al
  801ab1:	7f 12                	jg     801ac5 <strtol+0xf0>
			dig = *s - '0';
  801ab3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab7:	0f b6 00             	movzbl (%rax),%eax
  801aba:	0f be c0             	movsbl %al,%eax
  801abd:	83 e8 30             	sub    $0x30,%eax
  801ac0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ac3:	eb 4e                	jmp    801b13 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ac5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac9:	0f b6 00             	movzbl (%rax),%eax
  801acc:	3c 60                	cmp    $0x60,%al
  801ace:	7e 1d                	jle    801aed <strtol+0x118>
  801ad0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad4:	0f b6 00             	movzbl (%rax),%eax
  801ad7:	3c 7a                	cmp    $0x7a,%al
  801ad9:	7f 12                	jg     801aed <strtol+0x118>
			dig = *s - 'a' + 10;
  801adb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801adf:	0f b6 00             	movzbl (%rax),%eax
  801ae2:	0f be c0             	movsbl %al,%eax
  801ae5:	83 e8 57             	sub    $0x57,%eax
  801ae8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801aeb:	eb 26                	jmp    801b13 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801aed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af1:	0f b6 00             	movzbl (%rax),%eax
  801af4:	3c 40                	cmp    $0x40,%al
  801af6:	7e 47                	jle    801b3f <strtol+0x16a>
  801af8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afc:	0f b6 00             	movzbl (%rax),%eax
  801aff:	3c 5a                	cmp    $0x5a,%al
  801b01:	7f 3c                	jg     801b3f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801b03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b07:	0f b6 00             	movzbl (%rax),%eax
  801b0a:	0f be c0             	movsbl %al,%eax
  801b0d:	83 e8 37             	sub    $0x37,%eax
  801b10:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801b13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b16:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b19:	7d 23                	jge    801b3e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801b1b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b20:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801b23:	48 98                	cltq   
  801b25:	48 89 c2             	mov    %rax,%rdx
  801b28:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801b2d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b30:	48 98                	cltq   
  801b32:	48 01 d0             	add    %rdx,%rax
  801b35:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801b39:	e9 5f ff ff ff       	jmpq   801a9d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801b3e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801b3f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801b44:	74 0b                	je     801b51 <strtol+0x17c>
		*endptr = (char *) s;
  801b46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b4a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b4e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b55:	74 09                	je     801b60 <strtol+0x18b>
  801b57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b5b:	48 f7 d8             	neg    %rax
  801b5e:	eb 04                	jmp    801b64 <strtol+0x18f>
  801b60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b64:	c9                   	leaveq 
  801b65:	c3                   	retq   

0000000000801b66 <strstr>:

char * strstr(const char *in, const char *str)
{
  801b66:	55                   	push   %rbp
  801b67:	48 89 e5             	mov    %rsp,%rbp
  801b6a:	48 83 ec 30          	sub    $0x30,%rsp
  801b6e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b72:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b7a:	0f b6 00             	movzbl (%rax),%eax
  801b7d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801b80:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801b85:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b89:	75 06                	jne    801b91 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801b8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b8f:	eb 68                	jmp    801bf9 <strstr+0x93>

	len = strlen(str);
  801b91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b95:	48 89 c7             	mov    %rax,%rdi
  801b98:	48 b8 3c 14 80 00 00 	movabs $0x80143c,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	callq  *%rax
  801ba4:	48 98                	cltq   
  801ba6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801baa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bae:	0f b6 00             	movzbl (%rax),%eax
  801bb1:	88 45 ef             	mov    %al,-0x11(%rbp)
  801bb4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801bb9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801bbd:	75 07                	jne    801bc6 <strstr+0x60>
				return (char *) 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc4:	eb 33                	jmp    801bf9 <strstr+0x93>
		} while (sc != c);
  801bc6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801bca:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801bcd:	75 db                	jne    801baa <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801bcf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801bd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bdb:	48 89 ce             	mov    %rcx,%rsi
  801bde:	48 89 c7             	mov    %rax,%rdi
  801be1:	48 b8 58 16 80 00 00 	movabs $0x801658,%rax
  801be8:	00 00 00 
  801beb:	ff d0                	callq  *%rax
  801bed:	85 c0                	test   %eax,%eax
  801bef:	75 b9                	jne    801baa <strstr+0x44>

	return (char *) (in - 1);
  801bf1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf5:	48 83 e8 01          	sub    $0x1,%rax
}
  801bf9:	c9                   	leaveq 
  801bfa:	c3                   	retq   
	...

0000000000801bfc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801bfc:	55                   	push   %rbp
  801bfd:	48 89 e5             	mov    %rsp,%rbp
  801c00:	53                   	push   %rbx
  801c01:	48 83 ec 58          	sub    $0x58,%rsp
  801c05:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c08:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801c0b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c0f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c13:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801c17:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c1b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c1e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801c21:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c25:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801c29:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801c2d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801c31:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801c35:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801c38:	4c 89 c3             	mov    %r8,%rbx
  801c3b:	cd 30                	int    $0x30
  801c3d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801c41:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801c45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801c49:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c4d:	74 3e                	je     801c8d <syscall+0x91>
  801c4f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c54:	7e 37                	jle    801c8d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c5a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c5d:	49 89 d0             	mov    %rdx,%r8
  801c60:	89 c1                	mov    %eax,%ecx
  801c62:	48 ba 9b 46 80 00 00 	movabs $0x80469b,%rdx
  801c69:	00 00 00 
  801c6c:	be 23 00 00 00       	mov    $0x23,%esi
  801c71:	48 bf b8 46 80 00 00 	movabs $0x8046b8,%rdi
  801c78:	00 00 00 
  801c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c80:	49 b9 3c 05 80 00 00 	movabs $0x80053c,%r9
  801c87:	00 00 00 
  801c8a:	41 ff d1             	callq  *%r9

	return ret;
  801c8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c91:	48 83 c4 58          	add    $0x58,%rsp
  801c95:	5b                   	pop    %rbx
  801c96:	5d                   	pop    %rbp
  801c97:	c3                   	retq   

0000000000801c98 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c98:	55                   	push   %rbp
  801c99:	48 89 e5             	mov    %rsp,%rbp
  801c9c:	48 83 ec 20          	sub    $0x20,%rsp
  801ca0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ca4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ca8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb7:	00 
  801cb8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc4:	48 89 d1             	mov    %rdx,%rcx
  801cc7:	48 89 c2             	mov    %rax,%rdx
  801cca:	be 00 00 00 00       	mov    $0x0,%esi
  801ccf:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd4:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801cdb:	00 00 00 
  801cde:	ff d0                	callq  *%rax
}
  801ce0:	c9                   	leaveq 
  801ce1:	c3                   	retq   

0000000000801ce2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ce2:	55                   	push   %rbp
  801ce3:	48 89 e5             	mov    %rsp,%rbp
  801ce6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801cea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf1:	00 
  801cf2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d03:	ba 00 00 00 00       	mov    $0x0,%edx
  801d08:	be 00 00 00 00       	mov    $0x0,%esi
  801d0d:	bf 01 00 00 00       	mov    $0x1,%edi
  801d12:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801d19:	00 00 00 
  801d1c:	ff d0                	callq  *%rax
}
  801d1e:	c9                   	leaveq 
  801d1f:	c3                   	retq   

0000000000801d20 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d20:	55                   	push   %rbp
  801d21:	48 89 e5             	mov    %rsp,%rbp
  801d24:	48 83 ec 20          	sub    $0x20,%rsp
  801d28:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2e:	48 98                	cltq   
  801d30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d37:	00 
  801d38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d44:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d49:	48 89 c2             	mov    %rax,%rdx
  801d4c:	be 01 00 00 00       	mov    $0x1,%esi
  801d51:	bf 03 00 00 00       	mov    $0x3,%edi
  801d56:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801d5d:	00 00 00 
  801d60:	ff d0                	callq  *%rax
}
  801d62:	c9                   	leaveq 
  801d63:	c3                   	retq   

0000000000801d64 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d64:	55                   	push   %rbp
  801d65:	48 89 e5             	mov    %rsp,%rbp
  801d68:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d73:	00 
  801d74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d80:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d85:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8a:	be 00 00 00 00       	mov    $0x0,%esi
  801d8f:	bf 02 00 00 00       	mov    $0x2,%edi
  801d94:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801d9b:	00 00 00 
  801d9e:	ff d0                	callq  *%rax
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <sys_yield>:

void
sys_yield(void)
{
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801daa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db1:	00 
  801db2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc3:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc8:	be 00 00 00 00       	mov    $0x0,%esi
  801dcd:	bf 0b 00 00 00       	mov    $0xb,%edi
  801dd2:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	callq  *%rax
}
  801dde:	c9                   	leaveq 
  801ddf:	c3                   	retq   

0000000000801de0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801de0:	55                   	push   %rbp
  801de1:	48 89 e5             	mov    %rsp,%rbp
  801de4:	48 83 ec 20          	sub    $0x20,%rsp
  801de8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801deb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801def:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801df2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801df5:	48 63 c8             	movslq %eax,%rcx
  801df8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dff:	48 98                	cltq   
  801e01:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e08:	00 
  801e09:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0f:	49 89 c8             	mov    %rcx,%r8
  801e12:	48 89 d1             	mov    %rdx,%rcx
  801e15:	48 89 c2             	mov    %rax,%rdx
  801e18:	be 01 00 00 00       	mov    $0x1,%esi
  801e1d:	bf 04 00 00 00       	mov    $0x4,%edi
  801e22:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801e29:	00 00 00 
  801e2c:	ff d0                	callq  *%rax
}
  801e2e:	c9                   	leaveq 
  801e2f:	c3                   	retq   

0000000000801e30 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801e30:	55                   	push   %rbp
  801e31:	48 89 e5             	mov    %rsp,%rbp
  801e34:	48 83 ec 30          	sub    $0x30,%rsp
  801e38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e3f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e42:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e46:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801e4a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e4d:	48 63 c8             	movslq %eax,%rcx
  801e50:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e57:	48 63 f0             	movslq %eax,%rsi
  801e5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e61:	48 98                	cltq   
  801e63:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e67:	49 89 f9             	mov    %rdi,%r9
  801e6a:	49 89 f0             	mov    %rsi,%r8
  801e6d:	48 89 d1             	mov    %rdx,%rcx
  801e70:	48 89 c2             	mov    %rax,%rdx
  801e73:	be 01 00 00 00       	mov    $0x1,%esi
  801e78:	bf 05 00 00 00       	mov    $0x5,%edi
  801e7d:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801e84:	00 00 00 
  801e87:	ff d0                	callq  *%rax
}
  801e89:	c9                   	leaveq 
  801e8a:	c3                   	retq   

0000000000801e8b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e8b:	55                   	push   %rbp
  801e8c:	48 89 e5             	mov    %rsp,%rbp
  801e8f:	48 83 ec 20          	sub    $0x20,%rsp
  801e93:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea1:	48 98                	cltq   
  801ea3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eaa:	00 
  801eab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb7:	48 89 d1             	mov    %rdx,%rcx
  801eba:	48 89 c2             	mov    %rax,%rdx
  801ebd:	be 01 00 00 00       	mov    $0x1,%esi
  801ec2:	bf 06 00 00 00       	mov    $0x6,%edi
  801ec7:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801ece:	00 00 00 
  801ed1:	ff d0                	callq  *%rax
}
  801ed3:	c9                   	leaveq 
  801ed4:	c3                   	retq   

0000000000801ed5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ed5:	55                   	push   %rbp
  801ed6:	48 89 e5             	mov    %rsp,%rbp
  801ed9:	48 83 ec 20          	sub    $0x20,%rsp
  801edd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ee3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ee6:	48 63 d0             	movslq %eax,%rdx
  801ee9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eec:	48 98                	cltq   
  801eee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ef5:	00 
  801ef6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801efc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f02:	48 89 d1             	mov    %rdx,%rcx
  801f05:	48 89 c2             	mov    %rax,%rdx
  801f08:	be 01 00 00 00       	mov    $0x1,%esi
  801f0d:	bf 08 00 00 00       	mov    $0x8,%edi
  801f12:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	callq  *%rax
}
  801f1e:	c9                   	leaveq 
  801f1f:	c3                   	retq   

0000000000801f20 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f20:	55                   	push   %rbp
  801f21:	48 89 e5             	mov    %rsp,%rbp
  801f24:	48 83 ec 20          	sub    $0x20,%rsp
  801f28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801f2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f36:	48 98                	cltq   
  801f38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f3f:	00 
  801f40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f4c:	48 89 d1             	mov    %rdx,%rcx
  801f4f:	48 89 c2             	mov    %rax,%rdx
  801f52:	be 01 00 00 00       	mov    $0x1,%esi
  801f57:	bf 09 00 00 00       	mov    $0x9,%edi
  801f5c:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801f63:	00 00 00 
  801f66:	ff d0                	callq  *%rax
}
  801f68:	c9                   	leaveq 
  801f69:	c3                   	retq   

0000000000801f6a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f6a:	55                   	push   %rbp
  801f6b:	48 89 e5             	mov    %rsp,%rbp
  801f6e:	48 83 ec 20          	sub    $0x20,%rsp
  801f72:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f75:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f80:	48 98                	cltq   
  801f82:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f89:	00 
  801f8a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f96:	48 89 d1             	mov    %rdx,%rcx
  801f99:	48 89 c2             	mov    %rax,%rdx
  801f9c:	be 01 00 00 00       	mov    $0x1,%esi
  801fa1:	bf 0a 00 00 00       	mov    $0xa,%edi
  801fa6:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	callq  *%rax
}
  801fb2:	c9                   	leaveq 
  801fb3:	c3                   	retq   

0000000000801fb4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801fb4:	55                   	push   %rbp
  801fb5:	48 89 e5             	mov    %rsp,%rbp
  801fb8:	48 83 ec 30          	sub    $0x30,%rsp
  801fbc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fbf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fc3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801fc7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801fca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fcd:	48 63 f0             	movslq %eax,%rsi
  801fd0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd7:	48 98                	cltq   
  801fd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fdd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fe4:	00 
  801fe5:	49 89 f1             	mov    %rsi,%r9
  801fe8:	49 89 c8             	mov    %rcx,%r8
  801feb:	48 89 d1             	mov    %rdx,%rcx
  801fee:	48 89 c2             	mov    %rax,%rdx
  801ff1:	be 00 00 00 00       	mov    $0x0,%esi
  801ff6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ffb:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  802002:	00 00 00 
  802005:	ff d0                	callq  *%rax
}
  802007:	c9                   	leaveq 
  802008:	c3                   	retq   

0000000000802009 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802009:	55                   	push   %rbp
  80200a:	48 89 e5             	mov    %rsp,%rbp
  80200d:	48 83 ec 20          	sub    $0x20,%rsp
  802011:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802019:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802020:	00 
  802021:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802027:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80202d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802032:	48 89 c2             	mov    %rax,%rdx
  802035:	be 01 00 00 00       	mov    $0x1,%esi
  80203a:	bf 0d 00 00 00       	mov    $0xd,%edi
  80203f:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  802046:	00 00 00 
  802049:	ff d0                	callq  *%rax
}
  80204b:	c9                   	leaveq 
  80204c:	c3                   	retq   

000000000080204d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80204d:	55                   	push   %rbp
  80204e:	48 89 e5             	mov    %rsp,%rbp
  802051:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802055:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80205c:	00 
  80205d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802063:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802069:	b9 00 00 00 00       	mov    $0x0,%ecx
  80206e:	ba 00 00 00 00       	mov    $0x0,%edx
  802073:	be 00 00 00 00       	mov    $0x0,%esi
  802078:	bf 0e 00 00 00       	mov    $0xe,%edi
  80207d:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax
}
  802089:	c9                   	leaveq 
  80208a:	c3                   	retq   

000000000080208b <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80208b:	55                   	push   %rbp
  80208c:	48 89 e5             	mov    %rsp,%rbp
  80208f:	48 83 ec 30          	sub    $0x30,%rsp
  802093:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802096:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80209a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80209d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020a1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8020a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020a8:	48 63 c8             	movslq %eax,%rcx
  8020ab:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020b2:	48 63 f0             	movslq %eax,%rsi
  8020b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bc:	48 98                	cltq   
  8020be:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020c2:	49 89 f9             	mov    %rdi,%r9
  8020c5:	49 89 f0             	mov    %rsi,%r8
  8020c8:	48 89 d1             	mov    %rdx,%rcx
  8020cb:	48 89 c2             	mov    %rax,%rdx
  8020ce:	be 00 00 00 00       	mov    $0x0,%esi
  8020d3:	bf 0f 00 00 00       	mov    $0xf,%edi
  8020d8:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  8020df:	00 00 00 
  8020e2:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8020e4:	c9                   	leaveq 
  8020e5:	c3                   	retq   

00000000008020e6 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8020e6:	55                   	push   %rbp
  8020e7:	48 89 e5             	mov    %rsp,%rbp
  8020ea:	48 83 ec 20          	sub    $0x20,%rsp
  8020ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8020f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802105:	00 
  802106:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80210c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802112:	48 89 d1             	mov    %rdx,%rcx
  802115:	48 89 c2             	mov    %rax,%rdx
  802118:	be 00 00 00 00       	mov    $0x0,%esi
  80211d:	bf 10 00 00 00       	mov    $0x10,%edi
  802122:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax
}
  80212e:	c9                   	leaveq 
  80212f:	c3                   	retq   

0000000000802130 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802130:	55                   	push   %rbp
  802131:	48 89 e5             	mov    %rsp,%rbp
  802134:	48 83 ec 08          	sub    $0x8,%rsp
  802138:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80213c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802140:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802147:	ff ff ff 
  80214a:	48 01 d0             	add    %rdx,%rax
  80214d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802151:	c9                   	leaveq 
  802152:	c3                   	retq   

0000000000802153 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802153:	55                   	push   %rbp
  802154:	48 89 e5             	mov    %rsp,%rbp
  802157:	48 83 ec 08          	sub    $0x8,%rsp
  80215b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80215f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802163:	48 89 c7             	mov    %rax,%rdi
  802166:	48 b8 30 21 80 00 00 	movabs $0x802130,%rax
  80216d:	00 00 00 
  802170:	ff d0                	callq  *%rax
  802172:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802178:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80217c:	c9                   	leaveq 
  80217d:	c3                   	retq   

000000000080217e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80217e:	55                   	push   %rbp
  80217f:	48 89 e5             	mov    %rsp,%rbp
  802182:	48 83 ec 18          	sub    $0x18,%rsp
  802186:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80218a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802191:	eb 6b                	jmp    8021fe <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802196:	48 98                	cltq   
  802198:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80219e:	48 c1 e0 0c          	shl    $0xc,%rax
  8021a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021aa:	48 89 c2             	mov    %rax,%rdx
  8021ad:	48 c1 ea 15          	shr    $0x15,%rdx
  8021b1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021b8:	01 00 00 
  8021bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021bf:	83 e0 01             	and    $0x1,%eax
  8021c2:	48 85 c0             	test   %rax,%rax
  8021c5:	74 21                	je     8021e8 <fd_alloc+0x6a>
  8021c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021cb:	48 89 c2             	mov    %rax,%rdx
  8021ce:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021d9:	01 00 00 
  8021dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e0:	83 e0 01             	and    $0x1,%eax
  8021e3:	48 85 c0             	test   %rax,%rax
  8021e6:	75 12                	jne    8021fa <fd_alloc+0x7c>
			*fd_store = fd;
  8021e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	eb 1a                	jmp    802214 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021fe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802202:	7e 8f                	jle    802193 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802208:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80220f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802214:	c9                   	leaveq 
  802215:	c3                   	retq   

0000000000802216 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802216:	55                   	push   %rbp
  802217:	48 89 e5             	mov    %rsp,%rbp
  80221a:	48 83 ec 20          	sub    $0x20,%rsp
  80221e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802221:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802225:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802229:	78 06                	js     802231 <fd_lookup+0x1b>
  80222b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80222f:	7e 07                	jle    802238 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802231:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802236:	eb 6c                	jmp    8022a4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802238:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80223b:	48 98                	cltq   
  80223d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802243:	48 c1 e0 0c          	shl    $0xc,%rax
  802247:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80224b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80224f:	48 89 c2             	mov    %rax,%rdx
  802252:	48 c1 ea 15          	shr    $0x15,%rdx
  802256:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80225d:	01 00 00 
  802260:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802264:	83 e0 01             	and    $0x1,%eax
  802267:	48 85 c0             	test   %rax,%rax
  80226a:	74 21                	je     80228d <fd_lookup+0x77>
  80226c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802270:	48 89 c2             	mov    %rax,%rdx
  802273:	48 c1 ea 0c          	shr    $0xc,%rdx
  802277:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80227e:	01 00 00 
  802281:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802285:	83 e0 01             	and    $0x1,%eax
  802288:	48 85 c0             	test   %rax,%rax
  80228b:	75 07                	jne    802294 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80228d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802292:	eb 10                	jmp    8022a4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802294:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802298:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80229c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a4:	c9                   	leaveq 
  8022a5:	c3                   	retq   

00000000008022a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8022a6:	55                   	push   %rbp
  8022a7:	48 89 e5             	mov    %rsp,%rbp
  8022aa:	48 83 ec 30          	sub    $0x30,%rsp
  8022ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022b2:	89 f0                	mov    %esi,%eax
  8022b4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022bb:	48 89 c7             	mov    %rax,%rdi
  8022be:	48 b8 30 21 80 00 00 	movabs $0x802130,%rax
  8022c5:	00 00 00 
  8022c8:	ff d0                	callq  *%rax
  8022ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ce:	48 89 d6             	mov    %rdx,%rsi
  8022d1:	89 c7                	mov    %eax,%edi
  8022d3:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  8022da:	00 00 00 
  8022dd:	ff d0                	callq  *%rax
  8022df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e6:	78 0a                	js     8022f2 <fd_close+0x4c>
	    || fd != fd2)
  8022e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ec:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8022f0:	74 12                	je     802304 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8022f2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8022f6:	74 05                	je     8022fd <fd_close+0x57>
  8022f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fb:	eb 05                	jmp    802302 <fd_close+0x5c>
  8022fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802302:	eb 69                	jmp    80236d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802304:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802308:	8b 00                	mov    (%rax),%eax
  80230a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80230e:	48 89 d6             	mov    %rdx,%rsi
  802311:	89 c7                	mov    %eax,%edi
  802313:	48 b8 6f 23 80 00 00 	movabs $0x80236f,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	callq  *%rax
  80231f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802322:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802326:	78 2a                	js     802352 <fd_close+0xac>
		if (dev->dev_close)
  802328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802330:	48 85 c0             	test   %rax,%rax
  802333:	74 16                	je     80234b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802339:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80233d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802341:	48 89 c7             	mov    %rax,%rdi
  802344:	ff d2                	callq  *%rdx
  802346:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802349:	eb 07                	jmp    802352 <fd_close+0xac>
		else
			r = 0;
  80234b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802352:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802356:	48 89 c6             	mov    %rax,%rsi
  802359:	bf 00 00 00 00       	mov    $0x0,%edi
  80235e:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  802365:	00 00 00 
  802368:	ff d0                	callq  *%rax
	return r;
  80236a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80236d:	c9                   	leaveq 
  80236e:	c3                   	retq   

000000000080236f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80236f:	55                   	push   %rbp
  802370:	48 89 e5             	mov    %rsp,%rbp
  802373:	48 83 ec 20          	sub    $0x20,%rsp
  802377:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80237a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80237e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802385:	eb 41                	jmp    8023c8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802387:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80238e:	00 00 00 
  802391:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802394:	48 63 d2             	movslq %edx,%rdx
  802397:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80239b:	8b 00                	mov    (%rax),%eax
  80239d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023a0:	75 22                	jne    8023c4 <dev_lookup+0x55>
			*dev = devtab[i];
  8023a2:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8023a9:	00 00 00 
  8023ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023af:	48 63 d2             	movslq %edx,%rdx
  8023b2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8023b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c2:	eb 60                	jmp    802424 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8023c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023c8:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8023cf:	00 00 00 
  8023d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023d5:	48 63 d2             	movslq %edx,%rdx
  8023d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023dc:	48 85 c0             	test   %rax,%rax
  8023df:	75 a6                	jne    802387 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8023e1:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8023e8:	00 00 00 
  8023eb:	48 8b 00             	mov    (%rax),%rax
  8023ee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023f7:	89 c6                	mov    %eax,%esi
  8023f9:	48 bf c8 46 80 00 00 	movabs $0x8046c8,%rdi
  802400:	00 00 00 
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
  802408:	48 b9 77 07 80 00 00 	movabs $0x800777,%rcx
  80240f:	00 00 00 
  802412:	ff d1                	callq  *%rcx
	*dev = 0;
  802414:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802418:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80241f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802424:	c9                   	leaveq 
  802425:	c3                   	retq   

0000000000802426 <close>:

int
close(int fdnum)
{
  802426:	55                   	push   %rbp
  802427:	48 89 e5             	mov    %rsp,%rbp
  80242a:	48 83 ec 20          	sub    $0x20,%rsp
  80242e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802431:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802435:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802438:	48 89 d6             	mov    %rdx,%rsi
  80243b:	89 c7                	mov    %eax,%edi
  80243d:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  802444:	00 00 00 
  802447:	ff d0                	callq  *%rax
  802449:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802450:	79 05                	jns    802457 <close+0x31>
		return r;
  802452:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802455:	eb 18                	jmp    80246f <close+0x49>
	else
		return fd_close(fd, 1);
  802457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245b:	be 01 00 00 00       	mov    $0x1,%esi
  802460:	48 89 c7             	mov    %rax,%rdi
  802463:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  80246a:	00 00 00 
  80246d:	ff d0                	callq  *%rax
}
  80246f:	c9                   	leaveq 
  802470:	c3                   	retq   

0000000000802471 <close_all>:

void
close_all(void)
{
  802471:	55                   	push   %rbp
  802472:	48 89 e5             	mov    %rsp,%rbp
  802475:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802479:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802480:	eb 15                	jmp    802497 <close_all+0x26>
		close(i);
  802482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802485:	89 c7                	mov    %eax,%edi
  802487:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  80248e:	00 00 00 
  802491:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802493:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802497:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80249b:	7e e5                	jle    802482 <close_all+0x11>
		close(i);
}
  80249d:	c9                   	leaveq 
  80249e:	c3                   	retq   

000000000080249f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80249f:	55                   	push   %rbp
  8024a0:	48 89 e5             	mov    %rsp,%rbp
  8024a3:	48 83 ec 40          	sub    $0x40,%rsp
  8024a7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8024aa:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8024ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8024b1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8024b4:	48 89 d6             	mov    %rdx,%rsi
  8024b7:	89 c7                	mov    %eax,%edi
  8024b9:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  8024c0:	00 00 00 
  8024c3:	ff d0                	callq  *%rax
  8024c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024cc:	79 08                	jns    8024d6 <dup+0x37>
		return r;
  8024ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d1:	e9 70 01 00 00       	jmpq   802646 <dup+0x1a7>
	close(newfdnum);
  8024d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024d9:	89 c7                	mov    %eax,%edi
  8024db:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8024e7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024ea:	48 98                	cltq   
  8024ec:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024f2:	48 c1 e0 0c          	shl    $0xc,%rax
  8024f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8024fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024fe:	48 89 c7             	mov    %rax,%rdi
  802501:	48 b8 53 21 80 00 00 	movabs $0x802153,%rax
  802508:	00 00 00 
  80250b:	ff d0                	callq  *%rax
  80250d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802515:	48 89 c7             	mov    %rax,%rdi
  802518:	48 b8 53 21 80 00 00 	movabs $0x802153,%rax
  80251f:	00 00 00 
  802522:	ff d0                	callq  *%rax
  802524:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252c:	48 89 c2             	mov    %rax,%rdx
  80252f:	48 c1 ea 15          	shr    $0x15,%rdx
  802533:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80253a:	01 00 00 
  80253d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802541:	83 e0 01             	and    $0x1,%eax
  802544:	84 c0                	test   %al,%al
  802546:	74 71                	je     8025b9 <dup+0x11a>
  802548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254c:	48 89 c2             	mov    %rax,%rdx
  80254f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802553:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80255a:	01 00 00 
  80255d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802561:	83 e0 01             	and    $0x1,%eax
  802564:	84 c0                	test   %al,%al
  802566:	74 51                	je     8025b9 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256c:	48 89 c2             	mov    %rax,%rdx
  80256f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802573:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80257a:	01 00 00 
  80257d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802581:	89 c1                	mov    %eax,%ecx
  802583:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802589:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80258d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802591:	41 89 c8             	mov    %ecx,%r8d
  802594:	48 89 d1             	mov    %rdx,%rcx
  802597:	ba 00 00 00 00       	mov    $0x0,%edx
  80259c:	48 89 c6             	mov    %rax,%rsi
  80259f:	bf 00 00 00 00       	mov    $0x0,%edi
  8025a4:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  8025ab:	00 00 00 
  8025ae:	ff d0                	callq  *%rax
  8025b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b7:	78 56                	js     80260f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8025b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025bd:	48 89 c2             	mov    %rax,%rdx
  8025c0:	48 c1 ea 0c          	shr    $0xc,%rdx
  8025c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025cb:	01 00 00 
  8025ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d2:	89 c1                	mov    %eax,%ecx
  8025d4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8025da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025e2:	41 89 c8             	mov    %ecx,%r8d
  8025e5:	48 89 d1             	mov    %rdx,%rcx
  8025e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ed:	48 89 c6             	mov    %rax,%rsi
  8025f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f5:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax
  802601:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802604:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802608:	78 08                	js     802612 <dup+0x173>
		goto err;

	return newfdnum;
  80260a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80260d:	eb 37                	jmp    802646 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80260f:	90                   	nop
  802610:	eb 01                	jmp    802613 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802612:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802613:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802617:	48 89 c6             	mov    %rax,%rsi
  80261a:	bf 00 00 00 00       	mov    $0x0,%edi
  80261f:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  802626:	00 00 00 
  802629:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80262b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80262f:	48 89 c6             	mov    %rax,%rsi
  802632:	bf 00 00 00 00       	mov    $0x0,%edi
  802637:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  80263e:	00 00 00 
  802641:	ff d0                	callq  *%rax
	return r;
  802643:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802646:	c9                   	leaveq 
  802647:	c3                   	retq   

0000000000802648 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802648:	55                   	push   %rbp
  802649:	48 89 e5             	mov    %rsp,%rbp
  80264c:	48 83 ec 40          	sub    $0x40,%rsp
  802650:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802653:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802657:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80265b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80265f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802662:	48 89 d6             	mov    %rdx,%rsi
  802665:	89 c7                	mov    %eax,%edi
  802667:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  80266e:	00 00 00 
  802671:	ff d0                	callq  *%rax
  802673:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802676:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267a:	78 24                	js     8026a0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80267c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802680:	8b 00                	mov    (%rax),%eax
  802682:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802686:	48 89 d6             	mov    %rdx,%rsi
  802689:	89 c7                	mov    %eax,%edi
  80268b:	48 b8 6f 23 80 00 00 	movabs $0x80236f,%rax
  802692:	00 00 00 
  802695:	ff d0                	callq  *%rax
  802697:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269e:	79 05                	jns    8026a5 <read+0x5d>
		return r;
  8026a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a3:	eb 7a                	jmp    80271f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8026a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a9:	8b 40 08             	mov    0x8(%rax),%eax
  8026ac:	83 e0 03             	and    $0x3,%eax
  8026af:	83 f8 01             	cmp    $0x1,%eax
  8026b2:	75 3a                	jne    8026ee <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8026b4:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8026bb:	00 00 00 
  8026be:	48 8b 00             	mov    (%rax),%rax
  8026c1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026ca:	89 c6                	mov    %eax,%esi
  8026cc:	48 bf e7 46 80 00 00 	movabs $0x8046e7,%rdi
  8026d3:	00 00 00 
  8026d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026db:	48 b9 77 07 80 00 00 	movabs $0x800777,%rcx
  8026e2:	00 00 00 
  8026e5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026ec:	eb 31                	jmp    80271f <read+0xd7>
	}
	if (!dev->dev_read)
  8026ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026f6:	48 85 c0             	test   %rax,%rax
  8026f9:	75 07                	jne    802702 <read+0xba>
		return -E_NOT_SUPP;
  8026fb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802700:	eb 1d                	jmp    80271f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802702:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802706:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80270a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802712:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802716:	48 89 ce             	mov    %rcx,%rsi
  802719:	48 89 c7             	mov    %rax,%rdi
  80271c:	41 ff d0             	callq  *%r8
}
  80271f:	c9                   	leaveq 
  802720:	c3                   	retq   

0000000000802721 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802721:	55                   	push   %rbp
  802722:	48 89 e5             	mov    %rsp,%rbp
  802725:	48 83 ec 30          	sub    $0x30,%rsp
  802729:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80272c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802730:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802734:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80273b:	eb 46                	jmp    802783 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80273d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802740:	48 98                	cltq   
  802742:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802746:	48 29 c2             	sub    %rax,%rdx
  802749:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274c:	48 98                	cltq   
  80274e:	48 89 c1             	mov    %rax,%rcx
  802751:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802755:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802758:	48 89 ce             	mov    %rcx,%rsi
  80275b:	89 c7                	mov    %eax,%edi
  80275d:	48 b8 48 26 80 00 00 	movabs $0x802648,%rax
  802764:	00 00 00 
  802767:	ff d0                	callq  *%rax
  802769:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80276c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802770:	79 05                	jns    802777 <readn+0x56>
			return m;
  802772:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802775:	eb 1d                	jmp    802794 <readn+0x73>
		if (m == 0)
  802777:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80277b:	74 13                	je     802790 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80277d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802780:	01 45 fc             	add    %eax,-0x4(%rbp)
  802783:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802786:	48 98                	cltq   
  802788:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80278c:	72 af                	jb     80273d <readn+0x1c>
  80278e:	eb 01                	jmp    802791 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802790:	90                   	nop
	}
	return tot;
  802791:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802794:	c9                   	leaveq 
  802795:	c3                   	retq   

0000000000802796 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802796:	55                   	push   %rbp
  802797:	48 89 e5             	mov    %rsp,%rbp
  80279a:	48 83 ec 40          	sub    $0x40,%rsp
  80279e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027a5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027a9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027b0:	48 89 d6             	mov    %rdx,%rsi
  8027b3:	89 c7                	mov    %eax,%edi
  8027b5:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  8027bc:	00 00 00 
  8027bf:	ff d0                	callq  *%rax
  8027c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c8:	78 24                	js     8027ee <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ce:	8b 00                	mov    (%rax),%eax
  8027d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027d4:	48 89 d6             	mov    %rdx,%rsi
  8027d7:	89 c7                	mov    %eax,%edi
  8027d9:	48 b8 6f 23 80 00 00 	movabs $0x80236f,%rax
  8027e0:	00 00 00 
  8027e3:	ff d0                	callq  *%rax
  8027e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ec:	79 05                	jns    8027f3 <write+0x5d>
		return r;
  8027ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f1:	eb 79                	jmp    80286c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f7:	8b 40 08             	mov    0x8(%rax),%eax
  8027fa:	83 e0 03             	and    $0x3,%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	75 3a                	jne    80283b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802801:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802808:	00 00 00 
  80280b:	48 8b 00             	mov    (%rax),%rax
  80280e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802814:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802817:	89 c6                	mov    %eax,%esi
  802819:	48 bf 03 47 80 00 00 	movabs $0x804703,%rdi
  802820:	00 00 00 
  802823:	b8 00 00 00 00       	mov    $0x0,%eax
  802828:	48 b9 77 07 80 00 00 	movabs $0x800777,%rcx
  80282f:	00 00 00 
  802832:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802834:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802839:	eb 31                	jmp    80286c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80283b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802843:	48 85 c0             	test   %rax,%rax
  802846:	75 07                	jne    80284f <write+0xb9>
		return -E_NOT_SUPP;
  802848:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80284d:	eb 1d                	jmp    80286c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80284f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802853:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80285f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802863:	48 89 ce             	mov    %rcx,%rsi
  802866:	48 89 c7             	mov    %rax,%rdi
  802869:	41 ff d0             	callq  *%r8
}
  80286c:	c9                   	leaveq 
  80286d:	c3                   	retq   

000000000080286e <seek>:

int
seek(int fdnum, off_t offset)
{
  80286e:	55                   	push   %rbp
  80286f:	48 89 e5             	mov    %rsp,%rbp
  802872:	48 83 ec 18          	sub    $0x18,%rsp
  802876:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802879:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80287c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802880:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802883:	48 89 d6             	mov    %rdx,%rsi
  802886:	89 c7                	mov    %eax,%edi
  802888:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  80288f:	00 00 00 
  802892:	ff d0                	callq  *%rax
  802894:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802897:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289b:	79 05                	jns    8028a2 <seek+0x34>
		return r;
  80289d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a0:	eb 0f                	jmp    8028b1 <seek+0x43>
	fd->fd_offset = offset;
  8028a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028a9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8028ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b1:	c9                   	leaveq 
  8028b2:	c3                   	retq   

00000000008028b3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8028b3:	55                   	push   %rbp
  8028b4:	48 89 e5             	mov    %rsp,%rbp
  8028b7:	48 83 ec 30          	sub    $0x30,%rsp
  8028bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028be:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028c8:	48 89 d6             	mov    %rdx,%rsi
  8028cb:	89 c7                	mov    %eax,%edi
  8028cd:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  8028d4:	00 00 00 
  8028d7:	ff d0                	callq  *%rax
  8028d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e0:	78 24                	js     802906 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e6:	8b 00                	mov    (%rax),%eax
  8028e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028ec:	48 89 d6             	mov    %rdx,%rsi
  8028ef:	89 c7                	mov    %eax,%edi
  8028f1:	48 b8 6f 23 80 00 00 	movabs $0x80236f,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	callq  *%rax
  8028fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802900:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802904:	79 05                	jns    80290b <ftruncate+0x58>
		return r;
  802906:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802909:	eb 72                	jmp    80297d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80290b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290f:	8b 40 08             	mov    0x8(%rax),%eax
  802912:	83 e0 03             	and    $0x3,%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	75 3a                	jne    802953 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802919:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802920:	00 00 00 
  802923:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802926:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80292c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80292f:	89 c6                	mov    %eax,%esi
  802931:	48 bf 20 47 80 00 00 	movabs $0x804720,%rdi
  802938:	00 00 00 
  80293b:	b8 00 00 00 00       	mov    $0x0,%eax
  802940:	48 b9 77 07 80 00 00 	movabs $0x800777,%rcx
  802947:	00 00 00 
  80294a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80294c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802951:	eb 2a                	jmp    80297d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802953:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802957:	48 8b 40 30          	mov    0x30(%rax),%rax
  80295b:	48 85 c0             	test   %rax,%rax
  80295e:	75 07                	jne    802967 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802960:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802965:	eb 16                	jmp    80297d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80296f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802973:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802976:	89 d6                	mov    %edx,%esi
  802978:	48 89 c7             	mov    %rax,%rdi
  80297b:	ff d1                	callq  *%rcx
}
  80297d:	c9                   	leaveq 
  80297e:	c3                   	retq   

000000000080297f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80297f:	55                   	push   %rbp
  802980:	48 89 e5             	mov    %rsp,%rbp
  802983:	48 83 ec 30          	sub    $0x30,%rsp
  802987:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80298a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80298e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802992:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802995:	48 89 d6             	mov    %rdx,%rsi
  802998:	89 c7                	mov    %eax,%edi
  80299a:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  8029a1:	00 00 00 
  8029a4:	ff d0                	callq  *%rax
  8029a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ad:	78 24                	js     8029d3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b3:	8b 00                	mov    (%rax),%eax
  8029b5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b9:	48 89 d6             	mov    %rdx,%rsi
  8029bc:	89 c7                	mov    %eax,%edi
  8029be:	48 b8 6f 23 80 00 00 	movabs $0x80236f,%rax
  8029c5:	00 00 00 
  8029c8:	ff d0                	callq  *%rax
  8029ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d1:	79 05                	jns    8029d8 <fstat+0x59>
		return r;
  8029d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d6:	eb 5e                	jmp    802a36 <fstat+0xb7>
	if (!dev->dev_stat)
  8029d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029dc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029e0:	48 85 c0             	test   %rax,%rax
  8029e3:	75 07                	jne    8029ec <fstat+0x6d>
		return -E_NOT_SUPP;
  8029e5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029ea:	eb 4a                	jmp    802a36 <fstat+0xb7>
	stat->st_name[0] = 0;
  8029ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8029f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8029fe:	00 00 00 
	stat->st_isdir = 0;
  802a01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a05:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a0c:	00 00 00 
	stat->st_dev = dev;
  802a0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a17:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a22:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a2a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802a2e:	48 89 d6             	mov    %rdx,%rsi
  802a31:	48 89 c7             	mov    %rax,%rdi
  802a34:	ff d1                	callq  *%rcx
}
  802a36:	c9                   	leaveq 
  802a37:	c3                   	retq   

0000000000802a38 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a38:	55                   	push   %rbp
  802a39:	48 89 e5             	mov    %rsp,%rbp
  802a3c:	48 83 ec 20          	sub    $0x20,%rsp
  802a40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4c:	be 00 00 00 00       	mov    $0x0,%esi
  802a51:	48 89 c7             	mov    %rax,%rdi
  802a54:	48 b8 27 2b 80 00 00 	movabs $0x802b27,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
  802a60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a67:	79 05                	jns    802a6e <stat+0x36>
		return fd;
  802a69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6c:	eb 2f                	jmp    802a9d <stat+0x65>
	r = fstat(fd, stat);
  802a6e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a75:	48 89 d6             	mov    %rdx,%rsi
  802a78:	89 c7                	mov    %eax,%edi
  802a7a:	48 b8 7f 29 80 00 00 	movabs $0x80297f,%rax
  802a81:	00 00 00 
  802a84:	ff d0                	callq  *%rax
  802a86:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8c:	89 c7                	mov    %eax,%edi
  802a8e:	48 b8 26 24 80 00 00 	movabs $0x802426,%rax
  802a95:	00 00 00 
  802a98:	ff d0                	callq  *%rax
	return r;
  802a9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a9d:	c9                   	leaveq 
  802a9e:	c3                   	retq   
	...

0000000000802aa0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802aa0:	55                   	push   %rbp
  802aa1:	48 89 e5             	mov    %rsp,%rbp
  802aa4:	48 83 ec 10          	sub    $0x10,%rsp
  802aa8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802aab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802aaf:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802ab6:	00 00 00 
  802ab9:	8b 00                	mov    (%rax),%eax
  802abb:	85 c0                	test   %eax,%eax
  802abd:	75 1d                	jne    802adc <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802abf:	bf 01 00 00 00       	mov    $0x1,%edi
  802ac4:	48 b8 ca 3f 80 00 00 	movabs $0x803fca,%rax
  802acb:	00 00 00 
  802ace:	ff d0                	callq  *%rax
  802ad0:	48 ba 00 74 80 00 00 	movabs $0x807400,%rdx
  802ad7:	00 00 00 
  802ada:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802adc:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802ae3:	00 00 00 
  802ae6:	8b 00                	mov    (%rax),%eax
  802ae8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802aeb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802af0:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802af7:	00 00 00 
  802afa:	89 c7                	mov    %eax,%edi
  802afc:	48 b8 1b 3f 80 00 00 	movabs $0x803f1b,%rax
  802b03:	00 00 00 
  802b06:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b11:	48 89 c6             	mov    %rax,%rsi
  802b14:	bf 00 00 00 00       	mov    $0x0,%edi
  802b19:	48 b8 34 3e 80 00 00 	movabs $0x803e34,%rax
  802b20:	00 00 00 
  802b23:	ff d0                	callq  *%rax
}
  802b25:	c9                   	leaveq 
  802b26:	c3                   	retq   

0000000000802b27 <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  802b27:	55                   	push   %rbp
  802b28:	48 89 e5             	mov    %rsp,%rbp
  802b2b:	48 83 ec 20          	sub    $0x20,%rsp
  802b2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b33:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  802b36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3a:	48 89 c7             	mov    %rax,%rdi
  802b3d:	48 b8 3c 14 80 00 00 	movabs $0x80143c,%rax
  802b44:	00 00 00 
  802b47:	ff d0                	callq  *%rax
  802b49:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b4e:	7e 0a                	jle    802b5a <open+0x33>
		return -E_BAD_PATH;
  802b50:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b55:	e9 a5 00 00 00       	jmpq   802bff <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  802b5a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b5e:	48 89 c7             	mov    %rax,%rdi
  802b61:	48 b8 7e 21 80 00 00 	movabs $0x80217e,%rax
  802b68:	00 00 00 
  802b6b:	ff d0                	callq  *%rax
  802b6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802b70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b74:	79 08                	jns    802b7e <open+0x57>
		return r;
  802b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b79:	e9 81 00 00 00       	jmpq   802bff <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  802b7e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b85:	00 00 00 
  802b88:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802b8b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b95:	48 89 c6             	mov    %rax,%rsi
  802b98:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b9f:	00 00 00 
  802ba2:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  802ba9:	00 00 00 
  802bac:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  802bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb2:	48 89 c6             	mov    %rax,%rsi
  802bb5:	bf 01 00 00 00       	mov    $0x1,%edi
  802bba:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	callq  *%rax
  802bc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  802bc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bcd:	79 1d                	jns    802bec <open+0xc5>
		fd_close(new_fd, 0);
  802bcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd3:	be 00 00 00 00       	mov    $0x0,%esi
  802bd8:	48 89 c7             	mov    %rax,%rdi
  802bdb:	48 b8 a6 22 80 00 00 	movabs $0x8022a6,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
		return r;	
  802be7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bea:	eb 13                	jmp    802bff <open+0xd8>
	}
	return fd2num(new_fd);
  802bec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf0:	48 89 c7             	mov    %rax,%rdi
  802bf3:	48 b8 30 21 80 00 00 	movabs $0x802130,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
}
  802bff:	c9                   	leaveq 
  802c00:	c3                   	retq   

0000000000802c01 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c01:	55                   	push   %rbp
  802c02:	48 89 e5             	mov    %rsp,%rbp
  802c05:	48 83 ec 10          	sub    $0x10,%rsp
  802c09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c11:	8b 50 0c             	mov    0xc(%rax),%edx
  802c14:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c1b:	00 00 00 
  802c1e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c20:	be 00 00 00 00       	mov    $0x0,%esi
  802c25:	bf 06 00 00 00       	mov    $0x6,%edi
  802c2a:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	callq  *%rax
}
  802c36:	c9                   	leaveq 
  802c37:	c3                   	retq   

0000000000802c38 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c38:	55                   	push   %rbp
  802c39:	48 89 e5             	mov    %rsp,%rbp
  802c3c:	48 83 ec 30          	sub    $0x30,%rsp
  802c40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c48:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  802c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c50:	8b 50 0c             	mov    0xc(%rax),%edx
  802c53:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c5a:	00 00 00 
  802c5d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c5f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c66:	00 00 00 
  802c69:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c6d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  802c71:	be 00 00 00 00       	mov    $0x0,%esi
  802c76:	bf 03 00 00 00       	mov    $0x3,%edi
  802c7b:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  802c82:	00 00 00 
  802c85:	ff d0                	callq  *%rax
  802c87:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  802c8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8e:	7e 23                	jle    802cb3 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  802c90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c93:	48 63 d0             	movslq %eax,%rdx
  802c96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c9a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ca1:	00 00 00 
  802ca4:	48 89 c7             	mov    %rax,%rdi
  802ca7:	48 b8 ca 17 80 00 00 	movabs $0x8017ca,%rax
  802cae:	00 00 00 
  802cb1:	ff d0                	callq  *%rax
	}
	return nbytes;
  802cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cb6:	c9                   	leaveq 
  802cb7:	c3                   	retq   

0000000000802cb8 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802cb8:	55                   	push   %rbp
  802cb9:	48 89 e5             	mov    %rsp,%rbp
  802cbc:	48 83 ec 20          	sub    $0x20,%rsp
  802cc0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cc4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccc:	8b 50 0c             	mov    0xc(%rax),%edx
  802ccf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cd6:	00 00 00 
  802cd9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802cdb:	be 00 00 00 00       	mov    $0x0,%esi
  802ce0:	bf 05 00 00 00       	mov    $0x5,%edi
  802ce5:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  802cec:	00 00 00 
  802cef:	ff d0                	callq  *%rax
  802cf1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf8:	79 05                	jns    802cff <devfile_stat+0x47>
		return r;
  802cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfd:	eb 56                	jmp    802d55 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802cff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d03:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d0a:	00 00 00 
  802d0d:	48 89 c7             	mov    %rax,%rdi
  802d10:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  802d17:	00 00 00 
  802d1a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802d1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d23:	00 00 00 
  802d26:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802d2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d30:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d36:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d3d:	00 00 00 
  802d40:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802d46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d4a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802d50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d55:	c9                   	leaveq 
  802d56:	c3                   	retq   
	...

0000000000802d58 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802d58:	55                   	push   %rbp
  802d59:	48 89 e5             	mov    %rsp,%rbp
  802d5c:	48 83 ec 20          	sub    $0x20,%rsp
  802d60:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d68:	8b 40 0c             	mov    0xc(%rax),%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	7e 67                	jle    802dd6 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d73:	8b 40 04             	mov    0x4(%rax),%eax
  802d76:	48 63 d0             	movslq %eax,%rdx
  802d79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7d:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802d81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d85:	8b 00                	mov    (%rax),%eax
  802d87:	48 89 ce             	mov    %rcx,%rsi
  802d8a:	89 c7                	mov    %eax,%edi
  802d8c:	48 b8 96 27 80 00 00 	movabs $0x802796,%rax
  802d93:	00 00 00 
  802d96:	ff d0                	callq  *%rax
  802d98:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802d9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9f:	7e 13                	jle    802db4 <writebuf+0x5c>
			b->result += result;
  802da1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da5:	8b 40 08             	mov    0x8(%rax),%eax
  802da8:	89 c2                	mov    %eax,%edx
  802daa:	03 55 fc             	add    -0x4(%rbp),%edx
  802dad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db1:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802db4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db8:	8b 40 04             	mov    0x4(%rax),%eax
  802dbb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802dbe:	74 16                	je     802dd6 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc9:	89 c2                	mov    %eax,%edx
  802dcb:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  802dcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd3:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802dd6:	c9                   	leaveq 
  802dd7:	c3                   	retq   

0000000000802dd8 <putch>:

static void
putch(int ch, void *thunk)
{
  802dd8:	55                   	push   %rbp
  802dd9:	48 89 e5             	mov    %rsp,%rbp
  802ddc:	48 83 ec 20          	sub    $0x20,%rsp
  802de0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802de3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802de7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802deb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802def:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df3:	8b 40 04             	mov    0x4(%rax),%eax
  802df6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802df9:	89 d6                	mov    %edx,%esi
  802dfb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802dff:	48 63 d0             	movslq %eax,%rdx
  802e02:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  802e07:	8d 50 01             	lea    0x1(%rax),%edx
  802e0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e0e:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  802e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e15:	8b 40 04             	mov    0x4(%rax),%eax
  802e18:	3d 00 01 00 00       	cmp    $0x100,%eax
  802e1d:	75 1e                	jne    802e3d <putch+0x65>
		writebuf(b);
  802e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e23:	48 89 c7             	mov    %rax,%rdi
  802e26:	48 b8 58 2d 80 00 00 	movabs $0x802d58,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
		b->idx = 0;
  802e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802e3d:	c9                   	leaveq 
  802e3e:	c3                   	retq   

0000000000802e3f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802e3f:	55                   	push   %rbp
  802e40:	48 89 e5             	mov    %rsp,%rbp
  802e43:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802e4a:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802e50:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802e57:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802e5e:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802e64:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802e6a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802e71:	00 00 00 
	b.result = 0;
  802e74:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802e7b:	00 00 00 
	b.error = 1;
  802e7e:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802e85:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802e88:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802e8f:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802e96:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e9d:	48 89 c6             	mov    %rax,%rsi
  802ea0:	48 bf d8 2d 80 00 00 	movabs $0x802dd8,%rdi
  802ea7:	00 00 00 
  802eaa:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  802eb1:	00 00 00 
  802eb4:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802eb6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	7e 16                	jle    802ed6 <vfprintf+0x97>
		writebuf(&b);
  802ec0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802ec7:	48 89 c7             	mov    %rax,%rdi
  802eca:	48 b8 58 2d 80 00 00 	movabs $0x802d58,%rax
  802ed1:	00 00 00 
  802ed4:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802ed6:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802edc:	85 c0                	test   %eax,%eax
  802ede:	74 08                	je     802ee8 <vfprintf+0xa9>
  802ee0:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ee6:	eb 06                	jmp    802eee <vfprintf+0xaf>
  802ee8:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802eee:	c9                   	leaveq 
  802eef:	c3                   	retq   

0000000000802ef0 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802ef0:	55                   	push   %rbp
  802ef1:	48 89 e5             	mov    %rsp,%rbp
  802ef4:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802efb:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802f01:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802f08:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f0f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f16:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f1d:	84 c0                	test   %al,%al
  802f1f:	74 20                	je     802f41 <fprintf+0x51>
  802f21:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f25:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f29:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f2d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f31:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f35:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f39:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f3d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f41:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f48:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802f4f:	00 00 00 
  802f52:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f59:	00 00 00 
  802f5c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f60:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f67:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f6e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802f75:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f7c:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802f83:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f89:	48 89 ce             	mov    %rcx,%rsi
  802f8c:	89 c7                	mov    %eax,%edi
  802f8e:	48 b8 3f 2e 80 00 00 	movabs $0x802e3f,%rax
  802f95:	00 00 00 
  802f98:	ff d0                	callq  *%rax
  802f9a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802fa0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802fa6:	c9                   	leaveq 
  802fa7:	c3                   	retq   

0000000000802fa8 <printf>:

int
printf(const char *fmt, ...)
{
  802fa8:	55                   	push   %rbp
  802fa9:	48 89 e5             	mov    %rsp,%rbp
  802fac:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802fb3:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802fba:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fc1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fc8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fcf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fd6:	84 c0                	test   %al,%al
  802fd8:	74 20                	je     802ffa <printf+0x52>
  802fda:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fde:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fe2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fe6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fea:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fee:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ff2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ff6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ffa:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803001:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803008:	00 00 00 
  80300b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803012:	00 00 00 
  803015:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803019:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803020:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803027:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80302e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803035:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80303c:	48 89 c6             	mov    %rax,%rsi
  80303f:	bf 01 00 00 00       	mov    $0x1,%edi
  803044:	48 b8 3f 2e 80 00 00 	movabs $0x802e3f,%rax
  80304b:	00 00 00 
  80304e:	ff d0                	callq  *%rax
  803050:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803056:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80305c:	c9                   	leaveq 
  80305d:	c3                   	retq   
	...

0000000000803060 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803060:	55                   	push   %rbp
  803061:	48 89 e5             	mov    %rsp,%rbp
  803064:	48 83 ec 20          	sub    $0x20,%rsp
  803068:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80306b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80306f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803072:	48 89 d6             	mov    %rdx,%rsi
  803075:	89 c7                	mov    %eax,%edi
  803077:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803086:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308a:	79 05                	jns    803091 <fd2sockid+0x31>
		return r;
  80308c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308f:	eb 24                	jmp    8030b5 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803091:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803095:	8b 10                	mov    (%rax),%edx
  803097:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80309e:	00 00 00 
  8030a1:	8b 00                	mov    (%rax),%eax
  8030a3:	39 c2                	cmp    %eax,%edx
  8030a5:	74 07                	je     8030ae <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8030a7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030ac:	eb 07                	jmp    8030b5 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8030ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b2:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8030b5:	c9                   	leaveq 
  8030b6:	c3                   	retq   

00000000008030b7 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8030b7:	55                   	push   %rbp
  8030b8:	48 89 e5             	mov    %rsp,%rbp
  8030bb:	48 83 ec 20          	sub    $0x20,%rsp
  8030bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8030c2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030c6:	48 89 c7             	mov    %rax,%rdi
  8030c9:	48 b8 7e 21 80 00 00 	movabs $0x80217e,%rax
  8030d0:	00 00 00 
  8030d3:	ff d0                	callq  *%rax
  8030d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030dc:	78 26                	js     803104 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8030de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e2:	ba 07 04 00 00       	mov    $0x407,%edx
  8030e7:	48 89 c6             	mov    %rax,%rsi
  8030ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ef:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  8030f6:	00 00 00 
  8030f9:	ff d0                	callq  *%rax
  8030fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803102:	79 16                	jns    80311a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803104:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803107:	89 c7                	mov    %eax,%edi
  803109:	48 b8 c4 35 80 00 00 	movabs $0x8035c4,%rax
  803110:	00 00 00 
  803113:	ff d0                	callq  *%rax
		return r;
  803115:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803118:	eb 3a                	jmp    803154 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80311a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311e:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803125:	00 00 00 
  803128:	8b 12                	mov    (%rdx),%edx
  80312a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80312c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803130:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803137:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80313e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803141:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803145:	48 89 c7             	mov    %rax,%rdi
  803148:	48 b8 30 21 80 00 00 	movabs $0x802130,%rax
  80314f:	00 00 00 
  803152:	ff d0                	callq  *%rax
}
  803154:	c9                   	leaveq 
  803155:	c3                   	retq   

0000000000803156 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803156:	55                   	push   %rbp
  803157:	48 89 e5             	mov    %rsp,%rbp
  80315a:	48 83 ec 30          	sub    $0x30,%rsp
  80315e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803161:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803165:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803169:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80316c:	89 c7                	mov    %eax,%edi
  80316e:	48 b8 60 30 80 00 00 	movabs $0x803060,%rax
  803175:	00 00 00 
  803178:	ff d0                	callq  *%rax
  80317a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80317d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803181:	79 05                	jns    803188 <accept+0x32>
		return r;
  803183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803186:	eb 3b                	jmp    8031c3 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803188:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80318c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803190:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803193:	48 89 ce             	mov    %rcx,%rsi
  803196:	89 c7                	mov    %eax,%edi
  803198:	48 b8 a1 34 80 00 00 	movabs $0x8034a1,%rax
  80319f:	00 00 00 
  8031a2:	ff d0                	callq  *%rax
  8031a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ab:	79 05                	jns    8031b2 <accept+0x5c>
		return r;
  8031ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b0:	eb 11                	jmp    8031c3 <accept+0x6d>
	return alloc_sockfd(r);
  8031b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b5:	89 c7                	mov    %eax,%edi
  8031b7:	48 b8 b7 30 80 00 00 	movabs $0x8030b7,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
}
  8031c3:	c9                   	leaveq 
  8031c4:	c3                   	retq   

00000000008031c5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031c5:	55                   	push   %rbp
  8031c6:	48 89 e5             	mov    %rsp,%rbp
  8031c9:	48 83 ec 20          	sub    $0x20,%rsp
  8031cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031d4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031da:	89 c7                	mov    %eax,%edi
  8031dc:	48 b8 60 30 80 00 00 	movabs $0x803060,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
  8031e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ef:	79 05                	jns    8031f6 <bind+0x31>
		return r;
  8031f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f4:	eb 1b                	jmp    803211 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8031f6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031f9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803200:	48 89 ce             	mov    %rcx,%rsi
  803203:	89 c7                	mov    %eax,%edi
  803205:	48 b8 20 35 80 00 00 	movabs $0x803520,%rax
  80320c:	00 00 00 
  80320f:	ff d0                	callq  *%rax
}
  803211:	c9                   	leaveq 
  803212:	c3                   	retq   

0000000000803213 <shutdown>:

int
shutdown(int s, int how)
{
  803213:	55                   	push   %rbp
  803214:	48 89 e5             	mov    %rsp,%rbp
  803217:	48 83 ec 20          	sub    $0x20,%rsp
  80321b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80321e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803221:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803224:	89 c7                	mov    %eax,%edi
  803226:	48 b8 60 30 80 00 00 	movabs $0x803060,%rax
  80322d:	00 00 00 
  803230:	ff d0                	callq  *%rax
  803232:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803235:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803239:	79 05                	jns    803240 <shutdown+0x2d>
		return r;
  80323b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323e:	eb 16                	jmp    803256 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803240:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803243:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803246:	89 d6                	mov    %edx,%esi
  803248:	89 c7                	mov    %eax,%edi
  80324a:	48 b8 84 35 80 00 00 	movabs $0x803584,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
}
  803256:	c9                   	leaveq 
  803257:	c3                   	retq   

0000000000803258 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803258:	55                   	push   %rbp
  803259:	48 89 e5             	mov    %rsp,%rbp
  80325c:	48 83 ec 10          	sub    $0x10,%rsp
  803260:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803268:	48 89 c7             	mov    %rax,%rdi
  80326b:	48 b8 58 40 80 00 00 	movabs $0x804058,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
  803277:	83 f8 01             	cmp    $0x1,%eax
  80327a:	75 17                	jne    803293 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80327c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803280:	8b 40 0c             	mov    0xc(%rax),%eax
  803283:	89 c7                	mov    %eax,%edi
  803285:	48 b8 c4 35 80 00 00 	movabs $0x8035c4,%rax
  80328c:	00 00 00 
  80328f:	ff d0                	callq  *%rax
  803291:	eb 05                	jmp    803298 <devsock_close+0x40>
	else
		return 0;
  803293:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803298:	c9                   	leaveq 
  803299:	c3                   	retq   

000000000080329a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80329a:	55                   	push   %rbp
  80329b:	48 89 e5             	mov    %rsp,%rbp
  80329e:	48 83 ec 20          	sub    $0x20,%rsp
  8032a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032a9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032af:	89 c7                	mov    %eax,%edi
  8032b1:	48 b8 60 30 80 00 00 	movabs $0x803060,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	callq  *%rax
  8032bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c4:	79 05                	jns    8032cb <connect+0x31>
		return r;
  8032c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c9:	eb 1b                	jmp    8032e6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8032cb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032ce:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d5:	48 89 ce             	mov    %rcx,%rsi
  8032d8:	89 c7                	mov    %eax,%edi
  8032da:	48 b8 f1 35 80 00 00 	movabs $0x8035f1,%rax
  8032e1:	00 00 00 
  8032e4:	ff d0                	callq  *%rax
}
  8032e6:	c9                   	leaveq 
  8032e7:	c3                   	retq   

00000000008032e8 <listen>:

int
listen(int s, int backlog)
{
  8032e8:	55                   	push   %rbp
  8032e9:	48 89 e5             	mov    %rsp,%rbp
  8032ec:	48 83 ec 20          	sub    $0x20,%rsp
  8032f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032f3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032f9:	89 c7                	mov    %eax,%edi
  8032fb:	48 b8 60 30 80 00 00 	movabs $0x803060,%rax
  803302:	00 00 00 
  803305:	ff d0                	callq  *%rax
  803307:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330e:	79 05                	jns    803315 <listen+0x2d>
		return r;
  803310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803313:	eb 16                	jmp    80332b <listen+0x43>
	return nsipc_listen(r, backlog);
  803315:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803318:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331b:	89 d6                	mov    %edx,%esi
  80331d:	89 c7                	mov    %eax,%edi
  80331f:	48 b8 55 36 80 00 00 	movabs $0x803655,%rax
  803326:	00 00 00 
  803329:	ff d0                	callq  *%rax
}
  80332b:	c9                   	leaveq 
  80332c:	c3                   	retq   

000000000080332d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80332d:	55                   	push   %rbp
  80332e:	48 89 e5             	mov    %rsp,%rbp
  803331:	48 83 ec 20          	sub    $0x20,%rsp
  803335:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803339:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80333d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803345:	89 c2                	mov    %eax,%edx
  803347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80334b:	8b 40 0c             	mov    0xc(%rax),%eax
  80334e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803352:	b9 00 00 00 00       	mov    $0x0,%ecx
  803357:	89 c7                	mov    %eax,%edi
  803359:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  803360:	00 00 00 
  803363:	ff d0                	callq  *%rax
}
  803365:	c9                   	leaveq 
  803366:	c3                   	retq   

0000000000803367 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803367:	55                   	push   %rbp
  803368:	48 89 e5             	mov    %rsp,%rbp
  80336b:	48 83 ec 20          	sub    $0x20,%rsp
  80336f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803373:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803377:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80337b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80337f:	89 c2                	mov    %eax,%edx
  803381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803385:	8b 40 0c             	mov    0xc(%rax),%eax
  803388:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80338c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803391:	89 c7                	mov    %eax,%edi
  803393:	48 b8 61 37 80 00 00 	movabs $0x803761,%rax
  80339a:	00 00 00 
  80339d:	ff d0                	callq  *%rax
}
  80339f:	c9                   	leaveq 
  8033a0:	c3                   	retq   

00000000008033a1 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8033a1:	55                   	push   %rbp
  8033a2:	48 89 e5             	mov    %rsp,%rbp
  8033a5:	48 83 ec 10          	sub    $0x10,%rsp
  8033a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8033b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b5:	48 be 4b 47 80 00 00 	movabs $0x80474b,%rsi
  8033bc:	00 00 00 
  8033bf:	48 89 c7             	mov    %rax,%rdi
  8033c2:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  8033c9:	00 00 00 
  8033cc:	ff d0                	callq  *%rax
	return 0;
  8033ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d3:	c9                   	leaveq 
  8033d4:	c3                   	retq   

00000000008033d5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8033d5:	55                   	push   %rbp
  8033d6:	48 89 e5             	mov    %rsp,%rbp
  8033d9:	48 83 ec 20          	sub    $0x20,%rsp
  8033dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033e0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8033e3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8033e6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8033e9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8033ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ef:	89 ce                	mov    %ecx,%esi
  8033f1:	89 c7                	mov    %eax,%edi
  8033f3:	48 b8 19 38 80 00 00 	movabs $0x803819,%rax
  8033fa:	00 00 00 
  8033fd:	ff d0                	callq  *%rax
  8033ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803406:	79 05                	jns    80340d <socket+0x38>
		return r;
  803408:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340b:	eb 11                	jmp    80341e <socket+0x49>
	return alloc_sockfd(r);
  80340d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803410:	89 c7                	mov    %eax,%edi
  803412:	48 b8 b7 30 80 00 00 	movabs $0x8030b7,%rax
  803419:	00 00 00 
  80341c:	ff d0                	callq  *%rax
}
  80341e:	c9                   	leaveq 
  80341f:	c3                   	retq   

0000000000803420 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803420:	55                   	push   %rbp
  803421:	48 89 e5             	mov    %rsp,%rbp
  803424:	48 83 ec 10          	sub    $0x10,%rsp
  803428:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80342b:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  803432:	00 00 00 
  803435:	8b 00                	mov    (%rax),%eax
  803437:	85 c0                	test   %eax,%eax
  803439:	75 1d                	jne    803458 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80343b:	bf 02 00 00 00       	mov    $0x2,%edi
  803440:	48 b8 ca 3f 80 00 00 	movabs $0x803fca,%rax
  803447:	00 00 00 
  80344a:	ff d0                	callq  *%rax
  80344c:	48 ba 04 74 80 00 00 	movabs $0x807404,%rdx
  803453:	00 00 00 
  803456:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803458:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  80345f:	00 00 00 
  803462:	8b 00                	mov    (%rax),%eax
  803464:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803467:	b9 07 00 00 00       	mov    $0x7,%ecx
  80346c:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803473:	00 00 00 
  803476:	89 c7                	mov    %eax,%edi
  803478:	48 b8 1b 3f 80 00 00 	movabs $0x803f1b,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803484:	ba 00 00 00 00       	mov    $0x0,%edx
  803489:	be 00 00 00 00       	mov    $0x0,%esi
  80348e:	bf 00 00 00 00       	mov    $0x0,%edi
  803493:	48 b8 34 3e 80 00 00 	movabs $0x803e34,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
}
  80349f:	c9                   	leaveq 
  8034a0:	c3                   	retq   

00000000008034a1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034a1:	55                   	push   %rbp
  8034a2:	48 89 e5             	mov    %rsp,%rbp
  8034a5:	48 83 ec 30          	sub    $0x30,%rsp
  8034a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8034b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034bb:	00 00 00 
  8034be:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034c1:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8034c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8034c8:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  8034cf:	00 00 00 
  8034d2:	ff d0                	callq  *%rax
  8034d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034db:	78 3e                	js     80351b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8034dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034e4:	00 00 00 
  8034e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8034eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ef:	8b 40 10             	mov    0x10(%rax),%eax
  8034f2:	89 c2                	mov    %eax,%edx
  8034f4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8034f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034fc:	48 89 ce             	mov    %rcx,%rsi
  8034ff:	48 89 c7             	mov    %rax,%rdi
  803502:	48 b8 ca 17 80 00 00 	movabs $0x8017ca,%rax
  803509:	00 00 00 
  80350c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80350e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803512:	8b 50 10             	mov    0x10(%rax),%edx
  803515:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803519:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80351b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80351e:	c9                   	leaveq 
  80351f:	c3                   	retq   

0000000000803520 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803520:	55                   	push   %rbp
  803521:	48 89 e5             	mov    %rsp,%rbp
  803524:	48 83 ec 10          	sub    $0x10,%rsp
  803528:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80352b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80352f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803532:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803539:	00 00 00 
  80353c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80353f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803541:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803548:	48 89 c6             	mov    %rax,%rsi
  80354b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803552:	00 00 00 
  803555:	48 b8 ca 17 80 00 00 	movabs $0x8017ca,%rax
  80355c:	00 00 00 
  80355f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803561:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803568:	00 00 00 
  80356b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80356e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803571:	bf 02 00 00 00       	mov    $0x2,%edi
  803576:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
}
  803582:	c9                   	leaveq 
  803583:	c3                   	retq   

0000000000803584 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803584:	55                   	push   %rbp
  803585:	48 89 e5             	mov    %rsp,%rbp
  803588:	48 83 ec 10          	sub    $0x10,%rsp
  80358c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80358f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803592:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803599:	00 00 00 
  80359c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80359f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8035a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035a8:	00 00 00 
  8035ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035ae:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8035b1:	bf 03 00 00 00       	mov    $0x3,%edi
  8035b6:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  8035bd:	00 00 00 
  8035c0:	ff d0                	callq  *%rax
}
  8035c2:	c9                   	leaveq 
  8035c3:	c3                   	retq   

00000000008035c4 <nsipc_close>:

int
nsipc_close(int s)
{
  8035c4:	55                   	push   %rbp
  8035c5:	48 89 e5             	mov    %rsp,%rbp
  8035c8:	48 83 ec 10          	sub    $0x10,%rsp
  8035cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8035cf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035d6:	00 00 00 
  8035d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035dc:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8035de:	bf 04 00 00 00       	mov    $0x4,%edi
  8035e3:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  8035ea:	00 00 00 
  8035ed:	ff d0                	callq  *%rax
}
  8035ef:	c9                   	leaveq 
  8035f0:	c3                   	retq   

00000000008035f1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8035f1:	55                   	push   %rbp
  8035f2:	48 89 e5             	mov    %rsp,%rbp
  8035f5:	48 83 ec 10          	sub    $0x10,%rsp
  8035f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803600:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803603:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80360a:	00 00 00 
  80360d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803610:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803612:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803619:	48 89 c6             	mov    %rax,%rsi
  80361c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803623:	00 00 00 
  803626:	48 b8 ca 17 80 00 00 	movabs $0x8017ca,%rax
  80362d:	00 00 00 
  803630:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803632:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803639:	00 00 00 
  80363c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80363f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803642:	bf 05 00 00 00       	mov    $0x5,%edi
  803647:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  80364e:	00 00 00 
  803651:	ff d0                	callq  *%rax
}
  803653:	c9                   	leaveq 
  803654:	c3                   	retq   

0000000000803655 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803655:	55                   	push   %rbp
  803656:	48 89 e5             	mov    %rsp,%rbp
  803659:	48 83 ec 10          	sub    $0x10,%rsp
  80365d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803660:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803663:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80366a:	00 00 00 
  80366d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803670:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803672:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803679:	00 00 00 
  80367c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80367f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803682:	bf 06 00 00 00       	mov    $0x6,%edi
  803687:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  80368e:	00 00 00 
  803691:	ff d0                	callq  *%rax
}
  803693:	c9                   	leaveq 
  803694:	c3                   	retq   

0000000000803695 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803695:	55                   	push   %rbp
  803696:	48 89 e5             	mov    %rsp,%rbp
  803699:	48 83 ec 30          	sub    $0x30,%rsp
  80369d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036a4:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8036a7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8036aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036b1:	00 00 00 
  8036b4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036b7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8036b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036c0:	00 00 00 
  8036c3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036c6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8036c9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036d0:	00 00 00 
  8036d3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8036d6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8036d9:	bf 07 00 00 00       	mov    $0x7,%edi
  8036de:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  8036e5:	00 00 00 
  8036e8:	ff d0                	callq  *%rax
  8036ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f1:	78 69                	js     80375c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8036f3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8036fa:	7f 08                	jg     803704 <nsipc_recv+0x6f>
  8036fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ff:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803702:	7e 35                	jle    803739 <nsipc_recv+0xa4>
  803704:	48 b9 52 47 80 00 00 	movabs $0x804752,%rcx
  80370b:	00 00 00 
  80370e:	48 ba 67 47 80 00 00 	movabs $0x804767,%rdx
  803715:	00 00 00 
  803718:	be 61 00 00 00       	mov    $0x61,%esi
  80371d:	48 bf 7c 47 80 00 00 	movabs $0x80477c,%rdi
  803724:	00 00 00 
  803727:	b8 00 00 00 00       	mov    $0x0,%eax
  80372c:	49 b8 3c 05 80 00 00 	movabs $0x80053c,%r8
  803733:	00 00 00 
  803736:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373c:	48 63 d0             	movslq %eax,%rdx
  80373f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803743:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80374a:	00 00 00 
  80374d:	48 89 c7             	mov    %rax,%rdi
  803750:	48 b8 ca 17 80 00 00 	movabs $0x8017ca,%rax
  803757:	00 00 00 
  80375a:	ff d0                	callq  *%rax
	}

	return r;
  80375c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80375f:	c9                   	leaveq 
  803760:	c3                   	retq   

0000000000803761 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803761:	55                   	push   %rbp
  803762:	48 89 e5             	mov    %rsp,%rbp
  803765:	48 83 ec 20          	sub    $0x20,%rsp
  803769:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80376c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803770:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803773:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803776:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80377d:	00 00 00 
  803780:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803783:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803785:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80378c:	7e 35                	jle    8037c3 <nsipc_send+0x62>
  80378e:	48 b9 88 47 80 00 00 	movabs $0x804788,%rcx
  803795:	00 00 00 
  803798:	48 ba 67 47 80 00 00 	movabs $0x804767,%rdx
  80379f:	00 00 00 
  8037a2:	be 6c 00 00 00       	mov    $0x6c,%esi
  8037a7:	48 bf 7c 47 80 00 00 	movabs $0x80477c,%rdi
  8037ae:	00 00 00 
  8037b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b6:	49 b8 3c 05 80 00 00 	movabs $0x80053c,%r8
  8037bd:	00 00 00 
  8037c0:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8037c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037c6:	48 63 d0             	movslq %eax,%rdx
  8037c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cd:	48 89 c6             	mov    %rax,%rsi
  8037d0:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8037d7:	00 00 00 
  8037da:	48 b8 ca 17 80 00 00 	movabs $0x8017ca,%rax
  8037e1:	00 00 00 
  8037e4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8037e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ed:	00 00 00 
  8037f0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8037f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037fd:	00 00 00 
  803800:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803803:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803806:	bf 08 00 00 00       	mov    $0x8,%edi
  80380b:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
}
  803817:	c9                   	leaveq 
  803818:	c3                   	retq   

0000000000803819 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803819:	55                   	push   %rbp
  80381a:	48 89 e5             	mov    %rsp,%rbp
  80381d:	48 83 ec 10          	sub    $0x10,%rsp
  803821:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803824:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803827:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80382a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803831:	00 00 00 
  803834:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803837:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803839:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803840:	00 00 00 
  803843:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803846:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803849:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803850:	00 00 00 
  803853:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803856:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803859:	bf 09 00 00 00       	mov    $0x9,%edi
  80385e:	48 b8 20 34 80 00 00 	movabs $0x803420,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
}
  80386a:	c9                   	leaveq 
  80386b:	c3                   	retq   

000000000080386c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80386c:	55                   	push   %rbp
  80386d:	48 89 e5             	mov    %rsp,%rbp
  803870:	53                   	push   %rbx
  803871:	48 83 ec 38          	sub    $0x38,%rsp
  803875:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803879:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80387d:	48 89 c7             	mov    %rax,%rdi
  803880:	48 b8 7e 21 80 00 00 	movabs $0x80217e,%rax
  803887:	00 00 00 
  80388a:	ff d0                	callq  *%rax
  80388c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80388f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803893:	0f 88 bf 01 00 00    	js     803a58 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80389d:	ba 07 04 00 00       	mov    $0x407,%edx
  8038a2:	48 89 c6             	mov    %rax,%rsi
  8038a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8038aa:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  8038b1:	00 00 00 
  8038b4:	ff d0                	callq  *%rax
  8038b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038bd:	0f 88 95 01 00 00    	js     803a58 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038c3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8038c7:	48 89 c7             	mov    %rax,%rdi
  8038ca:	48 b8 7e 21 80 00 00 	movabs $0x80217e,%rax
  8038d1:	00 00 00 
  8038d4:	ff d0                	callq  *%rax
  8038d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038dd:	0f 88 5d 01 00 00    	js     803a40 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038e7:	ba 07 04 00 00       	mov    $0x407,%edx
  8038ec:	48 89 c6             	mov    %rax,%rsi
  8038ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f4:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  8038fb:	00 00 00 
  8038fe:	ff d0                	callq  *%rax
  803900:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803903:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803907:	0f 88 33 01 00 00    	js     803a40 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80390d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803911:	48 89 c7             	mov    %rax,%rdi
  803914:	48 b8 53 21 80 00 00 	movabs $0x802153,%rax
  80391b:	00 00 00 
  80391e:	ff d0                	callq  *%rax
  803920:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803924:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803928:	ba 07 04 00 00       	mov    $0x407,%edx
  80392d:	48 89 c6             	mov    %rax,%rsi
  803930:	bf 00 00 00 00       	mov    $0x0,%edi
  803935:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  80393c:	00 00 00 
  80393f:	ff d0                	callq  *%rax
  803941:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803944:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803948:	0f 88 d9 00 00 00    	js     803a27 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80394e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803952:	48 89 c7             	mov    %rax,%rdi
  803955:	48 b8 53 21 80 00 00 	movabs $0x802153,%rax
  80395c:	00 00 00 
  80395f:	ff d0                	callq  *%rax
  803961:	48 89 c2             	mov    %rax,%rdx
  803964:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803968:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80396e:	48 89 d1             	mov    %rdx,%rcx
  803971:	ba 00 00 00 00       	mov    $0x0,%edx
  803976:	48 89 c6             	mov    %rax,%rsi
  803979:	bf 00 00 00 00       	mov    $0x0,%edi
  80397e:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  803985:	00 00 00 
  803988:	ff d0                	callq  *%rax
  80398a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80398d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803991:	78 79                	js     803a0c <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803993:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803997:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  80399e:	00 00 00 
  8039a1:	8b 12                	mov    (%rdx),%edx
  8039a3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8039a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8039b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039b4:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  8039bb:	00 00 00 
  8039be:	8b 12                	mov    (%rdx),%edx
  8039c0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8039c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039c6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8039cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d1:	48 89 c7             	mov    %rax,%rdi
  8039d4:	48 b8 30 21 80 00 00 	movabs $0x802130,%rax
  8039db:	00 00 00 
  8039de:	ff d0                	callq  *%rax
  8039e0:	89 c2                	mov    %eax,%edx
  8039e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039e6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8039e8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039ec:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8039f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039f4:	48 89 c7             	mov    %rax,%rdi
  8039f7:	48 b8 30 21 80 00 00 	movabs $0x802130,%rax
  8039fe:	00 00 00 
  803a01:	ff d0                	callq  *%rax
  803a03:	89 03                	mov    %eax,(%rbx)
	return 0;
  803a05:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0a:	eb 4f                	jmp    803a5b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803a0c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803a0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a11:	48 89 c6             	mov    %rax,%rsi
  803a14:	bf 00 00 00 00       	mov    $0x0,%edi
  803a19:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  803a20:	00 00 00 
  803a23:	ff d0                	callq  *%rax
  803a25:	eb 01                	jmp    803a28 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803a27:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803a28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a2c:	48 89 c6             	mov    %rax,%rsi
  803a2f:	bf 00 00 00 00       	mov    $0x0,%edi
  803a34:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  803a3b:	00 00 00 
  803a3e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803a40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a44:	48 89 c6             	mov    %rax,%rsi
  803a47:	bf 00 00 00 00       	mov    $0x0,%edi
  803a4c:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  803a53:	00 00 00 
  803a56:	ff d0                	callq  *%rax
err:
	return r;
  803a58:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a5b:	48 83 c4 38          	add    $0x38,%rsp
  803a5f:	5b                   	pop    %rbx
  803a60:	5d                   	pop    %rbp
  803a61:	c3                   	retq   

0000000000803a62 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a62:	55                   	push   %rbp
  803a63:	48 89 e5             	mov    %rsp,%rbp
  803a66:	53                   	push   %rbx
  803a67:	48 83 ec 28          	sub    $0x28,%rsp
  803a6b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a6f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a73:	eb 01                	jmp    803a76 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803a75:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a76:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803a7d:	00 00 00 
  803a80:	48 8b 00             	mov    (%rax),%rax
  803a83:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a89:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a90:	48 89 c7             	mov    %rax,%rdi
  803a93:	48 b8 58 40 80 00 00 	movabs $0x804058,%rax
  803a9a:	00 00 00 
  803a9d:	ff d0                	callq  *%rax
  803a9f:	89 c3                	mov    %eax,%ebx
  803aa1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aa5:	48 89 c7             	mov    %rax,%rdi
  803aa8:	48 b8 58 40 80 00 00 	movabs $0x804058,%rax
  803aaf:	00 00 00 
  803ab2:	ff d0                	callq  *%rax
  803ab4:	39 c3                	cmp    %eax,%ebx
  803ab6:	0f 94 c0             	sete   %al
  803ab9:	0f b6 c0             	movzbl %al,%eax
  803abc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803abf:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803ac6:	00 00 00 
  803ac9:	48 8b 00             	mov    (%rax),%rax
  803acc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ad2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803ad5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ad8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803adb:	75 0a                	jne    803ae7 <_pipeisclosed+0x85>
			return ret;
  803add:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803ae0:	48 83 c4 28          	add    $0x28,%rsp
  803ae4:	5b                   	pop    %rbx
  803ae5:	5d                   	pop    %rbp
  803ae6:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803ae7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aea:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803aed:	74 86                	je     803a75 <_pipeisclosed+0x13>
  803aef:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803af3:	75 80                	jne    803a75 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803af5:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803afc:	00 00 00 
  803aff:	48 8b 00             	mov    (%rax),%rax
  803b02:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803b08:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b0b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b0e:	89 c6                	mov    %eax,%esi
  803b10:	48 bf 99 47 80 00 00 	movabs $0x804799,%rdi
  803b17:	00 00 00 
  803b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b1f:	49 b8 77 07 80 00 00 	movabs $0x800777,%r8
  803b26:	00 00 00 
  803b29:	41 ff d0             	callq  *%r8
	}
  803b2c:	e9 44 ff ff ff       	jmpq   803a75 <_pipeisclosed+0x13>

0000000000803b31 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803b31:	55                   	push   %rbp
  803b32:	48 89 e5             	mov    %rsp,%rbp
  803b35:	48 83 ec 30          	sub    $0x30,%rsp
  803b39:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b3c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b40:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b43:	48 89 d6             	mov    %rdx,%rsi
  803b46:	89 c7                	mov    %eax,%edi
  803b48:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  803b4f:	00 00 00 
  803b52:	ff d0                	callq  *%rax
  803b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b5b:	79 05                	jns    803b62 <pipeisclosed+0x31>
		return r;
  803b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b60:	eb 31                	jmp    803b93 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b66:	48 89 c7             	mov    %rax,%rdi
  803b69:	48 b8 53 21 80 00 00 	movabs $0x802153,%rax
  803b70:	00 00 00 
  803b73:	ff d0                	callq  *%rax
  803b75:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b7d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b81:	48 89 d6             	mov    %rdx,%rsi
  803b84:	48 89 c7             	mov    %rax,%rdi
  803b87:	48 b8 62 3a 80 00 00 	movabs $0x803a62,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
}
  803b93:	c9                   	leaveq 
  803b94:	c3                   	retq   

0000000000803b95 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b95:	55                   	push   %rbp
  803b96:	48 89 e5             	mov    %rsp,%rbp
  803b99:	48 83 ec 40          	sub    $0x40,%rsp
  803b9d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ba1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ba5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ba9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bad:	48 89 c7             	mov    %rax,%rdi
  803bb0:	48 b8 53 21 80 00 00 	movabs $0x802153,%rax
  803bb7:	00 00 00 
  803bba:	ff d0                	callq  *%rax
  803bbc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bc0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bc4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bc8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bcf:	00 
  803bd0:	e9 97 00 00 00       	jmpq   803c6c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803bd5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803bda:	74 09                	je     803be5 <devpipe_read+0x50>
				return i;
  803bdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be0:	e9 95 00 00 00       	jmpq   803c7a <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803be5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803be9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bed:	48 89 d6             	mov    %rdx,%rsi
  803bf0:	48 89 c7             	mov    %rax,%rdi
  803bf3:	48 b8 62 3a 80 00 00 	movabs $0x803a62,%rax
  803bfa:	00 00 00 
  803bfd:	ff d0                	callq  *%rax
  803bff:	85 c0                	test   %eax,%eax
  803c01:	74 07                	je     803c0a <devpipe_read+0x75>
				return 0;
  803c03:	b8 00 00 00 00       	mov    $0x0,%eax
  803c08:	eb 70                	jmp    803c7a <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803c0a:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  803c11:	00 00 00 
  803c14:	ff d0                	callq  *%rax
  803c16:	eb 01                	jmp    803c19 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c18:	90                   	nop
  803c19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c1d:	8b 10                	mov    (%rax),%edx
  803c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c23:	8b 40 04             	mov    0x4(%rax),%eax
  803c26:	39 c2                	cmp    %eax,%edx
  803c28:	74 ab                	je     803bd5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c32:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3a:	8b 00                	mov    (%rax),%eax
  803c3c:	89 c2                	mov    %eax,%edx
  803c3e:	c1 fa 1f             	sar    $0x1f,%edx
  803c41:	c1 ea 1b             	shr    $0x1b,%edx
  803c44:	01 d0                	add    %edx,%eax
  803c46:	83 e0 1f             	and    $0x1f,%eax
  803c49:	29 d0                	sub    %edx,%eax
  803c4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c4f:	48 98                	cltq   
  803c51:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803c56:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c5c:	8b 00                	mov    (%rax),%eax
  803c5e:	8d 50 01             	lea    0x1(%rax),%edx
  803c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c65:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c67:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c70:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c74:	72 a2                	jb     803c18 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c7a:	c9                   	leaveq 
  803c7b:	c3                   	retq   

0000000000803c7c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c7c:	55                   	push   %rbp
  803c7d:	48 89 e5             	mov    %rsp,%rbp
  803c80:	48 83 ec 40          	sub    $0x40,%rsp
  803c84:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c88:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c8c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c94:	48 89 c7             	mov    %rax,%rdi
  803c97:	48 b8 53 21 80 00 00 	movabs $0x802153,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
  803ca3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ca7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803caf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cb6:	00 
  803cb7:	e9 93 00 00 00       	jmpq   803d4f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803cbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cc4:	48 89 d6             	mov    %rdx,%rsi
  803cc7:	48 89 c7             	mov    %rax,%rdi
  803cca:	48 b8 62 3a 80 00 00 	movabs $0x803a62,%rax
  803cd1:	00 00 00 
  803cd4:	ff d0                	callq  *%rax
  803cd6:	85 c0                	test   %eax,%eax
  803cd8:	74 07                	je     803ce1 <devpipe_write+0x65>
				return 0;
  803cda:	b8 00 00 00 00       	mov    $0x0,%eax
  803cdf:	eb 7c                	jmp    803d5d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ce1:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  803ce8:	00 00 00 
  803ceb:	ff d0                	callq  *%rax
  803ced:	eb 01                	jmp    803cf0 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803cef:	90                   	nop
  803cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf4:	8b 40 04             	mov    0x4(%rax),%eax
  803cf7:	48 63 d0             	movslq %eax,%rdx
  803cfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfe:	8b 00                	mov    (%rax),%eax
  803d00:	48 98                	cltq   
  803d02:	48 83 c0 20          	add    $0x20,%rax
  803d06:	48 39 c2             	cmp    %rax,%rdx
  803d09:	73 b1                	jae    803cbc <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d0f:	8b 40 04             	mov    0x4(%rax),%eax
  803d12:	89 c2                	mov    %eax,%edx
  803d14:	c1 fa 1f             	sar    $0x1f,%edx
  803d17:	c1 ea 1b             	shr    $0x1b,%edx
  803d1a:	01 d0                	add    %edx,%eax
  803d1c:	83 e0 1f             	and    $0x1f,%eax
  803d1f:	29 d0                	sub    %edx,%eax
  803d21:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d25:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d29:	48 01 ca             	add    %rcx,%rdx
  803d2c:	0f b6 0a             	movzbl (%rdx),%ecx
  803d2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d33:	48 98                	cltq   
  803d35:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d3d:	8b 40 04             	mov    0x4(%rax),%eax
  803d40:	8d 50 01             	lea    0x1(%rax),%edx
  803d43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d47:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d4a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d53:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d57:	72 96                	jb     803cef <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803d59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d5d:	c9                   	leaveq 
  803d5e:	c3                   	retq   

0000000000803d5f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d5f:	55                   	push   %rbp
  803d60:	48 89 e5             	mov    %rsp,%rbp
  803d63:	48 83 ec 20          	sub    $0x20,%rsp
  803d67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d73:	48 89 c7             	mov    %rax,%rdi
  803d76:	48 b8 53 21 80 00 00 	movabs $0x802153,%rax
  803d7d:	00 00 00 
  803d80:	ff d0                	callq  *%rax
  803d82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d8a:	48 be ac 47 80 00 00 	movabs $0x8047ac,%rsi
  803d91:	00 00 00 
  803d94:	48 89 c7             	mov    %rax,%rdi
  803d97:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  803d9e:	00 00 00 
  803da1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da7:	8b 50 04             	mov    0x4(%rax),%edx
  803daa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dae:	8b 00                	mov    (%rax),%eax
  803db0:	29 c2                	sub    %eax,%edx
  803db2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803db6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803dbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803dc7:	00 00 00 
	stat->st_dev = &devpipe;
  803dca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dce:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803dd5:	00 00 00 
  803dd8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803de4:	c9                   	leaveq 
  803de5:	c3                   	retq   

0000000000803de6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803de6:	55                   	push   %rbp
  803de7:	48 89 e5             	mov    %rsp,%rbp
  803dea:	48 83 ec 10          	sub    $0x10,%rsp
  803dee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803df2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df6:	48 89 c6             	mov    %rax,%rsi
  803df9:	bf 00 00 00 00       	mov    $0x0,%edi
  803dfe:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  803e05:	00 00 00 
  803e08:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803e0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e0e:	48 89 c7             	mov    %rax,%rdi
  803e11:	48 b8 53 21 80 00 00 	movabs $0x802153,%rax
  803e18:	00 00 00 
  803e1b:	ff d0                	callq  *%rax
  803e1d:	48 89 c6             	mov    %rax,%rsi
  803e20:	bf 00 00 00 00       	mov    $0x0,%edi
  803e25:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  803e2c:	00 00 00 
  803e2f:	ff d0                	callq  *%rax
}
  803e31:	c9                   	leaveq 
  803e32:	c3                   	retq   
	...

0000000000803e34 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e34:	55                   	push   %rbp
  803e35:	48 89 e5             	mov    %rsp,%rbp
  803e38:	48 83 ec 30          	sub    $0x30,%rsp
  803e3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e44:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  803e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  803e4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e54:	74 18                	je     803e6e <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  803e56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e5a:	48 89 c7             	mov    %rax,%rdi
  803e5d:	48 b8 09 20 80 00 00 	movabs $0x802009,%rax
  803e64:	00 00 00 
  803e67:	ff d0                	callq  *%rax
  803e69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e6c:	eb 19                	jmp    803e87 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  803e6e:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  803e75:	00 00 00 
  803e78:	48 b8 09 20 80 00 00 	movabs $0x802009,%rax
  803e7f:	00 00 00 
  803e82:	ff d0                	callq  *%rax
  803e84:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  803e87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e8b:	79 39                	jns    803ec6 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  803e8d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e92:	75 08                	jne    803e9c <ipc_recv+0x68>
  803e94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e98:	8b 00                	mov    (%rax),%eax
  803e9a:	eb 05                	jmp    803ea1 <ipc_recv+0x6d>
  803e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ea5:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  803ea7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803eac:	75 08                	jne    803eb6 <ipc_recv+0x82>
  803eae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eb2:	8b 00                	mov    (%rax),%eax
  803eb4:	eb 05                	jmp    803ebb <ipc_recv+0x87>
  803eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  803ebb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803ebf:	89 02                	mov    %eax,(%rdx)
		return r;
  803ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec4:	eb 53                	jmp    803f19 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  803ec6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ecb:	74 19                	je     803ee6 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  803ecd:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803ed4:	00 00 00 
  803ed7:	48 8b 00             	mov    (%rax),%rax
  803eda:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ee0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee4:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  803ee6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803eeb:	74 19                	je     803f06 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803eed:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803ef4:	00 00 00 
  803ef7:	48 8b 00             	mov    (%rax),%rax
  803efa:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f04:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  803f06:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803f0d:	00 00 00 
  803f10:	48 8b 00             	mov    (%rax),%rax
  803f13:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  803f19:	c9                   	leaveq 
  803f1a:	c3                   	retq   

0000000000803f1b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f1b:	55                   	push   %rbp
  803f1c:	48 89 e5             	mov    %rsp,%rbp
  803f1f:	48 83 ec 30          	sub    $0x30,%rsp
  803f23:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f26:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f29:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f2d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  803f30:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  803f37:	eb 59                	jmp    803f92 <ipc_send+0x77>
		if(pg) {
  803f39:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f3e:	74 20                	je     803f60 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  803f40:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f43:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f46:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f4d:	89 c7                	mov    %eax,%edi
  803f4f:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  803f56:	00 00 00 
  803f59:	ff d0                	callq  *%rax
  803f5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f5e:	eb 26                	jmp    803f86 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  803f60:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f63:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f69:	89 d1                	mov    %edx,%ecx
  803f6b:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  803f72:	00 00 00 
  803f75:	89 c7                	mov    %eax,%edi
  803f77:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  803f7e:	00 00 00 
  803f81:	ff d0                	callq  *%rax
  803f83:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  803f86:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  803f8d:	00 00 00 
  803f90:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  803f92:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f96:	74 a1                	je     803f39 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  803f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9c:	74 2a                	je     803fc8 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  803f9e:	48 ba b8 47 80 00 00 	movabs $0x8047b8,%rdx
  803fa5:	00 00 00 
  803fa8:	be 49 00 00 00       	mov    $0x49,%esi
  803fad:	48 bf e3 47 80 00 00 	movabs $0x8047e3,%rdi
  803fb4:	00 00 00 
  803fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fbc:	48 b9 3c 05 80 00 00 	movabs $0x80053c,%rcx
  803fc3:	00 00 00 
  803fc6:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  803fc8:	c9                   	leaveq 
  803fc9:	c3                   	retq   

0000000000803fca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803fca:	55                   	push   %rbp
  803fcb:	48 89 e5             	mov    %rsp,%rbp
  803fce:	48 83 ec 18          	sub    $0x18,%rsp
  803fd2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803fd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fdc:	eb 6a                	jmp    804048 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  803fde:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fe5:	00 00 00 
  803fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803feb:	48 63 d0             	movslq %eax,%rdx
  803fee:	48 89 d0             	mov    %rdx,%rax
  803ff1:	48 c1 e0 02          	shl    $0x2,%rax
  803ff5:	48 01 d0             	add    %rdx,%rax
  803ff8:	48 01 c0             	add    %rax,%rax
  803ffb:	48 01 d0             	add    %rdx,%rax
  803ffe:	48 c1 e0 05          	shl    $0x5,%rax
  804002:	48 01 c8             	add    %rcx,%rax
  804005:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80400b:	8b 00                	mov    (%rax),%eax
  80400d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804010:	75 32                	jne    804044 <ipc_find_env+0x7a>
			return envs[i].env_id;
  804012:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804019:	00 00 00 
  80401c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80401f:	48 63 d0             	movslq %eax,%rdx
  804022:	48 89 d0             	mov    %rdx,%rax
  804025:	48 c1 e0 02          	shl    $0x2,%rax
  804029:	48 01 d0             	add    %rdx,%rax
  80402c:	48 01 c0             	add    %rax,%rax
  80402f:	48 01 d0             	add    %rdx,%rax
  804032:	48 c1 e0 05          	shl    $0x5,%rax
  804036:	48 01 c8             	add    %rcx,%rax
  804039:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80403f:	8b 40 08             	mov    0x8(%rax),%eax
  804042:	eb 12                	jmp    804056 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804044:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804048:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80404f:	7e 8d                	jle    803fde <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804051:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804056:	c9                   	leaveq 
  804057:	c3                   	retq   

0000000000804058 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804058:	55                   	push   %rbp
  804059:	48 89 e5             	mov    %rsp,%rbp
  80405c:	48 83 ec 18          	sub    $0x18,%rsp
  804060:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804068:	48 89 c2             	mov    %rax,%rdx
  80406b:	48 c1 ea 15          	shr    $0x15,%rdx
  80406f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804076:	01 00 00 
  804079:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80407d:	83 e0 01             	and    $0x1,%eax
  804080:	48 85 c0             	test   %rax,%rax
  804083:	75 07                	jne    80408c <pageref+0x34>
		return 0;
  804085:	b8 00 00 00 00       	mov    $0x0,%eax
  80408a:	eb 53                	jmp    8040df <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80408c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804090:	48 89 c2             	mov    %rax,%rdx
  804093:	48 c1 ea 0c          	shr    $0xc,%rdx
  804097:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80409e:	01 00 00 
  8040a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ad:	83 e0 01             	and    $0x1,%eax
  8040b0:	48 85 c0             	test   %rax,%rax
  8040b3:	75 07                	jne    8040bc <pageref+0x64>
		return 0;
  8040b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ba:	eb 23                	jmp    8040df <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040c0:	48 89 c2             	mov    %rax,%rdx
  8040c3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8040c7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040ce:	00 00 00 
  8040d1:	48 c1 e2 04          	shl    $0x4,%rdx
  8040d5:	48 01 d0             	add    %rdx,%rax
  8040d8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040dc:	0f b7 c0             	movzwl %ax,%eax
}
  8040df:	c9                   	leaveq 
  8040e0:	c3                   	retq   
