from database import DataBase
from classes import *
import sys
import os

def clear():
    os.system('cls' if os.name == 'nt' else 'clear')

class Game:

    def __init__(self):
        self.db = DataBase()
        self.player = None
        self.valid_cmd = 0
        pass

    def crate_new_character(self):
        clear()
        new_name = input('Digite o nome do seu personagem: ')
        if new_name == '':
            print('Digite um nome válido!')
            return

        new_ocupacao = input('Digite a ocupação do seu personagem: ')
        if new_ocupacao == '':
            print('Digite uma ocupação válida')
            return

        new_residencia = input('Digite a residência do seu personagem: ')
        if new_residencia == '':
            print('Digite uma residência válida')
            return

        new_local_nascimento = input('Digite o local de nascimento do seu personagem: ')
        if new_local_nascimento == '':
            print('Digite um local de nascimento válido')
            return

        new_idade = input('Digite a idade do seu personagem: ')

        new_sexo = input('Digite o sexo do seu personagem: ')
        if new_sexo == '':
            print('Digite um sexo válido')
            return

        self.db.create_new_character(new_name, new_ocupacao, new_residencia, new_local_nascimento, new_idade, new_sexo)
        self.gameplay()

    def load_character(self):
        clear()
        nome = input('Digite o nome do personagem ou sair: ')
        if nome.lower() == 'sair':
            self.start()
            return
        player_obj = self.db.get_personagem(nome)

        if player_obj:
            self.player = player_obj
            print(f"\n Personagem {self.player.nome} carregado com sucesso!")
            self.gameplay()
        else:
            print("Voltando ao menu principal")
            self.start()

    def start(self):

        print('Chamado de Cthullhu')
        print('Bem vindo ao jogo! \n')
        print('1 - Criar Personagem \n')
        print('2 - Carregar personagem \n')
        print('3 - Sair \n')

        print('Digite a opção desejada: ')

        opcao = 0

        while(opcao not in [1,2,3]):
            opcao = input('> ')

            if opcao == '1':
                self.crate_new_character()
            
            if opcao == '2':
                self.load_character()
                break

            if opcao == '3':
                sys.exit()
                break
            
            else:
                print('Opção inválida!')

    def gameplay(self):
        if not self.player:
            print("Nenhum jogador carregado. Voltando ao menu.")
            self.start()
            return

        while True: # O loop principal do jogo
            # 1. Busca os detalhes da sala atual (descrição e saídas)
            detalhes_sala = self.db.get_sala_com_saidas(self.player.id_sala)

            if not detalhes_sala:
                print(f"Erro: Não foi possível carregar os detalhes da sala ID: {self.player.id_sala}")
                self.start() # Volta para o menu principal em caso de erro
                return

            clear()
            print("==================================================")
            # 2. Mostra a descrição da sala
            print(f"Você está em: {detalhes_sala['descricao']}")
            print("==================================================")
            print("\nSAÍDAS DISPONÍVEIS:")

            # 3. Mostra as saídas numeradas para o jogador
            saidas = detalhes_sala['saidas']
            if not saidas:
                print("Não há saídas visíveis desta sala.")
                # O que fazer aqui? Por enquanto, vamos voltar ao menu.
                # No futuro, pode haver outras ações (procurar, usar item etc.)
                input("Pressione Enter para voltar ao menu...")
                self.start()
                return
                
            for i, saida in enumerate(saidas):
                print(f"  [{i + 1}] {saida['desc_corredor']} (Leva para a sala {saida['id_sala_destino']})")

            print("\nDigite o número da saída que deseja pegar ou 'sair' para voltar ao menu:")
            
            # 4. Pega a escolha do jogador
            escolha = input("> ")

            if escolha.lower() == 'sair':
                self.start()
                return

            try:
                escolha_num = int(escolha) - 1
                if 0 <= escolha_num < len(saidas):
                    # 5. Se a escolha for válida, atualiza a localização
                    saida_escolhida = saidas[escolha_num]
                    nova_sala_id = saida_escolhida['id_sala_destino']

                    # Atualiza no banco de dados
                    self.db.update_localizacao_jogador(self.player.idJogador, nova_sala_id)
                    
                    # Atualiza no objeto do jogador
                    self.player.id_sala = nova_sala_id
                    
                    print(f"\nVocê se move para a sala {nova_sala_id}...")

                else:
                    input("Escolha inválida. Pressione Enter para tentar novamente.")
            except ValueError:
                input("Por favor, digite um número. Pressione Enter para tentar novamente.")

if __name__ == '__main__':
    game = Game()
    game.start()