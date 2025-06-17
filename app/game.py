import os
import sys
from classes import Player, Corredor, Sala
from database import DataBase
import time # Importa o módulo time para usar time.sleep()

def clear():
    """Limpa a tela do terminal."""
    os.system('cls' if os.name == 'nt' else 'clear')

# --- Função para a introdução do Call of Cthulhu ---
def display_cthulhu_intro():
    clear()
    print(" _____   ___   _      _       ___________   _____ _____ _   _ _   _ _      _   _ _   _ ")
    print("/  __ \\ / _ \\ | |    | |     |  _  |  ___| /  __ \\_   _| | | | | | | |    | | | | | | |")
    print("| /  \\/ /_\\ \\| |    | |     | | | | |_    | /  \\/ | | | |_| | | | | |    | |_| | | | |")
    print("| |    |  _  || |    | |     | | | |  _|   | |     | | |  _  | | | | |    |  _  | | | |")
    print("| \\__/\\| | | || |____| |____ \\ \\_/ / |     | \\__/\\ | | | | | | |_| | |____| | | | |_| |")
    print(" \\____/\\_| |_/\\_____/\\_____/  \\___/\\_|      \\____/ \\_/ \\_| |_/\\___/\\_____/\_| |_/\\___/ ")
    print("                                                                                       ")
    print("                                                                                       \n\n")



    
    time.sleep(1) # Pequena pausa para a leitura inicial do título

    print("                                            O CHAMADO ECOA...")
    time.sleep(2)
    print("                           NAS PROFUNDEZAS ESQUECIDAS DO TEMPO E DO ESPAÇO...")
    time.sleep(2)
    print("                                  UMA ENTIDADE ANTIGA AGUARDA...")
    time.sleep(2)
    print("                                       E SEU PESADELO COMEÇA.")
    time.sleep(3) # Pausa mais longa para o impacto final
    clear() # Limpa a tela antes de ir para o menu principal do jogo
# --- Fim da função de introdução ---

