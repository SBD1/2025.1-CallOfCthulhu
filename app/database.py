import psycopg2
import psycopg2.extras 
import random
from psycopg2 import OperationalError, errors
from classes import Player # Agora importamos apenas Player, ja que Sala e Corredor foram removidas de classes.py

class DataBase:
    """
    Gerencia a conexão e operações com o banco de dados PostgreSQL,
    seguindo o estilo de funções de classe e métodos de instância que recebem a conexão.
    """

    def __init__(self):
        self.connection = None 
        try:
            self.connection = self._create_connection()
        except Exception as e:
            print(f"Falha na inicializacao do banco de dados: {e}")

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
            conn.autocommit = True
            print("Conexao com o banco de dados estabelecida com sucesso!")
            return conn
        except OperationalError as e:
            print(f"Falha ao conectar ao banco de dados: {e}")
            raise 
        except Exception as e:
            print(f"Erro inesperado ao criar conexao: {e}")
            raise

    def close(self):
        """Fecha a conexão com o banco de dados."""
        if self.connection and not self.connection.closed:
            self.connection.close()
            self.connection = None
            print("Conexao com o banco de dados fechada.")
        elif self.connection is None:
            print("Conexao ja estava fechada ou nunca foi estabelecida.")

    # --- Métodos Auxiliares para Execução de Query ---

    def _execute_query(self, query: str, params: tuple = None, fetch_all: bool = False, fetch_one: bool = False):
        """
        Método auxiliar para executar consultas SQL de forma segura.
        Gerencia a criação e fechamento do cursor.
        """
        if self.connection is None or self.connection.closed:
            print("Conexao inativa ou fechada. Tentando restabelecer antes de executar a query...")
            try:
                self.connection = self._create_connection()
            except Exception:
                print("Nao foi possivel restabelecer a conexao. Abortando consulta.")
                return None

        cursor = None
        try:
            cursor = self.connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            cursor.execute(query, params)

            if cursor.description:
                if fetch_one:
                    return cursor.fetchone()
                elif fetch_all:
                    return cursor.fetchall()
                else: 
                    return cursor.fetchall() # Comportamento padrao para SELECTs
            return None 

        except (OperationalError, errors.Error) as e:
            print(f"Erro ao executar consulta '{query}': {e}")
            return None
        except Exception as e:
            print(f"Erro inesperado ao executar consulta: {e}")
            return None
        finally:
            if cursor: 
                cursor.close()

    # REMOVIDO: get_corredor (nao existe mais a tabela 'corredores')
    # REMOVIDO: get_sala_com_saidas (nao existe mais a tabela 'salas')
    # REMOVIDO: get_corredor_com_saidas (nao existe mais a tabela 'corredores')
    # REMOVIDO: update_localizacao_jogador_na_sala (substituido por update_localizacao_jogador)

    def get_personagem(self, nome_personagem: str): 
        """
        Retorna um objeto Player (Personagem Jogável) pelo nome.
        Retorna None se o personagem não for encontrado ou em caso de erro.
        """
        query = """
        SELECT
            pj.id, pj.nome, pj.ocupacao, pj.residencia, pj.local_nascimento, pj.idade, pj.sexo,
            pj.forca, pj.constituicao, pj.poder, pj.destreza, pj.aparencia, pj.tamanho, pj.inteligencia, pj.educacao,
            pj.movimento, pj.sanidade_atual, pj.insanidade_temporaria, pj.insanidade_indefinida,
            pj.pm_base, pj.pm_max, pj.pontos_de_vida_atual,
            pj.id_local, -- AGORA EH APENAS id_local
            pj.id_inventario, pj.id_armadura, pj.id_arma,
            v.ideia, v.conhecimento, v.sorte, v.pts_de_vida AS pts_de_vida_maximo, v.sanidade_maxima
        FROM
            public.personagens_jogaveis pj
        JOIN
            public.view_personagens_jogaveis_completos v ON pj.id = v.id
        WHERE
            pj.nome = %s;
        """
        personagem_data = self._execute_query(query, (nome_personagem,), fetch_one=True)

        if personagem_data:
            # Passa apenas id_local para o construtor do Player
            return Player(
                id_jogador=personagem_data['id'],
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
                id_local=personagem_data['id_local'], # ATUALIZADO
                id_inventario=personagem_data['id_inventario'],
                id_armadura=personagem_data['id_armadura'],
                id_arma=personagem_data['id_arma'],
                # Passa os atributos calculados da view para o objeto Player
                ideia=personagem_data['ideia'],
                conhecimento=personagem_data['conhecimento'],
                sorte=personagem_data['sorte'],
                pts_de_vida_maximo=personagem_data['pts_de_vida_maximo'],
                sanidade_maxima=personagem_data['sanidade_maxima']
            )
        else:
            print(f"Personagem '{nome_personagem}' nao encontrado ou erro na consulta.")
            return None

    def create_new_character(self, nome: str, ocupacao: str, residencia: str, local_nascimento: str, idade: int, sexo: str):
        """
        Cria um novo personagem chamando a Stored Procedure no banco de dados.
        A aplicação apenas envia os dados básicos e recebe o ID de volta.
        Utiliza da função 'public.sp_criar_personagem()' para criar o personagem.
        Retorna o ID do novo personagem ou None em caso de falha.
        """
        try:
            print(f"Solicitando ao banco de dados para criar o personagem '{nome}'...")

            # Usamos SELECT para obter o valor de retorno da função 'public.sp_criar_personagem()'.
            # Aqui especificamos qual o tipo de cada uma das strings ao invés de enviar somente uma string '%s'
            #   Ex: %s::public.nome, indica que o parâmetro deve ser tratado como do domínio de tipo 'public.nome'
            query = "SELECT public.sp_criar_personagem(" \
            "%s::public.nome, " \
            "%s::public.ocupacao, " \
            "%s::public.residencia, " \
            "%s::public.local_nascimento, " \
            "%s::public.idade, " \
            "%s::public.sexo);"

            params = (
                nome,
                ocupacao,
                residencia,
                local_nascimento,
                idade,
                sexo
            )

            # Executa a query e espera receber o ID do novo personagem
            new_player_id_data = self._execute_query(query, params, fetch_one=True)

            if new_player_id_data and new_player_id_data['sp_criar_personagem']:
                novo_id_personagem = new_player_id_data['sp_criar_personagem']
                print(f"Personagem '{nome}' criado com sucesso pelo banco de dados com ID: {novo_id_personagem}")
                return novo_id_personagem
            else:
                print(f"Falha ao criar personagem '{nome}'. Verifique os logs do banco de dados para mais detalhes.")
                return None
        except Exception as e:
            print("!!!!!!!!!! OCORREU UM ERRO NO BANCO DE DADOS !!!!!!!!!!!")
            print(f"Tipo de Erro: {type(e)}")
            print(f"Mensagem Completa: {e}")
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    

    def create_new_inventory(self):
        query = "INSERT INTO public.inventarios (tamanho) VALUES (%s) RETURNING id;"
        result = self._execute_query(query, (32,), fetch_one=True) 
        if result: 
            return result['id']
        return None

    def update_localizacao_jogador(self, id_jogador: int, novo_local_id: int):
        """
        Atualiza a localização do jogador para um novo local no banco de dados.
        """
        query = """
            UPDATE public.personagens_jogaveis
            SET id_local = %s
            WHERE id = %s;
        """
        self._execute_query(query, (novo_local_id, id_jogador))
        print(f"[DB] Localizacao do jogador {id_jogador} atualizada para local {novo_local_id}.")

    def get_ficha_personagem(self, id_jogador: int):
        """
        Obtém e exibe a ficha completa do personagem usando a view.
        """

        query = """
            SELECT nome, ocupacao, residencia, local_nascimento, idade, sexo, forca, constituicao, poder, destreza,
                   aparencia, tamanho, inteligencia, educacao, ideia, conhecimento, sorte, movimento, sanidade_maxima,
                   sanidade_atual, insanidade_temporaria, insanidade_indefinida, PM_base, PM_max,
                   pts_de_vida, pontos_de_vida_atual
            FROM public.view_personagens_jogaveis_completos
            WHERE id = %s;
        """

        ficha_data = self._execute_query(query, (id_jogador,), fetch_one=True)

        if ficha_data:
        
            nome_limpo = ficha_data['nome'].strip()

            print("\n===========================================\n")
            print(f"          FICHA DE {nome_limpo.upper()}            \n")
            print("===========================================\n")
            print("* INFORMACOES BASICAS")
            print(f"  Nome: .......................... {nome_limpo}")
            print(f"  Ocupacao: ...................... {ficha_data['ocupacao'].strip()}")
            print(f"  Residencia: .................... {ficha_data['residencia'].strip()}")
            print(f"  Local de Nascimento:............ {ficha_data['local_nascimento'].strip()}")
            print(f"  Idade: ......................... {ficha_data['idade']} anos")
            print(f"  Sexo: .......................... {ficha_data['sexo'].strip()}\n")

            print("* ATRIBUTOS")
            print(f"  Forca: {ficha_data['forca']} | Constituicao: {ficha_data['constituicao']} | Poder: {ficha_data['poder']}")
            print(f"  Destreza: {ficha_data['destreza']} | Aparencia: {ficha_data['aparencia']} | Tamanho: {ficha_data['tamanho']}")
            print(f"  Inteligencia: {ficha_data['inteligencia']} | Educacao: {ficha_data['educacao']} | Movimento: {ficha_data['movimento']} \n")
            
            print("* ATRIBUTOS DERIVADOS")
            print(f"  Ideia: {ficha_data['ideia']} | Conhecimento: {ficha_data['conhecimento']} | Sorte: {ficha_data['sorte']}%\n")

            print("* STATUS DO PERSONAGEM")
            print(f"  Pontos de Vida: ................. {ficha_data['pontos_de_vida_atual']} / {ficha_data['pts_de_vida']}")
            print(f"  Sanidade: ....................... {ficha_data['sanidade_atual']} / {ficha_data['sanidade_maxima']}")
            print(f"  Insanidade Temporaria: .......... {'Sim' if ficha_data['insanidade_temporaria'] else 'Nao'}")
            print(f"  Insanidade Indefinida: .......... {'Sim' if ficha_data['insanidade_indefinida'] else 'Nao'}")
            print(f"  Pontos de Magia: ................ {ficha_data['pm_base']} / {ficha_data['pm_max']}")
            print("\n===========================================")

        else:
            print(f"Nao foi possivel encontrar a ficha para o personagem com ID: {id_jogador}")

    def get_local_details_and_exits(self, local_id):
        # Retorna os detalhes de um local e suas saídas (baseado nas colunas sul, norte, etc.)
        query = """
        SELECT
            l.id,
            l.descricao,
            l.tipo_local,
            l.status,
            l.local_sul AS id_sul,
            l.local_norte AS id_norte,
            l.local_leste AS id_leste,
            l.local_oeste AS id_oeste,
            l.local_noroeste AS id_noroeste,
            l.local_nordeste AS id_nordeste,
            l.local_sudeste AS id_sudeste,
            l.local_sudoeste AS id_sudoeste,
            l.local_cima AS id_cima,
            l.local_baixo AS id_baixo
        FROM
            public.local l
        WHERE
            l.id = %s;
        """
        local_data = self._execute_query(query, (local_id,), fetch_one=True)

        if not local_data:
            return None

        saidas_raw = []
        if local_data['id_sul']:
            saidas_raw.append({'id_saida': local_data['id_sul'], 'direcao': 'Sul'})
        if local_data['id_norte']:
            saidas_raw.append({'id_saida': local_data['id_norte'], 'direcao': 'Norte'})
        if local_data['id_leste']:
            saidas_raw.append({'id_saida': local_data['id_leste'], 'direcao': 'Leste'})
        if local_data['id_oeste']:
            saidas_raw.append({'id_saida': local_data['id_oeste'], 'direcao': 'Oeste'})
        if local_data['id_noroeste']:
            saidas_raw.append({'id_saida': local_data['id_noroeste'], 'direcao': 'Noroeste'})
        if local_data['id_nordeste']:
            saidas_raw.append({'id_saida': local_data['id_nordeste'], 'direcao': 'Nordeste'})
        if local_data['id_sudeste']:
            saidas_raw.append({'id_saida': local_data['id_sudeste'], 'direcao': 'Sudeste'})
        if local_data['id_sudoeste']:
            saidas_raw.append({'id_saida': local_data['id_sudoeste'], 'direcao': 'Sudoeste'})
        if local_data['id_cima']:
            saidas_raw.append({'id_saida': local_data['id_cima'], 'direcao': 'Cima'})
        if local_data['id_baixo']:
            saidas_raw.append({'id_saida': local_data['id_baixo'], 'direcao': 'Baixo'})
        
        full_saidas = []
        for saida in saidas_raw:
            # Pega a descricao e tipo_local do destino para exibir no jogo
            dest_local_query = "SELECT descricao, tipo_local FROM public.local WHERE id = %s;"
            dest_local_data = self._execute_query(dest_local_query, (saida['id_saida'],), fetch_one=True)
            if dest_local_data:
                full_saidas.append({
                    'id_saida': saida['id_saida'],
                    'direcao': saida['direcao'],
                    'desc_saida': dest_local_data['descricao'].strip(), # Garante que a descricao esteja limpa
                    'tipo_destino': dest_local_data['tipo_local'].strip() # Garante que o tipo esteja limpo
                })

        return {
            'id': local_data['id'],
            'descricao': local_data['descricao'].strip(), # Limpa a descricao do local atual
            'tipo_local': local_data['tipo_local'].strip(), # Limpa o tipo do local atual
            'status': local_data['status'], 
            'saidas': full_saidas
        }
    
    def get_items_in_location(self, local_id: int):
        """
        Chama a stored procedure sp_vasculhar_local para buscar e retornar
        todos os itens presentes em um local específico.
        """
        query = "SELECT * FROM public.sp_vasculhar_local(%s);"
        return self._execute_query(query, (local_id,), fetch_all=True)

    # Novo método para chamar a stored procedure sp_adicionar_item_ao_inventario
    def add_item_to_inventory(self, id_jogador: int, id_instancia_item: int):
        """
        Chama a stored procedure sp_adicionar_item_ao_inventario para adicionar
        uma instância de item ao inventário do jogador e removê-la do local.
        """
        query = "SELECT public.sp_adicionar_item_ao_inventario(%s, %s);"
        result = self._execute_query(query, (id_jogador, id_instancia_item), fetch_one=True)
        # A stored procedure retorna TRUE ou FALSE, entao verificamos o valor booleano
        return result and result['sp_adicionar_item_ao_inventario']
    

    def get_inventario_do_jogador(self, id_jogador: int):
        """
        Chama a stored procedure sp_ver_inventario para obter todos os itens
        no inventário de um jogador.
        """
        query = "SELECT * FROM public.sp_ver_inventario(%s);"
        return self._execute_query(query, (id_jogador,), fetch_all=True)
    
    def trigger_lua_de_sangue(self):
        """
        Chama a stored procedure lua_de_sangue para realizar o respawn
        de monstros e itens no jogo.
        """
        print("\nUma energia estranha paira no ar... A Lua de Sangue esta subindo!")
        query = "SELECT public.lua_de_sangue();"
        self._execute_query(query)
        print("A Lua de Sangue passou. Novos perigos aguardam!")

    
    def get_monsters_in_location(self, local_id: int):
        """
        Chama a stored procedure sp_encontrar_monstros_no_local para buscar e retornar
        todos os monstros presentes em um local específico.
        """
        query = "SELECT * FROM public.sp_encontrar_monstros_no_local(%s);"
        return self._execute_query(query, (local_id,), fetch_all=True)
    
    def kill_monsters_in_location(self, local_id: int):
        """
        Chama a stored procedure sp_matar_monstros_no_local para "matar"
        todos os monstros presentes em um local específico.
        """
        query = "SELECT public.sp_matar_monstros_no_local(%s);"
        result = self._execute_query(query, (local_id,), fetch_one=True)
        # A stored procedure retorna o número de monstros mortos (ou -1 em caso de erro)
        if result and result['sp_matar_monstros_no_local'] is not None:
            return result['sp_matar_monstros_no_local']
        return -1 # Indica erro se nada for retornado ou se a procedure indicar erro



