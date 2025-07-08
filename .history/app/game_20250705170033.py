import os
import sys
# Removendo importações antigas de Corredor e Sala, pois foram unificadas no DB
from classes import Player # Agora importamos apenas Player
from database import DataBase
# import time # Importa o módulo time para usar time.sleep()
# import time # Importa o módulo time para usar time.sleep()

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
        print("--- Personagens Salvos ---")
        personagens = self.db._execute_query("SELECT id, nome, ocupacao FROM public.personagens_jogaveis ORDER BY id;", fetch_all=True)

        if personagens:
            for p in personagens:
                print(f"ID: {p['id']}, Nome: {p['nome']}, Ocupacao: {p['ocupacao']}")
        else:
            print("Nenhum personagem encontrado no banco de dados.")
        
        input("\nPressione Enter para voltar ao menu principal...")
        self.start() 

    def start(self):
        """Exibe o menu inicial e gerencia as opcoes do usuario."""
        while True:
            # clear() # Limpa a tela a cada exibição do menu
            print('\n--- Chamado de Cthulhu ---')
            print('Bem-vindo ao jogo! \n')
            print('1 - Criar Personagem')
            print('2 - Carregar personagem')
            print('3 - Listar Personagens') 
            print('4 - Sair \n')

            opcao = input('Digite a opcao desejada: ').strip()

            if opcao == '1':
                self.create_new_character_flow()
                break 
            elif opcao == '2':
                self.load_character()
                break 
            elif opcao == '3': 
                self.list_characters()
            elif opcao == '4':
                print("Saindo do jogo. Ate mais!")
                if self.db:
                    self.db.close()
                sys.exit()
            else:
                input('Opcao invalida! Digite 1, 2, 3 ou 4. Pressione Enter para tentar novamente.')


    def gameplay(self):
        if not self.player:
            print("Erro: Nenhum jogador carregado.")
            return self.start()

        print(f"\n--- Comeca a aventura de {self.player.nome}! ---")

        while True:
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
                print(f"  [{i + 1}] Ir para {saida['direcao']} ({saida['tipo_destino']}): {saida['desc_saida']}")

            # 3. Pede a acao do jogador
            print("\nO que voce deseja fazer? ('ficha', 'inventario', 'sair')")
            escolha = input("> ").strip().lower()

            if escolha == 'sair':
                break
            elif escolha == 'ficha':
                # id_jogador eh o nome correto do atributo no objeto Player
                self.db.get_ficha_personagem(self.player.id_jogador) 
                input("\nPressione Enter para continuar...")
                continue
            elif escolha == 'inventario':
                create_new_inventory()
                print("Nao implementado ainda")
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