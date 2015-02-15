
obj/user/echo.debug:     file format elf64-x86-64


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
  80003c:	e8 03 01 00 00       	callq  800144 <libmain>
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
	int i, nflag;

	nflag = 0;
  800053:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80005a:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005e:	7e 38                	jle    800098 <umain+0x54>
  800060:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800064:	48 83 c0 08          	add    $0x8,%rax
  800068:	48 8b 00             	mov    (%rax),%rax
  80006b:	48 be 20 3c 80 00 00 	movabs $0x803c20,%rsi
  800072:	00 00 00 
  800075:	48 89 c7             	mov    %rax,%rdi
  800078:	48 b8 d7 03 80 00 00 	movabs $0x8003d7,%rax
  80007f:	00 00 00 
  800082:	ff d0                	callq  *%rax
  800084:	85 c0                	test   %eax,%eax
  800086:	75 10                	jne    800098 <umain+0x54>
		nflag = 1;
  800088:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008f:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800093:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800098:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009f:	eb 70                	jmp    800111 <umain+0xcd>
		if (i > 1)
  8000a1:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a5:	7e 20                	jle    8000c7 <umain+0x83>
			write(1, " ", 1);
  8000a7:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ac:	48 be 23 3c 80 00 00 	movabs $0x803c23,%rsi
  8000b3:	00 00 00 
  8000b6:	bf 01 00 00 00       	mov    $0x1,%edi
  8000bb:	48 b8 6a 15 80 00 00 	movabs $0x80156a,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ca:	48 98                	cltq   
  8000cc:	48 c1 e0 03          	shl    $0x3,%rax
  8000d0:	48 03 45 e0          	add    -0x20(%rbp),%rax
  8000d4:	48 8b 00             	mov    (%rax),%rax
  8000d7:	48 89 c7             	mov    %rax,%rdi
  8000da:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax
  8000e6:	48 63 d0             	movslq %eax,%rdx
  8000e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ec:	48 98                	cltq   
  8000ee:	48 c1 e0 03          	shl    $0x3,%rax
  8000f2:	48 03 45 e0          	add    -0x20(%rbp),%rax
  8000f6:	48 8b 00             	mov    (%rax),%rax
  8000f9:	48 89 c6             	mov    %rax,%rsi
  8000fc:	bf 01 00 00 00       	mov    $0x1,%edi
  800101:	48 b8 6a 15 80 00 00 	movabs $0x80156a,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80010d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800111:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800114:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800117:	7c 88                	jl     8000a1 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  800119:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011d:	75 20                	jne    80013f <umain+0xfb>
		write(1, "\n", 1);
  80011f:	ba 01 00 00 00       	mov    $0x1,%edx
  800124:	48 be 25 3c 80 00 00 	movabs $0x803c25,%rsi
  80012b:	00 00 00 
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
  800133:	48 b8 6a 15 80 00 00 	movabs $0x80156a,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	callq  *%rax
}
  80013f:	c9                   	leaveq 
  800140:	c3                   	retq   
  800141:	00 00                	add    %al,(%rax)
	...

0000000000800144 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800144:	55                   	push   %rbp
  800145:	48 89 e5             	mov    %rsp,%rbp
  800148:	48 83 ec 10          	sub    $0x10,%rsp
  80014c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80014f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800153:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80015a:	00 00 00 
  80015d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  800164:	48 b8 38 0b 80 00 00 	movabs $0x800b38,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
  800170:	48 98                	cltq   
  800172:	48 89 c2             	mov    %rax,%rdx
  800175:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80017b:	48 89 d0             	mov    %rdx,%rax
  80017e:	48 c1 e0 02          	shl    $0x2,%rax
  800182:	48 01 d0             	add    %rdx,%rax
  800185:	48 01 c0             	add    %rax,%rax
  800188:	48 01 d0             	add    %rdx,%rax
  80018b:	48 c1 e0 05          	shl    $0x5,%rax
  80018f:	48 89 c2             	mov    %rax,%rdx
  800192:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800199:	00 00 00 
  80019c:	48 01 c2             	add    %rax,%rdx
  80019f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001a6:	00 00 00 
  8001a9:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001b0:	7e 14                	jle    8001c6 <libmain+0x82>
		binaryname = argv[0];
  8001b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b6:	48 8b 10             	mov    (%rax),%rdx
  8001b9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001c0:	00 00 00 
  8001c3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001cd:	48 89 d6             	mov    %rdx,%rsi
  8001d0:	89 c7                	mov    %eax,%edi
  8001d2:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001de:	48 b8 ec 01 80 00 00 	movabs $0x8001ec,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
}
  8001ea:	c9                   	leaveq 
  8001eb:	c3                   	retq   

00000000008001ec <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ec:	55                   	push   %rbp
  8001ed:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001f0:	48 b8 45 12 80 00 00 	movabs $0x801245,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001fc:	bf 00 00 00 00       	mov    $0x0,%edi
  800201:	48 b8 f4 0a 80 00 00 	movabs $0x800af4,%rax
  800208:	00 00 00 
  80020b:	ff d0                	callq  *%rax
}
  80020d:	5d                   	pop    %rbp
  80020e:	c3                   	retq   
	...

0000000000800210 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800210:	55                   	push   %rbp
  800211:	48 89 e5             	mov    %rsp,%rbp
  800214:	48 83 ec 18          	sub    $0x18,%rsp
  800218:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80021c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800223:	eb 09                	jmp    80022e <strlen+0x1e>
		n++;
  800225:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800229:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80022e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800232:	0f b6 00             	movzbl (%rax),%eax
  800235:	84 c0                	test   %al,%al
  800237:	75 ec                	jne    800225 <strlen+0x15>
		n++;
	return n;
  800239:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80023c:	c9                   	leaveq 
  80023d:	c3                   	retq   

000000000080023e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80023e:	55                   	push   %rbp
  80023f:	48 89 e5             	mov    %rsp,%rbp
  800242:	48 83 ec 20          	sub    $0x20,%rsp
  800246:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80024a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80024e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800255:	eb 0e                	jmp    800265 <strnlen+0x27>
		n++;
  800257:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80025b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800260:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800265:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80026a:	74 0b                	je     800277 <strnlen+0x39>
  80026c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800270:	0f b6 00             	movzbl (%rax),%eax
  800273:	84 c0                	test   %al,%al
  800275:	75 e0                	jne    800257 <strnlen+0x19>
		n++;
	return n;
  800277:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80027a:	c9                   	leaveq 
  80027b:	c3                   	retq   

000000000080027c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80027c:	55                   	push   %rbp
  80027d:	48 89 e5             	mov    %rsp,%rbp
  800280:	48 83 ec 20          	sub    $0x20,%rsp
  800284:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800288:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80028c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800290:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800294:	90                   	nop
  800295:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800299:	0f b6 10             	movzbl (%rax),%edx
  80029c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002a0:	88 10                	mov    %dl,(%rax)
  8002a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002a6:	0f b6 00             	movzbl (%rax),%eax
  8002a9:	84 c0                	test   %al,%al
  8002ab:	0f 95 c0             	setne  %al
  8002ae:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8002b3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8002b8:	84 c0                	test   %al,%al
  8002ba:	75 d9                	jne    800295 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002c0:	c9                   	leaveq 
  8002c1:	c3                   	retq   

00000000008002c2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002c2:	55                   	push   %rbp
  8002c3:	48 89 e5             	mov    %rsp,%rbp
  8002c6:	48 83 ec 20          	sub    $0x20,%rsp
  8002ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002d6:	48 89 c7             	mov    %rax,%rdi
  8002d9:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  8002e0:	00 00 00 
  8002e3:	ff d0                	callq  *%rax
  8002e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002eb:	48 98                	cltq   
  8002ed:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8002f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002f5:	48 89 d6             	mov    %rdx,%rsi
  8002f8:	48 89 c7             	mov    %rax,%rdi
  8002fb:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  800302:	00 00 00 
  800305:	ff d0                	callq  *%rax
	return dst;
  800307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80030b:	c9                   	leaveq 
  80030c:	c3                   	retq   

000000000080030d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80030d:	55                   	push   %rbp
  80030e:	48 89 e5             	mov    %rsp,%rbp
  800311:	48 83 ec 28          	sub    $0x28,%rsp
  800315:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800319:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80031d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800325:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800329:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800330:	00 
  800331:	eb 27                	jmp    80035a <strncpy+0x4d>
		*dst++ = *src;
  800333:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800337:	0f b6 10             	movzbl (%rax),%edx
  80033a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033e:	88 10                	mov    %dl,(%rax)
  800340:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800345:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800349:	0f b6 00             	movzbl (%rax),%eax
  80034c:	84 c0                	test   %al,%al
  80034e:	74 05                	je     800355 <strncpy+0x48>
			src++;
  800350:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800355:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80035a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80035e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800362:	72 cf                	jb     800333 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800368:	c9                   	leaveq 
  800369:	c3                   	retq   

000000000080036a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80036a:	55                   	push   %rbp
  80036b:	48 89 e5             	mov    %rsp,%rbp
  80036e:	48 83 ec 28          	sub    $0x28,%rsp
  800372:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800376:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80037a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80037e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800382:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800386:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80038b:	74 37                	je     8003c4 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80038d:	eb 17                	jmp    8003a6 <strlcpy+0x3c>
			*dst++ = *src++;
  80038f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800393:	0f b6 10             	movzbl (%rax),%edx
  800396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80039a:	88 10                	mov    %dl,(%rax)
  80039c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8003a1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8003a6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8003ab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003b0:	74 0b                	je     8003bd <strlcpy+0x53>
  8003b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003b6:	0f b6 00             	movzbl (%rax),%eax
  8003b9:	84 c0                	test   %al,%al
  8003bb:	75 d2                	jne    80038f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003cc:	48 89 d1             	mov    %rdx,%rcx
  8003cf:	48 29 c1             	sub    %rax,%rcx
  8003d2:	48 89 c8             	mov    %rcx,%rax
}
  8003d5:	c9                   	leaveq 
  8003d6:	c3                   	retq   

00000000008003d7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003d7:	55                   	push   %rbp
  8003d8:	48 89 e5             	mov    %rsp,%rbp
  8003db:	48 83 ec 10          	sub    $0x10,%rsp
  8003df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003e7:	eb 0a                	jmp    8003f3 <strcmp+0x1c>
		p++, q++;
  8003e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003ee:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f7:	0f b6 00             	movzbl (%rax),%eax
  8003fa:	84 c0                	test   %al,%al
  8003fc:	74 12                	je     800410 <strcmp+0x39>
  8003fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800402:	0f b6 10             	movzbl (%rax),%edx
  800405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800409:	0f b6 00             	movzbl (%rax),%eax
  80040c:	38 c2                	cmp    %al,%dl
  80040e:	74 d9                	je     8003e9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800414:	0f b6 00             	movzbl (%rax),%eax
  800417:	0f b6 d0             	movzbl %al,%edx
  80041a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041e:	0f b6 00             	movzbl (%rax),%eax
  800421:	0f b6 c0             	movzbl %al,%eax
  800424:	89 d1                	mov    %edx,%ecx
  800426:	29 c1                	sub    %eax,%ecx
  800428:	89 c8                	mov    %ecx,%eax
}
  80042a:	c9                   	leaveq 
  80042b:	c3                   	retq   

000000000080042c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80042c:	55                   	push   %rbp
  80042d:	48 89 e5             	mov    %rsp,%rbp
  800430:	48 83 ec 18          	sub    $0x18,%rsp
  800434:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800438:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80043c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800440:	eb 0f                	jmp    800451 <strncmp+0x25>
		n--, p++, q++;
  800442:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800447:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80044c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800451:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800456:	74 1d                	je     800475 <strncmp+0x49>
  800458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80045c:	0f b6 00             	movzbl (%rax),%eax
  80045f:	84 c0                	test   %al,%al
  800461:	74 12                	je     800475 <strncmp+0x49>
  800463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800467:	0f b6 10             	movzbl (%rax),%edx
  80046a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046e:	0f b6 00             	movzbl (%rax),%eax
  800471:	38 c2                	cmp    %al,%dl
  800473:	74 cd                	je     800442 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800475:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80047a:	75 07                	jne    800483 <strncmp+0x57>
		return 0;
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	eb 1a                	jmp    80049d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800487:	0f b6 00             	movzbl (%rax),%eax
  80048a:	0f b6 d0             	movzbl %al,%edx
  80048d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800491:	0f b6 00             	movzbl (%rax),%eax
  800494:	0f b6 c0             	movzbl %al,%eax
  800497:	89 d1                	mov    %edx,%ecx
  800499:	29 c1                	sub    %eax,%ecx
  80049b:	89 c8                	mov    %ecx,%eax
}
  80049d:	c9                   	leaveq 
  80049e:	c3                   	retq   

000000000080049f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80049f:	55                   	push   %rbp
  8004a0:	48 89 e5             	mov    %rsp,%rbp
  8004a3:	48 83 ec 10          	sub    $0x10,%rsp
  8004a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004ab:	89 f0                	mov    %esi,%eax
  8004ad:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004b0:	eb 17                	jmp    8004c9 <strchr+0x2a>
		if (*s == c)
  8004b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004b6:	0f b6 00             	movzbl (%rax),%eax
  8004b9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004bc:	75 06                	jne    8004c4 <strchr+0x25>
			return (char *) s;
  8004be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c2:	eb 15                	jmp    8004d9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004cd:	0f b6 00             	movzbl (%rax),%eax
  8004d0:	84 c0                	test   %al,%al
  8004d2:	75 de                	jne    8004b2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004d9:	c9                   	leaveq 
  8004da:	c3                   	retq   

00000000008004db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004db:	55                   	push   %rbp
  8004dc:	48 89 e5             	mov    %rsp,%rbp
  8004df:	48 83 ec 10          	sub    $0x10,%rsp
  8004e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004e7:	89 f0                	mov    %esi,%eax
  8004e9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004ec:	eb 11                	jmp    8004ff <strfind+0x24>
		if (*s == c)
  8004ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f2:	0f b6 00             	movzbl (%rax),%eax
  8004f5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004f8:	74 12                	je     80050c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800503:	0f b6 00             	movzbl (%rax),%eax
  800506:	84 c0                	test   %al,%al
  800508:	75 e4                	jne    8004ee <strfind+0x13>
  80050a:	eb 01                	jmp    80050d <strfind+0x32>
		if (*s == c)
			break;
  80050c:	90                   	nop
	return (char *) s;
  80050d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800511:	c9                   	leaveq 
  800512:	c3                   	retq   

0000000000800513 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800513:	55                   	push   %rbp
  800514:	48 89 e5             	mov    %rsp,%rbp
  800517:	48 83 ec 18          	sub    $0x18,%rsp
  80051b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80051f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  800522:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  800526:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80052b:	75 06                	jne    800533 <memset+0x20>
		return v;
  80052d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800531:	eb 69                	jmp    80059c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  800533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800537:	83 e0 03             	and    $0x3,%eax
  80053a:	48 85 c0             	test   %rax,%rax
  80053d:	75 48                	jne    800587 <memset+0x74>
  80053f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800543:	83 e0 03             	and    $0x3,%eax
  800546:	48 85 c0             	test   %rax,%rax
  800549:	75 3c                	jne    800587 <memset+0x74>
		c &= 0xFF;
  80054b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800552:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800555:	89 c2                	mov    %eax,%edx
  800557:	c1 e2 18             	shl    $0x18,%edx
  80055a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80055d:	c1 e0 10             	shl    $0x10,%eax
  800560:	09 c2                	or     %eax,%edx
  800562:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800565:	c1 e0 08             	shl    $0x8,%eax
  800568:	09 d0                	or     %edx,%eax
  80056a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80056d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800571:	48 89 c1             	mov    %rax,%rcx
  800574:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800578:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80057c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80057f:	48 89 d7             	mov    %rdx,%rdi
  800582:	fc                   	cld    
  800583:	f3 ab                	rep stos %eax,%es:(%rdi)
  800585:	eb 11                	jmp    800598 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800587:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80058b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80058e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800592:	48 89 d7             	mov    %rdx,%rdi
  800595:	fc                   	cld    
  800596:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  800598:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80059c:	c9                   	leaveq 
  80059d:	c3                   	retq   

000000000080059e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80059e:	55                   	push   %rbp
  80059f:	48 89 e5             	mov    %rsp,%rbp
  8005a2:	48 83 ec 28          	sub    $0x28,%rsp
  8005a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8005b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005ca:	0f 83 88 00 00 00    	jae    800658 <memmove+0xba>
  8005d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005d8:	48 01 d0             	add    %rdx,%rax
  8005db:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005df:	76 77                	jbe    800658 <memmove+0xba>
		s += n;
  8005e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ed:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005f5:	83 e0 03             	and    $0x3,%eax
  8005f8:	48 85 c0             	test   %rax,%rax
  8005fb:	75 3b                	jne    800638 <memmove+0x9a>
  8005fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800601:	83 e0 03             	and    $0x3,%eax
  800604:	48 85 c0             	test   %rax,%rax
  800607:	75 2f                	jne    800638 <memmove+0x9a>
  800609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80060d:	83 e0 03             	and    $0x3,%eax
  800610:	48 85 c0             	test   %rax,%rax
  800613:	75 23                	jne    800638 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800619:	48 83 e8 04          	sub    $0x4,%rax
  80061d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800621:	48 83 ea 04          	sub    $0x4,%rdx
  800625:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800629:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80062d:	48 89 c7             	mov    %rax,%rdi
  800630:	48 89 d6             	mov    %rdx,%rsi
  800633:	fd                   	std    
  800634:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800636:	eb 1d                	jmp    800655 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800644:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80064c:	48 89 d7             	mov    %rdx,%rdi
  80064f:	48 89 c1             	mov    %rax,%rcx
  800652:	fd                   	std    
  800653:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800655:	fc                   	cld    
  800656:	eb 57                	jmp    8006af <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  800658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80065c:	83 e0 03             	and    $0x3,%eax
  80065f:	48 85 c0             	test   %rax,%rax
  800662:	75 36                	jne    80069a <memmove+0xfc>
  800664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800668:	83 e0 03             	and    $0x3,%eax
  80066b:	48 85 c0             	test   %rax,%rax
  80066e:	75 2a                	jne    80069a <memmove+0xfc>
  800670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800674:	83 e0 03             	and    $0x3,%eax
  800677:	48 85 c0             	test   %rax,%rax
  80067a:	75 1e                	jne    80069a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80067c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800680:	48 89 c1             	mov    %rax,%rcx
  800683:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80068f:	48 89 c7             	mov    %rax,%rdi
  800692:	48 89 d6             	mov    %rdx,%rsi
  800695:	fc                   	cld    
  800696:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800698:	eb 15                	jmp    8006af <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80069a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006a2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8006a6:	48 89 c7             	mov    %rax,%rdi
  8006a9:	48 89 d6             	mov    %rdx,%rsi
  8006ac:	fc                   	cld    
  8006ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8006b3:	c9                   	leaveq 
  8006b4:	c3                   	retq   

00000000008006b5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8006b5:	55                   	push   %rbp
  8006b6:	48 89 e5             	mov    %rsp,%rbp
  8006b9:	48 83 ec 18          	sub    $0x18,%rsp
  8006bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006d5:	48 89 ce             	mov    %rcx,%rsi
  8006d8:	48 89 c7             	mov    %rax,%rdi
  8006db:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  8006e2:	00 00 00 
  8006e5:	ff d0                	callq  *%rax
}
  8006e7:	c9                   	leaveq 
  8006e8:	c3                   	retq   

