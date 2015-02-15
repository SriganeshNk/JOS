
obj/fs/fs:     file format elf64-x86-64


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
  80003c:	e8 33 2d 00 00       	callq  802d74 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	53                   	push   %rbx
  800049:	48 83 ec 18          	sub    $0x18,%rsp
  80004d:	89 f8                	mov    %edi,%eax
  80004f:	88 45 e4             	mov    %al,-0x1c(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800052:	c7 45 f0 f7 01 00 00 	movl   $0x1f7,-0x10(%rbp)

    static __inline uint8_t
inb(int port)
{
    uint8_t data;
    __asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800059:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80005c:	89 55 e0             	mov    %edx,-0x20(%rbp)
  80005f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800062:	ec                   	in     (%dx),%al
  800063:	89 c3                	mov    %eax,%ebx
  800065:	88 5d ef             	mov    %bl,-0x11(%rbp)
    return data;
  800068:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80006c:	0f b6 c0             	movzbl %al,%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800072:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800075:	25 c0 00 00 00       	and    $0xc0,%eax
  80007a:	83 f8 40             	cmp    $0x40,%eax
  80007d:	75 d3                	jne    800052 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80007f:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  800083:	74 11                	je     800096 <ide_wait_ready+0x52>
  800085:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800088:	83 e0 21             	and    $0x21,%eax
  80008b:	85 c0                	test   %eax,%eax
  80008d:	74 07                	je     800096 <ide_wait_ready+0x52>
		return -1;
  80008f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800094:	eb 05                	jmp    80009b <ide_wait_ready+0x57>
	return 0;
  800096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80009b:	48 83 c4 18          	add    $0x18,%rsp
  80009f:	5b                   	pop    %rbx
  8000a0:	5d                   	pop    %rbp
  8000a1:	c3                   	retq   

00000000008000a2 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  8000a2:	55                   	push   %rbp
  8000a3:	48 89 e5             	mov    %rsp,%rbp
  8000a6:	53                   	push   %rbx
  8000a7:	48 83 ec 38          	sub    $0x38,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  8000ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8000b0:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
  8000bc:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  8000c3:	c6 45 e3 f0          	movb   $0xf0,-0x1d(%rbp)
}

    static __inline void
outb(int port, uint8_t data)
{
    __asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000c7:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  8000cb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8000ce:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8000d6:	eb 04                	jmp    8000dc <ide_probe_disk1+0x3a>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000d8:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000dc:	81 7d ec e7 03 00 00 	cmpl   $0x3e7,-0x14(%rbp)
  8000e3:	7f 2c                	jg     800111 <ide_probe_disk1+0x6f>
  8000e5:	c7 45 dc f7 01 00 00 	movl   $0x1f7,-0x24(%rbp)

    static __inline uint8_t
inb(int port)
{
    uint8_t data;
    __asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000ec:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8000ef:	89 55 cc             	mov    %edx,-0x34(%rbp)
  8000f2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8000f5:	ec                   	in     (%dx),%al
  8000f6:	89 c3                	mov    %eax,%ebx
  8000f8:	88 5d db             	mov    %bl,-0x25(%rbp)
    return data;
  8000fb:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ff:	0f b6 c0             	movzbl %al,%eax
  800102:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800105:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800108:	25 a1 00 00 00       	and    $0xa1,%eax
  80010d:	85 c0                	test   %eax,%eax
  80010f:	75 c7                	jne    8000d8 <ide_probe_disk1+0x36>
  800111:	c7 45 d4 f6 01 00 00 	movl   $0x1f6,-0x2c(%rbp)
  800118:	c6 45 d3 e0          	movb   $0xe0,-0x2d(%rbp)
}

    static __inline void
outb(int port, uint8_t data)
{
    __asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80011c:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
  800120:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  800123:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800124:	81 7d ec e7 03 00 00 	cmpl   $0x3e7,-0x14(%rbp)
  80012b:	0f 9e c0             	setle  %al
  80012e:	0f b6 c0             	movzbl %al,%eax
  800131:	89 c6                	mov    %eax,%esi
  800133:	48 bf 60 69 80 00 00 	movabs $0x806960,%rdi
  80013a:	00 00 00 
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
  800142:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  800149:	00 00 00 
  80014c:	ff d2                	callq  *%rdx
	return (x < 1000);
  80014e:	81 7d ec e7 03 00 00 	cmpl   $0x3e7,-0x14(%rbp)
  800155:	0f 9e c0             	setle  %al
}
  800158:	48 83 c4 38          	add    $0x38,%rsp
  80015c:	5b                   	pop    %rbx
  80015d:	5d                   	pop    %rbp
  80015e:	c3                   	retq   

000000000080015f <ide_set_disk>:

void
ide_set_disk(int d)
{
  80015f:	55                   	push   %rbp
  800160:	48 89 e5             	mov    %rsp,%rbp
  800163:	48 83 ec 10          	sub    $0x10,%rsp
  800167:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  80016a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80016e:	74 30                	je     8001a0 <ide_set_disk+0x41>
  800170:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  800174:	74 2a                	je     8001a0 <ide_set_disk+0x41>
		panic("bad disk number");
  800176:	48 ba 77 69 80 00 00 	movabs $0x806977,%rdx
  80017d:	00 00 00 
  800180:	be 3a 00 00 00       	mov    $0x3a,%esi
  800185:	48 bf 87 69 80 00 00 	movabs $0x806987,%rdi
  80018c:	00 00 00 
  80018f:	b8 00 00 00 00       	mov    $0x0,%eax
  800194:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  80019b:	00 00 00 
  80019e:	ff d1                	callq  *%rcx
	diskno = d;
  8001a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8001a7:	00 00 00 
  8001aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001ad:	89 10                	mov    %edx,(%rax)
}
  8001af:	c9                   	leaveq 
  8001b0:	c3                   	retq   

00000000008001b1 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8001b1:	55                   	push   %rbp
  8001b2:	48 89 e5             	mov    %rsp,%rbp
  8001b5:	41 54                	push   %r12
  8001b7:	53                   	push   %rbx
  8001b8:	48 83 ec 70          	sub    $0x70,%rsp
  8001bc:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  8001bf:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
  8001c3:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
	int r;

	assert(nsecs <= 256);
  8001c7:	48 81 7d 88 00 01 00 	cmpq   $0x100,-0x78(%rbp)
  8001ce:	00 
  8001cf:	76 35                	jbe    800206 <ide_read+0x55>
  8001d1:	48 b9 90 69 80 00 00 	movabs $0x806990,%rcx
  8001d8:	00 00 00 
  8001db:	48 ba 9d 69 80 00 00 	movabs $0x80699d,%rdx
  8001e2:	00 00 00 
  8001e5:	be 43 00 00 00       	mov    $0x43,%esi
  8001ea:	48 bf 87 69 80 00 00 	movabs $0x806987,%rdi
  8001f1:	00 00 00 
  8001f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f9:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800200:	00 00 00 
  800203:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800206:	bf 00 00 00 00       	mov    $0x0,%edi
  80020b:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800212:	00 00 00 
  800215:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800217:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  80021b:	0f b6 c0             	movzbl %al,%eax
  80021e:	c7 45 e8 f2 01 00 00 	movl   $0x1f2,-0x18(%rbp)
  800225:	88 45 e7             	mov    %al,-0x19(%rbp)
  800228:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  80022c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80022f:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800230:	8b 45 9c             	mov    -0x64(%rbp),%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e0 f3 01 00 00 	movl   $0x1f3,-0x20(%rbp)
  80023d:	88 45 df             	mov    %al,-0x21(%rbp)
  800240:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800244:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  800248:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80024b:	c1 e8 08             	shr    $0x8,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 d8 f4 01 00 00 	movl   $0x1f4,-0x28(%rbp)
  800258:	88 45 d7             	mov    %al,-0x29(%rbp)
  80025b:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80025f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800263:	8b 45 9c             	mov    -0x64(%rbp),%eax
  800266:	c1 e8 10             	shr    $0x10,%eax
  800269:	0f b6 c0             	movzbl %al,%eax
  80026c:	c7 45 d0 f5 01 00 00 	movl   $0x1f5,-0x30(%rbp)
  800273:	88 45 cf             	mov    %al,-0x31(%rbp)
  800276:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  80027a:	8b 55 d0             	mov    -0x30(%rbp),%edx
  80027d:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80027e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800285:	00 00 00 
  800288:	8b 00                	mov    (%rax),%eax
  80028a:	83 e0 01             	and    $0x1,%eax
  80028d:	89 c2                	mov    %eax,%edx
  80028f:	c1 e2 04             	shl    $0x4,%edx
  800292:	8b 45 9c             	mov    -0x64(%rbp),%eax
  800295:	c1 e8 18             	shr    $0x18,%eax
  800298:	83 e0 0f             	and    $0xf,%eax
  80029b:	09 d0                	or     %edx,%eax
  80029d:	83 c8 e0             	or     $0xffffffe0,%eax
  8002a0:	0f b6 c0             	movzbl %al,%eax
  8002a3:	c7 45 c8 f6 01 00 00 	movl   $0x1f6,-0x38(%rbp)
  8002aa:	88 45 c7             	mov    %al,-0x39(%rbp)
  8002ad:	0f b6 45 c7          	movzbl -0x39(%rbp),%eax
  8002b1:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002b4:	ee                   	out    %al,(%dx)
  8002b5:	c7 45 c0 f7 01 00 00 	movl   $0x1f7,-0x40(%rbp)
  8002bc:	c6 45 bf 20          	movb   $0x20,-0x41(%rbp)
  8002c0:	0f b6 45 bf          	movzbl -0x41(%rbp),%eax
  8002c4:	8b 55 c0             	mov    -0x40(%rbp),%edx
  8002c7:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002c8:	eb 67                	jmp    800331 <ide_read+0x180>
		if ((r = ide_wait_ready(1)) < 0)
  8002ca:	bf 01 00 00 00       	mov    $0x1,%edi
  8002cf:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8002d6:	00 00 00 
  8002d9:	ff d0                	callq  *%rax
  8002db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8002de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8002e2:	79 05                	jns    8002e9 <ide_read+0x138>
			return r;
  8002e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002e7:	eb 54                	jmp    80033d <ide_read+0x18c>
  8002e9:	c7 45 b8 f0 01 00 00 	movl   $0x1f0,-0x48(%rbp)
  8002f0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8002f4:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8002f8:	c7 45 ac 80 00 00 00 	movl   $0x80,-0x54(%rbp)
}

    static __inline void
insl(int port, void *addr, int cnt)
{
    __asm __volatile("cld\n\trepne\n\tinsl"			:
  8002ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800302:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800306:	8b 55 ac             	mov    -0x54(%rbp),%edx
  800309:	49 89 cc             	mov    %rcx,%r12
  80030c:	89 d3                	mov    %edx,%ebx
  80030e:	4c 89 e7             	mov    %r12,%rdi
  800311:	89 d9                	mov    %ebx,%ecx
  800313:	89 c2                	mov    %eax,%edx
  800315:	fc                   	cld    
  800316:	f2 6d                	repnz insl (%dx),%es:(%rdi)
  800318:	89 cb                	mov    %ecx,%ebx
  80031a:	49 89 fc             	mov    %rdi,%r12
  80031d:	4c 89 65 b0          	mov    %r12,-0x50(%rbp)
  800321:	89 5d ac             	mov    %ebx,-0x54(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800324:	48 83 6d 88 01       	subq   $0x1,-0x78(%rbp)
  800329:	48 81 45 90 00 02 00 	addq   $0x200,-0x70(%rbp)
  800330:	00 
  800331:	48 83 7d 88 00       	cmpq   $0x0,-0x78(%rbp)
  800336:	75 92                	jne    8002ca <ide_read+0x119>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80033d:	48 83 c4 70          	add    $0x70,%rsp
  800341:	5b                   	pop    %rbx
  800342:	41 5c                	pop    %r12
  800344:	5d                   	pop    %rbp
  800345:	c3                   	retq   

0000000000800346 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800346:	55                   	push   %rbp
  800347:	48 89 e5             	mov    %rsp,%rbp
  80034a:	41 54                	push   %r12
  80034c:	53                   	push   %rbx
  80034d:	48 83 ec 70          	sub    $0x70,%rsp
  800351:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  800354:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
  800358:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
	int r;

	assert(nsecs <= 256);
  80035c:	48 81 7d 88 00 01 00 	cmpq   $0x100,-0x78(%rbp)
  800363:	00 
  800364:	76 35                	jbe    80039b <ide_write+0x55>
  800366:	48 b9 90 69 80 00 00 	movabs $0x806990,%rcx
  80036d:	00 00 00 
  800370:	48 ba 9d 69 80 00 00 	movabs $0x80699d,%rdx
  800377:	00 00 00 
  80037a:	be 5c 00 00 00       	mov    $0x5c,%esi
  80037f:	48 bf 87 69 80 00 00 	movabs $0x806987,%rdi
  800386:	00 00 00 
  800389:	b8 00 00 00 00       	mov    $0x0,%eax
  80038e:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800395:	00 00 00 
  800398:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  80039b:	bf 00 00 00 00       	mov    $0x0,%edi
  8003a0:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8003a7:	00 00 00 
  8003aa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8003ac:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8003b0:	0f b6 c0             	movzbl %al,%eax
  8003b3:	c7 45 e8 f2 01 00 00 	movl   $0x1f2,-0x18(%rbp)
  8003ba:	88 45 e7             	mov    %al,-0x19(%rbp)
}

    static __inline void
outb(int port, uint8_t data)
{
    __asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8003bd:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003c1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003c4:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  8003c5:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8003c8:	0f b6 c0             	movzbl %al,%eax
  8003cb:	c7 45 e0 f3 01 00 00 	movl   $0x1f3,-0x20(%rbp)
  8003d2:	88 45 df             	mov    %al,-0x21(%rbp)
  8003d5:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003d9:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003dc:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003dd:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8003e0:	c1 e8 08             	shr    $0x8,%eax
  8003e3:	0f b6 c0             	movzbl %al,%eax
  8003e6:	c7 45 d8 f4 01 00 00 	movl   $0x1f4,-0x28(%rbp)
  8003ed:	88 45 d7             	mov    %al,-0x29(%rbp)
  8003f0:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  8003f4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8003f7:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003f8:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8003fb:	c1 e8 10             	shr    $0x10,%eax
  8003fe:	0f b6 c0             	movzbl %al,%eax
  800401:	c7 45 d0 f5 01 00 00 	movl   $0x1f5,-0x30(%rbp)
  800408:	88 45 cf             	mov    %al,-0x31(%rbp)
  80040b:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  80040f:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800412:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800413:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80041a:	00 00 00 
  80041d:	8b 00                	mov    (%rax),%eax
  80041f:	83 e0 01             	and    $0x1,%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	c1 e2 04             	shl    $0x4,%edx
  800427:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80042a:	c1 e8 18             	shr    $0x18,%eax
  80042d:	83 e0 0f             	and    $0xf,%eax
  800430:	09 d0                	or     %edx,%eax
  800432:	83 c8 e0             	or     $0xffffffe0,%eax
  800435:	0f b6 c0             	movzbl %al,%eax
  800438:	c7 45 c8 f6 01 00 00 	movl   $0x1f6,-0x38(%rbp)
  80043f:	88 45 c7             	mov    %al,-0x39(%rbp)
  800442:	0f b6 45 c7          	movzbl -0x39(%rbp),%eax
  800446:	8b 55 c8             	mov    -0x38(%rbp),%edx
  800449:	ee                   	out    %al,(%dx)
  80044a:	c7 45 c0 f7 01 00 00 	movl   $0x1f7,-0x40(%rbp)
  800451:	c6 45 bf 30          	movb   $0x30,-0x41(%rbp)
  800455:	0f b6 45 bf          	movzbl -0x41(%rbp),%eax
  800459:	8b 55 c0             	mov    -0x40(%rbp),%edx
  80045c:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80045d:	eb 67                	jmp    8004c6 <ide_write+0x180>
		if ((r = ide_wait_ready(1)) < 0)
  80045f:	bf 01 00 00 00       	mov    $0x1,%edi
  800464:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80046b:	00 00 00 
  80046e:	ff d0                	callq  *%rax
  800470:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800473:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800477:	79 05                	jns    80047e <ide_write+0x138>
			return r;
  800479:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80047c:	eb 54                	jmp    8004d2 <ide_write+0x18c>
  80047e:	c7 45 b8 f0 01 00 00 	movl   $0x1f0,-0x48(%rbp)
  800485:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800489:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  80048d:	c7 45 ac 80 00 00 00 	movl   $0x80,-0x54(%rbp)
}

    static __inline void
outsl(int port, const void *addr, int cnt)
{
    __asm __volatile("cld\n\trepne\n\toutsl"		:
  800494:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800497:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  80049b:	8b 55 ac             	mov    -0x54(%rbp),%edx
  80049e:	49 89 cc             	mov    %rcx,%r12
  8004a1:	89 d3                	mov    %edx,%ebx
  8004a3:	4c 89 e6             	mov    %r12,%rsi
  8004a6:	89 d9                	mov    %ebx,%ecx
  8004a8:	89 c2                	mov    %eax,%edx
  8004aa:	fc                   	cld    
  8004ab:	f2 6f                	repnz outsl %ds:(%rsi),(%dx)
  8004ad:	89 cb                	mov    %ecx,%ebx
  8004af:	49 89 f4             	mov    %rsi,%r12
  8004b2:	4c 89 65 b0          	mov    %r12,-0x50(%rbp)
  8004b6:	89 5d ac             	mov    %ebx,-0x54(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8004b9:	48 83 6d 88 01       	subq   $0x1,-0x78(%rbp)
  8004be:	48 81 45 90 00 02 00 	addq   $0x200,-0x70(%rbp)
  8004c5:	00 
  8004c6:	48 83 7d 88 00       	cmpq   $0x0,-0x78(%rbp)
  8004cb:	75 92                	jne    80045f <ide_write+0x119>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  8004cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004d2:	48 83 c4 70          	add    $0x70,%rsp
  8004d6:	5b                   	pop    %rbx
  8004d7:	41 5c                	pop    %r12
  8004d9:	5d                   	pop    %rbp
  8004da:	c3                   	retq   
	...

00000000008004dc <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004dc:	55                   	push   %rbp
  8004dd:	48 89 e5             	mov    %rsp,%rbp
  8004e0:	48 83 ec 10          	sub    $0x10,%rsp
  8004e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004e8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004ed:	74 2a                	je     800519 <diskaddr+0x3d>
  8004ef:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004f6:	00 00 00 
  8004f9:	48 8b 00             	mov    (%rax),%rax
  8004fc:	48 85 c0             	test   %rax,%rax
  8004ff:	74 4a                	je     80054b <diskaddr+0x6f>
  800501:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800508:	00 00 00 
  80050b:	48 8b 00             	mov    (%rax),%rax
  80050e:	8b 40 04             	mov    0x4(%rax),%eax
  800511:	89 c0                	mov    %eax,%eax
  800513:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800517:	77 32                	ja     80054b <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  800519:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80051d:	48 89 c1             	mov    %rax,%rcx
  800520:	48 ba b8 69 80 00 00 	movabs $0x8069b8,%rdx
  800527:	00 00 00 
  80052a:	be 09 00 00 00       	mov    $0x9,%esi
  80052f:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  800536:	00 00 00 
  800539:	b8 00 00 00 00       	mov    $0x0,%eax
  80053e:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800545:	00 00 00 
  800548:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  80054b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80054f:	48 05 00 00 01 00    	add    $0x10000,%rax
  800555:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800559:	c9                   	leaveq 
  80055a:	c3                   	retq   

000000000080055b <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  80055b:	55                   	push   %rbp
  80055c:	48 89 e5             	mov    %rsp,%rbp
  80055f:	48 83 ec 08          	sub    $0x8,%rsp
  800563:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  800567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80056b:	48 89 c2             	mov    %rax,%rdx
  80056e:	48 c1 ea 27          	shr    $0x27,%rdx
  800572:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  800579:	01 00 00 
  80057c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800580:	83 e0 01             	and    $0x1,%eax
  800583:	84 c0                	test   %al,%al
  800585:	74 67                	je     8005ee <va_is_mapped+0x93>
  800587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80058b:	48 89 c2             	mov    %rax,%rdx
  80058e:	48 c1 ea 1e          	shr    $0x1e,%rdx
  800592:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  800599:	01 00 00 
  80059c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005a0:	83 e0 01             	and    $0x1,%eax
  8005a3:	84 c0                	test   %al,%al
  8005a5:	74 47                	je     8005ee <va_is_mapped+0x93>
  8005a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ab:	48 89 c2             	mov    %rax,%rdx
  8005ae:	48 c1 ea 15          	shr    $0x15,%rdx
  8005b2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005b9:	01 00 00 
  8005bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005c0:	83 e0 01             	and    $0x1,%eax
  8005c3:	84 c0                	test   %al,%al
  8005c5:	74 27                	je     8005ee <va_is_mapped+0x93>
  8005c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005cb:	48 89 c2             	mov    %rax,%rdx
  8005ce:	48 c1 ea 0c          	shr    $0xc,%rdx
  8005d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005d9:	01 00 00 
  8005dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e0:	83 e0 01             	and    $0x1,%eax
  8005e3:	84 c0                	test   %al,%al
  8005e5:	74 07                	je     8005ee <va_is_mapped+0x93>
  8005e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8005ec:	eb 05                	jmp    8005f3 <va_is_mapped+0x98>
  8005ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8005f3:	c9                   	leaveq 
  8005f4:	c3                   	retq   

00000000008005f5 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005f5:	55                   	push   %rbp
  8005f6:	48 89 e5             	mov    %rsp,%rbp
  8005f9:	48 83 ec 08          	sub    $0x8,%rsp
  8005fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  800601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800605:	48 89 c2             	mov    %rax,%rdx
  800608:	48 c1 ea 0c          	shr    $0xc,%rdx
  80060c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800613:	01 00 00 
  800616:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80061a:	83 e0 40             	and    $0x40,%eax
  80061d:	48 85 c0             	test   %rax,%rax
  800620:	0f 95 c0             	setne  %al
}
  800623:	c9                   	leaveq 
  800624:	c3                   	retq   

0000000000800625 <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800625:	55                   	push   %rbp
  800626:	48 89 e5             	mov    %rsp,%rbp
  800629:	48 83 ec 50          	sub    $0x50,%rsp
  80062d:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  800631:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800635:	48 8b 00             	mov    (%rax),%rax
  800638:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80063c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800640:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800646:	48 c1 e8 0c          	shr    $0xc,%rax
  80064a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80064e:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800655:	0f 
  800656:	76 0b                	jbe    800663 <bc_pgfault+0x3e>
  800658:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80065d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  800661:	76 4b                	jbe    8006ae <bc_pgfault+0x89>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800663:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800667:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80066b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80066f:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800676:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80067a:	49 89 c9             	mov    %rcx,%r9
  80067d:	49 89 d0             	mov    %rdx,%r8
  800680:	48 89 c1             	mov    %rax,%rcx
  800683:	48 ba e8 69 80 00 00 	movabs $0x8069e8,%rdx
  80068a:	00 00 00 
  80068d:	be 27 00 00 00       	mov    $0x27,%esi
  800692:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  800699:	00 00 00 
  80069c:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a1:	49 ba 40 2e 80 00 00 	movabs $0x802e40,%r10
  8006a8:	00 00 00 
  8006ab:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8006ae:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8006b5:	00 00 00 
  8006b8:	48 8b 00             	mov    (%rax),%rax
  8006bb:	48 85 c0             	test   %rax,%rax
  8006be:	74 4a                	je     80070a <bc_pgfault+0xe5>
  8006c0:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8006c7:	00 00 00 
  8006ca:	48 8b 00             	mov    (%rax),%rax
  8006cd:	8b 40 04             	mov    0x4(%rax),%eax
  8006d0:	89 c0                	mov    %eax,%eax
  8006d2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006d6:	77 32                	ja     80070a <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006dc:	48 89 c1             	mov    %rax,%rcx
  8006df:	48 ba 18 6a 80 00 00 	movabs $0x806a18,%rdx
  8006e6:	00 00 00 
  8006e9:	be 2b 00 00 00       	mov    $0x2b,%esi
  8006ee:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  8006f5:	00 00 00 
  8006f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fd:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800704:	00 00 00 
  800707:	41 ff d0             	callq  *%r8
	// the reader: why do we do this *after* reading the block
	// in?)
	// if (bitmap && block_is_free(blockno))
	//	panic("reading free block %08x\n", blockno);
	// LAB 5: you code here:
	void *new_addr = ROUNDDOWN(addr, PGSIZE);
  80070a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80070e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800716:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80071c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	r = sys_page_alloc(0, new_addr, PTE_P|PTE_W|PTE_U);
  800720:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800724:	ba 07 00 00 00       	mov    $0x7,%edx
  800729:	48 89 c6             	mov    %rax,%rsi
  80072c:	bf 00 00 00 00       	mov    $0x0,%edi
  800731:	48 b8 84 45 80 00 00 	movabs $0x804584,%rax
  800738:	00 00 00 
  80073b:	ff d0                	callq  *%rax
  80073d:	89 45 dc             	mov    %eax,-0x24(%rbp)
	if(r<0)
  800740:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800744:	79 30                	jns    800776 <bc_pgfault+0x151>
		panic("Something wrong with allocation %e",r);
  800746:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800749:	89 c1                	mov    %eax,%ecx
  80074b:	48 ba 40 6a 80 00 00 	movabs $0x806a40,%rdx
  800752:	00 00 00 
  800755:	be 3c 00 00 00       	mov    $0x3c,%esi
  80075a:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  800761:	00 00 00 
  800764:	b8 00 00 00 00       	mov    $0x0,%eax
  800769:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800770:	00 00 00 
  800773:	41 ff d0             	callq  *%r8
	uint64_t sec_no = BLKSECTS * blockno;
  800776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80077a:	48 c1 e0 03          	shl    $0x3,%rax
  80077e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	size_t nsecs = BLKSECTS;
  800782:	48 c7 45 c8 08 00 00 	movq   $0x8,-0x38(%rbp)
  800789:	00 
	r = ide_read(sec_no, new_addr, nsecs);
  80078a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80078e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800792:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800796:	48 89 ce             	mov    %rcx,%rsi
  800799:	89 c7                	mov    %eax,%edi
  80079b:	48 b8 b1 01 80 00 00 	movabs $0x8001b1,%rax
  8007a2:	00 00 00 
  8007a5:	ff d0                	callq  *%rax
  8007a7:	89 45 dc             	mov    %eax,-0x24(%rbp)
	if(r<0)
  8007aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007ae:	79 30                	jns    8007e0 <bc_pgfault+0x1bb>
		panic("Something wrong with reading from the disk %e",r);
  8007b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8007b3:	89 c1                	mov    %eax,%ecx
  8007b5:	48 ba 68 6a 80 00 00 	movabs $0x806a68,%rdx
  8007bc:	00 00 00 
  8007bf:	be 41 00 00 00       	mov    $0x41,%esi
  8007c4:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  8007cb:	00 00 00 
  8007ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d3:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  8007da:	00 00 00 
  8007dd:	41 ff d0             	callq  *%r8
}
  8007e0:	c9                   	leaveq 
  8007e1:	c3                   	retq   

00000000008007e2 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  8007e2:	55                   	push   %rbp
  8007e3:	48 89 e5             	mov    %rsp,%rbp
  8007e6:	48 83 ec 20          	sub    $0x20,%rsp
  8007ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  8007f8:	48 c1 e8 0c          	shr    $0xc,%rax
  8007fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800800:	48 81 7d e8 ff ff ff 	cmpq   $0xfffffff,-0x18(%rbp)
  800807:	0f 
  800808:	76 0b                	jbe    800815 <flush_block+0x33>
  80080a:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80080f:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  800813:	76 32                	jbe    800847 <flush_block+0x65>
		panic("flush_block of bad va %08x", addr);
  800815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800819:	48 89 c1             	mov    %rax,%rcx
  80081c:	48 ba 96 6a 80 00 00 	movabs $0x806a96,%rdx
  800823:	00 00 00 
  800826:	be 51 00 00 00       	mov    $0x51,%esi
  80082b:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  800832:	00 00 00 
  800835:	b8 00 00 00 00       	mov    $0x0,%eax
  80083a:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800841:	00 00 00 
  800844:	41 ff d0             	callq  *%r8

	// LAB 5: Your code here.
	//panic("flush_block not implemented");
}
  800847:	c9                   	leaveq 
  800848:	c3                   	retq   

0000000000800849 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  800849:	55                   	push   %rbp
  80084a:	48 89 e5             	mov    %rsp,%rbp
  80084d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800854:	bf 01 00 00 00       	mov    $0x1,%edi
  800859:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800860:	00 00 00 
  800863:	ff d0                	callq  *%rax
  800865:	48 89 c1             	mov    %rax,%rcx
  800868:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80086f:	ba 08 01 00 00       	mov    $0x108,%edx
  800874:	48 89 ce             	mov    %rcx,%rsi
  800877:	48 89 c7             	mov    %rax,%rdi
  80087a:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  800881:	00 00 00 
  800884:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800886:	bf 01 00 00 00       	mov    $0x1,%edi
  80088b:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800892:	00 00 00 
  800895:	ff d0                	callq  *%rax
  800897:	48 be b1 6a 80 00 00 	movabs $0x806ab1,%rsi
  80089e:	00 00 00 
  8008a1:	48 89 c7             	mov    %rax,%rdi
  8008a4:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  8008ab:	00 00 00 
  8008ae:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  8008b0:	bf 01 00 00 00       	mov    $0x1,%edi
  8008b5:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8008bc:	00 00 00 
  8008bf:	ff d0                	callq  *%rax
  8008c1:	48 89 c7             	mov    %rax,%rdi
  8008c4:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  8008cb:	00 00 00 
  8008ce:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  8008d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8008d5:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8008dc:	00 00 00 
  8008df:	ff d0                	callq  *%rax
  8008e1:	48 89 c7             	mov    %rax,%rdi
  8008e4:	48 b8 5b 05 80 00 00 	movabs $0x80055b,%rax
  8008eb:	00 00 00 
  8008ee:	ff d0                	callq  *%rax
  8008f0:	83 f0 01             	xor    $0x1,%eax
  8008f3:	84 c0                	test   %al,%al
  8008f5:	74 35                	je     80092c <check_bc+0xe3>
  8008f7:	48 b9 b8 6a 80 00 00 	movabs $0x806ab8,%rcx
  8008fe:	00 00 00 
  800901:	48 ba d2 6a 80 00 00 	movabs $0x806ad2,%rdx
  800908:	00 00 00 
  80090b:	be 64 00 00 00       	mov    $0x64,%esi
  800910:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  800917:	00 00 00 
  80091a:	b8 00 00 00 00       	mov    $0x0,%eax
  80091f:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800926:	00 00 00 
  800929:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  80092c:	bf 01 00 00 00       	mov    $0x1,%edi
  800931:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800938:	00 00 00 
  80093b:	ff d0                	callq  *%rax
  80093d:	48 89 c7             	mov    %rax,%rdi
  800940:	48 b8 f5 05 80 00 00 	movabs $0x8005f5,%rax
  800947:	00 00 00 
  80094a:	ff d0                	callq  *%rax
  80094c:	84 c0                	test   %al,%al
  80094e:	74 35                	je     800985 <check_bc+0x13c>
  800950:	48 b9 e7 6a 80 00 00 	movabs $0x806ae7,%rcx
  800957:	00 00 00 
  80095a:	48 ba d2 6a 80 00 00 	movabs $0x806ad2,%rdx
  800961:	00 00 00 
  800964:	be 65 00 00 00       	mov    $0x65,%esi
  800969:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  800970:	00 00 00 
  800973:	b8 00 00 00 00       	mov    $0x0,%eax
  800978:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  80097f:	00 00 00 
  800982:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800985:	bf 01 00 00 00       	mov    $0x1,%edi
  80098a:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800991:	00 00 00 
  800994:	ff d0                	callq  *%rax
  800996:	48 89 c6             	mov    %rax,%rsi
  800999:	bf 00 00 00 00       	mov    $0x0,%edi
  80099e:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  8009a5:	00 00 00 
  8009a8:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  8009aa:	bf 01 00 00 00       	mov    $0x1,%edi
  8009af:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8009b6:	00 00 00 
  8009b9:	ff d0                	callq  *%rax
  8009bb:	48 89 c7             	mov    %rax,%rdi
  8009be:	48 b8 5b 05 80 00 00 	movabs $0x80055b,%rax
  8009c5:	00 00 00 
  8009c8:	ff d0                	callq  *%rax
  8009ca:	84 c0                	test   %al,%al
  8009cc:	74 35                	je     800a03 <check_bc+0x1ba>
  8009ce:	48 b9 01 6b 80 00 00 	movabs $0x806b01,%rcx
  8009d5:	00 00 00 
  8009d8:	48 ba d2 6a 80 00 00 	movabs $0x806ad2,%rdx
  8009df:	00 00 00 
  8009e2:	be 69 00 00 00       	mov    $0x69,%esi
  8009e7:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  8009ee:	00 00 00 
  8009f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f6:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  8009fd:	00 00 00 
  800a00:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800a03:	bf 01 00 00 00       	mov    $0x1,%edi
  800a08:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800a0f:	00 00 00 
  800a12:	ff d0                	callq  *%rax
  800a14:	48 be b1 6a 80 00 00 	movabs $0x806ab1,%rsi
  800a1b:	00 00 00 
  800a1e:	48 89 c7             	mov    %rax,%rdi
  800a21:	48 b8 a7 3d 80 00 00 	movabs $0x803da7,%rax
  800a28:	00 00 00 
  800a2b:	ff d0                	callq  *%rax
  800a2d:	85 c0                	test   %eax,%eax
  800a2f:	74 35                	je     800a66 <check_bc+0x21d>
  800a31:	48 b9 20 6b 80 00 00 	movabs $0x806b20,%rcx
  800a38:	00 00 00 
  800a3b:	48 ba d2 6a 80 00 00 	movabs $0x806ad2,%rdx
  800a42:	00 00 00 
  800a45:	be 6c 00 00 00       	mov    $0x6c,%esi
  800a4a:	48 bf da 69 80 00 00 	movabs $0x8069da,%rdi
  800a51:	00 00 00 
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
  800a59:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800a60:	00 00 00 
  800a63:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800a66:	bf 01 00 00 00       	mov    $0x1,%edi
  800a6b:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800a72:	00 00 00 
  800a75:	ff d0                	callq  *%rax
  800a77:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800a7e:	ba 08 01 00 00       	mov    $0x108,%edx
  800a83:	48 89 ce             	mov    %rcx,%rsi
  800a86:	48 89 c7             	mov    %rax,%rdi
  800a89:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  800a90:	00 00 00 
  800a93:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800a95:	bf 01 00 00 00       	mov    $0x1,%edi
  800a9a:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800aa1:	00 00 00 
  800aa4:	ff d0                	callq  *%rax
  800aa6:	48 89 c7             	mov    %rax,%rdi
  800aa9:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  800ab0:	00 00 00 
  800ab3:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800ab5:	48 bf 44 6b 80 00 00 	movabs $0x806b44,%rdi
  800abc:	00 00 00 
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac4:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  800acb:	00 00 00 
  800ace:	ff d2                	callq  *%rdx
}
  800ad0:	c9                   	leaveq 
  800ad1:	c3                   	retq   

0000000000800ad2 <bc_init>:

void
bc_init(void)
{
  800ad2:	55                   	push   %rbp
  800ad3:	48 89 e5             	mov    %rsp,%rbp
  800ad6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800add:	48 bf 25 06 80 00 00 	movabs $0x800625,%rdi
  800ae4:	00 00 00 
  800ae7:	48 b8 d4 48 80 00 00 	movabs $0x8048d4,%rax
  800aee:	00 00 00 
  800af1:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800af3:	bf 01 00 00 00       	mov    $0x1,%edi
  800af8:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800aff:	00 00 00 
  800b02:	ff d0                	callq  *%rax
  800b04:	48 89 c1             	mov    %rax,%rcx
  800b07:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800b0e:	ba 08 01 00 00       	mov    $0x108,%edx
  800b13:	48 89 ce             	mov    %rcx,%rsi
  800b16:	48 89 c7             	mov    %rax,%rdi
  800b19:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  800b20:	00 00 00 
  800b23:	ff d0                	callq  *%rax
}
  800b25:	c9                   	leaveq 
  800b26:	c3                   	retq   
	...

0000000000800b28 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800b28:	55                   	push   %rbp
  800b29:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800b2c:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800b33:	00 00 00 
  800b36:	48 8b 00             	mov    (%rax),%rax
  800b39:	8b 00                	mov    (%rax),%eax
  800b3b:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800b40:	74 2a                	je     800b6c <check_super+0x44>
		panic("bad file system magic number");
  800b42:	48 ba 59 6b 80 00 00 	movabs $0x806b59,%rdx
  800b49:	00 00 00 
  800b4c:	be 0e 00 00 00       	mov    $0xe,%esi
  800b51:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  800b58:	00 00 00 
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b60:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  800b67:	00 00 00 
  800b6a:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800b6c:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800b73:	00 00 00 
  800b76:	48 8b 00             	mov    (%rax),%rax
  800b79:	8b 40 04             	mov    0x4(%rax),%eax
  800b7c:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800b81:	76 2a                	jbe    800bad <check_super+0x85>
		panic("file system is too large");
  800b83:	48 ba 7e 6b 80 00 00 	movabs $0x806b7e,%rdx
  800b8a:	00 00 00 
  800b8d:	be 11 00 00 00       	mov    $0x11,%esi
  800b92:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  800b99:	00 00 00 
  800b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba1:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  800ba8:	00 00 00 
  800bab:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800bad:	48 bf 97 6b 80 00 00 	movabs $0x806b97,%rdi
  800bb4:	00 00 00 
  800bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbc:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  800bc3:	00 00 00 
  800bc6:	ff d2                	callq  *%rdx
}
  800bc8:	5d                   	pop    %rbp
  800bc9:	c3                   	retq   

0000000000800bca <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800bca:	55                   	push   %rbp
  800bcb:	48 89 e5             	mov    %rsp,%rbp
  800bce:	53                   	push   %rbx
  800bcf:	48 83 ec 08          	sub    $0x8,%rsp
  800bd3:	89 7d f4             	mov    %edi,-0xc(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800bd6:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800bdd:	00 00 00 
  800be0:	48 8b 00             	mov    (%rax),%rax
  800be3:	48 85 c0             	test   %rax,%rax
  800be6:	74 15                	je     800bfd <block_is_free+0x33>
  800be8:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800bef:	00 00 00 
  800bf2:	48 8b 00             	mov    (%rax),%rax
  800bf5:	8b 40 04             	mov    0x4(%rax),%eax
  800bf8:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800bfb:	77 07                	ja     800c04 <block_is_free+0x3a>
		return 0;
  800bfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800c02:	eb 43                	jmp    800c47 <block_is_free+0x7d>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800c04:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800c0b:	00 00 00 
  800c0e:	48 8b 00             	mov    (%rax),%rax
  800c11:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800c14:	c1 ea 05             	shr    $0x5,%edx
  800c17:	89 d2                	mov    %edx,%edx
  800c19:	48 c1 e2 02          	shl    $0x2,%rdx
  800c1d:	48 01 d0             	add    %rdx,%rax
  800c20:	8b 10                	mov    (%rax),%edx
  800c22:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800c25:	83 e0 1f             	and    $0x1f,%eax
  800c28:	be 01 00 00 00       	mov    $0x1,%esi
  800c2d:	89 f3                	mov    %esi,%ebx
  800c2f:	89 c1                	mov    %eax,%ecx
  800c31:	d3 e3                	shl    %cl,%ebx
  800c33:	89 d8                	mov    %ebx,%eax
  800c35:	21 d0                	and    %edx,%eax
  800c37:	85 c0                	test   %eax,%eax
  800c39:	74 07                	je     800c42 <block_is_free+0x78>
		return 1;
  800c3b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c40:	eb 05                	jmp    800c47 <block_is_free+0x7d>
	return 0;
  800c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c47:	48 83 c4 08          	add    $0x8,%rsp
  800c4b:	5b                   	pop    %rbx
  800c4c:	5d                   	pop    %rbp
  800c4d:	c3                   	retq   

0000000000800c4e <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800c4e:	55                   	push   %rbp
  800c4f:	48 89 e5             	mov    %rsp,%rbp
  800c52:	53                   	push   %rbx
  800c53:	48 83 ec 18          	sub    $0x18,%rsp
  800c57:	89 7d ec             	mov    %edi,-0x14(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800c5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800c5e:	75 2a                	jne    800c8a <free_block+0x3c>
		panic("attempt to free zero block");
  800c60:	48 ba ab 6b 80 00 00 	movabs $0x806bab,%rdx
  800c67:	00 00 00 
  800c6a:	be 2c 00 00 00       	mov    $0x2c,%esi
  800c6f:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  800c76:	00 00 00 
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7e:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  800c85:	00 00 00 
  800c88:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800c8a:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800c91:	00 00 00 
  800c94:	48 8b 10             	mov    (%rax),%rdx
  800c97:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c9a:	c1 e8 05             	shr    $0x5,%eax
  800c9d:	89 c1                	mov    %eax,%ecx
  800c9f:	48 c1 e1 02          	shl    $0x2,%rcx
  800ca3:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800ca7:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800cae:	00 00 00 
  800cb1:	48 8b 12             	mov    (%rdx),%rdx
  800cb4:	89 c0                	mov    %eax,%eax
  800cb6:	48 c1 e0 02          	shl    $0x2,%rax
  800cba:	48 01 d0             	add    %rdx,%rax
  800cbd:	8b 10                	mov    (%rax),%edx
  800cbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cc2:	83 e0 1f             	and    $0x1f,%eax
  800cc5:	bf 01 00 00 00       	mov    $0x1,%edi
  800cca:	89 fb                	mov    %edi,%ebx
  800ccc:	89 c1                	mov    %eax,%ecx
  800cce:	d3 e3                	shl    %cl,%ebx
  800cd0:	89 d8                	mov    %ebx,%eax
  800cd2:	09 d0                	or     %edx,%eax
  800cd4:	89 06                	mov    %eax,(%rsi)
}
  800cd6:	48 83 c4 18          	add    $0x18,%rsp
  800cda:	5b                   	pop    %rbx
  800cdb:	5d                   	pop    %rbp
  800cdc:	c3                   	retq   

0000000000800cdd <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800cdd:	55                   	push   %rbp
  800cde:	48 89 e5             	mov    %rsp,%rbp
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	panic("alloc_block not implemented");
  800ce1:	48 ba c6 6b 80 00 00 	movabs $0x806bc6,%rdx
  800ce8:	00 00 00 
  800ceb:	be 40 00 00 00       	mov    $0x40,%esi
  800cf0:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  800cf7:	00 00 00 
  800cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800cff:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  800d06:	00 00 00 
  800d09:	ff d1                	callq  *%rcx

0000000000800d0b <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800d0b:	55                   	push   %rbp
  800d0c:	48 89 e5             	mov    %rsp,%rbp
  800d0f:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800d13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800d1a:	eb 51                	jmp    800d6d <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d1f:	83 c0 02             	add    $0x2,%eax
  800d22:	89 c7                	mov    %eax,%edi
  800d24:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  800d2b:	00 00 00 
  800d2e:	ff d0                	callq  *%rax
  800d30:	84 c0                	test   %al,%al
  800d32:	74 35                	je     800d69 <check_bitmap+0x5e>
  800d34:	48 b9 e2 6b 80 00 00 	movabs $0x806be2,%rcx
  800d3b:	00 00 00 
  800d3e:	48 ba f6 6b 80 00 00 	movabs $0x806bf6,%rdx
  800d45:	00 00 00 
  800d48:	be 4f 00 00 00       	mov    $0x4f,%esi
  800d4d:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  800d54:	00 00 00 
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5c:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800d63:	00 00 00 
  800d66:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800d69:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800d6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d70:	89 c2                	mov    %eax,%edx
  800d72:	c1 e2 0f             	shl    $0xf,%edx
  800d75:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d7c:	00 00 00 
  800d7f:	48 8b 00             	mov    (%rax),%rax
  800d82:	8b 40 04             	mov    0x4(%rax),%eax
  800d85:	39 c2                	cmp    %eax,%edx
  800d87:	72 93                	jb     800d1c <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800d89:	bf 00 00 00 00       	mov    $0x0,%edi
  800d8e:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  800d95:	00 00 00 
  800d98:	ff d0                	callq  *%rax
  800d9a:	84 c0                	test   %al,%al
  800d9c:	74 35                	je     800dd3 <check_bitmap+0xc8>
  800d9e:	48 b9 0b 6c 80 00 00 	movabs $0x806c0b,%rcx
  800da5:	00 00 00 
  800da8:	48 ba f6 6b 80 00 00 	movabs $0x806bf6,%rdx
  800daf:	00 00 00 
  800db2:	be 52 00 00 00       	mov    $0x52,%esi
  800db7:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  800dbe:	00 00 00 
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc6:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800dcd:	00 00 00 
  800dd0:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  800dd3:	bf 01 00 00 00       	mov    $0x1,%edi
  800dd8:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  800ddf:	00 00 00 
  800de2:	ff d0                	callq  *%rax
  800de4:	84 c0                	test   %al,%al
  800de6:	74 35                	je     800e1d <check_bitmap+0x112>
  800de8:	48 b9 1d 6c 80 00 00 	movabs $0x806c1d,%rcx
  800def:	00 00 00 
  800df2:	48 ba f6 6b 80 00 00 	movabs $0x806bf6,%rdx
  800df9:	00 00 00 
  800dfc:	be 53 00 00 00       	mov    $0x53,%esi
  800e01:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  800e08:	00 00 00 
  800e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e10:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  800e17:	00 00 00 
  800e1a:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  800e1d:	48 bf 2f 6c 80 00 00 	movabs $0x806c2f,%rdi
  800e24:	00 00 00 
  800e27:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2c:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  800e33:	00 00 00 
  800e36:	ff d2                	callq  *%rdx
}
  800e38:	c9                   	leaveq 
  800e39:	c3                   	retq   

0000000000800e3a <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  800e3a:	55                   	push   %rbp
  800e3b:	48 89 e5             	mov    %rsp,%rbp
	static_assert(sizeof(struct File) == 256);

#ifndef VMM_GUEST
	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  800e3e:	48 b8 a2 00 80 00 00 	movabs $0x8000a2,%rax
  800e45:	00 00 00 
  800e48:	ff d0                	callq  *%rax
  800e4a:	84 c0                	test   %al,%al
  800e4c:	74 13                	je     800e61 <fs_init+0x27>
		ide_set_disk(1);
  800e4e:	bf 01 00 00 00       	mov    $0x1,%edi
  800e53:	48 b8 5f 01 80 00 00 	movabs $0x80015f,%rax
  800e5a:	00 00 00 
  800e5d:	ff d0                	callq  *%rax
  800e5f:	eb 11                	jmp    800e72 <fs_init+0x38>
	else
		ide_set_disk(0);
  800e61:	bf 00 00 00 00       	mov    $0x0,%edi
  800e66:	48 b8 5f 01 80 00 00 	movabs $0x80015f,%rax
  800e6d:	00 00 00 
  800e70:	ff d0                	callq  *%rax
#else
	host_ipc_init();
#endif
	bc_init();
  800e72:	48 b8 d2 0a 80 00 00 	movabs $0x800ad2,%rax
  800e79:	00 00 00 
  800e7c:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  800e7e:	bf 01 00 00 00       	mov    $0x1,%edi
  800e83:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800e8a:	00 00 00 
  800e8d:	ff d0                	callq  *%rax
  800e8f:	48 ba 10 20 81 00 00 	movabs $0x812010,%rdx
  800e96:	00 00 00 
  800e99:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  800e9c:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  800ea3:	00 00 00 
  800ea6:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  800ea8:	bf 02 00 00 00       	mov    $0x2,%edi
  800ead:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
  800eb9:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800ec0:	00 00 00 
  800ec3:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  800ec6:	48 b8 0b 0d 80 00 00 	movabs $0x800d0b,%rax
  800ecd:	00 00 00 
  800ed0:	ff d0                	callq  *%rax
}
  800ed2:	5d                   	pop    %rbp
  800ed3:	c3                   	retq   

