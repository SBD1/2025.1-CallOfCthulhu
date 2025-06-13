import psycopg2
import psycopg2.extras 
import pandas as pd
import random
from psycopg2 import OperationalError, errorcodes, errors
from classes import *

class DataBase:
    """
    Gerencia a conexão e operações com o banco de dados PostgreSQL,
    seguindo o estilo de funções de classe e métodos de instância que recebem a conexão.
    """

    def __init__(self):
    #     Inicializa a classe e tenta estabelecer a conexão com o banco de dados.
         self.connection = None # A conexão será atribuída por _create_connection
         try:
             self.connection = self._create_connection()
         except Exception as e:
    #         Captura a exceção de conexão e a exibe, mas não re-lança para o __main__
    #         Isso permite que o __main__ continue e teste se a conexão foi bem-sucedida ou não.
             print(f"Falha na inicialização do banco de dados: {e}")

    def _create_connection(self):
        """
        Cria e retorna uma conexão com o banco de dados.
        Levanta uma exceção em caso de falha na conexão.
        """
        conn = None
        try:
            conn = psycopg2.connect(
                host="localhost",
                database="call_of_chtulhu",  # Verifique o nome do seu banco de dados
                user="postgres",
                password="postgres",
                port=5431  # Verifique a porta. O padrão é 5432.
            )
            # Autocommit para operações de escrita (INSERT, UPDATE, DELETE) serem salvas automaticamente
            conn.autocommit = True
            print("Conexão com o banco de dados estabelecida com sucesso!")
            return conn
        except OperationalError as e:
            print(f"Falha ao conectar ao banco de dados: {e}")
            raise # Re-lança a exceção para ser capturada na inicialização
        except Exception as e:
            print(f"Erro inesperado ao criar conexão: {e}")
            raise

    def close(self):
        """Fecha a conexão com o banco de dados."""
        if self.connection and not self.connection.closed:
            self.connection.close()
            self.connection = None
            print("Conexão com o banco de dados fechada.")
        elif self.connection is None:
            print("Conexão já estava fechada ou nunca foi estabelecida.")

    # --- Métodos Auxiliares para Execução de Query ---

    def _execute_query(self, query: str, params: tuple = None, fetch_all: bool = False, fetch_one: bool = False):
        """
        Método auxiliar para executar consultas SQL de forma segura.
        Gerencia a criação e fechamento do cursor.
        """
        # Tenta reconectar se a conexão estiver fechada ou não estabelecida
        if self.connection is None or self.connection.closed:
            print("Conexão inativa ou fechada. Tentando restabelecer antes de executar a query...")
            try:
                self.connection = self._create_connection()
            except Exception:
                print("Não foi possível restabelecer a conexão. Abortando consulta.")
                return None

        cursor = None
        try:
            # Utiliza um gerenciador de contexto (with) para garantir que o cursor seja fechado
            cursor = self.connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            cursor.execute(query, params) # Use params para segurança!

            if cursor.description: # Se for um SELECT (o cursor tem uma descrição de colunas)
                if fetch_one:
                    return cursor.fetchone()
                elif fetch_all:
                    return cursor.fetchall()
                else: # Comportamento padrão para SELECTs: fetch_all
                    return cursor.fetchall()
            return None # Para INSERT, UPDATE, DELETE (queries DML)

        except (OperationalError, errors.Error) as e:
            print(f"Erro ao executar consulta '{query}': {e}")
            # Você pode adicionar lógica de rollback aqui se autocommit fosse False
            return None
        except Exception as e:
            print(f"Erro inesperado ao executar consulta: {e}")
            return None
        finally:
            if cursor: # Garante que o cursor seja fechado se criado
                cursor.close()