00000000008006e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006e9:	55                   	push   %rbp
  8006ea:	48 89 e5             	mov    %rsp,%rbp
  8006ed:	48 83 ec 28          	sub    $0x28,%rsp
  8006f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800701:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800705:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800709:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80070d:	eb 38                	jmp    800747 <memcmp+0x5e>
		if (*s1 != *s2)
  80070f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800713:	0f b6 10             	movzbl (%rax),%edx
  800716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071a:	0f b6 00             	movzbl (%rax),%eax
  80071d:	38 c2                	cmp    %al,%dl
  80071f:	74 1c                	je     80073d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  800721:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800725:	0f b6 00             	movzbl (%rax),%eax
  800728:	0f b6 d0             	movzbl %al,%edx
  80072b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072f:	0f b6 00             	movzbl (%rax),%eax
  800732:	0f b6 c0             	movzbl %al,%eax
  800735:	89 d1                	mov    %edx,%ecx
  800737:	29 c1                	sub    %eax,%ecx
  800739:	89 c8                	mov    %ecx,%eax
  80073b:	eb 20                	jmp    80075d <memcmp+0x74>
		s1++, s2++;
  80073d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800742:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800747:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80074c:	0f 95 c0             	setne  %al
  80074f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800754:	84 c0                	test   %al,%al
  800756:	75 b7                	jne    80070f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800758:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80075d:	c9                   	leaveq 
  80075e:	c3                   	retq   

000000000080075f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80075f:	55                   	push   %rbp
  800760:	48 89 e5             	mov    %rsp,%rbp
  800763:	48 83 ec 28          	sub    $0x28,%rsp
  800767:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80076b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80076e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  800772:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800776:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077a:	48 01 d0             	add    %rdx,%rax
  80077d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800781:	eb 13                	jmp    800796 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  800783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800787:	0f b6 10             	movzbl (%rax),%edx
  80078a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80078d:	38 c2                	cmp    %al,%dl
  80078f:	74 11                	je     8007a2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800791:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80079e:	72 e3                	jb     800783 <memfind+0x24>
  8007a0:	eb 01                	jmp    8007a3 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8007a2:	90                   	nop
	return (void *) s;
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8007a7:	c9                   	leaveq 
  8007a8:	c3                   	retq   

00000000008007a9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8007a9:	55                   	push   %rbp
  8007aa:	48 89 e5             	mov    %rsp,%rbp
  8007ad:	48 83 ec 38          	sub    $0x38,%rsp
  8007b1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007b5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007b9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007c3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007ca:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007cb:	eb 05                	jmp    8007d2 <strtol+0x29>
		s++;
  8007cd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d6:	0f b6 00             	movzbl (%rax),%eax
  8007d9:	3c 20                	cmp    $0x20,%al
  8007db:	74 f0                	je     8007cd <strtol+0x24>
  8007dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007e1:	0f b6 00             	movzbl (%rax),%eax
  8007e4:	3c 09                	cmp    $0x9,%al
  8007e6:	74 e5                	je     8007cd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ec:	0f b6 00             	movzbl (%rax),%eax
  8007ef:	3c 2b                	cmp    $0x2b,%al
  8007f1:	75 07                	jne    8007fa <strtol+0x51>
		s++;
  8007f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007f8:	eb 17                	jmp    800811 <strtol+0x68>
	else if (*s == '-')
  8007fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007fe:	0f b6 00             	movzbl (%rax),%eax
  800801:	3c 2d                	cmp    $0x2d,%al
  800803:	75 0c                	jne    800811 <strtol+0x68>
		s++, neg = 1;
  800805:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80080a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800811:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800815:	74 06                	je     80081d <strtol+0x74>
  800817:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80081b:	75 28                	jne    800845 <strtol+0x9c>
  80081d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800821:	0f b6 00             	movzbl (%rax),%eax
  800824:	3c 30                	cmp    $0x30,%al
  800826:	75 1d                	jne    800845 <strtol+0x9c>
  800828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80082c:	48 83 c0 01          	add    $0x1,%rax
  800830:	0f b6 00             	movzbl (%rax),%eax
  800833:	3c 78                	cmp    $0x78,%al
  800835:	75 0e                	jne    800845 <strtol+0x9c>
		s += 2, base = 16;
  800837:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80083c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  800843:	eb 2c                	jmp    800871 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  800845:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800849:	75 19                	jne    800864 <strtol+0xbb>
  80084b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80084f:	0f b6 00             	movzbl (%rax),%eax
  800852:	3c 30                	cmp    $0x30,%al
  800854:	75 0e                	jne    800864 <strtol+0xbb>
		s++, base = 8;
  800856:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80085b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800862:	eb 0d                	jmp    800871 <strtol+0xc8>
	else if (base == 0)
  800864:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800868:	75 07                	jne    800871 <strtol+0xc8>
		base = 10;
  80086a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800875:	0f b6 00             	movzbl (%rax),%eax
  800878:	3c 2f                	cmp    $0x2f,%al
  80087a:	7e 1d                	jle    800899 <strtol+0xf0>
  80087c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800880:	0f b6 00             	movzbl (%rax),%eax
  800883:	3c 39                	cmp    $0x39,%al
  800885:	7f 12                	jg     800899 <strtol+0xf0>
			dig = *s - '0';
  800887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80088b:	0f b6 00             	movzbl (%rax),%eax
  80088e:	0f be c0             	movsbl %al,%eax
  800891:	83 e8 30             	sub    $0x30,%eax
  800894:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800897:	eb 4e                	jmp    8008e7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  800899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089d:	0f b6 00             	movzbl (%rax),%eax
  8008a0:	3c 60                	cmp    $0x60,%al
  8008a2:	7e 1d                	jle    8008c1 <strtol+0x118>
  8008a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a8:	0f b6 00             	movzbl (%rax),%eax
  8008ab:	3c 7a                	cmp    $0x7a,%al
  8008ad:	7f 12                	jg     8008c1 <strtol+0x118>
			dig = *s - 'a' + 10;
  8008af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b3:	0f b6 00             	movzbl (%rax),%eax
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	83 e8 57             	sub    $0x57,%eax
  8008bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008bf:	eb 26                	jmp    8008e7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c5:	0f b6 00             	movzbl (%rax),%eax
  8008c8:	3c 40                	cmp    $0x40,%al
  8008ca:	7e 47                	jle    800913 <strtol+0x16a>
  8008cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008d0:	0f b6 00             	movzbl (%rax),%eax
  8008d3:	3c 5a                	cmp    $0x5a,%al
  8008d5:	7f 3c                	jg     800913 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8008d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008db:	0f b6 00             	movzbl (%rax),%eax
  8008de:	0f be c0             	movsbl %al,%eax
  8008e1:	83 e8 37             	sub    $0x37,%eax
  8008e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008ea:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008ed:	7d 23                	jge    800912 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8008ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008f4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008f7:	48 98                	cltq   
  8008f9:	48 89 c2             	mov    %rax,%rdx
  8008fc:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  800901:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800904:	48 98                	cltq   
  800906:	48 01 d0             	add    %rdx,%rax
  800909:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80090d:	e9 5f ff ff ff       	jmpq   800871 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800912:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800913:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800918:	74 0b                	je     800925 <strtol+0x17c>
		*endptr = (char *) s;
  80091a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80091e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800922:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  800925:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800929:	74 09                	je     800934 <strtol+0x18b>
  80092b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80092f:	48 f7 d8             	neg    %rax
  800932:	eb 04                	jmp    800938 <strtol+0x18f>
  800934:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800938:	c9                   	leaveq 
  800939:	c3                   	retq   

000000000080093a <strstr>:

char * strstr(const char *in, const char *str)
{
  80093a:	55                   	push   %rbp
  80093b:	48 89 e5             	mov    %rsp,%rbp
  80093e:	48 83 ec 30          	sub    $0x30,%rsp
  800942:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800946:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80094a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80094e:	0f b6 00             	movzbl (%rax),%eax
  800951:	88 45 ff             	mov    %al,-0x1(%rbp)
  800954:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  800959:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80095d:	75 06                	jne    800965 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  80095f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800963:	eb 68                	jmp    8009cd <strstr+0x93>

	len = strlen(str);
  800965:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800969:	48 89 c7             	mov    %rax,%rdi
  80096c:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  800973:	00 00 00 
  800976:	ff d0                	callq  *%rax
  800978:	48 98                	cltq   
  80097a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80097e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800982:	0f b6 00             	movzbl (%rax),%eax
  800985:	88 45 ef             	mov    %al,-0x11(%rbp)
  800988:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  80098d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  800991:	75 07                	jne    80099a <strstr+0x60>
				return (char *) 0;
  800993:	b8 00 00 00 00       	mov    $0x0,%eax
  800998:	eb 33                	jmp    8009cd <strstr+0x93>
		} while (sc != c);
  80099a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80099e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8009a1:	75 db                	jne    80097e <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  8009a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009a7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8009ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009af:	48 89 ce             	mov    %rcx,%rsi
  8009b2:	48 89 c7             	mov    %rax,%rdi
  8009b5:	48 b8 2c 04 80 00 00 	movabs $0x80042c,%rax
  8009bc:	00 00 00 
  8009bf:	ff d0                	callq  *%rax
  8009c1:	85 c0                	test   %eax,%eax
  8009c3:	75 b9                	jne    80097e <strstr+0x44>

	return (char *) (in - 1);
  8009c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c9:	48 83 e8 01          	sub    $0x1,%rax
}
  8009cd:	c9                   	leaveq 
  8009ce:	c3                   	retq   
	...

00000000008009d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009d0:	55                   	push   %rbp
  8009d1:	48 89 e5             	mov    %rsp,%rbp
  8009d4:	53                   	push   %rbx
  8009d5:	48 83 ec 58          	sub    $0x58,%rsp
  8009d9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009dc:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009df:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009e3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009e7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009eb:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009f2:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8009f5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009f9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009fd:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800a01:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800a05:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800a09:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a0c:	4c 89 c3             	mov    %r8,%rbx
  800a0f:	cd 30                	int    $0x30
  800a11:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  800a15:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800a19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a1d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a21:	74 3e                	je     800a61 <syscall+0x91>
  800a23:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a28:	7e 37                	jle    800a61 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a31:	49 89 d0             	mov    %rdx,%r8
  800a34:	89 c1                	mov    %eax,%ecx
  800a36:	48 ba 31 3c 80 00 00 	movabs $0x803c31,%rdx
  800a3d:	00 00 00 
  800a40:	be 23 00 00 00       	mov    $0x23,%esi
  800a45:	48 bf 4e 3c 80 00 00 	movabs $0x803c4e,%rdi
  800a4c:	00 00 00 
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a54:	49 b9 b4 2b 80 00 00 	movabs $0x802bb4,%r9
  800a5b:	00 00 00 
  800a5e:	41 ff d1             	callq  *%r9

	return ret;
  800a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a65:	48 83 c4 58          	add    $0x58,%rsp
  800a69:	5b                   	pop    %rbx
  800a6a:	5d                   	pop    %rbp
  800a6b:	c3                   	retq   

0000000000800a6c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a6c:	55                   	push   %rbp
  800a6d:	48 89 e5             	mov    %rsp,%rbp
  800a70:	48 83 ec 20          	sub    $0x20,%rsp
  800a74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a8b:	00 
  800a8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a98:	48 89 d1             	mov    %rdx,%rcx
  800a9b:	48 89 c2             	mov    %rax,%rdx
  800a9e:	be 00 00 00 00       	mov    $0x0,%esi
  800aa3:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa8:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax
}
  800ab4:	c9                   	leaveq 
  800ab5:	c3                   	retq   

0000000000800ab6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ab6:	55                   	push   %rbp
  800ab7:	48 89 e5             	mov    %rsp,%rbp
  800aba:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800abe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ac5:	00 
  800ac6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800acc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ad2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  800adc:	be 00 00 00 00       	mov    $0x0,%esi
  800ae1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae6:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800aed:	00 00 00 
  800af0:	ff d0                	callq  *%rax
}
  800af2:	c9                   	leaveq 
  800af3:	c3                   	retq   

0000000000800af4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800af4:	55                   	push   %rbp
  800af5:	48 89 e5             	mov    %rsp,%rbp
  800af8:	48 83 ec 20          	sub    $0x20,%rsp
  800afc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800aff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b02:	48 98                	cltq   
  800b04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b0b:	00 
  800b0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1d:	48 89 c2             	mov    %rax,%rdx
  800b20:	be 01 00 00 00       	mov    $0x1,%esi
  800b25:	bf 03 00 00 00       	mov    $0x3,%edi
  800b2a:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800b31:	00 00 00 
  800b34:	ff d0                	callq  *%rax
}
  800b36:	c9                   	leaveq 
  800b37:	c3                   	retq   

0000000000800b38 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b38:	55                   	push   %rbp
  800b39:	48 89 e5             	mov    %rsp,%rbp
  800b3c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b47:	00 
  800b48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b54:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b59:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5e:	be 00 00 00 00       	mov    $0x0,%esi
  800b63:	bf 02 00 00 00       	mov    $0x2,%edi
  800b68:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800b6f:	00 00 00 
  800b72:	ff d0                	callq  *%rax
}
  800b74:	c9                   	leaveq 
  800b75:	c3                   	retq   

0000000000800b76 <sys_yield>:

void
sys_yield(void)
{
  800b76:	55                   	push   %rbp
  800b77:	48 89 e5             	mov    %rsp,%rbp
  800b7a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b85:	00 
  800b86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b8c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b97:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9c:	be 00 00 00 00       	mov    $0x0,%esi
  800ba1:	bf 0b 00 00 00       	mov    $0xb,%edi
  800ba6:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800bad:	00 00 00 
  800bb0:	ff d0                	callq  *%rax
}
  800bb2:	c9                   	leaveq 
  800bb3:	c3                   	retq   

0000000000800bb4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb4:	55                   	push   %rbp
  800bb5:	48 89 e5             	mov    %rsp,%rbp
  800bb8:	48 83 ec 20          	sub    $0x20,%rsp
  800bbc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bbf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bc3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800bc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bc9:	48 63 c8             	movslq %eax,%rcx
  800bcc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bd3:	48 98                	cltq   
  800bd5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800bdc:	00 
  800bdd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800be3:	49 89 c8             	mov    %rcx,%r8
  800be6:	48 89 d1             	mov    %rdx,%rcx
  800be9:	48 89 c2             	mov    %rax,%rdx
  800bec:	be 01 00 00 00       	mov    $0x1,%esi
  800bf1:	bf 04 00 00 00       	mov    $0x4,%edi
  800bf6:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800bfd:	00 00 00 
  800c00:	ff d0                	callq  *%rax
}
  800c02:	c9                   	leaveq 
  800c03:	c3                   	retq   

0000000000800c04 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c04:	55                   	push   %rbp
  800c05:	48 89 e5             	mov    %rsp,%rbp
  800c08:	48 83 ec 30          	sub    $0x30,%rsp
  800c0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800c13:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800c16:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c1a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800c1e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c21:	48 63 c8             	movslq %eax,%rcx
  800c24:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c28:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c2b:	48 63 f0             	movslq %eax,%rsi
  800c2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c35:	48 98                	cltq   
  800c37:	48 89 0c 24          	mov    %rcx,(%rsp)
  800c3b:	49 89 f9             	mov    %rdi,%r9
  800c3e:	49 89 f0             	mov    %rsi,%r8
  800c41:	48 89 d1             	mov    %rdx,%rcx
  800c44:	48 89 c2             	mov    %rax,%rdx
  800c47:	be 01 00 00 00       	mov    $0x1,%esi
  800c4c:	bf 05 00 00 00       	mov    $0x5,%edi
  800c51:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800c58:	00 00 00 
  800c5b:	ff d0                	callq  *%rax
}
  800c5d:	c9                   	leaveq 
  800c5e:	c3                   	retq   

0000000000800c5f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c5f:	55                   	push   %rbp
  800c60:	48 89 e5             	mov    %rsp,%rbp
  800c63:	48 83 ec 20          	sub    $0x20,%rsp
  800c67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c75:	48 98                	cltq   
  800c77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c7e:	00 
  800c7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c8b:	48 89 d1             	mov    %rdx,%rcx
  800c8e:	48 89 c2             	mov    %rax,%rdx
  800c91:	be 01 00 00 00       	mov    $0x1,%esi
  800c96:	bf 06 00 00 00       	mov    $0x6,%edi
  800c9b:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800ca2:	00 00 00 
  800ca5:	ff d0                	callq  *%rax
}
  800ca7:	c9                   	leaveq 
  800ca8:	c3                   	retq   

0000000000800ca9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ca9:	55                   	push   %rbp
  800caa:	48 89 e5             	mov    %rsp,%rbp
  800cad:	48 83 ec 20          	sub    $0x20,%rsp
  800cb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cb4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800cb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cba:	48 63 d0             	movslq %eax,%rdx
  800cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cc0:	48 98                	cltq   
  800cc2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cc9:	00 
  800cca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cd6:	48 89 d1             	mov    %rdx,%rcx
  800cd9:	48 89 c2             	mov    %rax,%rdx
  800cdc:	be 01 00 00 00       	mov    $0x1,%esi
  800ce1:	bf 08 00 00 00       	mov    $0x8,%edi
  800ce6:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800ced:	00 00 00 
  800cf0:	ff d0                	callq  *%rax
}
  800cf2:	c9                   	leaveq 
  800cf3:	c3                   	retq   

0000000000800cf4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf4:	55                   	push   %rbp
  800cf5:	48 89 e5             	mov    %rsp,%rbp
  800cf8:	48 83 ec 20          	sub    $0x20,%rsp
  800cfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800d03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d0a:	48 98                	cltq   
  800d0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d13:	00 
  800d14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d20:	48 89 d1             	mov    %rdx,%rcx
  800d23:	48 89 c2             	mov    %rax,%rdx
  800d26:	be 01 00 00 00       	mov    $0x1,%esi
  800d2b:	bf 09 00 00 00       	mov    $0x9,%edi
  800d30:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800d37:	00 00 00 
  800d3a:	ff d0                	callq  *%rax
}
  800d3c:	c9                   	leaveq 
  800d3d:	c3                   	retq   

0000000000800d3e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d3e:	55                   	push   %rbp
  800d3f:	48 89 e5             	mov    %rsp,%rbp
  800d42:	48 83 ec 20          	sub    $0x20,%rsp
  800d46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d54:	48 98                	cltq   
  800d56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d5d:	00 
  800d5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d6a:	48 89 d1             	mov    %rdx,%rcx
  800d6d:	48 89 c2             	mov    %rax,%rdx
  800d70:	be 01 00 00 00       	mov    $0x1,%esi
  800d75:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d7a:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800d81:	00 00 00 
  800d84:	ff d0                	callq  *%rax
}
  800d86:	c9                   	leaveq 
  800d87:	c3                   	retq   

0000000000800d88 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d88:	55                   	push   %rbp
  800d89:	48 89 e5             	mov    %rsp,%rbp
  800d8c:	48 83 ec 30          	sub    $0x30,%rsp
  800d90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d9b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800da1:	48 63 f0             	movslq %eax,%rsi
  800da4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dab:	48 98                	cltq   
  800dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800db1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800db8:	00 
  800db9:	49 89 f1             	mov    %rsi,%r9
  800dbc:	49 89 c8             	mov    %rcx,%r8
  800dbf:	48 89 d1             	mov    %rdx,%rcx
  800dc2:	48 89 c2             	mov    %rax,%rdx
  800dc5:	be 00 00 00 00       	mov    $0x0,%esi
  800dca:	bf 0c 00 00 00       	mov    $0xc,%edi
  800dcf:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800dd6:	00 00 00 
  800dd9:	ff d0                	callq  *%rax
}
  800ddb:	c9                   	leaveq 
  800ddc:	c3                   	retq   

0000000000800ddd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ddd:	55                   	push   %rbp
  800dde:	48 89 e5             	mov    %rsp,%rbp
  800de1:	48 83 ec 20          	sub    $0x20,%rsp
  800de5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800de9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ded:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800df4:	00 
  800df5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800dfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e06:	48 89 c2             	mov    %rax,%rdx
  800e09:	be 01 00 00 00       	mov    $0x1,%esi
  800e0e:	bf 0d 00 00 00       	mov    $0xd,%edi
  800e13:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800e1a:	00 00 00 
  800e1d:	ff d0                	callq  *%rax
}
  800e1f:	c9                   	leaveq 
  800e20:	c3                   	retq   

