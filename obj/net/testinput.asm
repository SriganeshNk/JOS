
obj/net/testinput:     file format elf64-x86-64


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
  80003c:	e8 3b 08 00 00       	callq  80087c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <announce>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    static void
announce(void)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 30          	sub    $0x30,%rsp
    // with ARP requests.  Ideally, we would use gratuitous ARP
    // for this, but QEMU's ARP implementation is dumb and only
    // listens for very specific ARP requests, such as requests
    // for the gateway IP.

    uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80004c:	c6 45 e0 52          	movb   $0x52,-0x20(%rbp)
  800050:	c6 45 e1 54          	movb   $0x54,-0x1f(%rbp)
  800054:	c6 45 e2 00          	movb   $0x0,-0x1e(%rbp)
  800058:	c6 45 e3 12          	movb   $0x12,-0x1d(%rbp)
  80005c:	c6 45 e4 34          	movb   $0x34,-0x1c(%rbp)
  800060:	c6 45 e5 56          	movb   $0x56,-0x1b(%rbp)
    uint32_t myip = inet_addr(IP);
  800064:	48 bf 60 50 80 00 00 	movabs $0x805060,%rdi
  80006b:	00 00 00 
  80006e:	48 b8 bc 4b 80 00 00 	movabs $0x804bbc,%rax
  800075:	00 00 00 
  800078:	ff d0                	callq  *%rax
  80007a:	89 45 dc             	mov    %eax,-0x24(%rbp)
    uint32_t gwip = inet_addr(DEFAULT);
  80007d:	48 bf 6a 50 80 00 00 	movabs $0x80506a,%rdi
  800084:	00 00 00 
  800087:	48 b8 bc 4b 80 00 00 	movabs $0x804bbc,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 d8             	mov    %eax,-0x28(%rbp)
    int r;

    if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800096:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80009d:	00 00 00 
  8000a0:	48 8b 00             	mov    (%rax),%rax
  8000a3:	ba 07 00 00 00       	mov    $0x7,%edx
  8000a8:	48 89 c6             	mov    %rax,%rsi
  8000ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8000b0:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
  8000bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c3:	79 30                	jns    8000f5 <announce+0xb1>
        panic("sys_page_map: %e", r);
  8000c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c8:	89 c1                	mov    %eax,%ecx
  8000ca:	48 ba 73 50 80 00 00 	movabs $0x805073,%rdx
  8000d1:	00 00 00 
  8000d4:	be 19 00 00 00       	mov    $0x19,%esi
  8000d9:	48 bf 84 50 80 00 00 	movabs $0x805084,%rdi
  8000e0:	00 00 00 
  8000e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e8:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8000ef:	00 00 00 
  8000f2:	41 ff d0             	callq  *%r8

    struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  8000f5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000fc:	00 00 00 
  8000ff:	48 8b 00             	mov    (%rax),%rax
  800102:	48 83 c0 04          	add    $0x4,%rax
  800106:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    pkt->jp_len = sizeof(*arp);
  80010a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800111:	00 00 00 
  800114:	48 8b 00             	mov    (%rax),%rax
  800117:	c7 00 2a 00 00 00    	movl   $0x2a,(%rax)

    memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  80011d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800121:	ba 06 00 00 00       	mov    $0x6,%edx
  800126:	be ff 00 00 00       	mov    $0xff,%esi
  80012b:	48 89 c7             	mov    %rax,%rdi
  80012e:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
    memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80013a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013e:	48 8d 48 06          	lea    0x6(%rax),%rcx
  800142:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800146:	ba 06 00 00 00       	mov    $0x6,%edx
  80014b:	48 89 c6             	mov    %rax,%rsi
  80014e:	48 89 cf             	mov    %rcx,%rdi
  800151:	48 b8 8d 1b 80 00 00 	movabs $0x801b8d,%rax
  800158:	00 00 00 
  80015b:	ff d0                	callq  *%rax
    arp->ethhdr.type = htons(ETHTYPE_ARP);
  80015d:	bf 06 08 00 00       	mov    $0x806,%edi
  800162:	48 b8 c4 4f 80 00 00 	movabs $0x804fc4,%rax
  800169:	00 00 00 
  80016c:	ff d0                	callq  *%rax
  80016e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800172:	66 89 42 0c          	mov    %ax,0xc(%rdx)
    arp->hwtype = htons(1); // Ethernet
  800176:	bf 01 00 00 00       	mov    $0x1,%edi
  80017b:	48 b8 c4 4f 80 00 00 	movabs $0x804fc4,%rax
  800182:	00 00 00 
  800185:	ff d0                	callq  *%rax
  800187:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018b:	66 89 42 0e          	mov    %ax,0xe(%rdx)
    arp->proto = htons(ETHTYPE_IP);
  80018f:	bf 00 08 00 00       	mov    $0x800,%edi
  800194:	48 b8 c4 4f 80 00 00 	movabs $0x804fc4,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
  8001a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a4:	66 89 42 10          	mov    %ax,0x10(%rdx)
    arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001a8:	bf 04 06 00 00       	mov    $0x604,%edi
  8001ad:	48 b8 c4 4f 80 00 00 	movabs $0x804fc4,%rax
  8001b4:	00 00 00 
  8001b7:	ff d0                	callq  *%rax
  8001b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bd:	66 89 42 12          	mov    %ax,0x12(%rdx)
    arp->opcode = htons(ARP_REQUEST);
  8001c1:	bf 01 00 00 00       	mov    $0x1,%edi
  8001c6:	48 b8 c4 4f 80 00 00 	movabs $0x804fc4,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
  8001d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d6:	66 89 42 14          	mov    %ax,0x14(%rdx)
    memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001de:	48 8d 48 16          	lea    0x16(%rax),%rcx
  8001e2:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001e6:	ba 06 00 00 00       	mov    $0x6,%edx
  8001eb:	48 89 c6             	mov    %rax,%rsi
  8001ee:	48 89 cf             	mov    %rcx,%rdi
  8001f1:	48 b8 8d 1b 80 00 00 	movabs $0x801b8d,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
    memcpy(arp->sipaddr.addrw, &myip, 4);
  8001fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800201:	48 8d 48 1c          	lea    0x1c(%rax),%rcx
  800205:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
  800209:	ba 04 00 00 00       	mov    $0x4,%edx
  80020e:	48 89 c6             	mov    %rax,%rsi
  800211:	48 89 cf             	mov    %rcx,%rdi
  800214:	48 b8 8d 1b 80 00 00 	movabs $0x801b8d,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
    memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800224:	48 83 c0 20          	add    $0x20,%rax
  800228:	ba 06 00 00 00       	mov    $0x6,%edx
  80022d:	be 00 00 00 00       	mov    $0x0,%esi
  800232:	48 89 c7             	mov    %rax,%rdi
  800235:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
    memcpy(arp->dipaddr.addrw, &gwip, 4);
  800241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800245:	48 8d 48 26          	lea    0x26(%rax),%rcx
  800249:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80024d:	ba 04 00 00 00       	mov    $0x4,%edx
  800252:	48 89 c6             	mov    %rax,%rsi
  800255:	48 89 cf             	mov    %rcx,%rdi
  800258:	48 b8 8d 1b 80 00 00 	movabs $0x801b8d,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax

    ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800264:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80026b:	00 00 00 
  80026e:	48 8b 10             	mov    (%rax),%rdx
  800271:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800278:	00 00 00 
  80027b:	8b 00                	mov    (%rax),%eax
  80027d:	b9 07 00 00 00       	mov    $0x7,%ecx
  800282:	be 0b 00 00 00       	mov    $0xb,%esi
  800287:	89 c7                	mov    %eax,%edi
  800289:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  800290:	00 00 00 
  800293:	ff d0                	callq  *%rax
    sys_page_unmap(0, pkt);
  800295:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80029c:	00 00 00 
  80029f:	48 8b 00             	mov    (%rax),%rax
  8002a2:	48 89 c6             	mov    %rax,%rsi
  8002a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8002aa:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  8002b1:	00 00 00 
  8002b4:	ff d0                	callq  *%rax
}
  8002b6:	c9                   	leaveq 
  8002b7:	c3                   	retq   

00000000008002b8 <hexdump>:

    static void
hexdump(const char *prefix, const void *data, int len)
{
  8002b8:	55                   	push   %rbp
  8002b9:	48 89 e5             	mov    %rsp,%rbp
  8002bc:	53                   	push   %rbx
  8002bd:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8002c4:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  8002cb:	48 89 b5 70 ff ff ff 	mov    %rsi,-0x90(%rbp)
  8002d2:	89 95 6c ff ff ff    	mov    %edx,-0x94(%rbp)
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
  8002d8:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8002dc:	48 83 c0 50          	add    $0x50,%rax
  8002e0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    char *out = NULL;
  8002e4:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8002eb:	00 
    for (i = 0; i < len; i++) {
  8002ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8002f3:	e9 4f 01 00 00       	jmpq   800447 <hexdump+0x18f>
        if (i % 16 == 0)
  8002f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002fb:	83 e0 0f             	and    $0xf,%eax
  8002fe:	85 c0                	test   %eax,%eax
  800300:	75 53                	jne    800355 <hexdump+0x9d>
            out = buf + snprintf(buf, end - buf,
  800302:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800306:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  80030a:	48 89 d1             	mov    %rdx,%rcx
  80030d:	48 29 c1             	sub    %rax,%rcx
  800310:	48 89 c8             	mov    %rcx,%rax
  800313:	89 c6                	mov    %eax,%esi
  800315:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  800318:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  80031f:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800323:	41 89 c8             	mov    %ecx,%r8d
  800326:	48 89 d1             	mov    %rdx,%rcx
  800329:	48 ba 94 50 80 00 00 	movabs $0x805094,%rdx
  800330:	00 00 00 
  800333:	48 89 c7             	mov    %rax,%rdi
  800336:	b8 00 00 00 00       	mov    $0x0,%eax
  80033b:	49 b9 05 16 80 00 00 	movabs $0x801605,%r9
  800342:	00 00 00 
  800345:	41 ff d1             	callq  *%r9
  800348:	48 98                	cltq   
  80034a:	48 8d 55 80          	lea    -0x80(%rbp),%rdx
  80034e:	48 01 d0             	add    %rdx,%rax
  800351:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
                    "%s%04x   ", prefix, i);
        out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800355:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800358:	48 98                	cltq   
  80035a:	48 03 85 70 ff ff ff 	add    -0x90(%rbp),%rax
  800361:	0f b6 00             	movzbl (%rax),%eax
  800364:	0f b6 d0             	movzbl %al,%edx
  800367:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80036b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80036f:	48 89 cb             	mov    %rcx,%rbx
  800372:	48 29 c3             	sub    %rax,%rbx
  800375:	48 89 d8             	mov    %rbx,%rax
  800378:	89 c6                	mov    %eax,%esi
  80037a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80037e:	89 d1                	mov    %edx,%ecx
  800380:	48 ba 9e 50 80 00 00 	movabs $0x80509e,%rdx
  800387:	00 00 00 
  80038a:	48 89 c7             	mov    %rax,%rdi
  80038d:	b8 00 00 00 00       	mov    $0x0,%eax
  800392:	49 b8 05 16 80 00 00 	movabs $0x801605,%r8
  800399:	00 00 00 
  80039c:	41 ff d0             	callq  *%r8
  80039f:	48 98                	cltq   
  8003a1:	48 01 45 e0          	add    %rax,-0x20(%rbp)
        if (i % 16 == 15 || i == len - 1)
  8003a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003a8:	89 c2                	mov    %eax,%edx
  8003aa:	c1 fa 1f             	sar    $0x1f,%edx
  8003ad:	c1 ea 1c             	shr    $0x1c,%edx
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	83 e0 0f             	and    $0xf,%eax
  8003b5:	29 d0                	sub    %edx,%eax
  8003b7:	83 f8 0f             	cmp    $0xf,%eax
  8003ba:	74 0e                	je     8003ca <hexdump+0x112>
  8003bc:	8b 85 6c ff ff ff    	mov    -0x94(%rbp),%eax
  8003c2:	83 e8 01             	sub    $0x1,%eax
  8003c5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8003c8:	75 33                	jne    8003fd <hexdump+0x145>
            cprintf("%.*s\n", out - buf, buf);
  8003ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8003ce:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8003d2:	48 89 d1             	mov    %rdx,%rcx
  8003d5:	48 29 c1             	sub    %rax,%rcx
  8003d8:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8003dc:	48 89 c2             	mov    %rax,%rdx
  8003df:	48 89 ce             	mov    %rcx,%rsi
  8003e2:	48 bf a3 50 80 00 00 	movabs $0x8050a3,%rdi
  8003e9:	00 00 00 
  8003ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f1:	48 b9 83 0b 80 00 00 	movabs $0x800b83,%rcx
  8003f8:	00 00 00 
  8003fb:	ff d1                	callq  *%rcx
        if (i % 2 == 1)
  8003fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800400:	89 c2                	mov    %eax,%edx
  800402:	c1 fa 1f             	sar    $0x1f,%edx
  800405:	c1 ea 1f             	shr    $0x1f,%edx
  800408:	01 d0                	add    %edx,%eax
  80040a:	83 e0 01             	and    $0x1,%eax
  80040d:	29 d0                	sub    %edx,%eax
  80040f:	83 f8 01             	cmp    $0x1,%eax
  800412:	75 0c                	jne    800420 <hexdump+0x168>
            *(out++) = ' ';
  800414:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800418:	c6 00 20             	movb   $0x20,(%rax)
  80041b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
        if (i % 16 == 7)
  800420:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800423:	89 c2                	mov    %eax,%edx
  800425:	c1 fa 1f             	sar    $0x1f,%edx
  800428:	c1 ea 1c             	shr    $0x1c,%edx
  80042b:	01 d0                	add    %edx,%eax
  80042d:	83 e0 0f             	and    $0xf,%eax
  800430:	29 d0                	sub    %edx,%eax
  800432:	83 f8 07             	cmp    $0x7,%eax
  800435:	75 0c                	jne    800443 <hexdump+0x18b>
            *(out++) = ' ';
  800437:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80043b:	c6 00 20             	movb   $0x20,(%rax)
  80043e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
    char *out = NULL;
    for (i = 0; i < len; i++) {
  800443:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800447:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80044a:	3b 85 6c ff ff ff    	cmp    -0x94(%rbp),%eax
  800450:	0f 8c a2 fe ff ff    	jl     8002f8 <hexdump+0x40>
        if (i % 2 == 1)
            *(out++) = ' ';
        if (i % 16 == 7)
            *(out++) = ' ';
    }
}
  800456:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80045d:	5b                   	pop    %rbx
  80045e:	5d                   	pop    %rbp
  80045f:	c3                   	retq   

0000000000800460 <umain>:

    void
umain(int argc, char **argv)
{
  800460:	55                   	push   %rbp
  800461:	48 89 e5             	mov    %rsp,%rbp
  800464:	48 83 ec 30          	sub    $0x30,%rsp
  800468:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80046b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    envid_t ns_envid = sys_getenvid();
  80046f:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  800476:	00 00 00 
  800479:	ff d0                	callq  *%rax
  80047b:	89 45 f8             	mov    %eax,-0x8(%rbp)
    int i, r, first = 1;
  80047e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

    binaryname = "testinput";
  800485:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80048c:	00 00 00 
  80048f:	48 ba a9 50 80 00 00 	movabs $0x8050a9,%rdx
  800496:	00 00 00 
  800499:	48 89 10             	mov    %rdx,(%rax)

    output_envid = fork();
  80049c:	48 b8 a2 27 80 00 00 	movabs $0x8027a2,%rax
  8004a3:	00 00 00 
  8004a6:	ff d0                	callq  *%rax
  8004a8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8004af:	00 00 00 
  8004b2:	89 02                	mov    %eax,(%rdx)
    if (output_envid < 0)
  8004b4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004bb:	00 00 00 
  8004be:	8b 00                	mov    (%rax),%eax
  8004c0:	85 c0                	test   %eax,%eax
  8004c2:	79 2a                	jns    8004ee <umain+0x8e>
        panic("error forking");
  8004c4:	48 ba b3 50 80 00 00 	movabs $0x8050b3,%rdx
  8004cb:	00 00 00 
  8004ce:	be 4d 00 00 00       	mov    $0x4d,%esi
  8004d3:	48 bf 84 50 80 00 00 	movabs $0x805084,%rdi
  8004da:	00 00 00 
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  8004e9:	00 00 00 
  8004ec:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8004ee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004f5:	00 00 00 
  8004f8:	8b 00                	mov    (%rax),%eax
  8004fa:	85 c0                	test   %eax,%eax
  8004fc:	75 16                	jne    800514 <umain+0xb4>
        output(ns_envid);
  8004fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800501:	89 c7                	mov    %eax,%edi
  800503:	48 b8 58 08 80 00 00 	movabs $0x800858,%rax
  80050a:	00 00 00 
  80050d:	ff d0                	callq  *%rax
        return;
  80050f:	e9 fc 01 00 00       	jmpq   800710 <umain+0x2b0>
    }

    input_envid = fork();
  800514:	48 b8 a2 27 80 00 00 	movabs $0x8027a2,%rax
  80051b:	00 00 00 
  80051e:	ff d0                	callq  *%rax
  800520:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  800527:	00 00 00 
  80052a:	89 02                	mov    %eax,(%rdx)
    if (input_envid < 0)
  80052c:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  800533:	00 00 00 
  800536:	8b 00                	mov    (%rax),%eax
  800538:	85 c0                	test   %eax,%eax
  80053a:	79 2a                	jns    800566 <umain+0x106>
        panic("error forking");
  80053c:	48 ba b3 50 80 00 00 	movabs $0x8050b3,%rdx
  800543:	00 00 00 
  800546:	be 55 00 00 00       	mov    $0x55,%esi
  80054b:	48 bf 84 50 80 00 00 	movabs $0x805084,%rdi
  800552:	00 00 00 
  800555:	b8 00 00 00 00       	mov    $0x0,%eax
  80055a:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  800561:	00 00 00 
  800564:	ff d1                	callq  *%rcx
    else if (input_envid == 0) {
  800566:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80056d:	00 00 00 
  800570:	8b 00                	mov    (%rax),%eax
  800572:	85 c0                	test   %eax,%eax
  800574:	75 17                	jne    80058d <umain+0x12d>
        input(ns_envid);
  800576:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800579:	89 c7                	mov    %eax,%edi
  80057b:	48 b8 34 08 80 00 00 	movabs $0x800834,%rax
  800582:	00 00 00 
  800585:	ff d0                	callq  *%rax
        return;
  800587:	90                   	nop
  800588:	e9 83 01 00 00       	jmpq   800710 <umain+0x2b0>
    }

    cprintf("Sending ARP announcement...\n");
  80058d:	48 bf c1 50 80 00 00 	movabs $0x8050c1,%rdi
  800594:	00 00 00 
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	48 ba 83 0b 80 00 00 	movabs $0x800b83,%rdx
  8005a3:	00 00 00 
  8005a6:	ff d2                	callq  *%rdx
    announce();
  8005a8:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8005af:	00 00 00 
  8005b2:	ff d0                	callq  *%rax

    while (1) {
        envid_t whom;
        int perm;

        int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  8005b4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8005bb:	00 00 00 
  8005be:	48 8b 08             	mov    (%rax),%rcx
  8005c1:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
  8005c5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8005c9:	48 89 ce             	mov    %rcx,%rsi
  8005cc:	48 89 c7             	mov    %rax,%rdi
  8005cf:	48 b8 40 2b 80 00 00 	movabs $0x802b40,%rax
  8005d6:	00 00 00 
  8005d9:	ff d0                	callq  *%rax
  8005db:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (req < 0)
  8005de:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8005e2:	79 30                	jns    800614 <umain+0x1b4>
            panic("ipc_recv: %e", req);
  8005e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8005e7:	89 c1                	mov    %eax,%ecx
  8005e9:	48 ba de 50 80 00 00 	movabs $0x8050de,%rdx
  8005f0:	00 00 00 
  8005f3:	be 64 00 00 00       	mov    $0x64,%esi
  8005f8:	48 bf 84 50 80 00 00 	movabs $0x805084,%rdi
  8005ff:	00 00 00 
  800602:	b8 00 00 00 00       	mov    $0x0,%eax
  800607:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  80060e:	00 00 00 
  800611:	41 ff d0             	callq  *%r8
        if (whom != input_envid)
  800614:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800617:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80061e:	00 00 00 
  800621:	8b 00                	mov    (%rax),%eax
  800623:	39 c2                	cmp    %eax,%edx
  800625:	74 30                	je     800657 <umain+0x1f7>
            panic("IPC from unexpected environment %08x", whom);
  800627:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80062a:	89 c1                	mov    %eax,%ecx
  80062c:	48 ba f0 50 80 00 00 	movabs $0x8050f0,%rdx
  800633:	00 00 00 
  800636:	be 66 00 00 00       	mov    $0x66,%esi
  80063b:	48 bf 84 50 80 00 00 	movabs $0x805084,%rdi
  800642:	00 00 00 
  800645:	b8 00 00 00 00       	mov    $0x0,%eax
  80064a:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  800651:	00 00 00 
  800654:	41 ff d0             	callq  *%r8
        if (req != NSREQ_INPUT)
  800657:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  80065b:	74 30                	je     80068d <umain+0x22d>
            panic("Unexpected IPC %d", req);
  80065d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800660:	89 c1                	mov    %eax,%ecx
  800662:	48 ba 15 51 80 00 00 	movabs $0x805115,%rdx
  800669:	00 00 00 
  80066c:	be 68 00 00 00       	mov    $0x68,%esi
  800671:	48 bf 84 50 80 00 00 	movabs $0x805084,%rdi
  800678:	00 00 00 
  80067b:	b8 00 00 00 00       	mov    $0x0,%eax
  800680:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  800687:	00 00 00 
  80068a:	41 ff d0             	callq  *%r8

        hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80068d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800694:	00 00 00 
  800697:	48 8b 00             	mov    (%rax),%rax
  80069a:	8b 00                	mov    (%rax),%eax
  80069c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006a3:	00 00 00 
  8006a6:	48 8b 12             	mov    (%rdx),%rdx
  8006a9:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
  8006ad:	89 c2                	mov    %eax,%edx
  8006af:	48 89 ce             	mov    %rcx,%rsi
  8006b2:	48 bf 27 51 80 00 00 	movabs $0x805127,%rdi
  8006b9:	00 00 00 
  8006bc:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
        cprintf("\n");
  8006c8:	48 bf 2f 51 80 00 00 	movabs $0x80512f,%rdi
  8006cf:	00 00 00 
  8006d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d7:	48 ba 83 0b 80 00 00 	movabs $0x800b83,%rdx
  8006de:	00 00 00 
  8006e1:	ff d2                	callq  *%rdx

        // Only indicate that we're waiting for packets once
        // we've received the ARP reply
        if (first)
  8006e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006e7:	74 1b                	je     800704 <umain+0x2a4>
            cprintf("Waiting for packets...\n");
  8006e9:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  8006f0:	00 00 00 
  8006f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f8:	48 ba 83 0b 80 00 00 	movabs $0x800b83,%rdx
  8006ff:	00 00 00 
  800702:	ff d2                	callq  *%rdx
        first = 0;
  800704:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    }
  80070b:	e9 a4 fe ff ff       	jmpq   8005b4 <umain+0x154>
}
  800710:	c9                   	leaveq 
  800711:	c3                   	retq   
	...

0000000000800714 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800714:	55                   	push   %rbp
  800715:	48 89 e5             	mov    %rsp,%rbp
  800718:	48 83 ec 20          	sub    $0x20,%rsp
  80071c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80071f:	89 75 e8             	mov    %esi,-0x18(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800722:	48 b8 f9 22 80 00 00 	movabs $0x8022f9,%rax
  800729:	00 00 00 
  80072c:	ff d0                	callq  *%rax
  80072e:	03 45 e8             	add    -0x18(%rbp),%eax
  800731:	89 45 fc             	mov    %eax,-0x4(%rbp)

    binaryname = "ns_timer";
  800734:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80073b:	00 00 00 
  80073e:	48 ba 50 51 80 00 00 	movabs $0x805150,%rdx
  800745:	00 00 00 
  800748:	48 89 10             	mov    %rdx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  80074b:	eb 0c                	jmp    800759 <timer+0x45>
            sys_yield();
  80074d:	48 b8 4e 20 80 00 00 	movabs $0x80204e,%rax
  800754:	00 00 00 
  800757:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800759:	48 b8 f9 22 80 00 00 	movabs $0x8022f9,%rax
  800760:	00 00 00 
  800763:	ff d0                	callq  *%rax
  800765:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800768:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80076b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80076e:	73 06                	jae    800776 <timer+0x62>
  800770:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800774:	79 d7                	jns    80074d <timer+0x39>
            sys_yield();
        }
        if (r < 0)
  800776:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80077a:	79 30                	jns    8007ac <timer+0x98>
            panic("sys_time_msec: %e", r);
  80077c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80077f:	89 c1                	mov    %eax,%ecx
  800781:	48 ba 59 51 80 00 00 	movabs $0x805159,%rdx
  800788:	00 00 00 
  80078b:	be 0f 00 00 00       	mov    $0xf,%esi
  800790:	48 bf 6b 51 80 00 00 	movabs $0x80516b,%rdi
  800797:	00 00 00 
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8007a6:	00 00 00 
  8007a9:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8007ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8007af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b9:	be 0c 00 00 00       	mov    $0xc,%esi
  8007be:	89 c7                	mov    %eax,%edi
  8007c0:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  8007c7:	00 00 00 
  8007ca:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  8007cc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8007d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d5:	be 00 00 00 00       	mov    $0x0,%esi
  8007da:	48 89 c7             	mov    %rax,%rdi
  8007dd:	48 b8 40 2b 80 00 00 	movabs $0x802b40,%rax
  8007e4:	00 00 00 
  8007e7:	ff d0                	callq  *%rax
  8007e9:	89 45 f4             	mov    %eax,-0xc(%rbp)

            if (whom != ns_envid) {
  8007ec:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8007ef:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8007f2:	39 c2                	cmp    %eax,%edx
  8007f4:	74 22                	je     800818 <timer+0x104>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8007f6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8007f9:	89 c6                	mov    %eax,%esi
  8007fb:	48 bf 78 51 80 00 00 	movabs $0x805178,%rdi
  800802:	00 00 00 
  800805:	b8 00 00 00 00       	mov    $0x0,%eax
  80080a:	48 ba 83 0b 80 00 00 	movabs $0x800b83,%rdx
  800811:	00 00 00 
  800814:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  800816:	eb b4                	jmp    8007cc <timer+0xb8>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  800818:	48 b8 f9 22 80 00 00 	movabs $0x8022f9,%rax
  80081f:	00 00 00 
  800822:	ff d0                	callq  *%rax
  800824:	03 45 f4             	add    -0xc(%rbp),%eax
  800827:	89 45 fc             	mov    %eax,-0x4(%rbp)
            break;
  80082a:	90                   	nop
        }
    }
  80082b:	90                   	nop
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  80082c:	e9 28 ff ff ff       	jmpq   800759 <timer+0x45>
  800831:	00 00                	add    %al,(%rax)
	...

0000000000800834 <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  800834:	55                   	push   %rbp
  800835:	48 89 e5             	mov    %rsp,%rbp
  800838:	48 83 ec 08          	sub    $0x8,%rsp
  80083c:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_input";
  80083f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800846:	00 00 00 
  800849:	48 ba b3 51 80 00 00 	movabs $0x8051b3,%rdx
  800850:	00 00 00 
  800853:	48 89 10             	mov    %rdx,(%rax)
    // 	- read a packet from the device driver
    //	- send it to the network server
    // Hint: When you IPC a page to the network server, it will be
    // reading from it for a while, so don't immediately receive
    // another packet in to the same physical page.
}
  800856:	c9                   	leaveq 
  800857:	c3                   	retq   

0000000000800858 <output>:

extern union Nsipc nsipcbuf;

    void
output(envid_t ns_envid)
{
  800858:	55                   	push   %rbp
  800859:	48 89 e5             	mov    %rsp,%rbp
  80085c:	48 83 ec 08          	sub    $0x8,%rsp
  800860:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_output";
  800863:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80086a:	00 00 00 
  80086d:	48 ba bc 51 80 00 00 	movabs $0x8051bc,%rdx
  800874:	00 00 00 
  800877:	48 89 10             	mov    %rdx,(%rax)

    // LAB 6: Your code here:
    // 	- read a packet from the network server
    //	- send the packet to the device driver
}
  80087a:	c9                   	leaveq 
  80087b:	c3                   	retq   

000000000080087c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80087c:	55                   	push   %rbp
  80087d:	48 89 e5             	mov    %rsp,%rbp
  800880:	48 83 ec 10          	sub    $0x10,%rsp
  800884:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800887:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80088b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800892:	00 00 00 
  800895:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv = &envs[ENVX(sys_getenvid())];
  80089c:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  8008a3:	00 00 00 
  8008a6:	ff d0                	callq  *%rax
  8008a8:	48 98                	cltq   
  8008aa:	48 89 c2             	mov    %rax,%rdx
  8008ad:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8008b3:	48 89 d0             	mov    %rdx,%rax
  8008b6:	48 c1 e0 02          	shl    $0x2,%rax
  8008ba:	48 01 d0             	add    %rdx,%rax
  8008bd:	48 01 c0             	add    %rax,%rax
  8008c0:	48 01 d0             	add    %rdx,%rax
  8008c3:	48 c1 e0 05          	shl    $0x5,%rax
  8008c7:	48 89 c2             	mov    %rax,%rdx
  8008ca:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8008d1:	00 00 00 
  8008d4:	48 01 c2             	add    %rax,%rdx
  8008d7:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8008de:	00 00 00 
  8008e1:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008e8:	7e 14                	jle    8008fe <libmain+0x82>
		binaryname = argv[0];
  8008ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ee:	48 8b 10             	mov    (%rax),%rdx
  8008f1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8008f8:	00 00 00 
  8008fb:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800902:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800905:	48 89 d6             	mov    %rdx,%rsi
  800908:	89 c7                	mov    %eax,%edi
  80090a:	48 b8 60 04 80 00 00 	movabs $0x800460,%rax
  800911:	00 00 00 
  800914:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800916:	48 b8 24 09 80 00 00 	movabs $0x800924,%rax
  80091d:	00 00 00 
  800920:	ff d0                	callq  *%rax
}
  800922:	c9                   	leaveq 
  800923:	c3                   	retq   