#Exemplo

    def get_corredor(self, id_corredor: int):
            """
            Retorna um objeto Corredor pelo ID.
            Retorna None se o corredor não for encontrado ou em caso de erro.
            """
            query = "SELECT id, status, descricao FROM public.corredores WHERE id = %s;"
            # Usamos _execute_query para buscar apenas uma linha
            corredor_data = self._execute_query(query, (id_corredor,), fetch_one=True)

            if corredor_data:
                # Assumindo que as colunas retornadas pelo RealDictCursor são 'id', 'status', 'descricao'
                return Corredor(
                    idCorredor=corredor_data['id'],
                    status=corredor_data['status'],
                    descricao=corredor_data['descricao']
                )
            else:
                print(f"Corredor com ID {id_corredor} não encontrado ou erro na consulta.")
                return None



    #Aqui Luiz

    def get_personagem(self, nome_personagem: str): 
        """
        Retorna um objeto Player (Personagem Jogável) pelo nome.
        Retorna None se o personagem não for encontrado ou em caso de erro.
        """
        query = """
        SELECT
            id, nome, ocupacao, residencia, local_nascimento, idade, sexo,
            forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao,
            movimento, sanidade_atual, insanidade_temporaria, insanidade_indefinida,
            pm_base, pm_max, pontos_de_vida_atual,
            id_sala, id_corredor, id_inventario, id_armadura, id_arma, id_tipo_personagem
        FROM
            public.personagens_jogaveis
        WHERE
            nome = %s;
        """
        personagem_data = self._execute_query(query, (nome_personagem,), fetch_one=True)

        if personagem_data:
            return Player(
                idJogador=personagem_data['id'],
                nome=personagem_data['nome'],
                ocupacao=personagem_data['ocupacao'],
                residencia=personagem_data['residencia'],
                local_nascimento=personagem_data['local_nascimento'],
                idade=personagem_data['idade'],
                sexo=personagem_data['sexo'],
                forca=personagem_data['forca'],
                constituicao=personagem_data['constituicao'],
                poder=personagem_data['poder'],
                destreza=personagem_data['destreza'],
                aparencia=personagem_data['aparencia'],
                tamanho=personagem_data['tamanho'],
                inteligencia=personagem_data['inteligencia'],
                educacao=personagem_data['educacao'],
                movimento=personagem_data['movimento'],
                sanidade_atual=personagem_data['sanidade_atual'],
                insanidade_temporaria=personagem_data['insanidade_temporaria'],
                insanidade_indefinida=personagem_data['insanidade_indefinida'],
                PM_base=personagem_data['pm_base'], 
                PM_max=personagem_data['pm_max'],
                pontos_de_vida_atual=personagem_data['pontos_de_vida_atual'],
                id_sala=personagem_data['id_sala'],
                id_corredor=personagem_data['id_corredor'],
                id_inventario=personagem_data['id_inventario'],
                id_armadura=personagem_data['id_armadura'],
                id_arma=personagem_data['id_arma'],
                id_tipo_personagem=personagem_data['id_tipo_personagem']
            )
        else:
            print(f"Personagem '{nome_personagem}' não encontrado ou erro na consulta.")
            return None

    def create_new_character(self, nome: str, ocupacao: str, residencia: str, local_nascimento: str, idade: int, sexo: str):
    
            new_forca = random.randint(3, 18)
            new_constituicao = random.randint(3, 18)
            new_poder = random.randint(3, 18)
            new_destreza = random.randint(3, 18)
            new_aparencia = random.randint(3, 18)
            new_tamanho = random.randint(3, 18)
            new_inteligencia = random.randint(3, 18)
            new_educacao = random.randint(3, 18)
    
            pontos_de_vida_atual = (new_constituicao + new_tamanho) // 2
            sanidade_atual = new_poder * 5
            pm_max = new_poder * 5
            pm_base = pm_max 
            
            movimento = 8 
            if new_destreza < new_tamanho and new_forca < new_tamanho:
                movimento = 7
            elif new_destreza > new_tamanho and new_forca > new_tamanho:
                movimento = 9

            insanidade_temporaria = False
            insanidade_indefinida = False
    
            # novo_id_personagem = random.randint(100, 9999)
    
            id_inventario = self.create_new_inventory()
            if not id_inventario: 
                print('Falha ao criar o invetário')
                return None
            
            id_sala_inicial = 2 
            id_corredor_inicial = None 
            id_armadura_inicial = None 
            id_arma_inicial = None     
            id_tipo_personagem = 1 
    
            """
            Cria um novo personagem
            """
            query = """
            INSERT INTO public.personagens_jogaveis (
                nome, ocupacao, residencia, local_nascimento, idade, sexo,
                forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao,
                movimento, sanidade_atual, insanidade_temporaria, insanidade_indefinida,
                PM_base, PM_max, pontos_de_vida_atual,
                id_sala, id_corredor, id_inventario, id_armadura, id_arma, id_tipo_personagem
            ) VALUES (
                %s, %s, %s, %s, %s, %s,
                %s, %s, %s, %s, %s, %s, %s, %s,
                %s, %s, %s, %s,
                %s, %s, %s,
                %s, %s, %s, %s, %s, %s
            ) RETURNING id; 
            """
            
            params = (
                nome, ocupacao, residencia, local_nascimento, idade, sexo,
                new_forca, new_constituicao, new_poder, new_destreza, new_aparencia, new_tamanho, new_inteligencia, new_educacao,
                movimento, sanidade_atual, insanidade_temporaria, insanidade_indefinida,
                pm_base, pm_max, pontos_de_vida_atual,
                id_sala_inicial, id_corredor_inicial, id_inventario, id_armadura_inicial, id_arma_inicial, id_tipo_personagem
            )
    
            new_player_id_data = self._execute_query(query, params, fetch_one=True)
            
            if new_player_id_data:
                novo_id_personagem = new_player_id_data['id'] 
                print(f"Personagem '{nome}' criado com sucesso com ID: {novo_id_personagem}")
                return novo_id_personagem 
            else:
                print(f"Falha ao criar personagem '{nome}'.")
                return None 
    

    def create_new_inventory(self):
        query = "INSERT INTO public.inventarios (tamanho) VALUES (%s) RETURNING id;"
        result = self._execute_query(query, (32,), fetch_one= True) # Corrigido para tupla (32,)
        if result: 
            return result['id']
        return None

    # Em database.py, adicione estes dois métodos DENTRO da classe DataBase

    def get_sala_com_saidas(self, id_sala: int):
        """
        Busca a descrição de uma sala e todas as suas saídas conectadas.
        Uma saída é um corredor que leva a outra sala.
        """
        # Dicionário para guardar os resultados
        resultado = {'id': id_sala, 'descricao': None, 'saidas': []}

        # Consulta 1: Pega a descrição da sala atual.
        desc_query = "SELECT descricao FROM public.salas WHERE id = %s;"
        sala_data = self._execute_query(desc_query, (id_sala,), fetch_one=True)
        if not sala_data:
            return None # Sala não existe
        resultado['descricao'] = sala_data['descricao']

        # Consulta 2: Pega todos os corredores conectados a esta sala e para onde eles levam.
        # Esta consulta une a tabela de junção com ela mesma através do corredor
        # para encontrar a sala de origem e a sala de destino.
        saidas_query = """
            SELECT
                corredor.id AS id_corredor,
                corredor.descricao AS desc_corredor,
                destino.id_sala AS id_sala_destino
            FROM
                public.corredores_salas_destino AS origem
            JOIN
                public.corredores AS corredor ON origem.id_corredor = corredor.id
            JOIN
                public.corredores_salas_destino AS destino ON origem.id_corredor = destino.id_corredor
            WHERE
                origem.id_sala = %s AND destino.id_sala != %s;
        """
        saidas_data = self._execute_query(saidas_query, (id_sala, id_sala), fetch_all=True)

        if saidas_data:
            resultado['saidas'] = saidas_data

        return resultado

    def get_corredor_com_saidas(self, id_sala: int):
        """
        Busca a descrição de um corredor e todas as suas saídas conectadas.
        Uma saída é uuma sala que leva a outro corredor.
        """
        # Dicionário para guardar os resultados
        resultado = {'id': id_sala, 'descricao': None, 'saidas': []}

        # Consulta 1: Pega a descrição da sala atual.
        desc_query = "SELECT descricao FROM public.corredores WHERE id = %s;"
        sala_data = self._execute_query(desc_query, (id_sala,), fetch_one=True)
        if not sala_data:
            return None # Corredor não existe
        resultado['descricao'] = sala_data['descricao']

        # Consulta 2: Pega todos os corredores conectados a esta sala e para onde eles levam.
        # Esta consulta une a tabela de junção com ela mesma através do corredor
        # para encontrar a sala de origem e a sala de destino.
        saidas_query = """
            SELECT
                sala.id AS id_corredor,
                sala.descricao AS desc_corredor,
                destino.id_corredor AS id_sala_destino
            FROM
                public.corredores_salas_destino AS origem
            JOIN
                public.salas AS sala ON origem.id_sala = sala.id
            JOIN
                public.corredores_salas_destino AS destino ON origem.id_sala = destino.id_sala
            WHERE
                origem.id_corredor = %s AND destino.id_corredor != %s;
        """
        saidas_data = self._execute_query(saidas_query, (id_sala, id_sala), fetch_all=True)

        if saidas_data:
            resultado['saidas'] = saidas_data

        return resultado


    def update_localizacao_jogador_na_sala(self, id_jogador: int, nova_sala_id: int):
        """
        Atualiza a localização do jogador para um novo corredor no banco de dados.
        """
        # Define a nova sala e zera o corredor para cumprir a regra do banco de dados
        query = """
            UPDATE public.personagens_jogaveis
            SET id_sala = NULL, id_corredor = %s
            WHERE id = %s;
        """
        self._execute_query(query, (nova_sala_id, id_jogador))
        print(f"[DB] Localização do jogador {id_jogador} atualizada para corredor {nova_sala_id}.")

    def update_localizacao_jogador_no_corredor(self, id_jogador: int, nova_sala_id: int):
        """
        Atualiza a localização do jogador para uma nova sala no banco de dados.
        """
        # Define a nova sala e zera o corredor para cumprir a regra do banco de dados
        query = """
            UPDATE public.personagens_jogaveis
            SET id_sala = %s, id_corredor = NULL
            WHERE id = %s;
        """
        self._execute_query(query, (nova_sala_id, id_jogador))
        print(f"[DB] Localização do jogador {id_jogador} atualizada para corredor {nova_sala_id}.")