0000000000800e21 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e21:	55                   	push   %rbp
  800e22:	48 89 e5             	mov    %rsp,%rbp
  800e25:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800e29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e30:	00 
  800e31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e42:	ba 00 00 00 00       	mov    $0x0,%edx
  800e47:	be 00 00 00 00       	mov    $0x0,%esi
  800e4c:	bf 0e 00 00 00       	mov    $0xe,%edi
  800e51:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800e58:	00 00 00 
  800e5b:	ff d0                	callq  *%rax
}
  800e5d:	c9                   	leaveq 
  800e5e:	c3                   	retq   

0000000000800e5f <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  800e5f:	55                   	push   %rbp
  800e60:	48 89 e5             	mov    %rsp,%rbp
  800e63:	48 83 ec 30          	sub    $0x30,%rsp
  800e67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800e6e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800e71:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e75:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  800e79:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800e7c:	48 63 c8             	movslq %eax,%rcx
  800e7f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800e83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800e86:	48 63 f0             	movslq %eax,%rsi
  800e89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e90:	48 98                	cltq   
  800e92:	48 89 0c 24          	mov    %rcx,(%rsp)
  800e96:	49 89 f9             	mov    %rdi,%r9
  800e99:	49 89 f0             	mov    %rsi,%r8
  800e9c:	48 89 d1             	mov    %rdx,%rcx
  800e9f:	48 89 c2             	mov    %rax,%rdx
  800ea2:	be 00 00 00 00       	mov    $0x0,%esi
  800ea7:	bf 0f 00 00 00       	mov    $0xf,%edi
  800eac:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800eb3:	00 00 00 
  800eb6:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  800eb8:	c9                   	leaveq 
  800eb9:	c3                   	retq   

0000000000800eba <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  800eba:	55                   	push   %rbp
  800ebb:	48 89 e5             	mov    %rsp,%rbp
  800ebe:	48 83 ec 20          	sub    $0x20,%rsp
  800ec2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ec6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  800eca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ece:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ed2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ed9:	00 
  800eda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ee0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ee6:	48 89 d1             	mov    %rdx,%rcx
  800ee9:	48 89 c2             	mov    %rax,%rdx
  800eec:	be 00 00 00 00       	mov    $0x0,%esi
  800ef1:	bf 10 00 00 00       	mov    $0x10,%edi
  800ef6:	48 b8 d0 09 80 00 00 	movabs $0x8009d0,%rax
  800efd:	00 00 00 
  800f00:	ff d0                	callq  *%rax
}
  800f02:	c9                   	leaveq 
  800f03:	c3                   	retq   

0000000000800f04 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800f04:	55                   	push   %rbp
  800f05:	48 89 e5             	mov    %rsp,%rbp
  800f08:	48 83 ec 08          	sub    $0x8,%rsp
  800f0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f10:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800f14:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800f1b:	ff ff ff 
  800f1e:	48 01 d0             	add    %rdx,%rax
  800f21:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800f25:	c9                   	leaveq 
  800f26:	c3                   	retq   

0000000000800f27 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f27:	55                   	push   %rbp
  800f28:	48 89 e5             	mov    %rsp,%rbp
  800f2b:	48 83 ec 08          	sub    $0x8,%rsp
  800f2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800f33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f37:	48 89 c7             	mov    %rax,%rdi
  800f3a:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  800f41:	00 00 00 
  800f44:	ff d0                	callq  *%rax
  800f46:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800f4c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800f50:	c9                   	leaveq 
  800f51:	c3                   	retq   

0000000000800f52 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f52:	55                   	push   %rbp
  800f53:	48 89 e5             	mov    %rsp,%rbp
  800f56:	48 83 ec 18          	sub    $0x18,%rsp
  800f5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f65:	eb 6b                	jmp    800fd2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800f67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f6a:	48 98                	cltq   
  800f6c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f72:	48 c1 e0 0c          	shl    $0xc,%rax
  800f76:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7e:	48 89 c2             	mov    %rax,%rdx
  800f81:	48 c1 ea 15          	shr    $0x15,%rdx
  800f85:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f8c:	01 00 00 
  800f8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f93:	83 e0 01             	and    $0x1,%eax
  800f96:	48 85 c0             	test   %rax,%rax
  800f99:	74 21                	je     800fbc <fd_alloc+0x6a>
  800f9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f9f:	48 89 c2             	mov    %rax,%rdx
  800fa2:	48 c1 ea 0c          	shr    $0xc,%rdx
  800fa6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800fad:	01 00 00 
  800fb0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800fb4:	83 e0 01             	and    $0x1,%eax
  800fb7:	48 85 c0             	test   %rax,%rax
  800fba:	75 12                	jne    800fce <fd_alloc+0x7c>
			*fd_store = fd;
  800fbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fc4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcc:	eb 1a                	jmp    800fe8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fd2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800fd6:	7e 8f                	jle    800f67 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800fe3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800fe8:	c9                   	leaveq 
  800fe9:	c3                   	retq   

0000000000800fea <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fea:	55                   	push   %rbp
  800feb:	48 89 e5             	mov    %rsp,%rbp
  800fee:	48 83 ec 20          	sub    $0x20,%rsp
  800ff2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800ff5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ff9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800ffd:	78 06                	js     801005 <fd_lookup+0x1b>
  800fff:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801003:	7e 07                	jle    80100c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801005:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80100a:	eb 6c                	jmp    801078 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80100c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80100f:	48 98                	cltq   
  801011:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801017:	48 c1 e0 0c          	shl    $0xc,%rax
  80101b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80101f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801023:	48 89 c2             	mov    %rax,%rdx
  801026:	48 c1 ea 15          	shr    $0x15,%rdx
  80102a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801031:	01 00 00 
  801034:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801038:	83 e0 01             	and    $0x1,%eax
  80103b:	48 85 c0             	test   %rax,%rax
  80103e:	74 21                	je     801061 <fd_lookup+0x77>
  801040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801044:	48 89 c2             	mov    %rax,%rdx
  801047:	48 c1 ea 0c          	shr    $0xc,%rdx
  80104b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801052:	01 00 00 
  801055:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801059:	83 e0 01             	and    $0x1,%eax
  80105c:	48 85 c0             	test   %rax,%rax
  80105f:	75 07                	jne    801068 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801061:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801066:	eb 10                	jmp    801078 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801068:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80106c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801070:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801073:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801078:	c9                   	leaveq 
  801079:	c3                   	retq   

000000000080107a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80107a:	55                   	push   %rbp
  80107b:	48 89 e5             	mov    %rsp,%rbp
  80107e:	48 83 ec 30          	sub    $0x30,%rsp
  801082:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801086:	89 f0                	mov    %esi,%eax
  801088:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80108b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80108f:	48 89 c7             	mov    %rax,%rdi
  801092:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  801099:	00 00 00 
  80109c:	ff d0                	callq  *%rax
  80109e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8010a2:	48 89 d6             	mov    %rdx,%rsi
  8010a5:	89 c7                	mov    %eax,%edi
  8010a7:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  8010ae:	00 00 00 
  8010b1:	ff d0                	callq  *%rax
  8010b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010ba:	78 0a                	js     8010c6 <fd_close+0x4c>
	    || fd != fd2)
  8010bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8010c4:	74 12                	je     8010d8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8010c6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8010ca:	74 05                	je     8010d1 <fd_close+0x57>
  8010cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010cf:	eb 05                	jmp    8010d6 <fd_close+0x5c>
  8010d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d6:	eb 69                	jmp    801141 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010dc:	8b 00                	mov    (%rax),%eax
  8010de:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8010e2:	48 89 d6             	mov    %rdx,%rsi
  8010e5:	89 c7                	mov    %eax,%edi
  8010e7:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  8010ee:	00 00 00 
  8010f1:	ff d0                	callq  *%rax
  8010f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010fa:	78 2a                	js     801126 <fd_close+0xac>
		if (dev->dev_close)
  8010fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801100:	48 8b 40 20          	mov    0x20(%rax),%rax
  801104:	48 85 c0             	test   %rax,%rax
  801107:	74 16                	je     80111f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801111:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801115:	48 89 c7             	mov    %rax,%rdi
  801118:	ff d2                	callq  *%rdx
  80111a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80111d:	eb 07                	jmp    801126 <fd_close+0xac>
		else
			r = 0;
  80111f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801126:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80112a:	48 89 c6             	mov    %rax,%rsi
  80112d:	bf 00 00 00 00       	mov    $0x0,%edi
  801132:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  801139:	00 00 00 
  80113c:	ff d0                	callq  *%rax
	return r;
  80113e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801141:	c9                   	leaveq 
  801142:	c3                   	retq   

0000000000801143 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801143:	55                   	push   %rbp
  801144:	48 89 e5             	mov    %rsp,%rbp
  801147:	48 83 ec 20          	sub    $0x20,%rsp
  80114b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80114e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801159:	eb 41                	jmp    80119c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80115b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801162:	00 00 00 
  801165:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801168:	48 63 d2             	movslq %edx,%rdx
  80116b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80116f:	8b 00                	mov    (%rax),%eax
  801171:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801174:	75 22                	jne    801198 <dev_lookup+0x55>
			*dev = devtab[i];
  801176:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80117d:	00 00 00 
  801180:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801183:	48 63 d2             	movslq %edx,%rdx
  801186:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80118a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80118e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801191:	b8 00 00 00 00       	mov    $0x0,%eax
  801196:	eb 60                	jmp    8011f8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801198:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80119c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8011a3:	00 00 00 
  8011a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011a9:	48 63 d2             	movslq %edx,%rdx
  8011ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8011b0:	48 85 c0             	test   %rax,%rax
  8011b3:	75 a6                	jne    80115b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011b5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8011bc:	00 00 00 
  8011bf:	48 8b 00             	mov    (%rax),%rax
  8011c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8011c8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8011cb:	89 c6                	mov    %eax,%esi
  8011cd:	48 bf 60 3c 80 00 00 	movabs $0x803c60,%rdi
  8011d4:	00 00 00 
  8011d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011dc:	48 b9 ef 2d 80 00 00 	movabs $0x802def,%rcx
  8011e3:	00 00 00 
  8011e6:	ff d1                	callq  *%rcx
	*dev = 0;
  8011e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ec:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8011f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011f8:	c9                   	leaveq 
  8011f9:	c3                   	retq   

00000000008011fa <close>:

int
close(int fdnum)
{
  8011fa:	55                   	push   %rbp
  8011fb:	48 89 e5             	mov    %rsp,%rbp
  8011fe:	48 83 ec 20          	sub    $0x20,%rsp
  801202:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801205:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801209:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80120c:	48 89 d6             	mov    %rdx,%rsi
  80120f:	89 c7                	mov    %eax,%edi
  801211:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  801218:	00 00 00 
  80121b:	ff d0                	callq  *%rax
  80121d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801220:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801224:	79 05                	jns    80122b <close+0x31>
		return r;
  801226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801229:	eb 18                	jmp    801243 <close+0x49>
	else
		return fd_close(fd, 1);
  80122b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122f:	be 01 00 00 00       	mov    $0x1,%esi
  801234:	48 89 c7             	mov    %rax,%rdi
  801237:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  80123e:	00 00 00 
  801241:	ff d0                	callq  *%rax
}
  801243:	c9                   	leaveq 
  801244:	c3                   	retq   

0000000000801245 <close_all>:

void
close_all(void)
{
  801245:	55                   	push   %rbp
  801246:	48 89 e5             	mov    %rsp,%rbp
  801249:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80124d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801254:	eb 15                	jmp    80126b <close_all+0x26>
		close(i);
  801256:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801259:	89 c7                	mov    %eax,%edi
  80125b:	48 b8 fa 11 80 00 00 	movabs $0x8011fa,%rax
  801262:	00 00 00 
  801265:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801267:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80126b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80126f:	7e e5                	jle    801256 <close_all+0x11>
		close(i);
}
  801271:	c9                   	leaveq 
  801272:	c3                   	retq   

0000000000801273 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801273:	55                   	push   %rbp
  801274:	48 89 e5             	mov    %rsp,%rbp
  801277:	48 83 ec 40          	sub    $0x40,%rsp
  80127b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80127e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801281:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801285:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801288:	48 89 d6             	mov    %rdx,%rsi
  80128b:	89 c7                	mov    %eax,%edi
  80128d:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  801294:	00 00 00 
  801297:	ff d0                	callq  *%rax
  801299:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80129c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012a0:	79 08                	jns    8012aa <dup+0x37>
		return r;
  8012a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012a5:	e9 70 01 00 00       	jmpq   80141a <dup+0x1a7>
	close(newfdnum);
  8012aa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8012ad:	89 c7                	mov    %eax,%edi
  8012af:	48 b8 fa 11 80 00 00 	movabs $0x8011fa,%rax
  8012b6:	00 00 00 
  8012b9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8012bb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8012be:	48 98                	cltq   
  8012c0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8012c6:	48 c1 e0 0c          	shl    $0xc,%rax
  8012ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8012ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d2:	48 89 c7             	mov    %rax,%rdi
  8012d5:	48 b8 27 0f 80 00 00 	movabs $0x800f27,%rax
  8012dc:	00 00 00 
  8012df:	ff d0                	callq  *%rax
  8012e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8012e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e9:	48 89 c7             	mov    %rax,%rdi
  8012ec:	48 b8 27 0f 80 00 00 	movabs $0x800f27,%rax
  8012f3:	00 00 00 
  8012f6:	ff d0                	callq  *%rax
  8012f8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801300:	48 89 c2             	mov    %rax,%rdx
  801303:	48 c1 ea 15          	shr    $0x15,%rdx
  801307:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80130e:	01 00 00 
  801311:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801315:	83 e0 01             	and    $0x1,%eax
  801318:	84 c0                	test   %al,%al
  80131a:	74 71                	je     80138d <dup+0x11a>
  80131c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801320:	48 89 c2             	mov    %rax,%rdx
  801323:	48 c1 ea 0c          	shr    $0xc,%rdx
  801327:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80132e:	01 00 00 
  801331:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801335:	83 e0 01             	and    $0x1,%eax
  801338:	84 c0                	test   %al,%al
  80133a:	74 51                	je     80138d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80133c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801340:	48 89 c2             	mov    %rax,%rdx
  801343:	48 c1 ea 0c          	shr    $0xc,%rdx
  801347:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80134e:	01 00 00 
  801351:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801355:	89 c1                	mov    %eax,%ecx
  801357:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80135d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801365:	41 89 c8             	mov    %ecx,%r8d
  801368:	48 89 d1             	mov    %rdx,%rcx
  80136b:	ba 00 00 00 00       	mov    $0x0,%edx
  801370:	48 89 c6             	mov    %rax,%rsi
  801373:	bf 00 00 00 00       	mov    $0x0,%edi
  801378:	48 b8 04 0c 80 00 00 	movabs $0x800c04,%rax
  80137f:	00 00 00 
  801382:	ff d0                	callq  *%rax
  801384:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801387:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80138b:	78 56                	js     8013e3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80138d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801391:	48 89 c2             	mov    %rax,%rdx
  801394:	48 c1 ea 0c          	shr    $0xc,%rdx
  801398:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80139f:	01 00 00 
  8013a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8013a6:	89 c1                	mov    %eax,%ecx
  8013a8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8013ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8013b6:	41 89 c8             	mov    %ecx,%r8d
  8013b9:	48 89 d1             	mov    %rdx,%rcx
  8013bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c1:	48 89 c6             	mov    %rax,%rsi
  8013c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8013c9:	48 b8 04 0c 80 00 00 	movabs $0x800c04,%rax
  8013d0:	00 00 00 
  8013d3:	ff d0                	callq  *%rax
  8013d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013dc:	78 08                	js     8013e6 <dup+0x173>
		goto err;

	return newfdnum;
  8013de:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8013e1:	eb 37                	jmp    80141a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8013e3:	90                   	nop
  8013e4:	eb 01                	jmp    8013e7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8013e6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013eb:	48 89 c6             	mov    %rax,%rsi
  8013ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8013f3:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  8013fa:	00 00 00 
  8013fd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8013ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801403:	48 89 c6             	mov    %rax,%rsi
  801406:	bf 00 00 00 00       	mov    $0x0,%edi
  80140b:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  801412:	00 00 00 
  801415:	ff d0                	callq  *%rax
	return r;
  801417:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80141a:	c9                   	leaveq 
  80141b:	c3                   	retq   

000000000080141c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141c:	55                   	push   %rbp
  80141d:	48 89 e5             	mov    %rsp,%rbp
  801420:	48 83 ec 40          	sub    $0x40,%rsp
  801424:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801427:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80142b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801433:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801436:	48 89 d6             	mov    %rdx,%rsi
  801439:	89 c7                	mov    %eax,%edi
  80143b:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  801442:	00 00 00 
  801445:	ff d0                	callq  *%rax
  801447:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80144a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80144e:	78 24                	js     801474 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801450:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801454:	8b 00                	mov    (%rax),%eax
  801456:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80145a:	48 89 d6             	mov    %rdx,%rsi
  80145d:	89 c7                	mov    %eax,%edi
  80145f:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  801466:	00 00 00 
  801469:	ff d0                	callq  *%rax
  80146b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80146e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801472:	79 05                	jns    801479 <read+0x5d>
		return r;
  801474:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801477:	eb 7a                	jmp    8014f3 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147d:	8b 40 08             	mov    0x8(%rax),%eax
  801480:	83 e0 03             	and    $0x3,%eax
  801483:	83 f8 01             	cmp    $0x1,%eax
  801486:	75 3a                	jne    8014c2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801488:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80148f:	00 00 00 
  801492:	48 8b 00             	mov    (%rax),%rax
  801495:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80149b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80149e:	89 c6                	mov    %eax,%esi
  8014a0:	48 bf 7f 3c 80 00 00 	movabs $0x803c7f,%rdi
  8014a7:	00 00 00 
  8014aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8014af:	48 b9 ef 2d 80 00 00 	movabs $0x802def,%rcx
  8014b6:	00 00 00 
  8014b9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8014bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c0:	eb 31                	jmp    8014f3 <read+0xd7>
	}
	if (!dev->dev_read)
  8014c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8014ca:	48 85 c0             	test   %rax,%rax
  8014cd:	75 07                	jne    8014d6 <read+0xba>
		return -E_NOT_SUPP;
  8014cf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8014d4:	eb 1d                	jmp    8014f3 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8014d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014da:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8014de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014e6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8014ea:	48 89 ce             	mov    %rcx,%rsi
  8014ed:	48 89 c7             	mov    %rax,%rdi
  8014f0:	41 ff d0             	callq  *%r8
}
  8014f3:	c9                   	leaveq 
  8014f4:	c3                   	retq   

00000000008014f5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014f5:	55                   	push   %rbp
  8014f6:	48 89 e5             	mov    %rsp,%rbp
  8014f9:	48 83 ec 30          	sub    $0x30,%rsp
  8014fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801500:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801504:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801508:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80150f:	eb 46                	jmp    801557 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801514:	48 98                	cltq   
  801516:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80151a:	48 29 c2             	sub    %rax,%rdx
  80151d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801520:	48 98                	cltq   
  801522:	48 89 c1             	mov    %rax,%rcx
  801525:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  801529:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80152c:	48 89 ce             	mov    %rcx,%rsi
  80152f:	89 c7                	mov    %eax,%edi
  801531:	48 b8 1c 14 80 00 00 	movabs $0x80141c,%rax
  801538:	00 00 00 
  80153b:	ff d0                	callq  *%rax
  80153d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801540:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801544:	79 05                	jns    80154b <readn+0x56>
			return m;
  801546:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801549:	eb 1d                	jmp    801568 <readn+0x73>
		if (m == 0)
  80154b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80154f:	74 13                	je     801564 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801551:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801554:	01 45 fc             	add    %eax,-0x4(%rbp)
  801557:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80155a:	48 98                	cltq   
  80155c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801560:	72 af                	jb     801511 <readn+0x1c>
  801562:	eb 01                	jmp    801565 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  801564:	90                   	nop
	}
	return tot;
  801565:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801568:	c9                   	leaveq 
  801569:	c3                   	retq   