# --- Bloco de Teste para o Modelo Básico ---
if __name__ == "__main__":
    db = None 
    try:
        db = DataBase()

        if db.connection and not db.connection.closed:
            print("\n--- Conexao bem-sucedida. Realizando testes: ---")

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
                
                # Teste: Carregar o personagem
                print(f"\nTeste: Carregando personagem com ID {novo_id}...")
                personagem_carregado = db.get_personagem(nome="Teste Heroi")
                if personagem_carregado:
                    print(f"Personagem carregado: {personagem_carregado.nome}, Local ID: {personagem_carregado.id_local}")
                    db.get_ficha_personagem(personagem_carregado.id_jogador)

                    # Teste: Mover o personagem para um novo local (ex: o primeiro corredor)
                    print(f"\nTeste: Tentando mover o personagem para um novo local...")
                    # Para este teste, precisamos de um ID de local existente no seu DML.
                    # Pegamos o ID do primeiro corredor para exemplo.
                    first_corredor_id_result = db._execute_query("SELECT id FROM public.local WHERE tipo_local = 'Corredor' ORDER BY id LIMIT 1;", fetch_one=True)
                    if first_corredor_id_result:
                        first_corredor_id = first_corredor_id_result['id']
                        db.update_localizacao_jogador(personagem_carregado.id_jogador, first_corredor_id)
                        print(f"Local do personagem atualizado para {first_corredor_id}. Verifique no banco de dados.")
                    else:
                        print("Nao foi possivel encontrar um corredor para testar o movimento.")

                else:
                    print("Falha ao carregar o personagem 'Teste Heroi'.")
            else:
                print("Falha na criacao do personagem 'Teste Heroi'.")

        else:
            print("\nNao foi possivel realizar os testes basicos de consulta pois a conexao com o banco de dados falhou.")

    except Exception as e:
        print(f"\nUm erro inesperado ocorreu durante a execucao do script: {e}")
    finally:
        if db:
            db.close()