0000000000800924 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800924:	55                   	push   %rbp
  800925:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800928:	48 b8 a5 30 80 00 00 	movabs $0x8030a5,%rax
  80092f:	00 00 00 
  800932:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800934:	bf 00 00 00 00       	mov    $0x0,%edi
  800939:	48 b8 cc 1f 80 00 00 	movabs $0x801fcc,%rax
  800940:	00 00 00 
  800943:	ff d0                	callq  *%rax
}
  800945:	5d                   	pop    %rbp
  800946:	c3                   	retq   
	...

0000000000800948 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800948:	55                   	push   %rbp
  800949:	48 89 e5             	mov    %rsp,%rbp
  80094c:	53                   	push   %rbx
  80094d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800954:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80095b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800961:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800968:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80096f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800976:	84 c0                	test   %al,%al
  800978:	74 23                	je     80099d <_panic+0x55>
  80097a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800981:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800985:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800989:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80098d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800991:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800995:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800999:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80099d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8009a4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8009ab:	00 00 00 
  8009ae:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8009b5:	00 00 00 
  8009b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009bc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8009c3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8009ca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8009d1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8009d8:	00 00 00 
  8009db:	48 8b 18             	mov    (%rax),%rbx
  8009de:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  8009e5:	00 00 00 
  8009e8:	ff d0                	callq  *%rax
  8009ea:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8009f0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8009f7:	41 89 c8             	mov    %ecx,%r8d
  8009fa:	48 89 d1             	mov    %rdx,%rcx
  8009fd:	48 89 da             	mov    %rbx,%rdx
  800a00:	89 c6                	mov    %eax,%esi
  800a02:	48 bf d0 51 80 00 00 	movabs $0x8051d0,%rdi
  800a09:	00 00 00 
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	49 b9 83 0b 80 00 00 	movabs $0x800b83,%r9
  800a18:	00 00 00 
  800a1b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a1e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800a25:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a2c:	48 89 d6             	mov    %rdx,%rsi
  800a2f:	48 89 c7             	mov    %rax,%rdi
  800a32:	48 b8 d7 0a 80 00 00 	movabs $0x800ad7,%rax
  800a39:	00 00 00 
  800a3c:	ff d0                	callq  *%rax
	cprintf("\n");
  800a3e:	48 bf f3 51 80 00 00 	movabs $0x8051f3,%rdi
  800a45:	00 00 00 
  800a48:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4d:	48 ba 83 0b 80 00 00 	movabs $0x800b83,%rdx
  800a54:	00 00 00 
  800a57:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a59:	cc                   	int3   
  800a5a:	eb fd                	jmp    800a59 <_panic+0x111>

0000000000800a5c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800a5c:	55                   	push   %rbp
  800a5d:	48 89 e5             	mov    %rsp,%rbp
  800a60:	48 83 ec 10          	sub    $0x10,%rsp
  800a64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6f:	8b 00                	mov    (%rax),%eax
  800a71:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a74:	89 d6                	mov    %edx,%esi
  800a76:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800a7a:	48 63 d0             	movslq %eax,%rdx
  800a7d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800a82:	8d 50 01             	lea    0x1(%rax),%edx
  800a85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a89:	89 10                	mov    %edx,(%rax)
    if (b->idx == 256-1) {
  800a8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a8f:	8b 00                	mov    (%rax),%eax
  800a91:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a96:	75 2c                	jne    800ac4 <putch+0x68>
        sys_cputs(b->buf, b->idx);
  800a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a9c:	8b 00                	mov    (%rax),%eax
  800a9e:	48 98                	cltq   
  800aa0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aa4:	48 83 c2 08          	add    $0x8,%rdx
  800aa8:	48 89 c6             	mov    %rax,%rsi
  800aab:	48 89 d7             	mov    %rdx,%rdi
  800aae:	48 b8 44 1f 80 00 00 	movabs $0x801f44,%rax
  800ab5:	00 00 00 
  800ab8:	ff d0                	callq  *%rax
        b->idx = 0;
  800aba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800abe:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800ac4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ac8:	8b 40 04             	mov    0x4(%rax),%eax
  800acb:	8d 50 01             	lea    0x1(%rax),%edx
  800ace:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad2:	89 50 04             	mov    %edx,0x4(%rax)
}
  800ad5:	c9                   	leaveq 
  800ad6:	c3                   	retq   

0000000000800ad7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800ad7:	55                   	push   %rbp
  800ad8:	48 89 e5             	mov    %rsp,%rbp
  800adb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800ae2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ae9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800af0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800af7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800afe:	48 8b 0a             	mov    (%rdx),%rcx
  800b01:	48 89 08             	mov    %rcx,(%rax)
  800b04:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b08:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b0c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b10:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800b14:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800b1b:	00 00 00 
    b.cnt = 0;
  800b1e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800b25:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800b28:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800b2f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800b36:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800b3d:	48 89 c6             	mov    %rax,%rsi
  800b40:	48 bf 5c 0a 80 00 00 	movabs $0x800a5c,%rdi
  800b47:	00 00 00 
  800b4a:	48 b8 34 0f 80 00 00 	movabs $0x800f34,%rax
  800b51:	00 00 00 
  800b54:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800b56:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800b5c:	48 98                	cltq   
  800b5e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b65:	48 83 c2 08          	add    $0x8,%rdx
  800b69:	48 89 c6             	mov    %rax,%rsi
  800b6c:	48 89 d7             	mov    %rdx,%rdi
  800b6f:	48 b8 44 1f 80 00 00 	movabs $0x801f44,%rax
  800b76:	00 00 00 
  800b79:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b7b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b81:	c9                   	leaveq 
  800b82:	c3                   	retq   

0000000000800b83 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b83:	55                   	push   %rbp
  800b84:	48 89 e5             	mov    %rsp,%rbp
  800b87:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b8e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b95:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b9c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ba3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800baa:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bb1:	84 c0                	test   %al,%al
  800bb3:	74 20                	je     800bd5 <cprintf+0x52>
  800bb5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bb9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bbd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bc1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bc5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bc9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bcd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bd1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bd5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800bdc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800be3:	00 00 00 
  800be6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800bed:	00 00 00 
  800bf0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bf4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800bfb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c02:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800c09:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800c10:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800c17:	48 8b 0a             	mov    (%rdx),%rcx
  800c1a:	48 89 08             	mov    %rcx,(%rax)
  800c1d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c21:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c25:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c29:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800c2d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800c34:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800c3b:	48 89 d6             	mov    %rdx,%rsi
  800c3e:	48 89 c7             	mov    %rax,%rdi
  800c41:	48 b8 d7 0a 80 00 00 	movabs $0x800ad7,%rax
  800c48:	00 00 00 
  800c4b:	ff d0                	callq  *%rax
  800c4d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800c53:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800c59:	c9                   	leaveq 
  800c5a:	c3                   	retq   
	...

0000000000800c5c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c5c:	55                   	push   %rbp
  800c5d:	48 89 e5             	mov    %rsp,%rbp
  800c60:	48 83 ec 30          	sub    $0x30,%rsp
  800c64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800c68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800c6c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800c70:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800c73:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800c77:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c7b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c7e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800c82:	77 52                	ja     800cd6 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c84:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800c87:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c8b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800c8e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800c92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c96:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9b:	48 f7 75 d0          	divq   -0x30(%rbp)
  800c9f:	48 89 c2             	mov    %rax,%rdx
  800ca2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ca5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ca8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800cac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800cb0:	41 89 f9             	mov    %edi,%r9d
  800cb3:	48 89 c7             	mov    %rax,%rdi
  800cb6:	48 b8 5c 0c 80 00 00 	movabs $0x800c5c,%rax
  800cbd:	00 00 00 
  800cc0:	ff d0                	callq  *%rax
  800cc2:	eb 1c                	jmp    800ce0 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cc8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ccb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800ccf:	48 89 d6             	mov    %rdx,%rsi
  800cd2:	89 c7                	mov    %eax,%edi
  800cd4:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cd6:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800cda:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800cde:	7f e4                	jg     800cc4 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ce0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ce3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cec:	48 f7 f1             	div    %rcx
  800cef:	48 89 d0             	mov    %rdx,%rax
  800cf2:	48 ba f0 53 80 00 00 	movabs $0x8053f0,%rdx
  800cf9:	00 00 00 
  800cfc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800d00:	0f be c0             	movsbl %al,%eax
  800d03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d07:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800d0b:	48 89 d6             	mov    %rdx,%rsi
  800d0e:	89 c7                	mov    %eax,%edi
  800d10:	ff d1                	callq  *%rcx
}
  800d12:	c9                   	leaveq 
  800d13:	c3                   	retq   

0000000000800d14 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d14:	55                   	push   %rbp
  800d15:	48 89 e5             	mov    %rsp,%rbp
  800d18:	48 83 ec 20          	sub    $0x20,%rsp
  800d1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d20:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800d23:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800d27:	7e 52                	jle    800d7b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2d:	8b 00                	mov    (%rax),%eax
  800d2f:	83 f8 30             	cmp    $0x30,%eax
  800d32:	73 24                	jae    800d58 <getuint+0x44>
  800d34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d38:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d40:	8b 00                	mov    (%rax),%eax
  800d42:	89 c0                	mov    %eax,%eax
  800d44:	48 01 d0             	add    %rdx,%rax
  800d47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d4b:	8b 12                	mov    (%rdx),%edx
  800d4d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d54:	89 0a                	mov    %ecx,(%rdx)
  800d56:	eb 17                	jmp    800d6f <getuint+0x5b>
  800d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d60:	48 89 d0             	mov    %rdx,%rax
  800d63:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d6b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d6f:	48 8b 00             	mov    (%rax),%rax
  800d72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d76:	e9 a3 00 00 00       	jmpq   800e1e <getuint+0x10a>
	else if (lflag)
  800d7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d7f:	74 4f                	je     800dd0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d85:	8b 00                	mov    (%rax),%eax
  800d87:	83 f8 30             	cmp    $0x30,%eax
  800d8a:	73 24                	jae    800db0 <getuint+0x9c>
  800d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d90:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d98:	8b 00                	mov    (%rax),%eax
  800d9a:	89 c0                	mov    %eax,%eax
  800d9c:	48 01 d0             	add    %rdx,%rax
  800d9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da3:	8b 12                	mov    (%rdx),%edx
  800da5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800da8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dac:	89 0a                	mov    %ecx,(%rdx)
  800dae:	eb 17                	jmp    800dc7 <getuint+0xb3>
  800db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800db8:	48 89 d0             	mov    %rdx,%rax
  800dbb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800dbf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800dc7:	48 8b 00             	mov    (%rax),%rax
  800dca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800dce:	eb 4e                	jmp    800e1e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800dd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd4:	8b 00                	mov    (%rax),%eax
  800dd6:	83 f8 30             	cmp    $0x30,%eax
  800dd9:	73 24                	jae    800dff <getuint+0xeb>
  800ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de7:	8b 00                	mov    (%rax),%eax
  800de9:	89 c0                	mov    %eax,%eax
  800deb:	48 01 d0             	add    %rdx,%rax
  800dee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800df2:	8b 12                	mov    (%rdx),%edx
  800df4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800df7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dfb:	89 0a                	mov    %ecx,(%rdx)
  800dfd:	eb 17                	jmp    800e16 <getuint+0x102>
  800dff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e03:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e07:	48 89 d0             	mov    %rdx,%rax
  800e0a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e12:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e16:	8b 00                	mov    (%rax),%eax
  800e18:	89 c0                	mov    %eax,%eax
  800e1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e22:	c9                   	leaveq 
  800e23:	c3                   	retq   

0000000000800e24 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e24:	55                   	push   %rbp
  800e25:	48 89 e5             	mov    %rsp,%rbp
  800e28:	48 83 ec 20          	sub    $0x20,%rsp
  800e2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e30:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800e33:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800e37:	7e 52                	jle    800e8b <getint+0x67>
		x=va_arg(*ap, long long);
  800e39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3d:	8b 00                	mov    (%rax),%eax
  800e3f:	83 f8 30             	cmp    $0x30,%eax
  800e42:	73 24                	jae    800e68 <getint+0x44>
  800e44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e48:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e50:	8b 00                	mov    (%rax),%eax
  800e52:	89 c0                	mov    %eax,%eax
  800e54:	48 01 d0             	add    %rdx,%rax
  800e57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5b:	8b 12                	mov    (%rdx),%edx
  800e5d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e64:	89 0a                	mov    %ecx,(%rdx)
  800e66:	eb 17                	jmp    800e7f <getint+0x5b>
  800e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e70:	48 89 d0             	mov    %rdx,%rax
  800e73:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e7b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e7f:	48 8b 00             	mov    (%rax),%rax
  800e82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e86:	e9 a3 00 00 00       	jmpq   800f2e <getint+0x10a>
	else if (lflag)
  800e8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e8f:	74 4f                	je     800ee0 <getint+0xbc>
		x=va_arg(*ap, long);
  800e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e95:	8b 00                	mov    (%rax),%eax
  800e97:	83 f8 30             	cmp    $0x30,%eax
  800e9a:	73 24                	jae    800ec0 <getint+0x9c>
  800e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea8:	8b 00                	mov    (%rax),%eax
  800eaa:	89 c0                	mov    %eax,%eax
  800eac:	48 01 d0             	add    %rdx,%rax
  800eaf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb3:	8b 12                	mov    (%rdx),%edx
  800eb5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800eb8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebc:	89 0a                	mov    %ecx,(%rdx)
  800ebe:	eb 17                	jmp    800ed7 <getint+0xb3>
  800ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ec8:	48 89 d0             	mov    %rdx,%rax
  800ecb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ecf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ed7:	48 8b 00             	mov    (%rax),%rax
  800eda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ede:	eb 4e                	jmp    800f2e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ee0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee4:	8b 00                	mov    (%rax),%eax
  800ee6:	83 f8 30             	cmp    $0x30,%eax
  800ee9:	73 24                	jae    800f0f <getint+0xeb>
  800eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef7:	8b 00                	mov    (%rax),%eax
  800ef9:	89 c0                	mov    %eax,%eax
  800efb:	48 01 d0             	add    %rdx,%rax
  800efe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f02:	8b 12                	mov    (%rdx),%edx
  800f04:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f0b:	89 0a                	mov    %ecx,(%rdx)
  800f0d:	eb 17                	jmp    800f26 <getint+0x102>
  800f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f13:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f17:	48 89 d0             	mov    %rdx,%rax
  800f1a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f22:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f26:	8b 00                	mov    (%rax),%eax
  800f28:	48 98                	cltq   
  800f2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f32:	c9                   	leaveq 
  800f33:	c3                   	retq   

0000000000800f34 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f34:	55                   	push   %rbp
  800f35:	48 89 e5             	mov    %rsp,%rbp
  800f38:	41 54                	push   %r12
  800f3a:	53                   	push   %rbx
  800f3b:	48 83 ec 60          	sub    $0x60,%rsp
  800f3f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800f43:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800f47:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f4b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800f4f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f53:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800f57:	48 8b 0a             	mov    (%rdx),%rcx
  800f5a:	48 89 08             	mov    %rcx,(%rax)
  800f5d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f61:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f65:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f69:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f6d:	eb 17                	jmp    800f86 <vprintfmt+0x52>
			if (ch == '\0')
  800f6f:	85 db                	test   %ebx,%ebx
  800f71:	0f 84 ea 04 00 00    	je     801461 <vprintfmt+0x52d>
				return;
			putch(ch, putdat);
  800f77:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f7b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f7f:	48 89 c6             	mov    %rax,%rsi
  800f82:	89 df                	mov    %ebx,%edi
  800f84:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f86:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f8a:	0f b6 00             	movzbl (%rax),%eax
  800f8d:	0f b6 d8             	movzbl %al,%ebx
  800f90:	83 fb 25             	cmp    $0x25,%ebx
  800f93:	0f 95 c0             	setne  %al
  800f96:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800f9b:	84 c0                	test   %al,%al
  800f9d:	75 d0                	jne    800f6f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f9f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800fa3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800faa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800fb1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800fb8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800fbf:	eb 04                	jmp    800fc5 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800fc1:	90                   	nop
  800fc2:	eb 01                	jmp    800fc5 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800fc4:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fc5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fc9:	0f b6 00             	movzbl (%rax),%eax
  800fcc:	0f b6 d8             	movzbl %al,%ebx
  800fcf:	89 d8                	mov    %ebx,%eax
  800fd1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800fd6:	83 e8 23             	sub    $0x23,%eax
  800fd9:	83 f8 55             	cmp    $0x55,%eax
  800fdc:	0f 87 4b 04 00 00    	ja     80142d <vprintfmt+0x4f9>
  800fe2:	89 c0                	mov    %eax,%eax
  800fe4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800feb:	00 
  800fec:	48 b8 18 54 80 00 00 	movabs $0x805418,%rax
  800ff3:	00 00 00 
  800ff6:	48 01 d0             	add    %rdx,%rax
  800ff9:	48 8b 00             	mov    (%rax),%rax
  800ffc:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ffe:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801002:	eb c1                	jmp    800fc5 <vprintfmt+0x91>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801004:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801008:	eb bb                	jmp    800fc5 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80100a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  801011:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801014:	89 d0                	mov    %edx,%eax
  801016:	c1 e0 02             	shl    $0x2,%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	01 c0                	add    %eax,%eax
  80101d:	01 d8                	add    %ebx,%eax
  80101f:	83 e8 30             	sub    $0x30,%eax
  801022:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801025:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801029:	0f b6 00             	movzbl (%rax),%eax
  80102c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80102f:	83 fb 2f             	cmp    $0x2f,%ebx
  801032:	7e 63                	jle    801097 <vprintfmt+0x163>
  801034:	83 fb 39             	cmp    $0x39,%ebx
  801037:	7f 5e                	jg     801097 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801039:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80103e:	eb d1                	jmp    801011 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  801040:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801043:	83 f8 30             	cmp    $0x30,%eax
  801046:	73 17                	jae    80105f <vprintfmt+0x12b>
  801048:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80104c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80104f:	89 c0                	mov    %eax,%eax
  801051:	48 01 d0             	add    %rdx,%rax
  801054:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801057:	83 c2 08             	add    $0x8,%edx
  80105a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80105d:	eb 0f                	jmp    80106e <vprintfmt+0x13a>
  80105f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801063:	48 89 d0             	mov    %rdx,%rax
  801066:	48 83 c2 08          	add    $0x8,%rdx
  80106a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80106e:	8b 00                	mov    (%rax),%eax
  801070:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801073:	eb 23                	jmp    801098 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  801075:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801079:	0f 89 42 ff ff ff    	jns    800fc1 <vprintfmt+0x8d>
				width = 0;
  80107f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801086:	e9 36 ff ff ff       	jmpq   800fc1 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  80108b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801092:	e9 2e ff ff ff       	jmpq   800fc5 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801097:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801098:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80109c:	0f 89 22 ff ff ff    	jns    800fc4 <vprintfmt+0x90>
				width = precision, precision = -1;
  8010a2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8010a5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8010a8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8010af:	e9 10 ff ff ff       	jmpq   800fc4 <vprintfmt+0x90>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8010b4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8010b8:	e9 08 ff ff ff       	jmpq   800fc5 <vprintfmt+0x91>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8010bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010c0:	83 f8 30             	cmp    $0x30,%eax
  8010c3:	73 17                	jae    8010dc <vprintfmt+0x1a8>
  8010c5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010cc:	89 c0                	mov    %eax,%eax
  8010ce:	48 01 d0             	add    %rdx,%rax
  8010d1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010d4:	83 c2 08             	add    $0x8,%edx
  8010d7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010da:	eb 0f                	jmp    8010eb <vprintfmt+0x1b7>
  8010dc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010e0:	48 89 d0             	mov    %rdx,%rax
  8010e3:	48 83 c2 08          	add    $0x8,%rdx
  8010e7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010eb:	8b 00                	mov    (%rax),%eax
  8010ed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010f1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8010f5:	48 89 d6             	mov    %rdx,%rsi
  8010f8:	89 c7                	mov    %eax,%edi
  8010fa:	ff d1                	callq  *%rcx
			break;
  8010fc:	e9 5a 03 00 00       	jmpq   80145b <vprintfmt+0x527>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801101:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801104:	83 f8 30             	cmp    $0x30,%eax
  801107:	73 17                	jae    801120 <vprintfmt+0x1ec>
  801109:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80110d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801110:	89 c0                	mov    %eax,%eax
  801112:	48 01 d0             	add    %rdx,%rax
  801115:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801118:	83 c2 08             	add    $0x8,%edx
  80111b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80111e:	eb 0f                	jmp    80112f <vprintfmt+0x1fb>
  801120:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801124:	48 89 d0             	mov    %rdx,%rax
  801127:	48 83 c2 08          	add    $0x8,%rdx
  80112b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80112f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801131:	85 db                	test   %ebx,%ebx
  801133:	79 02                	jns    801137 <vprintfmt+0x203>
				err = -err;
  801135:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801137:	83 fb 15             	cmp    $0x15,%ebx
  80113a:	7f 16                	jg     801152 <vprintfmt+0x21e>
  80113c:	48 b8 40 53 80 00 00 	movabs $0x805340,%rax
  801143:	00 00 00 
  801146:	48 63 d3             	movslq %ebx,%rdx
  801149:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80114d:	4d 85 e4             	test   %r12,%r12
  801150:	75 2e                	jne    801180 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  801152:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801156:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80115a:	89 d9                	mov    %ebx,%ecx
  80115c:	48 ba 01 54 80 00 00 	movabs $0x805401,%rdx
  801163:	00 00 00 
  801166:	48 89 c7             	mov    %rax,%rdi
  801169:	b8 00 00 00 00       	mov    $0x0,%eax
  80116e:	49 b8 6b 14 80 00 00 	movabs $0x80146b,%r8
  801175:	00 00 00 
  801178:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80117b:	e9 db 02 00 00       	jmpq   80145b <vprintfmt+0x527>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801180:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801184:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801188:	4c 89 e1             	mov    %r12,%rcx
  80118b:	48 ba 0a 54 80 00 00 	movabs $0x80540a,%rdx
  801192:	00 00 00 
  801195:	48 89 c7             	mov    %rax,%rdi
  801198:	b8 00 00 00 00       	mov    $0x0,%eax
  80119d:	49 b8 6b 14 80 00 00 	movabs $0x80146b,%r8
  8011a4:	00 00 00 
  8011a7:	41 ff d0             	callq  *%r8
			break;
  8011aa:	e9 ac 02 00 00       	jmpq   80145b <vprintfmt+0x527>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8011af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011b2:	83 f8 30             	cmp    $0x30,%eax
  8011b5:	73 17                	jae    8011ce <vprintfmt+0x29a>
  8011b7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011be:	89 c0                	mov    %eax,%eax
  8011c0:	48 01 d0             	add    %rdx,%rax
  8011c3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011c6:	83 c2 08             	add    $0x8,%edx
  8011c9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011cc:	eb 0f                	jmp    8011dd <vprintfmt+0x2a9>
  8011ce:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011d2:	48 89 d0             	mov    %rdx,%rax
  8011d5:	48 83 c2 08          	add    $0x8,%rdx
  8011d9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011dd:	4c 8b 20             	mov    (%rax),%r12
  8011e0:	4d 85 e4             	test   %r12,%r12
  8011e3:	75 0a                	jne    8011ef <vprintfmt+0x2bb>
				p = "(null)";
  8011e5:	49 bc 0d 54 80 00 00 	movabs $0x80540d,%r12
  8011ec:	00 00 00 
			if (width > 0 && padc != '-')
  8011ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011f3:	7e 7a                	jle    80126f <vprintfmt+0x33b>
  8011f5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8011f9:	74 74                	je     80126f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8011fb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8011fe:	48 98                	cltq   
  801200:	48 89 c6             	mov    %rax,%rsi
  801203:	4c 89 e7             	mov    %r12,%rdi
  801206:	48 b8 16 17 80 00 00 	movabs $0x801716,%rax
  80120d:	00 00 00 
  801210:	ff d0                	callq  *%rax
  801212:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801215:	eb 17                	jmp    80122e <vprintfmt+0x2fa>
					putch(padc, putdat);
  801217:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  80121b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80121f:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  801223:	48 89 d6             	mov    %rdx,%rsi
  801226:	89 c7                	mov    %eax,%edi
  801228:	ff d1                	callq  *%rcx
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80122a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80122e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801232:	7f e3                	jg     801217 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801234:	eb 39                	jmp    80126f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  801236:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80123a:	74 1e                	je     80125a <vprintfmt+0x326>
  80123c:	83 fb 1f             	cmp    $0x1f,%ebx
  80123f:	7e 05                	jle    801246 <vprintfmt+0x312>
  801241:	83 fb 7e             	cmp    $0x7e,%ebx
  801244:	7e 14                	jle    80125a <vprintfmt+0x326>
					putch('?', putdat);
  801246:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80124a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80124e:	48 89 c6             	mov    %rax,%rsi
  801251:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801256:	ff d2                	callq  *%rdx
  801258:	eb 0f                	jmp    801269 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  80125a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80125e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801262:	48 89 c6             	mov    %rax,%rsi
  801265:	89 df                	mov    %ebx,%edi
  801267:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801269:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80126d:	eb 01                	jmp    801270 <vprintfmt+0x33c>
  80126f:	90                   	nop
  801270:	41 0f b6 04 24       	movzbl (%r12),%eax
  801275:	0f be d8             	movsbl %al,%ebx
  801278:	85 db                	test   %ebx,%ebx
  80127a:	0f 95 c0             	setne  %al
  80127d:	49 83 c4 01          	add    $0x1,%r12
  801281:	84 c0                	test   %al,%al
  801283:	74 28                	je     8012ad <vprintfmt+0x379>
  801285:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801289:	78 ab                	js     801236 <vprintfmt+0x302>
  80128b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80128f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801293:	79 a1                	jns    801236 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801295:	eb 16                	jmp    8012ad <vprintfmt+0x379>
				putch(' ', putdat);
  801297:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80129b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80129f:	48 89 c6             	mov    %rax,%rsi
  8012a2:	bf 20 00 00 00       	mov    $0x20,%edi
  8012a7:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8012a9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8012ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8012b1:	7f e4                	jg     801297 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  8012b3:	e9 a3 01 00 00       	jmpq   80145b <vprintfmt+0x527>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8012b8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012bc:	be 03 00 00 00       	mov    $0x3,%esi
  8012c1:	48 89 c7             	mov    %rax,%rdi
  8012c4:	48 b8 24 0e 80 00 00 	movabs $0x800e24,%rax
  8012cb:	00 00 00 
  8012ce:	ff d0                	callq  *%rax
  8012d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8012d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d8:	48 85 c0             	test   %rax,%rax
  8012db:	79 1d                	jns    8012fa <vprintfmt+0x3c6>
				putch('-', putdat);
  8012dd:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8012e1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8012e5:	48 89 c6             	mov    %rax,%rsi
  8012e8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8012ed:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8012ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f3:	48 f7 d8             	neg    %rax
  8012f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8012fa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801301:	e9 e8 00 00 00       	jmpq   8013ee <vprintfmt+0x4ba>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801306:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80130a:	be 03 00 00 00       	mov    $0x3,%esi
  80130f:	48 89 c7             	mov    %rax,%rdi
  801312:	48 b8 14 0d 80 00 00 	movabs $0x800d14,%rax
  801319:	00 00 00 
  80131c:	ff d0                	callq  *%rax
  80131e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801322:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801329:	e9 c0 00 00 00       	jmpq   8013ee <vprintfmt+0x4ba>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80132e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801332:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801336:	48 89 c6             	mov    %rax,%rsi
  801339:	bf 58 00 00 00       	mov    $0x58,%edi
  80133e:	ff d2                	callq  *%rdx
			putch('X', putdat);
  801340:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801344:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801348:	48 89 c6             	mov    %rax,%rsi
  80134b:	bf 58 00 00 00       	mov    $0x58,%edi
  801350:	ff d2                	callq  *%rdx
			putch('X', putdat);
  801352:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801356:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80135a:	48 89 c6             	mov    %rax,%rsi
  80135d:	bf 58 00 00 00       	mov    $0x58,%edi
  801362:	ff d2                	callq  *%rdx
			break;
  801364:	e9 f2 00 00 00       	jmpq   80145b <vprintfmt+0x527>

			// pointer
		case 'p':
			putch('0', putdat);
  801369:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80136d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801371:	48 89 c6             	mov    %rax,%rsi
  801374:	bf 30 00 00 00       	mov    $0x30,%edi
  801379:	ff d2                	callq  *%rdx
			putch('x', putdat);
  80137b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80137f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801383:	48 89 c6             	mov    %rax,%rsi
  801386:	bf 78 00 00 00       	mov    $0x78,%edi
  80138b:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80138d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801390:	83 f8 30             	cmp    $0x30,%eax
  801393:	73 17                	jae    8013ac <vprintfmt+0x478>
  801395:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801399:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80139c:	89 c0                	mov    %eax,%eax
  80139e:	48 01 d0             	add    %rdx,%rax
  8013a1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013a4:	83 c2 08             	add    $0x8,%edx
  8013a7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8013aa:	eb 0f                	jmp    8013bb <vprintfmt+0x487>
				(uintptr_t) va_arg(aq, void *);
  8013ac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013b0:	48 89 d0             	mov    %rdx,%rax
  8013b3:	48 83 c2 08          	add    $0x8,%rdx
  8013b7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013bb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8013be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8013c2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8013c9:	eb 23                	jmp    8013ee <vprintfmt+0x4ba>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8013cb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8013cf:	be 03 00 00 00       	mov    $0x3,%esi
  8013d4:	48 89 c7             	mov    %rax,%rdi
  8013d7:	48 b8 14 0d 80 00 00 	movabs $0x800d14,%rax
  8013de:	00 00 00 
  8013e1:	ff d0                	callq  *%rax
  8013e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8013e7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8013ee:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8013f3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8013f6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8013f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013fd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801401:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801405:	45 89 c1             	mov    %r8d,%r9d
  801408:	41 89 f8             	mov    %edi,%r8d
  80140b:	48 89 c7             	mov    %rax,%rdi
  80140e:	48 b8 5c 0c 80 00 00 	movabs $0x800c5c,%rax
  801415:	00 00 00 
  801418:	ff d0                	callq  *%rax
			break;
  80141a:	eb 3f                	jmp    80145b <vprintfmt+0x527>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80141c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801420:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801424:	48 89 c6             	mov    %rax,%rsi
  801427:	89 df                	mov    %ebx,%edi
  801429:	ff d2                	callq  *%rdx
			break;
  80142b:	eb 2e                	jmp    80145b <vprintfmt+0x527>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80142d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801431:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801435:	48 89 c6             	mov    %rax,%rsi
  801438:	bf 25 00 00 00       	mov    $0x25,%edi
  80143d:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  80143f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801444:	eb 05                	jmp    80144b <vprintfmt+0x517>
  801446:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80144b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80144f:	48 83 e8 01          	sub    $0x1,%rax
  801453:	0f b6 00             	movzbl (%rax),%eax
  801456:	3c 25                	cmp    $0x25,%al
  801458:	75 ec                	jne    801446 <vprintfmt+0x512>
				/* do nothing */;
			break;
  80145a:	90                   	nop
		}
	}
  80145b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80145c:	e9 25 fb ff ff       	jmpq   800f86 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801461:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801462:	48 83 c4 60          	add    $0x60,%rsp
  801466:	5b                   	pop    %rbx
  801467:	41 5c                	pop    %r12
  801469:	5d                   	pop    %rbp
  80146a:	c3                   	retq   