000000000080156a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80156a:	55                   	push   %rbp
  80156b:	48 89 e5             	mov    %rsp,%rbp
  80156e:	48 83 ec 40          	sub    $0x40,%rsp
  801572:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801575:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801579:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801581:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801584:	48 89 d6             	mov    %rdx,%rsi
  801587:	89 c7                	mov    %eax,%edi
  801589:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  801590:	00 00 00 
  801593:	ff d0                	callq  *%rax
  801595:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801598:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80159c:	78 24                	js     8015c2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a2:	8b 00                	mov    (%rax),%eax
  8015a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8015a8:	48 89 d6             	mov    %rdx,%rsi
  8015ab:	89 c7                	mov    %eax,%edi
  8015ad:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  8015b4:	00 00 00 
  8015b7:	ff d0                	callq  *%rax
  8015b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015c0:	79 05                	jns    8015c7 <write+0x5d>
		return r;
  8015c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015c5:	eb 79                	jmp    801640 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cb:	8b 40 08             	mov    0x8(%rax),%eax
  8015ce:	83 e0 03             	and    $0x3,%eax
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	75 3a                	jne    80160f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8015dc:	00 00 00 
  8015df:	48 8b 00             	mov    (%rax),%rax
  8015e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8015e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8015eb:	89 c6                	mov    %eax,%esi
  8015ed:	48 bf 9b 3c 80 00 00 	movabs $0x803c9b,%rdi
  8015f4:	00 00 00 
  8015f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fc:	48 b9 ef 2d 80 00 00 	movabs $0x802def,%rcx
  801603:	00 00 00 
  801606:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801608:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160d:	eb 31                	jmp    801640 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80160f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801613:	48 8b 40 18          	mov    0x18(%rax),%rax
  801617:	48 85 c0             	test   %rax,%rax
  80161a:	75 07                	jne    801623 <write+0xb9>
		return -E_NOT_SUPP;
  80161c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801621:	eb 1d                	jmp    801640 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  801623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801627:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80162b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80162f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801633:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801637:	48 89 ce             	mov    %rcx,%rsi
  80163a:	48 89 c7             	mov    %rax,%rdi
  80163d:	41 ff d0             	callq  *%r8
}
  801640:	c9                   	leaveq 
  801641:	c3                   	retq   

0000000000801642 <seek>:

int
seek(int fdnum, off_t offset)
{
  801642:	55                   	push   %rbp
  801643:	48 89 e5             	mov    %rsp,%rbp
  801646:	48 83 ec 18          	sub    $0x18,%rsp
  80164a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80164d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801650:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801654:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801657:	48 89 d6             	mov    %rdx,%rsi
  80165a:	89 c7                	mov    %eax,%edi
  80165c:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  801663:	00 00 00 
  801666:	ff d0                	callq  *%rax
  801668:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80166b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80166f:	79 05                	jns    801676 <seek+0x34>
		return r;
  801671:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801674:	eb 0f                	jmp    801685 <seek+0x43>
	fd->fd_offset = offset;
  801676:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80167d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  801680:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801685:	c9                   	leaveq 
  801686:	c3                   	retq   

0000000000801687 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801687:	55                   	push   %rbp
  801688:	48 89 e5             	mov    %rsp,%rbp
  80168b:	48 83 ec 30          	sub    $0x30,%rsp
  80168f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801692:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801695:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801699:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80169c:	48 89 d6             	mov    %rdx,%rsi
  80169f:	89 c7                	mov    %eax,%edi
  8016a1:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  8016a8:	00 00 00 
  8016ab:	ff d0                	callq  *%rax
  8016ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016b4:	78 24                	js     8016da <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ba:	8b 00                	mov    (%rax),%eax
  8016bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8016c0:	48 89 d6             	mov    %rdx,%rsi
  8016c3:	89 c7                	mov    %eax,%edi
  8016c5:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  8016cc:	00 00 00 
  8016cf:	ff d0                	callq  *%rax
  8016d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016d8:	79 05                	jns    8016df <ftruncate+0x58>
		return r;
  8016da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016dd:	eb 72                	jmp    801751 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e3:	8b 40 08             	mov    0x8(%rax),%eax
  8016e6:	83 e0 03             	and    $0x3,%eax
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	75 3a                	jne    801727 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016ed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8016f4:	00 00 00 
  8016f7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801700:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801703:	89 c6                	mov    %eax,%esi
  801705:	48 bf b8 3c 80 00 00 	movabs $0x803cb8,%rdi
  80170c:	00 00 00 
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
  801714:	48 b9 ef 2d 80 00 00 	movabs $0x802def,%rcx
  80171b:	00 00 00 
  80171e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801720:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801725:	eb 2a                	jmp    801751 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  801727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80172f:	48 85 c0             	test   %rax,%rax
  801732:	75 07                	jne    80173b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  801734:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801739:	eb 16                	jmp    801751 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80173b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80173f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  801743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801747:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80174a:	89 d6                	mov    %edx,%esi
  80174c:	48 89 c7             	mov    %rax,%rdi
  80174f:	ff d1                	callq  *%rcx
}
  801751:	c9                   	leaveq 
  801752:	c3                   	retq   

0000000000801753 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801753:	55                   	push   %rbp
  801754:	48 89 e5             	mov    %rsp,%rbp
  801757:	48 83 ec 30          	sub    $0x30,%rsp
  80175b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80175e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801762:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801766:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801769:	48 89 d6             	mov    %rdx,%rsi
  80176c:	89 c7                	mov    %eax,%edi
  80176e:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  801775:	00 00 00 
  801778:	ff d0                	callq  *%rax
  80177a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80177d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801781:	78 24                	js     8017a7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801787:	8b 00                	mov    (%rax),%eax
  801789:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80178d:	48 89 d6             	mov    %rdx,%rsi
  801790:	89 c7                	mov    %eax,%edi
  801792:	48 b8 43 11 80 00 00 	movabs $0x801143,%rax
  801799:	00 00 00 
  80179c:	ff d0                	callq  *%rax
  80179e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017a5:	79 05                	jns    8017ac <fstat+0x59>
		return r;
  8017a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017aa:	eb 5e                	jmp    80180a <fstat+0xb7>
	if (!dev->dev_stat)
  8017ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8017b4:	48 85 c0             	test   %rax,%rax
  8017b7:	75 07                	jne    8017c0 <fstat+0x6d>
		return -E_NOT_SUPP;
  8017b9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8017be:	eb 4a                	jmp    80180a <fstat+0xb7>
	stat->st_name[0] = 0;
  8017c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017c4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8017c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8017d2:	00 00 00 
	stat->st_isdir = 0;
  8017d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8017e0:	00 00 00 
	stat->st_dev = dev;
  8017e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017eb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8017f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f6:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8017fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fe:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801802:	48 89 d6             	mov    %rdx,%rsi
  801805:	48 89 c7             	mov    %rax,%rdi
  801808:	ff d1                	callq  *%rcx
}
  80180a:	c9                   	leaveq 
  80180b:	c3                   	retq   

000000000080180c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80180c:	55                   	push   %rbp
  80180d:	48 89 e5             	mov    %rsp,%rbp
  801810:	48 83 ec 20          	sub    $0x20,%rsp
  801814:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801818:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80181c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801820:	be 00 00 00 00       	mov    $0x0,%esi
  801825:	48 89 c7             	mov    %rax,%rdi
  801828:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  80182f:	00 00 00 
  801832:	ff d0                	callq  *%rax
  801834:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801837:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80183b:	79 05                	jns    801842 <stat+0x36>
		return fd;
  80183d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801840:	eb 2f                	jmp    801871 <stat+0x65>
	r = fstat(fd, stat);
  801842:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801849:	48 89 d6             	mov    %rdx,%rsi
  80184c:	89 c7                	mov    %eax,%edi
  80184e:	48 b8 53 17 80 00 00 	movabs $0x801753,%rax
  801855:	00 00 00 
  801858:	ff d0                	callq  *%rax
  80185a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80185d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801860:	89 c7                	mov    %eax,%edi
  801862:	48 b8 fa 11 80 00 00 	movabs $0x8011fa,%rax
  801869:	00 00 00 
  80186c:	ff d0                	callq  *%rax
	return r;
  80186e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801871:	c9                   	leaveq 
  801872:	c3                   	retq   
	...

0000000000801874 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801874:	55                   	push   %rbp
  801875:	48 89 e5             	mov    %rsp,%rbp
  801878:	48 83 ec 10          	sub    $0x10,%rsp
  80187c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80187f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801883:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80188a:	00 00 00 
  80188d:	8b 00                	mov    (%rax),%eax
  80188f:	85 c0                	test   %eax,%eax
  801891:	75 1d                	jne    8018b0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801893:	bf 01 00 00 00       	mov    $0x1,%edi
  801898:	48 b8 ea 3a 80 00 00 	movabs $0x803aea,%rax
  80189f:	00 00 00 
  8018a2:	ff d0                	callq  *%rax
  8018a4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8018ab:	00 00 00 
  8018ae:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018b0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8018b7:	00 00 00 
  8018ba:	8b 00                	mov    (%rax),%eax
  8018bc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8018bf:	b9 07 00 00 00       	mov    $0x7,%ecx
  8018c4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8018cb:	00 00 00 
  8018ce:	89 c7                	mov    %eax,%edi
  8018d0:	48 b8 3b 3a 80 00 00 	movabs $0x803a3b,%rax
  8018d7:	00 00 00 
  8018da:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8018dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e5:	48 89 c6             	mov    %rax,%rsi
  8018e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8018ed:	48 b8 54 39 80 00 00 	movabs $0x803954,%rax
  8018f4:	00 00 00 
  8018f7:	ff d0                	callq  *%rax
}
  8018f9:	c9                   	leaveq 
  8018fa:	c3                   	retq   

00000000008018fb <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  8018fb:	55                   	push   %rbp
  8018fc:	48 89 e5             	mov    %rsp,%rbp
  8018ff:	48 83 ec 20          	sub    $0x20,%rsp
  801903:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801907:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  80190a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80190e:	48 89 c7             	mov    %rax,%rdi
  801911:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  801918:	00 00 00 
  80191b:	ff d0                	callq  *%rax
  80191d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801922:	7e 0a                	jle    80192e <open+0x33>
		return -E_BAD_PATH;
  801924:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801929:	e9 a5 00 00 00       	jmpq   8019d3 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  80192e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801932:	48 89 c7             	mov    %rax,%rdi
  801935:	48 b8 52 0f 80 00 00 	movabs $0x800f52,%rax
  80193c:	00 00 00 
  80193f:	ff d0                	callq  *%rax
  801941:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  801944:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801948:	79 08                	jns    801952 <open+0x57>
		return r;
  80194a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194d:	e9 81 00 00 00       	jmpq   8019d3 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  801952:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801959:	00 00 00 
  80195c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80195f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  801965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801969:	48 89 c6             	mov    %rax,%rsi
  80196c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801973:	00 00 00 
  801976:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  80197d:	00 00 00 
  801980:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  801982:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801986:	48 89 c6             	mov    %rax,%rsi
  801989:	bf 01 00 00 00       	mov    $0x1,%edi
  80198e:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  801995:	00 00 00 
  801998:	ff d0                	callq  *%rax
  80199a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  80199d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a1:	79 1d                	jns    8019c0 <open+0xc5>
		fd_close(new_fd, 0);
  8019a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a7:	be 00 00 00 00       	mov    $0x0,%esi
  8019ac:	48 89 c7             	mov    %rax,%rdi
  8019af:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  8019b6:	00 00 00 
  8019b9:	ff d0                	callq  *%rax
		return r;	
  8019bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019be:	eb 13                	jmp    8019d3 <open+0xd8>
	}
	return fd2num(new_fd);
  8019c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c4:	48 89 c7             	mov    %rax,%rdi
  8019c7:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  8019ce:	00 00 00 
  8019d1:	ff d0                	callq  *%rax
}
  8019d3:	c9                   	leaveq 
  8019d4:	c3                   	retq   

00000000008019d5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019d5:	55                   	push   %rbp
  8019d6:	48 89 e5             	mov    %rsp,%rbp
  8019d9:	48 83 ec 10          	sub    $0x10,%rsp
  8019dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e5:	8b 50 0c             	mov    0xc(%rax),%edx
  8019e8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8019ef:	00 00 00 
  8019f2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8019f4:	be 00 00 00 00       	mov    $0x0,%esi
  8019f9:	bf 06 00 00 00       	mov    $0x6,%edi
  8019fe:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  801a05:	00 00 00 
  801a08:	ff d0                	callq  *%rax
}
  801a0a:	c9                   	leaveq 
  801a0b:	c3                   	retq   

0000000000801a0c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a0c:	55                   	push   %rbp
  801a0d:	48 89 e5             	mov    %rsp,%rbp
  801a10:	48 83 ec 30          	sub    $0x30,%rsp
  801a14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a1c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  801a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a24:	8b 50 0c             	mov    0xc(%rax),%edx
  801a27:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a2e:	00 00 00 
  801a31:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801a33:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a3a:	00 00 00 
  801a3d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a41:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  801a45:	be 00 00 00 00       	mov    $0x0,%esi
  801a4a:	bf 03 00 00 00       	mov    $0x3,%edi
  801a4f:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	callq  *%rax
  801a5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  801a5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a62:	7e 23                	jle    801a87 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  801a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a67:	48 63 d0             	movslq %eax,%rdx
  801a6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a6e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801a75:	00 00 00 
  801a78:	48 89 c7             	mov    %rax,%rdi
  801a7b:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  801a82:	00 00 00 
  801a85:	ff d0                	callq  *%rax
	}
	return nbytes;
  801a87:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801a8a:	c9                   	leaveq 
  801a8b:	c3                   	retq   

0000000000801a8c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a8c:	55                   	push   %rbp
  801a8d:	48 89 e5             	mov    %rsp,%rbp
  801a90:	48 83 ec 20          	sub    $0x20,%rsp
  801a94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aa0:	8b 50 0c             	mov    0xc(%rax),%edx
  801aa3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801aaa:	00 00 00 
  801aad:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aaf:	be 00 00 00 00       	mov    $0x0,%esi
  801ab4:	bf 05 00 00 00       	mov    $0x5,%edi
  801ab9:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  801ac0:	00 00 00 
  801ac3:	ff d0                	callq  *%rax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801acc:	79 05                	jns    801ad3 <devfile_stat+0x47>
		return r;
  801ace:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad1:	eb 56                	jmp    801b29 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ad3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ad7:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801ade:	00 00 00 
  801ae1:	48 89 c7             	mov    %rax,%rdi
  801ae4:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  801aeb:	00 00 00 
  801aee:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801af0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801af7:	00 00 00 
  801afa:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801b00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b04:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b0a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b11:	00 00 00 
  801b14:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801b1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b1e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b29:	c9                   	leaveq 
  801b2a:	c3                   	retq   
	...

0000000000801b2c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b2c:	55                   	push   %rbp
  801b2d:	48 89 e5             	mov    %rsp,%rbp
  801b30:	48 83 ec 20          	sub    $0x20,%rsp
  801b34:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b37:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b3e:	48 89 d6             	mov    %rdx,%rsi
  801b41:	89 c7                	mov    %eax,%edi
  801b43:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	callq  *%rax
  801b4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b56:	79 05                	jns    801b5d <fd2sockid+0x31>
		return r;
  801b58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5b:	eb 24                	jmp    801b81 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b61:	8b 10                	mov    (%rax),%edx
  801b63:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801b6a:	00 00 00 
  801b6d:	8b 00                	mov    (%rax),%eax
  801b6f:	39 c2                	cmp    %eax,%edx
  801b71:	74 07                	je     801b7a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801b73:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801b78:	eb 07                	jmp    801b81 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  801b7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b7e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801b81:	c9                   	leaveq 
  801b82:	c3                   	retq   

0000000000801b83 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801b83:	55                   	push   %rbp
  801b84:	48 89 e5             	mov    %rsp,%rbp
  801b87:	48 83 ec 20          	sub    $0x20,%rsp
  801b8b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801b8e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801b92:	48 89 c7             	mov    %rax,%rdi
  801b95:	48 b8 52 0f 80 00 00 	movabs $0x800f52,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	callq  *%rax
  801ba1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ba4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ba8:	78 26                	js     801bd0 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801baa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bae:	ba 07 04 00 00       	mov    $0x407,%edx
  801bb3:	48 89 c6             	mov    %rax,%rsi
  801bb6:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbb:	48 b8 b4 0b 80 00 00 	movabs $0x800bb4,%rax
  801bc2:	00 00 00 
  801bc5:	ff d0                	callq  *%rax
  801bc7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bce:	79 16                	jns    801be6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801bd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bd3:	89 c7                	mov    %eax,%edi
  801bd5:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  801bdc:	00 00 00 
  801bdf:	ff d0                	callq  *%rax
		return r;
  801be1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be4:	eb 3a                	jmp    801c20 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801be6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bea:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801bf1:	00 00 00 
  801bf4:	8b 12                	mov    (%rdx),%edx
  801bf6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bfc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801c03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c07:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c0a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801c0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c11:	48 89 c7             	mov    %rax,%rdi
  801c14:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  801c1b:	00 00 00 
  801c1e:	ff d0                	callq  *%rax
}
  801c20:	c9                   	leaveq 
  801c21:	c3                   	retq   

0000000000801c22 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c22:	55                   	push   %rbp
  801c23:	48 89 e5             	mov    %rsp,%rbp
  801c26:	48 83 ec 30          	sub    $0x30,%rsp
  801c2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c31:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c38:	89 c7                	mov    %eax,%edi
  801c3a:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	callq  *%rax
  801c46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c4d:	79 05                	jns    801c54 <accept+0x32>
		return r;
  801c4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c52:	eb 3b                	jmp    801c8f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c54:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c58:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801c5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5f:	48 89 ce             	mov    %rcx,%rsi
  801c62:	89 c7                	mov    %eax,%edi
  801c64:	48 b8 6d 1f 80 00 00 	movabs $0x801f6d,%rax
  801c6b:	00 00 00 
  801c6e:	ff d0                	callq  *%rax
  801c70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c77:	79 05                	jns    801c7e <accept+0x5c>
		return r;
  801c79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c7c:	eb 11                	jmp    801c8f <accept+0x6d>
	return alloc_sockfd(r);
  801c7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c81:	89 c7                	mov    %eax,%edi
  801c83:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  801c8a:	00 00 00 
  801c8d:	ff d0                	callq  *%rax
}
  801c8f:	c9                   	leaveq 
  801c90:	c3                   	retq   

0000000000801c91 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c91:	55                   	push   %rbp
  801c92:	48 89 e5             	mov    %rsp,%rbp
  801c95:	48 83 ec 20          	sub    $0x20,%rsp
  801c99:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c9c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ca0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ca3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ca6:	89 c7                	mov    %eax,%edi
  801ca8:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801caf:	00 00 00 
  801cb2:	ff d0                	callq  *%rax
  801cb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cbb:	79 05                	jns    801cc2 <bind+0x31>
		return r;
  801cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc0:	eb 1b                	jmp    801cdd <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  801cc2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801cc5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccc:	48 89 ce             	mov    %rcx,%rsi
  801ccf:	89 c7                	mov    %eax,%edi
  801cd1:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  801cd8:	00 00 00 
  801cdb:	ff d0                	callq  *%rax
}
  801cdd:	c9                   	leaveq 
  801cde:	c3                   	retq   

0000000000801cdf <shutdown>:

int
shutdown(int s, int how)
{
  801cdf:	55                   	push   %rbp
  801ce0:	48 89 e5             	mov    %rsp,%rbp
  801ce3:	48 83 ec 20          	sub    $0x20,%rsp
  801ce7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cea:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ced:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cf0:	89 c7                	mov    %eax,%edi
  801cf2:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	callq  *%rax
  801cfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d05:	79 05                	jns    801d0c <shutdown+0x2d>
		return r;
  801d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0a:	eb 16                	jmp    801d22 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801d0c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d12:	89 d6                	mov    %edx,%esi
  801d14:	89 c7                	mov    %eax,%edi
  801d16:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  801d1d:	00 00 00 
  801d20:	ff d0                	callq  *%rax
}
  801d22:	c9                   	leaveq 
  801d23:	c3                   	retq   