0000000000800ed4 <file_block_walk>:
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.

static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800ed4:	55                   	push   %rbp
  800ed5:	48 89 e5             	mov    %rsp,%rbp
  800ed8:	48 83 ec 30          	sub    $0x30,%rsp
  800edc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ee0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800ee3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800ee7:	89 c8                	mov    %ecx,%eax
  800ee9:	88 45 e0             	mov    %al,-0x20(%rbp)
	if (filebno >= NDIRECT + NINDIRECT) {
  800eec:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  800ef3:	76 0a                	jbe    800eff <file_block_walk+0x2b>
		return -E_INVAL;
  800ef5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800efa:	e9 a6 00 00 00       	jmpq   800fa5 <file_block_walk+0xd1>
	}
	uint32_t nblock = f->f_size / BLKSIZE;
  800eff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f03:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  800f09:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	0f 48 c2             	cmovs  %edx,%eax
  800f14:	c1 f8 0c             	sar    $0xc,%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (filebno > nblock) {
  800f1a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800f1d:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800f20:	76 07                	jbe    800f29 <file_block_walk+0x55>
		return -E_NOT_FOUND;
  800f22:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800f27:	eb 7c                	jmp    800fa5 <file_block_walk+0xd1>
	}
	if (filebno < NDIRECT) {
  800f29:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  800f2d:	77 23                	ja     800f52 <file_block_walk+0x7e>
		*ppdiskbno = &f->f_direct[filebno];
  800f2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f33:	48 8d 90 88 00 00 00 	lea    0x88(%rax),%rdx
  800f3a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800f3d:	48 c1 e0 02          	shl    $0x2,%rax
  800f41:	48 01 c2             	add    %rax,%rdx
  800f44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f48:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  800f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f50:	eb 53                	jmp    800fa5 <file_block_walk+0xd1>
	}
	else {
		if(!f->f_indirect) {
  800f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f56:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 07                	jne    800f67 <file_block_walk+0x93>
			return -E_NOT_FOUND;
  800f60:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800f65:	eb 3e                	jmp    800fa5 <file_block_walk+0xd1>
		}
		uint32_t* index = (uint32_t*)diskaddr(f->f_indirect);
  800f67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6b:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  800f71:	89 c0                	mov    %eax,%eax
  800f73:	48 89 c7             	mov    %rax,%rdi
  800f76:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800f7d:	00 00 00 
  800f80:	ff d0                	callq  *%rax
  800f82:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		*ppdiskbno = &index[filebno - NDIRECT] ;
  800f86:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800f89:	83 e8 0a             	sub    $0xa,%eax
  800f8c:	89 c0                	mov    %eax,%eax
  800f8e:	48 c1 e0 02          	shl    $0x2,%rax
  800f92:	48 89 c2             	mov    %rax,%rdx
  800f95:	48 03 55 f0          	add    -0x10(%rbp),%rdx
  800f99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f9d:	48 89 10             	mov    %rdx,(%rax)
	}
	return 0;
  800fa0:	b8 00 00 00 00       	mov    $0x0,%eax
    // LAB 5: Your code here.
	// panic("file_block_walk not implemented");
}
  800fa5:	c9                   	leaveq 
  800fa6:	c3                   	retq   

0000000000800fa7 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800fa7:	55                   	push   %rbp
  800fa8:	48 89 e5             	mov    %rsp,%rbp
  800fab:	48 83 ec 30          	sub    $0x30,%rsp
  800faf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fb3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800fb6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	if (filebno >= NDIRECT + NINDIRECT) {
  800fba:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  800fc1:	76 07                	jbe    800fca <file_get_block+0x23>
		return -E_INVAL;
  800fc3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc8:	eb 61                	jmp    80102b <file_get_block+0x84>
	}
	uint32_t *ppdiskbno;
	int r = file_block_walk(f, filebno, &ppdiskbno, false);
  800fca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800fce:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fda:	48 89 c7             	mov    %rax,%rdi
  800fdd:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  800fe4:	00 00 00 
  800fe7:	ff d0                	callq  *%rax
  800fe9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800fec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ff0:	79 05                	jns    800ff7 <file_get_block+0x50>
		return r;
  800ff2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ff5:	eb 34                	jmp    80102b <file_get_block+0x84>
    if (!*ppdiskbno)
  800ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffb:	8b 00                	mov    (%rax),%eax
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	75 07                	jne    801008 <file_get_block+0x61>
        return -E_NO_DISK;
  801001:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801006:	eb 23                	jmp    80102b <file_get_block+0x84>
	*blk = (char*)diskaddr(*ppdiskbno);
  801008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100c:	8b 00                	mov    (%rax),%eax
  80100e:	89 c0                	mov    %eax,%eax
  801010:	48 89 c7             	mov    %rax,%rdi
  801013:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  80101a:	00 00 00 
  80101d:	ff d0                	callq  *%rax
  80101f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801023:	48 89 02             	mov    %rax,(%rdx)
	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
	// LAB 5: Your code here.
	//panic("file_block_walk not implemented");
}
  80102b:	c9                   	leaveq 
  80102c:	c3                   	retq   

000000000080102d <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  80102d:	55                   	push   %rbp
  80102e:	48 89 e5             	mov    %rsp,%rbp
  801031:	48 83 ec 40          	sub    $0x40,%rsp
  801035:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801039:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80103d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  801041:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801045:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80104b:	25 ff 0f 00 00       	and    $0xfff,%eax
  801050:	85 c0                	test   %eax,%eax
  801052:	74 35                	je     801089 <dir_lookup+0x5c>
  801054:	48 b9 3f 6c 80 00 00 	movabs $0x806c3f,%rcx
  80105b:	00 00 00 
  80105e:	48 ba f6 6b 80 00 00 	movabs $0x806bf6,%rdx
  801065:	00 00 00 
  801068:	be cc 00 00 00       	mov    $0xcc,%esi
  80106d:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  801074:	00 00 00 
  801077:	b8 00 00 00 00       	mov    $0x0,%eax
  80107c:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  801083:	00 00 00 
  801086:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801089:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80108d:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801093:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801099:	85 c0                	test   %eax,%eax
  80109b:	0f 48 c2             	cmovs  %edx,%eax
  80109e:	c1 f8 0c             	sar    $0xc,%eax
  8010a1:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  8010a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010ab:	e9 8a 00 00 00       	jmpq   80113a <dir_lookup+0x10d>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010b0:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8010b4:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8010b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010bb:	89 ce                	mov    %ecx,%esi
  8010bd:	48 89 c7             	mov    %rax,%rdi
  8010c0:	48 b8 a7 0f 80 00 00 	movabs $0x800fa7,%rax
  8010c7:	00 00 00 
  8010ca:	ff d0                	callq  *%rax
  8010cc:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8010cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8010d3:	79 05                	jns    8010da <dir_lookup+0xad>
			return r;
  8010d5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8010d8:	eb 71                	jmp    80114b <dir_lookup+0x11e>
		f = (struct File*) blk;
  8010da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8010e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8010e9:	eb 45                	jmp    801130 <dir_lookup+0x103>
			if (strcmp(f[j].f_name, name) == 0) {
  8010eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010ee:	48 c1 e0 08          	shl    $0x8,%rax
  8010f2:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8010f6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8010fa:	48 89 d6             	mov    %rdx,%rsi
  8010fd:	48 89 c7             	mov    %rax,%rdi
  801100:	48 b8 a7 3d 80 00 00 	movabs $0x803da7,%rax
  801107:	00 00 00 
  80110a:	ff d0                	callq  *%rax
  80110c:	85 c0                	test   %eax,%eax
  80110e:	75 1c                	jne    80112c <dir_lookup+0xff>
				*file = &f[j];
  801110:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801113:	48 c1 e0 08          	shl    $0x8,%rax
  801117:	48 89 c2             	mov    %rax,%rdx
  80111a:	48 03 55 e8          	add    -0x18(%rbp),%rdx
  80111e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801122:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
  80112a:	eb 1f                	jmp    80114b <dir_lookup+0x11e>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  80112c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801130:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801134:	76 b5                	jbe    8010eb <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801136:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80113a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80113d:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801140:	0f 82 6a ff ff ff    	jb     8010b0 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  801146:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  80114b:	c9                   	leaveq 
  80114c:	c3                   	retq   

000000000080114d <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  80114d:	55                   	push   %rbp
  80114e:	48 89 e5             	mov    %rsp,%rbp
  801151:	48 83 ec 30          	sub    $0x30,%rsp
  801155:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801159:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  80115d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801161:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801167:	25 ff 0f 00 00       	and    $0xfff,%eax
  80116c:	85 c0                	test   %eax,%eax
  80116e:	74 35                	je     8011a5 <dir_alloc_file+0x58>
  801170:	48 b9 3f 6c 80 00 00 	movabs $0x806c3f,%rcx
  801177:	00 00 00 
  80117a:	48 ba f6 6b 80 00 00 	movabs $0x806bf6,%rdx
  801181:	00 00 00 
  801184:	be e5 00 00 00       	mov    $0xe5,%esi
  801189:	48 bf 76 6b 80 00 00 	movabs $0x806b76,%rdi
  801190:	00 00 00 
  801193:	b8 00 00 00 00       	mov    $0x0,%eax
  801198:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  80119f:	00 00 00 
  8011a2:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  8011a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a9:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8011af:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	0f 48 c2             	cmovs  %edx,%eax
  8011ba:	c1 f8 0c             	sar    $0xc,%eax
  8011bd:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  8011c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011c7:	eb 7a                	jmp    801243 <dir_alloc_file+0xf6>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8011c9:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8011cd:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8011d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d4:	89 ce                	mov    %ecx,%esi
  8011d6:	48 89 c7             	mov    %rax,%rdi
  8011d9:	48 b8 a7 0f 80 00 00 	movabs $0x800fa7,%rax
  8011e0:	00 00 00 
  8011e3:	ff d0                	callq  *%rax
  8011e5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8011e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8011ec:	79 08                	jns    8011f6 <dir_alloc_file+0xa9>
			return r;
  8011ee:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8011f1:	e9 b5 00 00 00       	jmpq   8012ab <dir_alloc_file+0x15e>
		f = (struct File*) blk;
  8011f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011fa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8011fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801205:	eb 32                	jmp    801239 <dir_alloc_file+0xec>
			if (f[j].f_name[0] == '\0') {
  801207:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80120a:	48 c1 e0 08          	shl    $0x8,%rax
  80120e:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801212:	0f b6 00             	movzbl (%rax),%eax
  801215:	84 c0                	test   %al,%al
  801217:	75 1c                	jne    801235 <dir_alloc_file+0xe8>
				*file = &f[j];
  801219:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80121c:	48 c1 e0 08          	shl    $0x8,%rax
  801220:	48 89 c2             	mov    %rax,%rdx
  801223:	48 03 55 e8          	add    -0x18(%rbp),%rdx
  801227:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80122b:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  80122e:	b8 00 00 00 00       	mov    $0x0,%eax
  801233:	eb 76                	jmp    8012ab <dir_alloc_file+0x15e>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801235:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801239:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  80123d:	76 c8                	jbe    801207 <dir_alloc_file+0xba>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  80123f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801243:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801246:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801249:	0f 82 7a ff ff ff    	jb     8011c9 <dir_alloc_file+0x7c>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  80124f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801253:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801259:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  80125f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801263:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801269:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80126d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801270:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801274:	89 ce                	mov    %ecx,%esi
  801276:	48 89 c7             	mov    %rax,%rdi
  801279:	48 b8 a7 0f 80 00 00 	movabs $0x800fa7,%rax
  801280:	00 00 00 
  801283:	ff d0                	callq  *%rax
  801285:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801288:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80128c:	79 05                	jns    801293 <dir_alloc_file+0x146>
		return r;
  80128e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801291:	eb 18                	jmp    8012ab <dir_alloc_file+0x15e>
	f = (struct File*) blk;
  801293:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801297:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  80129b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80129f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012a3:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8012a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ab:	c9                   	leaveq 
  8012ac:	c3                   	retq   

00000000008012ad <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  8012ad:	55                   	push   %rbp
  8012ae:	48 89 e5             	mov    %rsp,%rbp
  8012b1:	48 83 ec 08          	sub    $0x8,%rsp
  8012b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  8012b9:	eb 05                	jmp    8012c0 <skip_slash+0x13>
		p++;
  8012bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  8012c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c4:	0f b6 00             	movzbl (%rax),%eax
  8012c7:	3c 2f                	cmp    $0x2f,%al
  8012c9:	74 f0                	je     8012bb <skip_slash+0xe>
		p++;
	return p;
  8012cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012cf:	c9                   	leaveq 
  8012d0:	c3                   	retq   

00000000008012d1 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  8012d1:	55                   	push   %rbp
  8012d2:	48 89 e5             	mov    %rsp,%rbp
  8012d5:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8012dc:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  8012e3:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  8012ea:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  8012f1:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  8012f8:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8012ff:	48 89 c7             	mov    %rax,%rdi
  801302:	48 b8 ad 12 80 00 00 	movabs $0x8012ad,%rax
  801309:	00 00 00 
  80130c:	ff d0                	callq  *%rax
  80130e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  801315:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  80131c:	00 00 00 
  80131f:	48 8b 00             	mov    (%rax),%rax
  801322:	48 83 c0 08          	add    $0x8,%rax
  801326:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  80132d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801334:	00 
	name[0] = 0;
  801335:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  80133c:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801343:	00 
  801344:	74 0e                	je     801354 <walk_path+0x83>
		*pdir = 0;
  801346:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  80134d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  801354:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80135b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  801362:	e9 7c 01 00 00       	jmpq   8014e3 <walk_path+0x212>
		dir = f;
  801367:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80136e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  801372:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801379:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  80137d:	eb 08                	jmp    801387 <walk_path+0xb6>
			path++;
  80137f:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  801386:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801387:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80138e:	0f b6 00             	movzbl (%rax),%eax
  801391:	3c 2f                	cmp    $0x2f,%al
  801393:	74 0e                	je     8013a3 <walk_path+0xd2>
  801395:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80139c:	0f b6 00             	movzbl (%rax),%eax
  80139f:	84 c0                	test   %al,%al
  8013a1:	75 dc                	jne    80137f <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  8013a3:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8013aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ae:	48 89 d1             	mov    %rdx,%rcx
  8013b1:	48 29 c1             	sub    %rax,%rcx
  8013b4:	48 89 c8             	mov    %rcx,%rax
  8013b7:	48 83 f8 7f          	cmp    $0x7f,%rax
  8013bb:	7e 0a                	jle    8013c7 <walk_path+0xf6>
			return -E_BAD_PATH;
  8013bd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8013c2:	e9 5c 01 00 00       	jmpq   801523 <walk_path+0x252>
		memmove(name, p, path - p);
  8013c7:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8013ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d2:	48 89 d1             	mov    %rdx,%rcx
  8013d5:	48 29 c1             	sub    %rax,%rcx
  8013d8:	48 89 c8             	mov    %rcx,%rax
  8013db:	48 89 c2             	mov    %rax,%rdx
  8013de:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013e2:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  8013e9:	48 89 ce             	mov    %rcx,%rsi
  8013ec:	48 89 c7             	mov    %rax,%rdi
  8013ef:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  8013f6:	00 00 00 
  8013f9:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  8013fb:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801406:	48 89 d1             	mov    %rdx,%rcx
  801409:	48 29 c1             	sub    %rax,%rcx
  80140c:	48 89 c8             	mov    %rcx,%rax
  80140f:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  801416:	00 
		path = skip_slash(path);
  801417:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80141e:	48 89 c7             	mov    %rax,%rdi
  801421:	48 b8 ad 12 80 00 00 	movabs $0x8012ad,%rax
  801428:	00 00 00 
  80142b:	ff d0                	callq  *%rax
  80142d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  801434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801438:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80143e:	83 f8 01             	cmp    $0x1,%eax
  801441:	74 0a                	je     80144d <walk_path+0x17c>
			return -E_NOT_FOUND;
  801443:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801448:	e9 d6 00 00 00       	jmpq   801523 <walk_path+0x252>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  80144d:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  801454:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  80145b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145f:	48 89 ce             	mov    %rcx,%rsi
  801462:	48 89 c7             	mov    %rax,%rdi
  801465:	48 b8 2d 10 80 00 00 	movabs $0x80102d,%rax
  80146c:	00 00 00 
  80146f:	ff d0                	callq  *%rax
  801471:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801474:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801478:	79 69                	jns    8014e3 <walk_path+0x212>
			if (r == -E_NOT_FOUND && *path == '\0') {
  80147a:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  80147e:	75 5e                	jne    8014de <walk_path+0x20d>
  801480:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801487:	0f b6 00             	movzbl (%rax),%eax
  80148a:	84 c0                	test   %al,%al
  80148c:	75 50                	jne    8014de <walk_path+0x20d>
				if (pdir)
  80148e:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801495:	00 
  801496:	74 0e                	je     8014a6 <walk_path+0x1d5>
					*pdir = dir;
  801498:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  80149f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a3:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  8014a6:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  8014ad:	00 
  8014ae:	74 20                	je     8014d0 <walk_path+0x1ff>
					strcpy(lastelem, name);
  8014b0:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8014b7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  8014be:	48 89 d6             	mov    %rdx,%rsi
  8014c1:	48 89 c7             	mov    %rax,%rdi
  8014c4:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  8014cb:	00 00 00 
  8014ce:	ff d0                	callq  *%rax
				*pf = 0;
  8014d0:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8014d7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  8014de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014e1:	eb 40                	jmp    801523 <walk_path+0x252>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  8014e3:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8014ea:	0f b6 00             	movzbl (%rax),%eax
  8014ed:	84 c0                	test   %al,%al
  8014ef:	0f 85 72 fe ff ff    	jne    801367 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  8014f5:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8014fc:	00 
  8014fd:	74 0e                	je     80150d <walk_path+0x23c>
		*pdir = dir;
  8014ff:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801506:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150a:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  80150d:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  801514:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80151b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801523:	c9                   	leaveq 
  801524:	c3                   	retq   

0000000000801525 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801525:	55                   	push   %rbp
  801526:	48 89 e5             	mov    %rsp,%rbp
  801529:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801530:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  801537:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  80153e:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  801545:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80154c:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  801553:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80155a:	48 89 c7             	mov    %rax,%rdi
  80155d:	48 b8 d1 12 80 00 00 	movabs $0x8012d1,%rax
  801564:	00 00 00 
  801567:	ff d0                	callq  *%rax
  801569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80156c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801570:	75 0a                	jne    80157c <file_create+0x57>
		return -E_FILE_EXISTS;
  801572:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801577:	e9 91 00 00 00       	jmpq   80160d <file_create+0xe8>
	if (r != -E_NOT_FOUND || dir == 0)
  80157c:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  801580:	75 0c                	jne    80158e <file_create+0x69>
  801582:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801589:	48 85 c0             	test   %rax,%rax
  80158c:	75 05                	jne    801593 <file_create+0x6e>
		return r;
  80158e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801591:	eb 7a                	jmp    80160d <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  801593:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80159a:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8015a1:	48 89 d6             	mov    %rdx,%rsi
  8015a4:	48 89 c7             	mov    %rax,%rdi
  8015a7:	48 b8 4d 11 80 00 00 	movabs $0x80114d,%rax
  8015ae:	00 00 00 
  8015b1:	ff d0                	callq  *%rax
  8015b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015ba:	79 05                	jns    8015c1 <file_create+0x9c>
		return r;
  8015bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015bf:	eb 4c                	jmp    80160d <file_create+0xe8>
	strcpy(f->f_name, name);
  8015c1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8015c8:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  8015cf:	48 89 d6             	mov    %rdx,%rsi
  8015d2:	48 89 c7             	mov    %rax,%rdi
  8015d5:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  8015dc:	00 00 00 
  8015df:	ff d0                	callq  *%rax
	*pf = f;
  8015e1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8015e8:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8015ef:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  8015f2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8015f9:	48 89 c7             	mov    %rax,%rdi
  8015fc:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  801603:	00 00 00 
  801606:	ff d0                	callq  *%rax
	return 0;
  801608:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160d:	c9                   	leaveq 
  80160e:	c3                   	retq   

000000000080160f <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  80160f:	55                   	push   %rbp
  801610:	48 89 e5             	mov    %rsp,%rbp
  801613:	48 83 ec 10          	sub    $0x10,%rsp
  801617:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  80161f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801627:	b9 00 00 00 00       	mov    $0x0,%ecx
  80162c:	be 00 00 00 00       	mov    $0x0,%esi
  801631:	48 89 c7             	mov    %rax,%rdi
  801634:	48 b8 d1 12 80 00 00 	movabs $0x8012d1,%rax
  80163b:	00 00 00 
  80163e:	ff d0                	callq  *%rax
}
  801640:	c9                   	leaveq 
  801641:	c3                   	retq   

0000000000801642 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  801642:	55                   	push   %rbp
  801643:	48 89 e5             	mov    %rsp,%rbp
  801646:	48 83 ec 60          	sub    $0x60,%rsp
  80164a:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  80164e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  801652:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801656:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  801659:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80165d:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801663:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  801666:	7f 0a                	jg     801672 <file_read+0x30>
		return 0;
  801668:	b8 00 00 00 00       	mov    $0x0,%eax
  80166d:	e9 2d 01 00 00       	jmpq   80179f <file_read+0x15d>

	count = MIN(count, f->f_size - offset);
  801672:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801676:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80167a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80167e:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801684:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  801687:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80168a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80168d:	48 63 d0             	movslq %eax,%rdx
  801690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801694:	48 39 c2             	cmp    %rax,%rdx
  801697:	48 0f 46 c2          	cmovbe %rdx,%rax
  80169b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  80169f:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8016a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016a5:	e9 d9 00 00 00       	jmpq   801783 <file_read+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  8016aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ad:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	0f 48 c2             	cmovs  %edx,%eax
  8016b8:	c1 f8 0c             	sar    $0xc,%eax
  8016bb:	89 c1                	mov    %eax,%ecx
  8016bd:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8016c1:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8016c5:	89 ce                	mov    %ecx,%esi
  8016c7:	48 89 c7             	mov    %rax,%rdi
  8016ca:	48 b8 a7 0f 80 00 00 	movabs $0x800fa7,%rax
  8016d1:	00 00 00 
  8016d4:	ff d0                	callq  *%rax
  8016d6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8016d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8016dd:	79 08                	jns    8016e7 <file_read+0xa5>
			return r;
  8016df:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8016e2:	e9 b8 00 00 00       	jmpq   80179f <file_read+0x15d>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  8016e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ea:	89 c2                	mov    %eax,%edx
  8016ec:	c1 fa 1f             	sar    $0x1f,%edx
  8016ef:	c1 ea 14             	shr    $0x14,%edx
  8016f2:	01 d0                	add    %edx,%eax
  8016f4:	25 ff 0f 00 00       	and    $0xfff,%eax
  8016f9:	29 d0                	sub    %edx,%eax
  8016fb:	ba 00 10 00 00       	mov    $0x1000,%edx
  801700:	89 d1                	mov    %edx,%ecx
  801702:	29 c1                	sub    %eax,%ecx
  801704:	89 c8                	mov    %ecx,%eax
  801706:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801709:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80170c:	48 98                	cltq   
  80170e:	48 89 c2             	mov    %rax,%rdx
  801711:	48 03 55 a8          	add    -0x58(%rbp),%rdx
  801715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801718:	48 98                	cltq   
  80171a:	48 89 d1             	mov    %rdx,%rcx
  80171d:	48 29 c1             	sub    %rax,%rcx
  801720:	48 89 c8             	mov    %rcx,%rax
  801723:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801727:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80172a:	48 63 d0             	movslq %eax,%rdx
  80172d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801731:	48 39 c2             	cmp    %rax,%rdx
  801734:	48 0f 46 c2          	cmovbe %rdx,%rax
  801738:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  80173b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80173e:	48 63 c8             	movslq %eax,%rcx
  801741:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801745:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801748:	89 c2                	mov    %eax,%edx
  80174a:	c1 fa 1f             	sar    $0x1f,%edx
  80174d:	c1 ea 14             	shr    $0x14,%edx
  801750:	01 d0                	add    %edx,%eax
  801752:	25 ff 0f 00 00       	and    $0xfff,%eax
  801757:	29 d0                	sub    %edx,%eax
  801759:	48 98                	cltq   
  80175b:	48 01 c6             	add    %rax,%rsi
  80175e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801762:	48 89 ca             	mov    %rcx,%rdx
  801765:	48 89 c7             	mov    %rax,%rdi
  801768:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  80176f:	00 00 00 
  801772:	ff d0                	callq  *%rax
		pos += bn;
  801774:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801777:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  80177a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80177d:	48 98                	cltq   
  80177f:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801783:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801786:	48 63 d0             	movslq %eax,%rdx
  801789:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80178c:	48 98                	cltq   
  80178e:	48 03 45 a8          	add    -0x58(%rbp),%rax
  801792:	48 39 c2             	cmp    %rax,%rdx
  801795:	0f 82 0f ff ff ff    	jb     8016aa <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  80179b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  80179f:	c9                   	leaveq 
  8017a0:	c3                   	retq   

00000000008017a1 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  8017a1:	55                   	push   %rbp
  8017a2:	48 89 e5             	mov    %rsp,%rbp
  8017a5:	48 83 ec 50          	sub    $0x50,%rsp
  8017a9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8017ad:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8017b1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8017b5:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  8017b8:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8017bb:	48 98                	cltq   
  8017bd:	48 89 c2             	mov    %rax,%rdx
  8017c0:	48 03 55 b8          	add    -0x48(%rbp),%rdx
  8017c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8017c8:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8017ce:	48 98                	cltq   
  8017d0:	48 39 c2             	cmp    %rax,%rdx
  8017d3:	76 33                	jbe    801808 <file_write+0x67>
		if ((r = file_set_size(f, offset + count)) < 0)
  8017d5:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8017d9:	89 c2                	mov    %eax,%edx
  8017db:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8017de:	01 d0                	add    %edx,%eax
  8017e0:	89 c2                	mov    %eax,%edx
  8017e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8017e6:	89 d6                	mov    %edx,%esi
  8017e8:	48 89 c7             	mov    %rax,%rdi
  8017eb:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8017f2:	00 00 00 
  8017f5:	ff d0                	callq  *%rax
  8017f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8017fa:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8017fe:	79 08                	jns    801808 <file_write+0x67>
			return r;
  801800:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801803:	e9 01 01 00 00       	jmpq   801909 <file_write+0x168>

	for (pos = offset; pos < offset + count; ) {
  801808:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  80180b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80180e:	e9 da 00 00 00       	jmpq   8018ed <file_write+0x14c>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801813:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801816:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80181c:	85 c0                	test   %eax,%eax
  80181e:	0f 48 c2             	cmovs  %edx,%eax
  801821:	c1 f8 0c             	sar    $0xc,%eax
  801824:	89 c1                	mov    %eax,%ecx
  801826:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80182a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80182e:	89 ce                	mov    %ecx,%esi
  801830:	48 89 c7             	mov    %rax,%rdi
  801833:	48 b8 a7 0f 80 00 00 	movabs $0x800fa7,%rax
  80183a:	00 00 00 
  80183d:	ff d0                	callq  *%rax
  80183f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801842:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801846:	79 08                	jns    801850 <file_write+0xaf>
			return r;
  801848:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80184b:	e9 b9 00 00 00       	jmpq   801909 <file_write+0x168>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801850:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801853:	89 c2                	mov    %eax,%edx
  801855:	c1 fa 1f             	sar    $0x1f,%edx
  801858:	c1 ea 14             	shr    $0x14,%edx
  80185b:	01 d0                	add    %edx,%eax
  80185d:	25 ff 0f 00 00       	and    $0xfff,%eax
  801862:	29 d0                	sub    %edx,%eax
  801864:	ba 00 10 00 00       	mov    $0x1000,%edx
  801869:	89 d1                	mov    %edx,%ecx
  80186b:	29 c1                	sub    %eax,%ecx
  80186d:	89 c8                	mov    %ecx,%eax
  80186f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801872:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801875:	48 98                	cltq   
  801877:	48 89 c2             	mov    %rax,%rdx
  80187a:	48 03 55 b8          	add    -0x48(%rbp),%rdx
  80187e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801881:	48 98                	cltq   
  801883:	48 89 d1             	mov    %rdx,%rcx
  801886:	48 29 c1             	sub    %rax,%rcx
  801889:	48 89 c8             	mov    %rcx,%rax
  80188c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801890:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801893:	48 63 d0             	movslq %eax,%rdx
  801896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189a:	48 39 c2             	cmp    %rax,%rdx
  80189d:	48 0f 46 c2          	cmovbe %rdx,%rax
  8018a1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  8018a4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018a7:	48 63 c8             	movslq %eax,%rcx
  8018aa:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8018ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b1:	89 c2                	mov    %eax,%edx
  8018b3:	c1 fa 1f             	sar    $0x1f,%edx
  8018b6:	c1 ea 14             	shr    $0x14,%edx
  8018b9:	01 d0                	add    %edx,%eax
  8018bb:	25 ff 0f 00 00       	and    $0xfff,%eax
  8018c0:	29 d0                	sub    %edx,%eax
  8018c2:	48 98                	cltq   
  8018c4:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  8018c8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8018cc:	48 89 ca             	mov    %rcx,%rdx
  8018cf:	48 89 c6             	mov    %rax,%rsi
  8018d2:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	callq  *%rax
		pos += bn;
  8018de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018e1:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  8018e4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018e7:	48 98                	cltq   
  8018e9:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  8018ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f0:	48 63 d0             	movslq %eax,%rdx
  8018f3:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8018f6:	48 98                	cltq   
  8018f8:	48 03 45 b8          	add    -0x48(%rbp),%rax
  8018fc:	48 39 c2             	cmp    %rax,%rdx
  8018ff:	0f 82 0e ff ff ff    	jb     801813 <file_write+0x72>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801905:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801909:	c9                   	leaveq 
  80190a:	c3                   	retq   

000000000080190b <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  80190b:	55                   	push   %rbp
  80190c:	48 89 e5             	mov    %rsp,%rbp
  80190f:	48 83 ec 20          	sub    $0x20,%rsp
  801913:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801917:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  80191a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80191e:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801925:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192a:	48 89 c7             	mov    %rax,%rdi
  80192d:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  801934:	00 00 00 
  801937:	ff d0                	callq  *%rax
  801939:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80193c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801940:	79 05                	jns    801947 <file_free_block+0x3c>
		return r;
  801942:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801945:	eb 2d                	jmp    801974 <file_free_block+0x69>
	if (*ptr) {
  801947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80194b:	8b 00                	mov    (%rax),%eax
  80194d:	85 c0                	test   %eax,%eax
  80194f:	74 1e                	je     80196f <file_free_block+0x64>
		free_block(*ptr);
  801951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801955:	8b 00                	mov    (%rax),%eax
  801957:	89 c7                	mov    %eax,%edi
  801959:	48 b8 4e 0c 80 00 00 	movabs $0x800c4e,%rax
  801960:	00 00 00 
  801963:	ff d0                	callq  *%rax
		*ptr = 0;
  801965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801969:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  80196f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801974:	c9                   	leaveq 
  801975:	c3                   	retq   

0000000000801976 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801976:	55                   	push   %rbp
  801977:	48 89 e5             	mov    %rsp,%rbp
  80197a:	48 83 ec 20          	sub    $0x20,%rsp
  80197e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801982:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801989:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80198f:	05 ff 0f 00 00       	add    $0xfff,%eax
  801994:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80199a:	85 c0                	test   %eax,%eax
  80199c:	0f 48 c2             	cmovs  %edx,%eax
  80199f:	c1 f8 0c             	sar    $0xc,%eax
  8019a2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  8019a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019a8:	05 ff 0f 00 00       	add    $0xfff,%eax
  8019ad:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	0f 48 c2             	cmovs  %edx,%eax
  8019b8:	c1 f8 0c             	sar    $0xc,%eax
  8019bb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  8019be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019c4:	eb 45                	jmp    801a0b <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  8019c6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8019c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019cd:	89 d6                	mov    %edx,%esi
  8019cf:	48 89 c7             	mov    %rax,%rdi
  8019d2:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  8019d9:	00 00 00 
  8019dc:	ff d0                	callq  *%rax
  8019de:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8019e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8019e5:	79 20                	jns    801a07 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  8019e7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8019ea:	89 c6                	mov    %eax,%esi
  8019ec:	48 bf 5c 6c 80 00 00 	movabs $0x806c5c,%rdi
  8019f3:	00 00 00 
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  801a02:	00 00 00 
  801a05:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801a07:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0e:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801a11:	72 b3                	jb     8019c6 <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801a13:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801a17:	77 34                	ja     801a4d <file_truncate_blocks+0xd7>
  801a19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a1d:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801a23:	85 c0                	test   %eax,%eax
  801a25:	74 26                	je     801a4d <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2b:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801a31:	89 c7                	mov    %eax,%edi
  801a33:	48 b8 4e 0c 80 00 00 	movabs $0x800c4e,%rax
  801a3a:	00 00 00 
  801a3d:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a43:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801a4a:	00 00 00 
	}
}
  801a4d:	c9                   	leaveq 
  801a4e:	c3                   	retq   

0000000000801a4f <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801a4f:	55                   	push   %rbp
  801a50:	48 89 e5             	mov    %rsp,%rbp
  801a53:	48 83 ec 10          	sub    $0x10,%rsp
  801a57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a5b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801a5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a62:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a68:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801a6b:	7e 18                	jle    801a85 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801a6d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801a70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a74:	89 d6                	mov    %edx,%esi
  801a76:	48 89 c7             	mov    %rax,%rdi
  801a79:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  801a80:	00 00 00 
  801a83:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801a85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a89:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801a8c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801a92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a96:	48 89 c7             	mov    %rax,%rdi
  801a99:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  801aa0:	00 00 00 
  801aa3:	ff d0                	callq  *%rax
	return 0;
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aaa:	c9                   	leaveq 
  801aab:	c3                   	retq   

0000000000801aac <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801aac:	55                   	push   %rbp
  801aad:	48 89 e5             	mov    %rsp,%rbp
  801ab0:	48 83 ec 20          	sub    $0x20,%rsp
  801ab4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801ab8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801abf:	eb 63                	jmp    801b24 <file_flush+0x78>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801ac1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ac4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801acc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad1:	48 89 c7             	mov    %rax,%rdi
  801ad4:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  801adb:	00 00 00 
  801ade:	ff d0                	callq  *%rax
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 3b                	js     801b1f <file_flush+0x73>
		    pdiskbno == NULL || *pdiskbno == 0)
  801ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801ae8:	48 85 c0             	test   %rax,%rax
  801aeb:	74 32                	je     801b1f <file_flush+0x73>
		    pdiskbno == NULL || *pdiskbno == 0)
  801aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af1:	8b 00                	mov    (%rax),%eax
  801af3:	85 c0                	test   %eax,%eax
  801af5:	74 28                	je     801b1f <file_flush+0x73>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801af7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801afb:	8b 00                	mov    (%rax),%eax
  801afd:	89 c0                	mov    %eax,%eax
  801aff:	48 89 c7             	mov    %rax,%rdi
  801b02:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  801b09:	00 00 00 
  801b0c:	ff d0                	callq  *%rax
  801b0e:	48 89 c7             	mov    %rax,%rdi
  801b11:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
  801b1d:	eb 01                	jmp    801b20 <file_flush+0x74>
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
  801b1f:	90                   	nop
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801b20:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801b24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b28:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801b2e:	05 ff 0f 00 00       	add    $0xfff,%eax
  801b33:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	0f 48 c2             	cmovs  %edx,%eax
  801b3e:	c1 f8 0c             	sar    $0xc,%eax
  801b41:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801b44:	0f 8f 77 ff ff ff    	jg     801ac1 <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801b4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b4e:	48 89 c7             	mov    %rax,%rdi
  801b51:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  801b58:	00 00 00 
  801b5b:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b61:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801b67:	85 c0                	test   %eax,%eax
  801b69:	74 2a                	je     801b95 <file_flush+0xe9>
		flush_block(diskaddr(f->f_indirect));
  801b6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b6f:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801b75:	89 c0                	mov    %eax,%eax
  801b77:	48 89 c7             	mov    %rax,%rdi
  801b7a:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  801b81:	00 00 00 
  801b84:	ff d0                	callq  *%rax
  801b86:	48 89 c7             	mov    %rax,%rdi
  801b89:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  801b90:	00 00 00 
  801b93:	ff d0                	callq  *%rax
}
  801b95:	c9                   	leaveq 
  801b96:	c3                   	retq   

