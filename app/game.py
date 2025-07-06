import os
import sys
# Removendo importações antigas de Corredor e Sala, pois foram unificadas no DB
from classes import Player # Agora importamos apenas Player
from database import DataBase
# import time # Importa o módulo time para usar time.sleep()
# import time # Importa o módulo time para usar time.sleep()
import time # para a lua de sangue
import schedule # para a movimentação programada dos monstros
import threading # usa uma thread somente para a movimentação dos monstros

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
        self.scheduler_thread = None 

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
                self.gameplay()
            else:
                print("Erro ao carregar o personagem recem-criado. Tente carregar manualmente pelo menu.")
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
                print(f"|ID: {p['id']}, Nome: {p['nome']}, Ocupacao: {p['ocupacao']}")
            print("==========================================\n")
        else:
            print("Nenhum personagem encontrado no banco de dados.")
    

    def start(self):
        """Exibe o menu inicial e gerencia as opcoes do usuario."""
        while True:
            # clear() # Limpa a tela a cada exibição do menu
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
                input('Opcao invalida! Digite 1, 2, 3 ou 4. Pressione Enter para tentar novamente.')

    def _run_monster_movement_task(self):
        """
        Tarefa interna para ser executada pelo agendador.
        Chama a stored procedure sp_movimentar_monstros.
        """
        print("Os monstros estão mudando de sala, perigos se aproximam...")
        self.db.movimentar_todos_os_monstros() 
        print("Cuidado, os monstros já estão em novas salas.")

    def _scheduler_loop(self):
        """Loop que executa as tarefas agendadas."""
        while True:
            schedule.run_pending()
            time.sleep(1)

    def start_monster_movement_scheduler(self):
        """Inicia o agendador de movimento de monstros em uma thread separada."""
        # Agendar a execução da função a cada 60 segundos (para teste) ou 5 minutos (para jogo real)
        schedule.every(60).seconds.do(self._run_monster_movement_task) # Alterado para 60 segundos para facilitar o teste

        # Inicia a thread do agendador
        self.scheduler_thread = threading.Thread(target=self._scheduler_loop, daemon=True)
        self.scheduler_thread.start()
        print("Agendador de movimento de monstros iniciado em segundo plano.")

    def gameplay(self):
        if not self.player:
            print("Erro: Nenhum jogador carregado.")
            return self.start()

        print(f"\n--- Comeca a aventura de {self.player.nome}! ---")
        self.start_monster_movement_scheduler()
        while True:

            current_time = time.time()
            if current_time - self.last_lua_de_sangue_time >= 60:
                self.db.trigger_lua_de_sangue() # Chama o método que invoca a stored procedure
                self.last_lua_de_sangue_time = current_time # Reseta o timer

            # 1. Determina onde o jogador esta e busca os detalhes do local
            detalhes_local = self.db.get_local_details_and_exits(self.player.id_local)

            if not detalhes_local:
                # Agora, o ID é simplesmente self.player.id_local, não id_sala ou id_corredor
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
                print(f"  [{i + 1}] Ir para {saida['direcao']} ({saida['tipo_destino']})")

            # 3. Pede a acao do jogador
            print("\nO que voce deseja fazer? (Abrir Ficha [f], Abrir Inventário [i], Vasculhar [v], Procurar Monstros [p], Sair [s])")
            escolha = input("> ").strip().lower()

            if escolha == 's':
                break
            elif escolha == 'f':
                # id_jogador eh o nome correto do atributo no objeto Player
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


if __name__ == '__main__':
    display_cthulhu_intro()
    game = Game()
    game.start()
    if game.db:
        game.db.close()