0000000000801d24 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801d24:	55                   	push   %rbp
  801d25:	48 89 e5             	mov    %rsp,%rbp
  801d28:	48 83 ec 10          	sub    $0x10,%rsp
  801d2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  801d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d34:	48 89 c7             	mov    %rax,%rdi
  801d37:	48 b8 78 3b 80 00 00 	movabs $0x803b78,%rax
  801d3e:	00 00 00 
  801d41:	ff d0                	callq  *%rax
  801d43:	83 f8 01             	cmp    $0x1,%eax
  801d46:	75 17                	jne    801d5f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4c:	8b 40 0c             	mov    0xc(%rax),%eax
  801d4f:	89 c7                	mov    %eax,%edi
  801d51:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  801d58:	00 00 00 
  801d5b:	ff d0                	callq  *%rax
  801d5d:	eb 05                	jmp    801d64 <devsock_close+0x40>
	else
		return 0;
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d64:	c9                   	leaveq 
  801d65:	c3                   	retq   

0000000000801d66 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d66:	55                   	push   %rbp
  801d67:	48 89 e5             	mov    %rsp,%rbp
  801d6a:	48 83 ec 20          	sub    $0x20,%rsp
  801d6e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d75:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d7b:	89 c7                	mov    %eax,%edi
  801d7d:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801d84:	00 00 00 
  801d87:	ff d0                	callq  *%rax
  801d89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d90:	79 05                	jns    801d97 <connect+0x31>
		return r;
  801d92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d95:	eb 1b                	jmp    801db2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  801d97:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d9a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da1:	48 89 ce             	mov    %rcx,%rsi
  801da4:	89 c7                	mov    %eax,%edi
  801da6:	48 b8 bd 20 80 00 00 	movabs $0x8020bd,%rax
  801dad:	00 00 00 
  801db0:	ff d0                	callq  *%rax
}
  801db2:	c9                   	leaveq 
  801db3:	c3                   	retq   

0000000000801db4 <listen>:

int
listen(int s, int backlog)
{
  801db4:	55                   	push   %rbp
  801db5:	48 89 e5             	mov    %rsp,%rbp
  801db8:	48 83 ec 20          	sub    $0x20,%rsp
  801dbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801dbf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dc2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dc5:	89 c7                	mov    %eax,%edi
  801dc7:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801dce:	00 00 00 
  801dd1:	ff d0                	callq  *%rax
  801dd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dda:	79 05                	jns    801de1 <listen+0x2d>
		return r;
  801ddc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ddf:	eb 16                	jmp    801df7 <listen+0x43>
	return nsipc_listen(r, backlog);
  801de1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de7:	89 d6                	mov    %edx,%esi
  801de9:	89 c7                	mov    %eax,%edi
  801deb:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  801df2:	00 00 00 
  801df5:	ff d0                	callq  *%rax
}
  801df7:	c9                   	leaveq 
  801df8:	c3                   	retq   

0000000000801df9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801df9:	55                   	push   %rbp
  801dfa:	48 89 e5             	mov    %rsp,%rbp
  801dfd:	48 83 ec 20          	sub    $0x20,%rsp
  801e01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e09:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e11:	89 c2                	mov    %eax,%edx
  801e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e17:	8b 40 0c             	mov    0xc(%rax),%eax
  801e1a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801e1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e23:	89 c7                	mov    %eax,%edi
  801e25:	48 b8 61 21 80 00 00 	movabs $0x802161,%rax
  801e2c:	00 00 00 
  801e2f:	ff d0                	callq  *%rax
}
  801e31:	c9                   	leaveq 
  801e32:	c3                   	retq   

0000000000801e33 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e33:	55                   	push   %rbp
  801e34:	48 89 e5             	mov    %rsp,%rbp
  801e37:	48 83 ec 20          	sub    $0x20,%rsp
  801e3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e43:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e4b:	89 c2                	mov    %eax,%edx
  801e4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e51:	8b 40 0c             	mov    0xc(%rax),%eax
  801e54:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801e58:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e5d:	89 c7                	mov    %eax,%edi
  801e5f:	48 b8 2d 22 80 00 00 	movabs $0x80222d,%rax
  801e66:	00 00 00 
  801e69:	ff d0                	callq  *%rax
}
  801e6b:	c9                   	leaveq 
  801e6c:	c3                   	retq   

0000000000801e6d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e6d:	55                   	push   %rbp
  801e6e:	48 89 e5             	mov    %rsp,%rbp
  801e71:	48 83 ec 10          	sub    $0x10,%rsp
  801e75:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  801e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e81:	48 be e3 3c 80 00 00 	movabs $0x803ce3,%rsi
  801e88:	00 00 00 
  801e8b:	48 89 c7             	mov    %rax,%rdi
  801e8e:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	callq  *%rax
	return 0;
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9f:	c9                   	leaveq 
  801ea0:	c3                   	retq   

0000000000801ea1 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ea1:	55                   	push   %rbp
  801ea2:	48 89 e5             	mov    %rsp,%rbp
  801ea5:	48 83 ec 20          	sub    $0x20,%rsp
  801ea9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801eac:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801eaf:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801eb2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801eb5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801eb8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ebb:	89 ce                	mov    %ecx,%esi
  801ebd:	89 c7                	mov    %eax,%edi
  801ebf:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  801ec6:	00 00 00 
  801ec9:	ff d0                	callq  *%rax
  801ecb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ece:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ed2:	79 05                	jns    801ed9 <socket+0x38>
		return r;
  801ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed7:	eb 11                	jmp    801eea <socket+0x49>
	return alloc_sockfd(r);
  801ed9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edc:	89 c7                	mov    %eax,%edi
  801ede:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  801ee5:	00 00 00 
  801ee8:	ff d0                	callq  *%rax
}
  801eea:	c9                   	leaveq 
  801eeb:	c3                   	retq   

0000000000801eec <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801eec:	55                   	push   %rbp
  801eed:	48 89 e5             	mov    %rsp,%rbp
  801ef0:	48 83 ec 10          	sub    $0x10,%rsp
  801ef4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801ef7:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801efe:	00 00 00 
  801f01:	8b 00                	mov    (%rax),%eax
  801f03:	85 c0                	test   %eax,%eax
  801f05:	75 1d                	jne    801f24 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f07:	bf 02 00 00 00       	mov    $0x2,%edi
  801f0c:	48 b8 ea 3a 80 00 00 	movabs $0x803aea,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	callq  *%rax
  801f18:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  801f1f:	00 00 00 
  801f22:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f24:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801f2b:	00 00 00 
  801f2e:	8b 00                	mov    (%rax),%eax
  801f30:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f33:	b9 07 00 00 00       	mov    $0x7,%ecx
  801f38:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  801f3f:	00 00 00 
  801f42:	89 c7                	mov    %eax,%edi
  801f44:	48 b8 3b 3a 80 00 00 	movabs $0x803a3b,%rax
  801f4b:	00 00 00 
  801f4e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801f50:	ba 00 00 00 00       	mov    $0x0,%edx
  801f55:	be 00 00 00 00       	mov    $0x0,%esi
  801f5a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5f:	48 b8 54 39 80 00 00 	movabs $0x803954,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
}
  801f6b:	c9                   	leaveq 
  801f6c:	c3                   	retq   

0000000000801f6d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f6d:	55                   	push   %rbp
  801f6e:	48 89 e5             	mov    %rsp,%rbp
  801f71:	48 83 ec 30          	sub    $0x30,%rsp
  801f75:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f7c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  801f80:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801f87:	00 00 00 
  801f8a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f8d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f8f:	bf 01 00 00 00       	mov    $0x1,%edi
  801f94:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  801f9b:	00 00 00 
  801f9e:	ff d0                	callq  *%rax
  801fa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa7:	78 3e                	js     801fe7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801fa9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801fb0:	00 00 00 
  801fb3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbb:	8b 40 10             	mov    0x10(%rax),%eax
  801fbe:	89 c2                	mov    %eax,%edx
  801fc0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fc8:	48 89 ce             	mov    %rcx,%rsi
  801fcb:	48 89 c7             	mov    %rax,%rdi
  801fce:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  801fd5:	00 00 00 
  801fd8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fde:	8b 50 10             	mov    0x10(%rax),%edx
  801fe1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801fe7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fea:	c9                   	leaveq 
  801feb:	c3                   	retq   

0000000000801fec <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fec:	55                   	push   %rbp
  801fed:	48 89 e5             	mov    %rsp,%rbp
  801ff0:	48 83 ec 10          	sub    $0x10,%rsp
  801ff4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ff7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ffb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  801ffe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802005:	00 00 00 
  802008:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80200b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80200d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802014:	48 89 c6             	mov    %rax,%rsi
  802017:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80201e:	00 00 00 
  802021:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  802028:	00 00 00 
  80202b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80202d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802034:	00 00 00 
  802037:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80203a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80203d:	bf 02 00 00 00       	mov    $0x2,%edi
  802042:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  802049:	00 00 00 
  80204c:	ff d0                	callq  *%rax
}
  80204e:	c9                   	leaveq 
  80204f:	c3                   	retq   

0000000000802050 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802050:	55                   	push   %rbp
  802051:	48 89 e5             	mov    %rsp,%rbp
  802054:	48 83 ec 10          	sub    $0x10,%rsp
  802058:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80205b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80205e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802065:	00 00 00 
  802068:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80206b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80206d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802074:	00 00 00 
  802077:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80207a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80207d:	bf 03 00 00 00       	mov    $0x3,%edi
  802082:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  802089:	00 00 00 
  80208c:	ff d0                	callq  *%rax
}
  80208e:	c9                   	leaveq 
  80208f:	c3                   	retq   

0000000000802090 <nsipc_close>:

int
nsipc_close(int s)
{
  802090:	55                   	push   %rbp
  802091:	48 89 e5             	mov    %rsp,%rbp
  802094:	48 83 ec 10          	sub    $0x10,%rsp
  802098:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80209b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8020a2:	00 00 00 
  8020a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020a8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8020aa:	bf 04 00 00 00       	mov    $0x4,%edi
  8020af:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  8020b6:	00 00 00 
  8020b9:	ff d0                	callq  *%rax
}
  8020bb:	c9                   	leaveq 
  8020bc:	c3                   	retq   

00000000008020bd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020bd:	55                   	push   %rbp
  8020be:	48 89 e5             	mov    %rsp,%rbp
  8020c1:	48 83 ec 10          	sub    $0x10,%rsp
  8020c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020cc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8020cf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8020d6:	00 00 00 
  8020d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020dc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020de:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8020e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e5:	48 89 c6             	mov    %rax,%rsi
  8020e8:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8020ef:	00 00 00 
  8020f2:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8020fe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802105:	00 00 00 
  802108:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80210b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80210e:	bf 05 00 00 00       	mov    $0x5,%edi
  802113:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  80211a:	00 00 00 
  80211d:	ff d0                	callq  *%rax
}
  80211f:	c9                   	leaveq 
  802120:	c3                   	retq   

0000000000802121 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802121:	55                   	push   %rbp
  802122:	48 89 e5             	mov    %rsp,%rbp
  802125:	48 83 ec 10          	sub    $0x10,%rsp
  802129:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80212c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80212f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802136:	00 00 00 
  802139:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80213c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80213e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802145:	00 00 00 
  802148:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80214b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80214e:	bf 06 00 00 00       	mov    $0x6,%edi
  802153:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  80215a:	00 00 00 
  80215d:	ff d0                	callq  *%rax
}
  80215f:	c9                   	leaveq 
  802160:	c3                   	retq   

0000000000802161 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802161:	55                   	push   %rbp
  802162:	48 89 e5             	mov    %rsp,%rbp
  802165:	48 83 ec 30          	sub    $0x30,%rsp
  802169:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80216c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802170:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802173:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802176:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80217d:	00 00 00 
  802180:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802183:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802185:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80218c:	00 00 00 
  80218f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802192:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802195:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80219c:	00 00 00 
  80219f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021a2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021a5:	bf 07 00 00 00       	mov    $0x7,%edi
  8021aa:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  8021b1:	00 00 00 
  8021b4:	ff d0                	callq  *%rax
  8021b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021bd:	78 69                	js     802228 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8021bf:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8021c6:	7f 08                	jg     8021d0 <nsipc_recv+0x6f>
  8021c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8021ce:	7e 35                	jle    802205 <nsipc_recv+0xa4>
  8021d0:	48 b9 ea 3c 80 00 00 	movabs $0x803cea,%rcx
  8021d7:	00 00 00 
  8021da:	48 ba ff 3c 80 00 00 	movabs $0x803cff,%rdx
  8021e1:	00 00 00 
  8021e4:	be 61 00 00 00       	mov    $0x61,%esi
  8021e9:	48 bf 14 3d 80 00 00 	movabs $0x803d14,%rdi
  8021f0:	00 00 00 
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	49 b8 b4 2b 80 00 00 	movabs $0x802bb4,%r8
  8021ff:	00 00 00 
  802202:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802205:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802208:	48 63 d0             	movslq %eax,%rdx
  80220b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80220f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802216:	00 00 00 
  802219:	48 89 c7             	mov    %rax,%rdi
  80221c:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  802223:	00 00 00 
  802226:	ff d0                	callq  *%rax
	}

	return r;
  802228:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80222b:	c9                   	leaveq 
  80222c:	c3                   	retq   

000000000080222d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80222d:	55                   	push   %rbp
  80222e:	48 89 e5             	mov    %rsp,%rbp
  802231:	48 83 ec 20          	sub    $0x20,%rsp
  802235:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802238:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80223c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80223f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  802242:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802249:	00 00 00 
  80224c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80224f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  802251:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  802258:	7e 35                	jle    80228f <nsipc_send+0x62>
  80225a:	48 b9 20 3d 80 00 00 	movabs $0x803d20,%rcx
  802261:	00 00 00 
  802264:	48 ba ff 3c 80 00 00 	movabs $0x803cff,%rdx
  80226b:	00 00 00 
  80226e:	be 6c 00 00 00       	mov    $0x6c,%esi
  802273:	48 bf 14 3d 80 00 00 	movabs $0x803d14,%rdi
  80227a:	00 00 00 
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
  802282:	49 b8 b4 2b 80 00 00 	movabs $0x802bb4,%r8
  802289:	00 00 00 
  80228c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80228f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802292:	48 63 d0             	movslq %eax,%rdx
  802295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802299:	48 89 c6             	mov    %rax,%rsi
  80229c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8022a3:	00 00 00 
  8022a6:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  8022ad:	00 00 00 
  8022b0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8022b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8022b9:	00 00 00 
  8022bc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022bf:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8022c2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8022c9:	00 00 00 
  8022cc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022cf:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8022d2:	bf 08 00 00 00       	mov    $0x8,%edi
  8022d7:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  8022de:	00 00 00 
  8022e1:	ff d0                	callq  *%rax
}
  8022e3:	c9                   	leaveq 
  8022e4:	c3                   	retq   

00000000008022e5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022e5:	55                   	push   %rbp
  8022e6:	48 89 e5             	mov    %rsp,%rbp
  8022e9:	48 83 ec 10          	sub    $0x10,%rsp
  8022ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022f0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8022f3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8022f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8022fd:	00 00 00 
  802300:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802303:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  802305:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80230c:	00 00 00 
  80230f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802312:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  802315:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80231c:	00 00 00 
  80231f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802322:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  802325:	bf 09 00 00 00       	mov    $0x9,%edi
  80232a:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  802331:	00 00 00 
  802334:	ff d0                	callq  *%rax
}
  802336:	c9                   	leaveq 
  802337:	c3                   	retq   

0000000000802338 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802338:	55                   	push   %rbp
  802339:	48 89 e5             	mov    %rsp,%rbp
  80233c:	53                   	push   %rbx
  80233d:	48 83 ec 38          	sub    $0x38,%rsp
  802341:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802345:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802349:	48 89 c7             	mov    %rax,%rdi
  80234c:	48 b8 52 0f 80 00 00 	movabs $0x800f52,%rax
  802353:	00 00 00 
  802356:	ff d0                	callq  *%rax
  802358:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80235b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80235f:	0f 88 bf 01 00 00    	js     802524 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802369:	ba 07 04 00 00       	mov    $0x407,%edx
  80236e:	48 89 c6             	mov    %rax,%rsi
  802371:	bf 00 00 00 00       	mov    $0x0,%edi
  802376:	48 b8 b4 0b 80 00 00 	movabs $0x800bb4,%rax
  80237d:	00 00 00 
  802380:	ff d0                	callq  *%rax
  802382:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802385:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802389:	0f 88 95 01 00 00    	js     802524 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80238f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802393:	48 89 c7             	mov    %rax,%rdi
  802396:	48 b8 52 0f 80 00 00 	movabs $0x800f52,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8023a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023a9:	0f 88 5d 01 00 00    	js     80250c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023b3:	ba 07 04 00 00       	mov    $0x407,%edx
  8023b8:	48 89 c6             	mov    %rax,%rsi
  8023bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c0:	48 b8 b4 0b 80 00 00 	movabs $0x800bb4,%rax
  8023c7:	00 00 00 
  8023ca:	ff d0                	callq  *%rax
  8023cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8023cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023d3:	0f 88 33 01 00 00    	js     80250c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8023d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023dd:	48 89 c7             	mov    %rax,%rdi
  8023e0:	48 b8 27 0f 80 00 00 	movabs $0x800f27,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	callq  *%rax
  8023ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023f4:	ba 07 04 00 00       	mov    $0x407,%edx
  8023f9:	48 89 c6             	mov    %rax,%rsi
  8023fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802401:	48 b8 b4 0b 80 00 00 	movabs $0x800bb4,%rax
  802408:	00 00 00 
  80240b:	ff d0                	callq  *%rax
  80240d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802410:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802414:	0f 88 d9 00 00 00    	js     8024f3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80241a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80241e:	48 89 c7             	mov    %rax,%rdi
  802421:	48 b8 27 0f 80 00 00 	movabs $0x800f27,%rax
  802428:	00 00 00 
  80242b:	ff d0                	callq  *%rax
  80242d:	48 89 c2             	mov    %rax,%rdx
  802430:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802434:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80243a:	48 89 d1             	mov    %rdx,%rcx
  80243d:	ba 00 00 00 00       	mov    $0x0,%edx
  802442:	48 89 c6             	mov    %rax,%rsi
  802445:	bf 00 00 00 00       	mov    $0x0,%edi
  80244a:	48 b8 04 0c 80 00 00 	movabs $0x800c04,%rax
  802451:	00 00 00 
  802454:	ff d0                	callq  *%rax
  802456:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802459:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80245d:	78 79                	js     8024d8 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80245f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802463:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80246a:	00 00 00 
  80246d:	8b 12                	mov    (%rdx),%edx
  80246f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802475:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80247c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802480:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802487:	00 00 00 
  80248a:	8b 12                	mov    (%rdx),%edx
  80248c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80248e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802492:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80249d:	48 89 c7             	mov    %rax,%rdi
  8024a0:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  8024a7:	00 00 00 
  8024aa:	ff d0                	callq  *%rax
  8024ac:	89 c2                	mov    %eax,%edx
  8024ae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8024b2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8024b4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8024b8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8024bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024c0:	48 89 c7             	mov    %rax,%rdi
  8024c3:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  8024ca:	00 00 00 
  8024cd:	ff d0                	callq  *%rax
  8024cf:	89 03                	mov    %eax,(%rbx)
	return 0;
  8024d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d6:	eb 4f                	jmp    802527 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8024d8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8024d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024dd:	48 89 c6             	mov    %rax,%rsi
  8024e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e5:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  8024ec:	00 00 00 
  8024ef:	ff d0                	callq  *%rax
  8024f1:	eb 01                	jmp    8024f4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8024f3:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8024f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024f8:	48 89 c6             	mov    %rax,%rsi
  8024fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802500:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  802507:	00 00 00 
  80250a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80250c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802510:	48 89 c6             	mov    %rax,%rsi
  802513:	bf 00 00 00 00       	mov    $0x0,%edi
  802518:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  80251f:	00 00 00 
  802522:	ff d0                	callq  *%rax
err:
	return r;
  802524:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802527:	48 83 c4 38          	add    $0x38,%rsp
  80252b:	5b                   	pop    %rbx
  80252c:	5d                   	pop    %rbp
  80252d:	c3                   	retq   