000000000080146b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80146b:	55                   	push   %rbp
  80146c:	48 89 e5             	mov    %rsp,%rbp
  80146f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801476:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80147d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801484:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80148b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801492:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801499:	84 c0                	test   %al,%al
  80149b:	74 20                	je     8014bd <printfmt+0x52>
  80149d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8014a1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8014a5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8014a9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8014ad:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8014b1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8014b5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014b9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014bd:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8014c4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8014cb:	00 00 00 
  8014ce:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8014d5:	00 00 00 
  8014d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014dc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8014e3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014ea:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8014f1:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8014f8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8014ff:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801506:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80150d:	48 89 c7             	mov    %rax,%rdi
  801510:	48 b8 34 0f 80 00 00 	movabs $0x800f34,%rax
  801517:	00 00 00 
  80151a:	ff d0                	callq  *%rax
	va_end(ap);
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 10          	sub    $0x10,%rsp
  801526:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801529:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80152d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801531:	8b 40 10             	mov    0x10(%rax),%eax
  801534:	8d 50 01             	lea    0x1(%rax),%edx
  801537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80153e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801542:	48 8b 10             	mov    (%rax),%rdx
  801545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801549:	48 8b 40 08          	mov    0x8(%rax),%rax
  80154d:	48 39 c2             	cmp    %rax,%rdx
  801550:	73 17                	jae    801569 <sprintputch+0x4b>
		*b->buf++ = ch;
  801552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801556:	48 8b 00             	mov    (%rax),%rax
  801559:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80155c:	88 10                	mov    %dl,(%rax)
  80155e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801566:	48 89 10             	mov    %rdx,(%rax)
}
  801569:	c9                   	leaveq 
  80156a:	c3                   	retq   

000000000080156b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80156b:	55                   	push   %rbp
  80156c:	48 89 e5             	mov    %rsp,%rbp
  80156f:	48 83 ec 50          	sub    $0x50,%rsp
  801573:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801577:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80157a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80157e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801582:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801586:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80158a:	48 8b 0a             	mov    (%rdx),%rcx
  80158d:	48 89 08             	mov    %rcx,(%rax)
  801590:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801594:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801598:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80159c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015a0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8015a4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8015a8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8015ab:	48 98                	cltq   
  8015ad:	48 83 e8 01          	sub    $0x1,%rax
  8015b1:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8015b5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8015b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8015c0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8015c5:	74 06                	je     8015cd <vsnprintf+0x62>
  8015c7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8015cb:	7f 07                	jg     8015d4 <vsnprintf+0x69>
		return -E_INVAL;
  8015cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d2:	eb 2f                	jmp    801603 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8015d4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8015d8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8015dc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015e0:	48 89 c6             	mov    %rax,%rsi
  8015e3:	48 bf 1e 15 80 00 00 	movabs $0x80151e,%rdi
  8015ea:	00 00 00 
  8015ed:	48 b8 34 0f 80 00 00 	movabs $0x800f34,%rax
  8015f4:	00 00 00 
  8015f7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8015f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015fd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801600:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801603:	c9                   	leaveq 
  801604:	c3                   	retq   

0000000000801605 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801605:	55                   	push   %rbp
  801606:	48 89 e5             	mov    %rsp,%rbp
  801609:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801610:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801617:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80161d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801624:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80162b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801632:	84 c0                	test   %al,%al
  801634:	74 20                	je     801656 <snprintf+0x51>
  801636:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80163a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80163e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801642:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801646:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80164a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80164e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801652:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801656:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80165d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801664:	00 00 00 
  801667:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80166e:	00 00 00 
  801671:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801675:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80167c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801683:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80168a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801691:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801698:	48 8b 0a             	mov    (%rdx),%rcx
  80169b:	48 89 08             	mov    %rcx,(%rax)
  80169e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8016a2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8016a6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8016aa:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8016ae:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8016b5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8016bc:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8016c2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8016c9:	48 89 c7             	mov    %rax,%rdi
  8016cc:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8016d3:	00 00 00 
  8016d6:	ff d0                	callq  *%rax
  8016d8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8016de:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8016e4:	c9                   	leaveq 
  8016e5:	c3                   	retq   
	...

00000000008016e8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016e8:	55                   	push   %rbp
  8016e9:	48 89 e5             	mov    %rsp,%rbp
  8016ec:	48 83 ec 18          	sub    $0x18,%rsp
  8016f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8016f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016fb:	eb 09                	jmp    801706 <strlen+0x1e>
		n++;
  8016fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801701:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80170a:	0f b6 00             	movzbl (%rax),%eax
  80170d:	84 c0                	test   %al,%al
  80170f:	75 ec                	jne    8016fd <strlen+0x15>
		n++;
	return n;
  801711:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801714:	c9                   	leaveq 
  801715:	c3                   	retq   

0000000000801716 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801716:	55                   	push   %rbp
  801717:	48 89 e5             	mov    %rsp,%rbp
  80171a:	48 83 ec 20          	sub    $0x20,%rsp
  80171e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801722:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801726:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80172d:	eb 0e                	jmp    80173d <strnlen+0x27>
		n++;
  80172f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801733:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801738:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80173d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801742:	74 0b                	je     80174f <strnlen+0x39>
  801744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801748:	0f b6 00             	movzbl (%rax),%eax
  80174b:	84 c0                	test   %al,%al
  80174d:	75 e0                	jne    80172f <strnlen+0x19>
		n++;
	return n;
  80174f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801752:	c9                   	leaveq 
  801753:	c3                   	retq   

0000000000801754 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801754:	55                   	push   %rbp
  801755:	48 89 e5             	mov    %rsp,%rbp
  801758:	48 83 ec 20          	sub    $0x20,%rsp
  80175c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801760:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801768:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80176c:	90                   	nop
  80176d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801771:	0f b6 10             	movzbl (%rax),%edx
  801774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801778:	88 10                	mov    %dl,(%rax)
  80177a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177e:	0f b6 00             	movzbl (%rax),%eax
  801781:	84 c0                	test   %al,%al
  801783:	0f 95 c0             	setne  %al
  801786:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80178b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801790:	84 c0                	test   %al,%al
  801792:	75 d9                	jne    80176d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801794:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801798:	c9                   	leaveq 
  801799:	c3                   	retq   

000000000080179a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80179a:	55                   	push   %rbp
  80179b:	48 89 e5             	mov    %rsp,%rbp
  80179e:	48 83 ec 20          	sub    $0x20,%rsp
  8017a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8017aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ae:	48 89 c7             	mov    %rax,%rdi
  8017b1:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  8017b8:	00 00 00 
  8017bb:	ff d0                	callq  *%rax
  8017bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8017c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017c3:	48 98                	cltq   
  8017c5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8017c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017cd:	48 89 d6             	mov    %rdx,%rsi
  8017d0:	48 89 c7             	mov    %rax,%rdi
  8017d3:	48 b8 54 17 80 00 00 	movabs $0x801754,%rax
  8017da:	00 00 00 
  8017dd:	ff d0                	callq  *%rax
	return dst;
  8017df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017e3:	c9                   	leaveq 
  8017e4:	c3                   	retq   

00000000008017e5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8017e5:	55                   	push   %rbp
  8017e6:	48 89 e5             	mov    %rsp,%rbp
  8017e9:	48 83 ec 28          	sub    $0x28,%rsp
  8017ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8017f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801801:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801808:	00 
  801809:	eb 27                	jmp    801832 <strncpy+0x4d>
		*dst++ = *src;
  80180b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80180f:	0f b6 10             	movzbl (%rax),%edx
  801812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801816:	88 10                	mov    %dl,(%rax)
  801818:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80181d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801821:	0f b6 00             	movzbl (%rax),%eax
  801824:	84 c0                	test   %al,%al
  801826:	74 05                	je     80182d <strncpy+0x48>
			src++;
  801828:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80182d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801832:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801836:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80183a:	72 cf                	jb     80180b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80183c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801840:	c9                   	leaveq 
  801841:	c3                   	retq   

0000000000801842 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801842:	55                   	push   %rbp
  801843:	48 89 e5             	mov    %rsp,%rbp
  801846:	48 83 ec 28          	sub    $0x28,%rsp
  80184a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80184e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801852:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80185a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80185e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801863:	74 37                	je     80189c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801865:	eb 17                	jmp    80187e <strlcpy+0x3c>
			*dst++ = *src++;
  801867:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80186b:	0f b6 10             	movzbl (%rax),%edx
  80186e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801872:	88 10                	mov    %dl,(%rax)
  801874:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801879:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80187e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801883:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801888:	74 0b                	je     801895 <strlcpy+0x53>
  80188a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80188e:	0f b6 00             	movzbl (%rax),%eax
  801891:	84 c0                	test   %al,%al
  801893:	75 d2                	jne    801867 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801899:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80189c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a4:	48 89 d1             	mov    %rdx,%rcx
  8018a7:	48 29 c1             	sub    %rax,%rcx
  8018aa:	48 89 c8             	mov    %rcx,%rax
}
  8018ad:	c9                   	leaveq 
  8018ae:	c3                   	retq   

00000000008018af <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018af:	55                   	push   %rbp
  8018b0:	48 89 e5             	mov    %rsp,%rbp
  8018b3:	48 83 ec 10          	sub    $0x10,%rsp
  8018b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8018bf:	eb 0a                	jmp    8018cb <strcmp+0x1c>
		p++, q++;
  8018c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018c6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8018cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018cf:	0f b6 00             	movzbl (%rax),%eax
  8018d2:	84 c0                	test   %al,%al
  8018d4:	74 12                	je     8018e8 <strcmp+0x39>
  8018d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018da:	0f b6 10             	movzbl (%rax),%edx
  8018dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e1:	0f b6 00             	movzbl (%rax),%eax
  8018e4:	38 c2                	cmp    %al,%dl
  8018e6:	74 d9                	je     8018c1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ec:	0f b6 00             	movzbl (%rax),%eax
  8018ef:	0f b6 d0             	movzbl %al,%edx
  8018f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f6:	0f b6 00             	movzbl (%rax),%eax
  8018f9:	0f b6 c0             	movzbl %al,%eax
  8018fc:	89 d1                	mov    %edx,%ecx
  8018fe:	29 c1                	sub    %eax,%ecx
  801900:	89 c8                	mov    %ecx,%eax
}
  801902:	c9                   	leaveq 
  801903:	c3                   	retq   

0000000000801904 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801904:	55                   	push   %rbp
  801905:	48 89 e5             	mov    %rsp,%rbp
  801908:	48 83 ec 18          	sub    $0x18,%rsp
  80190c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801910:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801914:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801918:	eb 0f                	jmp    801929 <strncmp+0x25>
		n--, p++, q++;
  80191a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80191f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801924:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801929:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80192e:	74 1d                	je     80194d <strncmp+0x49>
  801930:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801934:	0f b6 00             	movzbl (%rax),%eax
  801937:	84 c0                	test   %al,%al
  801939:	74 12                	je     80194d <strncmp+0x49>
  80193b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80193f:	0f b6 10             	movzbl (%rax),%edx
  801942:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801946:	0f b6 00             	movzbl (%rax),%eax
  801949:	38 c2                	cmp    %al,%dl
  80194b:	74 cd                	je     80191a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80194d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801952:	75 07                	jne    80195b <strncmp+0x57>
		return 0;
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
  801959:	eb 1a                	jmp    801975 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80195b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195f:	0f b6 00             	movzbl (%rax),%eax
  801962:	0f b6 d0             	movzbl %al,%edx
  801965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801969:	0f b6 00             	movzbl (%rax),%eax
  80196c:	0f b6 c0             	movzbl %al,%eax
  80196f:	89 d1                	mov    %edx,%ecx
  801971:	29 c1                	sub    %eax,%ecx
  801973:	89 c8                	mov    %ecx,%eax
}
  801975:	c9                   	leaveq 
  801976:	c3                   	retq   

0000000000801977 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801977:	55                   	push   %rbp
  801978:	48 89 e5             	mov    %rsp,%rbp
  80197b:	48 83 ec 10          	sub    $0x10,%rsp
  80197f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801983:	89 f0                	mov    %esi,%eax
  801985:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801988:	eb 17                	jmp    8019a1 <strchr+0x2a>
		if (*s == c)
  80198a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198e:	0f b6 00             	movzbl (%rax),%eax
  801991:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801994:	75 06                	jne    80199c <strchr+0x25>
			return (char *) s;
  801996:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80199a:	eb 15                	jmp    8019b1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80199c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a5:	0f b6 00             	movzbl (%rax),%eax
  8019a8:	84 c0                	test   %al,%al
  8019aa:	75 de                	jne    80198a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8019ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b1:	c9                   	leaveq 
  8019b2:	c3                   	retq   

00000000008019b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
  8019b7:	48 83 ec 10          	sub    $0x10,%rsp
  8019bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019bf:	89 f0                	mov    %esi,%eax
  8019c1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8019c4:	eb 11                	jmp    8019d7 <strfind+0x24>
		if (*s == c)
  8019c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ca:	0f b6 00             	movzbl (%rax),%eax
  8019cd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8019d0:	74 12                	je     8019e4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019db:	0f b6 00             	movzbl (%rax),%eax
  8019de:	84 c0                	test   %al,%al
  8019e0:	75 e4                	jne    8019c6 <strfind+0x13>
  8019e2:	eb 01                	jmp    8019e5 <strfind+0x32>
		if (*s == c)
			break;
  8019e4:	90                   	nop
	return (char *) s;
  8019e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019e9:	c9                   	leaveq 
  8019ea:	c3                   	retq   

00000000008019eb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8019eb:	55                   	push   %rbp
  8019ec:	48 89 e5             	mov    %rsp,%rbp
  8019ef:	48 83 ec 18          	sub    $0x18,%rsp
  8019f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019f7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8019fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8019fe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a03:	75 06                	jne    801a0b <memset+0x20>
		return v;
  801a05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a09:	eb 69                	jmp    801a74 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0f:	83 e0 03             	and    $0x3,%eax
  801a12:	48 85 c0             	test   %rax,%rax
  801a15:	75 48                	jne    801a5f <memset+0x74>
  801a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a1b:	83 e0 03             	and    $0x3,%eax
  801a1e:	48 85 c0             	test   %rax,%rax
  801a21:	75 3c                	jne    801a5f <memset+0x74>
		c &= 0xFF;
  801a23:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801a2a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a2d:	89 c2                	mov    %eax,%edx
  801a2f:	c1 e2 18             	shl    $0x18,%edx
  801a32:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a35:	c1 e0 10             	shl    $0x10,%eax
  801a38:	09 c2                	or     %eax,%edx
  801a3a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a3d:	c1 e0 08             	shl    $0x8,%eax
  801a40:	09 d0                	or     %edx,%eax
  801a42:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801a45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a49:	48 89 c1             	mov    %rax,%rcx
  801a4c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801a50:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a54:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a57:	48 89 d7             	mov    %rdx,%rdi
  801a5a:	fc                   	cld    
  801a5b:	f3 ab                	rep stos %eax,%es:(%rdi)
  801a5d:	eb 11                	jmp    801a70 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801a5f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a63:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a66:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a6a:	48 89 d7             	mov    %rdx,%rdi
  801a6d:	fc                   	cld    
  801a6e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801a70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a74:	c9                   	leaveq 
  801a75:	c3                   	retq   

0000000000801a76 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801a76:	55                   	push   %rbp
  801a77:	48 89 e5             	mov    %rsp,%rbp
  801a7a:	48 83 ec 28          	sub    $0x28,%rsp
  801a7e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a86:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a8e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a96:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801aa2:	0f 83 88 00 00 00    	jae    801b30 <memmove+0xba>
  801aa8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ab0:	48 01 d0             	add    %rdx,%rax
  801ab3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801ab7:	76 77                	jbe    801b30 <memmove+0xba>
		s += n;
  801ab9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801ac1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ac9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801acd:	83 e0 03             	and    $0x3,%eax
  801ad0:	48 85 c0             	test   %rax,%rax
  801ad3:	75 3b                	jne    801b10 <memmove+0x9a>
  801ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad9:	83 e0 03             	and    $0x3,%eax
  801adc:	48 85 c0             	test   %rax,%rax
  801adf:	75 2f                	jne    801b10 <memmove+0x9a>
  801ae1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae5:	83 e0 03             	and    $0x3,%eax
  801ae8:	48 85 c0             	test   %rax,%rax
  801aeb:	75 23                	jne    801b10 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af1:	48 83 e8 04          	sub    $0x4,%rax
  801af5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801af9:	48 83 ea 04          	sub    $0x4,%rdx
  801afd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b01:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801b05:	48 89 c7             	mov    %rax,%rdi
  801b08:	48 89 d6             	mov    %rdx,%rsi
  801b0b:	fd                   	std    
  801b0c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b0e:	eb 1d                	jmp    801b2d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b14:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b24:	48 89 d7             	mov    %rdx,%rdi
  801b27:	48 89 c1             	mov    %rax,%rcx
  801b2a:	fd                   	std    
  801b2b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b2d:	fc                   	cld    
  801b2e:	eb 57                	jmp    801b87 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801b30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b34:	83 e0 03             	and    $0x3,%eax
  801b37:	48 85 c0             	test   %rax,%rax
  801b3a:	75 36                	jne    801b72 <memmove+0xfc>
  801b3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b40:	83 e0 03             	and    $0x3,%eax
  801b43:	48 85 c0             	test   %rax,%rax
  801b46:	75 2a                	jne    801b72 <memmove+0xfc>
  801b48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4c:	83 e0 03             	and    $0x3,%eax
  801b4f:	48 85 c0             	test   %rax,%rax
  801b52:	75 1e                	jne    801b72 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b58:	48 89 c1             	mov    %rax,%rcx
  801b5b:	48 c1 e9 02          	shr    $0x2,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b63:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b67:	48 89 c7             	mov    %rax,%rdi
  801b6a:	48 89 d6             	mov    %rdx,%rsi
  801b6d:	fc                   	cld    
  801b6e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b70:	eb 15                	jmp    801b87 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b76:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b7a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b7e:	48 89 c7             	mov    %rax,%rdi
  801b81:	48 89 d6             	mov    %rdx,%rsi
  801b84:	fc                   	cld    
  801b85:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b8b:	c9                   	leaveq 
  801b8c:	c3                   	retq   

0000000000801b8d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b8d:	55                   	push   %rbp
  801b8e:	48 89 e5             	mov    %rsp,%rbp
  801b91:	48 83 ec 18          	sub    $0x18,%rsp
  801b95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b99:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b9d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801ba1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ba5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ba9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bad:	48 89 ce             	mov    %rcx,%rsi
  801bb0:	48 89 c7             	mov    %rax,%rdi
  801bb3:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  801bba:	00 00 00 
  801bbd:	ff d0                	callq  *%rax
}
  801bbf:	c9                   	leaveq 
  801bc0:	c3                   	retq   

0000000000801bc1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801bc1:	55                   	push   %rbp
  801bc2:	48 89 e5             	mov    %rsp,%rbp
  801bc5:	48 83 ec 28          	sub    $0x28,%rsp
  801bc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801bd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801bdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801be1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801be5:	eb 38                	jmp    801c1f <memcmp+0x5e>
		if (*s1 != *s2)
  801be7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801beb:	0f b6 10             	movzbl (%rax),%edx
  801bee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bf2:	0f b6 00             	movzbl (%rax),%eax
  801bf5:	38 c2                	cmp    %al,%dl
  801bf7:	74 1c                	je     801c15 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801bf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bfd:	0f b6 00             	movzbl (%rax),%eax
  801c00:	0f b6 d0             	movzbl %al,%edx
  801c03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c07:	0f b6 00             	movzbl (%rax),%eax
  801c0a:	0f b6 c0             	movzbl %al,%eax
  801c0d:	89 d1                	mov    %edx,%ecx
  801c0f:	29 c1                	sub    %eax,%ecx
  801c11:	89 c8                	mov    %ecx,%eax
  801c13:	eb 20                	jmp    801c35 <memcmp+0x74>
		s1++, s2++;
  801c15:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c1a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c1f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c24:	0f 95 c0             	setne  %al
  801c27:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c2c:	84 c0                	test   %al,%al
  801c2e:	75 b7                	jne    801be7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c35:	c9                   	leaveq 
  801c36:	c3                   	retq   

0000000000801c37 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c37:	55                   	push   %rbp
  801c38:	48 89 e5             	mov    %rsp,%rbp
  801c3b:	48 83 ec 28          	sub    $0x28,%rsp
  801c3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c43:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801c46:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801c4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c52:	48 01 d0             	add    %rdx,%rax
  801c55:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801c59:	eb 13                	jmp    801c6e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5f:	0f b6 10             	movzbl (%rax),%edx
  801c62:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c65:	38 c2                	cmp    %al,%dl
  801c67:	74 11                	je     801c7a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c69:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801c6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c72:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801c76:	72 e3                	jb     801c5b <memfind+0x24>
  801c78:	eb 01                	jmp    801c7b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c7a:	90                   	nop
	return (void *) s;
  801c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c7f:	c9                   	leaveq 
  801c80:	c3                   	retq   

0000000000801c81 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c81:	55                   	push   %rbp
  801c82:	48 89 e5             	mov    %rsp,%rbp
  801c85:	48 83 ec 38          	sub    $0x38,%rsp
  801c89:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c91:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c9b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801ca2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ca3:	eb 05                	jmp    801caa <strtol+0x29>
		s++;
  801ca5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801caa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cae:	0f b6 00             	movzbl (%rax),%eax
  801cb1:	3c 20                	cmp    $0x20,%al
  801cb3:	74 f0                	je     801ca5 <strtol+0x24>
  801cb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb9:	0f b6 00             	movzbl (%rax),%eax
  801cbc:	3c 09                	cmp    $0x9,%al
  801cbe:	74 e5                	je     801ca5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801cc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc4:	0f b6 00             	movzbl (%rax),%eax
  801cc7:	3c 2b                	cmp    $0x2b,%al
  801cc9:	75 07                	jne    801cd2 <strtol+0x51>
		s++;
  801ccb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cd0:	eb 17                	jmp    801ce9 <strtol+0x68>
	else if (*s == '-')
  801cd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd6:	0f b6 00             	movzbl (%rax),%eax
  801cd9:	3c 2d                	cmp    $0x2d,%al
  801cdb:	75 0c                	jne    801ce9 <strtol+0x68>
		s++, neg = 1;
  801cdd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ce2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ce9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ced:	74 06                	je     801cf5 <strtol+0x74>
  801cef:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801cf3:	75 28                	jne    801d1d <strtol+0x9c>
  801cf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf9:	0f b6 00             	movzbl (%rax),%eax
  801cfc:	3c 30                	cmp    $0x30,%al
  801cfe:	75 1d                	jne    801d1d <strtol+0x9c>
  801d00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d04:	48 83 c0 01          	add    $0x1,%rax
  801d08:	0f b6 00             	movzbl (%rax),%eax
  801d0b:	3c 78                	cmp    $0x78,%al
  801d0d:	75 0e                	jne    801d1d <strtol+0x9c>
		s += 2, base = 16;
  801d0f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801d14:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801d1b:	eb 2c                	jmp    801d49 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801d1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d21:	75 19                	jne    801d3c <strtol+0xbb>
  801d23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d27:	0f b6 00             	movzbl (%rax),%eax
  801d2a:	3c 30                	cmp    $0x30,%al
  801d2c:	75 0e                	jne    801d3c <strtol+0xbb>
		s++, base = 8;
  801d2e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d33:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801d3a:	eb 0d                	jmp    801d49 <strtol+0xc8>
	else if (base == 0)
  801d3c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d40:	75 07                	jne    801d49 <strtol+0xc8>
		base = 10;
  801d42:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d4d:	0f b6 00             	movzbl (%rax),%eax
  801d50:	3c 2f                	cmp    $0x2f,%al
  801d52:	7e 1d                	jle    801d71 <strtol+0xf0>
  801d54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d58:	0f b6 00             	movzbl (%rax),%eax
  801d5b:	3c 39                	cmp    $0x39,%al
  801d5d:	7f 12                	jg     801d71 <strtol+0xf0>
			dig = *s - '0';
  801d5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d63:	0f b6 00             	movzbl (%rax),%eax
  801d66:	0f be c0             	movsbl %al,%eax
  801d69:	83 e8 30             	sub    $0x30,%eax
  801d6c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d6f:	eb 4e                	jmp    801dbf <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d75:	0f b6 00             	movzbl (%rax),%eax
  801d78:	3c 60                	cmp    $0x60,%al
  801d7a:	7e 1d                	jle    801d99 <strtol+0x118>
  801d7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d80:	0f b6 00             	movzbl (%rax),%eax
  801d83:	3c 7a                	cmp    $0x7a,%al
  801d85:	7f 12                	jg     801d99 <strtol+0x118>
			dig = *s - 'a' + 10;
  801d87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d8b:	0f b6 00             	movzbl (%rax),%eax
  801d8e:	0f be c0             	movsbl %al,%eax
  801d91:	83 e8 57             	sub    $0x57,%eax
  801d94:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d97:	eb 26                	jmp    801dbf <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d9d:	0f b6 00             	movzbl (%rax),%eax
  801da0:	3c 40                	cmp    $0x40,%al
  801da2:	7e 47                	jle    801deb <strtol+0x16a>
  801da4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801da8:	0f b6 00             	movzbl (%rax),%eax
  801dab:	3c 5a                	cmp    $0x5a,%al
  801dad:	7f 3c                	jg     801deb <strtol+0x16a>
			dig = *s - 'A' + 10;
  801daf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db3:	0f b6 00             	movzbl (%rax),%eax
  801db6:	0f be c0             	movsbl %al,%eax
  801db9:	83 e8 37             	sub    $0x37,%eax
  801dbc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801dbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dc2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801dc5:	7d 23                	jge    801dea <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801dc7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801dcc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801dcf:	48 98                	cltq   
  801dd1:	48 89 c2             	mov    %rax,%rdx
  801dd4:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801dd9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ddc:	48 98                	cltq   
  801dde:	48 01 d0             	add    %rdx,%rax
  801de1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801de5:	e9 5f ff ff ff       	jmpq   801d49 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801dea:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801deb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801df0:	74 0b                	je     801dfd <strtol+0x17c>
		*endptr = (char *) s;
  801df2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801df6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801dfa:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801dfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e01:	74 09                	je     801e0c <strtol+0x18b>
  801e03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e07:	48 f7 d8             	neg    %rax
  801e0a:	eb 04                	jmp    801e10 <strtol+0x18f>
  801e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801e10:	c9                   	leaveq 
  801e11:	c3                   	retq   

0000000000801e12 <strstr>:

