import os
import sys
from classes import Player 
from database import DataBase
import time 

def clear():
    """Limpa a tela do terminal."""
    os.system('cls' if os.name == 'nt' else 'clear')

# --- Função para a introdução do Call of Cthulhu ---
def display_cthulhu_intro():
    # clear()
    print(" _____   ___   _      _       ___________   _____ _____ _   _ _   _ _      _   _ _   _ ")
    print("/  __ \\ / _ \\ | |    | |     |  _  |  ___| /  __ \\_   _| | | | | | | |    | | | | | | |")
    print("| /  \\/ /_\\ \\| |    | |     | | | | |_    | /  \\/ | | | |_| | | | | |    | |_| | | | |")
    print("| |    |  _  || |    | |     | | | |  _|   | |     | | |  _  | | | | |    |  _  | | | |")
    print("| \\__/\\| | | || |____| |____ \\ \\_/ / |     | \\__/\\ | | | | | | |_| | |____| | | | |_| |")
    print(" \\____/\\_| |_/\\_____/\\_____/  \\___/\\_|      \\____/ \\_/ \\_| |_/\\___/\\_____/\\_| |_/\\___/ ")
    print("                                                                                         ")
    print("                                                                                         \n\n")

    print("                                            O CHAMADO ECOA...")
    print("                           NAS PROFUNDEZAS ESQUECIDAS DO TEMPO E DO ESPAÇO...")
    print("                                  UMA ENTIDADE ANTIGA AGUARDA...")
    print("                                       E SEU PESADELO COMEÇA.")
# --- Fim da função de introdução ---