0000000000801b97 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801b97:	55                   	push   %rbp
  801b98:	48 89 e5             	mov    %rsp,%rbp
  801b9b:	48 83 ec 20          	sub    $0x20,%rsp
  801b9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801ba3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb0:	be 00 00 00 00       	mov    $0x0,%esi
  801bb5:	48 89 c7             	mov    %rax,%rdi
  801bb8:	48 b8 d1 12 80 00 00 	movabs $0x8012d1,%rax
  801bbf:	00 00 00 
  801bc2:	ff d0                	callq  *%rax
  801bc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bcb:	79 05                	jns    801bd2 <file_remove+0x3b>
		return r;
  801bcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd0:	eb 45                	jmp    801c17 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd6:	be 00 00 00 00       	mov    $0x0,%esi
  801bdb:	48 89 c7             	mov    %rax,%rdi
  801bde:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  801be5:	00 00 00 
  801be8:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bee:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801bf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bf5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801bfc:	00 00 00 
	flush_block(f);
  801bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c03:	48 89 c7             	mov    %rax,%rdi
  801c06:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  801c0d:	00 00 00 
  801c10:	ff d0                	callq  *%rax

	return 0;
  801c12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c17:	c9                   	leaveq 
  801c18:	c3                   	retq   

0000000000801c19 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801c19:	55                   	push   %rbp
  801c1a:	48 89 e5             	mov    %rsp,%rbp
  801c1d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801c21:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801c28:	eb 27                	jmp    801c51 <fs_sync+0x38>
		flush_block(diskaddr(i));
  801c2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2d:	48 98                	cltq   
  801c2f:	48 89 c7             	mov    %rax,%rdi
  801c32:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	callq  *%rax
  801c3e:	48 89 c7             	mov    %rax,%rdi
  801c41:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  801c48:	00 00 00 
  801c4b:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801c4d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c51:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c54:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  801c5b:	00 00 00 
  801c5e:	48 8b 00             	mov    (%rax),%rax
  801c61:	8b 40 04             	mov    0x4(%rax),%eax
  801c64:	39 c2                	cmp    %eax,%edx
  801c66:	72 c2                	jb     801c2a <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  801c68:	c9                   	leaveq 
  801c69:	c3                   	retq   
	...

0000000000801c6c <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801c6c:	55                   	push   %rbp
  801c6d:	48 89 e5             	mov    %rsp,%rbp
  801c70:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  801c74:	c7 45 f0 00 00 00 d0 	movl   $0xd0000000,-0x10(%rbp)
  801c7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  801c82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c89:	eb 4b                	jmp    801cd6 <serve_init+0x6a>
		opentab[i].o_fileid = i;
  801c8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8e:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801c95:	00 00 00 
  801c98:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801c9b:	48 63 c9             	movslq %ecx,%rcx
  801c9e:	48 c1 e1 05          	shl    $0x5,%rcx
  801ca2:	48 01 ca             	add    %rcx,%rdx
  801ca5:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  801ca7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cab:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801cb2:	00 00 00 
  801cb5:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801cb8:	48 63 c9             	movslq %ecx,%rcx
  801cbb:	48 c1 e1 05          	shl    $0x5,%rcx
  801cbf:	48 01 ca             	add    %rcx,%rdx
  801cc2:	48 83 c2 10          	add    $0x10,%rdx
  801cc6:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  801cca:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  801cd1:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  801cd2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cd6:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801cdd:	7e ac                	jle    801c8b <serve_init+0x1f>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  801cdf:	c9                   	leaveq 
  801ce0:	c3                   	retq   

0000000000801ce1 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
  801ce5:	48 83 ec 20          	sub    $0x20,%rsp
  801ce9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801ced:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cf4:	e9 24 01 00 00       	jmpq   801e1d <openfile_alloc+0x13c>
		switch (pageref(opentab[i].o_fd)) {
  801cf9:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801d00:	00 00 00 
  801d03:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d06:	48 63 d2             	movslq %edx,%rdx
  801d09:	48 c1 e2 05          	shl    $0x5,%rdx
  801d0d:	48 01 d0             	add    %rdx,%rax
  801d10:	48 83 c0 10          	add    $0x10,%rax
  801d14:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d18:	48 89 c7             	mov    %rax,%rdi
  801d1b:	48 b8 3c 58 80 00 00 	movabs $0x80583c,%rax
  801d22:	00 00 00 
  801d25:	ff d0                	callq  *%rax
  801d27:	85 c0                	test   %eax,%eax
  801d29:	74 0a                	je     801d35 <openfile_alloc+0x54>
  801d2b:	83 f8 01             	cmp    $0x1,%eax
  801d2e:	74 4e                	je     801d7e <openfile_alloc+0x9d>
  801d30:	e9 e4 00 00 00       	jmpq   801e19 <openfile_alloc+0x138>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801d35:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801d3c:	00 00 00 
  801d3f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d42:	48 63 d2             	movslq %edx,%rdx
  801d45:	48 c1 e2 05          	shl    $0x5,%rdx
  801d49:	48 01 d0             	add    %rdx,%rax
  801d4c:	48 83 c0 10          	add    $0x10,%rax
  801d50:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d54:	ba 07 00 00 00       	mov    $0x7,%edx
  801d59:	48 89 c6             	mov    %rax,%rsi
  801d5c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d61:	48 b8 84 45 80 00 00 	movabs $0x804584,%rax
  801d68:	00 00 00 
  801d6b:	ff d0                	callq  *%rax
  801d6d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801d70:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d74:	79 08                	jns    801d7e <openfile_alloc+0x9d>
				return r;
  801d76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d79:	e9 b1 00 00 00       	jmpq   801e2f <openfile_alloc+0x14e>
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  801d7e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801d85:	00 00 00 
  801d88:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d8b:	48 63 d2             	movslq %edx,%rdx
  801d8e:	48 c1 e2 05          	shl    $0x5,%rdx
  801d92:	48 01 d0             	add    %rdx,%rax
  801d95:	8b 00                	mov    (%rax),%eax
  801d97:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  801d9d:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801da4:	00 00 00 
  801da7:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801daa:	48 63 c9             	movslq %ecx,%rcx
  801dad:	48 c1 e1 05          	shl    $0x5,%rcx
  801db1:	48 01 c8             	add    %rcx,%rax
  801db4:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  801db6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db9:	48 98                	cltq   
  801dbb:	48 89 c2             	mov    %rax,%rdx
  801dbe:	48 c1 e2 05          	shl    $0x5,%rdx
  801dc2:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801dc9:	00 00 00 
  801dcc:	48 01 c2             	add    %rax,%rdx
  801dcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd3:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  801dd6:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801ddd:	00 00 00 
  801de0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801de3:	48 63 d2             	movslq %edx,%rdx
  801de6:	48 c1 e2 05          	shl    $0x5,%rdx
  801dea:	48 01 d0             	add    %rdx,%rax
  801ded:	48 83 c0 10          	add    $0x10,%rax
  801df1:	48 8b 40 08          	mov    0x8(%rax),%rax
  801df5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801dfa:	be 00 00 00 00       	mov    $0x0,%esi
  801dff:	48 89 c7             	mov    %rax,%rdi
  801e02:	48 b8 e3 3e 80 00 00 	movabs $0x803ee3,%rax
  801e09:	00 00 00 
  801e0c:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  801e0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e12:	48 8b 00             	mov    (%rax),%rax
  801e15:	8b 00                	mov    (%rax),%eax
  801e17:	eb 16                	jmp    801e2f <openfile_alloc+0x14e>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801e19:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e1d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801e24:	0f 8e cf fe ff ff    	jle    801cf9 <openfile_alloc+0x18>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  801e2a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e2f:	c9                   	leaveq 
  801e30:	c3                   	retq   

0000000000801e31 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  801e31:	55                   	push   %rbp
  801e32:	48 89 e5             	mov    %rsp,%rbp
  801e35:	48 83 ec 20          	sub    $0x20,%rsp
  801e39:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e3c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801e3f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  801e43:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e46:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e4b:	48 89 c2             	mov    %rax,%rdx
  801e4e:	48 c1 e2 05          	shl    $0x5,%rdx
  801e52:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801e59:	00 00 00 
  801e5c:	48 01 d0             	add    %rdx,%rax
  801e5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  801e63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e67:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e6b:	48 89 c7             	mov    %rax,%rdi
  801e6e:	48 b8 3c 58 80 00 00 	movabs $0x80583c,%rax
  801e75:	00 00 00 
  801e78:	ff d0                	callq  *%rax
  801e7a:	83 f8 01             	cmp    $0x1,%eax
  801e7d:	74 0b                	je     801e8a <openfile_lookup+0x59>
  801e7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e83:	8b 00                	mov    (%rax),%eax
  801e85:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801e88:	74 07                	je     801e91 <openfile_lookup+0x60>
		return -E_INVAL;
  801e8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e8f:	eb 10                	jmp    801ea1 <openfile_lookup+0x70>
	*po = o;
  801e91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e95:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e99:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea1:	c9                   	leaveq 
  801ea2:	c3                   	retq   

0000000000801ea3 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  801ea3:	55                   	push   %rbp
  801ea4:	48 89 e5             	mov    %rsp,%rbp
  801ea7:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  801eae:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  801eb4:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  801ebb:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  801ec2:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  801ec9:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  801ed0:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  801ed7:	ba 00 04 00 00       	mov    $0x400,%edx
  801edc:	48 89 ce             	mov    %rcx,%rsi
  801edf:	48 89 c7             	mov    %rax,%rdi
  801ee2:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  801eee:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  801ef2:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  801ef9:	48 89 c7             	mov    %rax,%rdi
  801efc:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  801f03:	00 00 00 
  801f06:	ff d0                	callq  *%rax
  801f08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f0f:	79 08                	jns    801f19 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  801f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f14:	e9 7b 01 00 00       	jmpq   802094 <serve_open+0x1f1>
	}
	fileid = r;
  801f19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1c:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  801f1f:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  801f26:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  801f2c:	25 00 01 00 00       	and    $0x100,%eax
  801f31:	85 c0                	test   %eax,%eax
  801f33:	74 4e                	je     801f83 <serve_open+0xe0>
		if ((r = file_create(path, &f)) < 0) {
  801f35:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  801f3c:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  801f43:	48 89 d6             	mov    %rdx,%rsi
  801f46:	48 89 c7             	mov    %rax,%rdi
  801f49:	48 b8 25 15 80 00 00 	movabs $0x801525,%rax
  801f50:	00 00 00 
  801f53:	ff d0                	callq  *%rax
  801f55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f5c:	79 56                	jns    801fb4 <serve_open+0x111>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  801f5e:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  801f65:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  801f6b:	25 00 04 00 00       	and    $0x400,%eax
  801f70:	85 c0                	test   %eax,%eax
  801f72:	75 06                	jne    801f7a <serve_open+0xd7>
  801f74:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  801f78:	74 08                	je     801f82 <serve_open+0xdf>
				goto try_open;
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  801f7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f7d:	e9 12 01 00 00       	jmpq   802094 <serve_open+0x1f1>

	// Open the file
	if (req->req_omode & O_CREAT) {
		if ((r = file_create(path, &f)) < 0) {
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
				goto try_open;
  801f82:	90                   	nop
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
	try_open:
		if ((r = file_open(path, &f)) < 0) {
  801f83:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  801f8a:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  801f91:	48 89 d6             	mov    %rdx,%rsi
  801f94:	48 89 c7             	mov    %rax,%rdi
  801f97:	48 b8 0f 16 80 00 00 	movabs $0x80160f,%rax
  801f9e:	00 00 00 
  801fa1:	ff d0                	callq  *%rax
  801fa3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801faa:	79 08                	jns    801fb4 <serve_open+0x111>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  801fac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801faf:	e9 e0 00 00 00       	jmpq   802094 <serve_open+0x1f1>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  801fb4:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  801fbb:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  801fc1:	25 00 02 00 00       	and    $0x200,%eax
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	74 2c                	je     801ff6 <serve_open+0x153>
		if ((r = file_set_size(f, 0)) < 0) {
  801fca:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  801fd1:	be 00 00 00 00       	mov    $0x0,%esi
  801fd6:	48 89 c7             	mov    %rax,%rdi
  801fd9:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  801fe0:	00 00 00 
  801fe3:	ff d0                	callq  *%rax
  801fe5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fe8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fec:	79 08                	jns    801ff6 <serve_open+0x153>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  801fee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff1:	e9 9e 00 00 00       	jmpq   802094 <serve_open+0x1f1>
		}
	}

	// Save the file pointer
	o->o_file = f;
  801ff6:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  801ffd:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  802004:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  802008:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80200f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802013:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  80201a:	8b 12                	mov    (%rdx),%edx
  80201c:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80201f:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802026:	48 8b 40 18          	mov    0x18(%rax),%rax
  80202a:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  802031:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802037:	83 e2 03             	and    $0x3,%edx
  80203a:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  80203d:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802044:	48 8b 40 18          	mov    0x18(%rax),%rax
  802048:	48 ba e0 10 81 00 00 	movabs $0x8110e0,%rdx
  80204f:	00 00 00 
  802052:	8b 12                	mov    (%rdx),%edx
  802054:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  802056:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80205d:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  802064:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  80206a:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  80206d:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802074:	48 8b 50 18          	mov    0x18(%rax),%rdx
  802078:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  80207f:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  802082:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  802089:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802094:	c9                   	leaveq 
  802095:	c3                   	retq   

0000000000802096 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  802096:	55                   	push   %rbp
  802097:	48 89 e5             	mov    %rsp,%rbp
  80209a:	48 83 ec 20          	sub    $0x20,%rsp
  80209e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8020a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020a9:	8b 00                	mov    (%rax),%eax
  8020ab:	89 c1                	mov    %eax,%ecx
  8020ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020b4:	89 ce                	mov    %ecx,%esi
  8020b6:	89 c7                	mov    %eax,%edi
  8020b8:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  8020bf:	00 00 00 
  8020c2:	ff d0                	callq  *%rax
  8020c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020cb:	79 05                	jns    8020d2 <serve_set_size+0x3c>
		return r;
  8020cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d0:	eb 20                	jmp    8020f2 <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  8020d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020d6:	8b 50 04             	mov    0x4(%rax),%edx
  8020d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020dd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020e1:	89 d6                	mov    %edx,%esi
  8020e3:	48 89 c7             	mov    %rax,%rdi
  8020e6:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8020ed:	00 00 00 
  8020f0:	ff d0                	callq  *%rax
}
  8020f2:	c9                   	leaveq 
  8020f3:	c3                   	retq   

00000000008020f4 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8020f4:	55                   	push   %rbp
  8020f5:	48 89 e5             	mov    %rsp,%rbp
  8020f8:	48 83 ec 40          	sub    $0x40,%rsp
  8020fc:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020ff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	struct Fsreq_read *req = &ipc->read;
  802103:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802107:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  80210b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80210f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	// so filling in ret will overwrite req.
	//
	// LAB 5: Your code here
	//panic("serve_read not implemented");
	struct OpenFile *po;
	int r = openfile_lookup(envid, req->req_fileid, &po);
  802113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802117:	8b 00                	mov    (%rax),%eax
  802119:	89 c1                	mov    %eax,%ecx
  80211b:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  80211f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802122:	89 ce                	mov    %ecx,%esi
  802124:	89 c7                	mov    %eax,%edi
  802126:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  80212d:	00 00 00 
  802130:	ff d0                	callq  *%rax
  802132:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (r < 0) {
  802135:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802139:	79 25                	jns    802160 <serve_read+0x6c>
		cprintf("somwthing wrong in lookup %e", r);
  80213b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80213e:	89 c6                	mov    %eax,%esi
  802140:	48 bf 80 6c 80 00 00 	movabs $0x806c80,%rdi
  802147:	00 00 00 
  80214a:	b8 00 00 00 00       	mov    $0x0,%eax
  80214f:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  802156:	00 00 00 
  802159:	ff d2                	callq  *%rdx
		return r;
  80215b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80215e:	eb 6f                	jmp    8021cf <serve_read+0xdb>
	}
	size_t req_size = (req->req_n < PGSIZE) ? req->req_n : PGSIZE;
  802160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802164:	48 8b 40 08          	mov    0x8(%rax),%rax
  802168:	ba 00 10 00 00       	mov    $0x1000,%edx
  80216d:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  802173:	48 0f 47 c2          	cmova  %rdx,%rax
  802177:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	ssize_t ret_size = file_read(po->o_file, ret->ret_buf, req_size, po->o_fd->fd_offset);
  80217b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80217f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802183:	8b 48 04             	mov    0x4(%rax),%ecx
  802186:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80218a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80218e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802192:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802196:	48 89 c7             	mov    %rax,%rdi
  802199:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  8021a0:	00 00 00 
  8021a3:	ff d0                	callq  *%rax
  8021a5:	89 45 dc             	mov    %eax,-0x24(%rbp)
	if(ret_size<0) {
  8021a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8021ac:	79 05                	jns    8021b3 <serve_read+0xbf>
		return ret_size;
  8021ae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021b1:	eb 1c                	jmp    8021cf <serve_read+0xdb>
	}
	po->o_fd->fd_offset += ret_size;
  8021b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021b7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021bb:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8021bf:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8021c3:	8b 52 04             	mov    0x4(%rdx),%edx
  8021c6:	03 55 dc             	add    -0x24(%rbp),%edx
  8021c9:	89 50 04             	mov    %edx,0x4(%rax)
	return ret_size;
  8021cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
  8021cf:	c9                   	leaveq 
  8021d0:	c3                   	retq   

00000000008021d1 <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  8021d1:	55                   	push   %rbp
  8021d2:	48 89 e5             	mov    %rsp,%rbp
  8021d5:	48 83 ec 10          	sub    $0x10,%rsp
  8021d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	panic("serve_write not implemented");
  8021e0:	48 ba 9d 6c 80 00 00 	movabs $0x806c9d,%rdx
  8021e7:	00 00 00 
  8021ea:	be f6 00 00 00       	mov    $0xf6,%esi
  8021ef:	48 bf b9 6c 80 00 00 	movabs $0x806cb9,%rdi
  8021f6:	00 00 00 
  8021f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fe:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  802205:	00 00 00 
  802208:	ff d1                	callq  *%rcx

000000000080220a <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  80220a:	55                   	push   %rbp
  80220b:	48 89 e5             	mov    %rsp,%rbp
  80220e:	48 83 ec 30          	sub    $0x30,%rsp
  802212:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802215:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  802219:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80221d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  802221:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802225:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80222d:	8b 00                	mov    (%rax),%eax
  80222f:	89 c1                	mov    %eax,%ecx
  802231:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802235:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802238:	89 ce                	mov    %ecx,%esi
  80223a:	89 c7                	mov    %eax,%edi
  80223c:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  802243:	00 00 00 
  802246:	ff d0                	callq  *%rax
  802248:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80224b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80224f:	79 05                	jns    802256 <serve_stat+0x4c>
		return r;
  802251:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802254:	eb 5f                	jmp    8022b5 <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  802256:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80225a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80225e:	48 89 c2             	mov    %rax,%rdx
  802261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802265:	48 89 d6             	mov    %rdx,%rsi
  802268:	48 89 c7             	mov    %rax,%rdi
  80226b:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  802272:	00 00 00 
  802275:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  802277:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80227b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80227f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802285:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802289:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  80228f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802293:	48 8b 40 08          	mov    0x8(%rax),%rax
  802297:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80229d:	83 f8 01             	cmp    $0x1,%eax
  8022a0:	0f 94 c0             	sete   %al
  8022a3:	0f b6 d0             	movzbl %al,%edx
  8022a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022aa:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8022b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b5:	c9                   	leaveq 
  8022b6:	c3                   	retq   

00000000008022b7 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8022b7:	55                   	push   %rbp
  8022b8:	48 89 e5             	mov    %rsp,%rbp
  8022bb:	48 83 ec 20          	sub    $0x20,%rsp
  8022bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8022c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ca:	8b 00                	mov    (%rax),%eax
  8022cc:	89 c1                	mov    %eax,%ecx
  8022ce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022d5:	89 ce                	mov    %ecx,%esi
  8022d7:	89 c7                	mov    %eax,%edi
  8022d9:	48 b8 31 1e 80 00 00 	movabs $0x801e31,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	callq  *%rax
  8022e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ec:	79 05                	jns    8022f3 <serve_flush+0x3c>
		return r;
  8022ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f1:	eb 1c                	jmp    80230f <serve_flush+0x58>
	file_flush(o->o_file);
  8022f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022fb:	48 89 c7             	mov    %rax,%rdi
  8022fe:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax
	return 0;
  80230a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230f:	c9                   	leaveq 
  802310:	c3                   	retq   

0000000000802311 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  802311:	55                   	push   %rbp
  802312:	48 89 e5             	mov    %rsp,%rbp
  802315:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  80231c:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  802322:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802329:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  802330:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802337:	ba 00 04 00 00       	mov    $0x400,%edx
  80233c:	48 89 ce             	mov    %rcx,%rsi
  80233f:	48 89 c7             	mov    %rax,%rdi
  802342:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  802349:	00 00 00 
  80234c:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  80234e:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  802352:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802359:	48 89 c7             	mov    %rax,%rdi
  80235c:	48 b8 97 1b 80 00 00 	movabs $0x801b97,%rax
  802363:	00 00 00 
  802366:	ff d0                	callq  *%rax
}
  802368:	c9                   	leaveq 
  802369:	c3                   	retq   

000000000080236a <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  80236a:	55                   	push   %rbp
  80236b:	48 89 e5             	mov    %rsp,%rbp
  80236e:	48 83 ec 10          	sub    $0x10,%rsp
  802372:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802375:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  802379:	48 b8 19 1c 80 00 00 	movabs $0x801c19,%rax
  802380:	00 00 00 
  802383:	ff d0                	callq  *%rax
	return 0;
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238a:	c9                   	leaveq 
  80238b:	c3                   	retq   

000000000080238c <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  80238c:	55                   	push   %rbp
  80238d:	48 89 e5             	mov    %rsp,%rbp
  802390:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  802394:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80239b:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  8023a2:	00 00 00 
  8023a5:	48 8b 08             	mov    (%rax),%rcx
  8023a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ac:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  8023b0:	48 89 ce             	mov    %rcx,%rsi
  8023b3:	48 89 c7             	mov    %rax,%rdi
  8023b6:	48 b8 f0 49 80 00 00 	movabs $0x8049f0,%rax
  8023bd:	00 00 00 
  8023c0:	ff d0                	callq  *%rax
  8023c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  8023c5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8023c8:	83 e0 01             	and    $0x1,%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	75 23                	jne    8023f2 <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  8023cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023d2:	89 c6                	mov    %eax,%esi
  8023d4:	48 bf c8 6c 80 00 00 	movabs $0x806cc8,%rdi
  8023db:	00 00 00 
  8023de:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e3:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  8023ea:	00 00 00 
  8023ed:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  8023ef:	90                   	nop
		}
		ipc_send(whom, r, pg, perm);
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
	}
  8023f0:	eb a2                	jmp    802394 <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  8023f2:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8023f9:	00 
		if (req == FSREQ_OPEN) {
  8023fa:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  8023fe:	75 2b                	jne    80242b <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  802400:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  802407:	00 00 00 
  80240a:	48 8b 30             	mov    (%rax),%rsi
  80240d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802410:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  802414:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802418:	89 c7                	mov    %eax,%edi
  80241a:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  802421:	00 00 00 
  802424:	ff d0                	callq  *%rax
  802426:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802429:	eb 73                	jmp    80249e <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  80242b:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  80242f:	77 43                	ja     802474 <serve+0xe8>
  802431:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  802438:	00 00 00 
  80243b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80243e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802442:	48 85 c0             	test   %rax,%rax
  802445:	74 2d                	je     802474 <serve+0xe8>
			r = handlers[req](whom, fsreq);
  802447:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  80244e:	00 00 00 
  802451:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802454:	48 8b 0c d0          	mov    (%rax,%rdx,8),%rcx
  802458:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  80245f:	00 00 00 
  802462:	48 8b 10             	mov    (%rax),%rdx
  802465:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802468:	48 89 d6             	mov    %rdx,%rsi
  80246b:	89 c7                	mov    %eax,%edi
  80246d:	ff d1                	callq  *%rcx
  80246f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802472:	eb 2a                	jmp    80249e <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  802474:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802477:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80247a:	89 c6                	mov    %eax,%esi
  80247c:	48 bf f8 6c 80 00 00 	movabs $0x806cf8,%rdi
  802483:	00 00 00 
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
  80248b:	48 b9 7b 30 80 00 00 	movabs $0x80307b,%rcx
  802492:	00 00 00 
  802495:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  802497:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  80249e:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  8024a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024a5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024ab:	89 c7                	mov    %eax,%edi
  8024ad:	48 b8 d7 4a 80 00 00 	movabs $0x804ad7,%rax
  8024b4:	00 00 00 
  8024b7:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  8024b9:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  8024c0:	00 00 00 
  8024c3:	48 8b 00             	mov    (%rax),%rax
  8024c6:	48 89 c6             	mov    %rax,%rsi
  8024c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ce:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  8024d5:	00 00 00 
  8024d8:	ff d0                	callq  *%rax
	}
  8024da:	e9 b5 fe ff ff       	jmpq   802394 <serve+0x8>

00000000008024df <umain>:
}