char * strstr(const char *in, const char *str)
{
  801e12:	55                   	push   %rbp
  801e13:	48 89 e5             	mov    %rsp,%rbp
  801e16:	48 83 ec 30          	sub    $0x30,%rsp
  801e1a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e1e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801e22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e26:	0f b6 00             	movzbl (%rax),%eax
  801e29:	88 45 ff             	mov    %al,-0x1(%rbp)
  801e2c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	if (!c)
  801e31:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801e35:	75 06                	jne    801e3d <strstr+0x2b>
		return (char *) in;	// Trivial empty string case
  801e37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3b:	eb 68                	jmp    801ea5 <strstr+0x93>

	len = strlen(str);
  801e3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e41:	48 89 c7             	mov    %rax,%rdi
  801e44:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  801e4b:	00 00 00 
  801e4e:	ff d0                	callq  *%rax
  801e50:	48 98                	cltq   
  801e52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801e56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5a:	0f b6 00             	movzbl (%rax),%eax
  801e5d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801e60:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
			if (!sc)
  801e65:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801e69:	75 07                	jne    801e72 <strstr+0x60>
				return (char *) 0;
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e70:	eb 33                	jmp    801ea5 <strstr+0x93>
		} while (sc != c);
  801e72:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801e76:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801e79:	75 db                	jne    801e56 <strstr+0x44>
	} while (strncmp(in, str, len) != 0);
  801e7b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e7f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e87:	48 89 ce             	mov    %rcx,%rsi
  801e8a:	48 89 c7             	mov    %rax,%rdi
  801e8d:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  801e94:	00 00 00 
  801e97:	ff d0                	callq  *%rax
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	75 b9                	jne    801e56 <strstr+0x44>

	return (char *) (in - 1);
  801e9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea1:	48 83 e8 01          	sub    $0x1,%rax
}
  801ea5:	c9                   	leaveq 
  801ea6:	c3                   	retq   
	...

0000000000801ea8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ea8:	55                   	push   %rbp
  801ea9:	48 89 e5             	mov    %rsp,%rbp
  801eac:	53                   	push   %rbx
  801ead:	48 83 ec 58          	sub    $0x58,%rsp
  801eb1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801eb4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801eb7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ebb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801ebf:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801ec3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ec7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801eca:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801ecd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ed1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ed5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ed9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801edd:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801ee1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801ee4:	4c 89 c3             	mov    %r8,%rbx
  801ee7:	cd 30                	int    $0x30
  801ee9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801eed:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801ef1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801ef5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ef9:	74 3e                	je     801f39 <syscall+0x91>
  801efb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801f00:	7e 37                	jle    801f39 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801f02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f06:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f09:	49 89 d0             	mov    %rdx,%r8
  801f0c:	89 c1                	mov    %eax,%ecx
  801f0e:	48 ba c8 56 80 00 00 	movabs $0x8056c8,%rdx
  801f15:	00 00 00 
  801f18:	be 23 00 00 00       	mov    $0x23,%esi
  801f1d:	48 bf e5 56 80 00 00 	movabs $0x8056e5,%rdi
  801f24:	00 00 00 
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	49 b9 48 09 80 00 00 	movabs $0x800948,%r9
  801f33:	00 00 00 
  801f36:	41 ff d1             	callq  *%r9

	return ret;
  801f39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f3d:	48 83 c4 58          	add    $0x58,%rsp
  801f41:	5b                   	pop    %rbx
  801f42:	5d                   	pop    %rbp
  801f43:	c3                   	retq   

0000000000801f44 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801f44:	55                   	push   %rbp
  801f45:	48 89 e5             	mov    %rsp,%rbp
  801f48:	48 83 ec 20          	sub    $0x20,%rsp
  801f4c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f5c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f63:	00 
  801f64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f70:	48 89 d1             	mov    %rdx,%rcx
  801f73:	48 89 c2             	mov    %rax,%rdx
  801f76:	be 00 00 00 00       	mov    $0x0,%esi
  801f7b:	bf 00 00 00 00       	mov    $0x0,%edi
  801f80:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  801f87:	00 00 00 
  801f8a:	ff d0                	callq  *%rax
}
  801f8c:	c9                   	leaveq 
  801f8d:	c3                   	retq   

0000000000801f8e <sys_cgetc>:

int
sys_cgetc(void)
{
  801f8e:	55                   	push   %rbp
  801f8f:	48 89 e5             	mov    %rsp,%rbp
  801f92:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f96:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f9d:	00 
  801f9e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fa4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801faa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801faf:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb4:	be 00 00 00 00       	mov    $0x0,%esi
  801fb9:	bf 01 00 00 00       	mov    $0x1,%edi
  801fbe:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	callq  *%rax
}
  801fca:	c9                   	leaveq 
  801fcb:	c3                   	retq   

0000000000801fcc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801fcc:	55                   	push   %rbp
  801fcd:	48 89 e5             	mov    %rsp,%rbp
  801fd0:	48 83 ec 20          	sub    $0x20,%rsp
  801fd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fda:	48 98                	cltq   
  801fdc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fe3:	00 
  801fe4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ff5:	48 89 c2             	mov    %rax,%rdx
  801ff8:	be 01 00 00 00       	mov    $0x1,%esi
  801ffd:	bf 03 00 00 00       	mov    $0x3,%edi
  802002:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802009:	00 00 00 
  80200c:	ff d0                	callq  *%rax
}
  80200e:	c9                   	leaveq 
  80200f:	c3                   	retq   

0000000000802010 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802010:	55                   	push   %rbp
  802011:	48 89 e5             	mov    %rsp,%rbp
  802014:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802018:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80201f:	00 
  802020:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802026:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80202c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802031:	ba 00 00 00 00       	mov    $0x0,%edx
  802036:	be 00 00 00 00       	mov    $0x0,%esi
  80203b:	bf 02 00 00 00       	mov    $0x2,%edi
  802040:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802047:	00 00 00 
  80204a:	ff d0                	callq  *%rax
}
  80204c:	c9                   	leaveq 
  80204d:	c3                   	retq   

000000000080204e <sys_yield>:

void
sys_yield(void)
{
  80204e:	55                   	push   %rbp
  80204f:	48 89 e5             	mov    %rsp,%rbp
  802052:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802056:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80205d:	00 
  80205e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802064:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80206a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80206f:	ba 00 00 00 00       	mov    $0x0,%edx
  802074:	be 00 00 00 00       	mov    $0x0,%esi
  802079:	bf 0b 00 00 00       	mov    $0xb,%edi
  80207e:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802085:	00 00 00 
  802088:	ff d0                	callq  *%rax
}
  80208a:	c9                   	leaveq 
  80208b:	c3                   	retq   

000000000080208c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80208c:	55                   	push   %rbp
  80208d:	48 89 e5             	mov    %rsp,%rbp
  802090:	48 83 ec 20          	sub    $0x20,%rsp
  802094:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802097:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80209b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80209e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020a1:	48 63 c8             	movslq %eax,%rcx
  8020a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ab:	48 98                	cltq   
  8020ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020b4:	00 
  8020b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020bb:	49 89 c8             	mov    %rcx,%r8
  8020be:	48 89 d1             	mov    %rdx,%rcx
  8020c1:	48 89 c2             	mov    %rax,%rdx
  8020c4:	be 01 00 00 00       	mov    $0x1,%esi
  8020c9:	bf 04 00 00 00       	mov    $0x4,%edi
  8020ce:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  8020d5:	00 00 00 
  8020d8:	ff d0                	callq  *%rax
}
  8020da:	c9                   	leaveq 
  8020db:	c3                   	retq   

00000000008020dc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8020dc:	55                   	push   %rbp
  8020dd:	48 89 e5             	mov    %rsp,%rbp
  8020e0:	48 83 ec 30          	sub    $0x30,%rsp
  8020e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020eb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020ee:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020f2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8020f6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020f9:	48 63 c8             	movslq %eax,%rcx
  8020fc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802100:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802103:	48 63 f0             	movslq %eax,%rsi
  802106:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80210a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80210d:	48 98                	cltq   
  80210f:	48 89 0c 24          	mov    %rcx,(%rsp)
  802113:	49 89 f9             	mov    %rdi,%r9
  802116:	49 89 f0             	mov    %rsi,%r8
  802119:	48 89 d1             	mov    %rdx,%rcx
  80211c:	48 89 c2             	mov    %rax,%rdx
  80211f:	be 01 00 00 00       	mov    $0x1,%esi
  802124:	bf 05 00 00 00       	mov    $0x5,%edi
  802129:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802130:	00 00 00 
  802133:	ff d0                	callq  *%rax
}
  802135:	c9                   	leaveq 
  802136:	c3                   	retq   

0000000000802137 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802137:	55                   	push   %rbp
  802138:	48 89 e5             	mov    %rsp,%rbp
  80213b:	48 83 ec 20          	sub    $0x20,%rsp
  80213f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802142:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802146:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80214a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214d:	48 98                	cltq   
  80214f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802156:	00 
  802157:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80215d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802163:	48 89 d1             	mov    %rdx,%rcx
  802166:	48 89 c2             	mov    %rax,%rdx
  802169:	be 01 00 00 00       	mov    $0x1,%esi
  80216e:	bf 06 00 00 00       	mov    $0x6,%edi
  802173:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	callq  *%rax
}
  80217f:	c9                   	leaveq 
  802180:	c3                   	retq   

0000000000802181 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802181:	55                   	push   %rbp
  802182:	48 89 e5             	mov    %rsp,%rbp
  802185:	48 83 ec 20          	sub    $0x20,%rsp
  802189:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80218c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80218f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802192:	48 63 d0             	movslq %eax,%rdx
  802195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802198:	48 98                	cltq   
  80219a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021a1:	00 
  8021a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021ae:	48 89 d1             	mov    %rdx,%rcx
  8021b1:	48 89 c2             	mov    %rax,%rdx
  8021b4:	be 01 00 00 00       	mov    $0x1,%esi
  8021b9:	bf 08 00 00 00       	mov    $0x8,%edi
  8021be:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  8021c5:	00 00 00 
  8021c8:	ff d0                	callq  *%rax
}
  8021ca:	c9                   	leaveq 
  8021cb:	c3                   	retq   

00000000008021cc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8021cc:	55                   	push   %rbp
  8021cd:	48 89 e5             	mov    %rsp,%rbp
  8021d0:	48 83 ec 20          	sub    $0x20,%rsp
  8021d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8021db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e2:	48 98                	cltq   
  8021e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021eb:	00 
  8021ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021f8:	48 89 d1             	mov    %rdx,%rcx
  8021fb:	48 89 c2             	mov    %rax,%rdx
  8021fe:	be 01 00 00 00       	mov    $0x1,%esi
  802203:	bf 09 00 00 00       	mov    $0x9,%edi
  802208:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80220f:	00 00 00 
  802212:	ff d0                	callq  *%rax
}
  802214:	c9                   	leaveq 
  802215:	c3                   	retq   

0000000000802216 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802216:	55                   	push   %rbp
  802217:	48 89 e5             	mov    %rsp,%rbp
  80221a:	48 83 ec 20          	sub    $0x20,%rsp
  80221e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802221:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802225:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802229:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222c:	48 98                	cltq   
  80222e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802235:	00 
  802236:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80223c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802242:	48 89 d1             	mov    %rdx,%rcx
  802245:	48 89 c2             	mov    %rax,%rdx
  802248:	be 01 00 00 00       	mov    $0x1,%esi
  80224d:	bf 0a 00 00 00       	mov    $0xa,%edi
  802252:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802259:	00 00 00 
  80225c:	ff d0                	callq  *%rax
}
  80225e:	c9                   	leaveq 
  80225f:	c3                   	retq   

0000000000802260 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802260:	55                   	push   %rbp
  802261:	48 89 e5             	mov    %rsp,%rbp
  802264:	48 83 ec 30          	sub    $0x30,%rsp
  802268:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80226b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80226f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802273:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802276:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802279:	48 63 f0             	movslq %eax,%rsi
  80227c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802280:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802283:	48 98                	cltq   
  802285:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802289:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802290:	00 
  802291:	49 89 f1             	mov    %rsi,%r9
  802294:	49 89 c8             	mov    %rcx,%r8
  802297:	48 89 d1             	mov    %rdx,%rcx
  80229a:	48 89 c2             	mov    %rax,%rdx
  80229d:	be 00 00 00 00       	mov    $0x0,%esi
  8022a2:	bf 0c 00 00 00       	mov    $0xc,%edi
  8022a7:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  8022ae:	00 00 00 
  8022b1:	ff d0                	callq  *%rax
}
  8022b3:	c9                   	leaveq 
  8022b4:	c3                   	retq   

00000000008022b5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8022b5:	55                   	push   %rbp
  8022b6:	48 89 e5             	mov    %rsp,%rbp
  8022b9:	48 83 ec 20          	sub    $0x20,%rsp
  8022bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8022c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022cc:	00 
  8022cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022de:	48 89 c2             	mov    %rax,%rdx
  8022e1:	be 01 00 00 00       	mov    $0x1,%esi
  8022e6:	bf 0d 00 00 00       	mov    $0xd,%edi
  8022eb:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  8022f2:	00 00 00 
  8022f5:	ff d0                	callq  *%rax
}
  8022f7:	c9                   	leaveq 
  8022f8:	c3                   	retq   

00000000008022f9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8022f9:	55                   	push   %rbp
  8022fa:	48 89 e5             	mov    %rsp,%rbp
  8022fd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802301:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802308:	00 
  802309:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80230f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802315:	b9 00 00 00 00       	mov    $0x0,%ecx
  80231a:	ba 00 00 00 00       	mov    $0x0,%edx
  80231f:	be 00 00 00 00       	mov    $0x0,%esi
  802324:	bf 0e 00 00 00       	mov    $0xe,%edi
  802329:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802330:	00 00 00 
  802333:	ff d0                	callq  *%rax
}
  802335:	c9                   	leaveq 
  802336:	c3                   	retq   

0000000000802337 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802337:	55                   	push   %rbp
  802338:	48 89 e5             	mov    %rsp,%rbp
  80233b:	48 83 ec 30          	sub    $0x30,%rsp
  80233f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802342:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802346:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802349:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80234d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802351:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802354:	48 63 c8             	movslq %eax,%rcx
  802357:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80235b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80235e:	48 63 f0             	movslq %eax,%rsi
  802361:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802368:	48 98                	cltq   
  80236a:	48 89 0c 24          	mov    %rcx,(%rsp)
  80236e:	49 89 f9             	mov    %rdi,%r9
  802371:	49 89 f0             	mov    %rsi,%r8
  802374:	48 89 d1             	mov    %rdx,%rcx
  802377:	48 89 c2             	mov    %rax,%rdx
  80237a:	be 00 00 00 00       	mov    $0x0,%esi
  80237f:	bf 0f 00 00 00       	mov    $0xf,%edi
  802384:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80238b:	00 00 00 
  80238e:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802390:	c9                   	leaveq 
  802391:	c3                   	retq   

0000000000802392 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802392:	55                   	push   %rbp
  802393:	48 89 e5             	mov    %rsp,%rbp
  802396:	48 83 ec 20          	sub    $0x20,%rsp
  80239a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80239e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8023a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023b1:	00 
  8023b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023be:	48 89 d1             	mov    %rdx,%rcx
  8023c1:	48 89 c2             	mov    %rax,%rdx
  8023c4:	be 00 00 00 00       	mov    $0x0,%esi
  8023c9:	bf 10 00 00 00       	mov    $0x10,%edi
  8023ce:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  8023d5:	00 00 00 
  8023d8:	ff d0                	callq  *%rax
}
  8023da:	c9                   	leaveq 
  8023db:	c3                   	retq   

00000000008023dc <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8023dc:	55                   	push   %rbp
  8023dd:	48 89 e5             	mov    %rsp,%rbp
  8023e0:	48 83 ec 40          	sub    $0x40,%rsp
  8023e4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8023e8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8023ec:	48 8b 00             	mov    (%rax),%rax
  8023ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  8023f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8023f7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023fb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	pte_t entry = uvpt[VPN(addr)];
  8023fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802402:	48 89 c2             	mov    %rax,%rdx
  802405:	48 c1 ea 0c          	shr    $0xc,%rdx
  802409:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802410:	01 00 00 
  802413:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802417:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)) {
  80241b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80241e:	83 e0 02             	and    $0x2,%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	0f 84 4f 01 00 00    	je     802578 <pgfault+0x19c>
  802429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242d:	48 89 c2             	mov    %rax,%rdx
  802430:	48 c1 ea 0c          	shr    $0xc,%rdx
  802434:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80243b:	01 00 00 
  80243e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802442:	25 00 08 00 00       	and    $0x800,%eax
  802447:	48 85 c0             	test   %rax,%rax
  80244a:	0f 84 28 01 00 00    	je     802578 <pgfault+0x19c>
		if(sys_page_alloc(0, (void*)PFTEMP, PTE_U|PTE_P|PTE_W) == 0) {
  802450:	ba 07 00 00 00       	mov    $0x7,%edx
  802455:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80245a:	bf 00 00 00 00       	mov    $0x0,%edi
  80245f:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  802466:	00 00 00 
  802469:	ff d0                	callq  *%rax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	0f 85 db 00 00 00    	jne    80254e <pgfault+0x172>
			void *pg_addr = ROUNDDOWN(addr, PGSIZE);
  802473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802477:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80247b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802485:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			memmove(PFTEMP, pg_addr, PGSIZE);
  802489:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80248d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802492:	48 89 c6             	mov    %rax,%rsi
  802495:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80249a:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  8024a1:	00 00 00 
  8024a4:	ff d0                	callq  *%rax
			r = sys_page_map(0, (void*)PFTEMP, 0, pg_addr, PTE_U|PTE_W|PTE_P);
  8024a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024aa:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8024b0:	48 89 c1             	mov    %rax,%rcx
  8024b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c2:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  8024c9:	00 00 00 
  8024cc:	ff d0                	callq  *%rax
  8024ce:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  8024d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8024d5:	79 2a                	jns    802501 <pgfault+0x125>
				panic("pgfault...something wrong with page_map");
  8024d7:	48 ba f8 56 80 00 00 	movabs $0x8056f8,%rdx
  8024de:	00 00 00 
  8024e1:	be 28 00 00 00       	mov    $0x28,%esi
  8024e6:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  8024ed:	00 00 00 
  8024f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f5:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  8024fc:	00 00 00 
  8024ff:	ff d1                	callq  *%rcx
			}
			r = sys_page_unmap(0, PFTEMP);
  802501:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802506:	bf 00 00 00 00       	mov    $0x0,%edi
  80250b:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  802512:	00 00 00 
  802515:	ff d0                	callq  *%rax
  802517:	89 45 d4             	mov    %eax,-0x2c(%rbp)
			if (r < 0) {
  80251a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80251e:	0f 89 84 00 00 00    	jns    8025a8 <pgfault+0x1cc>
				panic("pgfault...something wrong with page_unmap");
  802524:	48 ba 30 57 80 00 00 	movabs $0x805730,%rdx
  80252b:	00 00 00 
  80252e:	be 2c 00 00 00       	mov    $0x2c,%esi
  802533:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  80253a:	00 00 00 
  80253d:	b8 00 00 00 00       	mov    $0x0,%eax
  802542:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  802549:	00 00 00 
  80254c:	ff d1                	callq  *%rcx
			}
			return;
		}
		else {
			panic("pgfault...something wrong with page_alloc");
  80254e:	48 ba 60 57 80 00 00 	movabs $0x805760,%rdx
  802555:	00 00 00 
  802558:	be 31 00 00 00       	mov    $0x31,%esi
  80255d:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  802564:	00 00 00 
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
  80256c:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  802573:	00 00 00 
  802576:	ff d1                	callq  *%rcx
		}
	}
	else {
			panic("pgfault...wrong error %e", err);	
  802578:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80257b:	89 c1                	mov    %eax,%ecx
  80257d:	48 ba 8a 57 80 00 00 	movabs $0x80578a,%rdx
  802584:	00 00 00 
  802587:	be 35 00 00 00       	mov    $0x35,%esi
  80258c:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  802593:	00 00 00 
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
  80259b:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8025a2:	00 00 00 
  8025a5:	41 ff d0             	callq  *%r8
			}
			r = sys_page_unmap(0, PFTEMP);
			if (r < 0) {
				panic("pgfault...something wrong with page_unmap");
			}
			return;
  8025a8:	90                   	nop
	}
	else {
			panic("pgfault...wrong error %e", err);	
	}
	// LAB 4: Your code here.
}
  8025a9:	c9                   	leaveq 
  8025aa:	c3                   	retq   

00000000008025ab <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8025ab:	55                   	push   %rbp
  8025ac:	48 89 e5             	mov    %rsp,%rbp
  8025af:	48 83 ec 30          	sub    $0x30,%rsp
  8025b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025b6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	pte_t entry = uvpt[pn];
  8025b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025c0:	01 00 00 
  8025c3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8025c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	void* addr = (void*) ((uintptr_t)pn * PGSIZE);
  8025ce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8025d1:	48 c1 e0 0c          	shl    $0xc,%rax
  8025d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int perm = entry & PTE_SYSCALL;
  8025d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8025e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if(perm& PTE_SHARE) {
  8025e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025e8:	25 00 04 00 00       	and    $0x400,%eax
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	74 62                	je     802653 <duppage+0xa8>
		r = sys_page_map(0, addr, envid, addr, perm);
  8025f1:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8025f4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025f8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ff:	41 89 f0             	mov    %esi,%r8d
  802602:	48 89 c6             	mov    %rax,%rsi
  802605:	bf 00 00 00 00       	mov    $0x0,%edi
  80260a:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  802611:	00 00 00 
  802614:	ff d0                	callq  *%rax
  802616:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802619:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80261d:	0f 89 78 01 00 00    	jns    80279b <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  802623:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802626:	89 c1                	mov    %eax,%ecx
  802628:	48 ba a8 57 80 00 00 	movabs $0x8057a8,%rdx
  80262f:	00 00 00 
  802632:	be 4f 00 00 00       	mov    $0x4f,%esi
  802637:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  80263e:	00 00 00 
  802641:	b8 00 00 00 00       	mov    $0x0,%eax
  802646:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  80264d:	00 00 00 
  802650:	41 ff d0             	callq  *%r8
		}
	}
	else if((perm & PTE_COW) || (perm & PTE_W)) {
  802653:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802656:	25 00 08 00 00       	and    $0x800,%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	75 0e                	jne    80266d <duppage+0xc2>
  80265f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802662:	83 e0 02             	and    $0x2,%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	0f 84 d0 00 00 00    	je     80273d <duppage+0x192>
		perm &= ~PTE_W;
  80266d:	83 65 ec fd          	andl   $0xfffffffd,-0x14(%rbp)
		perm |= PTE_COW;
  802671:	81 4d ec 00 08 00 00 	orl    $0x800,-0x14(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm);
  802678:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80267b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80267f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802682:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802686:	41 89 f0             	mov    %esi,%r8d
  802689:	48 89 c6             	mov    %rax,%rsi
  80268c:	bf 00 00 00 00       	mov    $0x0,%edi
  802691:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  802698:	00 00 00 
  80269b:	ff d0                	callq  *%rax
  80269d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  8026a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8026a4:	79 30                	jns    8026d6 <duppage+0x12b>
			panic("Something went wrong on duppage %e",r);
  8026a6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8026a9:	89 c1                	mov    %eax,%ecx
  8026ab:	48 ba a8 57 80 00 00 	movabs $0x8057a8,%rdx
  8026b2:	00 00 00 
  8026b5:	be 57 00 00 00       	mov    $0x57,%esi
  8026ba:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  8026c1:	00 00 00 
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8026d0:	00 00 00 
  8026d3:	41 ff d0             	callq  *%r8
		}
		r = sys_page_map(0, addr, 0, addr, perm);
  8026d6:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  8026d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e1:	41 89 c8             	mov    %ecx,%r8d
  8026e4:	48 89 d1             	mov    %rdx,%rcx
  8026e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ec:	48 89 c6             	mov    %rax,%rsi
  8026ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f4:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  8026fb:	00 00 00 
  8026fe:	ff d0                	callq  *%rax
  802700:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802703:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802707:	0f 89 8e 00 00 00    	jns    80279b <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  80270d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802710:	89 c1                	mov    %eax,%ecx
  802712:	48 ba a8 57 80 00 00 	movabs $0x8057a8,%rdx
  802719:	00 00 00 
  80271c:	be 5b 00 00 00       	mov    $0x5b,%esi
  802721:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  802728:	00 00 00 
  80272b:	b8 00 00 00 00       	mov    $0x0,%eax
  802730:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  802737:	00 00 00 
  80273a:	41 ff d0             	callq  *%r8
		}
	}
	else {
		r = sys_page_map(0, addr, envid, addr, perm);
  80273d:	8b 75 ec             	mov    -0x14(%rbp),%esi
  802740:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802744:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274b:	41 89 f0             	mov    %esi,%r8d
  80274e:	48 89 c6             	mov    %rax,%rsi
  802751:	bf 00 00 00 00       	mov    $0x0,%edi
  802756:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  80275d:	00 00 00 
  802760:	ff d0                	callq  *%rax
  802762:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r < 0) {
  802765:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802769:	79 30                	jns    80279b <duppage+0x1f0>
			panic("Something went wrong on duppage %e",r);
  80276b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80276e:	89 c1                	mov    %eax,%ecx
  802770:	48 ba a8 57 80 00 00 	movabs $0x8057a8,%rdx
  802777:	00 00 00 
  80277a:	be 61 00 00 00       	mov    $0x61,%esi
  80277f:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  802786:	00 00 00 
  802789:	b8 00 00 00 00       	mov    $0x0,%eax
  80278e:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  802795:	00 00 00 
  802798:	41 ff d0             	callq  *%r8
		}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a0:	c9                   	leaveq 
  8027a1:	c3                   	retq   