000000000080252e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	53                   	push   %rbx
  802533:	48 83 ec 28          	sub    $0x28,%rsp
  802537:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80253b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80253f:	eb 01                	jmp    802542 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  802541:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802542:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802549:	00 00 00 
  80254c:	48 8b 00             	mov    (%rax),%rax
  80254f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802555:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80255c:	48 89 c7             	mov    %rax,%rdi
  80255f:	48 b8 78 3b 80 00 00 	movabs $0x803b78,%rax
  802566:	00 00 00 
  802569:	ff d0                	callq  *%rax
  80256b:	89 c3                	mov    %eax,%ebx
  80256d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802571:	48 89 c7             	mov    %rax,%rdi
  802574:	48 b8 78 3b 80 00 00 	movabs $0x803b78,%rax
  80257b:	00 00 00 
  80257e:	ff d0                	callq  *%rax
  802580:	39 c3                	cmp    %eax,%ebx
  802582:	0f 94 c0             	sete   %al
  802585:	0f b6 c0             	movzbl %al,%eax
  802588:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80258b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802592:	00 00 00 
  802595:	48 8b 00             	mov    (%rax),%rax
  802598:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80259e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8025a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025a4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8025a7:	75 0a                	jne    8025b3 <_pipeisclosed+0x85>
			return ret;
  8025a9:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8025ac:	48 83 c4 28          	add    $0x28,%rsp
  8025b0:	5b                   	pop    %rbx
  8025b1:	5d                   	pop    %rbp
  8025b2:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8025b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025b6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8025b9:	74 86                	je     802541 <_pipeisclosed+0x13>
  8025bb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8025bf:	75 80                	jne    802541 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025c1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025c8:	00 00 00 
  8025cb:	48 8b 00             	mov    (%rax),%rax
  8025ce:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8025d4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8025d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025da:	89 c6                	mov    %eax,%esi
  8025dc:	48 bf 31 3d 80 00 00 	movabs $0x803d31,%rdi
  8025e3:	00 00 00 
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025eb:	49 b8 ef 2d 80 00 00 	movabs $0x802def,%r8
  8025f2:	00 00 00 
  8025f5:	41 ff d0             	callq  *%r8
	}
  8025f8:	e9 44 ff ff ff       	jmpq   802541 <_pipeisclosed+0x13>

00000000008025fd <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8025fd:	55                   	push   %rbp
  8025fe:	48 89 e5             	mov    %rsp,%rbp
  802601:	48 83 ec 30          	sub    $0x30,%rsp
  802605:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802608:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80260c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80260f:	48 89 d6             	mov    %rdx,%rsi
  802612:	89 c7                	mov    %eax,%edi
  802614:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  80261b:	00 00 00 
  80261e:	ff d0                	callq  *%rax
  802620:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802623:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802627:	79 05                	jns    80262e <pipeisclosed+0x31>
		return r;
  802629:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262c:	eb 31                	jmp    80265f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80262e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802632:	48 89 c7             	mov    %rax,%rdi
  802635:	48 b8 27 0f 80 00 00 	movabs $0x800f27,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	callq  *%rax
  802641:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802649:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80264d:	48 89 d6             	mov    %rdx,%rsi
  802650:	48 89 c7             	mov    %rax,%rdi
  802653:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  80265a:	00 00 00 
  80265d:	ff d0                	callq  *%rax
}
  80265f:	c9                   	leaveq 
  802660:	c3                   	retq   

0000000000802661 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802661:	55                   	push   %rbp
  802662:	48 89 e5             	mov    %rsp,%rbp
  802665:	48 83 ec 40          	sub    $0x40,%rsp
  802669:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80266d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802671:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802675:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802679:	48 89 c7             	mov    %rax,%rdi
  80267c:	48 b8 27 0f 80 00 00 	movabs $0x800f27,%rax
  802683:	00 00 00 
  802686:	ff d0                	callq  *%rax
  802688:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80268c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802690:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802694:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80269b:	00 
  80269c:	e9 97 00 00 00       	jmpq   802738 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8026a1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8026a6:	74 09                	je     8026b1 <devpipe_read+0x50>
				return i;
  8026a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ac:	e9 95 00 00 00       	jmpq   802746 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8026b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026b9:	48 89 d6             	mov    %rdx,%rsi
  8026bc:	48 89 c7             	mov    %rax,%rdi
  8026bf:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  8026c6:	00 00 00 
  8026c9:	ff d0                	callq  *%rax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	74 07                	je     8026d6 <devpipe_read+0x75>
				return 0;
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d4:	eb 70                	jmp    802746 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026d6:	48 b8 76 0b 80 00 00 	movabs $0x800b76,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	callq  *%rax
  8026e2:	eb 01                	jmp    8026e5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026e4:	90                   	nop
  8026e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e9:	8b 10                	mov    (%rax),%edx
  8026eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ef:	8b 40 04             	mov    0x4(%rax),%eax
  8026f2:	39 c2                	cmp    %eax,%edx
  8026f4:	74 ab                	je     8026a1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026fe:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802702:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802706:	8b 00                	mov    (%rax),%eax
  802708:	89 c2                	mov    %eax,%edx
  80270a:	c1 fa 1f             	sar    $0x1f,%edx
  80270d:	c1 ea 1b             	shr    $0x1b,%edx
  802710:	01 d0                	add    %edx,%eax
  802712:	83 e0 1f             	and    $0x1f,%eax
  802715:	29 d0                	sub    %edx,%eax
  802717:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80271b:	48 98                	cltq   
  80271d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802722:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802728:	8b 00                	mov    (%rax),%eax
  80272a:	8d 50 01             	lea    0x1(%rax),%edx
  80272d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802731:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802733:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80273c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802740:	72 a2                	jb     8026e4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802746:	c9                   	leaveq 
  802747:	c3                   	retq   

0000000000802748 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802748:	55                   	push   %rbp
  802749:	48 89 e5             	mov    %rsp,%rbp
  80274c:	48 83 ec 40          	sub    $0x40,%rsp
  802750:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802754:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802758:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80275c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802760:	48 89 c7             	mov    %rax,%rdi
  802763:	48 b8 27 0f 80 00 00 	movabs $0x800f27,%rax
  80276a:	00 00 00 
  80276d:	ff d0                	callq  *%rax
  80276f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802773:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802777:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80277b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802782:	00 
  802783:	e9 93 00 00 00       	jmpq   80281b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802788:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80278c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802790:	48 89 d6             	mov    %rdx,%rsi
  802793:	48 89 c7             	mov    %rax,%rdi
  802796:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  80279d:	00 00 00 
  8027a0:	ff d0                	callq  *%rax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 07                	je     8027ad <devpipe_write+0x65>
				return 0;
  8027a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ab:	eb 7c                	jmp    802829 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8027ad:	48 b8 76 0b 80 00 00 	movabs $0x800b76,%rax
  8027b4:	00 00 00 
  8027b7:	ff d0                	callq  *%rax
  8027b9:	eb 01                	jmp    8027bc <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8027bb:	90                   	nop
  8027bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c0:	8b 40 04             	mov    0x4(%rax),%eax
  8027c3:	48 63 d0             	movslq %eax,%rdx
  8027c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ca:	8b 00                	mov    (%rax),%eax
  8027cc:	48 98                	cltq   
  8027ce:	48 83 c0 20          	add    $0x20,%rax
  8027d2:	48 39 c2             	cmp    %rax,%rdx
  8027d5:	73 b1                	jae    802788 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8027d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027db:	8b 40 04             	mov    0x4(%rax),%eax
  8027de:	89 c2                	mov    %eax,%edx
  8027e0:	c1 fa 1f             	sar    $0x1f,%edx
  8027e3:	c1 ea 1b             	shr    $0x1b,%edx
  8027e6:	01 d0                	add    %edx,%eax
  8027e8:	83 e0 1f             	and    $0x1f,%eax
  8027eb:	29 d0                	sub    %edx,%eax
  8027ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027f5:	48 01 ca             	add    %rcx,%rdx
  8027f8:	0f b6 0a             	movzbl (%rdx),%ecx
  8027fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027ff:	48 98                	cltq   
  802801:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802809:	8b 40 04             	mov    0x4(%rax),%eax
  80280c:	8d 50 01             	lea    0x1(%rax),%edx
  80280f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802813:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802816:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80281b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80281f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802823:	72 96                	jb     8027bb <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802829:	c9                   	leaveq 
  80282a:	c3                   	retq   

000000000080282b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80282b:	55                   	push   %rbp
  80282c:	48 89 e5             	mov    %rsp,%rbp
  80282f:	48 83 ec 20          	sub    $0x20,%rsp
  802833:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802837:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80283b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283f:	48 89 c7             	mov    %rax,%rdi
  802842:	48 b8 27 0f 80 00 00 	movabs $0x800f27,%rax
  802849:	00 00 00 
  80284c:	ff d0                	callq  *%rax
  80284e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802852:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802856:	48 be 44 3d 80 00 00 	movabs $0x803d44,%rsi
  80285d:	00 00 00 
  802860:	48 89 c7             	mov    %rax,%rdi
  802863:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  80286a:	00 00 00 
  80286d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80286f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802873:	8b 50 04             	mov    0x4(%rax),%edx
  802876:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80287a:	8b 00                	mov    (%rax),%eax
  80287c:	29 c2                	sub    %eax,%edx
  80287e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802882:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802888:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80288c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802893:	00 00 00 
	stat->st_dev = &devpipe;
  802896:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8028a1:	00 00 00 
  8028a4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8028ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b0:	c9                   	leaveq 
  8028b1:	c3                   	retq   

00000000008028b2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8028b2:	55                   	push   %rbp
  8028b3:	48 89 e5             	mov    %rsp,%rbp
  8028b6:	48 83 ec 10          	sub    $0x10,%rsp
  8028ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8028be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028c2:	48 89 c6             	mov    %rax,%rsi
  8028c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ca:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  8028d1:	00 00 00 
  8028d4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8028d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028da:	48 89 c7             	mov    %rax,%rdi
  8028dd:	48 b8 27 0f 80 00 00 	movabs $0x800f27,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	callq  *%rax
  8028e9:	48 89 c6             	mov    %rax,%rsi
  8028ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f1:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	callq  *%rax
}
  8028fd:	c9                   	leaveq 
  8028fe:	c3                   	retq   
	...

0000000000802900 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802900:	55                   	push   %rbp
  802901:	48 89 e5             	mov    %rsp,%rbp
  802904:	48 83 ec 20          	sub    $0x20,%rsp
  802908:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80290b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80290e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802911:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802915:	be 01 00 00 00       	mov    $0x1,%esi
  80291a:	48 89 c7             	mov    %rax,%rdi
  80291d:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  802924:	00 00 00 
  802927:	ff d0                	callq  *%rax
}
  802929:	c9                   	leaveq 
  80292a:	c3                   	retq   

000000000080292b <getchar>:

int
getchar(void)
{
  80292b:	55                   	push   %rbp
  80292c:	48 89 e5             	mov    %rsp,%rbp
  80292f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802933:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802937:	ba 01 00 00 00       	mov    $0x1,%edx
  80293c:	48 89 c6             	mov    %rax,%rsi
  80293f:	bf 00 00 00 00       	mov    $0x0,%edi
  802944:	48 b8 1c 14 80 00 00 	movabs $0x80141c,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
  802950:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802953:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802957:	79 05                	jns    80295e <getchar+0x33>
		return r;
  802959:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295c:	eb 14                	jmp    802972 <getchar+0x47>
	if (r < 1)
  80295e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802962:	7f 07                	jg     80296b <getchar+0x40>
		return -E_EOF;
  802964:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802969:	eb 07                	jmp    802972 <getchar+0x47>
	return c;
  80296b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80296f:	0f b6 c0             	movzbl %al,%eax
}
  802972:	c9                   	leaveq 
  802973:	c3                   	retq   

0000000000802974 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802974:	55                   	push   %rbp
  802975:	48 89 e5             	mov    %rsp,%rbp
  802978:	48 83 ec 20          	sub    $0x20,%rsp
  80297c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80297f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802983:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802986:	48 89 d6             	mov    %rdx,%rsi
  802989:	89 c7                	mov    %eax,%edi
  80298b:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  802992:	00 00 00 
  802995:	ff d0                	callq  *%rax
  802997:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299e:	79 05                	jns    8029a5 <iscons+0x31>
		return r;
  8029a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a3:	eb 1a                	jmp    8029bf <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8029a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a9:	8b 10                	mov    (%rax),%edx
  8029ab:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8029b2:	00 00 00 
  8029b5:	8b 00                	mov    (%rax),%eax
  8029b7:	39 c2                	cmp    %eax,%edx
  8029b9:	0f 94 c0             	sete   %al
  8029bc:	0f b6 c0             	movzbl %al,%eax
}
  8029bf:	c9                   	leaveq 
  8029c0:	c3                   	retq   

00000000008029c1 <opencons>:

int
opencons(void)
{
  8029c1:	55                   	push   %rbp
  8029c2:	48 89 e5             	mov    %rsp,%rbp
  8029c5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029c9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8029cd:	48 89 c7             	mov    %rax,%rdi
  8029d0:	48 b8 52 0f 80 00 00 	movabs $0x800f52,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
  8029dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e3:	79 05                	jns    8029ea <opencons+0x29>
		return r;
  8029e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e8:	eb 5b                	jmp    802a45 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ee:	ba 07 04 00 00       	mov    $0x407,%edx
  8029f3:	48 89 c6             	mov    %rax,%rsi
  8029f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8029fb:	48 b8 b4 0b 80 00 00 	movabs $0x800bb4,%rax
  802a02:	00 00 00 
  802a05:	ff d0                	callq  *%rax
  802a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0e:	79 05                	jns    802a15 <opencons+0x54>
		return r;
  802a10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a13:	eb 30                	jmp    802a45 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802a15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a19:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802a20:	00 00 00 
  802a23:	8b 12                	mov    (%rdx),%edx
  802a25:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802a32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a36:	48 89 c7             	mov    %rax,%rdi
  802a39:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  802a40:	00 00 00 
  802a43:	ff d0                	callq  *%rax
}
  802a45:	c9                   	leaveq 
  802a46:	c3                   	retq   

0000000000802a47 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a47:	55                   	push   %rbp
  802a48:	48 89 e5             	mov    %rsp,%rbp
  802a4b:	48 83 ec 30          	sub    $0x30,%rsp
  802a4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a57:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802a5b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802a60:	75 13                	jne    802a75 <devcons_read+0x2e>
		return 0;
  802a62:	b8 00 00 00 00       	mov    $0x0,%eax
  802a67:	eb 49                	jmp    802ab2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802a69:	48 b8 76 0b 80 00 00 	movabs $0x800b76,%rax
  802a70:	00 00 00 
  802a73:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802a75:	48 b8 b6 0a 80 00 00 	movabs $0x800ab6,%rax
  802a7c:	00 00 00 
  802a7f:	ff d0                	callq  *%rax
  802a81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a88:	74 df                	je     802a69 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  802a8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8e:	79 05                	jns    802a95 <devcons_read+0x4e>
		return c;
  802a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a93:	eb 1d                	jmp    802ab2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  802a95:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802a99:	75 07                	jne    802aa2 <devcons_read+0x5b>
		return 0;
  802a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa0:	eb 10                	jmp    802ab2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  802aa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa5:	89 c2                	mov    %eax,%edx
  802aa7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aab:	88 10                	mov    %dl,(%rax)
	return 1;
  802aad:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802ab2:	c9                   	leaveq 
  802ab3:	c3                   	retq   

0000000000802ab4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802ab4:	55                   	push   %rbp
  802ab5:	48 89 e5             	mov    %rsp,%rbp
  802ab8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802abf:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802ac6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802acd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802ad4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802adb:	eb 77                	jmp    802b54 <devcons_write+0xa0>
		m = n - tot;
  802add:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802ae4:	89 c2                	mov    %eax,%edx
  802ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae9:	89 d1                	mov    %edx,%ecx
  802aeb:	29 c1                	sub    %eax,%ecx
  802aed:	89 c8                	mov    %ecx,%eax
  802aef:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802af2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802af5:	83 f8 7f             	cmp    $0x7f,%eax
  802af8:	76 07                	jbe    802b01 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  802afa:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802b01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b04:	48 63 d0             	movslq %eax,%rdx
  802b07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0a:	48 98                	cltq   
  802b0c:	48 89 c1             	mov    %rax,%rcx
  802b0f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  802b16:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802b1d:	48 89 ce             	mov    %rcx,%rsi
  802b20:	48 89 c7             	mov    %rax,%rdi
  802b23:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  802b2a:	00 00 00 
  802b2d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802b2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b32:	48 63 d0             	movslq %eax,%rdx
  802b35:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802b3c:	48 89 d6             	mov    %rdx,%rsi
  802b3f:	48 89 c7             	mov    %rax,%rdi
  802b42:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  802b49:	00 00 00 
  802b4c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b51:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b57:	48 98                	cltq   
  802b59:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802b60:	0f 82 77 ff ff ff    	jb     802add <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802b66:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b69:	c9                   	leaveq 
  802b6a:	c3                   	retq   

0000000000802b6b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802b6b:	55                   	push   %rbp
  802b6c:	48 89 e5             	mov    %rsp,%rbp
  802b6f:	48 83 ec 08          	sub    $0x8,%rsp
  802b73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b7c:	c9                   	leaveq 
  802b7d:	c3                   	retq   

0000000000802b7e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802b7e:	55                   	push   %rbp
  802b7f:	48 89 e5             	mov    %rsp,%rbp
  802b82:	48 83 ec 10          	sub    $0x10,%rsp
  802b86:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802b8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b92:	48 be 50 3d 80 00 00 	movabs $0x803d50,%rsi
  802b99:	00 00 00 
  802b9c:	48 89 c7             	mov    %rax,%rdi
  802b9f:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
	return 0;
  802bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb0:	c9                   	leaveq 
  802bb1:	c3                   	retq   
	...

0000000000802bb4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802bb4:	55                   	push   %rbp
  802bb5:	48 89 e5             	mov    %rsp,%rbp
  802bb8:	53                   	push   %rbx
  802bb9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802bc0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802bc7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802bcd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802bd4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802bdb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802be2:	84 c0                	test   %al,%al
  802be4:	74 23                	je     802c09 <_panic+0x55>
  802be6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802bed:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802bf1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802bf5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802bf9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802bfd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802c01:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802c05:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802c09:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802c10:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802c17:	00 00 00 
  802c1a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802c21:	00 00 00 
  802c24:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802c28:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802c2f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802c36:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802c3d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802c44:	00 00 00 
  802c47:	48 8b 18             	mov    (%rax),%rbx
  802c4a:	48 b8 38 0b 80 00 00 	movabs $0x800b38,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802c5c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802c63:	41 89 c8             	mov    %ecx,%r8d
  802c66:	48 89 d1             	mov    %rdx,%rcx
  802c69:	48 89 da             	mov    %rbx,%rdx
  802c6c:	89 c6                	mov    %eax,%esi
  802c6e:	48 bf 58 3d 80 00 00 	movabs $0x803d58,%rdi
  802c75:	00 00 00 
  802c78:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7d:	49 b9 ef 2d 80 00 00 	movabs $0x802def,%r9
  802c84:	00 00 00 
  802c87:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802c8a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802c91:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802c98:	48 89 d6             	mov    %rdx,%rsi
  802c9b:	48 89 c7             	mov    %rax,%rdi
  802c9e:	48 b8 43 2d 80 00 00 	movabs $0x802d43,%rax
  802ca5:	00 00 00 
  802ca8:	ff d0                	callq  *%rax
	cprintf("\n");
  802caa:	48 bf 7b 3d 80 00 00 	movabs $0x803d7b,%rdi
  802cb1:	00 00 00 
  802cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb9:	48 ba ef 2d 80 00 00 	movabs $0x802def,%rdx
  802cc0:	00 00 00 
  802cc3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802cc5:	cc                   	int3   
  802cc6:	eb fd                	jmp    802cc5 <_panic+0x111>