void
umain(int argc, char **argv)
{
  8024df:	55                   	push   %rbp
  8024e0:	48 89 e5             	mov    %rsp,%rbp
  8024e3:	48 83 ec 20          	sub    $0x20,%rsp
  8024e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8024ee:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  8024f5:	00 00 00 
  8024f8:	48 ba 1b 6d 80 00 00 	movabs $0x806d1b,%rdx
  8024ff:	00 00 00 
  802502:	48 89 10             	mov    %rdx,(%rax)
	cprintf("FS is running\n");
  802505:	48 bf 1e 6d 80 00 00 	movabs $0x806d1e,%rdi
  80250c:	00 00 00 
  80250f:	b8 00 00 00 00       	mov    $0x0,%eax
  802514:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  80251b:	00 00 00 
  80251e:	ff d2                	callq  *%rdx
  802520:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  802527:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

    static __inline void
outw(int port, uint16_t data)
{
    __asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80252d:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  802531:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802534:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  802536:	48 bf 2d 6d 80 00 00 	movabs $0x806d2d,%rdi
  80253d:	00 00 00 
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
  802545:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  80254c:	00 00 00 
  80254f:	ff d2                	callq  *%rdx

	serve_init();
  802551:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  802558:	00 00 00 
  80255b:	ff d0                	callq  *%rax
	fs_init();
  80255d:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
	serve();
  802569:	48 b8 8c 23 80 00 00 	movabs $0x80238c,%rax
  802570:	00 00 00 
  802573:	ff d0                	callq  *%rax
}
  802575:	c9                   	leaveq 
  802576:	c3                   	retq   
	...

0000000000802578 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802578:	55                   	push   %rbp
  802579:	48 89 e5             	mov    %rsp,%rbp
  80257c:	53                   	push   %rbx
  80257d:	48 83 ec 28          	sub    $0x28,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802581:	ba 07 00 00 00       	mov    $0x7,%edx
  802586:	be 00 10 00 00       	mov    $0x1000,%esi
  80258b:	bf 00 00 00 00       	mov    $0x0,%edi
  802590:	48 b8 84 45 80 00 00 	movabs $0x804584,%rax
  802597:	00 00 00 
  80259a:	ff d0                	callq  *%rax
  80259c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80259f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025a3:	79 30                	jns    8025d5 <fs_test+0x5d>
		panic("sys_page_alloc: %e", r);
  8025a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025a8:	89 c1                	mov    %eax,%ecx
  8025aa:	48 ba 66 6d 80 00 00 	movabs $0x806d66,%rdx
  8025b1:	00 00 00 
  8025b4:	be 13 00 00 00       	mov    $0x13,%esi
  8025b9:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  8025c0:	00 00 00 
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c8:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  8025cf:	00 00 00 
  8025d2:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  8025d5:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  8025dc:	00 
	memmove(bits, bitmap, PGSIZE);
  8025dd:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  8025e4:	00 00 00 
  8025e7:	48 8b 08             	mov    (%rax),%rcx
  8025ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025f3:	48 89 ce             	mov    %rcx,%rsi
  8025f6:	48 89 c7             	mov    %rax,%rdi
  8025f9:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  802605:	48 b8 dd 0c 80 00 00 	movabs $0x800cdd,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	callq  *%rax
  802611:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802614:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802618:	79 30                	jns    80264a <fs_test+0xd2>
		panic("alloc_block: %e", r);
  80261a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80261d:	89 c1                	mov    %eax,%ecx
  80261f:	48 ba 83 6d 80 00 00 	movabs $0x806d83,%rdx
  802626:	00 00 00 
  802629:	be 18 00 00 00       	mov    $0x18,%esi
  80262e:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802635:	00 00 00 
  802638:	b8 00 00 00 00       	mov    $0x0,%eax
  80263d:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802644:	00 00 00 
  802647:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  80264a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80264d:	8d 50 1f             	lea    0x1f(%rax),%edx
  802650:	85 c0                	test   %eax,%eax
  802652:	0f 48 c2             	cmovs  %edx,%eax
  802655:	c1 f8 05             	sar    $0x5,%eax
  802658:	48 98                	cltq   
  80265a:	48 c1 e0 02          	shl    $0x2,%rax
  80265e:	48 03 45 e0          	add    -0x20(%rbp),%rax
  802662:	8b 30                	mov    (%rax),%esi
  802664:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802667:	89 c2                	mov    %eax,%edx
  802669:	c1 fa 1f             	sar    $0x1f,%edx
  80266c:	c1 ea 1b             	shr    $0x1b,%edx
  80266f:	01 d0                	add    %edx,%eax
  802671:	83 e0 1f             	and    $0x1f,%eax
  802674:	29 d0                	sub    %edx,%eax
  802676:	ba 01 00 00 00       	mov    $0x1,%edx
  80267b:	89 d3                	mov    %edx,%ebx
  80267d:	89 c1                	mov    %eax,%ecx
  80267f:	d3 e3                	shl    %cl,%ebx
  802681:	89 d8                	mov    %ebx,%eax
  802683:	21 f0                	and    %esi,%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	75 35                	jne    8026be <fs_test+0x146>
  802689:	48 b9 93 6d 80 00 00 	movabs $0x806d93,%rcx
  802690:	00 00 00 
  802693:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  80269a:	00 00 00 
  80269d:	be 1a 00 00 00       	mov    $0x1a,%esi
  8026a2:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  8026a9:	00 00 00 
  8026ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b1:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  8026b8:	00 00 00 
  8026bb:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8026be:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  8026c5:	00 00 00 
  8026c8:	48 8b 10             	mov    (%rax),%rdx
  8026cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026ce:	8d 48 1f             	lea    0x1f(%rax),%ecx
  8026d1:	85 c0                	test   %eax,%eax
  8026d3:	0f 48 c1             	cmovs  %ecx,%eax
  8026d6:	c1 f8 05             	sar    $0x5,%eax
  8026d9:	48 98                	cltq   
  8026db:	48 c1 e0 02          	shl    $0x2,%rax
  8026df:	48 01 d0             	add    %rdx,%rax
  8026e2:	8b 30                	mov    (%rax),%esi
  8026e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026e7:	89 c2                	mov    %eax,%edx
  8026e9:	c1 fa 1f             	sar    $0x1f,%edx
  8026ec:	c1 ea 1b             	shr    $0x1b,%edx
  8026ef:	01 d0                	add    %edx,%eax
  8026f1:	83 e0 1f             	and    $0x1f,%eax
  8026f4:	29 d0                	sub    %edx,%eax
  8026f6:	ba 01 00 00 00       	mov    $0x1,%edx
  8026fb:	89 d3                	mov    %edx,%ebx
  8026fd:	89 c1                	mov    %eax,%ecx
  8026ff:	d3 e3                	shl    %cl,%ebx
  802701:	89 d8                	mov    %ebx,%eax
  802703:	21 f0                	and    %esi,%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	74 35                	je     80273e <fs_test+0x1c6>
  802709:	48 b9 c8 6d 80 00 00 	movabs $0x806dc8,%rcx
  802710:	00 00 00 
  802713:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  80271a:	00 00 00 
  80271d:	be 1c 00 00 00       	mov    $0x1c,%esi
  802722:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802729:	00 00 00 
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802738:	00 00 00 
  80273b:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  80273e:	48 bf e8 6d 80 00 00 	movabs $0x806de8,%rdi
  802745:	00 00 00 
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
  80274d:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  802754:	00 00 00 
  802757:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802759:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80275d:	48 89 c6             	mov    %rax,%rsi
  802760:	48 bf fd 6d 80 00 00 	movabs $0x806dfd,%rdi
  802767:	00 00 00 
  80276a:	48 b8 0f 16 80 00 00 	movabs $0x80160f,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802779:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80277d:	79 36                	jns    8027b5 <fs_test+0x23d>
  80277f:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  802783:	74 30                	je     8027b5 <fs_test+0x23d>
		panic("file_open /not-found: %e", r);
  802785:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802788:	89 c1                	mov    %eax,%ecx
  80278a:	48 ba 08 6e 80 00 00 	movabs $0x806e08,%rdx
  802791:	00 00 00 
  802794:	be 20 00 00 00       	mov    $0x20,%esi
  802799:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  8027a0:	00 00 00 
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  8027af:	00 00 00 
  8027b2:	41 ff d0             	callq  *%r8
	else if (r == 0)
  8027b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027b9:	75 2a                	jne    8027e5 <fs_test+0x26d>
		panic("file_open /not-found succeeded!");
  8027bb:	48 ba 28 6e 80 00 00 	movabs $0x806e28,%rdx
  8027c2:	00 00 00 
  8027c5:	be 22 00 00 00       	mov    $0x22,%esi
  8027ca:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  8027d1:	00 00 00 
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  8027e0:	00 00 00 
  8027e3:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  8027e5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8027e9:	48 89 c6             	mov    %rax,%rsi
  8027ec:	48 bf 48 6e 80 00 00 	movabs $0x806e48,%rdi
  8027f3:	00 00 00 
  8027f6:	48 b8 0f 16 80 00 00 	movabs $0x80160f,%rax
  8027fd:	00 00 00 
  802800:	ff d0                	callq  *%rax
  802802:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802805:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802809:	79 30                	jns    80283b <fs_test+0x2c3>
		panic("file_open /newmotd: %e", r);
  80280b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80280e:	89 c1                	mov    %eax,%ecx
  802810:	48 ba 51 6e 80 00 00 	movabs $0x806e51,%rdx
  802817:	00 00 00 
  80281a:	be 24 00 00 00       	mov    $0x24,%esi
  80281f:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802826:	00 00 00 
  802829:	b8 00 00 00 00       	mov    $0x0,%eax
  80282e:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802835:	00 00 00 
  802838:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  80283b:	48 bf 68 6e 80 00 00 	movabs $0x806e68,%rdi
  802842:	00 00 00 
  802845:	b8 00 00 00 00       	mov    $0x0,%eax
  80284a:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  802851:	00 00 00 
  802854:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80285a:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  80285e:	be 00 00 00 00       	mov    $0x0,%esi
  802863:	48 89 c7             	mov    %rax,%rdi
  802866:	48 b8 a7 0f 80 00 00 	movabs $0x800fa7,%rax
  80286d:	00 00 00 
  802870:	ff d0                	callq  *%rax
  802872:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802875:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802879:	79 30                	jns    8028ab <fs_test+0x333>
		panic("file_get_block: %e", r);
  80287b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80287e:	89 c1                	mov    %eax,%ecx
  802880:	48 ba 7b 6e 80 00 00 	movabs $0x806e7b,%rdx
  802887:	00 00 00 
  80288a:	be 28 00 00 00       	mov    $0x28,%esi
  80288f:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802896:	00 00 00 
  802899:	b8 00 00 00 00       	mov    $0x0,%eax
  80289e:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  8028a5:	00 00 00 
  8028a8:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  8028ab:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  8028b2:	00 00 00 
  8028b5:	48 8b 10             	mov    (%rax),%rdx
  8028b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028bc:	48 89 d6             	mov    %rdx,%rsi
  8028bf:	48 89 c7             	mov    %rax,%rdi
  8028c2:	48 b8 a7 3d 80 00 00 	movabs $0x803da7,%rax
  8028c9:	00 00 00 
  8028cc:	ff d0                	callq  *%rax
  8028ce:	85 c0                	test   %eax,%eax
  8028d0:	74 2a                	je     8028fc <fs_test+0x384>
		panic("file_get_block returned wrong data");
  8028d2:	48 ba 90 6e 80 00 00 	movabs $0x806e90,%rdx
  8028d9:	00 00 00 
  8028dc:	be 2a 00 00 00       	mov    $0x2a,%esi
  8028e1:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  8028e8:	00 00 00 
  8028eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f0:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  8028f7:	00 00 00 
  8028fa:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  8028fc:	48 bf b3 6e 80 00 00 	movabs $0x806eb3,%rdi
  802903:	00 00 00 
  802906:	b8 00 00 00 00       	mov    $0x0,%eax
  80290b:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  802912:	00 00 00 
  802915:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802917:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80291b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80291f:	0f b6 12             	movzbl (%rdx),%edx
  802922:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802924:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802928:	48 89 c2             	mov    %rax,%rdx
  80292b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80292f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802936:	01 00 00 
  802939:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80293d:	83 e0 40             	and    $0x40,%eax
  802940:	48 85 c0             	test   %rax,%rax
  802943:	75 35                	jne    80297a <fs_test+0x402>
  802945:	48 b9 cb 6e 80 00 00 	movabs $0x806ecb,%rcx
  80294c:	00 00 00 
  80294f:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  802956:	00 00 00 
  802959:	be 2e 00 00 00       	mov    $0x2e,%esi
  80295e:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802965:	00 00 00 
  802968:	b8 00 00 00 00       	mov    $0x0,%eax
  80296d:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802974:	00 00 00 
  802977:	41 ff d0             	callq  *%r8
	file_flush(f);
  80297a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80297e:	48 89 c7             	mov    %rax,%rdi
  802981:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  802988:	00 00 00 
  80298b:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80298d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802991:	48 89 c2             	mov    %rax,%rdx
  802994:	48 c1 ea 0c          	shr    $0xc,%rdx
  802998:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80299f:	01 00 00 
  8029a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029a6:	83 e0 40             	and    $0x40,%eax
  8029a9:	48 85 c0             	test   %rax,%rax
  8029ac:	74 35                	je     8029e3 <fs_test+0x46b>
  8029ae:	48 b9 e6 6e 80 00 00 	movabs $0x806ee6,%rcx
  8029b5:	00 00 00 
  8029b8:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  8029bf:	00 00 00 
  8029c2:	be 30 00 00 00       	mov    $0x30,%esi
  8029c7:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  8029ce:	00 00 00 
  8029d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d6:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  8029dd:	00 00 00 
  8029e0:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  8029e3:	48 bf 02 6f 80 00 00 	movabs $0x806f02,%rdi
  8029ea:	00 00 00 
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f2:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  8029f9:	00 00 00 
  8029fc:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  8029fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a02:	be 00 00 00 00       	mov    $0x0,%esi
  802a07:	48 89 c7             	mov    %rax,%rdi
  802a0a:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  802a11:	00 00 00 
  802a14:	ff d0                	callq  *%rax
  802a16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a19:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a1d:	79 30                	jns    802a4f <fs_test+0x4d7>
		panic("file_set_size: %e", r);
  802a1f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a22:	89 c1                	mov    %eax,%ecx
  802a24:	48 ba 16 6f 80 00 00 	movabs $0x806f16,%rdx
  802a2b:	00 00 00 
  802a2e:	be 34 00 00 00       	mov    $0x34,%esi
  802a33:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802a3a:	00 00 00 
  802a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a42:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802a49:	00 00 00 
  802a4c:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802a4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a53:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	74 35                	je     802a92 <fs_test+0x51a>
  802a5d:	48 b9 28 6f 80 00 00 	movabs $0x806f28,%rcx
  802a64:	00 00 00 
  802a67:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  802a6e:	00 00 00 
  802a71:	be 35 00 00 00       	mov    $0x35,%esi
  802a76:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802a7d:	00 00 00 
  802a80:	b8 00 00 00 00       	mov    $0x0,%eax
  802a85:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802a8c:	00 00 00 
  802a8f:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802a92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a96:	48 89 c2             	mov    %rax,%rdx
  802a99:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a9d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802aa4:	01 00 00 
  802aa7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aab:	83 e0 40             	and    $0x40,%eax
  802aae:	48 85 c0             	test   %rax,%rax
  802ab1:	74 35                	je     802ae8 <fs_test+0x570>
  802ab3:	48 b9 3c 6f 80 00 00 	movabs $0x806f3c,%rcx
  802aba:	00 00 00 
  802abd:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  802ac4:	00 00 00 
  802ac7:	be 36 00 00 00       	mov    $0x36,%esi
  802acc:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802ad3:	00 00 00 
  802ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  802adb:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802ae2:	00 00 00 
  802ae5:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802ae8:	48 bf 56 6f 80 00 00 	movabs $0x806f56,%rdi
  802aef:	00 00 00 
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
  802af7:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  802afe:	00 00 00 
  802b01:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802b03:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802b0a:	00 00 00 
  802b0d:	48 8b 00             	mov    (%rax),%rax
  802b10:	48 89 c7             	mov    %rax,%rdi
  802b13:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
  802b1f:	89 c2                	mov    %eax,%edx
  802b21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b25:	89 d6                	mov    %edx,%esi
  802b27:	48 89 c7             	mov    %rax,%rdi
  802b2a:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  802b31:	00 00 00 
  802b34:	ff d0                	callq  *%rax
  802b36:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b39:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b3d:	79 30                	jns    802b6f <fs_test+0x5f7>
		panic("file_set_size 2: %e", r);
  802b3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b42:	89 c1                	mov    %eax,%ecx
  802b44:	48 ba 6d 6f 80 00 00 	movabs $0x806f6d,%rdx
  802b4b:	00 00 00 
  802b4e:	be 3a 00 00 00       	mov    $0x3a,%esi
  802b53:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802b5a:	00 00 00 
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b62:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802b69:	00 00 00 
  802b6c:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802b6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b73:	48 89 c2             	mov    %rax,%rdx
  802b76:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b7a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b81:	01 00 00 
  802b84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b88:	83 e0 40             	and    $0x40,%eax
  802b8b:	48 85 c0             	test   %rax,%rax
  802b8e:	74 35                	je     802bc5 <fs_test+0x64d>
  802b90:	48 b9 3c 6f 80 00 00 	movabs $0x806f3c,%rcx
  802b97:	00 00 00 
  802b9a:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  802ba1:	00 00 00 
  802ba4:	be 3b 00 00 00       	mov    $0x3b,%esi
  802ba9:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802bb0:	00 00 00 
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb8:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802bbf:	00 00 00 
  802bc2:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802bc5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc9:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  802bcd:	be 00 00 00 00       	mov    $0x0,%esi
  802bd2:	48 89 c7             	mov    %rax,%rdi
  802bd5:	48 b8 a7 0f 80 00 00 	movabs $0x800fa7,%rax
  802bdc:	00 00 00 
  802bdf:	ff d0                	callq  *%rax
  802be1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802be4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802be8:	79 30                	jns    802c1a <fs_test+0x6a2>
		panic("file_get_block 2: %e", r);
  802bea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bed:	89 c1                	mov    %eax,%ecx
  802bef:	48 ba 81 6f 80 00 00 	movabs $0x806f81,%rdx
  802bf6:	00 00 00 
  802bf9:	be 3d 00 00 00       	mov    $0x3d,%esi
  802bfe:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802c05:	00 00 00 
  802c08:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0d:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802c14:	00 00 00 
  802c17:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  802c1a:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802c21:	00 00 00 
  802c24:	48 8b 10             	mov    (%rax),%rdx
  802c27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c2b:	48 89 d6             	mov    %rdx,%rsi
  802c2e:	48 89 c7             	mov    %rax,%rdi
  802c31:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  802c38:	00 00 00 
  802c3b:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802c3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c41:	48 89 c2             	mov    %rax,%rdx
  802c44:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c48:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c4f:	01 00 00 
  802c52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c56:	83 e0 40             	and    $0x40,%eax
  802c59:	48 85 c0             	test   %rax,%rax
  802c5c:	75 35                	jne    802c93 <fs_test+0x71b>
  802c5e:	48 b9 cb 6e 80 00 00 	movabs $0x806ecb,%rcx
  802c65:	00 00 00 
  802c68:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  802c6f:	00 00 00 
  802c72:	be 3f 00 00 00       	mov    $0x3f,%esi
  802c77:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802c7e:	00 00 00 
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802c8d:	00 00 00 
  802c90:	41 ff d0             	callq  *%r8
	file_flush(f);
  802c93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c97:	48 89 c7             	mov    %rax,%rdi
  802c9a:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  802ca1:	00 00 00 
  802ca4:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802ca6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802caa:	48 89 c2             	mov    %rax,%rdx
  802cad:	48 c1 ea 0c          	shr    $0xc,%rdx
  802cb1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cb8:	01 00 00 
  802cbb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cbf:	83 e0 40             	and    $0x40,%eax
  802cc2:	48 85 c0             	test   %rax,%rax
  802cc5:	74 35                	je     802cfc <fs_test+0x784>
  802cc7:	48 b9 e6 6e 80 00 00 	movabs $0x806ee6,%rcx
  802cce:	00 00 00 
  802cd1:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  802cd8:	00 00 00 
  802cdb:	be 41 00 00 00       	mov    $0x41,%esi
  802ce0:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802ce7:	00 00 00 
  802cea:	b8 00 00 00 00       	mov    $0x0,%eax
  802cef:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802cf6:	00 00 00 
  802cf9:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802cfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d00:	48 89 c2             	mov    %rax,%rdx
  802d03:	48 c1 ea 0c          	shr    $0xc,%rdx
  802d07:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d0e:	01 00 00 
  802d11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d15:	83 e0 40             	and    $0x40,%eax
  802d18:	48 85 c0             	test   %rax,%rax
  802d1b:	74 35                	je     802d52 <fs_test+0x7da>
  802d1d:	48 b9 3c 6f 80 00 00 	movabs $0x806f3c,%rcx
  802d24:	00 00 00 
  802d27:	48 ba ae 6d 80 00 00 	movabs $0x806dae,%rdx
  802d2e:	00 00 00 
  802d31:	be 42 00 00 00       	mov    $0x42,%esi
  802d36:	48 bf 79 6d 80 00 00 	movabs $0x806d79,%rdi
  802d3d:	00 00 00 
  802d40:	b8 00 00 00 00       	mov    $0x0,%eax
  802d45:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  802d4c:	00 00 00 
  802d4f:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  802d52:	48 bf 96 6f 80 00 00 	movabs $0x806f96,%rdi
  802d59:	00 00 00 
  802d5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d61:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  802d68:	00 00 00 
  802d6b:	ff d2                	callq  *%rdx
}
  802d6d:	48 83 c4 28          	add    $0x28,%rsp
  802d71:	5b                   	pop    %rbx
  802d72:	5d                   	pop    %rbp
  802d73:	c3                   	retq   

0000000000802d74 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  802d74:	55                   	push   %rbp
  802d75:	48 89 e5             	mov    %rsp,%rbp
  802d78:	48 83 ec 10          	sub    $0x10,%rsp
  802d7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  802d83:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  802d8a:	00 00 00 
  802d8d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  802d94:	48 b8 08 45 80 00 00 	movabs $0x804508,%rax
  802d9b:	00 00 00 
  802d9e:	ff d0                	callq  *%rax
  802da0:	48 98                	cltq   
  802da2:	48 89 c2             	mov    %rax,%rdx
  802da5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802dab:	48 89 d0             	mov    %rdx,%rax
  802dae:	48 c1 e0 02          	shl    $0x2,%rax
  802db2:	48 01 d0             	add    %rdx,%rax
  802db5:	48 01 c0             	add    %rax,%rax
  802db8:	48 01 d0             	add    %rdx,%rax
  802dbb:	48 c1 e0 05          	shl    $0x5,%rax
  802dbf:	48 89 c2             	mov    %rax,%rdx
  802dc2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802dc9:	00 00 00 
  802dcc:	48 01 c2             	add    %rax,%rdx
  802dcf:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  802dd6:	00 00 00 
  802dd9:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  802ddc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de0:	7e 14                	jle    802df6 <libmain+0x82>
		binaryname = argv[0];
  802de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de6:	48 8b 10             	mov    (%rax),%rdx
  802de9:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  802df0:	00 00 00 
  802df3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  802df6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfd:	48 89 d6             	mov    %rdx,%rsi
  802e00:	89 c7                	mov    %eax,%edi
  802e02:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  802e0e:	48 b8 1c 2e 80 00 00 	movabs $0x802e1c,%rax
  802e15:	00 00 00 
  802e18:	ff d0                	callq  *%rax
}
  802e1a:	c9                   	leaveq 
  802e1b:	c3                   	retq   

0000000000802e1c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  802e1c:	55                   	push   %rbp
  802e1d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  802e20:	48 b8 55 4f 80 00 00 	movabs $0x804f55,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  802e2c:	bf 00 00 00 00       	mov    $0x0,%edi
  802e31:	48 b8 c4 44 80 00 00 	movabs $0x8044c4,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax
}
  802e3d:	5d                   	pop    %rbp
  802e3e:	c3                   	retq   
	...

0000000000802e40 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802e40:	55                   	push   %rbp
  802e41:	48 89 e5             	mov    %rsp,%rbp
  802e44:	53                   	push   %rbx
  802e45:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802e4c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802e53:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802e59:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802e60:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802e67:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802e6e:	84 c0                	test   %al,%al
  802e70:	74 23                	je     802e95 <_panic+0x55>
  802e72:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802e79:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802e7d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802e81:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802e85:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802e89:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802e8d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802e91:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802e95:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802e9c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802ea3:	00 00 00 
  802ea6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802ead:	00 00 00 
  802eb0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802eb4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802ebb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802ec2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802ec9:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  802ed0:	00 00 00 
  802ed3:	48 8b 18             	mov    (%rax),%rbx
  802ed6:	48 b8 08 45 80 00 00 	movabs $0x804508,%rax
  802edd:	00 00 00 
  802ee0:	ff d0                	callq  *%rax
  802ee2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802ee8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802eef:	41 89 c8             	mov    %ecx,%r8d
  802ef2:	48 89 d1             	mov    %rdx,%rcx
  802ef5:	48 89 da             	mov    %rbx,%rdx
  802ef8:	89 c6                	mov    %eax,%esi
  802efa:	48 bf b8 6f 80 00 00 	movabs $0x806fb8,%rdi
  802f01:	00 00 00 
  802f04:	b8 00 00 00 00       	mov    $0x0,%eax
  802f09:	49 b9 7b 30 80 00 00 	movabs $0x80307b,%r9
  802f10:	00 00 00 
  802f13:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802f16:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802f1d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802f24:	48 89 d6             	mov    %rdx,%rsi
  802f27:	48 89 c7             	mov    %rax,%rdi
  802f2a:	48 b8 cf 2f 80 00 00 	movabs $0x802fcf,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	callq  *%rax
	cprintf("\n");
  802f36:	48 bf db 6f 80 00 00 	movabs $0x806fdb,%rdi
  802f3d:	00 00 00 
  802f40:	b8 00 00 00 00       	mov    $0x0,%eax
  802f45:	48 ba 7b 30 80 00 00 	movabs $0x80307b,%rdx
  802f4c:	00 00 00 
  802f4f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802f51:	cc                   	int3   
  802f52:	eb fd                	jmp    802f51 <_panic+0x111>

0000000000802f54 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  802f54:	55                   	push   %rbp
  802f55:	48 89 e5             	mov    %rsp,%rbp
  802f58:	48 83 ec 10          	sub    $0x10,%rsp
  802f5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  802f63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f67:	8b 00                	mov    (%rax),%eax
  802f69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f6c:	89 d6                	mov    %edx,%esi
  802f6e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f72:	48 63 d0             	movslq %eax,%rdx
  802f75:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  802f7a:	8d 50 01             	lea    0x1(%rax),%edx
  802f7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f81:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  802f83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f87:	8b 00                	mov    (%rax),%eax
  802f89:	3d ff 00 00 00       	cmp    $0xff,%eax
  802f8e:	75 2c                	jne    802fbc <putch+0x68>
        sys_cputs(b->buf, b->idx);
  802f90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f94:	8b 00                	mov    (%rax),%eax
  802f96:	48 98                	cltq   
  802f98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f9c:	48 83 c2 08          	add    $0x8,%rdx
  802fa0:	48 89 c6             	mov    %rax,%rsi
  802fa3:	48 89 d7             	mov    %rdx,%rdi
  802fa6:	48 b8 3c 44 80 00 00 	movabs $0x80443c,%rax
  802fad:	00 00 00 
  802fb0:	ff d0                	callq  *%rax
        b->idx = 0;
  802fb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc0:	8b 40 04             	mov    0x4(%rax),%eax
  802fc3:	8d 50 01             	lea    0x1(%rax),%edx
  802fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fca:	89 50 04             	mov    %edx,0x4(%rax)
}
  802fcd:	c9                   	leaveq 
  802fce:	c3                   	retq   

0000000000802fcf <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  802fcf:	55                   	push   %rbp
  802fd0:	48 89 e5             	mov    %rsp,%rbp
  802fd3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802fda:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802fe1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802fe8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802fef:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802ff6:	48 8b 0a             	mov    (%rdx),%rcx
  802ff9:	48 89 08             	mov    %rcx,(%rax)
  802ffc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803000:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803004:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803008:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80300c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  803013:	00 00 00 
    b.cnt = 0;
  803016:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80301d:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  803020:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  803027:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80302e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803035:	48 89 c6             	mov    %rax,%rsi
  803038:	48 bf 54 2f 80 00 00 	movabs $0x802f54,%rdi
  80303f:	00 00 00 
  803042:	48 b8 2c 34 80 00 00 	movabs $0x80342c,%rax
  803049:	00 00 00 
  80304c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80304e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  803054:	48 98                	cltq   
  803056:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80305d:	48 83 c2 08          	add    $0x8,%rdx
  803061:	48 89 c6             	mov    %rax,%rsi
  803064:	48 89 d7             	mov    %rdx,%rdi
  803067:	48 b8 3c 44 80 00 00 	movabs $0x80443c,%rax
  80306e:	00 00 00 
  803071:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  803073:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  803079:	c9                   	leaveq 
  80307a:	c3                   	retq   

000000000080307b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80307b:	55                   	push   %rbp
  80307c:	48 89 e5             	mov    %rsp,%rbp
  80307f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  803086:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80308d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803094:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80309b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8030a2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8030a9:	84 c0                	test   %al,%al
  8030ab:	74 20                	je     8030cd <cprintf+0x52>
  8030ad:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8030b1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8030b5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030b9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030bd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030c1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8030c5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8030c9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8030cd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8030d4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8030db:	00 00 00 
  8030de:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030e5:	00 00 00 
  8030e8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030ec:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030f3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030fa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  803101:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803108:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80310f:	48 8b 0a             	mov    (%rdx),%rcx
  803112:	48 89 08             	mov    %rcx,(%rax)
  803115:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803119:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80311d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803121:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  803125:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80312c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803133:	48 89 d6             	mov    %rdx,%rsi
  803136:	48 89 c7             	mov    %rax,%rdi
  803139:	48 b8 cf 2f 80 00 00 	movabs $0x802fcf,%rax
  803140:	00 00 00 
  803143:	ff d0                	callq  *%rax
  803145:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80314b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803151:	c9                   	leaveq 
  803152:	c3                   	retq   
	...

0000000000803154 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  803154:	55                   	push   %rbp
  803155:	48 89 e5             	mov    %rsp,%rbp
  803158:	48 83 ec 30          	sub    $0x30,%rsp
  80315c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803160:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803164:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803168:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80316b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80316f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803173:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803176:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80317a:	77 52                	ja     8031ce <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80317c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80317f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  803183:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803186:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80318a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80318e:	ba 00 00 00 00       	mov    $0x0,%edx
  803193:	48 f7 75 d0          	divq   -0x30(%rbp)
  803197:	48 89 c2             	mov    %rax,%rdx
  80319a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80319d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8031a0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a8:	41 89 f9             	mov    %edi,%r9d
  8031ab:	48 89 c7             	mov    %rax,%rdi
  8031ae:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  8031b5:	00 00 00 
  8031b8:	ff d0                	callq  *%rax
  8031ba:	eb 1c                	jmp    8031d8 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8031bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031c0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031c3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8031c7:	48 89 d6             	mov    %rdx,%rsi
  8031ca:	89 c7                	mov    %eax,%edi
  8031cc:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8031ce:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8031d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8031d6:	7f e4                	jg     8031bc <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8031d8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8031db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031df:	ba 00 00 00 00       	mov    $0x0,%edx
  8031e4:	48 f7 f1             	div    %rcx
  8031e7:	48 89 d0             	mov    %rdx,%rax
  8031ea:	48 ba d0 71 80 00 00 	movabs $0x8071d0,%rdx
  8031f1:	00 00 00 
  8031f4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8031f8:	0f be c0             	movsbl %al,%eax
  8031fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031ff:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803203:	48 89 d6             	mov    %rdx,%rsi
  803206:	89 c7                	mov    %eax,%edi
  803208:	ff d1                	callq  *%rcx
}
  80320a:	c9                   	leaveq 
  80320b:	c3                   	retq   

000000000080320c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80320c:	55                   	push   %rbp
  80320d:	48 89 e5             	mov    %rsp,%rbp
  803210:	48 83 ec 20          	sub    $0x20,%rsp
  803214:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803218:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80321b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80321f:	7e 52                	jle    803273 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  803221:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803225:	8b 00                	mov    (%rax),%eax
  803227:	83 f8 30             	cmp    $0x30,%eax
  80322a:	73 24                	jae    803250 <getuint+0x44>
  80322c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803230:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803234:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803238:	8b 00                	mov    (%rax),%eax
  80323a:	89 c0                	mov    %eax,%eax
  80323c:	48 01 d0             	add    %rdx,%rax
  80323f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803243:	8b 12                	mov    (%rdx),%edx
  803245:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803248:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80324c:	89 0a                	mov    %ecx,(%rdx)
  80324e:	eb 17                	jmp    803267 <getuint+0x5b>
  803250:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803254:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803258:	48 89 d0             	mov    %rdx,%rax
  80325b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80325f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803263:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803267:	48 8b 00             	mov    (%rax),%rax
  80326a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80326e:	e9 a3 00 00 00       	jmpq   803316 <getuint+0x10a>
	else if (lflag)
  803273:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803277:	74 4f                	je     8032c8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  803279:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327d:	8b 00                	mov    (%rax),%eax
  80327f:	83 f8 30             	cmp    $0x30,%eax
  803282:	73 24                	jae    8032a8 <getuint+0x9c>
  803284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803288:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80328c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803290:	8b 00                	mov    (%rax),%eax
  803292:	89 c0                	mov    %eax,%eax
  803294:	48 01 d0             	add    %rdx,%rax
  803297:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80329b:	8b 12                	mov    (%rdx),%edx
  80329d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8032a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032a4:	89 0a                	mov    %ecx,(%rdx)
  8032a6:	eb 17                	jmp    8032bf <getuint+0xb3>
  8032a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8032b0:	48 89 d0             	mov    %rdx,%rax
  8032b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8032b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8032bf:	48 8b 00             	mov    (%rax),%rax
  8032c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8032c6:	eb 4e                	jmp    803316 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8032c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032cc:	8b 00                	mov    (%rax),%eax
  8032ce:	83 f8 30             	cmp    $0x30,%eax
  8032d1:	73 24                	jae    8032f7 <getuint+0xeb>
  8032d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8032db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032df:	8b 00                	mov    (%rax),%eax
  8032e1:	89 c0                	mov    %eax,%eax
  8032e3:	48 01 d0             	add    %rdx,%rax
  8032e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032ea:	8b 12                	mov    (%rdx),%edx
  8032ec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8032ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032f3:	89 0a                	mov    %ecx,(%rdx)
  8032f5:	eb 17                	jmp    80330e <getuint+0x102>
  8032f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032fb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8032ff:	48 89 d0             	mov    %rdx,%rax
  803302:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803306:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80330a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80330e:	8b 00                	mov    (%rax),%eax
  803310:	89 c0                	mov    %eax,%eax
  803312:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80331a:	c9                   	leaveq 
  80331b:	c3                   	retq   

000000000080331c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80331c:	55                   	push   %rbp
  80331d:	48 89 e5             	mov    %rsp,%rbp
  803320:	48 83 ec 20          	sub    $0x20,%rsp
  803324:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803328:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80332b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80332f:	7e 52                	jle    803383 <getint+0x67>
		x=va_arg(*ap, long long);
  803331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803335:	8b 00                	mov    (%rax),%eax
  803337:	83 f8 30             	cmp    $0x30,%eax
  80333a:	73 24                	jae    803360 <getint+0x44>
  80333c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803340:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803348:	8b 00                	mov    (%rax),%eax
  80334a:	89 c0                	mov    %eax,%eax
  80334c:	48 01 d0             	add    %rdx,%rax
  80334f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803353:	8b 12                	mov    (%rdx),%edx
  803355:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803358:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80335c:	89 0a                	mov    %ecx,(%rdx)
  80335e:	eb 17                	jmp    803377 <getint+0x5b>
  803360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803364:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803368:	48 89 d0             	mov    %rdx,%rax
  80336b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80336f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803373:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803377:	48 8b 00             	mov    (%rax),%rax
  80337a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80337e:	e9 a3 00 00 00       	jmpq   803426 <getint+0x10a>
	else if (lflag)
  803383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803387:	74 4f                	je     8033d8 <getint+0xbc>
		x=va_arg(*ap, long);
  803389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80338d:	8b 00                	mov    (%rax),%eax
  80338f:	83 f8 30             	cmp    $0x30,%eax
  803392:	73 24                	jae    8033b8 <getint+0x9c>
  803394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803398:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80339c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a0:	8b 00                	mov    (%rax),%eax
  8033a2:	89 c0                	mov    %eax,%eax
  8033a4:	48 01 d0             	add    %rdx,%rax
  8033a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033ab:	8b 12                	mov    (%rdx),%edx
  8033ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8033b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033b4:	89 0a                	mov    %ecx,(%rdx)
  8033b6:	eb 17                	jmp    8033cf <getint+0xb3>
  8033b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033bc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8033c0:	48 89 d0             	mov    %rdx,%rax
  8033c3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8033c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8033cf:	48 8b 00             	mov    (%rax),%rax
  8033d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8033d6:	eb 4e                	jmp    803426 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8033d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033dc:	8b 00                	mov    (%rax),%eax
  8033de:	83 f8 30             	cmp    $0x30,%eax
  8033e1:	73 24                	jae    803407 <getint+0xeb>
  8033e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8033eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ef:	8b 00                	mov    (%rax),%eax
  8033f1:	89 c0                	mov    %eax,%eax
  8033f3:	48 01 d0             	add    %rdx,%rax
  8033f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033fa:	8b 12                	mov    (%rdx),%edx
  8033fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8033ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803403:	89 0a                	mov    %ecx,(%rdx)
  803405:	eb 17                	jmp    80341e <getint+0x102>
  803407:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80340b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80340f:	48 89 d0             	mov    %rdx,%rax
  803412:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803416:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80341a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80341e:	8b 00                	mov    (%rax),%eax
  803420:	48 98                	cltq   
  803422:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80342a:	c9                   	leaveq 
  80342b:	c3                   	retq   