00000000008027a2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8027a2:	55                   	push   %rbp
  8027a3:	48 89 e5             	mov    %rsp,%rbp
  8027a6:	53                   	push   %rbx
  8027a7:	48 83 ec 68          	sub    $0x68,%rsp
	int r=0;
  8027ab:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
	set_pgfault_handler(pgfault);
  8027b2:	48 bf dc 23 80 00 00 	movabs $0x8023dc,%rdi
  8027b9:	00 00 00 
  8027bc:	48 b8 14 4a 80 00 00 	movabs $0x804a14,%rax
  8027c3:	00 00 00 
  8027c6:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8027c8:	c7 45 9c 07 00 00 00 	movl   $0x7,-0x64(%rbp)
  8027cf:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8027d2:	cd 30                	int    $0x30
  8027d4:	89 c3                	mov    %eax,%ebx
  8027d6:	89 5d ac             	mov    %ebx,-0x54(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8027d9:	8b 45 ac             	mov    -0x54(%rbp),%eax
	envid_t childid = sys_exofork();
  8027dc:	89 45 b0             	mov    %eax,-0x50(%rbp)
	if(childid < 0) {
  8027df:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  8027e3:	79 30                	jns    802815 <fork+0x73>
		panic("\n couldn't call fork %e\n",childid);
  8027e5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8027e8:	89 c1                	mov    %eax,%ecx
  8027ea:	48 ba cb 57 80 00 00 	movabs $0x8057cb,%rdx
  8027f1:	00 00 00 
  8027f4:	be 80 00 00 00       	mov    $0x80,%esi
  8027f9:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  802800:	00 00 00 
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  80280f:	00 00 00 
  802812:	41 ff d0             	callq  *%r8
	}
	if(childid == 0) {
  802815:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  802819:	75 52                	jne    80286d <fork+0xcb>
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
  80281b:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  802822:	00 00 00 
  802825:	ff d0                	callq  *%rax
  802827:	48 98                	cltq   
  802829:	48 89 c2             	mov    %rax,%rdx
  80282c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802832:	48 89 d0             	mov    %rdx,%rax
  802835:	48 c1 e0 02          	shl    $0x2,%rax
  802839:	48 01 d0             	add    %rdx,%rax
  80283c:	48 01 c0             	add    %rax,%rax
  80283f:	48 01 d0             	add    %rdx,%rax
  802842:	48 c1 e0 05          	shl    $0x5,%rax
  802846:	48 89 c2             	mov    %rax,%rdx
  802849:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802850:	00 00 00 
  802853:	48 01 c2             	add    %rax,%rdx
  802856:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80285d:	00 00 00 
  802860:	48 89 10             	mov    %rdx,(%rax)
		return 0; //this is for the child
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
  802868:	e9 9d 02 00 00       	jmpq   802b0a <fork+0x368>
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
  80286d:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802870:	ba 07 00 00 00       	mov    $0x7,%edx
  802875:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80287a:	89 c7                	mov    %eax,%edi
  80287c:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  802883:	00 00 00 
  802886:	ff d0                	callq  *%rax
  802888:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  80288b:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  80288f:	79 30                	jns    8028c1 <fork+0x11f>
		panic("\n couldn't call fork %e\n", r);
  802891:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802894:	89 c1                	mov    %eax,%ecx
  802896:	48 ba cb 57 80 00 00 	movabs $0x8057cb,%rdx
  80289d:	00 00 00 
  8028a0:	be 88 00 00 00       	mov    $0x88,%esi
  8028a5:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  8028ac:	00 00 00 
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b4:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8028bb:	00 00 00 
  8028be:	41 ff d0             	callq  *%r8
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
  8028c1:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8028c8:	00 
	uint64_t each_pte = 0;
  8028c9:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8028d0:	00 
	uint64_t each_pdpe = 0;
  8028d1:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  8028d8:	00 
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  8028d9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028e0:	00 
  8028e1:	e9 73 01 00 00       	jmpq   802a59 <fork+0x2b7>
		if(uvpml4e[pml] & PTE_P) {
  8028e6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8028ed:	01 00 00 
  8028f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f8:	83 e0 01             	and    $0x1,%eax
  8028fb:	84 c0                	test   %al,%al
  8028fd:	0f 84 41 01 00 00    	je     802a44 <fork+0x2a2>
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  802903:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80290a:	00 
  80290b:	e9 24 01 00 00       	jmpq   802a34 <fork+0x292>
				if(uvpde[each_pdpe] & PTE_P) {
  802910:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802917:	01 00 00 
  80291a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80291e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802922:	83 e0 01             	and    $0x1,%eax
  802925:	84 c0                	test   %al,%al
  802927:	0f 84 ed 00 00 00    	je     802a1a <fork+0x278>
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  80292d:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802934:	00 
  802935:	e9 d0 00 00 00       	jmpq   802a0a <fork+0x268>
						if(uvpd[each_pde] & PTE_P) {
  80293a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802941:	01 00 00 
  802944:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802948:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294c:	83 e0 01             	and    $0x1,%eax
  80294f:	84 c0                	test   %al,%al
  802951:	0f 84 99 00 00 00    	je     8029f0 <fork+0x24e>
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  802957:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80295e:	00 
  80295f:	eb 7f                	jmp    8029e0 <fork+0x23e>
								if(uvpt[each_pte] & PTE_P) {
  802961:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802968:	01 00 00 
  80296b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80296f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802973:	83 e0 01             	and    $0x1,%eax
  802976:	84 c0                	test   %al,%al
  802978:	74 5c                	je     8029d6 <fork+0x234>
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
  80297a:	48 81 7d c0 ff f7 0e 	cmpq   $0xef7ff,-0x40(%rbp)
  802981:	00 
  802982:	74 52                	je     8029d6 <fork+0x234>
										r = duppage(childid, (unsigned)each_pte);
  802984:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802988:	89 c2                	mov    %eax,%edx
  80298a:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80298d:	89 d6                	mov    %edx,%esi
  80298f:	89 c7                	mov    %eax,%edi
  802991:	48 b8 ab 25 80 00 00 	movabs $0x8025ab,%rax
  802998:	00 00 00 
  80299b:	ff d0                	callq  *%rax
  80299d:	89 45 b4             	mov    %eax,-0x4c(%rbp)
										if (r < 0)
  8029a0:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  8029a4:	79 30                	jns    8029d6 <fork+0x234>
											panic("\n couldn't call fork %e\n", r);
  8029a6:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8029a9:	89 c1                	mov    %eax,%ecx
  8029ab:	48 ba cb 57 80 00 00 	movabs $0x8057cb,%rdx
  8029b2:	00 00 00 
  8029b5:	be a0 00 00 00       	mov    $0xa0,%esi
  8029ba:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  8029c1:	00 00 00 
  8029c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c9:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8029d0:	00 00 00 
  8029d3:	41 ff d0             	callq  *%r8
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
  8029d6:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8029db:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  8029e0:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8029e7:	00 
  8029e8:	0f 86 73 ff ff ff    	jbe    802961 <fork+0x1bf>
  8029ee:	eb 10                	jmp    802a00 <fork+0x25e>
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
  8029f0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029f4:	48 83 c0 01          	add    $0x1,%rax
  8029f8:	48 c1 e0 09          	shl    $0x9,%rax
  8029fc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
  802a00:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802a05:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  802a0a:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  802a11:	00 
  802a12:	0f 86 22 ff ff ff    	jbe    80293a <fork+0x198>
  802a18:	eb 10                	jmp    802a2a <fork+0x288>

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
  802a1a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  802a1e:	48 83 c0 01          	add    $0x1,%rax
  802a22:	48 c1 e0 09          	shl    $0x9,%rax
  802a26:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
  802a2a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  802a2f:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  802a34:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  802a3b:	00 
  802a3c:	0f 86 ce fe ff ff    	jbe    802910 <fork+0x16e>
  802a42:	eb 10                	jmp    802a54 <fork+0x2b2>

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
  802a44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a48:	48 83 c0 01          	add    $0x1,%rax
  802a4c:	48 c1 e0 09          	shl    $0x9,%rax
  802a50:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
  802a54:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802a59:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a5e:	0f 84 82 fe ff ff    	je     8028e6 <fork+0x144>
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  802a64:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802a67:	48 be ac 4a 80 00 00 	movabs $0x804aac,%rsi
  802a6e:	00 00 00 
  802a71:	89 c7                	mov    %eax,%edi
  802a73:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  802a7a:	00 00 00 
  802a7d:	ff d0                	callq  *%rax
  802a7f:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802a82:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802a86:	79 30                	jns    802ab8 <fork+0x316>
		panic("\n couldn't call fork %e\n", r);
  802a88:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802a8b:	89 c1                	mov    %eax,%ecx
  802a8d:	48 ba cb 57 80 00 00 	movabs $0x8057cb,%rdx
  802a94:	00 00 00 
  802a97:	be bd 00 00 00       	mov    $0xbd,%esi
  802a9c:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  802aa3:	00 00 00 
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aab:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  802ab2:	00 00 00 
  802ab5:	41 ff d0             	callq  *%r8

	r = sys_env_set_status(childid, ENV_RUNNABLE);
  802ab8:	8b 45 b0             	mov    -0x50(%rbp),%eax
  802abb:	be 02 00 00 00       	mov    $0x2,%esi
  802ac0:	89 c7                	mov    %eax,%edi
  802ac2:	48 b8 81 21 80 00 00 	movabs $0x802181,%rax
  802ac9:	00 00 00 
  802acc:	ff d0                	callq  *%rax
  802ace:	89 45 b4             	mov    %eax,-0x4c(%rbp)
	if (r < 0)
  802ad1:	83 7d b4 00          	cmpl   $0x0,-0x4c(%rbp)
  802ad5:	79 30                	jns    802b07 <fork+0x365>
		panic("\n couldn't call fork %e\n", r);
  802ad7:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802ada:	89 c1                	mov    %eax,%ecx
  802adc:	48 ba cb 57 80 00 00 	movabs $0x8057cb,%rdx
  802ae3:	00 00 00 
  802ae6:	be c1 00 00 00       	mov    $0xc1,%esi
  802aeb:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  802af2:	00 00 00 
  802af5:	b8 00 00 00 00       	mov    $0x0,%eax
  802afa:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  802b01:	00 00 00 
  802b04:	41 ff d0             	callq  *%r8
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
  802b07:	8b 45 b0             	mov    -0x50(%rbp),%eax
}
  802b0a:	48 83 c4 68          	add    $0x68,%rsp
  802b0e:	5b                   	pop    %rbx
  802b0f:	5d                   	pop    %rbp
  802b10:	c3                   	retq   

0000000000802b11 <sfork>:

// Challenge!
int
sfork(void)
{
  802b11:	55                   	push   %rbp
  802b12:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802b15:	48 ba e4 57 80 00 00 	movabs $0x8057e4,%rdx
  802b1c:	00 00 00 
  802b1f:	be cc 00 00 00       	mov    $0xcc,%esi
  802b24:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  802b2b:	00 00 00 
  802b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b33:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  802b3a:	00 00 00 
  802b3d:	ff d1                	callq  *%rcx
	...

0000000000802b40 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b40:	55                   	push   %rbp
  802b41:	48 89 e5             	mov    %rsp,%rbp
  802b44:	48 83 ec 30          	sub    $0x30,%rsp
  802b48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b50:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r = 0;
  802b54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(pg) {
  802b5b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802b60:	74 18                	je     802b7a <ipc_recv+0x3a>
		r = sys_ipc_recv(pg);
  802b62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b66:	48 89 c7             	mov    %rax,%rdi
  802b69:	48 b8 b5 22 80 00 00 	movabs $0x8022b5,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	callq  *%rax
  802b75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b78:	eb 19                	jmp    802b93 <ipc_recv+0x53>
	}
	else {
		r = sys_ipc_recv((void*)KERNBASE);
  802b7a:	48 bf 00 00 00 04 80 	movabs $0x8004000000,%rdi
  802b81:	00 00 00 
  802b84:	48 b8 b5 22 80 00 00 	movabs $0x8022b5,%rax
  802b8b:	00 00 00 
  802b8e:	ff d0                	callq  *%rax
  802b90:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if (r < 0) {
  802b93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b97:	79 39                	jns    802bd2 <ipc_recv+0x92>
		*from_env_store =  (from_env_store != NULL) ? (envid_t)0 : *from_env_store;
  802b99:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802b9e:	75 08                	jne    802ba8 <ipc_recv+0x68>
  802ba0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba4:	8b 00                	mov    (%rax),%eax
  802ba6:	eb 05                	jmp    802bad <ipc_recv+0x6d>
  802ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bb1:	89 02                	mov    %eax,(%rdx)
		*perm_store = (perm_store != NULL) ? (int)0 : *perm_store;
  802bb3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802bb8:	75 08                	jne    802bc2 <ipc_recv+0x82>
  802bba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bbe:	8b 00                	mov    (%rax),%eax
  802bc0:	eb 05                	jmp    802bc7 <ipc_recv+0x87>
  802bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bcb:	89 02                	mov    %eax,(%rdx)
		return r;
  802bcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd0:	eb 53                	jmp    802c25 <ipc_recv+0xe5>
	}
	if(from_env_store) {
  802bd2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802bd7:	74 19                	je     802bf2 <ipc_recv+0xb2>
		*from_env_store = thisenv->env_ipc_from;
  802bd9:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802be0:	00 00 00 
  802be3:	48 8b 00             	mov    (%rax),%rax
  802be6:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802bec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf0:	89 10                	mov    %edx,(%rax)
	}
	if(perm_store) {
  802bf2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802bf7:	74 19                	je     802c12 <ipc_recv+0xd2>
		*perm_store = thisenv->env_ipc_perm;
  802bf9:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802c00:	00 00 00 
  802c03:	48 8b 00             	mov    (%rax),%rax
  802c06:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802c0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c10:	89 10                	mov    %edx,(%rax)
	}
	return thisenv->env_ipc_value;
  802c12:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802c19:	00 00 00 
  802c1c:	48 8b 00             	mov    (%rax),%rax
  802c1f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
}
  802c25:	c9                   	leaveq 
  802c26:	c3                   	retq   

0000000000802c27 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802c27:	55                   	push   %rbp
  802c28:	48 89 e5             	mov    %rsp,%rbp
  802c2b:	48 83 ec 30          	sub    $0x30,%rsp
  802c2f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c32:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802c35:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802c39:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r = -E_IPC_NOT_RECV;
  802c3c:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	while(r == -E_IPC_NOT_RECV) {
  802c43:	eb 59                	jmp    802c9e <ipc_send+0x77>
		if(pg) {
  802c45:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c4a:	74 20                	je     802c6c <ipc_send+0x45>
			r = sys_ipc_try_send(to_env,val,pg,perm);
  802c4c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802c4f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802c52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c59:	89 c7                	mov    %eax,%edi
  802c5b:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  802c62:	00 00 00 
  802c65:	ff d0                	callq  *%rax
  802c67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6a:	eb 26                	jmp    802c92 <ipc_send+0x6b>
		}
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
  802c6c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802c6f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c72:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c75:	89 d1                	mov    %edx,%ecx
  802c77:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  802c7e:	00 00 00 
  802c81:	89 c7                	mov    %eax,%edi
  802c83:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
  802c8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		}
		sys_yield();
  802c92:	48 b8 4e 20 80 00 00 	movabs $0x80204e,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r = -E_IPC_NOT_RECV;
	while(r == -E_IPC_NOT_RECV) {
  802c9e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802ca2:	74 a1                	je     802c45 <ipc_send+0x1e>
		else {
			r = sys_ipc_try_send(to_env, val, (void*)KERNBASE, perm);
		}
		sys_yield();
	}
	if (r != 0) {
  802ca4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca8:	74 2a                	je     802cd4 <ipc_send+0xad>
		panic("something went wrong with sending the page");
  802caa:	48 ba 00 58 80 00 00 	movabs $0x805800,%rdx
  802cb1:	00 00 00 
  802cb4:	be 49 00 00 00       	mov    $0x49,%esi
  802cb9:	48 bf 2b 58 80 00 00 	movabs $0x80582b,%rdi
  802cc0:	00 00 00 
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc8:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  802ccf:	00 00 00 
  802cd2:	ff d1                	callq  *%rcx
	}
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
}
  802cd4:	c9                   	leaveq 
  802cd5:	c3                   	retq   

0000000000802cd6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802cd6:	55                   	push   %rbp
  802cd7:	48 89 e5             	mov    %rsp,%rbp
  802cda:	48 83 ec 18          	sub    $0x18,%rsp
  802cde:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802ce1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ce8:	eb 6a                	jmp    802d54 <ipc_find_env+0x7e>
		if (envs[i].env_type == type)
  802cea:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802cf1:	00 00 00 
  802cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf7:	48 63 d0             	movslq %eax,%rdx
  802cfa:	48 89 d0             	mov    %rdx,%rax
  802cfd:	48 c1 e0 02          	shl    $0x2,%rax
  802d01:	48 01 d0             	add    %rdx,%rax
  802d04:	48 01 c0             	add    %rax,%rax
  802d07:	48 01 d0             	add    %rdx,%rax
  802d0a:	48 c1 e0 05          	shl    $0x5,%rax
  802d0e:	48 01 c8             	add    %rcx,%rax
  802d11:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802d17:	8b 00                	mov    (%rax),%eax
  802d19:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802d1c:	75 32                	jne    802d50 <ipc_find_env+0x7a>
			return envs[i].env_id;
  802d1e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802d25:	00 00 00 
  802d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2b:	48 63 d0             	movslq %eax,%rdx
  802d2e:	48 89 d0             	mov    %rdx,%rax
  802d31:	48 c1 e0 02          	shl    $0x2,%rax
  802d35:	48 01 d0             	add    %rdx,%rax
  802d38:	48 01 c0             	add    %rax,%rax
  802d3b:	48 01 d0             	add    %rdx,%rax
  802d3e:	48 c1 e0 05          	shl    $0x5,%rax
  802d42:	48 01 c8             	add    %rcx,%rax
  802d45:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802d4b:	8b 40 08             	mov    0x8(%rax),%eax
  802d4e:	eb 12                	jmp    802d62 <ipc_find_env+0x8c>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802d50:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d54:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802d5b:	7e 8d                	jle    802cea <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d62:	c9                   	leaveq 
  802d63:	c3                   	retq   

0000000000802d64 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802d64:	55                   	push   %rbp
  802d65:	48 89 e5             	mov    %rsp,%rbp
  802d68:	48 83 ec 08          	sub    $0x8,%rsp
  802d6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802d70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d74:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802d7b:	ff ff ff 
  802d7e:	48 01 d0             	add    %rdx,%rax
  802d81:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802d85:	c9                   	leaveq 
  802d86:	c3                   	retq   

0000000000802d87 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802d87:	55                   	push   %rbp
  802d88:	48 89 e5             	mov    %rsp,%rbp
  802d8b:	48 83 ec 08          	sub    $0x8,%rsp
  802d8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802d93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d97:	48 89 c7             	mov    %rax,%rdi
  802d9a:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
  802da6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802dac:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802db0:	c9                   	leaveq 
  802db1:	c3                   	retq   

0000000000802db2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802db2:	55                   	push   %rbp
  802db3:	48 89 e5             	mov    %rsp,%rbp
  802db6:	48 83 ec 18          	sub    $0x18,%rsp
  802dba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802dbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802dc5:	eb 6b                	jmp    802e32 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dca:	48 98                	cltq   
  802dcc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802dd2:	48 c1 e0 0c          	shl    $0xc,%rax
  802dd6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dde:	48 89 c2             	mov    %rax,%rdx
  802de1:	48 c1 ea 15          	shr    $0x15,%rdx
  802de5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802dec:	01 00 00 
  802def:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802df3:	83 e0 01             	and    $0x1,%eax
  802df6:	48 85 c0             	test   %rax,%rax
  802df9:	74 21                	je     802e1c <fd_alloc+0x6a>
  802dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dff:	48 89 c2             	mov    %rax,%rdx
  802e02:	48 c1 ea 0c          	shr    $0xc,%rdx
  802e06:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e0d:	01 00 00 
  802e10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e14:	83 e0 01             	and    $0x1,%eax
  802e17:	48 85 c0             	test   %rax,%rax
  802e1a:	75 12                	jne    802e2e <fd_alloc+0x7c>
			*fd_store = fd;
  802e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e24:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802e27:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2c:	eb 1a                	jmp    802e48 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802e2e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e32:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802e36:	7e 8f                	jle    802dc7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802e43:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802e48:	c9                   	leaveq 
  802e49:	c3                   	retq   

0000000000802e4a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802e4a:	55                   	push   %rbp
  802e4b:	48 89 e5             	mov    %rsp,%rbp
  802e4e:	48 83 ec 20          	sub    $0x20,%rsp
  802e52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802e59:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e5d:	78 06                	js     802e65 <fd_lookup+0x1b>
  802e5f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802e63:	7e 07                	jle    802e6c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802e65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e6a:	eb 6c                	jmp    802ed8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802e6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e6f:	48 98                	cltq   
  802e71:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e77:	48 c1 e0 0c          	shl    $0xc,%rax
  802e7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802e7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e83:	48 89 c2             	mov    %rax,%rdx
  802e86:	48 c1 ea 15          	shr    $0x15,%rdx
  802e8a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e91:	01 00 00 
  802e94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e98:	83 e0 01             	and    $0x1,%eax
  802e9b:	48 85 c0             	test   %rax,%rax
  802e9e:	74 21                	je     802ec1 <fd_lookup+0x77>
  802ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea4:	48 89 c2             	mov    %rax,%rdx
  802ea7:	48 c1 ea 0c          	shr    $0xc,%rdx
  802eab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802eb2:	01 00 00 
  802eb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802eb9:	83 e0 01             	and    $0x1,%eax
  802ebc:	48 85 c0             	test   %rax,%rax
  802ebf:	75 07                	jne    802ec8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802ec1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ec6:	eb 10                	jmp    802ed8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802ec8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ecc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ed0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ed8:	c9                   	leaveq 
  802ed9:	c3                   	retq   

0000000000802eda <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802eda:	55                   	push   %rbp
  802edb:	48 89 e5             	mov    %rsp,%rbp
  802ede:	48 83 ec 30          	sub    $0x30,%rsp
  802ee2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ee6:	89 f0                	mov    %esi,%eax
  802ee8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802eeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eef:	48 89 c7             	mov    %rax,%rdi
  802ef2:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  802ef9:	00 00 00 
  802efc:	ff d0                	callq  *%rax
  802efe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f02:	48 89 d6             	mov    %rdx,%rsi
  802f05:	89 c7                	mov    %eax,%edi
  802f07:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	callq  *%rax
  802f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1a:	78 0a                	js     802f26 <fd_close+0x4c>
	    || fd != fd2)
  802f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f20:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802f24:	74 12                	je     802f38 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802f26:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802f2a:	74 05                	je     802f31 <fd_close+0x57>
  802f2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2f:	eb 05                	jmp    802f36 <fd_close+0x5c>
  802f31:	b8 00 00 00 00       	mov    $0x0,%eax
  802f36:	eb 69                	jmp    802fa1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802f38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f3c:	8b 00                	mov    (%rax),%eax
  802f3e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f42:	48 89 d6             	mov    %rdx,%rsi
  802f45:	89 c7                	mov    %eax,%edi
  802f47:	48 b8 a3 2f 80 00 00 	movabs $0x802fa3,%rax
  802f4e:	00 00 00 
  802f51:	ff d0                	callq  *%rax
  802f53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5a:	78 2a                	js     802f86 <fd_close+0xac>
		if (dev->dev_close)
  802f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f60:	48 8b 40 20          	mov    0x20(%rax),%rax
  802f64:	48 85 c0             	test   %rax,%rax
  802f67:	74 16                	je     802f7f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802f71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f75:	48 89 c7             	mov    %rax,%rdi
  802f78:	ff d2                	callq  *%rdx
  802f7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7d:	eb 07                	jmp    802f86 <fd_close+0xac>
		else
			r = 0;
  802f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802f86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8a:	48 89 c6             	mov    %rax,%rsi
  802f8d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f92:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  802f99:	00 00 00 
  802f9c:	ff d0                	callq  *%rax
	return r;
  802f9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fa1:	c9                   	leaveq 
  802fa2:	c3                   	retq   

0000000000802fa3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802fa3:	55                   	push   %rbp
  802fa4:	48 89 e5             	mov    %rsp,%rbp
  802fa7:	48 83 ec 20          	sub    $0x20,%rsp
  802fab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802fb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802fb9:	eb 41                	jmp    802ffc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802fbb:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802fc2:	00 00 00 
  802fc5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fc8:	48 63 d2             	movslq %edx,%rdx
  802fcb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fcf:	8b 00                	mov    (%rax),%eax
  802fd1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802fd4:	75 22                	jne    802ff8 <dev_lookup+0x55>
			*dev = devtab[i];
  802fd6:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802fdd:	00 00 00 
  802fe0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fe3:	48 63 d2             	movslq %edx,%rdx
  802fe6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802fea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff6:	eb 60                	jmp    803058 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802ff8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ffc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803003:	00 00 00 
  803006:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803009:	48 63 d2             	movslq %edx,%rdx
  80300c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803010:	48 85 c0             	test   %rax,%rax
  803013:	75 a6                	jne    802fbb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803015:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80301c:	00 00 00 
  80301f:	48 8b 00             	mov    (%rax),%rax
  803022:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803028:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80302b:	89 c6                	mov    %eax,%esi
  80302d:	48 bf 38 58 80 00 00 	movabs $0x805838,%rdi
  803034:	00 00 00 
  803037:	b8 00 00 00 00       	mov    $0x0,%eax
  80303c:	48 b9 83 0b 80 00 00 	movabs $0x800b83,%rcx
  803043:	00 00 00 
  803046:	ff d1                	callq  *%rcx
	*dev = 0;
  803048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80304c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803053:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803058:	c9                   	leaveq 
  803059:	c3                   	retq   

000000000080305a <close>:

int
close(int fdnum)
{
  80305a:	55                   	push   %rbp
  80305b:	48 89 e5             	mov    %rsp,%rbp
  80305e:	48 83 ec 20          	sub    $0x20,%rsp
  803062:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803065:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803069:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80306c:	48 89 d6             	mov    %rdx,%rsi
  80306f:	89 c7                	mov    %eax,%edi
  803071:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  803078:	00 00 00 
  80307b:	ff d0                	callq  *%rax
  80307d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803080:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803084:	79 05                	jns    80308b <close+0x31>
		return r;
  803086:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803089:	eb 18                	jmp    8030a3 <close+0x49>
	else
		return fd_close(fd, 1);
  80308b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308f:	be 01 00 00 00       	mov    $0x1,%esi
  803094:	48 89 c7             	mov    %rax,%rdi
  803097:	48 b8 da 2e 80 00 00 	movabs $0x802eda,%rax
  80309e:	00 00 00 
  8030a1:	ff d0                	callq  *%rax
}
  8030a3:	c9                   	leaveq 
  8030a4:	c3                   	retq   

00000000008030a5 <close_all>:

void
close_all(void)
{
  8030a5:	55                   	push   %rbp
  8030a6:	48 89 e5             	mov    %rsp,%rbp
  8030a9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8030ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030b4:	eb 15                	jmp    8030cb <close_all+0x26>
		close(i);
  8030b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b9:	89 c7                	mov    %eax,%edi
  8030bb:	48 b8 5a 30 80 00 00 	movabs $0x80305a,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8030c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8030cb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8030cf:	7e e5                	jle    8030b6 <close_all+0x11>
		close(i);
}
  8030d1:	c9                   	leaveq 
  8030d2:	c3                   	retq   

00000000008030d3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8030d3:	55                   	push   %rbp
  8030d4:	48 89 e5             	mov    %rsp,%rbp
  8030d7:	48 83 ec 40          	sub    $0x40,%rsp
  8030db:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8030de:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8030e1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8030e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8030e8:	48 89 d6             	mov    %rdx,%rsi
  8030eb:	89 c7                	mov    %eax,%edi
  8030ed:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
  8030f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803100:	79 08                	jns    80310a <dup+0x37>
		return r;
  803102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803105:	e9 70 01 00 00       	jmpq   80327a <dup+0x1a7>
	close(newfdnum);
  80310a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80310d:	89 c7                	mov    %eax,%edi
  80310f:	48 b8 5a 30 80 00 00 	movabs $0x80305a,%rax
  803116:	00 00 00 
  803119:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80311b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80311e:	48 98                	cltq   
  803120:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803126:	48 c1 e0 0c          	shl    $0xc,%rax
  80312a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80312e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803132:	48 89 c7             	mov    %rax,%rdi
  803135:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  80313c:	00 00 00 
  80313f:	ff d0                	callq  *%rax
  803141:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803145:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803149:	48 89 c7             	mov    %rax,%rdi
  80314c:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  803153:	00 00 00 
  803156:	ff d0                	callq  *%rax
  803158:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80315c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803160:	48 89 c2             	mov    %rax,%rdx
  803163:	48 c1 ea 15          	shr    $0x15,%rdx
  803167:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80316e:	01 00 00 
  803171:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803175:	83 e0 01             	and    $0x1,%eax
  803178:	84 c0                	test   %al,%al
  80317a:	74 71                	je     8031ed <dup+0x11a>
  80317c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803180:	48 89 c2             	mov    %rax,%rdx
  803183:	48 c1 ea 0c          	shr    $0xc,%rdx
  803187:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80318e:	01 00 00 
  803191:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803195:	83 e0 01             	and    $0x1,%eax
  803198:	84 c0                	test   %al,%al
  80319a:	74 51                	je     8031ed <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80319c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a0:	48 89 c2             	mov    %rax,%rdx
  8031a3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8031a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8031ae:	01 00 00 
  8031b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031b5:	89 c1                	mov    %eax,%ecx
  8031b7:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8031bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c5:	41 89 c8             	mov    %ecx,%r8d
  8031c8:	48 89 d1             	mov    %rdx,%rcx
  8031cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8031d0:	48 89 c6             	mov    %rax,%rsi
  8031d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8031d8:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  8031df:	00 00 00 
  8031e2:	ff d0                	callq  *%rax
  8031e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031eb:	78 56                	js     803243 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8031ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f1:	48 89 c2             	mov    %rax,%rdx
  8031f4:	48 c1 ea 0c          	shr    $0xc,%rdx
  8031f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8031ff:	01 00 00 
  803202:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803206:	89 c1                	mov    %eax,%ecx
  803208:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80320e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803212:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803216:	41 89 c8             	mov    %ecx,%r8d
  803219:	48 89 d1             	mov    %rdx,%rcx
  80321c:	ba 00 00 00 00       	mov    $0x0,%edx
  803221:	48 89 c6             	mov    %rax,%rsi
  803224:	bf 00 00 00 00       	mov    $0x0,%edi
  803229:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  803230:	00 00 00 
  803233:	ff d0                	callq  *%rax
  803235:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803238:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323c:	78 08                	js     803246 <dup+0x173>
		goto err;

	return newfdnum;
  80323e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803241:	eb 37                	jmp    80327a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  803243:	90                   	nop
  803244:	eb 01                	jmp    803247 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  803246:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324b:	48 89 c6             	mov    %rax,%rsi
  80324e:	bf 00 00 00 00       	mov    $0x0,%edi
  803253:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  80325a:	00 00 00 
  80325d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80325f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803263:	48 89 c6             	mov    %rax,%rsi
  803266:	bf 00 00 00 00       	mov    $0x0,%edi
  80326b:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
	return r;
  803277:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80327a:	c9                   	leaveq 
  80327b:	c3                   	retq   

000000000080327c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80327c:	55                   	push   %rbp
  80327d:	48 89 e5             	mov    %rsp,%rbp
  803280:	48 83 ec 40          	sub    $0x40,%rsp
  803284:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803287:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80328b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80328f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803293:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803296:	48 89 d6             	mov    %rdx,%rsi
  803299:	89 c7                	mov    %eax,%edi
  80329b:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  8032a2:	00 00 00 
  8032a5:	ff d0                	callq  *%rax
  8032a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ae:	78 24                	js     8032d4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b4:	8b 00                	mov    (%rax),%eax
  8032b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032ba:	48 89 d6             	mov    %rdx,%rsi
  8032bd:	89 c7                	mov    %eax,%edi
  8032bf:	48 b8 a3 2f 80 00 00 	movabs $0x802fa3,%rax
  8032c6:	00 00 00 
  8032c9:	ff d0                	callq  *%rax
  8032cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d2:	79 05                	jns    8032d9 <read+0x5d>
		return r;
  8032d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d7:	eb 7a                	jmp    803353 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8032d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032dd:	8b 40 08             	mov    0x8(%rax),%eax
  8032e0:	83 e0 03             	and    $0x3,%eax
  8032e3:	83 f8 01             	cmp    $0x1,%eax
  8032e6:	75 3a                	jne    803322 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8032e8:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8032ef:	00 00 00 
  8032f2:	48 8b 00             	mov    (%rax),%rax
  8032f5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8032fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8032fe:	89 c6                	mov    %eax,%esi
  803300:	48 bf 57 58 80 00 00 	movabs $0x805857,%rdi
  803307:	00 00 00 
  80330a:	b8 00 00 00 00       	mov    $0x0,%eax
  80330f:	48 b9 83 0b 80 00 00 	movabs $0x800b83,%rcx
  803316:	00 00 00 
  803319:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80331b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803320:	eb 31                	jmp    803353 <read+0xd7>
	}
	if (!dev->dev_read)
  803322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803326:	48 8b 40 10          	mov    0x10(%rax),%rax
  80332a:	48 85 c0             	test   %rax,%rax
  80332d:	75 07                	jne    803336 <read+0xba>
		return -E_NOT_SUPP;
  80332f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803334:	eb 1d                	jmp    803353 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  803336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80333e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803342:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803346:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80334a:	48 89 ce             	mov    %rcx,%rsi
  80334d:	48 89 c7             	mov    %rax,%rdi
  803350:	41 ff d0             	callq  *%r8
}
  803353:	c9                   	leaveq 
  803354:	c3                   	retq   

0000000000803355 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803355:	55                   	push   %rbp
  803356:	48 89 e5             	mov    %rsp,%rbp
  803359:	48 83 ec 30          	sub    $0x30,%rsp
  80335d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803360:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803364:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803368:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80336f:	eb 46                	jmp    8033b7 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803374:	48 98                	cltq   
  803376:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80337a:	48 29 c2             	sub    %rax,%rdx
  80337d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803380:	48 98                	cltq   
  803382:	48 89 c1             	mov    %rax,%rcx
  803385:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  803389:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80338c:	48 89 ce             	mov    %rcx,%rsi
  80338f:	89 c7                	mov    %eax,%edi
  803391:	48 b8 7c 32 80 00 00 	movabs $0x80327c,%rax
  803398:	00 00 00 
  80339b:	ff d0                	callq  *%rax
  80339d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8033a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033a4:	79 05                	jns    8033ab <readn+0x56>
			return m;
  8033a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033a9:	eb 1d                	jmp    8033c8 <readn+0x73>
		if (m == 0)
  8033ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033af:	74 13                	je     8033c4 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8033b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033b4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8033b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ba:	48 98                	cltq   
  8033bc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8033c0:	72 af                	jb     803371 <readn+0x1c>
  8033c2:	eb 01                	jmp    8033c5 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8033c4:	90                   	nop
	}
	return tot;
  8033c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033c8:	c9                   	leaveq 
  8033c9:	c3                   	retq   

00000000008033ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8033ca:	55                   	push   %rbp
  8033cb:	48 89 e5             	mov    %rsp,%rbp
  8033ce:	48 83 ec 40          	sub    $0x40,%rsp
  8033d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8033d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033d9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8033dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033e4:	48 89 d6             	mov    %rdx,%rsi
  8033e7:	89 c7                	mov    %eax,%edi
  8033e9:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  8033f0:	00 00 00 
  8033f3:	ff d0                	callq  *%rax
  8033f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fc:	78 24                	js     803422 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8033fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803402:	8b 00                	mov    (%rax),%eax
  803404:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803408:	48 89 d6             	mov    %rdx,%rsi
  80340b:	89 c7                	mov    %eax,%edi
  80340d:	48 b8 a3 2f 80 00 00 	movabs $0x802fa3,%rax
  803414:	00 00 00 
  803417:	ff d0                	callq  *%rax
  803419:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80341c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803420:	79 05                	jns    803427 <write+0x5d>
		return r;
  803422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803425:	eb 79                	jmp    8034a0 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80342b:	8b 40 08             	mov    0x8(%rax),%eax
  80342e:	83 e0 03             	and    $0x3,%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	75 3a                	jne    80346f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803435:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80343c:	00 00 00 
  80343f:	48 8b 00             	mov    (%rax),%rax
  803442:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803448:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80344b:	89 c6                	mov    %eax,%esi
  80344d:	48 bf 73 58 80 00 00 	movabs $0x805873,%rdi
  803454:	00 00 00 
  803457:	b8 00 00 00 00       	mov    $0x0,%eax
  80345c:	48 b9 83 0b 80 00 00 	movabs $0x800b83,%rcx
  803463:	00 00 00 
  803466:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803468:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80346d:	eb 31                	jmp    8034a0 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80346f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803473:	48 8b 40 18          	mov    0x18(%rax),%rax
  803477:	48 85 c0             	test   %rax,%rax
  80347a:	75 07                	jne    803483 <write+0xb9>
		return -E_NOT_SUPP;
  80347c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803481:	eb 1d                	jmp    8034a0 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  803483:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803487:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80348b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803493:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803497:	48 89 ce             	mov    %rcx,%rsi
  80349a:	48 89 c7             	mov    %rax,%rdi
  80349d:	41 ff d0             	callq  *%r8
}
  8034a0:	c9                   	leaveq 
  8034a1:	c3                   	retq   