0000000000802cc8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  802cc8:	55                   	push   %rbp
  802cc9:	48 89 e5             	mov    %rsp,%rbp
  802ccc:	48 83 ec 10          	sub    $0x10,%rsp
  802cd0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  802cd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cdb:	8b 00                	mov    (%rax),%eax
  802cdd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ce0:	89 d6                	mov    %edx,%esi
  802ce2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802ce6:	48 63 d0             	movslq %eax,%rdx
  802ce9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  802cee:	8d 50 01             	lea    0x1(%rax),%edx
  802cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf5:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  802cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cfb:	8b 00                	mov    (%rax),%eax
  802cfd:	3d ff 00 00 00       	cmp    $0xff,%eax
  802d02:	75 2c                	jne    802d30 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  802d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d08:	8b 00                	mov    (%rax),%eax
  802d0a:	48 98                	cltq   
  802d0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d10:	48 83 c2 08          	add    $0x8,%rdx
  802d14:	48 89 c6             	mov    %rax,%rsi
  802d17:	48 89 d7             	mov    %rdx,%rdi
  802d1a:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  802d21:	00 00 00 
  802d24:	ff d0                	callq  *%rax
        b->idx = 0;
  802d26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802d30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d34:	8b 40 04             	mov    0x4(%rax),%eax
  802d37:	8d 50 01             	lea    0x1(%rax),%edx
  802d3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3e:	89 50 04             	mov    %edx,0x4(%rax)
}
  802d41:	c9                   	leaveq 
  802d42:	c3                   	retq   

0000000000802d43 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  802d43:	55                   	push   %rbp
  802d44:	48 89 e5             	mov    %rsp,%rbp
  802d47:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802d4e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802d55:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802d5c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802d63:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802d6a:	48 8b 0a             	mov    (%rdx),%rcx
  802d6d:	48 89 08             	mov    %rcx,(%rax)
  802d70:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802d74:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802d78:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802d7c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802d80:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802d87:	00 00 00 
    b.cnt = 0;
  802d8a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802d91:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802d94:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802d9b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802da2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802da9:	48 89 c6             	mov    %rax,%rsi
  802dac:	48 bf c8 2c 80 00 00 	movabs $0x802cc8,%rdi
  802db3:	00 00 00 
  802db6:	48 b8 a0 31 80 00 00 	movabs $0x8031a0,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802dc2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802dc8:	48 98                	cltq   
  802dca:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802dd1:	48 83 c2 08          	add    $0x8,%rdx
  802dd5:	48 89 c6             	mov    %rax,%rsi
  802dd8:	48 89 d7             	mov    %rdx,%rdi
  802ddb:	48 b8 6c 0a 80 00 00 	movabs $0x800a6c,%rax
  802de2:	00 00 00 
  802de5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802de7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802ded:	c9                   	leaveq 
  802dee:	c3                   	retq   

0000000000802def <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802def:	55                   	push   %rbp
  802df0:	48 89 e5             	mov    %rsp,%rbp
  802df3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802dfa:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802e01:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e08:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e0f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e16:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e1d:	84 c0                	test   %al,%al
  802e1f:	74 20                	je     802e41 <cprintf+0x52>
  802e21:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e25:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e29:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e2d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e31:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e35:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e39:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e3d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e41:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802e48:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802e4f:	00 00 00 
  802e52:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802e59:	00 00 00 
  802e5c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e60:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802e67:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802e6e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802e75:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802e7c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802e83:	48 8b 0a             	mov    (%rdx),%rcx
  802e86:	48 89 08             	mov    %rcx,(%rax)
  802e89:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802e8d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802e91:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802e95:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802e99:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802ea0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802ea7:	48 89 d6             	mov    %rdx,%rsi
  802eaa:	48 89 c7             	mov    %rax,%rdi
  802ead:	48 b8 43 2d 80 00 00 	movabs $0x802d43,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
  802eb9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802ebf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ec5:	c9                   	leaveq 
  802ec6:	c3                   	retq   
	...

0000000000802ec8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802ec8:	55                   	push   %rbp
  802ec9:	48 89 e5             	mov    %rsp,%rbp
  802ecc:	48 83 ec 30          	sub    $0x30,%rsp
  802ed0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ed4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ed8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802edc:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  802edf:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  802ee3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802ee7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802eea:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  802eee:	77 52                	ja     802f42 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802ef0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  802ef3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802ef7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802efa:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f02:	ba 00 00 00 00       	mov    $0x0,%edx
  802f07:	48 f7 75 d0          	divq   -0x30(%rbp)
  802f0b:	48 89 c2             	mov    %rax,%rdx
  802f0e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802f11:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802f14:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f1c:	41 89 f9             	mov    %edi,%r9d
  802f1f:	48 89 c7             	mov    %rax,%rdi
  802f22:	48 b8 c8 2e 80 00 00 	movabs $0x802ec8,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
  802f2e:	eb 1c                	jmp    802f4c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  802f30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f34:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f37:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802f3b:	48 89 d6             	mov    %rdx,%rsi
  802f3e:	89 c7                	mov    %eax,%edi
  802f40:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802f42:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  802f46:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  802f4a:	7f e4                	jg     802f30 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802f4c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f53:	ba 00 00 00 00       	mov    $0x0,%edx
  802f58:	48 f7 f1             	div    %rcx
  802f5b:	48 89 d0             	mov    %rdx,%rax
  802f5e:	48 ba 70 3f 80 00 00 	movabs $0x803f70,%rdx
  802f65:	00 00 00 
  802f68:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802f6c:	0f be c0             	movsbl %al,%eax
  802f6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f73:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802f77:	48 89 d6             	mov    %rdx,%rsi
  802f7a:	89 c7                	mov    %eax,%edi
  802f7c:	ff d1                	callq  *%rcx
}
  802f7e:	c9                   	leaveq 
  802f7f:	c3                   	retq   

0000000000802f80 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802f80:	55                   	push   %rbp
  802f81:	48 89 e5             	mov    %rsp,%rbp
  802f84:	48 83 ec 20          	sub    $0x20,%rsp
  802f88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f8c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802f8f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802f93:	7e 52                	jle    802fe7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f99:	8b 00                	mov    (%rax),%eax
  802f9b:	83 f8 30             	cmp    $0x30,%eax
  802f9e:	73 24                	jae    802fc4 <getuint+0x44>
  802fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802fa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fac:	8b 00                	mov    (%rax),%eax
  802fae:	89 c0                	mov    %eax,%eax
  802fb0:	48 01 d0             	add    %rdx,%rax
  802fb3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fb7:	8b 12                	mov    (%rdx),%edx
  802fb9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802fbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fc0:	89 0a                	mov    %ecx,(%rdx)
  802fc2:	eb 17                	jmp    802fdb <getuint+0x5b>
  802fc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802fcc:	48 89 d0             	mov    %rdx,%rax
  802fcf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802fd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fd7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802fdb:	48 8b 00             	mov    (%rax),%rax
  802fde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802fe2:	e9 a3 00 00 00       	jmpq   80308a <getuint+0x10a>
	else if (lflag)
  802fe7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802feb:	74 4f                	je     80303c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff1:	8b 00                	mov    (%rax),%eax
  802ff3:	83 f8 30             	cmp    $0x30,%eax
  802ff6:	73 24                	jae    80301c <getuint+0x9c>
  802ff8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ffc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803000:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803004:	8b 00                	mov    (%rax),%eax
  803006:	89 c0                	mov    %eax,%eax
  803008:	48 01 d0             	add    %rdx,%rax
  80300b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80300f:	8b 12                	mov    (%rdx),%edx
  803011:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803014:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803018:	89 0a                	mov    %ecx,(%rdx)
  80301a:	eb 17                	jmp    803033 <getuint+0xb3>
  80301c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803020:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803024:	48 89 d0             	mov    %rdx,%rax
  803027:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80302b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80302f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803033:	48 8b 00             	mov    (%rax),%rax
  803036:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80303a:	eb 4e                	jmp    80308a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80303c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803040:	8b 00                	mov    (%rax),%eax
  803042:	83 f8 30             	cmp    $0x30,%eax
  803045:	73 24                	jae    80306b <getuint+0xeb>
  803047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80304f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803053:	8b 00                	mov    (%rax),%eax
  803055:	89 c0                	mov    %eax,%eax
  803057:	48 01 d0             	add    %rdx,%rax
  80305a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80305e:	8b 12                	mov    (%rdx),%edx
  803060:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803063:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803067:	89 0a                	mov    %ecx,(%rdx)
  803069:	eb 17                	jmp    803082 <getuint+0x102>
  80306b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803073:	48 89 d0             	mov    %rdx,%rax
  803076:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80307a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80307e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803082:	8b 00                	mov    (%rax),%eax
  803084:	89 c0                	mov    %eax,%eax
  803086:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80308a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80308e:	c9                   	leaveq 
  80308f:	c3                   	retq   

0000000000803090 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803090:	55                   	push   %rbp
  803091:	48 89 e5             	mov    %rsp,%rbp
  803094:	48 83 ec 20          	sub    $0x20,%rsp
  803098:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80309c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80309f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8030a3:	7e 52                	jle    8030f7 <getint+0x67>
		x=va_arg(*ap, long long);
  8030a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a9:	8b 00                	mov    (%rax),%eax
  8030ab:	83 f8 30             	cmp    $0x30,%eax
  8030ae:	73 24                	jae    8030d4 <getint+0x44>
  8030b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8030b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bc:	8b 00                	mov    (%rax),%eax
  8030be:	89 c0                	mov    %eax,%eax
  8030c0:	48 01 d0             	add    %rdx,%rax
  8030c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030c7:	8b 12                	mov    (%rdx),%edx
  8030c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8030cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030d0:	89 0a                	mov    %ecx,(%rdx)
  8030d2:	eb 17                	jmp    8030eb <getint+0x5b>
  8030d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8030dc:	48 89 d0             	mov    %rdx,%rax
  8030df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8030e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8030eb:	48 8b 00             	mov    (%rax),%rax
  8030ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8030f2:	e9 a3 00 00 00       	jmpq   80319a <getint+0x10a>
	else if (lflag)
  8030f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8030fb:	74 4f                	je     80314c <getint+0xbc>
		x=va_arg(*ap, long);
  8030fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803101:	8b 00                	mov    (%rax),%eax
  803103:	83 f8 30             	cmp    $0x30,%eax
  803106:	73 24                	jae    80312c <getint+0x9c>
  803108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803114:	8b 00                	mov    (%rax),%eax
  803116:	89 c0                	mov    %eax,%eax
  803118:	48 01 d0             	add    %rdx,%rax
  80311b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80311f:	8b 12                	mov    (%rdx),%edx
  803121:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803124:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803128:	89 0a                	mov    %ecx,(%rdx)
  80312a:	eb 17                	jmp    803143 <getint+0xb3>
  80312c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803130:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803134:	48 89 d0             	mov    %rdx,%rax
  803137:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80313b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80313f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803143:	48 8b 00             	mov    (%rax),%rax
  803146:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80314a:	eb 4e                	jmp    80319a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80314c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803150:	8b 00                	mov    (%rax),%eax
  803152:	83 f8 30             	cmp    $0x30,%eax
  803155:	73 24                	jae    80317b <getint+0xeb>
  803157:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80315f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803163:	8b 00                	mov    (%rax),%eax
  803165:	89 c0                	mov    %eax,%eax
  803167:	48 01 d0             	add    %rdx,%rax
  80316a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80316e:	8b 12                	mov    (%rdx),%edx
  803170:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803173:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803177:	89 0a                	mov    %ecx,(%rdx)
  803179:	eb 17                	jmp    803192 <getint+0x102>
  80317b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80317f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803183:	48 89 d0             	mov    %rdx,%rax
  803186:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80318a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80318e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803192:	8b 00                	mov    (%rax),%eax
  803194:	48 98                	cltq   
  803196:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80319a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80319e:	c9                   	leaveq 
  80319f:	c3                   	retq   

00000000008031a0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8031a0:	55                   	push   %rbp
  8031a1:	48 89 e5             	mov    %rsp,%rbp
  8031a4:	41 54                	push   %r12
  8031a6:	53                   	push   %rbx
  8031a7:	48 83 ec 60          	sub    $0x60,%rsp
  8031ab:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8031af:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8031b3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8031b7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8031bb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8031bf:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8031c3:	48 8b 0a             	mov    (%rdx),%rcx
  8031c6:	48 89 08             	mov    %rcx,(%rax)
  8031c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8031cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8031d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8031d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8031d9:	eb 17                	jmp    8031f2 <vprintfmt+0x52>
			if (ch == '\0')
  8031db:	85 db                	test   %ebx,%ebx
  8031dd:	0f 84 ea 04 00 00    	je     8036cd <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  8031e3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8031e7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8031eb:	48 89 c6             	mov    %rax,%rsi
  8031ee:	89 df                	mov    %ebx,%edi
  8031f0:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8031f2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8031f6:	0f b6 00             	movzbl (%rax),%eax
  8031f9:	0f b6 d8             	movzbl %al,%ebx
  8031fc:	83 fb 25             	cmp    $0x25,%ebx
  8031ff:	0f 95 c0             	setne  %al
  803202:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  803207:	84 c0                	test   %al,%al
  803209:	75 d0                	jne    8031db <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80320b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80320f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  803216:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80321d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  803224:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80322b:	eb 04                	jmp    803231 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80322d:	90                   	nop
  80322e:	eb 01                	jmp    803231 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  803230:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803231:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803235:	0f b6 00             	movzbl (%rax),%eax
  803238:	0f b6 d8             	movzbl %al,%ebx
  80323b:	89 d8                	mov    %ebx,%eax
  80323d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  803242:	83 e8 23             	sub    $0x23,%eax
  803245:	83 f8 55             	cmp    $0x55,%eax
  803248:	0f 87 4b 04 00 00    	ja     803699 <vprintfmt+0x4f9>
  80324e:	89 c0                	mov    %eax,%eax
  803250:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803257:	00 
  803258:	48 b8 98 3f 80 00 00 	movabs $0x803f98,%rax
  80325f:	00 00 00 
  803262:	48 01 d0             	add    %rdx,%rax
  803265:	48 8b 00             	mov    (%rax),%rax
  803268:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80326a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80326e:	eb c1                	jmp    803231 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803270:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803274:	eb bb                	jmp    803231 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803276:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80327d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803280:	89 d0                	mov    %edx,%eax
  803282:	c1 e0 02             	shl    $0x2,%eax
  803285:	01 d0                	add    %edx,%eax
  803287:	01 c0                	add    %eax,%eax
  803289:	01 d8                	add    %ebx,%eax
  80328b:	83 e8 30             	sub    $0x30,%eax
  80328e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803291:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803295:	0f b6 00             	movzbl (%rax),%eax
  803298:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80329b:	83 fb 2f             	cmp    $0x2f,%ebx
  80329e:	7e 63                	jle    803303 <vprintfmt+0x163>
  8032a0:	83 fb 39             	cmp    $0x39,%ebx
  8032a3:	7f 5e                	jg     803303 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8032a5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8032aa:	eb d1                	jmp    80327d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8032ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8032af:	83 f8 30             	cmp    $0x30,%eax
  8032b2:	73 17                	jae    8032cb <vprintfmt+0x12b>
  8032b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8032b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8032bb:	89 c0                	mov    %eax,%eax
  8032bd:	48 01 d0             	add    %rdx,%rax
  8032c0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8032c3:	83 c2 08             	add    $0x8,%edx
  8032c6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8032c9:	eb 0f                	jmp    8032da <vprintfmt+0x13a>
  8032cb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8032cf:	48 89 d0             	mov    %rdx,%rax
  8032d2:	48 83 c2 08          	add    $0x8,%rdx
  8032d6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8032da:	8b 00                	mov    (%rax),%eax
  8032dc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8032df:	eb 23                	jmp    803304 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8032e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8032e5:	0f 89 42 ff ff ff    	jns    80322d <vprintfmt+0x8d>
				width = 0;
  8032eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8032f2:	e9 36 ff ff ff       	jmpq   80322d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8032f7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8032fe:	e9 2e ff ff ff       	jmpq   803231 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  803303:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  803304:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803308:	0f 89 22 ff ff ff    	jns    803230 <vprintfmt+0x90>
				width = precision, precision = -1;
  80330e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803311:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803314:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80331b:	e9 10 ff ff ff       	jmpq   803230 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803320:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803324:	e9 08 ff ff ff       	jmpq   803231 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803329:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80332c:	83 f8 30             	cmp    $0x30,%eax
  80332f:	73 17                	jae    803348 <vprintfmt+0x1a8>
  803331:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803335:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803338:	89 c0                	mov    %eax,%eax
  80333a:	48 01 d0             	add    %rdx,%rax
  80333d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803340:	83 c2 08             	add    $0x8,%edx
  803343:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803346:	eb 0f                	jmp    803357 <vprintfmt+0x1b7>
  803348:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80334c:	48 89 d0             	mov    %rdx,%rax
  80334f:	48 83 c2 08          	add    $0x8,%rdx
  803353:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803357:	8b 00                	mov    (%rax),%eax
  803359:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80335d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  803361:	48 89 d6             	mov    %rdx,%rsi
  803364:	89 c7                	mov    %eax,%edi
  803366:	ff d1                	callq  *%rcx
			break;
  803368:	e9 5a 03 00 00       	jmpq   8036c7 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80336d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803370:	83 f8 30             	cmp    $0x30,%eax
  803373:	73 17                	jae    80338c <vprintfmt+0x1ec>
  803375:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803379:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80337c:	89 c0                	mov    %eax,%eax
  80337e:	48 01 d0             	add    %rdx,%rax
  803381:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803384:	83 c2 08             	add    $0x8,%edx
  803387:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80338a:	eb 0f                	jmp    80339b <vprintfmt+0x1fb>
  80338c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803390:	48 89 d0             	mov    %rdx,%rax
  803393:	48 83 c2 08          	add    $0x8,%rdx
  803397:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80339b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80339d:	85 db                	test   %ebx,%ebx
  80339f:	79 02                	jns    8033a3 <vprintfmt+0x203>
				err = -err;
  8033a1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8033a3:	83 fb 15             	cmp    $0x15,%ebx
  8033a6:	7f 16                	jg     8033be <vprintfmt+0x21e>
  8033a8:	48 b8 c0 3e 80 00 00 	movabs $0x803ec0,%rax
  8033af:	00 00 00 
  8033b2:	48 63 d3             	movslq %ebx,%rdx
  8033b5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8033b9:	4d 85 e4             	test   %r12,%r12
  8033bc:	75 2e                	jne    8033ec <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  8033be:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8033c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8033c6:	89 d9                	mov    %ebx,%ecx
  8033c8:	48 ba 81 3f 80 00 00 	movabs $0x803f81,%rdx
  8033cf:	00 00 00 
  8033d2:	48 89 c7             	mov    %rax,%rdi
  8033d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033da:	49 b8 d7 36 80 00 00 	movabs $0x8036d7,%r8
  8033e1:	00 00 00 
  8033e4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8033e7:	e9 db 02 00 00       	jmpq   8036c7 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8033ec:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8033f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8033f4:	4c 89 e1             	mov    %r12,%rcx
  8033f7:	48 ba 8a 3f 80 00 00 	movabs $0x803f8a,%rdx
  8033fe:	00 00 00 
  803401:	48 89 c7             	mov    %rax,%rdi
  803404:	b8 00 00 00 00       	mov    $0x0,%eax
  803409:	49 b8 d7 36 80 00 00 	movabs $0x8036d7,%r8
  803410:	00 00 00 
  803413:	41 ff d0             	callq  *%r8
			break;
  803416:	e9 ac 02 00 00       	jmpq   8036c7 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80341b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80341e:	83 f8 30             	cmp    $0x30,%eax
  803421:	73 17                	jae    80343a <vprintfmt+0x29a>
  803423:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803427:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80342a:	89 c0                	mov    %eax,%eax
  80342c:	48 01 d0             	add    %rdx,%rax
  80342f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803432:	83 c2 08             	add    $0x8,%edx
  803435:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803438:	eb 0f                	jmp    803449 <vprintfmt+0x2a9>
  80343a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80343e:	48 89 d0             	mov    %rdx,%rax
  803441:	48 83 c2 08          	add    $0x8,%rdx
  803445:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803449:	4c 8b 20             	mov    (%rax),%r12
  80344c:	4d 85 e4             	test   %r12,%r12
  80344f:	75 0a                	jne    80345b <vprintfmt+0x2bb>
				p = "(null)";
  803451:	49 bc 8d 3f 80 00 00 	movabs $0x803f8d,%r12
  803458:	00 00 00 
			if (width > 0 && padc != '-')
  80345b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80345f:	7e 7a                	jle    8034db <vprintfmt+0x33b>
  803461:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803465:	74 74                	je     8034db <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  803467:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80346a:	48 98                	cltq   
  80346c:	48 89 c6             	mov    %rax,%rsi
  80346f:	4c 89 e7             	mov    %r12,%rdi
  803472:	48 b8 3e 02 80 00 00 	movabs $0x80023e,%rax
  803479:	00 00 00 
  80347c:	ff d0                	callq  *%rax
  80347e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803481:	eb 17                	jmp    80349a <vprintfmt+0x2fa>
					putch(padc, putdat);
  803483:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  803487:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80348b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80348f:	48 89 d6             	mov    %rdx,%rsi
  803492:	89 c7                	mov    %eax,%edi
  803494:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803496:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80349a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80349e:	7f e3                	jg     803483 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8034a0:	eb 39                	jmp    8034db <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  8034a2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8034a6:	74 1e                	je     8034c6 <vprintfmt+0x326>
  8034a8:	83 fb 1f             	cmp    $0x1f,%ebx
  8034ab:	7e 05                	jle    8034b2 <vprintfmt+0x312>
  8034ad:	83 fb 7e             	cmp    $0x7e,%ebx
  8034b0:	7e 14                	jle    8034c6 <vprintfmt+0x326>
					putch('?', putdat);
  8034b2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8034b6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8034ba:	48 89 c6             	mov    %rax,%rsi
  8034bd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8034c2:	ff d2                	callq  *%rdx
  8034c4:	eb 0f                	jmp    8034d5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  8034c6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8034ca:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8034ce:	48 89 c6             	mov    %rax,%rsi
  8034d1:	89 df                	mov    %ebx,%edi
  8034d3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8034d5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8034d9:	eb 01                	jmp    8034dc <vprintfmt+0x33c>
  8034db:	90                   	nop
  8034dc:	41 0f b6 04 24       	movzbl (%r12),%eax
  8034e1:	0f be d8             	movsbl %al,%ebx
  8034e4:	85 db                	test   %ebx,%ebx
  8034e6:	0f 95 c0             	setne  %al
  8034e9:	49 83 c4 01          	add    $0x1,%r12
  8034ed:	84 c0                	test   %al,%al
  8034ef:	74 28                	je     803519 <vprintfmt+0x379>
  8034f1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8034f5:	78 ab                	js     8034a2 <vprintfmt+0x302>
  8034f7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8034fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8034ff:	79 a1                	jns    8034a2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803501:	eb 16                	jmp    803519 <vprintfmt+0x379>
				putch(' ', putdat);
  803503:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803507:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80350b:	48 89 c6             	mov    %rax,%rsi
  80350e:	bf 20 00 00 00       	mov    $0x20,%edi
  803513:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803515:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803519:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80351d:	7f e4                	jg     803503 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80351f:	e9 a3 01 00 00       	jmpq   8036c7 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803524:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803528:	be 03 00 00 00       	mov    $0x3,%esi
  80352d:	48 89 c7             	mov    %rax,%rdi
  803530:	48 b8 90 30 80 00 00 	movabs $0x803090,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
  80353c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803544:	48 85 c0             	test   %rax,%rax
  803547:	79 1d                	jns    803566 <vprintfmt+0x3c6>
				putch('-', putdat);
  803549:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80354d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803551:	48 89 c6             	mov    %rax,%rsi
  803554:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803559:	ff d2                	callq  *%rdx
				num = -(long long) num;
  80355b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355f:	48 f7 d8             	neg    %rax
  803562:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803566:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80356d:	e9 e8 00 00 00       	jmpq   80365a <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803572:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803576:	be 03 00 00 00       	mov    $0x3,%esi
  80357b:	48 89 c7             	mov    %rax,%rdi
  80357e:	48 b8 80 2f 80 00 00 	movabs $0x802f80,%rax
  803585:	00 00 00 
  803588:	ff d0                	callq  *%rax
  80358a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80358e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803595:	e9 c0 00 00 00       	jmpq   80365a <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80359a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80359e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8035a2:	48 89 c6             	mov    %rax,%rsi
  8035a5:	bf 58 00 00 00       	mov    $0x58,%edi
  8035aa:	ff d2                	callq  *%rdx
			putch('X', putdat);
  8035ac:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8035b0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8035b4:	48 89 c6             	mov    %rax,%rsi
  8035b7:	bf 58 00 00 00       	mov    $0x58,%edi
  8035bc:	ff d2                	callq  *%rdx
			putch('X', putdat);
  8035be:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8035c2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8035c6:	48 89 c6             	mov    %rax,%rsi
  8035c9:	bf 58 00 00 00       	mov    $0x58,%edi
  8035ce:	ff d2                	callq  *%rdx
			break;
  8035d0:	e9 f2 00 00 00       	jmpq   8036c7 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  8035d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8035d9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8035dd:	48 89 c6             	mov    %rax,%rsi
  8035e0:	bf 30 00 00 00       	mov    $0x30,%edi
  8035e5:	ff d2                	callq  *%rdx
			putch('x', putdat);
  8035e7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8035eb:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8035ef:	48 89 c6             	mov    %rax,%rsi
  8035f2:	bf 78 00 00 00       	mov    $0x78,%edi
  8035f7:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8035f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8035fc:	83 f8 30             	cmp    $0x30,%eax
  8035ff:	73 17                	jae    803618 <vprintfmt+0x478>
  803601:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803605:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803608:	89 c0                	mov    %eax,%eax
  80360a:	48 01 d0             	add    %rdx,%rax
  80360d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803610:	83 c2 08             	add    $0x8,%edx
  803613:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803616:	eb 0f                	jmp    803627 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  803618:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80361c:	48 89 d0             	mov    %rdx,%rax
  80361f:	48 83 c2 08          	add    $0x8,%rdx
  803623:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803627:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80362a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80362e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803635:	eb 23                	jmp    80365a <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803637:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80363b:	be 03 00 00 00       	mov    $0x3,%esi
  803640:	48 89 c7             	mov    %rax,%rdi
  803643:	48 b8 80 2f 80 00 00 	movabs $0x802f80,%rax
  80364a:	00 00 00 
  80364d:	ff d0                	callq  *%rax
  80364f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803653:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80365a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80365f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803662:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803665:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803669:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80366d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803671:	45 89 c1             	mov    %r8d,%r9d
  803674:	41 89 f8             	mov    %edi,%r8d
  803677:	48 89 c7             	mov    %rax,%rdi
  80367a:	48 b8 c8 2e 80 00 00 	movabs $0x802ec8,%rax
  803681:	00 00 00 
  803684:	ff d0                	callq  *%rax
			break;
  803686:	eb 3f                	jmp    8036c7 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803688:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80368c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803690:	48 89 c6             	mov    %rax,%rsi
  803693:	89 df                	mov    %ebx,%edi
  803695:	ff d2                	callq  *%rdx
			break;
  803697:	eb 2e                	jmp    8036c7 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803699:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80369d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8036a1:	48 89 c6             	mov    %rax,%rsi
  8036a4:	bf 25 00 00 00       	mov    $0x25,%edi
  8036a9:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8036ab:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8036b0:	eb 05                	jmp    8036b7 <vprintfmt+0x517>
  8036b2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8036b7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8036bb:	48 83 e8 01          	sub    $0x1,%rax
  8036bf:	0f b6 00             	movzbl (%rax),%eax
  8036c2:	3c 25                	cmp    $0x25,%al
  8036c4:	75 ec                	jne    8036b2 <vprintfmt+0x512>
				/* do nothing */;
			break;
  8036c6:	90                   	nop
		}
	}
  8036c7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8036c8:	e9 25 fb ff ff       	jmpq   8031f2 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  8036cd:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8036ce:	48 83 c4 60          	add    $0x60,%rsp
  8036d2:	5b                   	pop    %rbx
  8036d3:	41 5c                	pop    %r12
  8036d5:	5d                   	pop    %rbp
  8036d6:	c3                   	retq   