000000000080342c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80342c:	55                   	push   %rbp
  80342d:	48 89 e5             	mov    %rsp,%rbp
  803430:	41 54                	push   %r12
  803432:	53                   	push   %rbx
  803433:	48 83 ec 60          	sub    $0x60,%rsp
  803437:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80343b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80343f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803443:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803447:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80344b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80344f:	48 8b 0a             	mov    (%rdx),%rcx
  803452:	48 89 08             	mov    %rcx,(%rax)
  803455:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803459:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80345d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803461:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803465:	eb 17                	jmp    80347e <vprintfmt+0x52>
			if (ch == '\0')
  803467:	85 db                	test   %ebx,%ebx
  803469:	0f 84 ea 04 00 00    	je     803959 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  80346f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803473:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803477:	48 89 c6             	mov    %rax,%rsi
  80347a:	89 df                	mov    %ebx,%edi
  80347c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80347e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803482:	0f b6 00             	movzbl (%rax),%eax
  803485:	0f b6 d8             	movzbl %al,%ebx
  803488:	83 fb 25             	cmp    $0x25,%ebx
  80348b:	0f 95 c0             	setne  %al
  80348e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  803493:	84 c0                	test   %al,%al
  803495:	75 d0                	jne    803467 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803497:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80349b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8034a2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8034a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8034b0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8034b7:	eb 04                	jmp    8034bd <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8034b9:	90                   	nop
  8034ba:	eb 01                	jmp    8034bd <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8034bc:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8034bd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8034c1:	0f b6 00             	movzbl (%rax),%eax
  8034c4:	0f b6 d8             	movzbl %al,%ebx
  8034c7:	89 d8                	mov    %ebx,%eax
  8034c9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8034ce:	83 e8 23             	sub    $0x23,%eax
  8034d1:	83 f8 55             	cmp    $0x55,%eax
  8034d4:	0f 87 4b 04 00 00    	ja     803925 <vprintfmt+0x4f9>
  8034da:	89 c0                	mov    %eax,%eax
  8034dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034e3:	00 
  8034e4:	48 b8 f8 71 80 00 00 	movabs $0x8071f8,%rax
  8034eb:	00 00 00 
  8034ee:	48 01 d0             	add    %rdx,%rax
  8034f1:	48 8b 00             	mov    (%rax),%rax
  8034f4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8034f6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8034fa:	eb c1                	jmp    8034bd <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8034fc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803500:	eb bb                	jmp    8034bd <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803502:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803509:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80350c:	89 d0                	mov    %edx,%eax
  80350e:	c1 e0 02             	shl    $0x2,%eax
  803511:	01 d0                	add    %edx,%eax
  803513:	01 c0                	add    %eax,%eax
  803515:	01 d8                	add    %ebx,%eax
  803517:	83 e8 30             	sub    $0x30,%eax
  80351a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80351d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803521:	0f b6 00             	movzbl (%rax),%eax
  803524:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  803527:	83 fb 2f             	cmp    $0x2f,%ebx
  80352a:	7e 63                	jle    80358f <vprintfmt+0x163>
  80352c:	83 fb 39             	cmp    $0x39,%ebx
  80352f:	7f 5e                	jg     80358f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803531:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  803536:	eb d1                	jmp    803509 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  803538:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80353b:	83 f8 30             	cmp    $0x30,%eax
  80353e:	73 17                	jae    803557 <vprintfmt+0x12b>
  803540:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803544:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803547:	89 c0                	mov    %eax,%eax
  803549:	48 01 d0             	add    %rdx,%rax
  80354c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80354f:	83 c2 08             	add    $0x8,%edx
  803552:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803555:	eb 0f                	jmp    803566 <vprintfmt+0x13a>
  803557:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80355b:	48 89 d0             	mov    %rdx,%rax
  80355e:	48 83 c2 08          	add    $0x8,%rdx
  803562:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803566:	8b 00                	mov    (%rax),%eax
  803568:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80356b:	eb 23                	jmp    803590 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  80356d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803571:	0f 89 42 ff ff ff    	jns    8034b9 <vprintfmt+0x8d>
				width = 0;
  803577:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80357e:	e9 36 ff ff ff       	jmpq   8034b9 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  803583:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80358a:	e9 2e ff ff ff       	jmpq   8034bd <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80358f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  803590:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803594:	0f 89 22 ff ff ff    	jns    8034bc <vprintfmt+0x90>
				width = precision, precision = -1;
  80359a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80359d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8035a0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8035a7:	e9 10 ff ff ff       	jmpq   8034bc <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8035ac:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8035b0:	e9 08 ff ff ff       	jmpq   8034bd <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8035b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8035b8:	83 f8 30             	cmp    $0x30,%eax
  8035bb:	73 17                	jae    8035d4 <vprintfmt+0x1a8>
  8035bd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8035c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8035c4:	89 c0                	mov    %eax,%eax
  8035c6:	48 01 d0             	add    %rdx,%rax
  8035c9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8035cc:	83 c2 08             	add    $0x8,%edx
  8035cf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8035d2:	eb 0f                	jmp    8035e3 <vprintfmt+0x1b7>
  8035d4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8035d8:	48 89 d0             	mov    %rdx,%rax
  8035db:	48 83 c2 08          	add    $0x8,%rdx
  8035df:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8035e3:	8b 00                	mov    (%rax),%eax
  8035e5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8035e9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8035ed:	48 89 d6             	mov    %rdx,%rsi
  8035f0:	89 c7                	mov    %eax,%edi
  8035f2:	ff d1                	callq  *%rcx
			break;
  8035f4:	e9 5a 03 00 00       	jmpq   803953 <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8035f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8035fc:	83 f8 30             	cmp    $0x30,%eax
  8035ff:	73 17                	jae    803618 <vprintfmt+0x1ec>
  803601:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803605:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803608:	89 c0                	mov    %eax,%eax
  80360a:	48 01 d0             	add    %rdx,%rax
  80360d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803610:	83 c2 08             	add    $0x8,%edx
  803613:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803616:	eb 0f                	jmp    803627 <vprintfmt+0x1fb>
  803618:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80361c:	48 89 d0             	mov    %rdx,%rax
  80361f:	48 83 c2 08          	add    $0x8,%rdx
  803623:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803627:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803629:	85 db                	test   %ebx,%ebx
  80362b:	79 02                	jns    80362f <vprintfmt+0x203>
				err = -err;
  80362d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80362f:	83 fb 15             	cmp    $0x15,%ebx
  803632:	7f 16                	jg     80364a <vprintfmt+0x21e>
  803634:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80363b:	00 00 00 
  80363e:	48 63 d3             	movslq %ebx,%rdx
  803641:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803645:	4d 85 e4             	test   %r12,%r12
  803648:	75 2e                	jne    803678 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80364a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80364e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803652:	89 d9                	mov    %ebx,%ecx
  803654:	48 ba e1 71 80 00 00 	movabs $0x8071e1,%rdx
  80365b:	00 00 00 
  80365e:	48 89 c7             	mov    %rax,%rdi
  803661:	b8 00 00 00 00       	mov    $0x0,%eax
  803666:	49 b8 63 39 80 00 00 	movabs $0x803963,%r8
  80366d:	00 00 00 
  803670:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803673:	e9 db 02 00 00       	jmpq   803953 <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803678:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80367c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803680:	4c 89 e1             	mov    %r12,%rcx
  803683:	48 ba ea 71 80 00 00 	movabs $0x8071ea,%rdx
  80368a:	00 00 00 
  80368d:	48 89 c7             	mov    %rax,%rdi
  803690:	b8 00 00 00 00       	mov    $0x0,%eax
  803695:	49 b8 63 39 80 00 00 	movabs $0x803963,%r8
  80369c:	00 00 00 
  80369f:	41 ff d0             	callq  *%r8
			break;
  8036a2:	e9 ac 02 00 00       	jmpq   803953 <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8036a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8036aa:	83 f8 30             	cmp    $0x30,%eax
  8036ad:	73 17                	jae    8036c6 <vprintfmt+0x29a>
  8036af:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8036b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8036b6:	89 c0                	mov    %eax,%eax
  8036b8:	48 01 d0             	add    %rdx,%rax
  8036bb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8036be:	83 c2 08             	add    $0x8,%edx
  8036c1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8036c4:	eb 0f                	jmp    8036d5 <vprintfmt+0x2a9>
  8036c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8036ca:	48 89 d0             	mov    %rdx,%rax
  8036cd:	48 83 c2 08          	add    $0x8,%rdx
  8036d1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8036d5:	4c 8b 20             	mov    (%rax),%r12
  8036d8:	4d 85 e4             	test   %r12,%r12
  8036db:	75 0a                	jne    8036e7 <vprintfmt+0x2bb>
				p = "(null)";
  8036dd:	49 bc ed 71 80 00 00 	movabs $0x8071ed,%r12
  8036e4:	00 00 00 
			if (width > 0 && padc != '-')
  8036e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8036eb:	7e 7a                	jle    803767 <vprintfmt+0x33b>
  8036ed:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8036f1:	74 74                	je     803767 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8036f3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036f6:	48 98                	cltq   
  8036f8:	48 89 c6             	mov    %rax,%rsi
  8036fb:	4c 89 e7             	mov    %r12,%rdi
  8036fe:	48 b8 0e 3c 80 00 00 	movabs $0x803c0e,%rax
  803705:	00 00 00 
  803708:	ff d0                	callq  *%rax
  80370a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80370d:	eb 17                	jmp    803726 <vprintfmt+0x2fa>
					putch(padc, putdat);
  80370f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  803713:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803717:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80371b:	48 89 d6             	mov    %rdx,%rsi
  80371e:	89 c7                	mov    %eax,%edi
  803720:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803722:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803726:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80372a:	7f e3                	jg     80370f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80372c:	eb 39                	jmp    803767 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  80372e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803732:	74 1e                	je     803752 <vprintfmt+0x326>
  803734:	83 fb 1f             	cmp    $0x1f,%ebx
  803737:	7e 05                	jle    80373e <vprintfmt+0x312>
  803739:	83 fb 7e             	cmp    $0x7e,%ebx
  80373c:	7e 14                	jle    803752 <vprintfmt+0x326>
					putch('?', putdat);
  80373e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803742:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803746:	48 89 c6             	mov    %rax,%rsi
  803749:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80374e:	ff d2                	callq  *%rdx
  803750:	eb 0f                	jmp    803761 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  803752:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803756:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80375a:	48 89 c6             	mov    %rax,%rsi
  80375d:	89 df                	mov    %ebx,%edi
  80375f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803761:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803765:	eb 01                	jmp    803768 <vprintfmt+0x33c>
  803767:	90                   	nop
  803768:	41 0f b6 04 24       	movzbl (%r12),%eax
  80376d:	0f be d8             	movsbl %al,%ebx
  803770:	85 db                	test   %ebx,%ebx
  803772:	0f 95 c0             	setne  %al
  803775:	49 83 c4 01          	add    $0x1,%r12
  803779:	84 c0                	test   %al,%al
  80377b:	74 28                	je     8037a5 <vprintfmt+0x379>
  80377d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803781:	78 ab                	js     80372e <vprintfmt+0x302>
  803783:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803787:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80378b:	79 a1                	jns    80372e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80378d:	eb 16                	jmp    8037a5 <vprintfmt+0x379>
				putch(' ', putdat);
  80378f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803793:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803797:	48 89 c6             	mov    %rax,%rsi
  80379a:	bf 20 00 00 00       	mov    $0x20,%edi
  80379f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8037a1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8037a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8037a9:	7f e4                	jg     80378f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  8037ab:	e9 a3 01 00 00       	jmpq   803953 <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8037b0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8037b4:	be 03 00 00 00       	mov    $0x3,%esi
  8037b9:	48 89 c7             	mov    %rax,%rdi
  8037bc:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  8037c3:	00 00 00 
  8037c6:	ff d0                	callq  *%rax
  8037c8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8037cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d0:	48 85 c0             	test   %rax,%rax
  8037d3:	79 1d                	jns    8037f2 <vprintfmt+0x3c6>
				putch('-', putdat);
  8037d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8037d9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8037dd:	48 89 c6             	mov    %rax,%rsi
  8037e0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8037e5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8037e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037eb:	48 f7 d8             	neg    %rax
  8037ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8037f2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8037f9:	e9 e8 00 00 00       	jmpq   8038e6 <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8037fe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803802:	be 03 00 00 00       	mov    $0x3,%esi
  803807:	48 89 c7             	mov    %rax,%rdi
  80380a:	48 b8 0c 32 80 00 00 	movabs $0x80320c,%rax
  803811:	00 00 00 
  803814:	ff d0                	callq  *%rax
  803816:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80381a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803821:	e9 c0 00 00 00       	jmpq   8038e6 <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  803826:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80382a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80382e:	48 89 c6             	mov    %rax,%rsi
  803831:	bf 58 00 00 00       	mov    $0x58,%edi
  803836:	ff d2                	callq  *%rdx
			putch('X', putdat);
  803838:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80383c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803840:	48 89 c6             	mov    %rax,%rsi
  803843:	bf 58 00 00 00       	mov    $0x58,%edi
  803848:	ff d2                	callq  *%rdx
			putch('X', putdat);
  80384a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80384e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803852:	48 89 c6             	mov    %rax,%rsi
  803855:	bf 58 00 00 00       	mov    $0x58,%edi
  80385a:	ff d2                	callq  *%rdx
			break;
  80385c:	e9 f2 00 00 00       	jmpq   803953 <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  803861:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803865:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803869:	48 89 c6             	mov    %rax,%rsi
  80386c:	bf 30 00 00 00       	mov    $0x30,%edi
  803871:	ff d2                	callq  *%rdx
			putch('x', putdat);
  803873:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803877:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80387b:	48 89 c6             	mov    %rax,%rsi
  80387e:	bf 78 00 00 00       	mov    $0x78,%edi
  803883:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803885:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803888:	83 f8 30             	cmp    $0x30,%eax
  80388b:	73 17                	jae    8038a4 <vprintfmt+0x478>
  80388d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803891:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803894:	89 c0                	mov    %eax,%eax
  803896:	48 01 d0             	add    %rdx,%rax
  803899:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80389c:	83 c2 08             	add    $0x8,%edx
  80389f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8038a2:	eb 0f                	jmp    8038b3 <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  8038a4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8038a8:	48 89 d0             	mov    %rdx,%rax
  8038ab:	48 83 c2 08          	add    $0x8,%rdx
  8038af:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8038b3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8038b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8038ba:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8038c1:	eb 23                	jmp    8038e6 <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8038c3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8038c7:	be 03 00 00 00       	mov    $0x3,%esi
  8038cc:	48 89 c7             	mov    %rax,%rdi
  8038cf:	48 b8 0c 32 80 00 00 	movabs $0x80320c,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
  8038db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8038df:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8038e6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8038eb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8038ee:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8038f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038f5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8038f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8038fd:	45 89 c1             	mov    %r8d,%r9d
  803900:	41 89 f8             	mov    %edi,%r8d
  803903:	48 89 c7             	mov    %rax,%rdi
  803906:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  80390d:	00 00 00 
  803910:	ff d0                	callq  *%rax
			break;
  803912:	eb 3f                	jmp    803953 <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803914:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803918:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80391c:	48 89 c6             	mov    %rax,%rsi
  80391f:	89 df                	mov    %ebx,%edi
  803921:	ff d2                	callq  *%rdx
			break;
  803923:	eb 2e                	jmp    803953 <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803925:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803929:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80392d:	48 89 c6             	mov    %rax,%rsi
  803930:	bf 25 00 00 00       	mov    $0x25,%edi
  803935:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  803937:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80393c:	eb 05                	jmp    803943 <vprintfmt+0x517>
  80393e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803943:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803947:	48 83 e8 01          	sub    $0x1,%rax
  80394b:	0f b6 00             	movzbl (%rax),%eax
  80394e:	3c 25                	cmp    $0x25,%al
  803950:	75 ec                	jne    80393e <vprintfmt+0x512>
				/* do nothing */;
			break;
  803952:	90                   	nop
		}
	}
  803953:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803954:	e9 25 fb ff ff       	jmpq   80347e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  803959:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80395a:	48 83 c4 60          	add    $0x60,%rsp
  80395e:	5b                   	pop    %rbx
  80395f:	41 5c                	pop    %r12
  803961:	5d                   	pop    %rbp
  803962:	c3                   	retq   

0000000000803963 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803963:	55                   	push   %rbp
  803964:	48 89 e5             	mov    %rsp,%rbp
  803967:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80396e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803975:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80397c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803983:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80398a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803991:	84 c0                	test   %al,%al
  803993:	74 20                	je     8039b5 <printfmt+0x52>
  803995:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803999:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80399d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8039a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8039a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8039a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8039ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8039b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8039b5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8039bc:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8039c3:	00 00 00 
  8039c6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8039cd:	00 00 00 
  8039d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8039d4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8039db:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8039e2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8039e9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8039f0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8039f7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8039fe:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803a05:	48 89 c7             	mov    %rax,%rdi
  803a08:	48 b8 2c 34 80 00 00 	movabs $0x80342c,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
	va_end(ap);
}
  803a14:	c9                   	leaveq 
  803a15:	c3                   	retq   

0000000000803a16 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803a16:	55                   	push   %rbp
  803a17:	48 89 e5             	mov    %rsp,%rbp
  803a1a:	48 83 ec 10          	sub    $0x10,%rsp
  803a1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a29:	8b 40 10             	mov    0x10(%rax),%eax
  803a2c:	8d 50 01             	lea    0x1(%rax),%edx
  803a2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a33:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803a36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3a:	48 8b 10             	mov    (%rax),%rdx
  803a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a41:	48 8b 40 08          	mov    0x8(%rax),%rax
  803a45:	48 39 c2             	cmp    %rax,%rdx
  803a48:	73 17                	jae    803a61 <sprintputch+0x4b>
		*b->buf++ = ch;
  803a4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a4e:	48 8b 00             	mov    (%rax),%rax
  803a51:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a54:	88 10                	mov    %dl,(%rax)
  803a56:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5e:	48 89 10             	mov    %rdx,(%rax)
}
  803a61:	c9                   	leaveq 
  803a62:	c3                   	retq   

0000000000803a63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803a63:	55                   	push   %rbp
  803a64:	48 89 e5             	mov    %rsp,%rbp
  803a67:	48 83 ec 50          	sub    $0x50,%rsp
  803a6b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803a6f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803a72:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803a76:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803a7a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803a7e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803a82:	48 8b 0a             	mov    (%rdx),%rcx
  803a85:	48 89 08             	mov    %rcx,(%rax)
  803a88:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803a8c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803a90:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803a94:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803a98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a9c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803aa0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803aa3:	48 98                	cltq   
  803aa5:	48 83 e8 01          	sub    $0x1,%rax
  803aa9:	48 03 45 c8          	add    -0x38(%rbp),%rax
  803aad:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803ab1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803ab8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803abd:	74 06                	je     803ac5 <vsnprintf+0x62>
  803abf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803ac3:	7f 07                	jg     803acc <vsnprintf+0x69>
		return -E_INVAL;
  803ac5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803aca:	eb 2f                	jmp    803afb <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803acc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803ad0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803ad4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ad8:	48 89 c6             	mov    %rax,%rsi
  803adb:	48 bf 16 3a 80 00 00 	movabs $0x803a16,%rdi
  803ae2:	00 00 00 
  803ae5:	48 b8 2c 34 80 00 00 	movabs $0x80342c,%rax
  803aec:	00 00 00 
  803aef:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803af1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803af5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803af8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803afb:	c9                   	leaveq 
  803afc:	c3                   	retq   

0000000000803afd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803afd:	55                   	push   %rbp
  803afe:	48 89 e5             	mov    %rsp,%rbp
  803b01:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803b08:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803b0f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803b15:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803b1c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803b23:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803b2a:	84 c0                	test   %al,%al
  803b2c:	74 20                	je     803b4e <snprintf+0x51>
  803b2e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803b32:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803b36:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803b3a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803b3e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803b42:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803b46:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803b4a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803b4e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803b55:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803b5c:	00 00 00 
  803b5f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803b66:	00 00 00 
  803b69:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b6d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803b74:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803b7b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803b82:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803b89:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803b90:	48 8b 0a             	mov    (%rdx),%rcx
  803b93:	48 89 08             	mov    %rcx,(%rax)
  803b96:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803b9a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803b9e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803ba2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803ba6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803bad:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803bb4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803bba:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803bc1:	48 89 c7             	mov    %rax,%rdi
  803bc4:	48 b8 63 3a 80 00 00 	movabs $0x803a63,%rax
  803bcb:	00 00 00 
  803bce:	ff d0                	callq  *%rax
  803bd0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803bd6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803bdc:	c9                   	leaveq 
  803bdd:	c3                   	retq   
	...

0000000000803be0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803be0:	55                   	push   %rbp
  803be1:	48 89 e5             	mov    %rsp,%rbp
  803be4:	48 83 ec 18          	sub    $0x18,%rsp
  803be8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bf3:	eb 09                	jmp    803bfe <strlen+0x1e>
		n++;
  803bf5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803bf9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803bfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c02:	0f b6 00             	movzbl (%rax),%eax
  803c05:	84 c0                	test   %al,%al
  803c07:	75 ec                	jne    803bf5 <strlen+0x15>
		n++;
	return n;
  803c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c0c:	c9                   	leaveq 
  803c0d:	c3                   	retq   

0000000000803c0e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803c0e:	55                   	push   %rbp
  803c0f:	48 89 e5             	mov    %rsp,%rbp
  803c12:	48 83 ec 20          	sub    $0x20,%rsp
  803c16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c25:	eb 0e                	jmp    803c35 <strnlen+0x27>
		n++;
  803c27:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803c2b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803c30:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  803c35:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c3a:	74 0b                	je     803c47 <strnlen+0x39>
  803c3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c40:	0f b6 00             	movzbl (%rax),%eax
  803c43:	84 c0                	test   %al,%al
  803c45:	75 e0                	jne    803c27 <strnlen+0x19>
		n++;
	return n;
  803c47:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c4a:	c9                   	leaveq 
  803c4b:	c3                   	retq   

0000000000803c4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803c4c:	55                   	push   %rbp
  803c4d:	48 89 e5             	mov    %rsp,%rbp
  803c50:	48 83 ec 20          	sub    $0x20,%rsp
  803c54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803c5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  803c64:	90                   	nop
  803c65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c69:	0f b6 10             	movzbl (%rax),%edx
  803c6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c70:	88 10                	mov    %dl,(%rax)
  803c72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c76:	0f b6 00             	movzbl (%rax),%eax
  803c79:	84 c0                	test   %al,%al
  803c7b:	0f 95 c0             	setne  %al
  803c7e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803c83:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803c88:	84 c0                	test   %al,%al
  803c8a:	75 d9                	jne    803c65 <strcpy+0x19>
		/* do nothing */;
	return ret;
  803c8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c90:	c9                   	leaveq 
  803c91:	c3                   	retq   

0000000000803c92 <strcat>:

char *
strcat(char *dst, const char *src)
{
  803c92:	55                   	push   %rbp
  803c93:	48 89 e5             	mov    %rsp,%rbp
  803c96:	48 83 ec 20          	sub    $0x20,%rsp
  803c9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  803ca2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca6:	48 89 c7             	mov    %rax,%rdi
  803ca9:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  803cb0:	00 00 00 
  803cb3:	ff d0                	callq  *%rax
  803cb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  803cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cbb:	48 98                	cltq   
  803cbd:	48 03 45 e8          	add    -0x18(%rbp),%rax
  803cc1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803cc5:	48 89 d6             	mov    %rdx,%rsi
  803cc8:	48 89 c7             	mov    %rax,%rdi
  803ccb:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  803cd2:	00 00 00 
  803cd5:	ff d0                	callq  *%rax
	return dst;
  803cd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803cdb:	c9                   	leaveq 
  803cdc:	c3                   	retq   

0000000000803cdd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  803cdd:	55                   	push   %rbp
  803cde:	48 89 e5             	mov    %rsp,%rbp
  803ce1:	48 83 ec 28          	sub    $0x28,%rsp
  803ce5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ce9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ced:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  803cf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cf5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  803cf9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d00:	00 
  803d01:	eb 27                	jmp    803d2a <strncpy+0x4d>
		*dst++ = *src;
  803d03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d07:	0f b6 10             	movzbl (%rax),%edx
  803d0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d0e:	88 10                	mov    %dl,(%rax)
  803d10:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803d15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d19:	0f b6 00             	movzbl (%rax),%eax
  803d1c:	84 c0                	test   %al,%al
  803d1e:	74 05                	je     803d25 <strncpy+0x48>
			src++;
  803d20:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  803d25:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d2e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803d32:	72 cf                	jb     803d03 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  803d34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803d38:	c9                   	leaveq 
  803d39:	c3                   	retq   

0000000000803d3a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  803d3a:	55                   	push   %rbp
  803d3b:	48 89 e5             	mov    %rsp,%rbp
  803d3e:	48 83 ec 28          	sub    $0x28,%rsp
  803d42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  803d4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  803d56:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d5b:	74 37                	je     803d94 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  803d5d:	eb 17                	jmp    803d76 <strlcpy+0x3c>
			*dst++ = *src++;
  803d5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d63:	0f b6 10             	movzbl (%rax),%edx
  803d66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d6a:	88 10                	mov    %dl,(%rax)
  803d6c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803d71:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  803d76:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  803d7b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d80:	74 0b                	je     803d8d <strlcpy+0x53>
  803d82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d86:	0f b6 00             	movzbl (%rax),%eax
  803d89:	84 c0                	test   %al,%al
  803d8b:	75 d2                	jne    803d5f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  803d8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d91:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  803d94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d9c:	48 89 d1             	mov    %rdx,%rcx
  803d9f:	48 29 c1             	sub    %rax,%rcx
  803da2:	48 89 c8             	mov    %rcx,%rax
}
  803da5:	c9                   	leaveq 
  803da6:	c3                   	retq   

0000000000803da7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  803da7:	55                   	push   %rbp
  803da8:	48 89 e5             	mov    %rsp,%rbp
  803dab:	48 83 ec 10          	sub    $0x10,%rsp
  803daf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803db3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  803db7:	eb 0a                	jmp    803dc3 <strcmp+0x1c>
		p++, q++;
  803db9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803dbe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  803dc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dc7:	0f b6 00             	movzbl (%rax),%eax
  803dca:	84 c0                	test   %al,%al
  803dcc:	74 12                	je     803de0 <strcmp+0x39>
  803dce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dd2:	0f b6 10             	movzbl (%rax),%edx
  803dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd9:	0f b6 00             	movzbl (%rax),%eax
  803ddc:	38 c2                	cmp    %al,%dl
  803dde:	74 d9                	je     803db9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  803de0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de4:	0f b6 00             	movzbl (%rax),%eax
  803de7:	0f b6 d0             	movzbl %al,%edx
  803dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dee:	0f b6 00             	movzbl (%rax),%eax
  803df1:	0f b6 c0             	movzbl %al,%eax
  803df4:	89 d1                	mov    %edx,%ecx
  803df6:	29 c1                	sub    %eax,%ecx
  803df8:	89 c8                	mov    %ecx,%eax
}
  803dfa:	c9                   	leaveq 
  803dfb:	c3                   	retq   

0000000000803dfc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  803dfc:	55                   	push   %rbp
  803dfd:	48 89 e5             	mov    %rsp,%rbp
  803e00:	48 83 ec 18          	sub    $0x18,%rsp
  803e04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e0c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  803e10:	eb 0f                	jmp    803e21 <strncmp+0x25>
		n--, p++, q++;
  803e12:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  803e17:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e1c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  803e21:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e26:	74 1d                	je     803e45 <strncmp+0x49>
  803e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e2c:	0f b6 00             	movzbl (%rax),%eax
  803e2f:	84 c0                	test   %al,%al
  803e31:	74 12                	je     803e45 <strncmp+0x49>
  803e33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e37:	0f b6 10             	movzbl (%rax),%edx
  803e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3e:	0f b6 00             	movzbl (%rax),%eax
  803e41:	38 c2                	cmp    %al,%dl
  803e43:	74 cd                	je     803e12 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  803e45:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e4a:	75 07                	jne    803e53 <strncmp+0x57>
		return 0;
  803e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e51:	eb 1a                	jmp    803e6d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  803e53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e57:	0f b6 00             	movzbl (%rax),%eax
  803e5a:	0f b6 d0             	movzbl %al,%edx
  803e5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e61:	0f b6 00             	movzbl (%rax),%eax
  803e64:	0f b6 c0             	movzbl %al,%eax
  803e67:	89 d1                	mov    %edx,%ecx
  803e69:	29 c1                	sub    %eax,%ecx
  803e6b:	89 c8                	mov    %ecx,%eax
}
  803e6d:	c9                   	leaveq 
  803e6e:	c3                   	retq   

0000000000803e6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  803e6f:	55                   	push   %rbp
  803e70:	48 89 e5             	mov    %rsp,%rbp
  803e73:	48 83 ec 10          	sub    $0x10,%rsp
  803e77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e7b:	89 f0                	mov    %esi,%eax
  803e7d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  803e80:	eb 17                	jmp    803e99 <strchr+0x2a>
		if (*s == c)
  803e82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e86:	0f b6 00             	movzbl (%rax),%eax
  803e89:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803e8c:	75 06                	jne    803e94 <strchr+0x25>
			return (char *) s;
  803e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e92:	eb 15                	jmp    803ea9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  803e94:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e9d:	0f b6 00             	movzbl (%rax),%eax
  803ea0:	84 c0                	test   %al,%al
  803ea2:	75 de                	jne    803e82 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  803ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ea9:	c9                   	leaveq 
  803eaa:	c3                   	retq   

0000000000803eab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  803eab:	55                   	push   %rbp
  803eac:	48 89 e5             	mov    %rsp,%rbp
  803eaf:	48 83 ec 10          	sub    $0x10,%rsp
  803eb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803eb7:	89 f0                	mov    %esi,%eax
  803eb9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  803ebc:	eb 11                	jmp    803ecf <strfind+0x24>
		if (*s == c)
  803ebe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec2:	0f b6 00             	movzbl (%rax),%eax
  803ec5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803ec8:	74 12                	je     803edc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  803eca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ed3:	0f b6 00             	movzbl (%rax),%eax
  803ed6:	84 c0                	test   %al,%al
  803ed8:	75 e4                	jne    803ebe <strfind+0x13>
  803eda:	eb 01                	jmp    803edd <strfind+0x32>
		if (*s == c)
			break;
  803edc:	90                   	nop
	return (char *) s;
  803edd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ee1:	c9                   	leaveq 
  803ee2:	c3                   	retq   

0000000000803ee3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  803ee3:	55                   	push   %rbp
  803ee4:	48 89 e5             	mov    %rsp,%rbp
  803ee7:	48 83 ec 18          	sub    $0x18,%rsp
  803eeb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803eef:	89 75 f4             	mov    %esi,-0xc(%rbp)
  803ef2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  803ef6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803efb:	75 06                	jne    803f03 <memset+0x20>
		return v;
  803efd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f01:	eb 69                	jmp    803f6c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  803f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f07:	83 e0 03             	and    $0x3,%eax
  803f0a:	48 85 c0             	test   %rax,%rax
  803f0d:	75 48                	jne    803f57 <memset+0x74>
  803f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f13:	83 e0 03             	and    $0x3,%eax
  803f16:	48 85 c0             	test   %rax,%rax
  803f19:	75 3c                	jne    803f57 <memset+0x74>
		c &= 0xFF;
  803f1b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  803f22:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f25:	89 c2                	mov    %eax,%edx
  803f27:	c1 e2 18             	shl    $0x18,%edx
  803f2a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f2d:	c1 e0 10             	shl    $0x10,%eax
  803f30:	09 c2                	or     %eax,%edx
  803f32:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f35:	c1 e0 08             	shl    $0x8,%eax
  803f38:	09 d0                	or     %edx,%eax
  803f3a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  803f3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f41:	48 89 c1             	mov    %rax,%rcx
  803f44:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  803f48:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f4c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f4f:	48 89 d7             	mov    %rdx,%rdi
  803f52:	fc                   	cld    
  803f53:	f3 ab                	rep stos %eax,%es:(%rdi)
  803f55:	eb 11                	jmp    803f68 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  803f57:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f5b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f5e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f62:	48 89 d7             	mov    %rdx,%rdi
  803f65:	fc                   	cld    
  803f66:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  803f68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f6c:	c9                   	leaveq 
  803f6d:	c3                   	retq   

0000000000803f6e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  803f6e:	55                   	push   %rbp
  803f6f:	48 89 e5             	mov    %rsp,%rbp
  803f72:	48 83 ec 28          	sub    $0x28,%rsp
  803f76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  803f82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  803f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  803f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f96:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803f9a:	0f 83 88 00 00 00    	jae    804028 <memmove+0xba>
  803fa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fa4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803fa8:	48 01 d0             	add    %rdx,%rax
  803fab:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803faf:	76 77                	jbe    804028 <memmove+0xba>
		s += n;
  803fb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  803fb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fbd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803fc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fc5:	83 e0 03             	and    $0x3,%eax
  803fc8:	48 85 c0             	test   %rax,%rax
  803fcb:	75 3b                	jne    804008 <memmove+0x9a>
  803fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd1:	83 e0 03             	and    $0x3,%eax
  803fd4:	48 85 c0             	test   %rax,%rax
  803fd7:	75 2f                	jne    804008 <memmove+0x9a>
  803fd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fdd:	83 e0 03             	and    $0x3,%eax
  803fe0:	48 85 c0             	test   %rax,%rax
  803fe3:	75 23                	jne    804008 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803fe5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe9:	48 83 e8 04          	sub    $0x4,%rax
  803fed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ff1:	48 83 ea 04          	sub    $0x4,%rdx
  803ff5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803ff9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  803ffd:	48 89 c7             	mov    %rax,%rdi
  804000:	48 89 d6             	mov    %rdx,%rsi
  804003:	fd                   	std    
  804004:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804006:	eb 1d                	jmp    804025 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  804008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80400c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804014:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  804018:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80401c:	48 89 d7             	mov    %rdx,%rdi
  80401f:	48 89 c1             	mov    %rax,%rcx
  804022:	fd                   	std    
  804023:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  804025:	fc                   	cld    
  804026:	eb 57                	jmp    80407f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804028:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80402c:	83 e0 03             	and    $0x3,%eax
  80402f:	48 85 c0             	test   %rax,%rax
  804032:	75 36                	jne    80406a <memmove+0xfc>
  804034:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804038:	83 e0 03             	and    $0x3,%eax
  80403b:	48 85 c0             	test   %rax,%rax
  80403e:	75 2a                	jne    80406a <memmove+0xfc>
  804040:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804044:	83 e0 03             	and    $0x3,%eax
  804047:	48 85 c0             	test   %rax,%rax
  80404a:	75 1e                	jne    80406a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80404c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804050:	48 89 c1             	mov    %rax,%rcx
  804053:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  804057:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80405f:	48 89 c7             	mov    %rax,%rdi
  804062:	48 89 d6             	mov    %rdx,%rsi
  804065:	fc                   	cld    
  804066:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804068:	eb 15                	jmp    80407f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80406a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804072:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804076:	48 89 c7             	mov    %rax,%rdi
  804079:	48 89 d6             	mov    %rdx,%rsi
  80407c:	fc                   	cld    
  80407d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80407f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804083:	c9                   	leaveq 
  804084:	c3                   	retq   

0000000000804085 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  804085:	55                   	push   %rbp
  804086:	48 89 e5             	mov    %rsp,%rbp
  804089:	48 83 ec 18          	sub    $0x18,%rsp
  80408d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804091:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804095:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  804099:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80409d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8040a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a5:	48 89 ce             	mov    %rcx,%rsi
  8040a8:	48 89 c7             	mov    %rax,%rdi
  8040ab:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  8040b2:	00 00 00 
  8040b5:	ff d0                	callq  *%rax
}
  8040b7:	c9                   	leaveq 
  8040b8:	c3                   	retq   

00000000008040b9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8040b9:	55                   	push   %rbp
  8040ba:	48 89 e5             	mov    %rsp,%rbp
  8040bd:	48 83 ec 28          	sub    $0x28,%rsp
  8040c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8040cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8040d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8040dd:	eb 38                	jmp    804117 <memcmp+0x5e>
		if (*s1 != *s2)
  8040df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e3:	0f b6 10             	movzbl (%rax),%edx
  8040e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ea:	0f b6 00             	movzbl (%rax),%eax
  8040ed:	38 c2                	cmp    %al,%dl
  8040ef:	74 1c                	je     80410d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8040f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040f5:	0f b6 00             	movzbl (%rax),%eax
  8040f8:	0f b6 d0             	movzbl %al,%edx
  8040fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ff:	0f b6 00             	movzbl (%rax),%eax
  804102:	0f b6 c0             	movzbl %al,%eax
  804105:	89 d1                	mov    %edx,%ecx
  804107:	29 c1                	sub    %eax,%ecx
  804109:	89 c8                	mov    %ecx,%eax
  80410b:	eb 20                	jmp    80412d <memcmp+0x74>
		s1++, s2++;
  80410d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804112:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  804117:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80411c:	0f 95 c0             	setne  %al
  80411f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  804124:	84 c0                	test   %al,%al
  804126:	75 b7                	jne    8040df <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  804128:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80412d:	c9                   	leaveq 
  80412e:	c3                   	retq   

000000000080412f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80412f:	55                   	push   %rbp
  804130:	48 89 e5             	mov    %rsp,%rbp
  804133:	48 83 ec 28          	sub    $0x28,%rsp
  804137:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80413b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80413e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  804142:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804146:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80414a:	48 01 d0             	add    %rdx,%rax
  80414d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  804151:	eb 13                	jmp    804166 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  804153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804157:	0f b6 10             	movzbl (%rax),%edx
  80415a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80415d:	38 c2                	cmp    %al,%dl
  80415f:	74 11                	je     804172 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  804161:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80416a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80416e:	72 e3                	jb     804153 <memfind+0x24>
  804170:	eb 01                	jmp    804173 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  804172:	90                   	nop
	return (void *) s;
  804173:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804177:	c9                   	leaveq 
  804178:	c3                   	retq   

0000000000804179 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  804179:	55                   	push   %rbp
  80417a:	48 89 e5             	mov    %rsp,%rbp
  80417d:	48 83 ec 38          	sub    $0x38,%rsp
  804181:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804185:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804189:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80418c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  804193:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80419a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80419b:	eb 05                	jmp    8041a2 <strtol+0x29>
		s++;
  80419d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8041a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041a6:	0f b6 00             	movzbl (%rax),%eax
  8041a9:	3c 20                	cmp    $0x20,%al
  8041ab:	74 f0                	je     80419d <strtol+0x24>
  8041ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041b1:	0f b6 00             	movzbl (%rax),%eax
  8041b4:	3c 09                	cmp    $0x9,%al
  8041b6:	74 e5                	je     80419d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8041b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041bc:	0f b6 00             	movzbl (%rax),%eax
  8041bf:	3c 2b                	cmp    $0x2b,%al
  8041c1:	75 07                	jne    8041ca <strtol+0x51>
		s++;
  8041c3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8041c8:	eb 17                	jmp    8041e1 <strtol+0x68>
	else if (*s == '-')
  8041ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041ce:	0f b6 00             	movzbl (%rax),%eax
  8041d1:	3c 2d                	cmp    $0x2d,%al
  8041d3:	75 0c                	jne    8041e1 <strtol+0x68>
		s++, neg = 1;
  8041d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8041da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8041e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8041e5:	74 06                	je     8041ed <strtol+0x74>
  8041e7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8041eb:	75 28                	jne    804215 <strtol+0x9c>
  8041ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041f1:	0f b6 00             	movzbl (%rax),%eax
  8041f4:	3c 30                	cmp    $0x30,%al
  8041f6:	75 1d                	jne    804215 <strtol+0x9c>
  8041f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041fc:	48 83 c0 01          	add    $0x1,%rax
  804200:	0f b6 00             	movzbl (%rax),%eax
  804203:	3c 78                	cmp    $0x78,%al
  804205:	75 0e                	jne    804215 <strtol+0x9c>
		s += 2, base = 16;
  804207:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80420c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  804213:	eb 2c                	jmp    804241 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  804215:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804219:	75 19                	jne    804234 <strtol+0xbb>
  80421b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80421f:	0f b6 00             	movzbl (%rax),%eax
  804222:	3c 30                	cmp    $0x30,%al
  804224:	75 0e                	jne    804234 <strtol+0xbb>
		s++, base = 8;
  804226:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80422b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  804232:	eb 0d                	jmp    804241 <strtol+0xc8>
	else if (base == 0)
  804234:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804238:	75 07                	jne    804241 <strtol+0xc8>
		base = 10;
  80423a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  804241:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804245:	0f b6 00             	movzbl (%rax),%eax
  804248:	3c 2f                	cmp    $0x2f,%al
  80424a:	7e 1d                	jle    804269 <strtol+0xf0>
  80424c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804250:	0f b6 00             	movzbl (%rax),%eax
  804253:	3c 39                	cmp    $0x39,%al
  804255:	7f 12                	jg     804269 <strtol+0xf0>
			dig = *s - '0';
  804257:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80425b:	0f b6 00             	movzbl (%rax),%eax
  80425e:	0f be c0             	movsbl %al,%eax
  804261:	83 e8 30             	sub    $0x30,%eax
  804264:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804267:	eb 4e                	jmp    8042b7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  804269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80426d:	0f b6 00             	movzbl (%rax),%eax
  804270:	3c 60                	cmp    $0x60,%al
  804272:	7e 1d                	jle    804291 <strtol+0x118>
  804274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804278:	0f b6 00             	movzbl (%rax),%eax
  80427b:	3c 7a                	cmp    $0x7a,%al
  80427d:	7f 12                	jg     804291 <strtol+0x118>
			dig = *s - 'a' + 10;
  80427f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804283:	0f b6 00             	movzbl (%rax),%eax
  804286:	0f be c0             	movsbl %al,%eax
  804289:	83 e8 57             	sub    $0x57,%eax
  80428c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80428f:	eb 26                	jmp    8042b7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  804291:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804295:	0f b6 00             	movzbl (%rax),%eax
  804298:	3c 40                	cmp    $0x40,%al
  80429a:	7e 47                	jle    8042e3 <strtol+0x16a>
  80429c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042a0:	0f b6 00             	movzbl (%rax),%eax
  8042a3:	3c 5a                	cmp    $0x5a,%al
  8042a5:	7f 3c                	jg     8042e3 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8042a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042ab:	0f b6 00             	movzbl (%rax),%eax
  8042ae:	0f be c0             	movsbl %al,%eax
  8042b1:	83 e8 37             	sub    $0x37,%eax
  8042b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8042b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042ba:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8042bd:	7d 23                	jge    8042e2 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8042bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8042c4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8042c7:	48 98                	cltq   
  8042c9:	48 89 c2             	mov    %rax,%rdx
  8042cc:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8042d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042d4:	48 98                	cltq   
  8042d6:	48 01 d0             	add    %rdx,%rax
  8042d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8042dd:	e9 5f ff ff ff       	jmpq   804241 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8042e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8042e3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8042e8:	74 0b                	je     8042f5 <strtol+0x17c>
		*endptr = (char *) s;
  8042ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042ee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8042f2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8042f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042f9:	74 09                	je     804304 <strtol+0x18b>
  8042fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ff:	48 f7 d8             	neg    %rax
  804302:	eb 04                	jmp    804308 <strtol+0x18f>
  804304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  804308:	c9                   	leaveq 
  804309:	c3                   	retq   