class Game:

    def __init__(self):
        self.db = DataBase()
        self.player = None

    def create_new_character_flow(self):
        clear()
        print("--- Criação de Novo Personagem ---")
        
        new_name = input('Digite o nome do seu personagem: ').strip()
        if not new_name:
            print('Nome inválido! Voltando ao menu principal.')
            return

        ocupacoes = [
            "Médico",
            "Doutor",
            "Arqueólogo",
            "Detetive",
            "Jornalista",
            "Professor",
            "Engenheiro",
            "Artista",
            "Soldado",
            "Explorador"
            # demais ocupacoes podem ser adicionadas aqui
        ]
        print("\nEscolha a ocupação do seu personagem:")
        for index, ocupacao in enumerate(ocupacoes, 1):
            print(f"{index}. {ocupacao}")
        new_ocupacao = None
        while new_ocupacao is None:
            escolha = input("Digite o número da ocupação desejada: ").strip()
            try:
                escolha_num = int(escolha)
                if 1 <= escolha_num <= len(ocupacoes):
                    new_ocupacao = ocupacoes[escolha_num - 1]
                else:
                    print("Ocupação inválida. Digite novamente.")
            except ValueError:
                print("Entrada inválida. Digite apenas o número da ocupação.")

        new_residencia = input('Digite a residência do seu personagem: ').strip()
        if not new_residencia: print('Residência inválida!'); return

        new_local_nascimento = input('Digite o local de nascimento do seu personagem: ').strip()
        if not new_local_nascimento: print('Local de nascimento inválido!'); return

        # --- Loop para Idade ---
        new_idade = None
        while new_idade is None:
            idade_input = input('Digite a idade do seu personagem: ').strip()
            try:
                idade = int(idade_input)
                if 1 <= idade <= 120:
                    new_idade = idade
                else:
                    print(f"Idade inválida: {idade}. Por favor, digite um número entre 1 e 120.")
            except ValueError:
                print(f"Entrada inválida: '{idade_input}'. Por favor, digite um número para a idade.")

        # --- Loop para Sexo ---
        new_sexo = None
        while new_sexo is None:
            sexo_input = input('Digite o sexo do seu personagem (masculino/feminino): ').strip().lower()
            if sexo_input in ['masculino', 'feminino']:
                new_sexo = sexo_input
            else:
                print(f"Sexo inválido: '{sexo_input}'. Por favor, digite 'masculino' ou 'feminino'.")

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
            input("Pressione Enter para continuar e iniciar o jogo...") # Pausa para o usuário ver
            self.player = self.db.get_personagem(new_name)
            if self.player:
                print(f"Bem-vindo(a) ao mundo, {self.player.nome}!")
                self.gameplay()
            else:
                print("Erro ao carregar o personagem recém-criado. Tente carregar manualmente pelo menu.")
                self.start()
        else:
            print("Falha na criação do personagem. Verifique se o nome já existe ou outros erros.")
            self.start()

    def load_character(self):
        clear()
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
            print(f"Personagem '{nome}' não encontrado. Voltando ao menu principal.")
            self.start()

    def list_characters(self):
        clear()
        print("--- Personagens Salvos ---")
        personagens = self.db._execute_query("SELECT id, nome, ocupacao FROM public.personagens_jogaveis ORDER BY id;", fetch_all=True)

        if personagens:
            for p in personagens:
                print(f"ID: {p['id']}, Nome: {p['nome']}, Ocupação: {p['ocupacao']}")
        else:
            print("Nenhum personagem encontrado no banco de dados.")
        
        input("\nPressione Enter para voltar ao menu principal...")
        self.start() # Retorna ao menu inicial

    def start(self):
        """Exibe o menu inicial e gerencia as opções do usuário."""
        while True:
            clear() # Limpa a tela a cada exibição do menu
            print('\n--- Chamado de Cthulhu ---')
            print('Bem-vindo ao jogo! \n')
            print('1 - Criar Personagem')
            print('2 - Carregar personagem')
            print('3 - Listar Personagens') # Nova opção
            print('4 - Sair \n')

            opcao = input('Digite a opção desejada: ').strip()

            if opcao == '1':
                self.create_new_character_flow()
                # Após o fluxo de criação, o gameplay é chamado ou o menu inicial é retornado
                break # Sai do loop 'start'
            elif opcao == '2':
                self.load_character()
                # Após o fluxo de carregamento, o gameplay é chamado ou o menu inicial é retornado
                break # Sai do loop 'start'
            elif opcao == '3': # Nova opção
                self.list_characters()
                # Após listar, a função list_characters() chama start() novamente
            elif opcao == '4':
                print("Saindo do jogo. Até mais!")
                if self.db:
                    self.db.close()
                sys.exit()
            else:
                input('Opção inválida! Digite 1, 2, 3 ou 4. Pressione Enter para tentar novamente.')


    def gameplay(self):
        if not self.player:
            print("Erro: Nenhum jogador carregado.")
            return self.start()

        print(f"\n--- Começa a aventura de {self.player.nome}! ---")

        while True:
            detalhes_local = None
            local_atual = None

            # 1. Determina onde o jogador está e busca os detalhes
            if self.player.id_sala:
                local_atual = 'sala'
                detalhes_local = self.db.get_sala_com_saidas(self.player.id_sala)
            elif self.player.id_corredor:
                local_atual = 'corredor'
                detalhes_local = self.db.get_corredor_com_saidas(self.player.id_corredor)

            if not detalhes_local:
                location_id = self.player.id_sala or self.player.id_corredor
                print(f"Erro: Não foi possível carregar os detalhes do local ID: {location_id}")
                return self.start()

            # 2. Mostra o status atual
            clear()
            print("==================================================")
            if local_atual == 'sala':
                print(f"Você está em uma SALA: {detalhes_local['descricao']}")
            elif local_atual == 'corredor':
                print(f"Você está em um CORREDOR: {detalhes_local['descricao']}")
            print("==================================================")
            print("\nSAÍDAS DISPONÍVEIS:")
            
            saidas = detalhes_local['saidas']
            if not saidas:
                print("Não há saídas visíveis daqui.")
                input("Pressione Enter para continuar...")
                continue

            for i, saida in enumerate(saidas):
                destino_tipo = "Corredor" if local_atual == 'sala' else "Sala"
                print(f"  [{i + 1}] Ir para {destino_tipo}: {saida['desc_saida']}")

            # 3. Pede a ação do jogador
            print("\nO que você deseja fazer? ('ficha', 'inventario', 'sair')")
            escolha = input("> ").strip().lower()

            if escolha == 'sair':
                break
            elif escolha == 'ficha':
                self.db.get_ficha_personagem(self.player.idJogador)
                input("\n Precisione Enter para continuar...")
                continue
            elif escolha == 'inventario':
                print("Não implementado ainda")
                input("\nPressione Enter para continuar...")
                continue
            
            # 4. Processa o movimento
            try:
                escolha_num = int(escolha) - 1
                if 0 <= escolha_num < len(saidas):
                    saida_escolhida = saidas[escolha_num]
                    id_destino = saida_escolhida['id_saida']

                    if local_atual == 'sala':
                        self.db.update_localizacao_jogador(self.player.idJogador, novo_corredor_id=id_destino)
                        self.player.id_sala = None
                        self.player.id_corredor = id_destino
                    elif local_atual == 'corredor':
                        self.db.update_localizacao_jogador(self.player.idJogador, nova_sala_id=id_destino)
                        self.player.id_corredor = None
                        self.player.id_sala = id_destino
                else:
                    input("Escolha de saída inválida. Pressione Enter.")
            except ValueError:
                input("Comando inválido. Pressione Enter.")

        self.start()


if __name__ == '__main__':
    display_cthulhu_intro()
    game = Game()
    game.start()
    # No final do script principal, garante que a conexão do DB seja fechada.
    # Isso é importante se o sys.exit() não for chamado por algum motivo.
    if game.db:
        game.db.close()