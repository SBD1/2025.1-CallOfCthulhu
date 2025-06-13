import os
import sys
from classes import Player, Corredor, Sala
from database import DataBase

def clear():
    """Limpa a tela do terminal."""
    os.system('cls' if os.name == 'nt' else 'clear')

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

        new_ocupacao = input('Digite a ocupação do seu personagem: ').strip()
        if not new_ocupacao: print('Ocupação inválida!'); return

        new_residencia = input('Digite a residência do seu personagem: ').strip()
        if not new_residencia: print('Residência inválida!'); return

        new_local_nascimento = input('Digite o local de nascimento do seu personagem: ').strip()
        if not new_local_nascimento: print('Local de nascimento inválido!'); return

        try:
            new_idade = int(input('Digite a idade do seu personagem: ').strip())
            if not (1 <= new_idade <= 120):
                print("Idade inválida! (Entre 1 e 120).")
                return
        except ValueError:
            print("Idade inválida! Digite um número.")
            return

        new_sexo = input('Digite o sexo do seu personagem (masculino/feminino): ').strip().lower()
        if new_sexo not in ['masculino', 'feminino']:
            print('Sexo inválido! Digite "masculino" ou "feminino".')
            return

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
        """O loop principal do jogo onde as ações do jogador ocorrem."""
        if not self.player:
            print("Erro: Nenhum jogador carregado para iniciar o gameplay.")
            self.start()
            return

        print(f"\n--- Começa a aventura de {self.player.nome}! ---")

        while True:
            detalhes_sala = self.db.get_sala_com_saidas(self.player.id_sala)

            if not detalhes_sala:
                print(f"Erro: Não foi possível carregar os detalhes da sala ID: {self.player.id_sala}")
                input("Pressione Enter para voltar ao menu principal...")
                self.start()
                return

            clear()
            print("==================================================")
            print(f"Você está em: {detalhes_sala['descricao']}")
            print("==================================================")
            print("\nSAÍDAS DISPONÍVEIS:")

            saidas = detalhes_sala['saidas']
            if not saidas:
                print("Não há saídas visíveis desta sala.")
                print("Você deve encontrar outro caminho ou interagir com o ambiente.")
                input("Pressione Enter para continuar (por enquanto, você está preso aqui)...")
                # Se não houver saídas, você pode implementar outras ações aqui
                # Por agora, voltamos ao menu principal para não deixar o jogo "parado"
                self.start()
                return
                
            for i, saida in enumerate(saidas):
                print(f"  [{i + 1}] {saida['desc_corredor']} (Leva para a sala {saida['id_sala_destino']})")

            print("\nO que você deseja fazer?")
            print("  Digite o número da saída para se mover.")
            print("  'status' para ver seus atributos.")
            print("  'inventario' para ver seus itens.")
            print("  'sair' para encerrar o jogo.")
            
            escolha = input("> ").strip().lower()

            if escolha == 'sair':
                print(f"Aventura de {self.player.nome} encerrada. Até a próxima!")
                break
            elif escolha == 'status':
                clear()
                print("--- Seus Atributos ---")
                player_details = self.db.get_personagem(self.player.nome) # Usando nome para buscar detalhes completos
                # Alternativamente, você poderia ter um método get_character_by_id em DataBase
                if player_details: # get_personagem já retorna um objeto Player
                    print(f"Nome: {player_details.nome}")
                    print(f"Ocupação: {player_details.ocupacao}")
                    print(f"Idade: {player_details.idade}, Sexo: {player_details.sexo}")
                    print(f"Força: {player_details.forca}, Constituição: {player_details.constituicao}")
                    print(f"Poder: {player_details.poder}, Destreza: {player_details.destreza}")
                    print(f"Aparência: {player_details.aparencia}, Tamanho: {player_details.tamanho}")
                    print(f"Inteligência: {player_details.inteligencia}, Educação: {player_details.educacao}")
                    print(f"Movimento: {player_details.movimento}")
                    print(f"Sanidade Atual: {player_details.sanidade_atual}, Sanidade Máxima: {player_details.PM_max * 5}") # PM_max * 5 é um cálculo aproximado, use sanidade_maxima se a view retornar
                    print(f"PM Base: {player_details.PM_base}, PM Máximo: {player_details.PM_max}")
                    print(f"Pontos de Vida Atual: {player_details.pontos_de_vida_atual}")
                    # Ideia, Conhecimento, Sorte não estão no objeto Player direto, mas na view.
                    # Se quiser exibir, precisaria de outro método no database.py
                    # ou ajustar o get_personagem para usar a view e incluir esses atributos no objeto Player
                else:
                    print("Não foi possível carregar os detalhes do personagem.")
                input("\nPressione Enter para continuar...")
            elif escolha == 'inventario':
                clear()
                print("--- Seu Inventário ---")
                self.db.get_view_inventory(self.player.inventario)
                input("\nPressione Enter para continuar...")
            else:
                try:
                    escolha_num = int(escolha) - 1
                    if 0 <= escolha_num < len(saidas):
                        saida_escolhida = saidas[escolha_num]
                        nova_sala_id = saida_escolhida['id_sala_destino']

                        self.db.update_localizacao_jogador(self.player.idJogador, nova_sala_id)
                        
                        self.player.sala = nova_sala_id # Atualiza o atributo do objeto Player
                        
                        print(f"\nVocê se move para a sala {nova_sala_id}...")

                    else:
                        input("Escolha de saída inválida. Pressione Enter para tentar novamente.")
                except ValueError:
                    input("Comando inválido. Por favor, digite um número para mover ou um comando. Pressione Enter para tentar novamente.")

        # Ao sair do loop gameplay, volta para o menu inicial
        self.start()


if __name__ == '__main__':
    game = Game()
    game.start()
    # No final do script principal, garante que a conexão do DB seja fechada.
    # Isso é importante se o sys.exit() não for chamado por algum motivo.
    if game.db:
        game.db.close()