class Game:

    def __init__(self):
        self.db = DataBase()
        self.player = None
        self.last_lua_de_sangue_time = time.time()

    def create_new_character_flow(self):
        # clear()
        print("--- Criação de Novo Personagem ---")
        
        new_name = input('Digite o nome do seu personagem: ').strip()
        if not new_name:
            print('Nome invalido! Voltando ao menu principal.')
            return

        ocupacoes = [
            "Medico", "Doutor", "Arqueologo", "Detetive", "Jornalista",
            "Professor", "Engenheiro", "Artista", "Soldado", "Explorador"
        ]
        print("\nEscolha a ocupacao do seu personagem:")
        for index, ocupacao in enumerate(ocupacoes, 1):
            print(f"{index}. {ocupacao}")
        new_ocupacao = None
        while new_ocupacao is None:
            escolha = input("Digite o numero da ocupacao desejada: ").strip()
            try:
                escolha_num = int(escolha)
                if 1 <= escolha_num <= len(ocupacoes):
                    new_ocupacao = ocupacoes[escolha_num - 1]
                else:
                    print("Ocupacao invalida. Digite novamente.")
            except ValueError:
                print("Entrada invalida. Digite apenas o numero da ocupacao.")

        new_residencia = input('Digite a residencia do seu personagem: ').strip()
        if not new_residencia: print('Residencia invalida!'); return

        new_local_nascimento = input('Digite o local de nascimento do seu personagem: ').strip()
        if not new_local_nascimento: print('Local de nascimento invalido!'); return

        new_idade = None
        while new_idade is None:
            idade_input = input('Digite a idade do seu personagem: ').strip()
            try:
                idade = int(idade_input)
                if 1 <= idade <= 120:
                    new_idade = idade
                else:
                    print(f"Idade invalida: {idade}. Por favor, digite um numero entre 1 e 120.")
            except ValueError:
                print(f"Entrada invalida: '{idade_input}'. Por favor, digite um numero para a idade.")

        new_sexo = None
        while new_sexo is None:
            sexo_input = input('Digite o sexo do seu personagem (masculino/feminino): ').strip().lower()
            if sexo_input in ['masculino', 'feminino']:
                new_sexo = sexo_input
            else:
                print(f"Sexo invalido: '{sexo_input}'. Por favor, digite 'masculino' ou 'feminino'.")

        new_player_id = self.db.create_new_character(
            nome=new_name, ocupacao=new_ocupacao, residencia=new_residencia,
            local_nascimento=new_local_nascimento, idade=new_idade, sexo=new_sexo
        )

        if new_player_id:
            print(f"\nPersonagem '{new_name}' criado com sucesso! ID: {new_player_id}")
            input("Pressione Enter para continuar e iniciar o jogo...") 
            self.player = self.db.get_personagem(new_name)
            if self.player:
                print(f"Bem-vindo(a) ao mundo, {self.player.nome}!")
                self.gameplay()
            else:
                print("Erro ao carregar o personagem recem-criado. Tente carregar manually pelo menu.")
                self.start()
        else:
            print("Falha na criacao do personagem. Verifique se o nome ja existe ou outros erros.")
            self.start()

    def load_character(self):
        # clear()
        print("--- Carregar Personagem Existente ---")
        nome = input('Digite o nome do personagem (ou "sair" para voltar ao menu): ').strip()
        
        if nome.lower() == 'sair':
            self.start()
            return

        player_obj = self.db.get_personagem(nome)

        if player_obj:
            self.player = player_obj
            print(f"\nPersonagem '{self.player.nome}' carregado com sucesso!")
            input("Pressione Enter para iniciar o jogo...")
            self.gameplay()
        else:
            print(f"Personagem '{nome}' nao encontrado. Voltando ao menu principal.")
            self.start()

    def list_characters(self):
        # clear()
        print("========== Personagens Salvos ==========")
        personagens = self.db._execute_query("SELECT id, nome, ocupacao FROM public.personagens_jogaveis ORDER BY id;", fetch_all=True)

        if personagens:
            for p in personagens:
                print(f"|ID: {p['id']}, Nome: {p['nome'].strip()}, Ocupacao: {p['ocupacao'].strip()}")
            print("==========================================\n")
        else:
            print("Nenhum personagem encontrado no banco de dados.")
    
    def start(self):
        """Exibe o menu inicial e gerencia as opcoes do usuario."""
        while True:
            # clear() 
            print('\n--- Chamado de Cthulhu ---')
            print('Bem-vindo ao jogo! \n')
            print('1 - Criar Personagem')
            print('2 - Listar Personagens') 
            print('3 - Sair \n')

            opcao = input('Digite a opcao desejada: ').strip()

            if opcao == '1':
                self.create_new_character_flow()
                break 
            elif opcao == '2':
                self.list_characters()
                self.load_character()
                break 
            elif opcao == '3':
                print("Saindo do jogo. Ate mais!")
                if self.db:
                    self.db.close()
                sys.exit()
            else:
                input('Opcao invalida! Digite 1, 2, ou 3. Pressione Enter para tentar novamente.')

    def _handle_inventory_actions(self):
        """Gerencia as ações dentro do inventário (equipar/desequipar/vender)."""
        while True:
            itens_inventario = self.db.get_inventario_do_jogador(self.player.id_jogador)
            
            print("\n--- Seu Inventário ---")
            if not itens_inventario:
                print("Seu inventário está vazio.")
                break

            for i, item in enumerate(itens_inventario):
                nome_item = item['item_nome'].strip()
                tipo_item = item['item_tipo'].strip()
                
                # Monta a string de status do item
                stats_str = ""
                if tipo_item == 'arma' and item.get('dano'):
                    stats_str = f"(Dano: {item['dano']})"
                elif tipo_item == 'armadura' and item.get('qtd_dano_mitigado') is not None:
                    bonus = ""
                    if item.get('tipo_atributo_recebe') and item.get('qtd_atributo_recebe'):
                         bonus = f", Bonus: +{item['qtd_atributo_recebe']} {item['tipo_atributo_recebe'].strip()}"
                    stats_str = f"(Defesa: {item['qtd_dano_mitigado']}{bonus})"
                
                # Adiciona o marcador de "Equipado"
                equipado_str = "(Equipado)" if item.get('esta_equipado') else ""

                print(f"[{i + 1}] {nome_item} {stats_str} {equipado_str}")

            action = input("\nO que deseja fazer? (equipar, desequipar, vender, sair): ").strip().lower()

            if action == 'equipar':
                item_idx_str = input("Digite o número do item para equipar: ").strip()
                try:
                    item_idx = int(item_idx_str) - 1
                    if 0 <= item_idx < len(itens_inventario):
                        item_id = itens_inventario[item_idx]['instancia_item_id']
                        result_msg = self.db.equip_item(self.player.id_jogador, item_id)
                        print(result_msg)
                    else:
                        print("Número de item inválido.")
                except ValueError:
                    print("Entrada inválida.")
                input("Pressione Enter para continuar...")

            elif action == 'desequipar':
                slot = input("Qual slot deseja desequipar? (arma/armadura): ").strip().lower()
                if slot in ['arma', 'armadura']:
                    result_msg = self.db.unequip_item(self.player.id_jogador, slot)
                    print(result_msg)
                else:
                    print("Slot inválido. Escolha 'arma' ou 'armadura'.")
                input("Pressione Enter para continuar...")
            elif action == 'vender':
                item_idx_str = input("Digite o número do item para vender: ").strip()
                try:
                    item_idx = int(item_idx_str) - 1
                    if 0 <= item_idx < len(itens_inventario):
                        item_a_vender = itens_inventario[item_idx]

                        # Procura por um vendedor no local atual
                        vendedores_aqui = self.db.get_vendedor_in_location(self.player.id_local)
                        if not vendedores_aqui:
                            print("Não há ninguém para comprar seus itens aqui.")
                        else:
                            vendedor_alvo = vendedores_aqui[0] # Vende para o primeiro vendedor encontrado
                            print(f"Você está vendendo para {vendedor_alvo['nome'].strip()}.")

                            # Chama o método do banco de dados para efetuar a venda
                            resultado = self.db.personagem_vende_item(
                                id_jogador=self.player.id_jogador,
                                npc_id=vendedor_alvo['id_personagem_npc'],
                                id_instancia_item=item_a_vender['instancia_item_id']
                            )
                            print(f"\n> {resultado}")

                            # Atualiza o ouro do jogador em memória se a venda deu certo
                            if "sucesso" in resultado.lower():
                                self.player.ouro += item_a_vender['item_valor']
                    else:
                        print("Número de item inválido.")
                except ValueError:
                    print("Entrada inválida.")
                input("Pressione Enter para continuar...")
            
            elif action == 'sair':
                break
            else:
                print("Ação inválida.")
    
    def _display_monster_details(self, monster_id):
        """Busca e exibe a ficha de um monstro."""
        details = self.db.inspect_monster(monster_id)
        if not details:
            print("Não foi possível obter detalhes para este monstro.")
            return

        print("\n--- Ficha da Criatura ---")
        print(f"Nome: {details['nome'].strip()}")
        print(f"Descrição: {details['descricao'].strip()}")
        print(f"Vida: {details['vida_atual']}/{details['vida_total']} | Defesa: {details['defesa']}")

        if details['tipo_monstro'].strip() == 'agressivo':
            print(f"Dano: {details.get('dano', 'N/A')}")
            if details.get('velocidade_ataque'):
                print(f"Velocidade de Ataque: {details['velocidade_ataque']}")
            if details.get('loucura_induzida'):
                print(f"Loucura Induzida: {details['loucura_induzida']}")
            if details.get('ponto_magia'):
                print(f"Pontos de Magia: {details['ponto_magia']}")
        
        print("-------------------------\n")
    
    def display_detalhes_item(self, item: dict):
        """
        Recebe um dicionário de item e exibe seus detalhes de forma organizada.
        """
        print("\n--- Detalhes do Item ---")
        print(f"Nome: ................. {item.get('item_nome', 'N/A').strip()}")
        print(f"Tipo: ................. {item.get('item_tipo', 'N/A').strip()}")
        print(f"Descrição: ............ {item.get('item_descricao', 'N/A').strip()}")
        print(f"Valor: ................ {item.get('item_valor', 0)}")

        if item.get('durabilidade_total') is not None:
            print(f"Durabilidade: ......... {item.get('durabilidade_atual', 0)} / {item.get('durabilidade_total', 0)}")

        if item.get('dano') is not None:
            print("\n* Atributos de Arma:")
            print(f"  Dano: ............... {item.get('dano')}")
            print(f"  Alcance: ............ {item.get('alcance', 1)}")

        if item.get('qtd_dano_mitigado') is not None:
            print("\n* Atributos de Armadura:")
            print(f"  Dano Mitigado: ..... {item.get('qtd_dano_mitigado')}")

        if item.get('qts_usos') is not None:
            print("\n* Atributos de Consumível:")
            print(f"  Usos Restantes: .... {item.get('qts_usos')}")

        # --- LINHA CORRIGIDA ---
        # Usamos 'or 0' para garantir que, se o valor for None, ele se torne 0 antes da comparação.
        if (item.get('qtd_pontos_vida_recupera') or 0) > 0:
            print(f"  Recupera Vida: ..... +{item.get('qtd_pontos_vida_recupera')}")

        if item.get('custo_sanidade') is not None:
            print(f"  Custo de Sanidade: . {item.get('custo_sanidade')}")

        print("------------------------")


    def _handle_explore_actions(self):
        """Gerencia as ações de exploração (itens e monstros)."""
        while True:
            print("\n--- Explorar Ambiente ---")
            print("1. Procurar por Itens")
            print("2. Procurar por Ameaças")
            print("3. Comprar itens")
            print("0. Voltar")
            
            choice = input("> ").strip()

            if choice == '1': # Procurar Itens
                print("\nVoce comeca a vasculhar o ambiente com cautela...")
                itens_no_local = self.db.get_items_in_location(self.player.id_local)

                if itens_no_local:
                    print("\nVoce encontrou os seguintes itens:")
                    for i, item in enumerate(itens_no_local):
                        print(f"  [{i + 1}] {item['item_nome'].strip()} ({item['item_descricao'].strip()})")
                    
                    escolha_item = input("Digite o numero do item que deseja pegar (ou '0' para nao pegar nada): ").strip()
                    try:
                        idx_item = int(escolha_item) - 1
                        if 0 <= idx_item < len(itens_no_local):
                            item_escolhido = itens_no_local[idx_item]
                            if self.db.add_item_to_inventory(self.player.id_jogador, item_escolhido['instancia_item_id']):
                                print(f"Voce pegou '{item_escolhido['item_nome'].strip()}'.")
                            else:
                                print("Nao foi possivel pegar o item. Tente novamente.")
                        elif escolha_item == '0':
                            print("Voce decidiu nao pegar nenhum item.")
                        else:
                            print("Escolha de item invalida.")
                    except ValueError:
                        print("Entrada invalida para pegar item.")
                else:
                    print("Voce nao encontrou nada de interessante aqui.")
                input("\nPressione Enter para continuar...")

            elif choice == '2': # Procurar Ameaças
                print("\nVoce se prepara para procurar por sinais de vida... nao-humana.")
                monstros_no_local = self.db.get_monsters_in_location(self.player.id_local)

                if monstros_no_local:
                    print("\nVoce avista os seguintes seres horripilantes:")
                    for i, monstro in enumerate(monstros_no_local):
                        print(f"  [{i + 1}] {monstro['monstro_nome'].strip()} (Vida: {monstro['vida_atual']}/{monstro['vida_total']})")
                    
                    action = input("Seja cuidadoso! [a]tacar, [i]nspecionar, ou [r]ecuar (formato 'a1', 'i1'): ").strip().lower()
                    
                    try:
                        command = action[0]
                        num = int(action[1:]) - 1

                        if 0 <= num < len(monstros_no_local):
                            monstro_escolhido = monstros_no_local[num]
                            if command == 'a':
                                print("\n--- A BATALHA COMEÇA! ---")
                                resultado_batalha = self.db.execute_battle(self.player.id_jogador, monstro_escolhido['instancia_monstro_id'])
                                print(resultado_batalha)
                                print("--- A BATALHA TERMINOU! ---")
                            elif command == 'i':
                                self._display_monster_details(monstro_escolhido['instancia_monstro_id'])
                            else:
                                print("Comando inválido. Use 'a' para atacar ou 'i' para inspecionar.")
                        else:
                            print("Número de monstro inválido.")
                    
                    except (ValueError, IndexError):
                        if action == 'r':
                             print("Voce recua para as sombras, evitando o confronto.")
                        else:
                            print("Comando inválido. Use o formato 'a1', 'i1', ou 'r'.")

                else:
                    print("O local parece estar livre de ameacas... por enquanto.")
                input("\nPressione Enter para continuar...")

            elif choice == '3': # Comprar Itens / Interagir com Vendedor
                vendedores_no_local = self.db.get_vendedor_in_location(self.player.id_local)

                if vendedores_no_local:
                    vendedor = vendedores_no_local[0]
                    print(f"\nVocê avista {vendedor['nome'].strip()}.")

                    if vendedor.get('script_dialogo'):
                        print(f"\n{vendedor['nome'].strip()}: \"{vendedor['script_dialogo'].strip()}\"")

                    while True:
                        action = input("\nO que deseja fazer? [1] Ver Loja, [0] Sair: ").strip()

                        if action == '1':
                            itens_do_vendedor = self.db.get_item_vendedor(vendedor.get('id_personagem_npc'))

                            if not itens_do_vendedor:
                                print("Este vendedor não tem itens para vender no momento.")
                                input("Pressione Enter para continuar...")
                                break 

                            while True:
                                print(f"\n--- Itens de {vendedor['nome'].strip()} ---")
                                for i, item in enumerate(itens_do_vendedor, 1):
                                    nome_item = item.get('item_nome', 'N/A').strip()
                                    valor_item = item.get('item_valor', 0)
                                    print(f"[{i}] {nome_item} (Valor: {valor_item})")

                                escolha_item = input("\nDigite o número para inspecionar (ou 'voltar'): ").strip().lower()

                                if escolha_item == 'voltar':
                                    break 
                                
                                try:
                                    idx = int(escolha_item) - 1
                                    if 0 <= idx < len(itens_do_vendedor):
                                        item_escolhido = itens_do_vendedor[idx]
                                        self.display_detalhes_item(item_escolhido)

                                        # --- BLOCO DE COMPRA ADICIONADO ---
                                        custo_item = item_escolhido.get('item_valor', 0)
                                        ouro_jogador = self.player.ouro

                                        print(f"Custo: {custo_item} Ouro | Você tem: {ouro_jogador} Ouro")

                                        if ouro_jogador >= custo_item:
                                            comprar = input("Deseja comprar este item? (s/n): ").lower()
                                            if comprar == 's':
                                                resultado = self.db.personagem_compra_item(
                                                    id_jogador=self.player.id_jogador,
                                                    npc_id=vendedor['id_personagem_npc'],
                                                    id_instancia_item=item_escolhido['instancia_item_id'],
                                                    valor_pago=custo_item
                                                )
                                                print(f"\n> {resultado}")

                                                if "sucesso" in resultado.lower():
                                                    # Atualiza o ouro do jogador em memória
                                                    self.player.ouro -= custo_item
                                                    print(f"Seu ouro restante: {self.player.ouro}")
                                                    input("Pressione Enter para continuar...")
                                                    break # Sai para a lista de itens da loja ser atualizada
                                                
                                        else:
                                            print("Você não tem ouro suficiente.")
                                            input("\nPressione Enter para voltar à lista...")
                                            # --- FIM DO BLOCO DE COMPRA ---
                                    else:
                                        print("Número de item inválido.")
                                except ValueError:
                                    print("Entrada inválida. Digite um número.")

                        elif action == '0':
                            print(f"Você se despede de {vendedor['nome'].strip()}.")
                            break
                        else:
                            print("Opção inválida.")
                else:
                    print("\nNão há vendedores neste local.")

            elif choice == '0':
                break
            else:
                print("Opção de exploração inválida.")

    def gameplay(self):
        if not self.player:
            print("Erro: Nenhum jogador carregado.")
            return self.start()

        print(f"\n--- Comeca a aventura de {self.player.nome}! ---")

        while True:
            current_time = time.time()
            if current_time - self.last_lua_de_sangue_time >= 60:
                self.db.trigger_lua_de_sangue() 
                self.last_lua_de_sangue_time = current_time 

            detalhes_local = self.db.get_local_details_and_exits(self.player.id_local)

            if not detalhes_local:
                print(f"Erro: Nao foi possivel carregar os detalhes do local ID: {self.player.id_local}")
                return self.start()

            # clear()
            print("==================================================")
            print(f"Voce esta em um(a) {detalhes_local['tipo_local']}: {detalhes_local['descricao']}")
            
            if detalhes_local['tipo_local'].lower() == 'corredor' and detalhes_local['status'] is not None:
                print(f"Status do Corredor: {'Ativo' if detalhes_local['status'] else 'Inativo'}")
            
            print("==================================================")
            print("\nSAIDAS DISPONIVEIS:")
            
            saidas = detalhes_local['saidas']
            if not saidas:
                print("Nao ha saidas visiveis daqui.")
            else:
                for i, saida in enumerate(saidas):
                    print(f"  [{i + 1}] Ir para {saida['direcao']} ({saida['tipo_destino']})")

            print("\nO que voce deseja fazer? (Ficha [f], Inventário [i], Explorar [e], Sair [s])")
            escolha = input("> ").strip().lower()

            if escolha == 's':
                break
            elif escolha == 'f':
                self.db.get_ficha_personagem(self.player.id_jogador) 
                input("\nPressione Enter para continuar...")
            elif escolha == 'i':
                self._handle_inventory_actions()
            elif escolha == 'e':
                self._handle_explore_actions()
            
            elif escolha == 'kill': 
                print("\nVoce decide usar forca letal para limpar o local de qualquer ameaca...")
                monstros_mortos_count = self.db.kill_monsters_in_location(self.player.id_local)
                if monstros_mortos_count > 0:
                    print(f"Voce aniquilou {monstros_mortos_count} monstros neste local!")
                elif monstros_mortos_count == 0:
                    print("Nao havia monstros para matar neste local.")
                else:
                    print("Ocorreu um erro ao tentar matar os monstros.")
                input("\nPressione Enter para continuar...")
            
            else:
                try:
                    escolha_num = int(escolha) - 1
                    if 0 <= escolha_num < len(saidas):
                        saida_escolhida = saidas[escolha_num]
                        novo_local_id = saida_escolhida['id_saida']
                        self.db.update_localizacao_jogador(self.player.id_jogador, novo_local_id)
                        self.player.id_local = novo_local_id 
                    else:
                        print("Escolha de saida invalida.")
                except ValueError:
                    print("Comando invalido.")

        self.start() 


if __name__ == '__main__':
    display_cthulhu_intro()
    game = Game()
    game.start()
    if game.db:
        game.db.close()