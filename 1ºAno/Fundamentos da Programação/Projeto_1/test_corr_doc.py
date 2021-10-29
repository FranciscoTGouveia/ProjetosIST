import unittest
import projeto


class TestCorrecao(unittest.TestCase):
    #Capitulo 1
    def test_corrigir_palavra(self):
        self.assertEqual(projeto.corrigir_palavra("aAxbB"), "x")
        self.assertEqual(projeto.corrigir_palavra("cCdatabasacCADde"), "database")
        self.assertEqual(projeto.corrigir_palavra("AafqQrBbaAanciscCcoOo"), "francisco")

    def test_anagrama(self):
        self.assertEqual(projeto.eh_anagrama("caso", "SaCo"), True)
        self.assertEqual(projeto.eh_anagrama("caso", "casos"), False)
        self.assertEqual(projeto.eh_anagrama("caso", "caso"), True)
        self.assertEqual(projeto.eh_anagrama("casO", "Caso"), True)
        self.assertEqual(projeto.eh_anagrama("moLHO", "melhO"), False)
        self.assertEqual(projeto.eh_anagrama("LaGo", "gAlO"), True)
        self.assertEqual(projeto.eh_anagrama("objetos", "bojetos"), True)
        self.assertEqual(projeto.eh_anagrama("souvenir", "universo"), True)

    def test_corrigir_doc(self):
        self.assertRaises(ValueError, projeto.corrigir_doc, "???")
        self.assertRaises(ValueError, projeto.corrigir_doc, "")
        self.assertRaises(ValueError, projeto.corrigir_doc, " ")
        self.assertRaises(ValueError, projeto.corrigir_doc, [1,2,3,4])
        self.assertRaises(ValueError, projeto.corrigir_doc, (1,2,3,4))
        self.assertRaises(ValueError, projeto.corrigir_doc, "al0 co3m es5as")
        self.assertRaises(ValueError, projeto.corrigir_doc, 1)
        self.assertEqual(projeto.corrigir_doc("BuAaXOoxiIKoOkggyrFfhHXxR duJjUTtaCcmMtaAGga \
eEMmtxXOjUuJQqQHhqoada JlLjbaoOsuUeYy cChgGvValLCwMmWBbclLsNn \
LyYlMmwmMrRrongTtoOkyYcCK daRfFKkLlhHrtZKqQkkvVKza"), "Buggy data base has wrong data")
        self.assertRaises(ValueError, projeto.corrigir_doc, "Dois  espaços")
        self.assertRaises(ValueError, projeto.corrigir_doc, "letr4s e numer0s")
        self.assertEqual(projeto.corrigir_doc("Programacao Programacao porgramacao"), "Programacao Programacao")
        self.assertEqual(projeto.corrigir_doc("Programacao com objetos e bojetos"), "Programacao com objetos e")
        self.assertEqual(projeto.corrigir_doc("Era la suma souvenir del universo la inmaculada briosa y sobria marioneta danesa de adanes"), "Era la suma souvenir del la inmaculada briosa y marioneta danesa de")
        self.assertEqual(projeto.corrigir_doc("Programacao porgramacao e programacao"), "Programacao e programacao")
        self.assertEqual(projeto.corrigir_doc("ProgtBbTrajJmagGcaGgo FfZqQzcmYyQSsqMomPZzUuERraAJjep JjFfqQobjKkuUkKetQqSspPCcAaEeovVTtSvVtTvVss eMmlxqQXOoIiLLlOo XxbhHodDWwjejJtwWoOos"), "Programacao com objetos e")
        self.assertEqual(projeto.corrigir_doc("FuKknfbBFdamvVEIicCeetTntUJjuos DddBfFbrRQKkquUlLNnajJ NnzZPnNrBbbBdDogDvVdrwoOWamTtaSfFscwkKWaouUtbBTKQqk"), "Fundamentos da Programacao")
        self.assertEqual(projeto.corrigir_doc("ErgGAaxXrRhVvHsSUuJjapPnN WwNnXxgGXxlLMmYyla sgGAauOyEeYoTtmsSoOwkKWaGg CtTcpiIPZJcCjzShHkKsBbmuzVvzZkKdBbDZGgYyszZa sNnjoOJbBTtouvenXxCTtcidDr HGguUYyhdBaAbPpKkeZzlCc univeZUubYRvVryBzKkiIrLlNnsMmLnNlo IiFfaAlOoVuUjJAavPpiIaMmdHhDBbgG ixXiIPpnmacutlLTzZlrRadIia cXtTxayYyYlyiIYumnuUiAaaSsdEejJa DdbiIryYiLjJloJjfFSsBbAWwayYyYsCcpGgGgPgGaaA uUdDIhHiwWyPTtpBbhvVHIiYUvwWVuCcy sLlCQqFfPphHHhLlcoDdgGxXPpFfIibBbriTJjaAtaQqsS drRDmadDrBseESbizZonTtFfUucCeta LoOlmhHonhHbaABeHoOhtaRiIrrMmiuDdUwWaLEeljJZz danesa de"), "Era la suma souvenir del la inmaculada briosa y marioneta danesa de")

    #Capitulo 2
    def test_obter_posicao(self):
        self.assertEqual(projeto.obter_posicao("C", 5), 2)
        self.assertEqual(projeto.obter_posicao("B", 7), 7)
        self.assertEqual(projeto.obter_posicao("E", 7), 7)
        self.assertEqual(projeto.obter_posicao("E", 5), 4)
        self.assertEqual(projeto.obter_posicao("B", 3), 6)
        self.assertEqual(projeto.obter_posicao("E", 6), 5)
        self.assertEqual(projeto.obter_posicao("D", 5), 6)

    def test_obter_digito(self):
        self.assertEqual(projeto.obter_digito("CEE", 5), 1)
        self.assertEqual(projeto.obter_digito("CCEDBBD", 6), 9)
        self.assertEqual(projeto.obter_digito("EBDEBBDBE", 2), 7)
        self.assertEqual(projeto.obter_digito("CEBDDCBBE", 4), 8)
        self.assertEqual(projeto.obter_digito("CECDDBBDEEBD", 8), 8)
        self.assertEqual(projeto.obter_digito("BECDECBBDB", 2), 8) 

    def test_obter_pin(self):
        self.assertEqual(projeto.obter_pin(("CEE", "DDBBB", "ECDBE", "CCCCB")), (1, 9, 8, 5))
        self.assertEqual(projeto.obter_pin(("CEEBDC", "BBECDCE", "BBEDCDCEEE", "BDBDCCC")), (2, 1, 1, 3))
        self.assertRaises(ValueError, projeto.obter_pin, 1)
        self.assertRaises(ValueError, projeto.obter_pin, ("E", "C", "D"))
        self.assertRaises(ValueError, projeto.obter_pin, ('E', 'C', 'D', 'E', 'C', 'D', 'E', 'C', 'D', 'E', 'C'))
        self.assertRaises(ValueError, projeto.obter_pin, ("e", "C", "D", "D"))
        self.assertRaises(ValueError, projeto.obter_pin, ("z", "E", "C", "D"))
        self.assertRaises(ValueError, projeto.obter_pin, (" ", "C", "D", "D"))
        self.assertRaises(ValueError, projeto.obter_pin, ("CEE"))
        self.assertRaises(ValueError, projeto.obter_pin, ("CBEDDBCcde", "EB", "BEDDBC", "DBBEEC"))
        self.assertRaises(ValueError, projeto.obter_pin, ("CBBEDx", "CEE", "ECDE", "CCCCBEED"))
        self.assertRaises(ValueError, projeto.obter_pin, ("CEE", "CBBEDD2", "BED583C", "BEEDC#", "ECDBEe"))

    #Capitulo 3
    def test_eh_entrada(self):
        self.assertEqual(projeto.eh_entrada(('a-b-c-d-e-f-g-h', '[abcd]', (950, 300))), False)
        self.assertEqual(projeto.eh_entrada(('a-b-c-d-e-f-g-h-2', '[abcde]', (950, 300))), False)
        self.assertEqual(projeto.eh_entrada(('a-b-c-d-e-f-g-h', '[xxxxx]', (950, 300))), True)
        self.assertEqual(projeto.eh_entrada(1), False)
        self.assertEqual(projeto.eh_entrada(("ainda-errado", 25, (950, 300))), False)
        self.assertEqual(projeto.eh_entrada(("a")), False)
        self.assertEqual(projeto.eh_entrada(("a", "b", "c")), False)
        self.assertEqual(projeto.eh_entrada(("", "[aaaaa]", (1,2))), False)
        self.assertEqual(projeto.eh_entrada(("aa", "", (1,2))), False)
        self.assertEqual(projeto.eh_entrada(("aa", "abcde", (1,2))), False)
        self.assertEqual(projeto.eh_entrada(("aa", "abcdefg", (1, 2))), False)
        self.assertEqual(projeto.eh_entrada(("aa", "[abcdef", (1,2))), False)
        self.assertEqual(projeto.eh_entrada(("aa", "abcdef]", (1, 2))), False)
        self.assertEqual(projeto.eh_entrada(("aa", "[aaa]a]", (1,2))), False)
        self.assertEqual(projeto.eh_entrada(("aa-", "[aaaaa]", (1,2))), False)
        self.assertEqual(projeto.eh_entrada(("aa", "[aa[aa]", (1,2))), False)
        self.assertEqual(projeto.eh_entrada(("-aa", "[aaaaa]", (1, 2))), False)
        self.assertEqual(projeto.eh_entrada(("a--a", "[aaaaa]", (1,2))), False)
        self.assertEqual(projeto.eh_entrada(("a", "b")), False)
        self.assertEqual(projeto.eh_entrada(('', '[aaaaa]', (1, 2))), False)
        self.assertEqual(projeto.eh_entrada(('aa', '[aaaaa]', ())), False)
        self.assertEqual(projeto.eh_entrada(('aa', '[aaaaa]', ('a', 2))), False)
        self.assertEqual(projeto.eh_entrada(('aa', '[aaaaa]', (-1, 2))), False)
        self.assertEqual(projeto.eh_entrada(("a-b-aasd-asdfr-a-asd", "[afsvf]", (2745, 751))), True)
        self.assertEqual(projeto.eh_entrada(("a-b-aasd-asdfr-a-asd", "[afasvf]", (2745, 751))), False)
        self.assertEqual(projeto.eh_entrada(('A', '[aaaaa]', (1, 2))), False)
        self.assertEqual(projeto.eh_entrada(('aa', 'abcdefg', (1, 2))), False)
        self.assertEqual(projeto.eh_entrada(('aa', '[abcdef', (1, 2))), False)
        self.assertEqual(projeto.eh_entrada(("aa", "[aaaaa]", (124, 325, -7))), False)
        self.assertEqual(projeto.eh_entrada(("a-b-c-d-e-f-g", "[xxxxx]", (124, 325, 7))), True)
        self.assertEqual(projeto.eh_entrada(("qgfo-qutdo-s-egoes-wzegsnfmjqz", "[abcde]", (2223, 424, 1316, 99))), True)


    def test_validar_cifra(self):
        self.assertEqual(projeto.validar_cifra("a-b-c-d-e-f-g-h", "[xxxxx]"), False)
        self.assertEqual(projeto.validar_cifra("a-b-c-d-e-f-g-h", "[abcde]"), True)
        self.assertEqual(projeto.validar_cifra('zzz-yyy-ccc-aaa-bbb', '[abcyz]'), True)
        self.assertEqual(projeto.validar_cifra('zzz-bb-aa-d-c', '[zabcd]'), True)
        self.assertEqual(projeto.validar_cifra("a-x-v-x-xxx-aazzzz-hjuyt", "[xzahj]"), True)
        self.assertEqual(projeto.validar_cifra("a-x-v-x-xxx-aazzzz-hjuyt", "[azxhj]"), False)
        self.assertEqual(projeto.validar_cifra("xxyyaabbcdcdeex", "[abcde]"), False)
        self.assertEqual(projeto.validar_cifra("fundamentos-da-programacao", "[aodmn]"), True)
        self.assertEqual(projeto.validar_cifra("xxyyaabbcdcdee", "[abcde]"), True)
        self.assertEqual(projeto.validar_cifra("lorem-ipsum-dolor-sit-amet-consectetur-adipiscing-elit-sed-do-eiusmod-tempor-incididunt-ut-labore-et-dolore-magna-aliqua-ut-enim-ad-minim-veniam-quis-nostrud-exercitation-ullamco-laboris-nisi-ut-aliquip-ex-ea-commodo-consequat-duis-aute-irure-dolor-in-reprehenderit-in-voluptate-velit-esse-cillum-dolore-eu-fugiat-nulla-pariatur-excepteur-sint-occaecat-cupidatat-non-proident-sunt-in-culpa-qui-officia-deserunt-mollit-anim-id-est-laborum", "[ietao]"), True)


    def test_filtrar_bdb(self):
        self.assertRaises(ValueError, projeto.filtrar_bdb, " ")
        self.assertEqual(projeto.filtrar_bdb([("aaaaa-bbb-zx-yz-xy", "[abxyz]", (950, 300)), ("a-b-c-d-e-f-g-h", "[abcde]", (124, 325, 7)),("entrada-muito-errada", "[abcde]", (50, 404))]), [("entrada-muito-errada", "[abcde]", (50, 404))])
        self.assertRaises(ValueError, projeto.filtrar_bdb, ())
        self.assertRaises(ValueError, projeto.filtrar_bdb, [])
        self.assertRaises(ValueError, projeto.filtrar_bdb, [100])
        self.assertRaises(ValueError, projeto.filtrar_bdb, [(), ()])
        self.assertEqual(projeto.filtrar_bdb([("programar-e-fixe", "[raefh]", (3, 4, 5)), ("entrada-sem-erros", "[erasd]", (52, 404)), ("fundamentos-da-programacao", "[aodmn]", (1, 2)),]), [("programar-e-fixe", "[raefh]", (3, 4, 5))])
        self.assertEqual(projeto.filtrar_bdb([("beautiful-is-better-than-ugly", "[teuab]", (1, 2)), ("explicit-is-better-than-implicit", "[itecl]", (3, 4)), ("simple-is-better-than-complex", "[etilm]", (5, 6)), ("complex-is-better-than-complicated", "[etcai]", (7, 8))]), [])
        self.assertEqual(projeto.filtrar_bdb([("beautiful-is-better-than-ugly", "[etuab]", (1, 2)), ("explicit-is-better-than-implicit", "[tiecl]", (3, 4)), ("simple-is-better-than-complex", "[etiml]", (5, 6)), ("complex-is-better-than-complicated", "[etcia]", (7, 8))]), [("beautiful-is-better-than-ugly", "[etuab]", (1, 2)), ("explicit-is-better-than-implicit", "[tiecl]", (3, 4)), ("simple-is-better-than-complex", "[etiml]", (5, 6)), ("complex-is-better-than-complicated", "[etcia]", (7, 8))])


    #Capitulo 4
    def test_obter_num_seguranca(self):
        self.assertEqual(projeto.obter_num_seguranca((2223,424,1316,99)), 325)
        self.assertEqual(projeto.obter_num_seguranca((1, 10, 100)), 9)
        self.assertEqual(projeto.obter_num_seguranca((100, 1, 10)), 9)
        self.assertEqual(projeto.obter_num_seguranca((100, 10, 1)), 9)
        self.assertEqual(projeto.obter_num_seguranca((420, 69, 31415)), 351)
        self.assertEqual(projeto.obter_num_seguranca((1, 100, 10)), 9)
        self.assertEqual(projeto.obter_num_seguranca((10, 100, 1)), 9)
        self.assertEqual(projeto.obter_num_seguranca((10, 1, 100)), 9)
        self.assertEqual(projeto.obter_num_seguranca((1422, 427, 2100, 54102)), 678)
        self.assertEqual(projeto.obter_num_seguranca((1423, 5542341, 2341, 321, 5542333)), 8)
        self.assertEqual(projeto.obter_num_seguranca((4929, 19786, 6046, 18239, 17005, 17656, 11057, 14014, 11739, 17495)), 161)
        self.assertEqual(projeto.obter_num_seguranca((1390, 1558, 483, 1748, 1879, 1930, 1501, 41, 1175, 502)), 19)
        self.assertEqual(projeto.obter_num_seguranca((79, 1289, 589, 144, 1230, 275, 1016, 1200, 1933, 1383, 446, 795, 277, 1941, 1190, 441, 1788, 583, 1653, 1551, 56, 1286, 251, 1365, 723, 1501, 644, 1964, 404, 1631, 732, 252, 677, 1625, 902, 422, 131, 288, 136, 1387, 31, 1368, 20, 619, 1027, 475, 1256, 435, 1237, 387, 156, 385, 1013, 967, 1208, 1868, 386, 900, 675, 1191, 1627, 1437, 704, 1900, 591, 1145, 1275, 1296, 707, 1494, 1002, 1421, 99, 1774, 1334, 1283, 290, 548, 1127, 1199, 1515, 595, 297, 1339, 1700, 1748, 1390, 201, 216, 274, 266, 379)), 1)
        self.assertEqual(projeto.obter_num_seguranca((777, 707, 901)), 70)

    def test_decifrar_texto(self):
        self.assertEqual(projeto.decifrar_texto("qgfo-qutdo-s-egoes-wzegsnfmjqz", 325), "esta cifra e quase inquebravel")
        self.assertEqual(projeto.decifrar_texto("qgfo-qutdo-s-egoes-wzegsnfmjqz", 10), "bpqx zfcox b nrxpb fknrbyoxsbi")
        self.assertEqual(projeto.decifrar_texto("bfaudoyod-q-yiuha-rwjs", 793), "programar e muito fixe")
        self.assertEqual(projeto.decifrar_texto("uztpmdype-bn-wxomzk-mcti-pzgr", 526), "beautiful is better than ugly")
        self.assertEqual(projeto.decifrar_texto("vqgezvzm-bj-sxkmvk-myte-zfgezvzm", 1152), "explicit is better than implicit")
        self.assertEqual(projeto.decifrar_texto("fxzeyt-xf-otgirg-iupa-pdzeytk", 9060), "simple is better than complex")

    def test_decifrar_bdb(self):
        self.assertRaises(ValueError, projeto.decifrar_bdb, [("nothing")])
        self.assertRaises(ValueError, projeto.decifrar_bdb, 1)
        self.assertRaises(ValueError, projeto.decifrar_bdb, (("qgfo-qutdo-s-egoes-wzegsnfmjqz", "[abcde]", (2223, 424, 1316, 99))))
        bdb = [
            ("qgfo-qutdo-s-egoes-wzegsnfmjqz", "[abcde]", (2223, 424, 1316, 99)),
            ("lctlgukvzwy-ji-xxwmzgugkgw", "[abxyz]", (2388, 367, 5999)),
            ("nyccjoj-vfrex-ncalml", "[xxxxx]", (50, 404)),
        ]
        self.assertEqual(projeto.decifrar_bdb(bdb), ["esta cifra e quase inquebravel", "fundamentos da programacao", "entrada muito errada"])
        self.assertRaises(ValueError, projeto.decifrar_bdb, (('bfaudoyod-q-yiuha-rwjs', '[adouy]', (2, 795, 3223, 4316)), ('lctlgukvzwy-ji-xxwmzgugkgw', '[abxyz]', (2388, 367, 5999)), ('nyccjoj-vfrex-ncalml', '[xxxxx]', (50, 404))))
        self.assertEqual(projeto.decifrar_bdb([('bfaudoyod-q-yiuha-rwjs', '[adouy]', (2, 795, 3223, 4316))]), ["programar e muito fixe"])
        bdb1 = [
            ('qvplizula-xj-stkivg-iype-lvcn', '[ilvpa]', (762, 2586, 310)),
            ('avljeaer-go-xcprap-rdyj-ekljeaer', '[earjl]', (929, 2915, 380)),
            ('zrtysn-rz-inacla-coju-jxtysne', '[nacjr]', (3354, 33, 805, 1859)),
            ('dtp-kav-whivv-sx-pzmy-phl', '[pvhad]', (1706, 1048, 380, 4385))
        ]
        self.assertEqual(projeto.decifrar_bdb(bdb1), ["beautiful is better than ugly", "explicit is better than implicit", "simple is better than complex", "may the force be with you",])


    # Capitulo 5
    def test_eh_utilizador(self):
        self.assertEqual(projeto.eh_utilizador({'name':'john.doe','pass':'aabcde','rule':{'vals':(1,3),'char':'a'}}), True)
        self.assertEqual(projeto.eh_utilizador({'name':'john.doe','pass':'aabcde','rule':{'vals':1,'char':'a'}}), False)
        self.assertEqual(projeto.eh_utilizador(56.7), False)
        self.assertEqual(projeto.eh_utilizador(("name", "pass", "rule")), False)
        self.assertEqual(projeto.eh_utilizador({"name": 56, "pass": "mynameisbatman", "rule": {"vals": (2, 8), "char": "m"}}), False)
        self.assertEqual(projeto.eh_utilizador({"name": "bruce.wayne", "pass": "mynameisbatman", "rule": {"vals": (2, 1), "char": "m"}}), False)
        self.assertEqual(projeto.eh_utilizador({"name": "bruce.wayne", "pass": "mynameisbatman", "rule": {"vals": (-2, 8), "char": "m"}}), False)
        self.assertEqual(projeto.eh_utilizador({"name": "bruce.wayne", "pass": "mynameisbatman", "rule": {}}), False)
        self.assertEqual(projeto.eh_utilizador({'name':'bruce','surname':'wayne','pass':'mynameisbatman','rule':{'vals':(2,8),'char':'m'}}), False)
        self.assertEqual(projeto.eh_utilizador({'pass':'mynameisbatman','rule':{'vals':(2,8),'char':'m'}}), False)
        self.assertEqual(projeto.eh_utilizador({'name':'','pass':'mynameisbatman','rule':{'vals':(2,8),'char':'m'}}), False)
        self.assertEqual(projeto.eh_utilizador({'name':'bruce.wayne','pass':'mynameisbatman','rule':{}}), False)
        self.assertEqual(projeto.eh_utilizador({'name':'bruce.wayne','pass':'mynameisbatman','rule':{'vals':(2,8),'char':'ma'}}), False)
        self.assertEqual(projeto.eh_utilizador({'name':'bruce.wayne','pass':'mynameisbatman','rule':{'vals':(2,8),'char':'m'}}), True)
        self.assertEqual(projeto.eh_utilizador({"name": "bruce.wayne", "pass": "mynameisbatman", "rule": {"vals": (-3, 2), "char": "m"}}), False)
        self.assertEqual(projeto.eh_utilizador({"name": "bruce.wayne", "pass": "mynameisbatman", "rule": {"vals": (5, 2), "char": "m"}}), False)
        self.assertEqual(projeto.eh_utilizador({'name': 'bruce.wayne', 'pass': True, 'rule': {'vals': (2, 8), 'char': 'm'}}), False)

    def test_eh_senha_valida(self):
        self.assertEqual(projeto.eh_senha_valida('aabcde', {'vals': (1, 3), 'char': 'a'}), True)
        self.assertEqual(projeto.eh_senha_valida('cdefgh', {'vals': (1, 3), 'char': 'b'}), False)
        self.assertEqual(projeto.eh_senha_valida("aeeioukckakhek", {"vals": (1, 5), "char": "k"}), True)
        self.assertEqual(projeto.eh_senha_valida("asdfcsaou", {"vals": (1, 5), "char": "a"}), False)
        self.assertEqual(projeto.eh_senha_valida("aaaaaa", {"vals": (1, 5), "char": "a"}), False)
        self.assertEqual(projeto.eh_senha_valida("aaaaa", {"vals": (2, 5), "char": "d"}), False)
        self.assertEqual(projeto.eh_senha_valida("ddddei", {"vals": (2, 5), "char": "d"}), False)
        self.assertEqual(projeto.eh_senha_valida("addddei", {"vals": (2, 5), "char": "d"}), True)
        self.assertEqual(projeto.eh_senha_valida("adedidodei", {"vals": (2, 5), "char": "d"}), False)
        self.assertEqual(projeto.eh_senha_valida("ajejidojeii", {"vals": (3, 3), "char": "j"}), True)
        self.assertEqual(projeto.eh_senha_valida("aXaxaaa", {"vals": (1, 3), "char": "X"}), True)
        self.assertEqual(projeto.eh_senha_valida("..adedidodei", {"vals": (2, 5), "char": "d"}), True)
        self.assertEqual(projeto.eh_senha_valida("fundamentosdaprogramacao21-22", {"vals": (2, 5), "char": "n"}), True)


    def test_filtrar_senhas(self):
        self.assertEqual(projeto.filtrar_senhas([{"name":"john.doe", "pass":"aabcde", "rule":{"vals":(1,3), "char":"a"}}, {"name":"jane.doe", "pass":"cdefgh", "rule":{"vals":(1,3), "char":"b"}}, {"name":"jack.doe", "pass":"cccccc", "rule":{"vals":(2,9), "char":"c"}}]), ["jack.doe", "jane.doe"])
        self.assertRaises(ValueError, projeto.filtrar_senhas, [])
        self.assertRaises(ValueError, projeto.filtrar_senhas, ())
        self.assertRaises(ValueError, projeto.filtrar_senhas, "nothing")



if __name__ == '__main__':
    unittest.main()