000000000080430a <strstr>:

char * strstr(const char *in, const char *str)
{
  80430a:	55                   	push   %rbp
  80430b:	48 89 e5             	mov    %rsp,%rbp
  80430e:	48 83 ec 30          	sub    $0x30,%rsp
  804312:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804316:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80431a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80431e:	0f b6 00             	movzbl (%rax),%eax
  804321:	88 45 ff             	mov    %al,-0x1(%rbp)
  804324:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  804329:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80432d:	75 06                	jne    804335 <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  80432f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804333:	eb 68                	jmp    80439d <strstr+0x93>

	len = strlen(str);
  804335:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804339:	48 89 c7             	mov    %rax,%rdi
  80433c:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  804343:	00 00 00 
  804346:	ff d0                	callq  *%rax
  804348:	48 98                	cltq   
  80434a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80434e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804352:	0f b6 00             	movzbl (%rax),%eax
  804355:	88 45 ef             	mov    %al,-0x11(%rbp)
  804358:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  80435d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  804361:	75 07                	jne    80436a <strstr+0x60>
				return (char *) 0;
  804363:	b8 00 00 00 00       	mov    $0x0,%eax
  804368:	eb 33                	jmp    80439d <strstr+0x93>
		} while (sc != c);
  80436a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80436e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  804371:	75 db                	jne    80434e <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  804373:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804377:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80437b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80437f:	48 89 ce             	mov    %rcx,%rsi
  804382:	48 89 c7             	mov    %rax,%rdi
  804385:	48 b8 fc 3d 80 00 00 	movabs $0x803dfc,%rax
  80438c:	00 00 00 
  80438f:	ff d0                	callq  *%rax
  804391:	85 c0                	test   %eax,%eax
  804393:	75 b9                	jne    80434e <strstr+0x44>

	return (char *) (in - 1);
  804395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804399:	48 83 e8 01          	sub    $0x1,%rax
}
  80439d:	c9                   	leaveq 
  80439e:	c3                   	retq   
	...

00000000008043a0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8043a0:	55                   	push   %rbp
  8043a1:	48 89 e5             	mov    %rsp,%rbp
  8043a4:	53                   	push   %rbx
  8043a5:	48 83 ec 58          	sub    $0x58,%rsp
  8043a9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8043ac:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8043af:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8043b3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8043b7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8043bb:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8043bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8043c2:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8043c5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8043c9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8043cd:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8043d1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8043d5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8043d9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8043dc:	4c 89 c3             	mov    %r8,%rbx
  8043df:	cd 30                	int    $0x30
  8043e1:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8043e5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8043e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8043ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8043f1:	74 3e                	je     804431 <syscall+0x91>
  8043f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043f8:	7e 37                	jle    804431 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8043fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043fe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804401:	49 89 d0             	mov    %rdx,%r8
  804404:	89 c1                	mov    %eax,%ecx
  804406:	48 ba a8 74 80 00 00 	movabs $0x8074a8,%rdx
  80440d:	00 00 00 
  804410:	be 23 00 00 00       	mov    $0x23,%esi
  804415:	48 bf c5 74 80 00 00 	movabs $0x8074c5,%rdi
  80441c:	00 00 00 
  80441f:	b8 00 00 00 00       	mov    $0x0,%eax
  804424:	49 b9 40 2e 80 00 00 	movabs $0x802e40,%r9
  80442b:	00 00 00 
  80442e:	41 ff d1             	callq  *%r9

	return ret;
  804431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804435:	48 83 c4 58          	add    $0x58,%rsp
  804439:	5b                   	pop    %rbx
  80443a:	5d                   	pop    %rbp
  80443b:	c3                   	retq   

000000000080443c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80443c:	55                   	push   %rbp
  80443d:	48 89 e5             	mov    %rsp,%rbp
  804440:	48 83 ec 20          	sub    $0x20,%rsp
  804444:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804448:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80444c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804450:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804454:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80445b:	00 
  80445c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804462:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804468:	48 89 d1             	mov    %rdx,%rcx
  80446b:	48 89 c2             	mov    %rax,%rdx
  80446e:	be 00 00 00 00       	mov    $0x0,%esi
  804473:	bf 00 00 00 00       	mov    $0x0,%edi
  804478:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  80447f:	00 00 00 
  804482:	ff d0                	callq  *%rax
}
  804484:	c9                   	leaveq 
  804485:	c3                   	retq   

0000000000804486 <sys_cgetc>:

int
sys_cgetc(void)
{
  804486:	55                   	push   %rbp
  804487:	48 89 e5             	mov    %rsp,%rbp
  80448a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80448e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804495:	00 
  804496:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80449c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8044a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8044a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8044ac:	be 00 00 00 00       	mov    $0x0,%esi
  8044b1:	bf 01 00 00 00       	mov    $0x1,%edi
  8044b6:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  8044bd:	00 00 00 
  8044c0:	ff d0                	callq  *%rax
}
  8044c2:	c9                   	leaveq 
  8044c3:	c3                   	retq   

00000000008044c4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8044c4:	55                   	push   %rbp
  8044c5:	48 89 e5             	mov    %rsp,%rbp
  8044c8:	48 83 ec 20          	sub    $0x20,%rsp
  8044cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8044cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044d2:	48 98                	cltq   
  8044d4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8044db:	00 
  8044dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8044e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8044e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8044ed:	48 89 c2             	mov    %rax,%rdx
  8044f0:	be 01 00 00 00       	mov    $0x1,%esi
  8044f5:	bf 03 00 00 00       	mov    $0x3,%edi
  8044fa:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  804501:	00 00 00 
  804504:	ff d0                	callq  *%rax
}
  804506:	c9                   	leaveq 
  804507:	c3                   	retq   

0000000000804508 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  804508:	55                   	push   %rbp
  804509:	48 89 e5             	mov    %rsp,%rbp
  80450c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  804510:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804517:	00 
  804518:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80451e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804524:	b9 00 00 00 00       	mov    $0x0,%ecx
  804529:	ba 00 00 00 00       	mov    $0x0,%edx
  80452e:	be 00 00 00 00       	mov    $0x0,%esi
  804533:	bf 02 00 00 00       	mov    $0x2,%edi
  804538:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  80453f:	00 00 00 
  804542:	ff d0                	callq  *%rax
}
  804544:	c9                   	leaveq 
  804545:	c3                   	retq   

0000000000804546 <sys_yield>:

void
sys_yield(void)
{
  804546:	55                   	push   %rbp
  804547:	48 89 e5             	mov    %rsp,%rbp
  80454a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80454e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804555:	00 
  804556:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80455c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804562:	b9 00 00 00 00       	mov    $0x0,%ecx
  804567:	ba 00 00 00 00       	mov    $0x0,%edx
  80456c:	be 00 00 00 00       	mov    $0x0,%esi
  804571:	bf 0b 00 00 00       	mov    $0xb,%edi
  804576:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  80457d:	00 00 00 
  804580:	ff d0                	callq  *%rax
}
  804582:	c9                   	leaveq 
  804583:	c3                   	retq   

0000000000804584 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804584:	55                   	push   %rbp
  804585:	48 89 e5             	mov    %rsp,%rbp
  804588:	48 83 ec 20          	sub    $0x20,%rsp
  80458c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80458f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804593:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804596:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804599:	48 63 c8             	movslq %eax,%rcx
  80459c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a3:	48 98                	cltq   
  8045a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8045ac:	00 
  8045ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8045b3:	49 89 c8             	mov    %rcx,%r8
  8045b6:	48 89 d1             	mov    %rdx,%rcx
  8045b9:	48 89 c2             	mov    %rax,%rdx
  8045bc:	be 01 00 00 00       	mov    $0x1,%esi
  8045c1:	bf 04 00 00 00       	mov    $0x4,%edi
  8045c6:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  8045cd:	00 00 00 
  8045d0:	ff d0                	callq  *%rax
}
  8045d2:	c9                   	leaveq 
  8045d3:	c3                   	retq   

00000000008045d4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8045d4:	55                   	push   %rbp
  8045d5:	48 89 e5             	mov    %rsp,%rbp
  8045d8:	48 83 ec 30          	sub    $0x30,%rsp
  8045dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8045df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8045e3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8045e6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8045ea:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8045ee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8045f1:	48 63 c8             	movslq %eax,%rcx
  8045f4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8045f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045fb:	48 63 f0             	movslq %eax,%rsi
  8045fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804602:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804605:	48 98                	cltq   
  804607:	48 89 0c 24          	mov    %rcx,(%rsp)
  80460b:	49 89 f9             	mov    %rdi,%r9
  80460e:	49 89 f0             	mov    %rsi,%r8
  804611:	48 89 d1             	mov    %rdx,%rcx
  804614:	48 89 c2             	mov    %rax,%rdx
  804617:	be 01 00 00 00       	mov    $0x1,%esi
  80461c:	bf 05 00 00 00       	mov    $0x5,%edi
  804621:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  804628:	00 00 00 
  80462b:	ff d0                	callq  *%rax
}
  80462d:	c9                   	leaveq 
  80462e:	c3                   	retq   

000000000080462f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80462f:	55                   	push   %rbp
  804630:	48 89 e5             	mov    %rsp,%rbp
  804633:	48 83 ec 20          	sub    $0x20,%rsp
  804637:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80463a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80463e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804645:	48 98                	cltq   
  804647:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80464e:	00 
  80464f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804655:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80465b:	48 89 d1             	mov    %rdx,%rcx
  80465e:	48 89 c2             	mov    %rax,%rdx
  804661:	be 01 00 00 00       	mov    $0x1,%esi
  804666:	bf 06 00 00 00       	mov    $0x6,%edi
  80466b:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  804672:	00 00 00 
  804675:	ff d0                	callq  *%rax
}
  804677:	c9                   	leaveq 
  804678:	c3                   	retq   

0000000000804679 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804679:	55                   	push   %rbp
  80467a:	48 89 e5             	mov    %rsp,%rbp
  80467d:	48 83 ec 20          	sub    $0x20,%rsp
  804681:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804684:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804687:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80468a:	48 63 d0             	movslq %eax,%rdx
  80468d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804690:	48 98                	cltq   
  804692:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804699:	00 
  80469a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8046a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8046a6:	48 89 d1             	mov    %rdx,%rcx
  8046a9:	48 89 c2             	mov    %rax,%rdx
  8046ac:	be 01 00 00 00       	mov    $0x1,%esi
  8046b1:	bf 08 00 00 00       	mov    $0x8,%edi
  8046b6:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  8046bd:	00 00 00 
  8046c0:	ff d0                	callq  *%rax
}
  8046c2:	c9                   	leaveq 
  8046c3:	c3                   	retq   

00000000008046c4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8046c4:	55                   	push   %rbp
  8046c5:	48 89 e5             	mov    %rsp,%rbp
  8046c8:	48 83 ec 20          	sub    $0x20,%rsp
  8046cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8046cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8046d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046da:	48 98                	cltq   
  8046dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8046e3:	00 
  8046e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8046ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8046f0:	48 89 d1             	mov    %rdx,%rcx
  8046f3:	48 89 c2             	mov    %rax,%rdx
  8046f6:	be 01 00 00 00       	mov    $0x1,%esi
  8046fb:	bf 09 00 00 00       	mov    $0x9,%edi
  804700:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  804707:	00 00 00 
  80470a:	ff d0                	callq  *%rax
}
  80470c:	c9                   	leaveq 
  80470d:	c3                   	retq   

000000000080470e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80470e:	55                   	push   %rbp
  80470f:	48 89 e5             	mov    %rsp,%rbp
  804712:	48 83 ec 20          	sub    $0x20,%rsp
  804716:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804719:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80471d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804724:	48 98                	cltq   
  804726:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80472d:	00 
  80472e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804734:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80473a:	48 89 d1             	mov    %rdx,%rcx
  80473d:	48 89 c2             	mov    %rax,%rdx
  804740:	be 01 00 00 00       	mov    $0x1,%esi
  804745:	bf 0a 00 00 00       	mov    $0xa,%edi
  80474a:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  804751:	00 00 00 
  804754:	ff d0                	callq  *%rax
}
  804756:	c9                   	leaveq 
  804757:	c3                   	retq   

0000000000804758 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804758:	55                   	push   %rbp
  804759:	48 89 e5             	mov    %rsp,%rbp
  80475c:	48 83 ec 30          	sub    $0x30,%rsp
  804760:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804763:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804767:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80476b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80476e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804771:	48 63 f0             	movslq %eax,%rsi
  804774:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804778:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80477b:	48 98                	cltq   
  80477d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804781:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804788:	00 
  804789:	49 89 f1             	mov    %rsi,%r9
  80478c:	49 89 c8             	mov    %rcx,%r8
  80478f:	48 89 d1             	mov    %rdx,%rcx
  804792:	48 89 c2             	mov    %rax,%rdx
  804795:	be 00 00 00 00       	mov    $0x0,%esi
  80479a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80479f:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  8047a6:	00 00 00 
  8047a9:	ff d0                	callq  *%rax
}
  8047ab:	c9                   	leaveq 
  8047ac:	c3                   	retq   

00000000008047ad <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8047ad:	55                   	push   %rbp
  8047ae:	48 89 e5             	mov    %rsp,%rbp
  8047b1:	48 83 ec 20          	sub    $0x20,%rsp
  8047b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8047b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8047c4:	00 
  8047c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8047cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8047d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8047d6:	48 89 c2             	mov    %rax,%rdx
  8047d9:	be 01 00 00 00       	mov    $0x1,%esi
  8047de:	bf 0d 00 00 00       	mov    $0xd,%edi
  8047e3:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  8047ea:	00 00 00 
  8047ed:	ff d0                	callq  *%rax
}
  8047ef:	c9                   	leaveq 
  8047f0:	c3                   	retq   

00000000008047f1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8047f1:	55                   	push   %rbp
  8047f2:	48 89 e5             	mov    %rsp,%rbp
  8047f5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8047f9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804800:	00 
  804801:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804807:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80480d:	b9 00 00 00 00       	mov    $0x0,%ecx
  804812:	ba 00 00 00 00       	mov    $0x0,%edx
  804817:	be 00 00 00 00       	mov    $0x0,%esi
  80481c:	bf 0e 00 00 00       	mov    $0xe,%edi
  804821:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  804828:	00 00 00 
  80482b:	ff d0                	callq  *%rax
}
  80482d:	c9                   	leaveq 
  80482e:	c3                   	retq   

000000000080482f <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80482f:	55                   	push   %rbp
  804830:	48 89 e5             	mov    %rsp,%rbp
  804833:	48 83 ec 30          	sub    $0x30,%rsp
  804837:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80483a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80483e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804841:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804845:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  804849:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80484c:	48 63 c8             	movslq %eax,%rcx
  80484f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804853:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804856:	48 63 f0             	movslq %eax,%rsi
  804859:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80485d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804860:	48 98                	cltq   
  804862:	48 89 0c 24          	mov    %rcx,(%rsp)
  804866:	49 89 f9             	mov    %rdi,%r9
  804869:	49 89 f0             	mov    %rsi,%r8
  80486c:	48 89 d1             	mov    %rdx,%rcx
  80486f:	48 89 c2             	mov    %rax,%rdx
  804872:	be 00 00 00 00       	mov    $0x0,%esi
  804877:	bf 0f 00 00 00       	mov    $0xf,%edi
  80487c:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  804883:	00 00 00 
  804886:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  804888:	c9                   	leaveq 
  804889:	c3                   	retq   

000000000080488a <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80488a:	55                   	push   %rbp
  80488b:	48 89 e5             	mov    %rsp,%rbp
  80488e:	48 83 ec 20          	sub    $0x20,%rsp
  804892:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804896:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80489a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80489e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048a2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8048a9:	00 
  8048aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8048b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8048b6:	48 89 d1             	mov    %rdx,%rcx
  8048b9:	48 89 c2             	mov    %rax,%rdx
  8048bc:	be 00 00 00 00       	mov    $0x0,%esi
  8048c1:	bf 10 00 00 00       	mov    $0x10,%edi
  8048c6:	48 b8 a0 43 80 00 00 	movabs $0x8043a0,%rax
  8048cd:	00 00 00 
  8048d0:	ff d0                	callq  *%rax
}
  8048d2:	c9                   	leaveq 
  8048d3:	c3                   	retq   

00000000008048d4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8048d4:	55                   	push   %rbp
  8048d5:	48 89 e5             	mov    %rsp,%rbp
  8048d8:	48 83 ec 10          	sub    $0x10,%rsp
  8048dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8048e0:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  8048e7:	00 00 00 
  8048ea:	48 8b 00             	mov    (%rax),%rax
  8048ed:	48 85 c0             	test   %rax,%rax
  8048f0:	75 66                	jne    804958 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  8048f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8048f7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8048fc:	bf 00 00 00 00       	mov    $0x0,%edi
  804901:	48 b8 84 45 80 00 00 	movabs $0x804584,%rax
  804908:	00 00 00 
  80490b:	ff d0                	callq  *%rax
  80490d:	85 c0                	test   %eax,%eax
  80490f:	75 1d                	jne    80492e <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804911:	48 be 6c 49 80 00 00 	movabs $0x80496c,%rsi
  804918:	00 00 00 
  80491b:	bf 00 00 00 00       	mov    $0x0,%edi
  804920:	48 b8 0e 47 80 00 00 	movabs $0x80470e,%rax
  804927:	00 00 00 
  80492a:	ff d0                	callq  *%rax
  80492c:	eb 2a                	jmp    804958 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  80492e:	48 ba d3 74 80 00 00 	movabs $0x8074d3,%rdx
  804935:	00 00 00 
  804938:	be 23 00 00 00       	mov    $0x23,%esi
  80493d:	48 bf f1 74 80 00 00 	movabs $0x8074f1,%rdi
  804944:	00 00 00 
  804947:	b8 00 00 00 00       	mov    $0x0,%eax
  80494c:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  804953:	00 00 00 
  804956:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804958:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  80495f:	00 00 00 
  804962:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804966:	48 89 10             	mov    %rdx,(%rax)
}
  804969:	c9                   	leaveq 
  80496a:	c3                   	retq   
	...

000000000080496c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80496c:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80496f:	48 a1 20 20 81 00 00 	movabs 0x812020,%rax
  804976:	00 00 00 
call *%rax
  804979:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  80497b:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  80497f:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  804984:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  80498b:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  80498c:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  804990:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  804993:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  80499a:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  80499b:	4c 8b 3c 24          	mov    (%rsp),%r15
  80499f:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8049a4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8049a9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8049ae:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8049b3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8049b8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8049bd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8049c2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8049c7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8049cc:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8049d1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8049d6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8049db:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8049e0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8049e5:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  8049e9:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  8049ed:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  8049ee:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  8049ef:	c3                   	retq   

00000000008049f0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8049f0:	55                   	push   %rbp
  8049f1:	48 89 e5             	mov    %rsp,%rbp
  8049f4:	48 83 ec 30          	sub    $0x30,%rsp
  8049f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8049fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  804a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  804a0b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a10:	74 18                	je     804a2a <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  804a12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a16:	48 89 c7             	mov    %rax,%rdi
  804a19:	48 b8 ad 47 80 00 00 	movabs $0x8047ad,%rax
  804a20:	00 00 00 
  804a23:	ff d0                	callq  *%rax
  804a25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a28:	eb 19                	jmp    804a43 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  804a2a:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  804a31:	00 00 00 
  804a34:	48 b8 ad 47 80 00 00 	movabs $0x8047ad,%rax
  804a3b:	00 00 00 
  804a3e:	ff d0                	callq  *%rax
  804a40:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  804a43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a47:	79 39                	jns    804a82 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  804a49:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804a4e:	75 08                	jne    804a58 <ipc_recv+0x68>
  804a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a54:	8b 00                	mov    (%rax),%eax
  804a56:	eb 05                	jmp    804a5d <ipc_recv+0x6d>
  804a58:	b8 00 00 00 00       	mov    $0x0,%eax
  804a5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a61:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  804a63:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a68:	75 08                	jne    804a72 <ipc_recv+0x82>
  804a6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a6e:	8b 00                	mov    (%rax),%eax
  804a70:	eb 05                	jmp    804a77 <ipc_recv+0x87>
  804a72:	b8 00 00 00 00       	mov    $0x0,%eax
  804a77:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804a7b:	89 02                	mov    %eax,(%rdx)
		return r;
  804a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a80:	eb 53                	jmp    804ad5 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  804a82:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804a87:	74 19                	je     804aa2 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  804a89:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804a90:	00 00 00 
  804a93:	48 8b 00             	mov    (%rax),%rax
  804a96:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aa0:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  804aa2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804aa7:	74 19                	je     804ac2 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  804aa9:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804ab0:	00 00 00 
  804ab3:	48 8b 00             	mov    (%rax),%rax
  804ab6:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804abc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ac0:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  804ac2:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804ac9:	00 00 00 
  804acc:	48 8b 00             	mov    (%rax),%rax
  804acf:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  804ad5:	c9                   	leaveq 
  804ad6:	c3                   	retq   

0000000000804ad7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804ad7:	55                   	push   %rbp
  804ad8:	48 89 e5             	mov    %rsp,%rbp
  804adb:	48 83 ec 30          	sub    $0x30,%rsp
  804adf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804ae2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804ae5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804ae9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  804aec:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  804af3:	eb 59                	jmp    804b4e <ipc_send+0x77>
		if(pg) {
  804af5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804afa:	74 20                	je     804b1c <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  804afc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804aff:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804b02:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804b06:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b09:	89 c7                	mov    %eax,%edi
  804b0b:	48 b8 58 47 80 00 00 	movabs $0x804758,%rax
  804b12:	00 00 00 
  804b15:	ff d0                	callq  *%rax
  804b17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b1a:	eb 26                	jmp    804b42 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  804b1c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804b1f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804b22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b25:	89 d1                	mov    %edx,%ecx
  804b27:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  804b2e:	00 00 00 
  804b31:	89 c7                	mov    %eax,%edi
  804b33:	48 b8 58 47 80 00 00 	movabs $0x804758,%rax
  804b3a:	00 00 00 
  804b3d:	ff d0                	callq  *%rax
  804b3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  804b42:	48 b8 46 45 80 00 00 	movabs $0x804546,%rax
  804b49:	00 00 00 
  804b4c:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  804b4e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804b52:	74 a1                	je     804af5 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  804b54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b58:	74 2a                	je     804b84 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  804b5a:	48 ba 00 75 80 00 00 	movabs $0x807500,%rdx
  804b61:	00 00 00 
  804b64:	be 49 00 00 00       	mov    $0x49,%esi
  804b69:	48 bf 2b 75 80 00 00 	movabs $0x80752b,%rdi
  804b70:	00 00 00 
  804b73:	b8 00 00 00 00       	mov    $0x0,%eax
  804b78:	48 b9 40 2e 80 00 00 	movabs $0x802e40,%rcx
  804b7f:	00 00 00 
  804b82:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  804b84:	c9                   	leaveq 
  804b85:	c3                   	retq   

0000000000804b86 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804b86:	55                   	push   %rbp
  804b87:	48 89 e5             	mov    %rsp,%rbp
  804b8a:	48 83 ec 18          	sub    $0x18,%rsp
  804b8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804b91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804b98:	eb 6a                	jmp    804c04 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  804b9a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804ba1:	00 00 00 
  804ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ba7:	48 63 d0             	movslq %eax,%rdx
  804baa:	48 89 d0             	mov    %rdx,%rax
  804bad:	48 c1 e0 02          	shl    $0x2,%rax
  804bb1:	48 01 d0             	add    %rdx,%rax
  804bb4:	48 01 c0             	add    %rax,%rax
  804bb7:	48 01 d0             	add    %rdx,%rax
  804bba:	48 c1 e0 05          	shl    $0x5,%rax
  804bbe:	48 01 c8             	add    %rcx,%rax
  804bc1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804bc7:	8b 00                	mov    (%rax),%eax
  804bc9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804bcc:	75 32                	jne    804c00 <ipc_find_env+0x7a>
			return envs[i].env_id;
  804bce:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804bd5:	00 00 00 
  804bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bdb:	48 63 d0             	movslq %eax,%rdx
  804bde:	48 89 d0             	mov    %rdx,%rax
  804be1:	48 c1 e0 02          	shl    $0x2,%rax
  804be5:	48 01 d0             	add    %rdx,%rax
  804be8:	48 01 c0             	add    %rax,%rax
  804beb:	48 01 d0             	add    %rdx,%rax
  804bee:	48 c1 e0 05          	shl    $0x5,%rax
  804bf2:	48 01 c8             	add    %rcx,%rax
  804bf5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804bfb:	8b 40 08             	mov    0x8(%rax),%eax
  804bfe:	eb 12                	jmp    804c12 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804c00:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804c04:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804c0b:	7e 8d                	jle    804b9a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c12:	c9                   	leaveq 
  804c13:	c3                   	retq   

0000000000804c14 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  804c14:	55                   	push   %rbp
  804c15:	48 89 e5             	mov    %rsp,%rbp
  804c18:	48 83 ec 08          	sub    $0x8,%rsp
  804c1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  804c20:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804c24:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  804c2b:	ff ff ff 
  804c2e:	48 01 d0             	add    %rdx,%rax
  804c31:	48 c1 e8 0c          	shr    $0xc,%rax
}
  804c35:	c9                   	leaveq 
  804c36:	c3                   	retq   

0000000000804c37 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  804c37:	55                   	push   %rbp
  804c38:	48 89 e5             	mov    %rsp,%rbp
  804c3b:	48 83 ec 08          	sub    $0x8,%rsp
  804c3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  804c43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c47:	48 89 c7             	mov    %rax,%rdi
  804c4a:	48 b8 14 4c 80 00 00 	movabs $0x804c14,%rax
  804c51:	00 00 00 
  804c54:	ff d0                	callq  *%rax
  804c56:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  804c5c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  804c60:	c9                   	leaveq 
  804c61:	c3                   	retq   

0000000000804c62 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  804c62:	55                   	push   %rbp
  804c63:	48 89 e5             	mov    %rsp,%rbp
  804c66:	48 83 ec 18          	sub    $0x18,%rsp
  804c6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804c6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804c75:	eb 6b                	jmp    804ce2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  804c77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c7a:	48 98                	cltq   
  804c7c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804c82:	48 c1 e0 0c          	shl    $0xc,%rax
  804c86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  804c8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c8e:	48 89 c2             	mov    %rax,%rdx
  804c91:	48 c1 ea 15          	shr    $0x15,%rdx
  804c95:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c9c:	01 00 00 
  804c9f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ca3:	83 e0 01             	and    $0x1,%eax
  804ca6:	48 85 c0             	test   %rax,%rax
  804ca9:	74 21                	je     804ccc <fd_alloc+0x6a>
  804cab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804caf:	48 89 c2             	mov    %rax,%rdx
  804cb2:	48 c1 ea 0c          	shr    $0xc,%rdx
  804cb6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804cbd:	01 00 00 
  804cc0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804cc4:	83 e0 01             	and    $0x1,%eax
  804cc7:	48 85 c0             	test   %rax,%rax
  804cca:	75 12                	jne    804cde <fd_alloc+0x7c>
			*fd_store = fd;
  804ccc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804cd4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  804cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  804cdc:	eb 1a                	jmp    804cf8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804cde:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804ce2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  804ce6:	7e 8f                	jle    804c77 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  804ce8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cec:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  804cf3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  804cf8:	c9                   	leaveq 
  804cf9:	c3                   	retq   

0000000000804cfa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  804cfa:	55                   	push   %rbp
  804cfb:	48 89 e5             	mov    %rsp,%rbp
  804cfe:	48 83 ec 20          	sub    $0x20,%rsp
  804d02:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804d05:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  804d09:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804d0d:	78 06                	js     804d15 <fd_lookup+0x1b>
  804d0f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  804d13:	7e 07                	jle    804d1c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  804d15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804d1a:	eb 6c                	jmp    804d88 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  804d1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804d1f:	48 98                	cltq   
  804d21:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804d27:	48 c1 e0 0c          	shl    $0xc,%rax
  804d2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  804d2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d33:	48 89 c2             	mov    %rax,%rdx
  804d36:	48 c1 ea 15          	shr    $0x15,%rdx
  804d3a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804d41:	01 00 00 
  804d44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d48:	83 e0 01             	and    $0x1,%eax
  804d4b:	48 85 c0             	test   %rax,%rax
  804d4e:	74 21                	je     804d71 <fd_lookup+0x77>
  804d50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d54:	48 89 c2             	mov    %rax,%rdx
  804d57:	48 c1 ea 0c          	shr    $0xc,%rdx
  804d5b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804d62:	01 00 00 
  804d65:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d69:	83 e0 01             	and    $0x1,%eax
  804d6c:	48 85 c0             	test   %rax,%rax
  804d6f:	75 07                	jne    804d78 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  804d71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804d76:	eb 10                	jmp    804d88 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  804d78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d7c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804d80:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  804d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d88:	c9                   	leaveq 
  804d89:	c3                   	retq   

0000000000804d8a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  804d8a:	55                   	push   %rbp
  804d8b:	48 89 e5             	mov    %rsp,%rbp
  804d8e:	48 83 ec 30          	sub    $0x30,%rsp
  804d92:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804d96:	89 f0                	mov    %esi,%eax
  804d98:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  804d9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d9f:	48 89 c7             	mov    %rax,%rdi
  804da2:	48 b8 14 4c 80 00 00 	movabs $0x804c14,%rax
  804da9:	00 00 00 
  804dac:	ff d0                	callq  *%rax
  804dae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804db2:	48 89 d6             	mov    %rdx,%rsi
  804db5:	89 c7                	mov    %eax,%edi
  804db7:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  804dbe:	00 00 00 
  804dc1:	ff d0                	callq  *%rax
  804dc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804dc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804dca:	78 0a                	js     804dd6 <fd_close+0x4c>
	    || fd != fd2)
  804dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804dd0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  804dd4:	74 12                	je     804de8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  804dd6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  804dda:	74 05                	je     804de1 <fd_close+0x57>
  804ddc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ddf:	eb 05                	jmp    804de6 <fd_close+0x5c>
  804de1:	b8 00 00 00 00       	mov    $0x0,%eax
  804de6:	eb 69                	jmp    804e51 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  804de8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804dec:	8b 00                	mov    (%rax),%eax
  804dee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804df2:	48 89 d6             	mov    %rdx,%rsi
  804df5:	89 c7                	mov    %eax,%edi
  804df7:	48 b8 53 4e 80 00 00 	movabs $0x804e53,%rax
  804dfe:	00 00 00 
  804e01:	ff d0                	callq  *%rax
  804e03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e0a:	78 2a                	js     804e36 <fd_close+0xac>
		if (dev->dev_close)
  804e0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e10:	48 8b 40 20          	mov    0x20(%rax),%rax
  804e14:	48 85 c0             	test   %rax,%rax
  804e17:	74 16                	je     804e2f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  804e19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e1d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  804e21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e25:	48 89 c7             	mov    %rax,%rdi
  804e28:	ff d2                	callq  *%rdx
  804e2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e2d:	eb 07                	jmp    804e36 <fd_close+0xac>
		else
			r = 0;
  804e2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  804e36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e3a:	48 89 c6             	mov    %rax,%rsi
  804e3d:	bf 00 00 00 00       	mov    $0x0,%edi
  804e42:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  804e49:	00 00 00 
  804e4c:	ff d0                	callq  *%rax
	return r;
  804e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804e51:	c9                   	leaveq 
  804e52:	c3                   	retq   

0000000000804e53 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  804e53:	55                   	push   %rbp
  804e54:	48 89 e5             	mov    %rsp,%rbp
  804e57:	48 83 ec 20          	sub    $0x20,%rsp
  804e5b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804e5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  804e62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804e69:	eb 41                	jmp    804eac <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  804e6b:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  804e72:	00 00 00 
  804e75:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804e78:	48 63 d2             	movslq %edx,%rdx
  804e7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804e7f:	8b 00                	mov    (%rax),%eax
  804e81:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804e84:	75 22                	jne    804ea8 <dev_lookup+0x55>
			*dev = devtab[i];
  804e86:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  804e8d:	00 00 00 
  804e90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804e93:	48 63 d2             	movslq %edx,%rdx
  804e96:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  804e9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e9e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  804ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  804ea6:	eb 60                	jmp    804f08 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  804ea8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804eac:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  804eb3:	00 00 00 
  804eb6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804eb9:	48 63 d2             	movslq %edx,%rdx
  804ebc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ec0:	48 85 c0             	test   %rax,%rax
  804ec3:	75 a6                	jne    804e6b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  804ec5:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804ecc:	00 00 00 
  804ecf:	48 8b 00             	mov    (%rax),%rax
  804ed2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804ed8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804edb:	89 c6                	mov    %eax,%esi
  804edd:	48 bf 38 75 80 00 00 	movabs $0x807538,%rdi
  804ee4:	00 00 00 
  804ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  804eec:	48 b9 7b 30 80 00 00 	movabs $0x80307b,%rcx
  804ef3:	00 00 00 
  804ef6:	ff d1                	callq  *%rcx
	*dev = 0;
  804ef8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804efc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  804f03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  804f08:	c9                   	leaveq 
  804f09:	c3                   	retq   

0000000000804f0a <close>:

int
close(int fdnum)
{
  804f0a:	55                   	push   %rbp
  804f0b:	48 89 e5             	mov    %rsp,%rbp
  804f0e:	48 83 ec 20          	sub    $0x20,%rsp
  804f12:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804f15:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804f19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804f1c:	48 89 d6             	mov    %rdx,%rsi
  804f1f:	89 c7                	mov    %eax,%edi
  804f21:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  804f28:	00 00 00 
  804f2b:	ff d0                	callq  *%rax
  804f2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f34:	79 05                	jns    804f3b <close+0x31>
		return r;
  804f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f39:	eb 18                	jmp    804f53 <close+0x49>
	else
		return fd_close(fd, 1);
  804f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f3f:	be 01 00 00 00       	mov    $0x1,%esi
  804f44:	48 89 c7             	mov    %rax,%rdi
  804f47:	48 b8 8a 4d 80 00 00 	movabs $0x804d8a,%rax
  804f4e:	00 00 00 
  804f51:	ff d0                	callq  *%rax
}
  804f53:	c9                   	leaveq 
  804f54:	c3                   	retq   

0000000000804f55 <close_all>:

void
close_all(void)
{
  804f55:	55                   	push   %rbp
  804f56:	48 89 e5             	mov    %rsp,%rbp
  804f59:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  804f5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804f64:	eb 15                	jmp    804f7b <close_all+0x26>
		close(i);
  804f66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f69:	89 c7                	mov    %eax,%edi
  804f6b:	48 b8 0a 4f 80 00 00 	movabs $0x804f0a,%rax
  804f72:	00 00 00 
  804f75:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  804f77:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804f7b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  804f7f:	7e e5                	jle    804f66 <close_all+0x11>
		close(i);
}
  804f81:	c9                   	leaveq 
  804f82:	c3                   	retq   