# --- Bloco de Teste para o Modelo Básico ---
# Este bloco será executado apenas quando você rodar 'python database.py'
if __name__ == "__main__":
    db = None 
    try:
        db = DataBase()

        if db.connection and not db.connection.closed:
            print("\n--- Conexão bem-sucedida. Realizando testes: ---")

            # --- Teste de create_new_character ---
            print("\nTeste: Criando um novo personagem 'Teste Heroi'...")
            novo_id = db.create_new_character(
                nome="Teste Heroi",
                ocupacao="Explorador",
                residencia="Arkham",
                local_nascimento="Dunwich",
                idade=30,
                sexo="masculino"
            )
            if novo_id:
                print(f"Personagem 'Teste Heroi' criado com ID: {novo_id}. Verifique no banco de dados.")
                # Opcional: buscar e exibir o personagem criado
                personagem_criado = db._execute_query(f"SELECT id, nome, ocupacao FROM public.personagens_jogaveis WHERE id = {novo_id};", fetch_one=True)
                if personagem_criado:
                    print(f"Dados do personagem recém-criado: {personagem_criado}")
            else:
                print("Falha na criação do personagem 'Teste Heroi'.")

            # ... (Mantenha seus outros testes aqui para verificar o restante do database.py) ...

        else:
            print("\nNão foi possível realizar os testes básicos de consulta pois a conexão com o banco de dados falhou.")

    except Exception as e:
        print(f"\nUm erro inesperado ocorreu durante a execução do script: {e}")
    finally:
        if db:
            db.close()