00000000008034a2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8034a2:	55                   	push   %rbp
  8034a3:	48 89 e5             	mov    %rsp,%rbp
  8034a6:	48 83 ec 18          	sub    $0x18,%rsp
  8034aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034ad:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034b7:	48 89 d6             	mov    %rdx,%rsi
  8034ba:	89 c7                	mov    %eax,%edi
  8034bc:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
  8034c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034cf:	79 05                	jns    8034d6 <seek+0x34>
		return r;
  8034d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d4:	eb 0f                	jmp    8034e5 <seek+0x43>
	fd->fd_offset = offset;
  8034d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034da:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034dd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8034e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034e5:	c9                   	leaveq 
  8034e6:	c3                   	retq   

00000000008034e7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8034e7:	55                   	push   %rbp
  8034e8:	48 89 e5             	mov    %rsp,%rbp
  8034eb:	48 83 ec 30          	sub    $0x30,%rsp
  8034ef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8034f2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8034f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034fc:	48 89 d6             	mov    %rdx,%rsi
  8034ff:	89 c7                	mov    %eax,%edi
  803501:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  803508:	00 00 00 
  80350b:	ff d0                	callq  *%rax
  80350d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803510:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803514:	78 24                	js     80353a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351a:	8b 00                	mov    (%rax),%eax
  80351c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803520:	48 89 d6             	mov    %rdx,%rsi
  803523:	89 c7                	mov    %eax,%edi
  803525:	48 b8 a3 2f 80 00 00 	movabs $0x802fa3,%rax
  80352c:	00 00 00 
  80352f:	ff d0                	callq  *%rax
  803531:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803534:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803538:	79 05                	jns    80353f <ftruncate+0x58>
		return r;
  80353a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353d:	eb 72                	jmp    8035b1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80353f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803543:	8b 40 08             	mov    0x8(%rax),%eax
  803546:	83 e0 03             	and    $0x3,%eax
  803549:	85 c0                	test   %eax,%eax
  80354b:	75 3a                	jne    803587 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80354d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803554:	00 00 00 
  803557:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80355a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803560:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803563:	89 c6                	mov    %eax,%esi
  803565:	48 bf 90 58 80 00 00 	movabs $0x805890,%rdi
  80356c:	00 00 00 
  80356f:	b8 00 00 00 00       	mov    $0x0,%eax
  803574:	48 b9 83 0b 80 00 00 	movabs $0x800b83,%rcx
  80357b:	00 00 00 
  80357e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803580:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803585:	eb 2a                	jmp    8035b1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803587:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80358f:	48 85 c0             	test   %rax,%rax
  803592:	75 07                	jne    80359b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803594:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803599:	eb 16                	jmp    8035b1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80359b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8035a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8035aa:	89 d6                	mov    %edx,%esi
  8035ac:	48 89 c7             	mov    %rax,%rdi
  8035af:	ff d1                	callq  *%rcx
}
  8035b1:	c9                   	leaveq 
  8035b2:	c3                   	retq   

00000000008035b3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8035b3:	55                   	push   %rbp
  8035b4:	48 89 e5             	mov    %rsp,%rbp
  8035b7:	48 83 ec 30          	sub    $0x30,%rsp
  8035bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8035be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8035c2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035c9:	48 89 d6             	mov    %rdx,%rsi
  8035cc:	89 c7                	mov    %eax,%edi
  8035ce:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  8035d5:	00 00 00 
  8035d8:	ff d0                	callq  *%rax
  8035da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e1:	78 24                	js     803607 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8035e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e7:	8b 00                	mov    (%rax),%eax
  8035e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035ed:	48 89 d6             	mov    %rdx,%rsi
  8035f0:	89 c7                	mov    %eax,%edi
  8035f2:	48 b8 a3 2f 80 00 00 	movabs $0x802fa3,%rax
  8035f9:	00 00 00 
  8035fc:	ff d0                	callq  *%rax
  8035fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803601:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803605:	79 05                	jns    80360c <fstat+0x59>
		return r;
  803607:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360a:	eb 5e                	jmp    80366a <fstat+0xb7>
	if (!dev->dev_stat)
  80360c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803610:	48 8b 40 28          	mov    0x28(%rax),%rax
  803614:	48 85 c0             	test   %rax,%rax
  803617:	75 07                	jne    803620 <fstat+0x6d>
		return -E_NOT_SUPP;
  803619:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80361e:	eb 4a                	jmp    80366a <fstat+0xb7>
	stat->st_name[0] = 0;
  803620:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803624:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803627:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80362b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803632:	00 00 00 
	stat->st_isdir = 0;
  803635:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803639:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803640:	00 00 00 
	stat->st_dev = dev;
  803643:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803647:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80364b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803656:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80365a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803662:	48 89 d6             	mov    %rdx,%rsi
  803665:	48 89 c7             	mov    %rax,%rdi
  803668:	ff d1                	callq  *%rcx
}
  80366a:	c9                   	leaveq 
  80366b:	c3                   	retq   

000000000080366c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80366c:	55                   	push   %rbp
  80366d:	48 89 e5             	mov    %rsp,%rbp
  803670:	48 83 ec 20          	sub    $0x20,%rsp
  803674:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803678:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80367c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803680:	be 00 00 00 00       	mov    $0x0,%esi
  803685:	48 89 c7             	mov    %rax,%rdi
  803688:	48 b8 5b 37 80 00 00 	movabs $0x80375b,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
  803694:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803697:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369b:	79 05                	jns    8036a2 <stat+0x36>
		return fd;
  80369d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a0:	eb 2f                	jmp    8036d1 <stat+0x65>
	r = fstat(fd, stat);
  8036a2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8036a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a9:	48 89 d6             	mov    %rdx,%rsi
  8036ac:	89 c7                	mov    %eax,%edi
  8036ae:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  8036b5:	00 00 00 
  8036b8:	ff d0                	callq  *%rax
  8036ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8036bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c0:	89 c7                	mov    %eax,%edi
  8036c2:	48 b8 5a 30 80 00 00 	movabs $0x80305a,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
	return r;
  8036ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8036d1:	c9                   	leaveq 
  8036d2:	c3                   	retq   
	...

00000000008036d4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8036d4:	55                   	push   %rbp
  8036d5:	48 89 e5             	mov    %rsp,%rbp
  8036d8:	48 83 ec 10          	sub    $0x10,%rsp
  8036dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8036e3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8036ea:	00 00 00 
  8036ed:	8b 00                	mov    (%rax),%eax
  8036ef:	85 c0                	test   %eax,%eax
  8036f1:	75 1d                	jne    803710 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8036f3:	bf 01 00 00 00       	mov    $0x1,%edi
  8036f8:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  8036ff:	00 00 00 
  803702:	ff d0                	callq  *%rax
  803704:	48 ba 08 80 80 00 00 	movabs $0x808008,%rdx
  80370b:	00 00 00 
  80370e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803710:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803717:	00 00 00 
  80371a:	8b 00                	mov    (%rax),%eax
  80371c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80371f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803724:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80372b:	00 00 00 
  80372e:	89 c7                	mov    %eax,%edi
  803730:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  803737:	00 00 00 
  80373a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80373c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803740:	ba 00 00 00 00       	mov    $0x0,%edx
  803745:	48 89 c6             	mov    %rax,%rsi
  803748:	bf 00 00 00 00       	mov    $0x0,%edi
  80374d:	48 b8 40 2b 80 00 00 	movabs $0x802b40,%rax
  803754:	00 00 00 
  803757:	ff d0                	callq  *%rax
}
  803759:	c9                   	leaveq 
  80375a:	c3                   	retq   

000000000080375b <open>:
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.

int
open(const char *path, int mode)
{
  80375b:	55                   	push   %rbp
  80375c:	48 89 e5             	mov    %rsp,%rbp
  80375f:	48 83 ec 20          	sub    $0x20,%rsp
  803763:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803767:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	if(strlen(path) >= MAXPATHLEN) {
  80376a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80376e:	48 89 c7             	mov    %rax,%rdi
  803771:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
  80377d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803782:	7e 0a                	jle    80378e <open+0x33>
		return -E_BAD_PATH;
  803784:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803789:	e9 a5 00 00 00       	jmpq   803833 <open+0xd8>
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	// LAB 5: Your code here
	struct Fd *new_fd;
	int r = fd_alloc(&new_fd);
  80378e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803792:	48 89 c7             	mov    %rax,%rdi
  803795:	48 b8 b2 2d 80 00 00 	movabs $0x802db2,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
  8037a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8037a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a8:	79 08                	jns    8037b2 <open+0x57>
		return r;
  8037aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ad:	e9 81 00 00 00       	jmpq   803833 <open+0xd8>
	}
	fsipcbuf.open.req_omode = mode;
  8037b2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037b9:	00 00 00 
  8037bc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8037bf:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8037c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c9:	48 89 c6             	mov    %rax,%rsi
  8037cc:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8037d3:	00 00 00 
  8037d6:	48 b8 54 17 80 00 00 	movabs $0x801754,%rax
  8037dd:	00 00 00 
  8037e0:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_OPEN, new_fd);
  8037e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e6:	48 89 c6             	mov    %rax,%rsi
  8037e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8037ee:	48 b8 d4 36 80 00 00 	movabs $0x8036d4,%rax
  8037f5:	00 00 00 
  8037f8:	ff d0                	callq  *%rax
  8037fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r<0) {
  8037fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803801:	79 1d                	jns    803820 <open+0xc5>
		fd_close(new_fd, 0);
  803803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803807:	be 00 00 00 00       	mov    $0x0,%esi
  80380c:	48 89 c7             	mov    %rax,%rdi
  80380f:	48 b8 da 2e 80 00 00 	movabs $0x802eda,%rax
  803816:	00 00 00 
  803819:	ff d0                	callq  *%rax
		return r;	
  80381b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381e:	eb 13                	jmp    803833 <open+0xd8>
	}
	return fd2num(new_fd);
  803820:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803824:	48 89 c7             	mov    %rax,%rdi
  803827:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  80382e:	00 00 00 
  803831:	ff d0                	callq  *%rax
}
  803833:	c9                   	leaveq 
  803834:	c3                   	retq   

0000000000803835 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803835:	55                   	push   %rbp
  803836:	48 89 e5             	mov    %rsp,%rbp
  803839:	48 83 ec 10          	sub    $0x10,%rsp
  80383d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803841:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803845:	8b 50 0c             	mov    0xc(%rax),%edx
  803848:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80384f:	00 00 00 
  803852:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803854:	be 00 00 00 00       	mov    $0x0,%esi
  803859:	bf 06 00 00 00       	mov    $0x6,%edi
  80385e:	48 b8 d4 36 80 00 00 	movabs $0x8036d4,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
}
  80386a:	c9                   	leaveq 
  80386b:	c3                   	retq   

000000000080386c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80386c:	55                   	push   %rbp
  80386d:	48 89 e5             	mov    %rsp,%rbp
  803870:	48 83 ec 30          	sub    $0x30,%rsp
  803874:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803878:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80387c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	// panic("devfile_read not implemented");
	fsipcbuf.read.req_fileid =  fd->fd_file.id;
  803880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803884:	8b 50 0c             	mov    0xc(%rax),%edx
  803887:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80388e:	00 00 00 
  803891:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803893:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80389a:	00 00 00 
  80389d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038a1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ssize_t nbytes = fsipc(FSREQ_READ, NULL);
  8038a5:	be 00 00 00 00       	mov    $0x0,%esi
  8038aa:	bf 03 00 00 00       	mov    $0x3,%edi
  8038af:	48 b8 d4 36 80 00 00 	movabs $0x8036d4,%rax
  8038b6:	00 00 00 
  8038b9:	ff d0                	callq  *%rax
  8038bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(nbytes > 0) {
  8038be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c2:	7e 23                	jle    8038e7 <devfile_read+0x7b>
		memmove(buf, fsipcbuf.readRet.ret_buf, nbytes);
  8038c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c7:	48 63 d0             	movslq %eax,%rdx
  8038ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ce:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8038d5:	00 00 00 
  8038d8:	48 89 c7             	mov    %rax,%rdi
  8038db:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  8038e2:	00 00 00 
  8038e5:	ff d0                	callq  *%rax
	}
	return nbytes;
  8038e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038ea:	c9                   	leaveq 
  8038eb:	c3                   	retq   

00000000008038ec <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8038ec:	55                   	push   %rbp
  8038ed:	48 89 e5             	mov    %rsp,%rbp
  8038f0:	48 83 ec 20          	sub    $0x20,%rsp
  8038f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8038fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803900:	8b 50 0c             	mov    0xc(%rax),%edx
  803903:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80390a:	00 00 00 
  80390d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80390f:	be 00 00 00 00       	mov    $0x0,%esi
  803914:	bf 05 00 00 00       	mov    $0x5,%edi
  803919:	48 b8 d4 36 80 00 00 	movabs $0x8036d4,%rax
  803920:	00 00 00 
  803923:	ff d0                	callq  *%rax
  803925:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803928:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392c:	79 05                	jns    803933 <devfile_stat+0x47>
		return r;
  80392e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803931:	eb 56                	jmp    803989 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803933:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803937:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80393e:	00 00 00 
  803941:	48 89 c7             	mov    %rax,%rdi
  803944:	48 b8 54 17 80 00 00 	movabs $0x801754,%rax
  80394b:	00 00 00 
  80394e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803950:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803957:	00 00 00 
  80395a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803960:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803964:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80396a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803971:	00 00 00 
  803974:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80397a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80397e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803984:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803989:	c9                   	leaveq 
  80398a:	c3                   	retq   
	...

000000000080398c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80398c:	55                   	push   %rbp
  80398d:	48 89 e5             	mov    %rsp,%rbp
  803990:	48 83 ec 20          	sub    $0x20,%rsp
  803994:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803997:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80399b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80399e:	48 89 d6             	mov    %rdx,%rsi
  8039a1:	89 c7                	mov    %eax,%edi
  8039a3:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  8039aa:	00 00 00 
  8039ad:	ff d0                	callq  *%rax
  8039af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b6:	79 05                	jns    8039bd <fd2sockid+0x31>
		return r;
  8039b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039bb:	eb 24                	jmp    8039e1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8039bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c1:	8b 10                	mov    (%rax),%edx
  8039c3:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8039ca:	00 00 00 
  8039cd:	8b 00                	mov    (%rax),%eax
  8039cf:	39 c2                	cmp    %eax,%edx
  8039d1:	74 07                	je     8039da <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8039d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8039d8:	eb 07                	jmp    8039e1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8039da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039de:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8039e1:	c9                   	leaveq 
  8039e2:	c3                   	retq   

00000000008039e3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8039e3:	55                   	push   %rbp
  8039e4:	48 89 e5             	mov    %rsp,%rbp
  8039e7:	48 83 ec 20          	sub    $0x20,%rsp
  8039eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8039ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8039f2:	48 89 c7             	mov    %rax,%rdi
  8039f5:	48 b8 b2 2d 80 00 00 	movabs $0x802db2,%rax
  8039fc:	00 00 00 
  8039ff:	ff d0                	callq  *%rax
  803a01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a08:	78 26                	js     803a30 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803a0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0e:	ba 07 04 00 00       	mov    $0x407,%edx
  803a13:	48 89 c6             	mov    %rax,%rsi
  803a16:	bf 00 00 00 00       	mov    $0x0,%edi
  803a1b:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  803a22:	00 00 00 
  803a25:	ff d0                	callq  *%rax
  803a27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a2e:	79 16                	jns    803a46 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803a30:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a33:	89 c7                	mov    %eax,%edi
  803a35:	48 b8 f0 3e 80 00 00 	movabs $0x803ef0,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
		return r;
  803a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a44:	eb 3a                	jmp    803a80 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803a46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a4a:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803a51:	00 00 00 
  803a54:	8b 12                	mov    (%rdx),%edx
  803a56:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803a58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803a63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a67:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a6a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a71:	48 89 c7             	mov    %rax,%rdi
  803a74:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  803a7b:	00 00 00 
  803a7e:	ff d0                	callq  *%rax
}
  803a80:	c9                   	leaveq 
  803a81:	c3                   	retq   

0000000000803a82 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a82:	55                   	push   %rbp
  803a83:	48 89 e5             	mov    %rsp,%rbp
  803a86:	48 83 ec 30          	sub    $0x30,%rsp
  803a8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a91:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a98:	89 c7                	mov    %eax,%edi
  803a9a:	48 b8 8c 39 80 00 00 	movabs $0x80398c,%rax
  803aa1:	00 00 00 
  803aa4:	ff d0                	callq  *%rax
  803aa6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aad:	79 05                	jns    803ab4 <accept+0x32>
		return r;
  803aaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab2:	eb 3b                	jmp    803aef <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803ab4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803ab8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803abc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803abf:	48 89 ce             	mov    %rcx,%rsi
  803ac2:	89 c7                	mov    %eax,%edi
  803ac4:	48 b8 cd 3d 80 00 00 	movabs $0x803dcd,%rax
  803acb:	00 00 00 
  803ace:	ff d0                	callq  *%rax
  803ad0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ad3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad7:	79 05                	jns    803ade <accept+0x5c>
		return r;
  803ad9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803adc:	eb 11                	jmp    803aef <accept+0x6d>
	return alloc_sockfd(r);
  803ade:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae1:	89 c7                	mov    %eax,%edi
  803ae3:	48 b8 e3 39 80 00 00 	movabs $0x8039e3,%rax
  803aea:	00 00 00 
  803aed:	ff d0                	callq  *%rax
}
  803aef:	c9                   	leaveq 
  803af0:	c3                   	retq   

0000000000803af1 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803af1:	55                   	push   %rbp
  803af2:	48 89 e5             	mov    %rsp,%rbp
  803af5:	48 83 ec 20          	sub    $0x20,%rsp
  803af9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803afc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b00:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b06:	89 c7                	mov    %eax,%edi
  803b08:	48 b8 8c 39 80 00 00 	movabs $0x80398c,%rax
  803b0f:	00 00 00 
  803b12:	ff d0                	callq  *%rax
  803b14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b1b:	79 05                	jns    803b22 <bind+0x31>
		return r;
  803b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b20:	eb 1b                	jmp    803b3d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803b22:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b25:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2c:	48 89 ce             	mov    %rcx,%rsi
  803b2f:	89 c7                	mov    %eax,%edi
  803b31:	48 b8 4c 3e 80 00 00 	movabs $0x803e4c,%rax
  803b38:	00 00 00 
  803b3b:	ff d0                	callq  *%rax
}
  803b3d:	c9                   	leaveq 
  803b3e:	c3                   	retq   

0000000000803b3f <shutdown>:

int
shutdown(int s, int how)
{
  803b3f:	55                   	push   %rbp
  803b40:	48 89 e5             	mov    %rsp,%rbp
  803b43:	48 83 ec 20          	sub    $0x20,%rsp
  803b47:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b4a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b50:	89 c7                	mov    %eax,%edi
  803b52:	48 b8 8c 39 80 00 00 	movabs $0x80398c,%rax
  803b59:	00 00 00 
  803b5c:	ff d0                	callq  *%rax
  803b5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b65:	79 05                	jns    803b6c <shutdown+0x2d>
		return r;
  803b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6a:	eb 16                	jmp    803b82 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803b6c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b72:	89 d6                	mov    %edx,%esi
  803b74:	89 c7                	mov    %eax,%edi
  803b76:	48 b8 b0 3e 80 00 00 	movabs $0x803eb0,%rax
  803b7d:	00 00 00 
  803b80:	ff d0                	callq  *%rax
}
  803b82:	c9                   	leaveq 
  803b83:	c3                   	retq   

0000000000803b84 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803b84:	55                   	push   %rbp
  803b85:	48 89 e5             	mov    %rsp,%rbp
  803b88:	48 83 ec 10          	sub    $0x10,%rsp
  803b8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803b90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b94:	48 89 c7             	mov    %rax,%rdi
  803b97:	48 b8 30 4b 80 00 00 	movabs $0x804b30,%rax
  803b9e:	00 00 00 
  803ba1:	ff d0                	callq  *%rax
  803ba3:	83 f8 01             	cmp    $0x1,%eax
  803ba6:	75 17                	jne    803bbf <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bac:	8b 40 0c             	mov    0xc(%rax),%eax
  803baf:	89 c7                	mov    %eax,%edi
  803bb1:	48 b8 f0 3e 80 00 00 	movabs $0x803ef0,%rax
  803bb8:	00 00 00 
  803bbb:	ff d0                	callq  *%rax
  803bbd:	eb 05                	jmp    803bc4 <devsock_close+0x40>
	else
		return 0;
  803bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bc4:	c9                   	leaveq 
  803bc5:	c3                   	retq   

0000000000803bc6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803bc6:	55                   	push   %rbp
  803bc7:	48 89 e5             	mov    %rsp,%rbp
  803bca:	48 83 ec 20          	sub    $0x20,%rsp
  803bce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bd1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bd5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bd8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bdb:	89 c7                	mov    %eax,%edi
  803bdd:	48 b8 8c 39 80 00 00 	movabs $0x80398c,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
  803be9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf0:	79 05                	jns    803bf7 <connect+0x31>
		return r;
  803bf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf5:	eb 1b                	jmp    803c12 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803bf7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803bfa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c01:	48 89 ce             	mov    %rcx,%rsi
  803c04:	89 c7                	mov    %eax,%edi
  803c06:	48 b8 1d 3f 80 00 00 	movabs $0x803f1d,%rax
  803c0d:	00 00 00 
  803c10:	ff d0                	callq  *%rax
}
  803c12:	c9                   	leaveq 
  803c13:	c3                   	retq   

0000000000803c14 <listen>:

int
listen(int s, int backlog)
{
  803c14:	55                   	push   %rbp
  803c15:	48 89 e5             	mov    %rsp,%rbp
  803c18:	48 83 ec 20          	sub    $0x20,%rsp
  803c1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c1f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c25:	89 c7                	mov    %eax,%edi
  803c27:	48 b8 8c 39 80 00 00 	movabs $0x80398c,%rax
  803c2e:	00 00 00 
  803c31:	ff d0                	callq  *%rax
  803c33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c3a:	79 05                	jns    803c41 <listen+0x2d>
		return r;
  803c3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c3f:	eb 16                	jmp    803c57 <listen+0x43>
	return nsipc_listen(r, backlog);
  803c41:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c47:	89 d6                	mov    %edx,%esi
  803c49:	89 c7                	mov    %eax,%edi
  803c4b:	48 b8 81 3f 80 00 00 	movabs $0x803f81,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
}
  803c57:	c9                   	leaveq 
  803c58:	c3                   	retq   

0000000000803c59 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803c59:	55                   	push   %rbp
  803c5a:	48 89 e5             	mov    %rsp,%rbp
  803c5d:	48 83 ec 20          	sub    $0x20,%rsp
  803c61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c69:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803c6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c71:	89 c2                	mov    %eax,%edx
  803c73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c77:	8b 40 0c             	mov    0xc(%rax),%eax
  803c7a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803c7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c83:	89 c7                	mov    %eax,%edi
  803c85:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  803c8c:	00 00 00 
  803c8f:	ff d0                	callq  *%rax
}
  803c91:	c9                   	leaveq 
  803c92:	c3                   	retq   

0000000000803c93 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803c93:	55                   	push   %rbp
  803c94:	48 89 e5             	mov    %rsp,%rbp
  803c97:	48 83 ec 20          	sub    $0x20,%rsp
  803c9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ca3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803ca7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cab:	89 c2                	mov    %eax,%edx
  803cad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cb1:	8b 40 0c             	mov    0xc(%rax),%eax
  803cb4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803cb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  803cbd:	89 c7                	mov    %eax,%edi
  803cbf:	48 b8 8d 40 80 00 00 	movabs $0x80408d,%rax
  803cc6:	00 00 00 
  803cc9:	ff d0                	callq  *%rax
}
  803ccb:	c9                   	leaveq 
  803ccc:	c3                   	retq   

0000000000803ccd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803ccd:	55                   	push   %rbp
  803cce:	48 89 e5             	mov    %rsp,%rbp
  803cd1:	48 83 ec 10          	sub    $0x10,%rsp
  803cd5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cd9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce1:	48 be bb 58 80 00 00 	movabs $0x8058bb,%rsi
  803ce8:	00 00 00 
  803ceb:	48 89 c7             	mov    %rax,%rdi
  803cee:	48 b8 54 17 80 00 00 	movabs $0x801754,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
	return 0;
  803cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cff:	c9                   	leaveq 
  803d00:	c3                   	retq   

0000000000803d01 <socket>:

int
socket(int domain, int type, int protocol)
{
  803d01:	55                   	push   %rbp
  803d02:	48 89 e5             	mov    %rsp,%rbp
  803d05:	48 83 ec 20          	sub    $0x20,%rsp
  803d09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d0c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d0f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803d12:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803d15:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d1b:	89 ce                	mov    %ecx,%esi
  803d1d:	89 c7                	mov    %eax,%edi
  803d1f:	48 b8 45 41 80 00 00 	movabs $0x804145,%rax
  803d26:	00 00 00 
  803d29:	ff d0                	callq  *%rax
  803d2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d32:	79 05                	jns    803d39 <socket+0x38>
		return r;
  803d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d37:	eb 11                	jmp    803d4a <socket+0x49>
	return alloc_sockfd(r);
  803d39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3c:	89 c7                	mov    %eax,%edi
  803d3e:	48 b8 e3 39 80 00 00 	movabs $0x8039e3,%rax
  803d45:	00 00 00 
  803d48:	ff d0                	callq  *%rax
}
  803d4a:	c9                   	leaveq 
  803d4b:	c3                   	retq   