0000000000804f83 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  804f83:	55                   	push   %rbp
  804f84:	48 89 e5             	mov    %rsp,%rbp
  804f87:	48 83 ec 40          	sub    $0x40,%rsp
  804f8b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804f8e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  804f91:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  804f95:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804f98:	48 89 d6             	mov    %rdx,%rsi
  804f9b:	89 c7                	mov    %eax,%edi
  804f9d:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  804fa4:	00 00 00 
  804fa7:	ff d0                	callq  *%rax
  804fa9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804fac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fb0:	79 08                	jns    804fba <dup+0x37>
		return r;
  804fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fb5:	e9 70 01 00 00       	jmpq   80512a <dup+0x1a7>
	close(newfdnum);
  804fba:	8b 45 c8             	mov    -0x38(%rbp),%eax
  804fbd:	89 c7                	mov    %eax,%edi
  804fbf:	48 b8 0a 4f 80 00 00 	movabs $0x804f0a,%rax
  804fc6:	00 00 00 
  804fc9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  804fcb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  804fce:	48 98                	cltq   
  804fd0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804fd6:	48 c1 e0 0c          	shl    $0xc,%rax
  804fda:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  804fde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804fe2:	48 89 c7             	mov    %rax,%rdi
  804fe5:	48 b8 37 4c 80 00 00 	movabs $0x804c37,%rax
  804fec:	00 00 00 
  804fef:	ff d0                	callq  *%rax
  804ff1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  804ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ff9:	48 89 c7             	mov    %rax,%rdi
  804ffc:	48 b8 37 4c 80 00 00 	movabs $0x804c37,%rax
  805003:	00 00 00 
  805006:	ff d0                	callq  *%rax
  805008:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80500c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805010:	48 89 c2             	mov    %rax,%rdx
  805013:	48 c1 ea 15          	shr    $0x15,%rdx
  805017:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80501e:	01 00 00 
  805021:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805025:	83 e0 01             	and    $0x1,%eax
  805028:	84 c0                	test   %al,%al
  80502a:	74 71                	je     80509d <dup+0x11a>
  80502c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805030:	48 89 c2             	mov    %rax,%rdx
  805033:	48 c1 ea 0c          	shr    $0xc,%rdx
  805037:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80503e:	01 00 00 
  805041:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805045:	83 e0 01             	and    $0x1,%eax
  805048:	84 c0                	test   %al,%al
  80504a:	74 51                	je     80509d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80504c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805050:	48 89 c2             	mov    %rax,%rdx
  805053:	48 c1 ea 0c          	shr    $0xc,%rdx
  805057:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80505e:	01 00 00 
  805061:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805065:	89 c1                	mov    %eax,%ecx
  805067:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80506d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805075:	41 89 c8             	mov    %ecx,%r8d
  805078:	48 89 d1             	mov    %rdx,%rcx
  80507b:	ba 00 00 00 00       	mov    $0x0,%edx
  805080:	48 89 c6             	mov    %rax,%rsi
  805083:	bf 00 00 00 00       	mov    $0x0,%edi
  805088:	48 b8 d4 45 80 00 00 	movabs $0x8045d4,%rax
  80508f:	00 00 00 
  805092:	ff d0                	callq  *%rax
  805094:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805097:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80509b:	78 56                	js     8050f3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80509d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050a1:	48 89 c2             	mov    %rax,%rdx
  8050a4:	48 c1 ea 0c          	shr    $0xc,%rdx
  8050a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8050af:	01 00 00 
  8050b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050b6:	89 c1                	mov    %eax,%ecx
  8050b8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8050be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8050c6:	41 89 c8             	mov    %ecx,%r8d
  8050c9:	48 89 d1             	mov    %rdx,%rcx
  8050cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8050d1:	48 89 c6             	mov    %rax,%rsi
  8050d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8050d9:	48 b8 d4 45 80 00 00 	movabs $0x8045d4,%rax
  8050e0:	00 00 00 
  8050e3:	ff d0                	callq  *%rax
  8050e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8050e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8050ec:	78 08                	js     8050f6 <dup+0x173>
		goto err;

	return newfdnum;
  8050ee:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8050f1:	eb 37                	jmp    80512a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8050f3:	90                   	nop
  8050f4:	eb 01                	jmp    8050f7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8050f6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8050f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050fb:	48 89 c6             	mov    %rax,%rsi
  8050fe:	bf 00 00 00 00       	mov    $0x0,%edi
  805103:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  80510a:	00 00 00 
  80510d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80510f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805113:	48 89 c6             	mov    %rax,%rsi
  805116:	bf 00 00 00 00       	mov    $0x0,%edi
  80511b:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  805122:	00 00 00 
  805125:	ff d0                	callq  *%rax
	return r;
  805127:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80512a:	c9                   	leaveq 
  80512b:	c3                   	retq   

000000000080512c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80512c:	55                   	push   %rbp
  80512d:	48 89 e5             	mov    %rsp,%rbp
  805130:	48 83 ec 40          	sub    $0x40,%rsp
  805134:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805137:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80513b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80513f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805143:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805146:	48 89 d6             	mov    %rdx,%rsi
  805149:	89 c7                	mov    %eax,%edi
  80514b:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  805152:	00 00 00 
  805155:	ff d0                	callq  *%rax
  805157:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80515a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80515e:	78 24                	js     805184 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805164:	8b 00                	mov    (%rax),%eax
  805166:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80516a:	48 89 d6             	mov    %rdx,%rsi
  80516d:	89 c7                	mov    %eax,%edi
  80516f:	48 b8 53 4e 80 00 00 	movabs $0x804e53,%rax
  805176:	00 00 00 
  805179:	ff d0                	callq  *%rax
  80517b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80517e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805182:	79 05                	jns    805189 <read+0x5d>
		return r;
  805184:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805187:	eb 7a                	jmp    805203 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  805189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80518d:	8b 40 08             	mov    0x8(%rax),%eax
  805190:	83 e0 03             	and    $0x3,%eax
  805193:	83 f8 01             	cmp    $0x1,%eax
  805196:	75 3a                	jne    8051d2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  805198:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  80519f:	00 00 00 
  8051a2:	48 8b 00             	mov    (%rax),%rax
  8051a5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8051ab:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8051ae:	89 c6                	mov    %eax,%esi
  8051b0:	48 bf 57 75 80 00 00 	movabs $0x807557,%rdi
  8051b7:	00 00 00 
  8051ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8051bf:	48 b9 7b 30 80 00 00 	movabs $0x80307b,%rcx
  8051c6:	00 00 00 
  8051c9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8051cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8051d0:	eb 31                	jmp    805203 <read+0xd7>
	}
	if (!dev->dev_read)
  8051d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051d6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8051da:	48 85 c0             	test   %rax,%rax
  8051dd:	75 07                	jne    8051e6 <read+0xba>
		return -E_NOT_SUPP;
  8051df:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8051e4:	eb 1d                	jmp    805203 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8051e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051ea:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8051ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051f2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8051f6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8051fa:	48 89 ce             	mov    %rcx,%rsi
  8051fd:	48 89 c7             	mov    %rax,%rdi
  805200:	41 ff d0             	callq  *%r8
}
  805203:	c9                   	leaveq 
  805204:	c3                   	retq   

0000000000805205 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  805205:	55                   	push   %rbp
  805206:	48 89 e5             	mov    %rsp,%rbp
  805209:	48 83 ec 30          	sub    $0x30,%rsp
  80520d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805210:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805214:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805218:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80521f:	eb 46                	jmp    805267 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  805221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805224:	48 98                	cltq   
  805226:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80522a:	48 29 c2             	sub    %rax,%rdx
  80522d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805230:	48 98                	cltq   
  805232:	48 89 c1             	mov    %rax,%rcx
  805235:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  805239:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80523c:	48 89 ce             	mov    %rcx,%rsi
  80523f:	89 c7                	mov    %eax,%edi
  805241:	48 b8 2c 51 80 00 00 	movabs $0x80512c,%rax
  805248:	00 00 00 
  80524b:	ff d0                	callq  *%rax
  80524d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  805250:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805254:	79 05                	jns    80525b <readn+0x56>
			return m;
  805256:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805259:	eb 1d                	jmp    805278 <readn+0x73>
		if (m == 0)
  80525b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80525f:	74 13                	je     805274 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805261:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805264:	01 45 fc             	add    %eax,-0x4(%rbp)
  805267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80526a:	48 98                	cltq   
  80526c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805270:	72 af                	jb     805221 <readn+0x1c>
  805272:	eb 01                	jmp    805275 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  805274:	90                   	nop
	}
	return tot;
  805275:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805278:	c9                   	leaveq 
  805279:	c3                   	retq   

000000000080527a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80527a:	55                   	push   %rbp
  80527b:	48 89 e5             	mov    %rsp,%rbp
  80527e:	48 83 ec 40          	sub    $0x40,%rsp
  805282:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805285:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805289:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80528d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805291:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805294:	48 89 d6             	mov    %rdx,%rsi
  805297:	89 c7                	mov    %eax,%edi
  805299:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  8052a0:	00 00 00 
  8052a3:	ff d0                	callq  *%rax
  8052a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8052a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8052ac:	78 24                	js     8052d2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8052ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052b2:	8b 00                	mov    (%rax),%eax
  8052b4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8052b8:	48 89 d6             	mov    %rdx,%rsi
  8052bb:	89 c7                	mov    %eax,%edi
  8052bd:	48 b8 53 4e 80 00 00 	movabs $0x804e53,%rax
  8052c4:	00 00 00 
  8052c7:	ff d0                	callq  *%rax
  8052c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8052cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8052d0:	79 05                	jns    8052d7 <write+0x5d>
		return r;
  8052d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052d5:	eb 79                	jmp    805350 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8052d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052db:	8b 40 08             	mov    0x8(%rax),%eax
  8052de:	83 e0 03             	and    $0x3,%eax
  8052e1:	85 c0                	test   %eax,%eax
  8052e3:	75 3a                	jne    80531f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8052e5:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8052ec:	00 00 00 
  8052ef:	48 8b 00             	mov    (%rax),%rax
  8052f2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8052f8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8052fb:	89 c6                	mov    %eax,%esi
  8052fd:	48 bf 73 75 80 00 00 	movabs $0x807573,%rdi
  805304:	00 00 00 
  805307:	b8 00 00 00 00       	mov    $0x0,%eax
  80530c:	48 b9 7b 30 80 00 00 	movabs $0x80307b,%rcx
  805313:	00 00 00 
  805316:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805318:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80531d:	eb 31                	jmp    805350 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80531f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805323:	48 8b 40 18          	mov    0x18(%rax),%rax
  805327:	48 85 c0             	test   %rax,%rax
  80532a:	75 07                	jne    805333 <write+0xb9>
		return -E_NOT_SUPP;
  80532c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805331:	eb 1d                	jmp    805350 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  805333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805337:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80533b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80533f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805343:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805347:	48 89 ce             	mov    %rcx,%rsi
  80534a:	48 89 c7             	mov    %rax,%rdi
  80534d:	41 ff d0             	callq  *%r8
}
  805350:	c9                   	leaveq 
  805351:	c3                   	retq   

0000000000805352 <seek>:

int
seek(int fdnum, off_t offset)
{
  805352:	55                   	push   %rbp
  805353:	48 89 e5             	mov    %rsp,%rbp
  805356:	48 83 ec 18          	sub    $0x18,%rsp
  80535a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80535d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805360:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805364:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805367:	48 89 d6             	mov    %rdx,%rsi
  80536a:	89 c7                	mov    %eax,%edi
  80536c:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  805373:	00 00 00 
  805376:	ff d0                	callq  *%rax
  805378:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80537b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80537f:	79 05                	jns    805386 <seek+0x34>
		return r;
  805381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805384:	eb 0f                	jmp    805395 <seek+0x43>
	fd->fd_offset = offset;
  805386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80538a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80538d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  805390:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805395:	c9                   	leaveq 
  805396:	c3                   	retq   

0000000000805397 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  805397:	55                   	push   %rbp
  805398:	48 89 e5             	mov    %rsp,%rbp
  80539b:	48 83 ec 30          	sub    $0x30,%rsp
  80539f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8053a2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8053a5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8053a9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8053ac:	48 89 d6             	mov    %rdx,%rsi
  8053af:	89 c7                	mov    %eax,%edi
  8053b1:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  8053b8:	00 00 00 
  8053bb:	ff d0                	callq  *%rax
  8053bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8053c4:	78 24                	js     8053ea <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8053c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053ca:	8b 00                	mov    (%rax),%eax
  8053cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8053d0:	48 89 d6             	mov    %rdx,%rsi
  8053d3:	89 c7                	mov    %eax,%edi
  8053d5:	48 b8 53 4e 80 00 00 	movabs $0x804e53,%rax
  8053dc:	00 00 00 
  8053df:	ff d0                	callq  *%rax
  8053e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8053e8:	79 05                	jns    8053ef <ftruncate+0x58>
		return r;
  8053ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053ed:	eb 72                	jmp    805461 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8053ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053f3:	8b 40 08             	mov    0x8(%rax),%eax
  8053f6:	83 e0 03             	and    $0x3,%eax
  8053f9:	85 c0                	test   %eax,%eax
  8053fb:	75 3a                	jne    805437 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8053fd:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805404:	00 00 00 
  805407:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80540a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805410:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805413:	89 c6                	mov    %eax,%esi
  805415:	48 bf 90 75 80 00 00 	movabs $0x807590,%rdi
  80541c:	00 00 00 
  80541f:	b8 00 00 00 00       	mov    $0x0,%eax
  805424:	48 b9 7b 30 80 00 00 	movabs $0x80307b,%rcx
  80542b:	00 00 00 
  80542e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805435:	eb 2a                	jmp    805461 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  805437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80543b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80543f:	48 85 c0             	test   %rax,%rax
  805442:	75 07                	jne    80544b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  805444:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805449:	eb 16                	jmp    805461 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80544b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80544f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  805453:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805457:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80545a:	89 d6                	mov    %edx,%esi
  80545c:	48 89 c7             	mov    %rax,%rdi
  80545f:	ff d1                	callq  *%rcx
}
  805461:	c9                   	leaveq 
  805462:	c3                   	retq   

0000000000805463 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  805463:	55                   	push   %rbp
  805464:	48 89 e5             	mov    %rsp,%rbp
  805467:	48 83 ec 30          	sub    $0x30,%rsp
  80546b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80546e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805472:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805476:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805479:	48 89 d6             	mov    %rdx,%rsi
  80547c:	89 c7                	mov    %eax,%edi
  80547e:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  805485:	00 00 00 
  805488:	ff d0                	callq  *%rax
  80548a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80548d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805491:	78 24                	js     8054b7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805497:	8b 00                	mov    (%rax),%eax
  805499:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80549d:	48 89 d6             	mov    %rdx,%rsi
  8054a0:	89 c7                	mov    %eax,%edi
  8054a2:	48 b8 53 4e 80 00 00 	movabs $0x804e53,%rax
  8054a9:	00 00 00 
  8054ac:	ff d0                	callq  *%rax
  8054ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054b5:	79 05                	jns    8054bc <fstat+0x59>
		return r;
  8054b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054ba:	eb 5e                	jmp    80551a <fstat+0xb7>
	if (!dev->dev_stat)
  8054bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054c0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8054c4:	48 85 c0             	test   %rax,%rax
  8054c7:	75 07                	jne    8054d0 <fstat+0x6d>
		return -E_NOT_SUPP;
  8054c9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8054ce:	eb 4a                	jmp    80551a <fstat+0xb7>
	stat->st_name[0] = 0;
  8054d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054d4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8054d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8054e2:	00 00 00 
	stat->st_isdir = 0;
  8054e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054e9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8054f0:	00 00 00 
	stat->st_dev = dev;
  8054f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8054f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054fb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805506:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80550a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80550e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  805512:	48 89 d6             	mov    %rdx,%rsi
  805515:	48 89 c7             	mov    %rax,%rdi
  805518:	ff d1                	callq  *%rcx
}
  80551a:	c9                   	leaveq 
  80551b:	c3                   	retq   

000000000080551c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80551c:	55                   	push   %rbp
  80551d:	48 89 e5             	mov    %rsp,%rbp
  805520:	48 83 ec 20          	sub    $0x20,%rsp
  805524:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805528:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80552c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805530:	be 00 00 00 00       	mov    $0x0,%esi
  805535:	48 89 c7             	mov    %rax,%rdi
  805538:	48 b8 0b 56 80 00 00 	movabs $0x80560b,%rax
  80553f:	00 00 00 
  805542:	ff d0                	callq  *%rax
  805544:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805547:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80554b:	79 05                	jns    805552 <stat+0x36>
		return fd;
  80554d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805550:	eb 2f                	jmp    805581 <stat+0x65>
	r = fstat(fd, stat);
  805552:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805556:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805559:	48 89 d6             	mov    %rdx,%rsi
  80555c:	89 c7                	mov    %eax,%edi
  80555e:	48 b8 63 54 80 00 00 	movabs $0x805463,%rax
  805565:	00 00 00 
  805568:	ff d0                	callq  *%rax
  80556a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80556d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805570:	89 c7                	mov    %eax,%edi
  805572:	48 b8 0a 4f 80 00 00 	movabs $0x804f0a,%rax
  805579:	00 00 00 
  80557c:	ff d0                	callq  *%rax
	return r;
  80557e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805581:	c9                   	leaveq 
  805582:	c3                   	retq   
	...

0000000000805584 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805584:	55                   	push   %rbp
  805585:	48 89 e5             	mov    %rsp,%rbp
  805588:	48 83 ec 10          	sub    $0x10,%rsp
  80558c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80558f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805593:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  80559a:	00 00 00 
  80559d:	8b 00                	mov    (%rax),%eax
  80559f:	85 c0                	test   %eax,%eax
  8055a1:	75 1d                	jne    8055c0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8055a3:	bf 01 00 00 00       	mov    $0x1,%edi
  8055a8:	48 b8 86 4b 80 00 00 	movabs $0x804b86,%rax
  8055af:	00 00 00 
  8055b2:	ff d0                	callq  *%rax
  8055b4:	48 ba 00 20 81 00 00 	movabs $0x812000,%rdx
  8055bb:	00 00 00 
  8055be:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8055c0:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  8055c7:	00 00 00 
  8055ca:	8b 00                	mov    (%rax),%eax
  8055cc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8055cf:	b9 07 00 00 00       	mov    $0x7,%ecx
  8055d4:	48 ba 00 30 81 00 00 	movabs $0x813000,%rdx
  8055db:	00 00 00 
  8055de:	89 c7                	mov    %eax,%edi
  8055e0:	48 b8 d7 4a 80 00 00 	movabs $0x804ad7,%rax
  8055e7:	00 00 00 
  8055ea:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8055ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8055f5:	48 89 c6             	mov    %rax,%rsi
  8055f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8055fd:	48 b8 f0 49 80 00 00 	movabs $0x8049f0,%rax
  805604:	00 00 00 
  805607:	ff d0                	callq  *%rax
}
  805609:	c9                   	leaveq 
  80560a:	c3                   	retq   

000000000080560b <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  80560b:	55                   	push   %rbp
  80560c:	48 89 e5             	mov    %rsp,%rbp
  80560f:	48 83 ec 20          	sub    $0x20,%rsp
  805613:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805617:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  80561a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80561e:	48 89 c7             	mov    %rax,%rdi
  805621:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  805628:	00 00 00 
  80562b:	ff d0                	callq  *%rax
  80562d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805632:	7e 0a                	jle    80563e <open+0x33>
		return -E_BAD_PATH;
  805634:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805639:	e9 a5 00 00 00       	jmpq   8056e3 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  80563e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  805642:	48 89 c7             	mov    %rax,%rdi
  805645:	48 b8 62 4c 80 00 00 	movabs $0x804c62,%rax
  80564c:	00 00 00 
  80564f:	ff d0                	callq  *%rax
  805651:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  805654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805658:	79 08                	jns    805662 <open+0x57>
		return r;
  80565a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80565d:	e9 81 00 00 00       	jmpq   8056e3 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  805662:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805669:	00 00 00 
  80566c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80566f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  805675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805679:	48 89 c6             	mov    %rax,%rsi
  80567c:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  805683:	00 00 00 
  805686:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  80568d:	00 00 00 
  805690:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  805692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805696:	48 89 c6             	mov    %rax,%rsi
  805699:	bf 01 00 00 00       	mov    $0x1,%edi
  80569e:	48 b8 84 55 80 00 00 	movabs $0x805584,%rax
  8056a5:	00 00 00 
  8056a8:	ff d0                	callq  *%rax
  8056aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8056ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056b1:	79 1d                	jns    8056d0 <open+0xc5>
		fd_close(new_fd, 0);
  8056b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056b7:	be 00 00 00 00       	mov    $0x0,%esi
  8056bc:	48 89 c7             	mov    %rax,%rdi
  8056bf:	48 b8 8a 4d 80 00 00 	movabs $0x804d8a,%rax
  8056c6:	00 00 00 
  8056c9:	ff d0                	callq  *%rax
		return r;	
  8056cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056ce:	eb 13                	jmp    8056e3 <open+0xd8>
	}
	return fd2num(new_fd);
  8056d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056d4:	48 89 c7             	mov    %rax,%rdi
  8056d7:	48 b8 14 4c 80 00 00 	movabs $0x804c14,%rax
  8056de:	00 00 00 
  8056e1:	ff d0                	callq  *%rax
}
  8056e3:	c9                   	leaveq 
  8056e4:	c3                   	retq   

00000000008056e5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8056e5:	55                   	push   %rbp
  8056e6:	48 89 e5             	mov    %rsp,%rbp
  8056e9:	48 83 ec 10          	sub    $0x10,%rsp
  8056ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8056f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056f5:	8b 50 0c             	mov    0xc(%rax),%edx
  8056f8:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8056ff:	00 00 00 
  805702:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805704:	be 00 00 00 00       	mov    $0x0,%esi
  805709:	bf 06 00 00 00       	mov    $0x6,%edi
  80570e:	48 b8 84 55 80 00 00 	movabs $0x805584,%rax
  805715:	00 00 00 
  805718:	ff d0                	callq  *%rax
}
  80571a:	c9                   	leaveq 
  80571b:	c3                   	retq   

000000000080571c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80571c:	55                   	push   %rbp
  80571d:	48 89 e5             	mov    %rsp,%rbp
  805720:	48 83 ec 30          	sub    $0x30,%rsp
  805724:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805728:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80572c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  805730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805734:	8b 50 0c             	mov    0xc(%rax),%edx
  805737:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  80573e:	00 00 00 
  805741:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  805743:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  80574a:	00 00 00 
  80574d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805751:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  805755:	be 00 00 00 00       	mov    $0x0,%esi
  80575a:	bf 03 00 00 00       	mov    $0x3,%edi
  80575f:	48 b8 84 55 80 00 00 	movabs $0x805584,%rax
  805766:	00 00 00 
  805769:	ff d0                	callq  *%rax
  80576b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  80576e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805772:	7e 23                	jle    805797 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  805774:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805777:	48 63 d0             	movslq %eax,%rdx
  80577a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80577e:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805785:	00 00 00 
  805788:	48 89 c7             	mov    %rax,%rdi
  80578b:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  805792:	00 00 00 
  805795:	ff d0                	callq  *%rax
	}
	return nbytes;
  805797:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80579a:	c9                   	leaveq 
  80579b:	c3                   	retq   

000000000080579c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80579c:	55                   	push   %rbp
  80579d:	48 89 e5             	mov    %rsp,%rbp
  8057a0:	48 83 ec 20          	sub    $0x20,%rsp
  8057a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8057a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8057ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057b0:	8b 50 0c             	mov    0xc(%rax),%edx
  8057b3:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8057ba:	00 00 00 
  8057bd:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8057bf:	be 00 00 00 00       	mov    $0x0,%esi
  8057c4:	bf 05 00 00 00       	mov    $0x5,%edi
  8057c9:	48 b8 84 55 80 00 00 	movabs $0x805584,%rax
  8057d0:	00 00 00 
  8057d3:	ff d0                	callq  *%rax
  8057d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057dc:	79 05                	jns    8057e3 <devfile_stat+0x47>
		return r;
  8057de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057e1:	eb 56                	jmp    805839 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8057e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8057e7:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  8057ee:	00 00 00 
  8057f1:	48 89 c7             	mov    %rax,%rdi
  8057f4:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  8057fb:	00 00 00 
  8057fe:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805800:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805807:	00 00 00 
  80580a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805810:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805814:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80581a:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805821:	00 00 00 
  805824:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80582a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80582e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805839:	c9                   	leaveq 
  80583a:	c3                   	retq   
	...

000000000080583c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80583c:	55                   	push   %rbp
  80583d:	48 89 e5             	mov    %rsp,%rbp
  805840:	48 83 ec 18          	sub    $0x18,%rsp
  805844:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80584c:	48 89 c2             	mov    %rax,%rdx
  80584f:	48 c1 ea 15          	shr    $0x15,%rdx
  805853:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80585a:	01 00 00 
  80585d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805861:	83 e0 01             	and    $0x1,%eax
  805864:	48 85 c0             	test   %rax,%rax
  805867:	75 07                	jne    805870 <pageref+0x34>
		return 0;
  805869:	b8 00 00 00 00       	mov    $0x0,%eax
  80586e:	eb 53                	jmp    8058c3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805874:	48 89 c2             	mov    %rax,%rdx
  805877:	48 c1 ea 0c          	shr    $0xc,%rdx
  80587b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805882:	01 00 00 
  805885:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805889:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80588d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805891:	83 e0 01             	and    $0x1,%eax
  805894:	48 85 c0             	test   %rax,%rax
  805897:	75 07                	jne    8058a0 <pageref+0x64>
		return 0;
  805899:	b8 00 00 00 00       	mov    $0x0,%eax
  80589e:	eb 23                	jmp    8058c3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8058a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058a4:	48 89 c2             	mov    %rax,%rdx
  8058a7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8058ab:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8058b2:	00 00 00 
  8058b5:	48 c1 e2 04          	shl    $0x4,%rdx
  8058b9:	48 01 d0             	add    %rdx,%rax
  8058bc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8058c0:	0f b7 c0             	movzwl %ax,%eax
}
  8058c3:	c9                   	leaveq 
  8058c4:	c3                   	retq   
  8058c5:	00 00                	add    %al,(%rax)
	...

00000000008058c8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8058c8:	55                   	push   %rbp
  8058c9:	48 89 e5             	mov    %rsp,%rbp
  8058cc:	48 83 ec 20          	sub    $0x20,%rsp
  8058d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8058d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8058d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8058da:	48 89 d6             	mov    %rdx,%rsi
  8058dd:	89 c7                	mov    %eax,%edi
  8058df:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  8058e6:	00 00 00 
  8058e9:	ff d0                	callq  *%rax
  8058eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058f2:	79 05                	jns    8058f9 <fd2sockid+0x31>
		return r;
  8058f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058f7:	eb 24                	jmp    80591d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8058f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058fd:	8b 10                	mov    (%rax),%edx
  8058ff:	48 b8 20 11 81 00 00 	movabs $0x811120,%rax
  805906:	00 00 00 
  805909:	8b 00                	mov    (%rax),%eax
  80590b:	39 c2                	cmp    %eax,%edx
  80590d:	74 07                	je     805916 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80590f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805914:	eb 07                	jmp    80591d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  805916:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80591a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80591d:	c9                   	leaveq 
  80591e:	c3                   	retq   

000000000080591f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80591f:	55                   	push   %rbp
  805920:	48 89 e5             	mov    %rsp,%rbp
  805923:	48 83 ec 20          	sub    $0x20,%rsp
  805927:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80592a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80592e:	48 89 c7             	mov    %rax,%rdi
  805931:	48 b8 62 4c 80 00 00 	movabs $0x804c62,%rax
  805938:	00 00 00 
  80593b:	ff d0                	callq  *%rax
  80593d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805940:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805944:	78 26                	js     80596c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  805946:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80594a:	ba 07 04 00 00       	mov    $0x407,%edx
  80594f:	48 89 c6             	mov    %rax,%rsi
  805952:	bf 00 00 00 00       	mov    $0x0,%edi
  805957:	48 b8 84 45 80 00 00 	movabs $0x804584,%rax
  80595e:	00 00 00 
  805961:	ff d0                	callq  *%rax
  805963:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805966:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80596a:	79 16                	jns    805982 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80596c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80596f:	89 c7                	mov    %eax,%edi
  805971:	48 b8 2c 5e 80 00 00 	movabs $0x805e2c,%rax
  805978:	00 00 00 
  80597b:	ff d0                	callq  *%rax
		return r;
  80597d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805980:	eb 3a                	jmp    8059bc <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  805982:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805986:	48 ba 20 11 81 00 00 	movabs $0x811120,%rdx
  80598d:	00 00 00 
  805990:	8b 12                	mov    (%rdx),%edx
  805992:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  805994:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805998:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80599f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059a3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8059a6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8059a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059ad:	48 89 c7             	mov    %rax,%rdi
  8059b0:	48 b8 14 4c 80 00 00 	movabs $0x804c14,%rax
  8059b7:	00 00 00 
  8059ba:	ff d0                	callq  *%rax
}
  8059bc:	c9                   	leaveq 
  8059bd:	c3                   	retq   

00000000008059be <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8059be:	55                   	push   %rbp
  8059bf:	48 89 e5             	mov    %rsp,%rbp
  8059c2:	48 83 ec 30          	sub    $0x30,%rsp
  8059c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8059c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8059cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8059d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8059d4:	89 c7                	mov    %eax,%edi
  8059d6:	48 b8 c8 58 80 00 00 	movabs $0x8058c8,%rax
  8059dd:	00 00 00 
  8059e0:	ff d0                	callq  *%rax
  8059e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059e9:	79 05                	jns    8059f0 <accept+0x32>
		return r;
  8059eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059ee:	eb 3b                	jmp    805a2b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8059f0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8059f4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8059f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059fb:	48 89 ce             	mov    %rcx,%rsi
  8059fe:	89 c7                	mov    %eax,%edi
  805a00:	48 b8 09 5d 80 00 00 	movabs $0x805d09,%rax
  805a07:	00 00 00 
  805a0a:	ff d0                	callq  *%rax
  805a0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a13:	79 05                	jns    805a1a <accept+0x5c>
		return r;
  805a15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a18:	eb 11                	jmp    805a2b <accept+0x6d>
	return alloc_sockfd(r);
  805a1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a1d:	89 c7                	mov    %eax,%edi
  805a1f:	48 b8 1f 59 80 00 00 	movabs $0x80591f,%rax
  805a26:	00 00 00 
  805a29:	ff d0                	callq  *%rax
}
  805a2b:	c9                   	leaveq 
  805a2c:	c3                   	retq   

0000000000805a2d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805a2d:	55                   	push   %rbp
  805a2e:	48 89 e5             	mov    %rsp,%rbp
  805a31:	48 83 ec 20          	sub    $0x20,%rsp
  805a35:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805a38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805a3c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805a3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805a42:	89 c7                	mov    %eax,%edi
  805a44:	48 b8 c8 58 80 00 00 	movabs $0x8058c8,%rax
  805a4b:	00 00 00 
  805a4e:	ff d0                	callq  *%rax
  805a50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a57:	79 05                	jns    805a5e <bind+0x31>
		return r;
  805a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a5c:	eb 1b                	jmp    805a79 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  805a5e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805a61:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a68:	48 89 ce             	mov    %rcx,%rsi
  805a6b:	89 c7                	mov    %eax,%edi
  805a6d:	48 b8 88 5d 80 00 00 	movabs $0x805d88,%rax
  805a74:	00 00 00 
  805a77:	ff d0                	callq  *%rax
}
  805a79:	c9                   	leaveq 
  805a7a:	c3                   	retq   

0000000000805a7b <shutdown>:

int
shutdown(int s, int how)
{
  805a7b:	55                   	push   %rbp
  805a7c:	48 89 e5             	mov    %rsp,%rbp
  805a7f:	48 83 ec 20          	sub    $0x20,%rsp
  805a83:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805a86:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805a89:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805a8c:	89 c7                	mov    %eax,%edi
  805a8e:	48 b8 c8 58 80 00 00 	movabs $0x8058c8,%rax
  805a95:	00 00 00 
  805a98:	ff d0                	callq  *%rax
  805a9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805aa1:	79 05                	jns    805aa8 <shutdown+0x2d>
		return r;
  805aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805aa6:	eb 16                	jmp    805abe <shutdown+0x43>
	return nsipc_shutdown(r, how);
  805aa8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805aae:	89 d6                	mov    %edx,%esi
  805ab0:	89 c7                	mov    %eax,%edi
  805ab2:	48 b8 ec 5d 80 00 00 	movabs $0x805dec,%rax
  805ab9:	00 00 00 
  805abc:	ff d0                	callq  *%rax
}
  805abe:	c9                   	leaveq 
  805abf:	c3                   	retq   

0000000000805ac0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  805ac0:	55                   	push   %rbp
  805ac1:	48 89 e5             	mov    %rsp,%rbp
  805ac4:	48 83 ec 10          	sub    $0x10,%rsp
  805ac8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  805acc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ad0:	48 89 c7             	mov    %rax,%rdi
  805ad3:	48 b8 3c 58 80 00 00 	movabs $0x80583c,%rax
  805ada:	00 00 00 
  805add:	ff d0                	callq  *%rax
  805adf:	83 f8 01             	cmp    $0x1,%eax
  805ae2:	75 17                	jne    805afb <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  805ae4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ae8:	8b 40 0c             	mov    0xc(%rax),%eax
  805aeb:	89 c7                	mov    %eax,%edi
  805aed:	48 b8 2c 5e 80 00 00 	movabs $0x805e2c,%rax
  805af4:	00 00 00 
  805af7:	ff d0                	callq  *%rax
  805af9:	eb 05                	jmp    805b00 <devsock_close+0x40>
	else
		return 0;
  805afb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805b00:	c9                   	leaveq 
  805b01:	c3                   	retq   

0000000000805b02 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805b02:	55                   	push   %rbp
  805b03:	48 89 e5             	mov    %rsp,%rbp
  805b06:	48 83 ec 20          	sub    $0x20,%rsp
  805b0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805b0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805b11:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805b14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805b17:	89 c7                	mov    %eax,%edi
  805b19:	48 b8 c8 58 80 00 00 	movabs $0x8058c8,%rax
  805b20:	00 00 00 
  805b23:	ff d0                	callq  *%rax
  805b25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b2c:	79 05                	jns    805b33 <connect+0x31>
		return r;
  805b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b31:	eb 1b                	jmp    805b4e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  805b33:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805b36:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b3d:	48 89 ce             	mov    %rcx,%rsi
  805b40:	89 c7                	mov    %eax,%edi
  805b42:	48 b8 59 5e 80 00 00 	movabs $0x805e59,%rax
  805b49:	00 00 00 
  805b4c:	ff d0                	callq  *%rax
}
  805b4e:	c9                   	leaveq 
  805b4f:	c3                   	retq   

0000000000805b50 <listen>:

int
listen(int s, int backlog)
{
  805b50:	55                   	push   %rbp
  805b51:	48 89 e5             	mov    %rsp,%rbp
  805b54:	48 83 ec 20          	sub    $0x20,%rsp
  805b58:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805b5b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805b5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805b61:	89 c7                	mov    %eax,%edi
  805b63:	48 b8 c8 58 80 00 00 	movabs $0x8058c8,%rax
  805b6a:	00 00 00 
  805b6d:	ff d0                	callq  *%rax
  805b6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b76:	79 05                	jns    805b7d <listen+0x2d>
		return r;
  805b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b7b:	eb 16                	jmp    805b93 <listen+0x43>
	return nsipc_listen(r, backlog);
  805b7d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b83:	89 d6                	mov    %edx,%esi
  805b85:	89 c7                	mov    %eax,%edi
  805b87:	48 b8 bd 5e 80 00 00 	movabs $0x805ebd,%rax
  805b8e:	00 00 00 
  805b91:	ff d0                	callq  *%rax
}
  805b93:	c9                   	leaveq 
  805b94:	c3                   	retq   

0000000000805b95 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  805b95:	55                   	push   %rbp
  805b96:	48 89 e5             	mov    %rsp,%rbp
  805b99:	48 83 ec 20          	sub    $0x20,%rsp
  805b9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805ba1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805ba5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  805ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805bad:	89 c2                	mov    %eax,%edx
  805baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805bb3:	8b 40 0c             	mov    0xc(%rax),%eax
  805bb6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  805bba:	b9 00 00 00 00       	mov    $0x0,%ecx
  805bbf:	89 c7                	mov    %eax,%edi
  805bc1:	48 b8 fd 5e 80 00 00 	movabs $0x805efd,%rax
  805bc8:	00 00 00 
  805bcb:	ff d0                	callq  *%rax
}
  805bcd:	c9                   	leaveq 
  805bce:	c3                   	retq   

0000000000805bcf <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  805bcf:	55                   	push   %rbp
  805bd0:	48 89 e5             	mov    %rsp,%rbp
  805bd3:	48 83 ec 20          	sub    $0x20,%rsp
  805bd7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805bdb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805bdf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  805be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805be7:	89 c2                	mov    %eax,%edx
  805be9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805bed:	8b 40 0c             	mov    0xc(%rax),%eax
  805bf0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  805bf4:	b9 00 00 00 00       	mov    $0x0,%ecx
  805bf9:	89 c7                	mov    %eax,%edi
  805bfb:	48 b8 c9 5f 80 00 00 	movabs $0x805fc9,%rax
  805c02:	00 00 00 
  805c05:	ff d0                	callq  *%rax
}
  805c07:	c9                   	leaveq 
  805c08:	c3                   	retq   

0000000000805c09 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  805c09:	55                   	push   %rbp
  805c0a:	48 89 e5             	mov    %rsp,%rbp
  805c0d:	48 83 ec 10          	sub    $0x10,%rsp
  805c11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805c15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  805c19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c1d:	48 be bb 75 80 00 00 	movabs $0x8075bb,%rsi
  805c24:	00 00 00 
  805c27:	48 89 c7             	mov    %rax,%rdi
  805c2a:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  805c31:	00 00 00 
  805c34:	ff d0                	callq  *%rax
	return 0;
  805c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805c3b:	c9                   	leaveq 
  805c3c:	c3                   	retq   

0000000000805c3d <socket>:

int
socket(int domain, int type, int protocol)
{
  805c3d:	55                   	push   %rbp
  805c3e:	48 89 e5             	mov    %rsp,%rbp
  805c41:	48 83 ec 20          	sub    $0x20,%rsp
  805c45:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805c48:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805c4b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  805c4e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805c51:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805c54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805c57:	89 ce                	mov    %ecx,%esi
  805c59:	89 c7                	mov    %eax,%edi
  805c5b:	48 b8 81 60 80 00 00 	movabs $0x806081,%rax
  805c62:	00 00 00 
  805c65:	ff d0                	callq  *%rax
  805c67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c6e:	79 05                	jns    805c75 <socket+0x38>
		return r;
  805c70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c73:	eb 11                	jmp    805c86 <socket+0x49>
	return alloc_sockfd(r);
  805c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c78:	89 c7                	mov    %eax,%edi
  805c7a:	48 b8 1f 59 80 00 00 	movabs $0x80591f,%rax
  805c81:	00 00 00 
  805c84:	ff d0                	callq  *%rax
}
  805c86:	c9                   	leaveq 
  805c87:	c3                   	retq   