00000000008036d7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8036d7:	55                   	push   %rbp
  8036d8:	48 89 e5             	mov    %rsp,%rbp
  8036db:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8036e2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8036e9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8036f0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8036f7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8036fe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803705:	84 c0                	test   %al,%al
  803707:	74 20                	je     803729 <printfmt+0x52>
  803709:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80370d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803711:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803715:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803719:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80371d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803721:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803725:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803729:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803730:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803737:	00 00 00 
  80373a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803741:	00 00 00 
  803744:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803748:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80374f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803756:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80375d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803764:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80376b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803772:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803779:	48 89 c7             	mov    %rax,%rdi
  80377c:	48 b8 a0 31 80 00 00 	movabs $0x8031a0,%rax
  803783:	00 00 00 
  803786:	ff d0                	callq  *%rax
	va_end(ap);
}
  803788:	c9                   	leaveq 
  803789:	c3                   	retq   

000000000080378a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80378a:	55                   	push   %rbp
  80378b:	48 89 e5             	mov    %rsp,%rbp
  80378e:	48 83 ec 10          	sub    $0x10,%rsp
  803792:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803795:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803799:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379d:	8b 40 10             	mov    0x10(%rax),%eax
  8037a0:	8d 50 01             	lea    0x1(%rax),%edx
  8037a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8037aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ae:	48 8b 10             	mov    (%rax),%rdx
  8037b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037b9:	48 39 c2             	cmp    %rax,%rdx
  8037bc:	73 17                	jae    8037d5 <sprintputch+0x4b>
		*b->buf++ = ch;
  8037be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c2:	48 8b 00             	mov    (%rax),%rax
  8037c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037c8:	88 10                	mov    %dl,(%rax)
  8037ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8037ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d2:	48 89 10             	mov    %rdx,(%rax)
}
  8037d5:	c9                   	leaveq 
  8037d6:	c3                   	retq   

00000000008037d7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8037d7:	55                   	push   %rbp
  8037d8:	48 89 e5             	mov    %rsp,%rbp
  8037db:	48 83 ec 50          	sub    $0x50,%rsp
  8037df:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8037e3:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8037e6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8037ea:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8037ee:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8037f2:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8037f6:	48 8b 0a             	mov    (%rdx),%rcx
  8037f9:	48 89 08             	mov    %rcx,(%rax)
  8037fc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803800:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803804:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803808:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80380c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803810:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803814:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803817:	48 98                	cltq   
  803819:	48 83 e8 01          	sub    $0x1,%rax
  80381d:	48 03 45 c8          	add    -0x38(%rbp),%rax
  803821:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803825:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80382c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803831:	74 06                	je     803839 <vsnprintf+0x62>
  803833:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803837:	7f 07                	jg     803840 <vsnprintf+0x69>
		return -E_INVAL;
  803839:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80383e:	eb 2f                	jmp    80386f <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803840:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803844:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803848:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80384c:	48 89 c6             	mov    %rax,%rsi
  80384f:	48 bf 8a 37 80 00 00 	movabs $0x80378a,%rdi
  803856:	00 00 00 
  803859:	48 b8 a0 31 80 00 00 	movabs $0x8031a0,%rax
  803860:	00 00 00 
  803863:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803865:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803869:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80386c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80386f:	c9                   	leaveq 
  803870:	c3                   	retq   

0000000000803871 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803871:	55                   	push   %rbp
  803872:	48 89 e5             	mov    %rsp,%rbp
  803875:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80387c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803883:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803889:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803890:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803897:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80389e:	84 c0                	test   %al,%al
  8038a0:	74 20                	je     8038c2 <snprintf+0x51>
  8038a2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8038a6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8038aa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8038ae:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8038b2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8038b6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8038ba:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8038be:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8038c2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8038c9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8038d0:	00 00 00 
  8038d3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8038da:	00 00 00 
  8038dd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8038e1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8038e8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8038ef:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8038f6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8038fd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803904:	48 8b 0a             	mov    (%rdx),%rcx
  803907:	48 89 08             	mov    %rcx,(%rax)
  80390a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80390e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803912:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803916:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80391a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803921:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803928:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80392e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803935:	48 89 c7             	mov    %rax,%rdi
  803938:	48 b8 d7 37 80 00 00 	movabs $0x8037d7,%rax
  80393f:	00 00 00 
  803942:	ff d0                	callq  *%rax
  803944:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80394a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803950:	c9                   	leaveq 
  803951:	c3                   	retq   
	...

0000000000803954 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803954:	55                   	push   %rbp
  803955:	48 89 e5             	mov    %rsp,%rbp
  803958:	48 83 ec 30          	sub    $0x30,%rsp
  80395c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803960:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803964:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  803968:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  80396f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803974:	74 18                	je     80398e <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  803976:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80397a:	48 89 c7             	mov    %rax,%rdi
  80397d:	48 b8 dd 0d 80 00 00 	movabs $0x800ddd,%rax
  803984:	00 00 00 
  803987:	ff d0                	callq  *%rax
  803989:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80398c:	eb 19                	jmp    8039a7 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  80398e:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  803995:	00 00 00 
  803998:	48 b8 dd 0d 80 00 00 	movabs $0x800ddd,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax
  8039a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  8039a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ab:	79 39                	jns    8039e6 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  8039ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8039b2:	75 08                	jne    8039bc <ipc_recv+0x68>
  8039b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b8:	8b 00                	mov    (%rax),%eax
  8039ba:	eb 05                	jmp    8039c1 <ipc_recv+0x6d>
  8039bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039c5:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  8039c7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039cc:	75 08                	jne    8039d6 <ipc_recv+0x82>
  8039ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d2:	8b 00                	mov    (%rax),%eax
  8039d4:	eb 05                	jmp    8039db <ipc_recv+0x87>
  8039d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039db:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8039df:	89 02                	mov    %eax,(%rdx)
		return r;
  8039e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e4:	eb 53                	jmp    803a39 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  8039e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8039eb:	74 19                	je     803a06 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  8039ed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039f4:	00 00 00 
  8039f7:	48 8b 00             	mov    (%rax),%rax
  8039fa:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803a00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a04:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  803a06:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a0b:	74 19                	je     803a26 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  803a0d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a14:	00 00 00 
  803a17:	48 8b 00             	mov    (%rax),%rax
  803a1a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a24:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  803a26:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a2d:	00 00 00 
  803a30:	48 8b 00             	mov    (%rax),%rax
  803a33:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  803a39:	c9                   	leaveq 
  803a3a:	c3                   	retq   

0000000000803a3b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a3b:	55                   	push   %rbp
  803a3c:	48 89 e5             	mov    %rsp,%rbp
  803a3f:	48 83 ec 30          	sub    $0x30,%rsp
  803a43:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a46:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a49:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a4d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  803a50:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  803a57:	eb 59                	jmp    803ab2 <ipc_send+0x77>
		if(pg) {
  803a59:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a5e:	74 20                	je     803a80 <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  803a60:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a63:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803a66:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803a6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a6d:	89 c7                	mov    %eax,%edi
  803a6f:	48 b8 88 0d 80 00 00 	movabs $0x800d88,%rax
  803a76:	00 00 00 
  803a79:	ff d0                	callq  *%rax
  803a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a7e:	eb 26                	jmp    803aa6 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  803a80:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a83:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a89:	89 d1                	mov    %edx,%ecx
  803a8b:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  803a92:	00 00 00 
  803a95:	89 c7                	mov    %eax,%edi
  803a97:	48 b8 88 0d 80 00 00 	movabs $0x800d88,%rax
  803a9e:	00 00 00 
  803aa1:	ff d0                	callq  *%rax
  803aa3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  803aa6:	48 b8 76 0b 80 00 00 	movabs $0x800b76,%rax
  803aad:	00 00 00 
  803ab0:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  803ab2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ab6:	74 a1                	je     803a59 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  803ab8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abc:	74 2a                	je     803ae8 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  803abe:	48 ba 48 42 80 00 00 	movabs $0x804248,%rdx
  803ac5:	00 00 00 
  803ac8:	be 49 00 00 00       	mov    $0x49,%esi
  803acd:	48 bf 73 42 80 00 00 	movabs $0x804273,%rdi
  803ad4:	00 00 00 
  803ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  803adc:	48 b9 b4 2b 80 00 00 	movabs $0x802bb4,%rcx
  803ae3:	00 00 00 
  803ae6:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  803ae8:	c9                   	leaveq 
  803ae9:	c3                   	retq   

0000000000803aea <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803aea:	55                   	push   %rbp
  803aeb:	48 89 e5             	mov    %rsp,%rbp
  803aee:	48 83 ec 18          	sub    $0x18,%rsp
  803af2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803af5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803afc:	eb 6a                	jmp    803b68 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  803afe:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b05:	00 00 00 
  803b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0b:	48 63 d0             	movslq %eax,%rdx
  803b0e:	48 89 d0             	mov    %rdx,%rax
  803b11:	48 c1 e0 02          	shl    $0x2,%rax
  803b15:	48 01 d0             	add    %rdx,%rax
  803b18:	48 01 c0             	add    %rax,%rax
  803b1b:	48 01 d0             	add    %rdx,%rax
  803b1e:	48 c1 e0 05          	shl    $0x5,%rax
  803b22:	48 01 c8             	add    %rcx,%rax
  803b25:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b2b:	8b 00                	mov    (%rax),%eax
  803b2d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b30:	75 32                	jne    803b64 <ipc_find_env+0x7a>
			return envs[i].env_id;
  803b32:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b39:	00 00 00 
  803b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3f:	48 63 d0             	movslq %eax,%rdx
  803b42:	48 89 d0             	mov    %rdx,%rax
  803b45:	48 c1 e0 02          	shl    $0x2,%rax
  803b49:	48 01 d0             	add    %rdx,%rax
  803b4c:	48 01 c0             	add    %rax,%rax
  803b4f:	48 01 d0             	add    %rdx,%rax
  803b52:	48 c1 e0 05          	shl    $0x5,%rax
  803b56:	48 01 c8             	add    %rcx,%rax
  803b59:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b5f:	8b 40 08             	mov    0x8(%rax),%eax
  803b62:	eb 12                	jmp    803b76 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803b64:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b68:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b6f:	7e 8d                	jle    803afe <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803b71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b76:	c9                   	leaveq 
  803b77:	c3                   	retq   

0000000000803b78 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b78:	55                   	push   %rbp
  803b79:	48 89 e5             	mov    %rsp,%rbp
  803b7c:	48 83 ec 18          	sub    $0x18,%rsp
  803b80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803b84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b88:	48 89 c2             	mov    %rax,%rdx
  803b8b:	48 c1 ea 15          	shr    $0x15,%rdx
  803b8f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b96:	01 00 00 
  803b99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b9d:	83 e0 01             	and    $0x1,%eax
  803ba0:	48 85 c0             	test   %rax,%rax
  803ba3:	75 07                	jne    803bac <pageref+0x34>
		return 0;
  803ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  803baa:	eb 53                	jmp    803bff <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb0:	48 89 c2             	mov    %rax,%rdx
  803bb3:	48 c1 ea 0c          	shr    $0xc,%rdx
  803bb7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bbe:	01 00 00 
  803bc1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bc5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803bc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bcd:	83 e0 01             	and    $0x1,%eax
  803bd0:	48 85 c0             	test   %rax,%rax
  803bd3:	75 07                	jne    803bdc <pageref+0x64>
		return 0;
  803bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  803bda:	eb 23                	jmp    803bff <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803bdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be0:	48 89 c2             	mov    %rax,%rdx
  803be3:	48 c1 ea 0c          	shr    $0xc,%rdx
  803be7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803bee:	00 00 00 
  803bf1:	48 c1 e2 04          	shl    $0x4,%rdx
  803bf5:	48 01 d0             	add    %rdx,%rax
  803bf8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803bfc:	0f b7 c0             	movzwl %ax,%eax
}
  803bff:	c9                   	leaveq 
  803c00:	c3                   	retq   