0000000000803d4c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803d4c:	55                   	push   %rbp
  803d4d:	48 89 e5             	mov    %rsp,%rbp
  803d50:	48 83 ec 10          	sub    $0x10,%rsp
  803d54:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803d57:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  803d5e:	00 00 00 
  803d61:	8b 00                	mov    (%rax),%eax
  803d63:	85 c0                	test   %eax,%eax
  803d65:	75 1d                	jne    803d84 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803d67:	bf 02 00 00 00       	mov    $0x2,%edi
  803d6c:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  803d73:	00 00 00 
  803d76:	ff d0                	callq  *%rax
  803d78:	48 ba 0c 80 80 00 00 	movabs $0x80800c,%rdx
  803d7f:	00 00 00 
  803d82:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803d84:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  803d8b:	00 00 00 
  803d8e:	8b 00                	mov    (%rax),%eax
  803d90:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803d93:	b9 07 00 00 00       	mov    $0x7,%ecx
  803d98:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803d9f:	00 00 00 
  803da2:	89 c7                	mov    %eax,%edi
  803da4:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  803dab:	00 00 00 
  803dae:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803db0:	ba 00 00 00 00       	mov    $0x0,%edx
  803db5:	be 00 00 00 00       	mov    $0x0,%esi
  803dba:	bf 00 00 00 00       	mov    $0x0,%edi
  803dbf:	48 b8 40 2b 80 00 00 	movabs $0x802b40,%rax
  803dc6:	00 00 00 
  803dc9:	ff d0                	callq  *%rax
}
  803dcb:	c9                   	leaveq 
  803dcc:	c3                   	retq   

0000000000803dcd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803dcd:	55                   	push   %rbp
  803dce:	48 89 e5             	mov    %rsp,%rbp
  803dd1:	48 83 ec 30          	sub    $0x30,%rsp
  803dd5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803dd8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ddc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803de0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803de7:	00 00 00 
  803dea:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ded:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803def:	bf 01 00 00 00       	mov    $0x1,%edi
  803df4:	48 b8 4c 3d 80 00 00 	movabs $0x803d4c,%rax
  803dfb:	00 00 00 
  803dfe:	ff d0                	callq  *%rax
  803e00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e07:	78 3e                	js     803e47 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803e09:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e10:	00 00 00 
  803e13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1b:	8b 40 10             	mov    0x10(%rax),%eax
  803e1e:	89 c2                	mov    %eax,%edx
  803e20:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803e24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e28:	48 89 ce             	mov    %rcx,%rsi
  803e2b:	48 89 c7             	mov    %rax,%rdi
  803e2e:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  803e35:	00 00 00 
  803e38:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3e:	8b 50 10             	mov    0x10(%rax),%edx
  803e41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e45:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e4a:	c9                   	leaveq 
  803e4b:	c3                   	retq   

0000000000803e4c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803e4c:	55                   	push   %rbp
  803e4d:	48 89 e5             	mov    %rsp,%rbp
  803e50:	48 83 ec 10          	sub    $0x10,%rsp
  803e54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e5b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803e5e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e65:	00 00 00 
  803e68:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e6b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803e6d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e74:	48 89 c6             	mov    %rax,%rsi
  803e77:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803e7e:	00 00 00 
  803e81:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  803e88:	00 00 00 
  803e8b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803e8d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e94:	00 00 00 
  803e97:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e9a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803e9d:	bf 02 00 00 00       	mov    $0x2,%edi
  803ea2:	48 b8 4c 3d 80 00 00 	movabs $0x803d4c,%rax
  803ea9:	00 00 00 
  803eac:	ff d0                	callq  *%rax
}
  803eae:	c9                   	leaveq 
  803eaf:	c3                   	retq   

0000000000803eb0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803eb0:	55                   	push   %rbp
  803eb1:	48 89 e5             	mov    %rsp,%rbp
  803eb4:	48 83 ec 10          	sub    $0x10,%rsp
  803eb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ebb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803ebe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ec5:	00 00 00 
  803ec8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ecb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803ecd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed4:	00 00 00 
  803ed7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803eda:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803edd:	bf 03 00 00 00       	mov    $0x3,%edi
  803ee2:	48 b8 4c 3d 80 00 00 	movabs $0x803d4c,%rax
  803ee9:	00 00 00 
  803eec:	ff d0                	callq  *%rax
}
  803eee:	c9                   	leaveq 
  803eef:	c3                   	retq   

0000000000803ef0 <nsipc_close>:

int
nsipc_close(int s)
{
  803ef0:	55                   	push   %rbp
  803ef1:	48 89 e5             	mov    %rsp,%rbp
  803ef4:	48 83 ec 10          	sub    $0x10,%rsp
  803ef8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803efb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f02:	00 00 00 
  803f05:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f08:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803f0a:	bf 04 00 00 00       	mov    $0x4,%edi
  803f0f:	48 b8 4c 3d 80 00 00 	movabs $0x803d4c,%rax
  803f16:	00 00 00 
  803f19:	ff d0                	callq  *%rax
}
  803f1b:	c9                   	leaveq 
  803f1c:	c3                   	retq   

0000000000803f1d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803f1d:	55                   	push   %rbp
  803f1e:	48 89 e5             	mov    %rsp,%rbp
  803f21:	48 83 ec 10          	sub    $0x10,%rsp
  803f25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f2c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803f2f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f36:	00 00 00 
  803f39:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f3c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803f3e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f45:	48 89 c6             	mov    %rax,%rsi
  803f48:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803f4f:	00 00 00 
  803f52:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  803f59:	00 00 00 
  803f5c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803f5e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f65:	00 00 00 
  803f68:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f6b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803f6e:	bf 05 00 00 00       	mov    $0x5,%edi
  803f73:	48 b8 4c 3d 80 00 00 	movabs $0x803d4c,%rax
  803f7a:	00 00 00 
  803f7d:	ff d0                	callq  *%rax
}
  803f7f:	c9                   	leaveq 
  803f80:	c3                   	retq   

0000000000803f81 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803f81:	55                   	push   %rbp
  803f82:	48 89 e5             	mov    %rsp,%rbp
  803f85:	48 83 ec 10          	sub    $0x10,%rsp
  803f89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f8c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803f8f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f96:	00 00 00 
  803f99:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f9c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803f9e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fa5:	00 00 00 
  803fa8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fab:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803fae:	bf 06 00 00 00       	mov    $0x6,%edi
  803fb3:	48 b8 4c 3d 80 00 00 	movabs $0x803d4c,%rax
  803fba:	00 00 00 
  803fbd:	ff d0                	callq  *%rax
}
  803fbf:	c9                   	leaveq 
  803fc0:	c3                   	retq   

0000000000803fc1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803fc1:	55                   	push   %rbp
  803fc2:	48 89 e5             	mov    %rsp,%rbp
  803fc5:	48 83 ec 30          	sub    $0x30,%rsp
  803fc9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fcc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fd0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803fd3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803fd6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fdd:	00 00 00 
  803fe0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803fe3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803fe5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fec:	00 00 00 
  803fef:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ff2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ff5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ffc:	00 00 00 
  803fff:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804002:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804005:	bf 07 00 00 00       	mov    $0x7,%edi
  80400a:	48 b8 4c 3d 80 00 00 	movabs $0x803d4c,%rax
  804011:	00 00 00 
  804014:	ff d0                	callq  *%rax
  804016:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804019:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401d:	78 69                	js     804088 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80401f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804026:	7f 08                	jg     804030 <nsipc_recv+0x6f>
  804028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80402e:	7e 35                	jle    804065 <nsipc_recv+0xa4>
  804030:	48 b9 c2 58 80 00 00 	movabs $0x8058c2,%rcx
  804037:	00 00 00 
  80403a:	48 ba d7 58 80 00 00 	movabs $0x8058d7,%rdx
  804041:	00 00 00 
  804044:	be 61 00 00 00       	mov    $0x61,%esi
  804049:	48 bf ec 58 80 00 00 	movabs $0x8058ec,%rdi
  804050:	00 00 00 
  804053:	b8 00 00 00 00       	mov    $0x0,%eax
  804058:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  80405f:	00 00 00 
  804062:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804065:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804068:	48 63 d0             	movslq %eax,%rdx
  80406b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80406f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804076:	00 00 00 
  804079:	48 89 c7             	mov    %rax,%rdi
  80407c:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  804083:	00 00 00 
  804086:	ff d0                	callq  *%rax
	}

	return r;
  804088:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80408b:	c9                   	leaveq 
  80408c:	c3                   	retq   

000000000080408d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80408d:	55                   	push   %rbp
  80408e:	48 89 e5             	mov    %rsp,%rbp
  804091:	48 83 ec 20          	sub    $0x20,%rsp
  804095:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804098:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80409c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80409f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8040a2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040a9:	00 00 00 
  8040ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040af:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8040b1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8040b8:	7e 35                	jle    8040ef <nsipc_send+0x62>
  8040ba:	48 b9 f8 58 80 00 00 	movabs $0x8058f8,%rcx
  8040c1:	00 00 00 
  8040c4:	48 ba d7 58 80 00 00 	movabs $0x8058d7,%rdx
  8040cb:	00 00 00 
  8040ce:	be 6c 00 00 00       	mov    $0x6c,%esi
  8040d3:	48 bf ec 58 80 00 00 	movabs $0x8058ec,%rdi
  8040da:	00 00 00 
  8040dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e2:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8040e9:	00 00 00 
  8040ec:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8040ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040f2:	48 63 d0             	movslq %eax,%rdx
  8040f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f9:	48 89 c6             	mov    %rax,%rsi
  8040fc:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804103:	00 00 00 
  804106:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  80410d:	00 00 00 
  804110:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804112:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804119:	00 00 00 
  80411c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80411f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804122:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804129:	00 00 00 
  80412c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80412f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804132:	bf 08 00 00 00       	mov    $0x8,%edi
  804137:	48 b8 4c 3d 80 00 00 	movabs $0x803d4c,%rax
  80413e:	00 00 00 
  804141:	ff d0                	callq  *%rax
}
  804143:	c9                   	leaveq 
  804144:	c3                   	retq   

0000000000804145 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804145:	55                   	push   %rbp
  804146:	48 89 e5             	mov    %rsp,%rbp
  804149:	48 83 ec 10          	sub    $0x10,%rsp
  80414d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804150:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804153:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804156:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80415d:	00 00 00 
  804160:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804163:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804165:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80416c:	00 00 00 
  80416f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804172:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804175:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80417c:	00 00 00 
  80417f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804182:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804185:	bf 09 00 00 00       	mov    $0x9,%edi
  80418a:	48 b8 4c 3d 80 00 00 	movabs $0x803d4c,%rax
  804191:	00 00 00 
  804194:	ff d0                	callq  *%rax
}
  804196:	c9                   	leaveq 
  804197:	c3                   	retq   

0000000000804198 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804198:	55                   	push   %rbp
  804199:	48 89 e5             	mov    %rsp,%rbp
  80419c:	53                   	push   %rbx
  80419d:	48 83 ec 38          	sub    $0x38,%rsp
  8041a1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8041a5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8041a9:	48 89 c7             	mov    %rax,%rdi
  8041ac:	48 b8 b2 2d 80 00 00 	movabs $0x802db2,%rax
  8041b3:	00 00 00 
  8041b6:	ff d0                	callq  *%rax
  8041b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041bf:	0f 88 bf 01 00 00    	js     804384 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041c9:	ba 07 04 00 00       	mov    $0x407,%edx
  8041ce:	48 89 c6             	mov    %rax,%rsi
  8041d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8041d6:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  8041dd:	00 00 00 
  8041e0:	ff d0                	callq  *%rax
  8041e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041e9:	0f 88 95 01 00 00    	js     804384 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8041ef:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8041f3:	48 89 c7             	mov    %rax,%rdi
  8041f6:	48 b8 b2 2d 80 00 00 	movabs $0x802db2,%rax
  8041fd:	00 00 00 
  804200:	ff d0                	callq  *%rax
  804202:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804205:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804209:	0f 88 5d 01 00 00    	js     80436c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80420f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804213:	ba 07 04 00 00       	mov    $0x407,%edx
  804218:	48 89 c6             	mov    %rax,%rsi
  80421b:	bf 00 00 00 00       	mov    $0x0,%edi
  804220:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  804227:	00 00 00 
  80422a:	ff d0                	callq  *%rax
  80422c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80422f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804233:	0f 88 33 01 00 00    	js     80436c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80423d:	48 89 c7             	mov    %rax,%rdi
  804240:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  804247:	00 00 00 
  80424a:	ff d0                	callq  *%rax
  80424c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804250:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804254:	ba 07 04 00 00       	mov    $0x407,%edx
  804259:	48 89 c6             	mov    %rax,%rsi
  80425c:	bf 00 00 00 00       	mov    $0x0,%edi
  804261:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  804268:	00 00 00 
  80426b:	ff d0                	callq  *%rax
  80426d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804270:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804274:	0f 88 d9 00 00 00    	js     804353 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80427a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80427e:	48 89 c7             	mov    %rax,%rdi
  804281:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  804288:	00 00 00 
  80428b:	ff d0                	callq  *%rax
  80428d:	48 89 c2             	mov    %rax,%rdx
  804290:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804294:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80429a:	48 89 d1             	mov    %rdx,%rcx
  80429d:	ba 00 00 00 00       	mov    $0x0,%edx
  8042a2:	48 89 c6             	mov    %rax,%rsi
  8042a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8042aa:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  8042b1:	00 00 00 
  8042b4:	ff d0                	callq  *%rax
  8042b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042bd:	78 79                	js     804338 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8042bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042c3:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8042ca:	00 00 00 
  8042cd:	8b 12                	mov    (%rdx),%edx
  8042cf:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8042d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8042dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042e0:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8042e7:	00 00 00 
  8042ea:	8b 12                	mov    (%rdx),%edx
  8042ec:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8042ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042f2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8042f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042fd:	48 89 c7             	mov    %rax,%rdi
  804300:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  804307:	00 00 00 
  80430a:	ff d0                	callq  *%rax
  80430c:	89 c2                	mov    %eax,%edx
  80430e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804312:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804314:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804318:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80431c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804320:	48 89 c7             	mov    %rax,%rdi
  804323:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  80432a:	00 00 00 
  80432d:	ff d0                	callq  *%rax
  80432f:	89 03                	mov    %eax,(%rbx)
	return 0;
  804331:	b8 00 00 00 00       	mov    $0x0,%eax
  804336:	eb 4f                	jmp    804387 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804338:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804339:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80433d:	48 89 c6             	mov    %rax,%rsi
  804340:	bf 00 00 00 00       	mov    $0x0,%edi
  804345:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  80434c:	00 00 00 
  80434f:	ff d0                	callq  *%rax
  804351:	eb 01                	jmp    804354 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804353:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804354:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804358:	48 89 c6             	mov    %rax,%rsi
  80435b:	bf 00 00 00 00       	mov    $0x0,%edi
  804360:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  804367:	00 00 00 
  80436a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80436c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804370:	48 89 c6             	mov    %rax,%rsi
  804373:	bf 00 00 00 00       	mov    $0x0,%edi
  804378:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  80437f:	00 00 00 
  804382:	ff d0                	callq  *%rax
err:
	return r;
  804384:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804387:	48 83 c4 38          	add    $0x38,%rsp
  80438b:	5b                   	pop    %rbx
  80438c:	5d                   	pop    %rbp
  80438d:	c3                   	retq   

000000000080438e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80438e:	55                   	push   %rbp
  80438f:	48 89 e5             	mov    %rsp,%rbp
  804392:	53                   	push   %rbx
  804393:	48 83 ec 28          	sub    $0x28,%rsp
  804397:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80439b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80439f:	eb 01                	jmp    8043a2 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8043a1:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8043a2:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8043a9:	00 00 00 
  8043ac:	48 8b 00             	mov    (%rax),%rax
  8043af:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8043b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8043b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043bc:	48 89 c7             	mov    %rax,%rdi
  8043bf:	48 b8 30 4b 80 00 00 	movabs $0x804b30,%rax
  8043c6:	00 00 00 
  8043c9:	ff d0                	callq  *%rax
  8043cb:	89 c3                	mov    %eax,%ebx
  8043cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043d1:	48 89 c7             	mov    %rax,%rdi
  8043d4:	48 b8 30 4b 80 00 00 	movabs $0x804b30,%rax
  8043db:	00 00 00 
  8043de:	ff d0                	callq  *%rax
  8043e0:	39 c3                	cmp    %eax,%ebx
  8043e2:	0f 94 c0             	sete   %al
  8043e5:	0f b6 c0             	movzbl %al,%eax
  8043e8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8043eb:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8043f2:	00 00 00 
  8043f5:	48 8b 00             	mov    (%rax),%rax
  8043f8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8043fe:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804401:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804404:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804407:	75 0a                	jne    804413 <_pipeisclosed+0x85>
			return ret;
  804409:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80440c:	48 83 c4 28          	add    $0x28,%rsp
  804410:	5b                   	pop    %rbx
  804411:	5d                   	pop    %rbp
  804412:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  804413:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804416:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804419:	74 86                	je     8043a1 <_pipeisclosed+0x13>
  80441b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80441f:	75 80                	jne    8043a1 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804421:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804428:	00 00 00 
  80442b:	48 8b 00             	mov    (%rax),%rax
  80442e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804434:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804437:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80443a:	89 c6                	mov    %eax,%esi
  80443c:	48 bf 09 59 80 00 00 	movabs $0x805909,%rdi
  804443:	00 00 00 
  804446:	b8 00 00 00 00       	mov    $0x0,%eax
  80444b:	49 b8 83 0b 80 00 00 	movabs $0x800b83,%r8
  804452:	00 00 00 
  804455:	41 ff d0             	callq  *%r8
	}
  804458:	e9 44 ff ff ff       	jmpq   8043a1 <_pipeisclosed+0x13>

000000000080445d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  80445d:	55                   	push   %rbp
  80445e:	48 89 e5             	mov    %rsp,%rbp
  804461:	48 83 ec 30          	sub    $0x30,%rsp
  804465:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804468:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80446c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80446f:	48 89 d6             	mov    %rdx,%rsi
  804472:	89 c7                	mov    %eax,%edi
  804474:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  80447b:	00 00 00 
  80447e:	ff d0                	callq  *%rax
  804480:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804483:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804487:	79 05                	jns    80448e <pipeisclosed+0x31>
		return r;
  804489:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80448c:	eb 31                	jmp    8044bf <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80448e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804492:	48 89 c7             	mov    %rax,%rdi
  804495:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  80449c:	00 00 00 
  80449f:	ff d0                	callq  *%rax
  8044a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8044a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044ad:	48 89 d6             	mov    %rdx,%rsi
  8044b0:	48 89 c7             	mov    %rax,%rdi
  8044b3:	48 b8 8e 43 80 00 00 	movabs $0x80438e,%rax
  8044ba:	00 00 00 
  8044bd:	ff d0                	callq  *%rax
}
  8044bf:	c9                   	leaveq 
  8044c0:	c3                   	retq   

00000000008044c1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044c1:	55                   	push   %rbp
  8044c2:	48 89 e5             	mov    %rsp,%rbp
  8044c5:	48 83 ec 40          	sub    $0x40,%rsp
  8044c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8044d1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8044d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044d9:	48 89 c7             	mov    %rax,%rdi
  8044dc:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  8044e3:	00 00 00 
  8044e6:	ff d0                	callq  *%rax
  8044e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8044ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8044f4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8044fb:	00 
  8044fc:	e9 97 00 00 00       	jmpq   804598 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804501:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804506:	74 09                	je     804511 <devpipe_read+0x50>
				return i;
  804508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450c:	e9 95 00 00 00       	jmpq   8045a6 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804511:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804515:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804519:	48 89 d6             	mov    %rdx,%rsi
  80451c:	48 89 c7             	mov    %rax,%rdi
  80451f:	48 b8 8e 43 80 00 00 	movabs $0x80438e,%rax
  804526:	00 00 00 
  804529:	ff d0                	callq  *%rax
  80452b:	85 c0                	test   %eax,%eax
  80452d:	74 07                	je     804536 <devpipe_read+0x75>
				return 0;
  80452f:	b8 00 00 00 00       	mov    $0x0,%eax
  804534:	eb 70                	jmp    8045a6 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804536:	48 b8 4e 20 80 00 00 	movabs $0x80204e,%rax
  80453d:	00 00 00 
  804540:	ff d0                	callq  *%rax
  804542:	eb 01                	jmp    804545 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804544:	90                   	nop
  804545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804549:	8b 10                	mov    (%rax),%edx
  80454b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454f:	8b 40 04             	mov    0x4(%rax),%eax
  804552:	39 c2                	cmp    %eax,%edx
  804554:	74 ab                	je     804501 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80455a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80455e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804566:	8b 00                	mov    (%rax),%eax
  804568:	89 c2                	mov    %eax,%edx
  80456a:	c1 fa 1f             	sar    $0x1f,%edx
  80456d:	c1 ea 1b             	shr    $0x1b,%edx
  804570:	01 d0                	add    %edx,%eax
  804572:	83 e0 1f             	and    $0x1f,%eax
  804575:	29 d0                	sub    %edx,%eax
  804577:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80457b:	48 98                	cltq   
  80457d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804582:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804584:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804588:	8b 00                	mov    (%rax),%eax
  80458a:	8d 50 01             	lea    0x1(%rax),%edx
  80458d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804591:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804593:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804598:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80459c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8045a0:	72 a2                	jb     804544 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8045a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8045a6:	c9                   	leaveq 
  8045a7:	c3                   	retq   

00000000008045a8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8045a8:	55                   	push   %rbp
  8045a9:	48 89 e5             	mov    %rsp,%rbp
  8045ac:	48 83 ec 40          	sub    $0x40,%rsp
  8045b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8045b8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8045bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045c0:	48 89 c7             	mov    %rax,%rdi
  8045c3:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  8045ca:	00 00 00 
  8045cd:	ff d0                	callq  *%rax
  8045cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8045d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8045db:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8045e2:	00 
  8045e3:	e9 93 00 00 00       	jmpq   80467b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8045e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045f0:	48 89 d6             	mov    %rdx,%rsi
  8045f3:	48 89 c7             	mov    %rax,%rdi
  8045f6:	48 b8 8e 43 80 00 00 	movabs $0x80438e,%rax
  8045fd:	00 00 00 
  804600:	ff d0                	callq  *%rax
  804602:	85 c0                	test   %eax,%eax
  804604:	74 07                	je     80460d <devpipe_write+0x65>
				return 0;
  804606:	b8 00 00 00 00       	mov    $0x0,%eax
  80460b:	eb 7c                	jmp    804689 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80460d:	48 b8 4e 20 80 00 00 	movabs $0x80204e,%rax
  804614:	00 00 00 
  804617:	ff d0                	callq  *%rax
  804619:	eb 01                	jmp    80461c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80461b:	90                   	nop
  80461c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804620:	8b 40 04             	mov    0x4(%rax),%eax
  804623:	48 63 d0             	movslq %eax,%rdx
  804626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80462a:	8b 00                	mov    (%rax),%eax
  80462c:	48 98                	cltq   
  80462e:	48 83 c0 20          	add    $0x20,%rax
  804632:	48 39 c2             	cmp    %rax,%rdx
  804635:	73 b1                	jae    8045e8 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80463b:	8b 40 04             	mov    0x4(%rax),%eax
  80463e:	89 c2                	mov    %eax,%edx
  804640:	c1 fa 1f             	sar    $0x1f,%edx
  804643:	c1 ea 1b             	shr    $0x1b,%edx
  804646:	01 d0                	add    %edx,%eax
  804648:	83 e0 1f             	and    $0x1f,%eax
  80464b:	29 d0                	sub    %edx,%eax
  80464d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804651:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804655:	48 01 ca             	add    %rcx,%rdx
  804658:	0f b6 0a             	movzbl (%rdx),%ecx
  80465b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80465f:	48 98                	cltq   
  804661:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804665:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804669:	8b 40 04             	mov    0x4(%rax),%eax
  80466c:	8d 50 01             	lea    0x1(%rax),%edx
  80466f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804673:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804676:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80467b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80467f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804683:	72 96                	jb     80461b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804689:	c9                   	leaveq 
  80468a:	c3                   	retq   

000000000080468b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80468b:	55                   	push   %rbp
  80468c:	48 89 e5             	mov    %rsp,%rbp
  80468f:	48 83 ec 20          	sub    $0x20,%rsp
  804693:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804697:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80469b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80469f:	48 89 c7             	mov    %rax,%rdi
  8046a2:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  8046a9:	00 00 00 
  8046ac:	ff d0                	callq  *%rax
  8046ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8046b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046b6:	48 be 1c 59 80 00 00 	movabs $0x80591c,%rsi
  8046bd:	00 00 00 
  8046c0:	48 89 c7             	mov    %rax,%rdi
  8046c3:	48 b8 54 17 80 00 00 	movabs $0x801754,%rax
  8046ca:	00 00 00 
  8046cd:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8046cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046d3:	8b 50 04             	mov    0x4(%rax),%edx
  8046d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046da:	8b 00                	mov    (%rax),%eax
  8046dc:	29 c2                	sub    %eax,%edx
  8046de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046e2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8046e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046ec:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8046f3:	00 00 00 
	stat->st_dev = &devpipe;
  8046f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046fa:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804701:	00 00 00 
  804704:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80470b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804710:	c9                   	leaveq 
  804711:	c3                   	retq   

0000000000804712 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804712:	55                   	push   %rbp
  804713:	48 89 e5             	mov    %rsp,%rbp
  804716:	48 83 ec 10          	sub    $0x10,%rsp
  80471a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80471e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804722:	48 89 c6             	mov    %rax,%rsi
  804725:	bf 00 00 00 00       	mov    $0x0,%edi
  80472a:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  804731:	00 00 00 
  804734:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804736:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80473a:	48 89 c7             	mov    %rax,%rdi
  80473d:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  804744:	00 00 00 
  804747:	ff d0                	callq  *%rax
  804749:	48 89 c6             	mov    %rax,%rsi
  80474c:	bf 00 00 00 00       	mov    $0x0,%edi
  804751:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  804758:	00 00 00 
  80475b:	ff d0                	callq  *%rax
}
  80475d:	c9                   	leaveq 
  80475e:	c3                   	retq   
	...

0000000000804760 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804760:	55                   	push   %rbp
  804761:	48 89 e5             	mov    %rsp,%rbp
  804764:	48 83 ec 20          	sub    $0x20,%rsp
  804768:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80476b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80476e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804771:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804775:	be 01 00 00 00       	mov    $0x1,%esi
  80477a:	48 89 c7             	mov    %rax,%rdi
  80477d:	48 b8 44 1f 80 00 00 	movabs $0x801f44,%rax
  804784:	00 00 00 
  804787:	ff d0                	callq  *%rax
}
  804789:	c9                   	leaveq 
  80478a:	c3                   	retq   

000000000080478b <getchar>:

int
getchar(void)
{
  80478b:	55                   	push   %rbp
  80478c:	48 89 e5             	mov    %rsp,%rbp
  80478f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804793:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804797:	ba 01 00 00 00       	mov    $0x1,%edx
  80479c:	48 89 c6             	mov    %rax,%rsi
  80479f:	bf 00 00 00 00       	mov    $0x0,%edi
  8047a4:	48 b8 7c 32 80 00 00 	movabs $0x80327c,%rax
  8047ab:	00 00 00 
  8047ae:	ff d0                	callq  *%rax
  8047b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8047b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047b7:	79 05                	jns    8047be <getchar+0x33>
		return r;
  8047b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047bc:	eb 14                	jmp    8047d2 <getchar+0x47>
	if (r < 1)
  8047be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047c2:	7f 07                	jg     8047cb <getchar+0x40>
		return -E_EOF;
  8047c4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8047c9:	eb 07                	jmp    8047d2 <getchar+0x47>
	return c;
  8047cb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8047cf:	0f b6 c0             	movzbl %al,%eax
}
  8047d2:	c9                   	leaveq 
  8047d3:	c3                   	retq   

00000000008047d4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8047d4:	55                   	push   %rbp
  8047d5:	48 89 e5             	mov    %rsp,%rbp
  8047d8:	48 83 ec 20          	sub    $0x20,%rsp
  8047dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8047df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8047e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047e6:	48 89 d6             	mov    %rdx,%rsi
  8047e9:	89 c7                	mov    %eax,%edi
  8047eb:	48 b8 4a 2e 80 00 00 	movabs $0x802e4a,%rax
  8047f2:	00 00 00 
  8047f5:	ff d0                	callq  *%rax
  8047f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047fe:	79 05                	jns    804805 <iscons+0x31>
		return r;
  804800:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804803:	eb 1a                	jmp    80481f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804809:	8b 10                	mov    (%rax),%edx
  80480b:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804812:	00 00 00 
  804815:	8b 00                	mov    (%rax),%eax
  804817:	39 c2                	cmp    %eax,%edx
  804819:	0f 94 c0             	sete   %al
  80481c:	0f b6 c0             	movzbl %al,%eax
}
  80481f:	c9                   	leaveq 
  804820:	c3                   	retq   

0000000000804821 <opencons>:

int
opencons(void)
{
  804821:	55                   	push   %rbp
  804822:	48 89 e5             	mov    %rsp,%rbp
  804825:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804829:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80482d:	48 89 c7             	mov    %rax,%rdi
  804830:	48 b8 b2 2d 80 00 00 	movabs $0x802db2,%rax
  804837:	00 00 00 
  80483a:	ff d0                	callq  *%rax
  80483c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80483f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804843:	79 05                	jns    80484a <opencons+0x29>
		return r;
  804845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804848:	eb 5b                	jmp    8048a5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80484a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80484e:	ba 07 04 00 00       	mov    $0x407,%edx
  804853:	48 89 c6             	mov    %rax,%rsi
  804856:	bf 00 00 00 00       	mov    $0x0,%edi
  80485b:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  804862:	00 00 00 
  804865:	ff d0                	callq  *%rax
  804867:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80486a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80486e:	79 05                	jns    804875 <opencons+0x54>
		return r;
  804870:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804873:	eb 30                	jmp    8048a5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804875:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804879:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804880:	00 00 00 
  804883:	8b 12                	mov    (%rdx),%edx
  804885:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80488b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804892:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804896:	48 89 c7             	mov    %rax,%rdi
  804899:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  8048a0:	00 00 00 
  8048a3:	ff d0                	callq  *%rax
}
  8048a5:	c9                   	leaveq 
  8048a6:	c3                   	retq   

00000000008048a7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8048a7:	55                   	push   %rbp
  8048a8:	48 89 e5             	mov    %rsp,%rbp
  8048ab:	48 83 ec 30          	sub    $0x30,%rsp
  8048af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8048b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8048b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8048bb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048c0:	75 13                	jne    8048d5 <devcons_read+0x2e>
		return 0;
  8048c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8048c7:	eb 49                	jmp    804912 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8048c9:	48 b8 4e 20 80 00 00 	movabs $0x80204e,%rax
  8048d0:	00 00 00 
  8048d3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8048d5:	48 b8 8e 1f 80 00 00 	movabs $0x801f8e,%rax
  8048dc:	00 00 00 
  8048df:	ff d0                	callq  *%rax
  8048e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048e8:	74 df                	je     8048c9 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8048ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048ee:	79 05                	jns    8048f5 <devcons_read+0x4e>
		return c;
  8048f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f3:	eb 1d                	jmp    804912 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8048f5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8048f9:	75 07                	jne    804902 <devcons_read+0x5b>
		return 0;
  8048fb:	b8 00 00 00 00       	mov    $0x0,%eax
  804900:	eb 10                	jmp    804912 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804902:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804905:	89 c2                	mov    %eax,%edx
  804907:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80490b:	88 10                	mov    %dl,(%rax)
	return 1;
  80490d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804912:	c9                   	leaveq 
  804913:	c3                   	retq   

0000000000804914 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804914:	55                   	push   %rbp
  804915:	48 89 e5             	mov    %rsp,%rbp
  804918:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80491f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804926:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80492d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804934:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80493b:	eb 77                	jmp    8049b4 <devcons_write+0xa0>
		m = n - tot;
  80493d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804944:	89 c2                	mov    %eax,%edx
  804946:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804949:	89 d1                	mov    %edx,%ecx
  80494b:	29 c1                	sub    %eax,%ecx
  80494d:	89 c8                	mov    %ecx,%eax
  80494f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804952:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804955:	83 f8 7f             	cmp    $0x7f,%eax
  804958:	76 07                	jbe    804961 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80495a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804961:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804964:	48 63 d0             	movslq %eax,%rdx
  804967:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80496a:	48 98                	cltq   
  80496c:	48 89 c1             	mov    %rax,%rcx
  80496f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804976:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80497d:	48 89 ce             	mov    %rcx,%rsi
  804980:	48 89 c7             	mov    %rax,%rdi
  804983:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  80498a:	00 00 00 
  80498d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80498f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804992:	48 63 d0             	movslq %eax,%rdx
  804995:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80499c:	48 89 d6             	mov    %rdx,%rsi
  80499f:	48 89 c7             	mov    %rax,%rdi
  8049a2:	48 b8 44 1f 80 00 00 	movabs $0x801f44,%rax
  8049a9:	00 00 00 
  8049ac:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8049ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049b1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8049b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049b7:	48 98                	cltq   
  8049b9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8049c0:	0f 82 77 ff ff ff    	jb     80493d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8049c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8049c9:	c9                   	leaveq 
  8049ca:	c3                   	retq   

00000000008049cb <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8049cb:	55                   	push   %rbp
  8049cc:	48 89 e5             	mov    %rsp,%rbp
  8049cf:	48 83 ec 08          	sub    $0x8,%rsp
  8049d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8049d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049dc:	c9                   	leaveq 
  8049dd:	c3                   	retq   

00000000008049de <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8049de:	55                   	push   %rbp
  8049df:	48 89 e5             	mov    %rsp,%rbp
  8049e2:	48 83 ec 10          	sub    $0x10,%rsp
  8049e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8049ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8049ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049f2:	48 be 28 59 80 00 00 	movabs $0x805928,%rsi
  8049f9:	00 00 00 
  8049fc:	48 89 c7             	mov    %rax,%rdi
  8049ff:	48 b8 54 17 80 00 00 	movabs $0x801754,%rax
  804a06:	00 00 00 
  804a09:	ff d0                	callq  *%rax
	return 0;
  804a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a10:	c9                   	leaveq 
  804a11:	c3                   	retq   
	...

0000000000804a14 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804a14:	55                   	push   %rbp
  804a15:	48 89 e5             	mov    %rsp,%rbp
  804a18:	48 83 ec 10          	sub    $0x10,%rsp
  804a1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804a20:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a27:	00 00 00 
  804a2a:	48 8b 00             	mov    (%rax),%rax
  804a2d:	48 85 c0             	test   %rax,%rax
  804a30:	75 66                	jne    804a98 <set_pgfault_handler+0x84>
		// First time through!
		// LAB 4: Your code here.
		if(sys_page_alloc(0, (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P) == 0)
  804a32:	ba 07 00 00 00       	mov    $0x7,%edx
  804a37:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804a3c:	bf 00 00 00 00       	mov    $0x0,%edi
  804a41:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  804a48:	00 00 00 
  804a4b:	ff d0                	callq  *%rax
  804a4d:	85 c0                	test   %eax,%eax
  804a4f:	75 1d                	jne    804a6e <set_pgfault_handler+0x5a>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804a51:	48 be ac 4a 80 00 00 	movabs $0x804aac,%rsi
  804a58:	00 00 00 
  804a5b:	bf 00 00 00 00       	mov    $0x0,%edi
  804a60:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  804a67:	00 00 00 
  804a6a:	ff d0                	callq  *%rax
  804a6c:	eb 2a                	jmp    804a98 <set_pgfault_handler+0x84>
		else
			panic("set_pgfault_handler no memory");
  804a6e:	48 ba 2f 59 80 00 00 	movabs $0x80592f,%rdx
  804a75:	00 00 00 
  804a78:	be 23 00 00 00       	mov    $0x23,%esi
  804a7d:	48 bf 4d 59 80 00 00 	movabs $0x80594d,%rdi
  804a84:	00 00 00 
  804a87:	b8 00 00 00 00       	mov    $0x0,%eax
  804a8c:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  804a93:	00 00 00 
  804a96:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804a98:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a9f:	00 00 00 
  804aa2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804aa6:	48 89 10             	mov    %rdx,(%rax)
}
  804aa9:	c9                   	leaveq 
  804aaa:	c3                   	retq   
	...

0000000000804aac <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804aac:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804aaf:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804ab6:	00 00 00 
call *%rax
  804ab9:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

addq $16,%rsp /* to skip fault_va and error code (not needed) */
  804abb:	48 83 c4 10          	add    $0x10,%rsp

/* from rsp which is pointing to fault_va which is the 8 for fault_va, 8 for error_code, 120 positions is occupied by regs, 8 for eflags and 8 for rip */

movq 120(%rsp), %r10 /*RIP*/
  804abf:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
movq 136(%rsp), %r11 /*RSP*/
  804ac4:	4c 8b 9c 24 88 00 00 	mov    0x88(%rsp),%r11
  804acb:	00 

subq $8, %r11  /*to push the value of the rip to timetrap rsp, subtract and then push*/
  804acc:	49 83 eb 08          	sub    $0x8,%r11
movq %r10, (%r11) /*transfer RIP to the trap time RSP% */
  804ad0:	4d 89 13             	mov    %r10,(%r11)
movq %r11, 136(%rsp)  /*Putting the RSP back in the right place*/
  804ad3:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  804ada:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.

POPA_ /* already skipped the fault_va and error_code previously by adding 16, so just pop using the macro*/
  804adb:	4c 8b 3c 24          	mov    (%rsp),%r15
  804adf:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804ae4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804ae9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804aee:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804af3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804af8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804afd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804b02:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804b07:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804b0c:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804b11:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804b16:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804b1b:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804b20:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804b25:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
	
addq $8, %rsp /* go to eflags skipping rip*/
  804b29:	48 83 c4 08          	add    $0x8,%rsp
popfq /*pop the flags*/ 
  804b2d:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.

popq %rsp /* already at the point of rsp. so just pop.*/
  804b2e:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.

ret
  804b2f:	c3                   	retq   

0000000000804b30 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804b30:	55                   	push   %rbp
  804b31:	48 89 e5             	mov    %rsp,%rbp
  804b34:	48 83 ec 18          	sub    $0x18,%rsp
  804b38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b40:	48 89 c2             	mov    %rax,%rdx
  804b43:	48 c1 ea 15          	shr    $0x15,%rdx
  804b47:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804b4e:	01 00 00 
  804b51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b55:	83 e0 01             	and    $0x1,%eax
  804b58:	48 85 c0             	test   %rax,%rax
  804b5b:	75 07                	jne    804b64 <pageref+0x34>
		return 0;
  804b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  804b62:	eb 53                	jmp    804bb7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804b64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b68:	48 89 c2             	mov    %rax,%rdx
  804b6b:	48 c1 ea 0c          	shr    $0xc,%rdx
  804b6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804b76:	01 00 00 
  804b79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b7d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804b81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b85:	83 e0 01             	and    $0x1,%eax
  804b88:	48 85 c0             	test   %rax,%rax
  804b8b:	75 07                	jne    804b94 <pageref+0x64>
		return 0;
  804b8d:	b8 00 00 00 00       	mov    $0x0,%eax
  804b92:	eb 23                	jmp    804bb7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804b94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b98:	48 89 c2             	mov    %rax,%rdx
  804b9b:	48 c1 ea 0c          	shr    $0xc,%rdx
  804b9f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ba6:	00 00 00 
  804ba9:	48 c1 e2 04          	shl    $0x4,%rdx
  804bad:	48 01 d0             	add    %rdx,%rax
  804bb0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804bb4:	0f b7 c0             	movzwl %ax,%eax
}
  804bb7:	c9                   	leaveq 
  804bb8:	c3                   	retq   
  804bb9:	00 00                	add    %al,(%rax)
	...

0000000000804bbc <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804bbc:	55                   	push   %rbp
  804bbd:	48 89 e5             	mov    %rsp,%rbp
  804bc0:	48 83 ec 20          	sub    $0x20,%rsp
  804bc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804bc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804bcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804bd0:	48 89 d6             	mov    %rdx,%rsi
  804bd3:	48 89 c7             	mov    %rax,%rdi
  804bd6:	48 b8 f2 4b 80 00 00 	movabs $0x804bf2,%rax
  804bdd:	00 00 00 
  804be0:	ff d0                	callq  *%rax
  804be2:	85 c0                	test   %eax,%eax
  804be4:	74 05                	je     804beb <inet_addr+0x2f>
    return (val.s_addr);
  804be6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804be9:	eb 05                	jmp    804bf0 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804beb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  804bf0:	c9                   	leaveq 
  804bf1:	c3                   	retq   

0000000000804bf2 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804bf2:	55                   	push   %rbp
  804bf3:	48 89 e5             	mov    %rsp,%rbp
  804bf6:	53                   	push   %rbx
  804bf7:	48 83 ec 48          	sub    $0x48,%rsp
  804bfb:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  804bff:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804c03:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804c07:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

  c = *cp;
  804c0b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804c0f:	0f b6 00             	movzbl (%rax),%eax
  804c12:	0f be c0             	movsbl %al,%eax
  804c15:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804c18:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c1b:	3c 2f                	cmp    $0x2f,%al
  804c1d:	76 07                	jbe    804c26 <inet_aton+0x34>
  804c1f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c22:	3c 39                	cmp    $0x39,%al
  804c24:	76 0a                	jbe    804c30 <inet_aton+0x3e>
      return (0);
  804c26:	b8 00 00 00 00       	mov    $0x0,%eax
  804c2b:	e9 6a 02 00 00       	jmpq   804e9a <inet_aton+0x2a8>
    val = 0;
  804c30:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    base = 10;
  804c37:	c7 45 e8 0a 00 00 00 	movl   $0xa,-0x18(%rbp)
    if (c == '0') {
  804c3e:	83 7d e4 30          	cmpl   $0x30,-0x1c(%rbp)
  804c42:	75 40                	jne    804c84 <inet_aton+0x92>
      c = *++cp;
  804c44:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804c49:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804c4d:	0f b6 00             	movzbl (%rax),%eax
  804c50:	0f be c0             	movsbl %al,%eax
  804c53:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if (c == 'x' || c == 'X') {
  804c56:	83 7d e4 78          	cmpl   $0x78,-0x1c(%rbp)
  804c5a:	74 06                	je     804c62 <inet_aton+0x70>
  804c5c:	83 7d e4 58          	cmpl   $0x58,-0x1c(%rbp)
  804c60:	75 1b                	jne    804c7d <inet_aton+0x8b>
        base = 16;
  804c62:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%rbp)
        c = *++cp;
  804c69:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804c6e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804c72:	0f b6 00             	movzbl (%rax),%eax
  804c75:	0f be c0             	movsbl %al,%eax
  804c78:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  804c7b:	eb 07                	jmp    804c84 <inet_aton+0x92>
      } else
        base = 8;
  804c7d:	c7 45 e8 08 00 00 00 	movl   $0x8,-0x18(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804c84:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c87:	3c 2f                	cmp    $0x2f,%al
  804c89:	76 2f                	jbe    804cba <inet_aton+0xc8>
  804c8b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c8e:	3c 39                	cmp    $0x39,%al
  804c90:	77 28                	ja     804cba <inet_aton+0xc8>
        val = (val * base) + (int)(c - '0');
  804c92:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c95:	89 c2                	mov    %eax,%edx
  804c97:	0f af 55 ec          	imul   -0x14(%rbp),%edx
  804c9b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c9e:	01 d0                	add    %edx,%eax
  804ca0:	83 e8 30             	sub    $0x30,%eax
  804ca3:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  804ca6:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804cab:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804caf:	0f b6 00             	movzbl (%rax),%eax
  804cb2:	0f be c0             	movsbl %al,%eax
  804cb5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804cb8:	eb ca                	jmp    804c84 <inet_aton+0x92>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804cba:	83 7d e8 10          	cmpl   $0x10,-0x18(%rbp)
  804cbe:	75 74                	jne    804d34 <inet_aton+0x142>
  804cc0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cc3:	3c 2f                	cmp    $0x2f,%al
  804cc5:	76 07                	jbe    804cce <inet_aton+0xdc>
  804cc7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cca:	3c 39                	cmp    $0x39,%al
  804ccc:	76 1c                	jbe    804cea <inet_aton+0xf8>
  804cce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cd1:	3c 60                	cmp    $0x60,%al
  804cd3:	76 07                	jbe    804cdc <inet_aton+0xea>
  804cd5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cd8:	3c 66                	cmp    $0x66,%al
  804cda:	76 0e                	jbe    804cea <inet_aton+0xf8>
  804cdc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cdf:	3c 40                	cmp    $0x40,%al
  804ce1:	76 51                	jbe    804d34 <inet_aton+0x142>
  804ce3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ce6:	3c 46                	cmp    $0x46,%al
  804ce8:	77 4a                	ja     804d34 <inet_aton+0x142>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804cea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ced:	89 c2                	mov    %eax,%edx
  804cef:	c1 e2 04             	shl    $0x4,%edx
  804cf2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cf5:	8d 48 0a             	lea    0xa(%rax),%ecx
  804cf8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cfb:	3c 60                	cmp    $0x60,%al
  804cfd:	76 0e                	jbe    804d0d <inet_aton+0x11b>
  804cff:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804d02:	3c 7a                	cmp    $0x7a,%al
  804d04:	77 07                	ja     804d0d <inet_aton+0x11b>
  804d06:	b8 61 00 00 00       	mov    $0x61,%eax
  804d0b:	eb 05                	jmp    804d12 <inet_aton+0x120>
  804d0d:	b8 41 00 00 00       	mov    $0x41,%eax
  804d12:	89 cb                	mov    %ecx,%ebx
  804d14:	29 c3                	sub    %eax,%ebx
  804d16:	89 d8                	mov    %ebx,%eax
  804d18:	09 d0                	or     %edx,%eax
  804d1a:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  804d1d:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804d22:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804d26:	0f b6 00             	movzbl (%rax),%eax
  804d29:	0f be c0             	movsbl %al,%eax
  804d2c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else
        break;
    }
  804d2f:	e9 50 ff ff ff       	jmpq   804c84 <inet_aton+0x92>
    if (c == '.') {
  804d34:	83 7d e4 2e          	cmpl   $0x2e,-0x1c(%rbp)
  804d38:	75 3d                	jne    804d77 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804d3a:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804d3e:	48 83 c0 0c          	add    $0xc,%rax
  804d42:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  804d46:	72 0a                	jb     804d52 <inet_aton+0x160>
        return (0);
  804d48:	b8 00 00 00 00       	mov    $0x0,%eax
  804d4d:	e9 48 01 00 00       	jmpq   804e9a <inet_aton+0x2a8>
      *pp++ = val;
  804d52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d56:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804d59:	89 10                	mov    %edx,(%rax)
  804d5b:	48 83 45 d8 04       	addq   $0x4,-0x28(%rbp)
      c = *++cp;
  804d60:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804d65:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804d69:	0f b6 00             	movzbl (%rax),%eax
  804d6c:	0f be c0             	movsbl %al,%eax
  804d6f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    } else
      break;
  }
  804d72:	e9 a1 fe ff ff       	jmpq   804c18 <inet_aton+0x26>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  804d77:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804d78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804d7c:	74 3c                	je     804dba <inet_aton+0x1c8>
  804d7e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804d81:	3c 1f                	cmp    $0x1f,%al
  804d83:	76 2b                	jbe    804db0 <inet_aton+0x1be>
  804d85:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804d88:	84 c0                	test   %al,%al
  804d8a:	78 24                	js     804db0 <inet_aton+0x1be>
  804d8c:	83 7d e4 20          	cmpl   $0x20,-0x1c(%rbp)
  804d90:	74 28                	je     804dba <inet_aton+0x1c8>
  804d92:	83 7d e4 0c          	cmpl   $0xc,-0x1c(%rbp)
  804d96:	74 22                	je     804dba <inet_aton+0x1c8>
  804d98:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  804d9c:	74 1c                	je     804dba <inet_aton+0x1c8>
  804d9e:	83 7d e4 0d          	cmpl   $0xd,-0x1c(%rbp)
  804da2:	74 16                	je     804dba <inet_aton+0x1c8>
  804da4:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  804da8:	74 10                	je     804dba <inet_aton+0x1c8>
  804daa:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%rbp)
  804dae:	74 0a                	je     804dba <inet_aton+0x1c8>
    return (0);
  804db0:	b8 00 00 00 00       	mov    $0x0,%eax
  804db5:	e9 e0 00 00 00       	jmpq   804e9a <inet_aton+0x2a8>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804dba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804dbe:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804dc2:	48 89 d1             	mov    %rdx,%rcx
  804dc5:	48 29 c1             	sub    %rax,%rcx
  804dc8:	48 89 c8             	mov    %rcx,%rax
  804dcb:	48 c1 f8 02          	sar    $0x2,%rax
  804dcf:	83 c0 01             	add    $0x1,%eax
  804dd2:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  switch (n) {
  804dd5:	83 7d d4 04          	cmpl   $0x4,-0x2c(%rbp)
  804dd9:	0f 87 98 00 00 00    	ja     804e77 <inet_aton+0x285>
  804ddf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804de2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804de9:	00 
  804dea:	48 b8 60 59 80 00 00 	movabs $0x805960,%rax
  804df1:	00 00 00 
  804df4:	48 01 d0             	add    %rdx,%rax
  804df7:	48 8b 00             	mov    (%rax),%rax
  804dfa:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  804e01:	e9 94 00 00 00       	jmpq   804e9a <inet_aton+0x2a8>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804e06:	81 7d ec ff ff ff 00 	cmpl   $0xffffff,-0x14(%rbp)
  804e0d:	76 0a                	jbe    804e19 <inet_aton+0x227>
      return (0);
  804e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  804e14:	e9 81 00 00 00       	jmpq   804e9a <inet_aton+0x2a8>
    val |= parts[0] << 24;
  804e19:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804e1c:	c1 e0 18             	shl    $0x18,%eax
  804e1f:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804e22:	eb 53                	jmp    804e77 <inet_aton+0x285>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804e24:	81 7d ec ff ff 00 00 	cmpl   $0xffff,-0x14(%rbp)
  804e2b:	76 07                	jbe    804e34 <inet_aton+0x242>
      return (0);
  804e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  804e32:	eb 66                	jmp    804e9a <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804e34:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804e37:	89 c2                	mov    %eax,%edx
  804e39:	c1 e2 18             	shl    $0x18,%edx
  804e3c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804e3f:	c1 e0 10             	shl    $0x10,%eax
  804e42:	09 d0                	or     %edx,%eax
  804e44:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804e47:	eb 2e                	jmp    804e77 <inet_aton+0x285>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804e49:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%rbp)
  804e50:	76 07                	jbe    804e59 <inet_aton+0x267>
      return (0);
  804e52:	b8 00 00 00 00       	mov    $0x0,%eax
  804e57:	eb 41                	jmp    804e9a <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804e59:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804e5c:	89 c2                	mov    %eax,%edx
  804e5e:	c1 e2 18             	shl    $0x18,%edx
  804e61:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804e64:	c1 e0 10             	shl    $0x10,%eax
  804e67:	09 c2                	or     %eax,%edx
  804e69:	8b 45 c8             	mov    -0x38(%rbp),%eax
  804e6c:	c1 e0 08             	shl    $0x8,%eax
  804e6f:	09 d0                	or     %edx,%eax
  804e71:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804e74:	eb 01                	jmp    804e77 <inet_aton+0x285>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  804e76:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804e77:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  804e7c:	74 17                	je     804e95 <inet_aton+0x2a3>
    addr->s_addr = htonl(val);
  804e7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e81:	89 c7                	mov    %eax,%edi
  804e83:	48 b8 09 50 80 00 00 	movabs $0x805009,%rax
  804e8a:	00 00 00 
  804e8d:	ff d0                	callq  *%rax
  804e8f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  804e93:	89 02                	mov    %eax,(%rdx)
  return (1);
  804e95:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804e9a:	48 83 c4 48          	add    $0x48,%rsp
  804e9e:	5b                   	pop    %rbx
  804e9f:	5d                   	pop    %rbp
  804ea0:	c3                   	retq   

0000000000804ea1 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804ea1:	55                   	push   %rbp
  804ea2:	48 89 e5             	mov    %rsp,%rbp
  804ea5:	48 83 ec 30          	sub    $0x30,%rsp
  804ea9:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804eac:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804eaf:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804eb2:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804eb9:	00 00 00 
  804ebc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804ec0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804ec4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804ec8:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804ecc:	e9 d1 00 00 00       	jmpq   804fa2 <inet_ntoa+0x101>
    i = 0;
  804ed1:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  804ed5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ed9:	0f b6 08             	movzbl (%rax),%ecx
  804edc:	0f b6 d1             	movzbl %cl,%edx
  804edf:	89 d0                	mov    %edx,%eax
  804ee1:	c1 e0 02             	shl    $0x2,%eax
  804ee4:	01 d0                	add    %edx,%eax
  804ee6:	c1 e0 03             	shl    $0x3,%eax
  804ee9:	01 d0                	add    %edx,%eax
  804eeb:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804ef2:	01 d0                	add    %edx,%eax
  804ef4:	66 c1 e8 08          	shr    $0x8,%ax
  804ef8:	c0 e8 03             	shr    $0x3,%al
  804efb:	88 45 ed             	mov    %al,-0x13(%rbp)
  804efe:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804f02:	89 d0                	mov    %edx,%eax
  804f04:	c1 e0 02             	shl    $0x2,%eax
  804f07:	01 d0                	add    %edx,%eax
  804f09:	01 c0                	add    %eax,%eax
  804f0b:	89 ca                	mov    %ecx,%edx
  804f0d:	28 c2                	sub    %al,%dl
  804f0f:	89 d0                	mov    %edx,%eax
  804f11:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  804f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f18:	0f b6 00             	movzbl (%rax),%eax
  804f1b:	0f b6 d0             	movzbl %al,%edx
  804f1e:	89 d0                	mov    %edx,%eax
  804f20:	c1 e0 02             	shl    $0x2,%eax
  804f23:	01 d0                	add    %edx,%eax
  804f25:	c1 e0 03             	shl    $0x3,%eax
  804f28:	01 d0                	add    %edx,%eax
  804f2a:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804f31:	01 d0                	add    %edx,%eax
  804f33:	66 c1 e8 08          	shr    $0x8,%ax
  804f37:	89 c2                	mov    %eax,%edx
  804f39:	c0 ea 03             	shr    $0x3,%dl
  804f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f40:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804f42:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804f46:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804f4a:	83 c2 30             	add    $0x30,%edx
  804f4d:	48 98                	cltq   
  804f4f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
  804f53:	80 45 ee 01          	addb   $0x1,-0x12(%rbp)
    } while(*ap);
  804f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f5b:	0f b6 00             	movzbl (%rax),%eax
  804f5e:	84 c0                	test   %al,%al
  804f60:	0f 85 6f ff ff ff    	jne    804ed5 <inet_ntoa+0x34>
    while(i--)
  804f66:	eb 16                	jmp    804f7e <inet_ntoa+0xdd>
      *rp++ = inv[i];
  804f68:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804f6c:	48 98                	cltq   
  804f6e:	0f b6 54 05 e0       	movzbl -0x20(%rbp,%rax,1),%edx
  804f73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f77:	88 10                	mov    %dl,(%rax)
  804f79:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  804f7e:	80 7d ee 00          	cmpb   $0x0,-0x12(%rbp)
  804f82:	0f 95 c0             	setne  %al
  804f85:	80 6d ee 01          	subb   $0x1,-0x12(%rbp)
  804f89:	84 c0                	test   %al,%al
  804f8b:	75 db                	jne    804f68 <inet_ntoa+0xc7>
      *rp++ = inv[i];
    *rp++ = '.';
  804f8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f91:	c6 00 2e             	movb   $0x2e,(%rax)
  804f94:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    ap++;
  804f99:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  804f9e:	80 45 ef 01          	addb   $0x1,-0x11(%rbp)
  804fa2:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  804fa6:	0f 86 25 ff ff ff    	jbe    804ed1 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804fac:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804fb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804fb5:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804fb8:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804fbf:	00 00 00 
}
  804fc2:	c9                   	leaveq 
  804fc3:	c3                   	retq   

0000000000804fc4 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804fc4:	55                   	push   %rbp
  804fc5:	48 89 e5             	mov    %rsp,%rbp
  804fc8:	48 83 ec 08          	sub    $0x8,%rsp
  804fcc:	89 f8                	mov    %edi,%eax
  804fce:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804fd2:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804fd6:	c1 e0 08             	shl    $0x8,%eax
  804fd9:	89 c2                	mov    %eax,%edx
  804fdb:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804fdf:	66 c1 e8 08          	shr    $0x8,%ax
  804fe3:	09 d0                	or     %edx,%eax
}
  804fe5:	c9                   	leaveq 
  804fe6:	c3                   	retq   

0000000000804fe7 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804fe7:	55                   	push   %rbp
  804fe8:	48 89 e5             	mov    %rsp,%rbp
  804feb:	48 83 ec 08          	sub    $0x8,%rsp
  804fef:	89 f8                	mov    %edi,%eax
  804ff1:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  804ff5:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804ff9:	89 c7                	mov    %eax,%edi
  804ffb:	48 b8 c4 4f 80 00 00 	movabs $0x804fc4,%rax
  805002:	00 00 00 
  805005:	ff d0                	callq  *%rax
}
  805007:	c9                   	leaveq 
  805008:	c3                   	retq   

0000000000805009 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  805009:	55                   	push   %rbp
  80500a:	48 89 e5             	mov    %rsp,%rbp
  80500d:	48 83 ec 08          	sub    $0x8,%rsp
  805011:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  805014:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805017:	89 c2                	mov    %eax,%edx
  805019:	c1 e2 18             	shl    $0x18,%edx
    ((n & 0xff00) << 8) |
  80501c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80501f:	25 00 ff 00 00       	and    $0xff00,%eax
  805024:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805027:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  805029:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80502c:	25 00 00 ff 00       	and    $0xff0000,%eax
  805031:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805035:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  805037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80503a:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80503d:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80503f:	c9                   	leaveq 
  805040:	c3                   	retq   

0000000000805041 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  805041:	55                   	push   %rbp
  805042:	48 89 e5             	mov    %rsp,%rbp
  805045:	48 83 ec 08          	sub    $0x8,%rsp
  805049:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  80504c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80504f:	89 c7                	mov    %eax,%edi
  805051:	48 b8 09 50 80 00 00 	movabs $0x805009,%rax
  805058:	00 00 00 
  80505b:	ff d0                	callq  *%rax
}
  80505d:	c9                   	leaveq 
  80505e:	c3                   	retq   