0000000000805c88 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  805c88:	55                   	push   %rbp
  805c89:	48 89 e5             	mov    %rsp,%rbp
  805c8c:	48 83 ec 10          	sub    $0x10,%rsp
  805c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  805c93:	48 b8 04 20 81 00 00 	movabs $0x812004,%rax
  805c9a:	00 00 00 
  805c9d:	8b 00                	mov    (%rax),%eax
  805c9f:	85 c0                	test   %eax,%eax
  805ca1:	75 1d                	jne    805cc0 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  805ca3:	bf 02 00 00 00       	mov    $0x2,%edi
  805ca8:	48 b8 86 4b 80 00 00 	movabs $0x804b86,%rax
  805caf:	00 00 00 
  805cb2:	ff d0                	callq  *%rax
  805cb4:	48 ba 04 20 81 00 00 	movabs $0x812004,%rdx
  805cbb:	00 00 00 
  805cbe:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  805cc0:	48 b8 04 20 81 00 00 	movabs $0x812004,%rax
  805cc7:	00 00 00 
  805cca:	8b 00                	mov    (%rax),%eax
  805ccc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805ccf:	b9 07 00 00 00       	mov    $0x7,%ecx
  805cd4:	48 ba 00 50 81 00 00 	movabs $0x815000,%rdx
  805cdb:	00 00 00 
  805cde:	89 c7                	mov    %eax,%edi
  805ce0:	48 b8 d7 4a 80 00 00 	movabs $0x804ad7,%rax
  805ce7:	00 00 00 
  805cea:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  805cec:	ba 00 00 00 00       	mov    $0x0,%edx
  805cf1:	be 00 00 00 00       	mov    $0x0,%esi
  805cf6:	bf 00 00 00 00       	mov    $0x0,%edi
  805cfb:	48 b8 f0 49 80 00 00 	movabs $0x8049f0,%rax
  805d02:	00 00 00 
  805d05:	ff d0                	callq  *%rax
}
  805d07:	c9                   	leaveq 
  805d08:	c3                   	retq   

0000000000805d09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  805d09:	55                   	push   %rbp
  805d0a:	48 89 e5             	mov    %rsp,%rbp
  805d0d:	48 83 ec 30          	sub    $0x30,%rsp
  805d11:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805d14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805d18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  805d1c:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805d23:	00 00 00 
  805d26:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805d29:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  805d2b:	bf 01 00 00 00       	mov    $0x1,%edi
  805d30:	48 b8 88 5c 80 00 00 	movabs $0x805c88,%rax
  805d37:	00 00 00 
  805d3a:	ff d0                	callq  *%rax
  805d3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d43:	78 3e                	js     805d83 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  805d45:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805d4c:	00 00 00 
  805d4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  805d53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d57:	8b 40 10             	mov    0x10(%rax),%eax
  805d5a:	89 c2                	mov    %eax,%edx
  805d5c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  805d60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d64:	48 89 ce             	mov    %rcx,%rsi
  805d67:	48 89 c7             	mov    %rax,%rdi
  805d6a:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  805d71:	00 00 00 
  805d74:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  805d76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d7a:	8b 50 10             	mov    0x10(%rax),%edx
  805d7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805d81:	89 10                	mov    %edx,(%rax)
	}
	return r;
  805d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805d86:	c9                   	leaveq 
  805d87:	c3                   	retq   

0000000000805d88 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805d88:	55                   	push   %rbp
  805d89:	48 89 e5             	mov    %rsp,%rbp
  805d8c:	48 83 ec 10          	sub    $0x10,%rsp
  805d90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805d93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805d97:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  805d9a:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805da1:	00 00 00 
  805da4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805da7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  805da9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805dac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805db0:	48 89 c6             	mov    %rax,%rsi
  805db3:	48 bf 04 50 81 00 00 	movabs $0x815004,%rdi
  805dba:	00 00 00 
  805dbd:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  805dc4:	00 00 00 
  805dc7:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  805dc9:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805dd0:	00 00 00 
  805dd3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805dd6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  805dd9:	bf 02 00 00 00       	mov    $0x2,%edi
  805dde:	48 b8 88 5c 80 00 00 	movabs $0x805c88,%rax
  805de5:	00 00 00 
  805de8:	ff d0                	callq  *%rax
}
  805dea:	c9                   	leaveq 
  805deb:	c3                   	retq   

0000000000805dec <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  805dec:	55                   	push   %rbp
  805ded:	48 89 e5             	mov    %rsp,%rbp
  805df0:	48 83 ec 10          	sub    $0x10,%rsp
  805df4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805df7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  805dfa:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805e01:	00 00 00 
  805e04:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805e07:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  805e09:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805e10:	00 00 00 
  805e13:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805e16:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  805e19:	bf 03 00 00 00       	mov    $0x3,%edi
  805e1e:	48 b8 88 5c 80 00 00 	movabs $0x805c88,%rax
  805e25:	00 00 00 
  805e28:	ff d0                	callq  *%rax
}
  805e2a:	c9                   	leaveq 
  805e2b:	c3                   	retq   

0000000000805e2c <nsipc_close>:

int
nsipc_close(int s)
{
  805e2c:	55                   	push   %rbp
  805e2d:	48 89 e5             	mov    %rsp,%rbp
  805e30:	48 83 ec 10          	sub    $0x10,%rsp
  805e34:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  805e37:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805e3e:	00 00 00 
  805e41:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805e44:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  805e46:	bf 04 00 00 00       	mov    $0x4,%edi
  805e4b:	48 b8 88 5c 80 00 00 	movabs $0x805c88,%rax
  805e52:	00 00 00 
  805e55:	ff d0                	callq  *%rax
}
  805e57:	c9                   	leaveq 
  805e58:	c3                   	retq   

0000000000805e59 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805e59:	55                   	push   %rbp
  805e5a:	48 89 e5             	mov    %rsp,%rbp
  805e5d:	48 83 ec 10          	sub    $0x10,%rsp
  805e61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805e64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805e68:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  805e6b:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805e72:	00 00 00 
  805e75:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805e78:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  805e7a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805e81:	48 89 c6             	mov    %rax,%rsi
  805e84:	48 bf 04 50 81 00 00 	movabs $0x815004,%rdi
  805e8b:	00 00 00 
  805e8e:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  805e95:	00 00 00 
  805e98:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  805e9a:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805ea1:	00 00 00 
  805ea4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805ea7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  805eaa:	bf 05 00 00 00       	mov    $0x5,%edi
  805eaf:	48 b8 88 5c 80 00 00 	movabs $0x805c88,%rax
  805eb6:	00 00 00 
  805eb9:	ff d0                	callq  *%rax
}
  805ebb:	c9                   	leaveq 
  805ebc:	c3                   	retq   

0000000000805ebd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  805ebd:	55                   	push   %rbp
  805ebe:	48 89 e5             	mov    %rsp,%rbp
  805ec1:	48 83 ec 10          	sub    $0x10,%rsp
  805ec5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805ec8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  805ecb:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805ed2:	00 00 00 
  805ed5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805ed8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  805eda:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805ee1:	00 00 00 
  805ee4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805ee7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  805eea:	bf 06 00 00 00       	mov    $0x6,%edi
  805eef:	48 b8 88 5c 80 00 00 	movabs $0x805c88,%rax
  805ef6:	00 00 00 
  805ef9:	ff d0                	callq  *%rax
}
  805efb:	c9                   	leaveq 
  805efc:	c3                   	retq   

0000000000805efd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  805efd:	55                   	push   %rbp
  805efe:	48 89 e5             	mov    %rsp,%rbp
  805f01:	48 83 ec 30          	sub    $0x30,%rsp
  805f05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805f08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805f0c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  805f0f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  805f12:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805f19:	00 00 00 
  805f1c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805f1f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  805f21:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805f28:	00 00 00 
  805f2b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805f2e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  805f31:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805f38:	00 00 00 
  805f3b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805f3e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  805f41:	bf 07 00 00 00       	mov    $0x7,%edi
  805f46:	48 b8 88 5c 80 00 00 	movabs $0x805c88,%rax
  805f4d:	00 00 00 
  805f50:	ff d0                	callq  *%rax
  805f52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f59:	78 69                	js     805fc4 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  805f5b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  805f62:	7f 08                	jg     805f6c <nsipc_recv+0x6f>
  805f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f67:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  805f6a:	7e 35                	jle    805fa1 <nsipc_recv+0xa4>
  805f6c:	48 b9 c2 75 80 00 00 	movabs $0x8075c2,%rcx
  805f73:	00 00 00 
  805f76:	48 ba d7 75 80 00 00 	movabs $0x8075d7,%rdx
  805f7d:	00 00 00 
  805f80:	be 61 00 00 00       	mov    $0x61,%esi
  805f85:	48 bf ec 75 80 00 00 	movabs $0x8075ec,%rdi
  805f8c:	00 00 00 
  805f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  805f94:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  805f9b:	00 00 00 
  805f9e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  805fa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805fa4:	48 63 d0             	movslq %eax,%rdx
  805fa7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805fab:	48 be 00 50 81 00 00 	movabs $0x815000,%rsi
  805fb2:	00 00 00 
  805fb5:	48 89 c7             	mov    %rax,%rdi
  805fb8:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  805fbf:	00 00 00 
  805fc2:	ff d0                	callq  *%rax
	}

	return r;
  805fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805fc7:	c9                   	leaveq 
  805fc8:	c3                   	retq   

0000000000805fc9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  805fc9:	55                   	push   %rbp
  805fca:	48 89 e5             	mov    %rsp,%rbp
  805fcd:	48 83 ec 20          	sub    $0x20,%rsp
  805fd1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805fd4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805fd8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  805fdb:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  805fde:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805fe5:	00 00 00 
  805fe8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805feb:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  805fed:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  805ff4:	7e 35                	jle    80602b <nsipc_send+0x62>
  805ff6:	48 b9 f8 75 80 00 00 	movabs $0x8075f8,%rcx
  805ffd:	00 00 00 
  806000:	48 ba d7 75 80 00 00 	movabs $0x8075d7,%rdx
  806007:	00 00 00 
  80600a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80600f:	48 bf ec 75 80 00 00 	movabs $0x8075ec,%rdi
  806016:	00 00 00 
  806019:	b8 00 00 00 00       	mov    $0x0,%eax
  80601e:	49 b8 40 2e 80 00 00 	movabs $0x802e40,%r8
  806025:	00 00 00 
  806028:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80602b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80602e:	48 63 d0             	movslq %eax,%rdx
  806031:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806035:	48 89 c6             	mov    %rax,%rsi
  806038:	48 bf 0c 50 81 00 00 	movabs $0x81500c,%rdi
  80603f:	00 00 00 
  806042:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  806049:	00 00 00 
  80604c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80604e:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806055:	00 00 00 
  806058:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80605b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80605e:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806065:	00 00 00 
  806068:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80606b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80606e:	bf 08 00 00 00       	mov    $0x8,%edi
  806073:	48 b8 88 5c 80 00 00 	movabs $0x805c88,%rax
  80607a:	00 00 00 
  80607d:	ff d0                	callq  *%rax
}
  80607f:	c9                   	leaveq 
  806080:	c3                   	retq   

0000000000806081 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  806081:	55                   	push   %rbp
  806082:	48 89 e5             	mov    %rsp,%rbp
  806085:	48 83 ec 10          	sub    $0x10,%rsp
  806089:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80608c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80608f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  806092:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806099:	00 00 00 
  80609c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80609f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8060a1:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8060a8:	00 00 00 
  8060ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8060ae:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8060b1:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  8060b8:	00 00 00 
  8060bb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8060be:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8060c1:	bf 09 00 00 00       	mov    $0x9,%edi
  8060c6:	48 b8 88 5c 80 00 00 	movabs $0x805c88,%rax
  8060cd:	00 00 00 
  8060d0:	ff d0                	callq  *%rax
}
  8060d2:	c9                   	leaveq 
  8060d3:	c3                   	retq   

00000000008060d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8060d4:	55                   	push   %rbp
  8060d5:	48 89 e5             	mov    %rsp,%rbp
  8060d8:	53                   	push   %rbx
  8060d9:	48 83 ec 38          	sub    $0x38,%rsp
  8060dd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8060e1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8060e5:	48 89 c7             	mov    %rax,%rdi
  8060e8:	48 b8 62 4c 80 00 00 	movabs $0x804c62,%rax
  8060ef:	00 00 00 
  8060f2:	ff d0                	callq  *%rax
  8060f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8060f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8060fb:	0f 88 bf 01 00 00    	js     8062c0 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806101:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806105:	ba 07 04 00 00       	mov    $0x407,%edx
  80610a:	48 89 c6             	mov    %rax,%rsi
  80610d:	bf 00 00 00 00       	mov    $0x0,%edi
  806112:	48 b8 84 45 80 00 00 	movabs $0x804584,%rax
  806119:	00 00 00 
  80611c:	ff d0                	callq  *%rax
  80611e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806121:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806125:	0f 88 95 01 00 00    	js     8062c0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80612b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80612f:	48 89 c7             	mov    %rax,%rdi
  806132:	48 b8 62 4c 80 00 00 	movabs $0x804c62,%rax
  806139:	00 00 00 
  80613c:	ff d0                	callq  *%rax
  80613e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806141:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806145:	0f 88 5d 01 00 00    	js     8062a8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80614b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80614f:	ba 07 04 00 00       	mov    $0x407,%edx
  806154:	48 89 c6             	mov    %rax,%rsi
  806157:	bf 00 00 00 00       	mov    $0x0,%edi
  80615c:	48 b8 84 45 80 00 00 	movabs $0x804584,%rax
  806163:	00 00 00 
  806166:	ff d0                	callq  *%rax
  806168:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80616b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80616f:	0f 88 33 01 00 00    	js     8062a8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  806175:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806179:	48 89 c7             	mov    %rax,%rdi
  80617c:	48 b8 37 4c 80 00 00 	movabs $0x804c37,%rax
  806183:	00 00 00 
  806186:	ff d0                	callq  *%rax
  806188:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80618c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806190:	ba 07 04 00 00       	mov    $0x407,%edx
  806195:	48 89 c6             	mov    %rax,%rsi
  806198:	bf 00 00 00 00       	mov    $0x0,%edi
  80619d:	48 b8 84 45 80 00 00 	movabs $0x804584,%rax
  8061a4:	00 00 00 
  8061a7:	ff d0                	callq  *%rax
  8061a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8061ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8061b0:	0f 88 d9 00 00 00    	js     80628f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8061b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8061ba:	48 89 c7             	mov    %rax,%rdi
  8061bd:	48 b8 37 4c 80 00 00 	movabs $0x804c37,%rax
  8061c4:	00 00 00 
  8061c7:	ff d0                	callq  *%rax
  8061c9:	48 89 c2             	mov    %rax,%rdx
  8061cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8061d0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8061d6:	48 89 d1             	mov    %rdx,%rcx
  8061d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8061de:	48 89 c6             	mov    %rax,%rsi
  8061e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8061e6:	48 b8 d4 45 80 00 00 	movabs $0x8045d4,%rax
  8061ed:	00 00 00 
  8061f0:	ff d0                	callq  *%rax
  8061f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8061f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8061f9:	78 79                	js     806274 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8061fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8061ff:	48 ba 60 11 81 00 00 	movabs $0x811160,%rdx
  806206:	00 00 00 
  806209:	8b 12                	mov    (%rdx),%edx
  80620b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80620d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806211:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  806218:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80621c:	48 ba 60 11 81 00 00 	movabs $0x811160,%rdx
  806223:	00 00 00 
  806226:	8b 12                	mov    (%rdx),%edx
  806228:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80622a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80622e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  806235:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806239:	48 89 c7             	mov    %rax,%rdi
  80623c:	48 b8 14 4c 80 00 00 	movabs $0x804c14,%rax
  806243:	00 00 00 
  806246:	ff d0                	callq  *%rax
  806248:	89 c2                	mov    %eax,%edx
  80624a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80624e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  806250:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806254:	48 8d 58 04          	lea    0x4(%rax),%rbx
  806258:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80625c:	48 89 c7             	mov    %rax,%rdi
  80625f:	48 b8 14 4c 80 00 00 	movabs $0x804c14,%rax
  806266:	00 00 00 
  806269:	ff d0                	callq  *%rax
  80626b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80626d:	b8 00 00 00 00       	mov    $0x0,%eax
  806272:	eb 4f                	jmp    8062c3 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  806274:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  806275:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806279:	48 89 c6             	mov    %rax,%rsi
  80627c:	bf 00 00 00 00       	mov    $0x0,%edi
  806281:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  806288:	00 00 00 
  80628b:	ff d0                	callq  *%rax
  80628d:	eb 01                	jmp    806290 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80628f:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  806290:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806294:	48 89 c6             	mov    %rax,%rsi
  806297:	bf 00 00 00 00       	mov    $0x0,%edi
  80629c:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  8062a3:	00 00 00 
  8062a6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8062a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8062ac:	48 89 c6             	mov    %rax,%rsi
  8062af:	bf 00 00 00 00       	mov    $0x0,%edi
  8062b4:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  8062bb:	00 00 00 
  8062be:	ff d0                	callq  *%rax
err:
	return r;
  8062c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8062c3:	48 83 c4 38          	add    $0x38,%rsp
  8062c7:	5b                   	pop    %rbx
  8062c8:	5d                   	pop    %rbp
  8062c9:	c3                   	retq   

00000000008062ca <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8062ca:	55                   	push   %rbp
  8062cb:	48 89 e5             	mov    %rsp,%rbp
  8062ce:	53                   	push   %rbx
  8062cf:	48 83 ec 28          	sub    $0x28,%rsp
  8062d3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8062d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8062db:	eb 01                	jmp    8062de <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8062dd:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8062de:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8062e5:	00 00 00 
  8062e8:	48 8b 00             	mov    (%rax),%rax
  8062eb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8062f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8062f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8062f8:	48 89 c7             	mov    %rax,%rdi
  8062fb:	48 b8 3c 58 80 00 00 	movabs $0x80583c,%rax
  806302:	00 00 00 
  806305:	ff d0                	callq  *%rax
  806307:	89 c3                	mov    %eax,%ebx
  806309:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80630d:	48 89 c7             	mov    %rax,%rdi
  806310:	48 b8 3c 58 80 00 00 	movabs $0x80583c,%rax
  806317:	00 00 00 
  80631a:	ff d0                	callq  *%rax
  80631c:	39 c3                	cmp    %eax,%ebx
  80631e:	0f 94 c0             	sete   %al
  806321:	0f b6 c0             	movzbl %al,%eax
  806324:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806327:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  80632e:	00 00 00 
  806331:	48 8b 00             	mov    (%rax),%rax
  806334:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80633a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80633d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806340:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806343:	75 0a                	jne    80634f <_pipeisclosed+0x85>
			return ret;
  806345:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  806348:	48 83 c4 28          	add    $0x28,%rsp
  80634c:	5b                   	pop    %rbx
  80634d:	5d                   	pop    %rbp
  80634e:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80634f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806352:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806355:	74 86                	je     8062dd <_pipeisclosed+0x13>
  806357:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80635b:	75 80                	jne    8062dd <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80635d:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  806364:	00 00 00 
  806367:	48 8b 00             	mov    (%rax),%rax
  80636a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  806370:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806373:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806376:	89 c6                	mov    %eax,%esi
  806378:	48 bf 09 76 80 00 00 	movabs $0x807609,%rdi
  80637f:	00 00 00 
  806382:	b8 00 00 00 00       	mov    $0x0,%eax
  806387:	49 b8 7b 30 80 00 00 	movabs $0x80307b,%r8
  80638e:	00 00 00 
  806391:	41 ff d0             	callq  *%r8
	}
  806394:	e9 44 ff ff ff       	jmpq   8062dd <_pipeisclosed+0x13>

0000000000806399 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  806399:	55                   	push   %rbp
  80639a:	48 89 e5             	mov    %rsp,%rbp
  80639d:	48 83 ec 30          	sub    $0x30,%rsp
  8063a1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8063a4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8063a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8063ab:	48 89 d6             	mov    %rdx,%rsi
  8063ae:	89 c7                	mov    %eax,%edi
  8063b0:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  8063b7:	00 00 00 
  8063ba:	ff d0                	callq  *%rax
  8063bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8063bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8063c3:	79 05                	jns    8063ca <pipeisclosed+0x31>
		return r;
  8063c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063c8:	eb 31                	jmp    8063fb <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8063ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063ce:	48 89 c7             	mov    %rax,%rdi
  8063d1:	48 b8 37 4c 80 00 00 	movabs $0x804c37,%rax
  8063d8:	00 00 00 
  8063db:	ff d0                	callq  *%rax
  8063dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8063e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8063e9:	48 89 d6             	mov    %rdx,%rsi
  8063ec:	48 89 c7             	mov    %rax,%rdi
  8063ef:	48 b8 ca 62 80 00 00 	movabs $0x8062ca,%rax
  8063f6:	00 00 00 
  8063f9:	ff d0                	callq  *%rax
}
  8063fb:	c9                   	leaveq 
  8063fc:	c3                   	retq   

00000000008063fd <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8063fd:	55                   	push   %rbp
  8063fe:	48 89 e5             	mov    %rsp,%rbp
  806401:	48 83 ec 40          	sub    $0x40,%rsp
  806405:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806409:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80640d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  806411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806415:	48 89 c7             	mov    %rax,%rdi
  806418:	48 b8 37 4c 80 00 00 	movabs $0x804c37,%rax
  80641f:	00 00 00 
  806422:	ff d0                	callq  *%rax
  806424:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806428:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80642c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806430:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806437:	00 
  806438:	e9 97 00 00 00       	jmpq   8064d4 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80643d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  806442:	74 09                	je     80644d <devpipe_read+0x50>
				return i;
  806444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806448:	e9 95 00 00 00       	jmpq   8064e2 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80644d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806455:	48 89 d6             	mov    %rdx,%rsi
  806458:	48 89 c7             	mov    %rax,%rdi
  80645b:	48 b8 ca 62 80 00 00 	movabs $0x8062ca,%rax
  806462:	00 00 00 
  806465:	ff d0                	callq  *%rax
  806467:	85 c0                	test   %eax,%eax
  806469:	74 07                	je     806472 <devpipe_read+0x75>
				return 0;
  80646b:	b8 00 00 00 00       	mov    $0x0,%eax
  806470:	eb 70                	jmp    8064e2 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  806472:	48 b8 46 45 80 00 00 	movabs $0x804546,%rax
  806479:	00 00 00 
  80647c:	ff d0                	callq  *%rax
  80647e:	eb 01                	jmp    806481 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  806480:	90                   	nop
  806481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806485:	8b 10                	mov    (%rax),%edx
  806487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80648b:	8b 40 04             	mov    0x4(%rax),%eax
  80648e:	39 c2                	cmp    %eax,%edx
  806490:	74 ab                	je     80643d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806496:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80649a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80649e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8064a2:	8b 00                	mov    (%rax),%eax
  8064a4:	89 c2                	mov    %eax,%edx
  8064a6:	c1 fa 1f             	sar    $0x1f,%edx
  8064a9:	c1 ea 1b             	shr    $0x1b,%edx
  8064ac:	01 d0                	add    %edx,%eax
  8064ae:	83 e0 1f             	and    $0x1f,%eax
  8064b1:	29 d0                	sub    %edx,%eax
  8064b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8064b7:	48 98                	cltq   
  8064b9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8064be:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8064c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8064c4:	8b 00                	mov    (%rax),%eax
  8064c6:	8d 50 01             	lea    0x1(%rax),%edx
  8064c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8064cd:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8064cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8064d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8064d8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8064dc:	72 a2                	jb     806480 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8064de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8064e2:	c9                   	leaveq 
  8064e3:	c3                   	retq   

00000000008064e4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8064e4:	55                   	push   %rbp
  8064e5:	48 89 e5             	mov    %rsp,%rbp
  8064e8:	48 83 ec 40          	sub    $0x40,%rsp
  8064ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8064f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8064f4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8064f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8064fc:	48 89 c7             	mov    %rax,%rdi
  8064ff:	48 b8 37 4c 80 00 00 	movabs $0x804c37,%rax
  806506:	00 00 00 
  806509:	ff d0                	callq  *%rax
  80650b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80650f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806513:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806517:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80651e:	00 
  80651f:	e9 93 00 00 00       	jmpq   8065b7 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806524:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806528:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80652c:	48 89 d6             	mov    %rdx,%rsi
  80652f:	48 89 c7             	mov    %rax,%rdi
  806532:	48 b8 ca 62 80 00 00 	movabs $0x8062ca,%rax
  806539:	00 00 00 
  80653c:	ff d0                	callq  *%rax
  80653e:	85 c0                	test   %eax,%eax
  806540:	74 07                	je     806549 <devpipe_write+0x65>
				return 0;
  806542:	b8 00 00 00 00       	mov    $0x0,%eax
  806547:	eb 7c                	jmp    8065c5 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806549:	48 b8 46 45 80 00 00 	movabs $0x804546,%rax
  806550:	00 00 00 
  806553:	ff d0                	callq  *%rax
  806555:	eb 01                	jmp    806558 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806557:	90                   	nop
  806558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80655c:	8b 40 04             	mov    0x4(%rax),%eax
  80655f:	48 63 d0             	movslq %eax,%rdx
  806562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806566:	8b 00                	mov    (%rax),%eax
  806568:	48 98                	cltq   
  80656a:	48 83 c0 20          	add    $0x20,%rax
  80656e:	48 39 c2             	cmp    %rax,%rdx
  806571:	73 b1                	jae    806524 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  806573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806577:	8b 40 04             	mov    0x4(%rax),%eax
  80657a:	89 c2                	mov    %eax,%edx
  80657c:	c1 fa 1f             	sar    $0x1f,%edx
  80657f:	c1 ea 1b             	shr    $0x1b,%edx
  806582:	01 d0                	add    %edx,%eax
  806584:	83 e0 1f             	and    $0x1f,%eax
  806587:	29 d0                	sub    %edx,%eax
  806589:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80658d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  806591:	48 01 ca             	add    %rcx,%rdx
  806594:	0f b6 0a             	movzbl (%rdx),%ecx
  806597:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80659b:	48 98                	cltq   
  80659d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8065a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8065a5:	8b 40 04             	mov    0x4(%rax),%eax
  8065a8:	8d 50 01             	lea    0x1(%rax),%edx
  8065ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8065af:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8065b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8065b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8065bb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8065bf:	72 96                	jb     806557 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8065c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8065c5:	c9                   	leaveq 
  8065c6:	c3                   	retq   

00000000008065c7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8065c7:	55                   	push   %rbp
  8065c8:	48 89 e5             	mov    %rsp,%rbp
  8065cb:	48 83 ec 20          	sub    $0x20,%rsp
  8065cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8065d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8065d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8065db:	48 89 c7             	mov    %rax,%rdi
  8065de:	48 b8 37 4c 80 00 00 	movabs $0x804c37,%rax
  8065e5:	00 00 00 
  8065e8:	ff d0                	callq  *%rax
  8065ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8065ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8065f2:	48 be 1c 76 80 00 00 	movabs $0x80761c,%rsi
  8065f9:	00 00 00 
  8065fc:	48 89 c7             	mov    %rax,%rdi
  8065ff:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  806606:	00 00 00 
  806609:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80660b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80660f:	8b 50 04             	mov    0x4(%rax),%edx
  806612:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806616:	8b 00                	mov    (%rax),%eax
  806618:	29 c2                	sub    %eax,%edx
  80661a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80661e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  806624:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806628:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80662f:	00 00 00 
	stat->st_dev = &devpipe;
  806632:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806636:	48 ba 60 11 81 00 00 	movabs $0x811160,%rdx
  80663d:	00 00 00 
  806640:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  806647:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80664c:	c9                   	leaveq 
  80664d:	c3                   	retq   

000000000080664e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80664e:	55                   	push   %rbp
  80664f:	48 89 e5             	mov    %rsp,%rbp
  806652:	48 83 ec 10          	sub    $0x10,%rsp
  806656:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80665a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80665e:	48 89 c6             	mov    %rax,%rsi
  806661:	bf 00 00 00 00       	mov    $0x0,%edi
  806666:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  80666d:	00 00 00 
  806670:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  806672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806676:	48 89 c7             	mov    %rax,%rdi
  806679:	48 b8 37 4c 80 00 00 	movabs $0x804c37,%rax
  806680:	00 00 00 
  806683:	ff d0                	callq  *%rax
  806685:	48 89 c6             	mov    %rax,%rsi
  806688:	bf 00 00 00 00       	mov    $0x0,%edi
  80668d:	48 b8 2f 46 80 00 00 	movabs $0x80462f,%rax
  806694:	00 00 00 
  806697:	ff d0                	callq  *%rax
}
  806699:	c9                   	leaveq 
  80669a:	c3                   	retq   
	...

000000000080669c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80669c:	55                   	push   %rbp
  80669d:	48 89 e5             	mov    %rsp,%rbp
  8066a0:	48 83 ec 20          	sub    $0x20,%rsp
  8066a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8066a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8066aa:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8066ad:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8066b1:	be 01 00 00 00       	mov    $0x1,%esi
  8066b6:	48 89 c7             	mov    %rax,%rdi
  8066b9:	48 b8 3c 44 80 00 00 	movabs $0x80443c,%rax
  8066c0:	00 00 00 
  8066c3:	ff d0                	callq  *%rax
}
  8066c5:	c9                   	leaveq 
  8066c6:	c3                   	retq   

00000000008066c7 <getchar>:

int
getchar(void)
{
  8066c7:	55                   	push   %rbp
  8066c8:	48 89 e5             	mov    %rsp,%rbp
  8066cb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8066cf:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8066d3:	ba 01 00 00 00       	mov    $0x1,%edx
  8066d8:	48 89 c6             	mov    %rax,%rsi
  8066db:	bf 00 00 00 00       	mov    $0x0,%edi
  8066e0:	48 b8 2c 51 80 00 00 	movabs $0x80512c,%rax
  8066e7:	00 00 00 
  8066ea:	ff d0                	callq  *%rax
  8066ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8066ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066f3:	79 05                	jns    8066fa <getchar+0x33>
		return r;
  8066f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066f8:	eb 14                	jmp    80670e <getchar+0x47>
	if (r < 1)
  8066fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066fe:	7f 07                	jg     806707 <getchar+0x40>
		return -E_EOF;
  806700:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  806705:	eb 07                	jmp    80670e <getchar+0x47>
	return c;
  806707:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80670b:	0f b6 c0             	movzbl %al,%eax
}
  80670e:	c9                   	leaveq 
  80670f:	c3                   	retq   

0000000000806710 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  806710:	55                   	push   %rbp
  806711:	48 89 e5             	mov    %rsp,%rbp
  806714:	48 83 ec 20          	sub    $0x20,%rsp
  806718:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80671b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80671f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806722:	48 89 d6             	mov    %rdx,%rsi
  806725:	89 c7                	mov    %eax,%edi
  806727:	48 b8 fa 4c 80 00 00 	movabs $0x804cfa,%rax
  80672e:	00 00 00 
  806731:	ff d0                	callq  *%rax
  806733:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806736:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80673a:	79 05                	jns    806741 <iscons+0x31>
		return r;
  80673c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80673f:	eb 1a                	jmp    80675b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  806741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806745:	8b 10                	mov    (%rax),%edx
  806747:	48 b8 a0 11 81 00 00 	movabs $0x8111a0,%rax
  80674e:	00 00 00 
  806751:	8b 00                	mov    (%rax),%eax
  806753:	39 c2                	cmp    %eax,%edx
  806755:	0f 94 c0             	sete   %al
  806758:	0f b6 c0             	movzbl %al,%eax
}
  80675b:	c9                   	leaveq 
  80675c:	c3                   	retq   

000000000080675d <opencons>:

int
opencons(void)
{
  80675d:	55                   	push   %rbp
  80675e:	48 89 e5             	mov    %rsp,%rbp
  806761:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  806765:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  806769:	48 89 c7             	mov    %rax,%rdi
  80676c:	48 b8 62 4c 80 00 00 	movabs $0x804c62,%rax
  806773:	00 00 00 
  806776:	ff d0                	callq  *%rax
  806778:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80677b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80677f:	79 05                	jns    806786 <opencons+0x29>
		return r;
  806781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806784:	eb 5b                	jmp    8067e1 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  806786:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80678a:	ba 07 04 00 00       	mov    $0x407,%edx
  80678f:	48 89 c6             	mov    %rax,%rsi
  806792:	bf 00 00 00 00       	mov    $0x0,%edi
  806797:	48 b8 84 45 80 00 00 	movabs $0x804584,%rax
  80679e:	00 00 00 
  8067a1:	ff d0                	callq  *%rax
  8067a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8067a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8067aa:	79 05                	jns    8067b1 <opencons+0x54>
		return r;
  8067ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8067af:	eb 30                	jmp    8067e1 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8067b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8067b5:	48 ba a0 11 81 00 00 	movabs $0x8111a0,%rdx
  8067bc:	00 00 00 
  8067bf:	8b 12                	mov    (%rdx),%edx
  8067c1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8067c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8067c7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8067ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8067d2:	48 89 c7             	mov    %rax,%rdi
  8067d5:	48 b8 14 4c 80 00 00 	movabs $0x804c14,%rax
  8067dc:	00 00 00 
  8067df:	ff d0                	callq  *%rax
}
  8067e1:	c9                   	leaveq 
  8067e2:	c3                   	retq   

00000000008067e3 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8067e3:	55                   	push   %rbp
  8067e4:	48 89 e5             	mov    %rsp,%rbp
  8067e7:	48 83 ec 30          	sub    $0x30,%rsp
  8067eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8067ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8067f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8067f7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8067fc:	75 13                	jne    806811 <devcons_read+0x2e>
		return 0;
  8067fe:	b8 00 00 00 00       	mov    $0x0,%eax
  806803:	eb 49                	jmp    80684e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  806805:	48 b8 46 45 80 00 00 	movabs $0x804546,%rax
  80680c:	00 00 00 
  80680f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  806811:	48 b8 86 44 80 00 00 	movabs $0x804486,%rax
  806818:	00 00 00 
  80681b:	ff d0                	callq  *%rax
  80681d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806820:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806824:	74 df                	je     806805 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  806826:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80682a:	79 05                	jns    806831 <devcons_read+0x4e>
		return c;
  80682c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80682f:	eb 1d                	jmp    80684e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  806831:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  806835:	75 07                	jne    80683e <devcons_read+0x5b>
		return 0;
  806837:	b8 00 00 00 00       	mov    $0x0,%eax
  80683c:	eb 10                	jmp    80684e <devcons_read+0x6b>
	*(char*)vbuf = c;
  80683e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806841:	89 c2                	mov    %eax,%edx
  806843:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806847:	88 10                	mov    %dl,(%rax)
	return 1;
  806849:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80684e:	c9                   	leaveq 
  80684f:	c3                   	retq   

0000000000806850 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806850:	55                   	push   %rbp
  806851:	48 89 e5             	mov    %rsp,%rbp
  806854:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80685b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  806862:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  806869:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  806870:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806877:	eb 77                	jmp    8068f0 <devcons_write+0xa0>
		m = n - tot;
  806879:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  806880:	89 c2                	mov    %eax,%edx
  806882:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806885:	89 d1                	mov    %edx,%ecx
  806887:	29 c1                	sub    %eax,%ecx
  806889:	89 c8                	mov    %ecx,%eax
  80688b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80688e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806891:	83 f8 7f             	cmp    $0x7f,%eax
  806894:	76 07                	jbe    80689d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  806896:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80689d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8068a0:	48 63 d0             	movslq %eax,%rdx
  8068a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8068a6:	48 98                	cltq   
  8068a8:	48 89 c1             	mov    %rax,%rcx
  8068ab:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8068b2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8068b9:	48 89 ce             	mov    %rcx,%rsi
  8068bc:	48 89 c7             	mov    %rax,%rdi
  8068bf:	48 b8 6e 3f 80 00 00 	movabs $0x803f6e,%rax
  8068c6:	00 00 00 
  8068c9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8068cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8068ce:	48 63 d0             	movslq %eax,%rdx
  8068d1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8068d8:	48 89 d6             	mov    %rdx,%rsi
  8068db:	48 89 c7             	mov    %rax,%rdi
  8068de:	48 b8 3c 44 80 00 00 	movabs $0x80443c,%rax
  8068e5:	00 00 00 
  8068e8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8068ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8068ed:	01 45 fc             	add    %eax,-0x4(%rbp)
  8068f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8068f3:	48 98                	cltq   
  8068f5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8068fc:	0f 82 77 ff ff ff    	jb     806879 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  806902:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806905:	c9                   	leaveq 
  806906:	c3                   	retq   

0000000000806907 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  806907:	55                   	push   %rbp
  806908:	48 89 e5             	mov    %rsp,%rbp
  80690b:	48 83 ec 08          	sub    $0x8,%rsp
  80690f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  806913:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806918:	c9                   	leaveq 
  806919:	c3                   	retq   

000000000080691a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80691a:	55                   	push   %rbp
  80691b:	48 89 e5             	mov    %rsp,%rbp
  80691e:	48 83 ec 10          	sub    $0x10,%rsp
  806922:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806926:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80692a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80692e:	48 be 28 76 80 00 00 	movabs $0x807628,%rsi
  806935:	00 00 00 
  806938:	48 89 c7             	mov    %rax,%rdi
  80693b:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  806942:	00 00 00 
  806945:	ff d0                	callq  *%rax
	return 0;
  806947:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80694c:	c9                   	leaveq 
  80694d:	c3                   	retq   
