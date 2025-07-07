import os
import sys
# Removendo importações antigas de Corredor e Sala, pois foram unificadas no DB
from classes import Player # Agora importamos apenas Player
from database import DataBase
# import time # Importa o módulo time para usar time.sleep()
# import time # Importa o módulo time para usar time.sleep()
import time # para a lua de sangue

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

    
    # time.sleep(1) # Pequena pausa para a leitura inicial do título

    print("                                            O CHAMADO ECOA...")
    # time.sleep(2)
    print("                           NAS PROFUNDEZAS ESQUECIDAS DO TEMPO E DO ESPAÇO...")
    # time.sleep(2)
    print("                                  UMA ENTIDADE ANTIGA AGUARDA...")
    # time.sleep(2)
    print("                                       E SEU PESADELO COMEÇA.")
    # time.sleep(3) # Pausa mais longa para o impacto final
    # clear() # Limpa a tela antes de ir para o menu principal do jogo
# --- Fim da função de introdução ---

class Game:

    def __init__(self):
        self.db = DataBase()
        self.player = None
        self.last_lua_de_sangue_time = time.time()
        self.game_mode = None # 'mundo_aberto' ou 'historia'
        self.mission_state = None

        # Define os dados da missão do modo história.
        # NOTA: Os IDs dos locais e monstros devem corresponder aos do seu arquivo dml.sql
        self.STORY_MISSION_DATA = {
            'title': 'A Purificação do Templo',
            'stages': [
                # Estágio 1: Sala 2 ('Um salão circular...') com o 'Abominável Horror'
                {'local_id': 40300003, 'monster_name': 'Abominável Horror', 'objective': 'Derrote o Abominável Horror no Salão Circular.',
                 'allowed_exits': {'Norte': 40300012}}, # Permite ir para o Corredor 1

                # Estágio 2: Sala 0 ('O ar pesa...') - Requer um monstro aqui no DML
                {'local_id': 40300001, 'monster_name': 'Sombra Rastejante', 'objective': 'Enfrente a Sombra na sala de entrada.',
                 'allowed_exits': {'Leste': 40300014}}, # Permite ir para o Corredor 2

                # Estágio 3: Sala 1 ('Esta câmara é uma abóbada...') - Requer um monstro aqui no DML
                {'local_id': 40300002, 'monster_name': 'Guardião da Cripta', 'objective': 'Extermine o Guardião da Cripta.',
                 'allowed_exits': {}} # Sem saída, fim da missão
            ],
            'reward': 'Você purificou o templo e recebe a Adaga Rúnica como recompensa!'
        }


    def create_new_character_flow(self):
        # clear()
        print("--- Criação de Novo Personagem ---")
        
        new_name = input('Digite o nome do seu personagem: ').strip()
        if not new_name:
            print('Nome invalido! Voltando ao menu principal.')
            return

        ocupacoes = [
            "Medico",
            "Doutor",
            "Arqueologo",
            "Detetive",
            "Jornalista",
            "Professor",
            "Engenheiro",
            "Artista",
            "Soldado",
            "Explorador"
            # demais ocupacoes podem ser adicionadas aqui
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

        # --- Loop para Idade ---
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

        # --- Loop para Sexo ---
        new_sexo = None
        while new_sexo is None:
            sexo_input = input('Digite o sexo do seu personagem (masculino/feminino): ').strip().lower()
            if sexo_input in ['masculino', 'feminino']:
                new_sexo = sexo_input
            else:
                print(f"Sexo invalido: '{sexo_input}'. Por favor, digite 'masculino' ou 'feminino'.")

        # Tenta criar o personagem no banco de dados
        new_player_id = self.db.create_new_character(
            nome=new_name,
            ocupacao=new_ocupacao,
            residencia=new_residencia,
            local_nascimento=new_local_nascimento,
            idade=new_idade,
            sexo=new_sexo
        )

        if new_player_id:
            print(f"\nPersonagem '{new_name}' criado com sucesso! ID: {new_player_id}")
            input("Pressione Enter para continuar e iniciar o jogo...") 
            self.player = self.db.get_personagem(new_name)
            if self.player:
                print(f"Bem-vindo(a) ao mundo, {self.player.nome}!")
                if self.game_mode == 'historia':
                    self.initialize_story_mode()
                self.gameplay()
            else:
                print("Erro ao carregar o personagem recem-criado. Tente carregar manualmente pelo menu.")
                self.start()
        else:
            print("Falha na criacao do personagem. Verifique se o nome ja existe ou outros erros.")
            # Pequena pausa para o usuário ler a mensagem de erro
            input("\nPressione Enter para voltar ao menu...")
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
            if self.game_mode == 'historia':
                self.initialize_story_mode()
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
                print(f"|ID: {p['id']}, Nome: {p['nome']}, Ocupacao: {p['ocupacao']}")
            print("==========================================\n")
        else:
            print("Nenhum personagem encontrado no banco de dados.")

    def initialize_story_mode(self):
        """Prepara o estado inicial para o Modo História."""
        print("\n--- Iniciando Modo História: A Purificação do Templo ---")
        self.mission_state = {
            'current_stage': 0,
            'monsters_defeated': [False, False, False] # Controla a derrota dos monstros de cada estágio
        }
        # Move o jogador para a primeira sala da missão
        first_stage_local_id = self.STORY_MISSION_DATA['stages'][0]['local_id']
        self.db.update_localizacao_jogador(self.player.id_jogador, first_stage_local_id)
        self.player.id_local = first_stage_local_id
        input("Você foi transportado para o início da sua missão. Pressione Enter...")

    def start(self):
        """Exibe o menu inicial e gerencia as opcoes do usuario."""
        while True:
            # clear() # Limpa a tela a cada exibição do menu
            print('\n--- Chamado de Cthulhu ---')
            print('Bem-vindo ao jogo! \n')
            print('1 - Mundo Aberto (Experiência Padrão)')
            print('2 - Modo História (Missão Guiada)')
            print('3 - Sair \n')

            opcao = input('Digite a opcao desejada: ').strip()

            if opcao == '1':
                self.game_mode = 'mundo_aberto'
                self.character_menu()
                break
            elif opcao == '2':
                self.game_mode = 'historia'
                self.character_menu()
                break
            elif opcao == '3':
                print("Saindo do jogo. Ate mais!")
                if self.db:
                    self.db.close()
                sys.exit()
            else:
                input('Opcao invalida! Digite 1, 2 ou 3. Pressione Enter para tentar novamente.')

    def character_menu(self):
        """Menu para criar, carregar ou listar personagens."""
        while True:
            # clear()
            print('\n--- Menu de Personagens ---')
            print('1 - Criar Novo Personagem')
            print('2 - Carregar Personagem Existente')
            print('3 - Listar Personagens Salvos')
            print('4 - Voltar ao Menu Principal\n')

            opcao = input('Digite a opcao desejada: ').strip()

            if opcao == '1':
                self.create_new_character_flow()
                break 
            elif opcao == '2':
                self.load_character()
                break 
            elif opcao == '3': 
                self.list_characters()
                input("\nPressione Enter para voltar ao menu...")
                # Fica no menu para o usuário decidir o que fazer depois de listar
            elif opcao == '4':
                self.start()
                break
            else:
                input('Opcao invalida! Digite 1, 2, 3 ou 4. Pressione Enter para tentar novamente.')


    def gameplay(self):
        if not self.player:
            print("Erro: Nenhum jogador carregado.")
            return self.start()

        if self.game_mode == 'historia':
            self.gameplay_story_mode()
        else:
            self.gameplay_open_world()

    def gameplay_open_world(self):
        """Lógica de jogo para o modo Mundo Aberto."""
        print(f"\n--- Explorando o Templo com {self.player.nome}! ---")
        while True:
            current_time = time.time()
            if current_time - self.last_lua_de_sangue_time >= 60:
                self.db.trigger_lua_de_sangue() # Chama o método que invoca a stored procedure
                self.last_lua_de_sangue_time = current_time # Reseta o timer

            # 1. Determina onde o jogador esta e busca os detalhes do local
            detalhes_local = self.db.get_local_details_and_exits(self.player.id_local)

            if not detalhes_local:
                print(f"Erro: Nao foi possivel carregar os detalhes do local ID: {self.player.id_local}")
                return self.start() # Volta ao menu inicial se o local nao for encontrado

            # 2. Mostra o status atual
            # clear()
            print("==================================================")
            # Usa o tipo_local diretamente do BD (ex: 'Sala' ou 'Corredor')
            print(f"Voce esta em um(a) {detalhes_local['tipo_local']}: {detalhes_local['descricao']}")
            
            # Se for um corredor, pode mostrar o status dele
            if detalhes_local['tipo_local'].lower() == 'corredor' and detalhes_local['status'] is not None:
                print(f"Status do Corredor: {'Ativo' if detalhes_local['status'] else 'Inativo'}")
            
            print("==================================================")
            print("\nSAIDAS DISPONIVEIS:")
            
            saidas = detalhes_local['saidas']
            if not saidas:
                print("Nao ha saidas visiveis daqui.")
                input("Pressione Enter para continuar...")
                continue

            for i, saida in enumerate(saidas):
                # Usa tipo_destino para dizer se vai para uma Sala ou Corredor
                print(f"  [{i + 1}] Ir para {saida['direcao']} ({saida['tipo_destino']}): {saida['desc_saida']}")

            # 3. Pede a acao do jogador
            print("\nO que voce deseja fazer? (Ficha [f], Inventário [i], Vasculhar [v], Monstros [p], Atacar [a], Sair [s])")
            escolha = input("> ").strip().lower()

            if escolha == 's':
                break
            elif escolha == 'f':
                self.db.get_ficha_personagem(self.player.id_jogador) 
                input("\nPressione Enter para continuar...")
                continue
            elif escolha == 'i':
                print("\n--- Seu Inventário ---")
                itens_inventario = self.db.get_inventario_do_jogador(self.player.id_jogador) 
                
                if itens_inventario:
                    for item in itens_inventario:
                        nome_item = item['item_nome'].strip()
                        descricao_item = item['item_descricao'].strip()
                        durabilidade = item['durabilidade']
                        durabilidade_total = item['durabilidade_total']
                        
                        if durabilidade is not None and durabilidade_total is not None:
                            print(f"- {nome_item}: {descricao_item} (Durabilidade: {durabilidade}/{durabilidade_total})")
                        else:
                            print(f"- {nome_item}: {descricao_item}")
                else:
                    print("Seu inventário está vazio.")
                input("\nPressione Enter para continuar...")
                continue
            elif escolha == 'v':
                print("\nVoce comeca a vasculhar o ambiente...")
                itens_no_local = self.db.get_items_in_location(self.player.id_local)

                if itens_no_local:
                    print("\nVoce encontrou os seguintes itens:")
                    for i, item in enumerate(itens_no_local):
                        print(f"  [{i + 1}] {item['item_nome'].strip()} ({item['item_descricao'].strip()})")
                    
                    escolha_item = input("Digite o numero do item que deseja pegar (ou '0' para nao pegar nada): ").strip()
                    try:
                        idx_item = int(escolha_item) - 1
                        if 0 <= idx_item < len(itens_2
                                               no_local):
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
                continue # Voltar ao inicio do loop gameplay

            elif escolha == 'p':
                print("\nVoce se prepara para procurar por sinais de vida... nao-humana.")
                monstros_no_local = self.db.get_monsters_in_location(self.player.id_local)

                if monstros_no_local:
                    print("\nVoce avista os seguintes seres horripilantes:")
                    for i, monstro in enumerate(monstros_no_local):
                        nome_monstro = monstro['monstro_nome'].strip()
                        tipo_monstro = monstro['monstro_tipo'].strip()
                        vida_atual = monstro['vida_atual']
                        vida_total = monstro['vida_total']
                        print(f"  [{i + 1}] {nome_monstro} (Tipo: {tipo_monstro}, Vida: {vida_atual}/{vida_total})")
                else:
                    print("O local parece estar livre de ameacas... por enquanto.")
                input("\nPressione Enter para continuar...")
                continue
            elif escolha == 'a' or escolha == 'atacar':
                monsters_in_room = self.db.get_monsters_in_location(self.player.id_local)
                if not monsters_in_room:
                    print("Não há o que atacar aqui.")
                    input("Pressione Enter para continuar...")
                    continue
                
                try:
                    monster_num_str = input("Digite o número do monstro que deseja atacar: ").strip()
                    monster_num = int(monster_num_str) - 1

                    if 0 <= monster_num < len(monsters_in_room):
                        monster_to_attack = monsters_in_room[monster_num]
                        id_instancia_monstro = monster_to_attack['instancia_monstro_id']
                        
                        # Chama a nova função de combate do banco de dados
                        combat_result = self.db.character_attacks_monster(self.player.id_jogador, id_instancia_monstro)
                        
                        if combat_result:
                            print(f"\n{combat_result['mensagem']}")
                            if combat_result['monstro_derrotado']:
                                print(f"Você derrotou o {monster_to_attack['monstro_nome'].strip()}!")
                            else:
                                print(f"Dano causado: {combat_result['dano_causado']}. Vida restante do monstro: {combat_result['vida_restante_monstro']}")
                        else:
                            print("Ocorreu um erro no combate.")
                    else:
                        print("Número do monstro inválido.")
                except (ValueError, IndexError):
                    print("Entrada inválida. Use um número da lista.")
                input("Pressione Enter para continuar...")
                continue

            
            # 4. Processa o movimento
            try:
                escolha_num = int(escolha) - 1
                if 0 <= escolha_num < len(saidas):
                    saida_escolhida = saidas[escolha_num]
                    novo_local_id = saida_escolhida['id_saida']

                    # Apenas atualiza o id_local do jogador no banco de dados
                    self.db.update_localizacao_jogador(self.player.id_jogador, novo_local_id)
                    # Atualiza o id_local do jogador no objeto Player em memoria
                    self.player.id_local = novo_local_id 

                else:
                    input("Escolha de saida invalida. Pressione Enter.")
            except ValueError:
                input("Comando invalido. Pressione Enter.")

        # Ao sair do loop gameplay, retorna ao menu principal
        self.start() 

    def gameplay_story_mode(self):
        """Lógica de jogo para o modo História."""
        print(f"\n--- Missão: {self.STORY_MISSION_DATA['title']} ---")

        while True:
            stage_index = self.mission_state['current_stage']
            
            # Verifica se a missão terminou
            if stage_index >= len(self.STORY_MISSION_DATA['stages']):
                print("\nParabéns! Você completou a missão!")
                print(f"Recompensa: {self.STORY_MISSION_DATA['reward']}")
                input("Pressione Enter para voltar ao menu principal.")
                return self.start()

            stage_data = self.STORY_MISSION_DATA['stages'][stage_index]

            # 1. Busca os detalhes do local
            detalhes_local = self.db.get_local_details_and_exits(self.player.id_local)
            if not detalhes_local:
                print(f"Erro: Nao foi possivel carregar os detalhes do local ID: {self.player.id_local}")
                return self.start()

            # 2. Mostra o status atual
            clear()
            print("==================================================")
            print(f"Voce esta em um(a) {detalhes_local['tipo_local']}: {detalhes_local['descricao']}")
            print(f"\nOBJETIVO ATUAL: {stage_data['objective']}")
            print("==================================================")

            # Listar monstros no local
            monsters_in_room = self.db.get_monsters_in_location(self.player.id_local)
            if monsters_in_room and not self.mission_state['monsters_defeated'][stage_index]:
                print("\nPERIGO! Monstros na sala:")
                for i, monster in enumerate(monsters_in_room):
                    print(f"  - Monstro [{i + 1}]: {monster['monstro_nome'].strip()}")
            else:
                print("\nO caminho está livre.")

            # 3. Filtra e exibe as saídas permitidas
            print("\nSAIDAS DISPONIVEIS:")
            allowed_exits_info = stage_data['allowed_exits']
            
            # Só permite saídas se o monstro do estágio atual foi derrotado
            if self.mission_state['monsters_defeated'][stage_index]:
                available_exits = [s for s in detalhes_local['saidas'] if s['direcao'] in allowed_exits_info and allowed_exits_info[s['direcao']] == s['id_saida']]
            else:
                available_exits = [] # Bloqueia todas as saídas

            if not available_exits:
                print("Nao ha saidas visiveis ou o caminho está bloqueado. Cumpra seu objetivo.")
            else:
                for i, saida in enumerate(available_exits):
                    print(f"  [{i + 1}] Ir para {saida['direcao']} ({saida['tipo_destino']}): {saida['desc_saida']}")

            # 4. Pede a acao do jogador
            print("\nO que voce deseja fazer? (Ficha [f], Atacar [a], Sair [s])")
            escolha = input("> ").strip().lower()

            if escolha == 'sair':
                break
            elif escolha == 'f':
                self.db.get_ficha_personagem(self.player.id_jogador) 
                input("\nPressione Enter para continuar...")
                continue
            elif escolha == 'a' or escolha == 'atacar':
                if not monsters_in_room or self.mission_state['monsters_defeated'][stage_index]:
                    print("Não há o que atacar aqui.")
                    input("Pressione Enter para continuar...")
                    continue
                
                try:
                    monster_num_str = input("Digite o número do monstro que deseja atacar: ").strip()
                    monster_num = int(monster_num_str) - 1

                    if 0 <= monster_num < len(monsters_in_room):
                        monster_to_attack = monsters_in_room[monster_num]
                        id_instancia_monstro = monster_to_attack['instancia_monstro_id']
                        
                        combat_result = self.db.character_attacks_monster(self.player.id_jogador, id_instancia_monstro)
                        
                        if combat_result and combat_result['monstro_derrotado']:
                            print(f"\n{combat_result['mensagem']}")
                            print(f"Você derrotou o {monster_to_attack['monstro_nome'].strip()}!")
                            self.mission_state['monsters_defeated'][stage_index] = True
                            self.mission_state['current_stage'] += 1 # Avança para o próximo estágio
                            print("O caminho para a próxima área parece ter se aberto.")
                        elif combat_result:
                            print(f"\n{combat_result['mensagem']}")
                            print(f"Dano causado: {combat_result['dano_causado']}. Vida restante do monstro: {combat_result['vida_restante_monstro']}")
                        else:
                            print("Ocorreu um erro no combate.")
                    else:
                        print("Número do monstro inválido.")
                except (ValueError, IndexError):
                    print("Entrada inválida. Use um número da lista.")
                input("Pressione Enter para continuar...")
                continue

            # 5. Processa o movimento (se houver saídas disponíveis)
            try:
                escolha_num = int(escolha) - 1
                if 0 <= escolha_num < len(available_exits):
                    saida_escolhida = available_exits[escolha_num]
                    novo_local_id = saida_escolhida['id_saida']
                    self.db.update_localizacao_jogador(self.player.id_jogador, novo_local_id)
                    self.player.id_local = novo_local_id
                else:
                    input("Escolha de saida invalida. Pressione Enter.")
            except ValueError:
                input("Comando invalido. Pressione Enter.")


if __name__ == '__main__':
    display_cthulhu_intro()
    game = Game()
    game.start()
    if game.db:
        game.db.close()