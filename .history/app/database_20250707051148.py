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
            pj.id, pj.nome, pj.ocupacao, pj.residencia, pj.local_nascimento, pj.idade, pj.sexo, pj.ouro,
            pj.forca, pj.constituicao, pj.poder, pj.destreza, pj.aparencia, pj.tamanho, pj.inteligencia, pj.educacao,
            pj.movimento, pj.sanidade_atual, pj.insanidade_temporaria, pj.insanidade_indefinida,
            pj.pm_base, pj.pm_max, pj.pontos_de_vida_atual,
            pj.id_local, pj.id_missao_historia_ativa,
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
                ouro=personagem_data['ouro'],
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
                id_missao_historia_ativa=personagem_data['id_missao_historia_ativa'],
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
        Utiliza da função 'public.sp_criar_personagem_jogavel()' para criar o personagem.
        Retorna o ID do novo personagem ou None em caso de falha.
        """
        try:
            print(f"Solicitando ao banco de dados para criar o personagem '{nome}'...")

            # CORREÇÃO: Chamando a stored procedure 'sp_criar_personagem_jogavel' que é a correta.
            # A passagem de parâmetros foi simplificada para corresponder à forma como o psycopg2 lida com tipos.
            query = """
                SELECT public.sp_criar_personagem_jogavel(
                    %s::public.nome, 
                    %s::public.ocupacao, 
                    %s::public.residencia, 
                    %s::public.local_nascimento, 
                    %s::public.idade, 
                    %s::public.sexo
                );
            """

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
            
            # O nome do campo retornado pela função será o nome da própria função.
            if new_player_id_data and new_player_id_data['sp_criar_personagem_jogavel']:
                novo_id_personagem = new_player_id_data['sp_criar_personagem_jogavel']
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
        Obtém e exibe a ficha completa do personagem, incluindo itens equipados.
        """

        query = """
            SELECT *, v.pts_de_vida AS pts_de_vida_maximo
            FROM public.view_personagens_jogaveis_completos v
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
            print(f"  Pontos de Vida: ................. {ficha_data['pontos_de_vida_atual']} / {ficha_data['pts_de_vida_maximo']}")
            print(f"  Sanidade: ....................... {ficha_data['sanidade_atual']} / {ficha_data['sanidade_maxima']}")
            print(f"  Insanidade Temporaria: .......... {'Sim' if ficha_data['insanidade_temporaria'] else 'Nao'}")
            print(f"  Insanidade Indefinida: .......... {'Sim' if ficha_data['insanidade_indefinida'] else 'Nao'}")
            print(f"  Pontos de Magia: ................ {ficha_data['pm_base']} / {ficha_data['pm_max']}\n")
            print(f"  Ouro: ........................... {ficha_data['ouro']}\n")

            # --- NOVA SEÇÃO DE EQUIPAMENTO ---
            print("* EQUIPAMENTO")
            id_arma_instancia = ficha_data.get('id_arma')
            id_armadura_instancia = ficha_data.get('id_armadura')

            if id_arma_instancia:
                arma_query = """
                    SELECT i.nome, a.dano FROM public.itens i
                    JOIN public.armas a ON i.id = a.id
                    JOIN public.instancias_de_itens ii ON i.id = ii.id_item
                    WHERE ii.id = %s
                """
                arma_detalhes = self._execute_query(arma_query, (id_arma_instancia,), fetch_one=True)
                if arma_detalhes:
                    print(f"  Arma Equipada: ................ {arma_detalhes['nome'].strip()} (Dano: {arma_detalhes['dano']})")
                else:
                    print("  Arma Equipada: ................ (Erro ao buscar detalhes da arma)")
            else:
                print("  Arma Equipada: ................ Nenhuma")

            if id_armadura_instancia:
                armadura_query = """
                    SELECT i.nome, ar.qtd_dano_mitigado, ar.tipo_atributo_recebe, ar.qtd_atributo_recebe FROM public.itens i
                    JOIN public.armaduras ar ON i.id = ar.id
                    JOIN public.instancias_de_itens ii ON i.id = ii.id_item
                    WHERE ii.id = %s
                """
                armadura_detalhes = self._execute_query(armadura_query, (id_armadura_instancia,), fetch_one=True)
                if armadura_detalhes:
                    bonus_str = ""
                    if armadura_detalhes.get('tipo_atributo_recebe') and armadura_detalhes.get('qtd_atributo_recebe'):
                        bonus_str = f" (Bonus: +{armadura_detalhes['qtd_atributo_recebe']} {armadura_detalhes['tipo_atributo_recebe'].strip()})"
                    print(f"  Armadura Equipada: ............ {armadura_detalhes['nome'].strip()} (Defesa: {armadura_detalhes['qtd_dano_mitigado']}){bonus_str}")
                else:
                    print("  Armadura Equipada: ............ (Erro ao buscar detalhes da armadura)")
            else:
                print("  Armadura Equipada: ............ Nenhuma")

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
        direcoes = ['sul', 'norte', 'leste', 'oeste', 'noroeste', 'nordeste', 'sudeste', 'sudoeste', 'cima', 'baixo']
        for direcao in direcoes:
            id_col = f'id_{direcao}'
            if local_data[id_col]:
                saidas_raw.append({'id_saida': local_data[id_col], 'direcao': direcao.capitalize()})
        
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

    def add_item_to_inventory(self, id_jogador: int, id_instancia_item: int):
        """
        Chama a stored procedure sp_adicionar_item_ao_inventario para adicionar
        uma instância de item ao inventário do jogador e removê-la do local.
        """
        query = "SELECT public.sp_adicionar_item_ao_inventario(%s, %s);"
        result = self._execute_query(query, (id_jogador, id_instancia_item), fetch_one=True)
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
        
    def movimentar_todos_os_monstros(self):
        """
        Chama a storede procedure sp_movimentar_monstros que movimenta
        todos os monstros do jogo para uma sala aleatória 
        """
        query = "SELECT public.sp_movimentar_monstros();"
        return self._execute_query(query, fetch_all=True)

    def equip_item(self, id_jogador: int, id_instancia_item: int):
        """
        Chama a stored procedure para equipar um item do inventário.
        Retorna a mensagem de sucesso ou falha do banco de dados.
        """
        query = "SELECT public.sp_equipar_item(%s, %s);"
        result = self._execute_query(query, (id_jogador, id_instancia_item), fetch_one=True)
        if result:
            return result['sp_equipar_item']
        return "Erro ao tentar equipar o item."

    def unequip_item(self, id_jogador: int, tipo_slot: str):
        """
        Chama a stored procedure para desequipar um item de um slot ('arma' ou 'armadura').
        Retorna a mensagem de sucesso ou falha do banco de dados.
        """
        query = "SELECT public.sp_desequipar_item(%s, %s);"
        result = self._execute_query(query, (id_jogador, tipo_slot), fetch_one=True)
        if result:
            return result['sp_desequipar_item']
        return "Erro ao tentar desequipar o item."

    def execute_battle(self, id_jogador: int, id_instancia_monstro: int):
        """
        Chama a stored procedure que executa um loop de batalha completo.
        Retorna o texto com o resultado final da batalha.
        """
        query = "SELECT public.sp_executar_batalha(%s, %s);"
        result = self._execute_query(query, (id_jogador, id_instancia_monstro), fetch_one=True)
        if result:
            return result['sp_executar_batalha']
        return "A batalha terminou de forma inconclusiva devido a um erro."

    # Adicione este novo método à sua classe DataBase em database.py

    def inspect_monster(self, id_instancia_monstro: int):
        """
        Chama a stored procedure para buscar os detalhes completos de uma instância de monstro.
        Retorna um dicionário com os atributos do monstro ou None se não for encontrado.
        """
        query = "SELECT * FROM public.sp_inspecionar_monstro(%s);"
        return self._execute_query(query, (id_instancia_monstro,), fetch_one=True)
    
    def get_vendedor_in_location(self, local_id: int):
        """
        Chama a stored procedure sp_encontrar_vendedor_no_local para buscar e retornar
        todos os vendedores presentes em um local específico.
        """
        query = "SELECT * FROM public.sp_encontrar_vendedor_no_local(%s);"
        return self._execute_query(query, (local_id,), fetch_all=True)
    
    def get_item_vendedor(self, npc_id: int):
        """
        Chama a stored procedure sp_ver_inventario_npc que mostra todos os itens do inventario do npc
        """
        query = "SELECT * FROM public.sp_ver_inventario_npc(%s);"
        params = (npc_id,)
        
        return self._execute_query(query, params, fetch_all=True)    
    
    def personagem_compra_item(self, id_jogador: int, npc_id: int, id_instancia_item: int, valor_pago: int):
       """
       Chama a stored procedure public.sp_comprar_item_do_npc para realizar a transação.
       """
       # A query agora aceita 4 parâmetros
       query = """
        SELECT public.sp_comprar_item_do_npc(
            %s::public.id_personagem_jogavel, 
            %s::public.id_personagem_npc, 
            %s::public.id_instancia_de_item, 
            %s::smallint
        );
        """

       # Passa todos os 4 parâmetros na ordem correta
       params = (id_jogador, npc_id, id_instancia_item, valor_pago)

       result = self._execute_query(query, params, fetch_one=True)
       if result:
           return result['sp_comprar_item_do_npc']
       return "Erro ao tentar comprar item."
    
    def personagem_vende_item(self, id_jogador: int, npc_id: int, id_instancia_item: int):
       """
       Chama a stored procedure public.sp_jogador_vende_item para realizar a venda.
       """
       query = """
           SELECT public.sp_jogador_vende_item(
               %s::public.id_personagem_jogavel,
               %s::public.id_personagem_npc,
               %s::public.id_instancia_de_item
           );
       """
       params = (id_jogador, npc_id, id_instancia_item)
       result = self._execute_query(query, params, fetch_one=True)
       if result:
           return result['sp_jogador_vende_item']
       return "Erro ao tentar vender o item."

    def apply_sanity_damage(self, id_jogador: int, dano: int):
        """Chama a procedure para aplicar dano à sanidade do jogador."""
        query = "SELECT public.sp_aplicar_dano_sanidade(%s, %s);"
        result = self._execute_query(query, (id_jogador, dano), fetch_one=True)
        return result['sp_aplicar_dano_sanidade'] if result else "Erro ao aplicar dano de sanidade."

    def get_monster_drop(self, id_instancia_monstro: int):
        # Simples query para pegar o item que o monstro dropa
        return self._execute_query("SELECT id_instancia_de_item FROM public.instancias_monstros WHERE id = %s;", (id_instancia_monstro,), fetch_one=True)

    def kill_monster_instance(self, id_instancia_monstro: int):
        # Marca o monstro como derrotado (para a Lua de Sangue)
        self._execute_query("UPDATE public.instancias_monstros SET id_local = NULL, vida = 0 WHERE id = %s;", (id_instancia_monstro,))

    def perform_skill_check(self, id_jogador: int, nome_pericia: str):
        query = "SELECT public.sp_realizar_teste_pericia(%s, %s);"
        result = self._execute_query(query, (id_jogador, nome_pericia), fetch_one=True)
        return result['sp_realizar_teste_pericia'] if result else False

    # --- NOVOS MÉTODOS PARA BATALHA E MORTE ---

    def execute_battle_turn(self, id_jogador: int, id_instancia_monstro: int):
        """Chama a procedure que executa um único turno de batalha."""
        query = "SELECT * FROM public.sp_executar_turno_batalha(%s, %s);"
        return self._execute_query(query, (id_jogador, id_instancia_monstro), fetch_one=True)

    def execute_monster_attack_only(self, id_jogador: int, id_instancia_monstro: int):
        """Chama a procedure para o monstro atacar sozinho (quando o jogador falha em fugir)."""
        query = "SELECT public.sp_monstro_ataca_sozinho(%s, %s) as log_turno;"
        return self._execute_query(query, (id_jogador, id_instancia_monstro), fetch_one=True)

    def reset_player_status(self, id_jogador: int):
        """Chama a procedure para resetar a vida e sanidade do jogador."""
        self._execute_query("SELECT public.sp_resetar_status_jogador(%s);", (id_jogador,))

    def add_item_to_inventory(self, id_jogador: int, id_instancia_item: int):
        query = "SELECT public.sp_adicionar_item_ao_inventario(%s, %s);"
        result = self._execute_query(query, (id_jogador, id_instancia_item), fetch_one=True)
        return result and result['sp_adicionar_item_ao_inventario']

    def get_inventario_do_jogador(self, id_jogador: int):
        return self._execute_query("SELECT * FROM public.sp_ver_inventario(%s);", (id_jogador,), fetch_all=True)
    
    def get_player_skills(self, player_id: int):
        """Busca todas as perícias que um jogador possui."""
        query = """
            SELECT p.nome, ppp.valor_atual
            FROM public.personagens_possuem_pericias ppp
            JOIN public.pericias p ON ppp.id_pericia = p.id
            WHERE ppp.id_personagem = %s
            ORDER BY p.nome;
        """
        return self._execute_query(query, (player_id,), fetch_all=True)

    def start_story_mode(self, player_id: int, mission_name: str):
        """
        Calls the stored procedure to start the story mode for a player.
        This moves the player to the mission's starting location and activates the mission.
        """
        query = "SELECT public.sp_iniciar_modo_historia(%s, %s);"
        params = (player_id, mission_name)
        result = self._execute_query(query, params, fetch_one=True)
        if result and result.get('sp_iniciar_modo_historia'):
            return result['sp_iniciar_modo_historia']
        return "Falha ao iniciar o Modo História. A escuridão resiste."

    # --- MÉTODOS DE SUPORTE AO MODO HISTÓRIA ---

    def get_active_mission_details(self, mission_id: int):
        """Busca os detalhes da missão de história ativa."""
        query = "SELECT * FROM public.missoes WHERE id = %s;"
        return self._execute_query(query, (mission_id,), fetch_one=True)

    def update_mission_requirement(self, mission_id: int, defeated_monster_instance_id: int):
        """Marca um requisito de missão como concluído."""
        query = """
            UPDATE public.requisitos_missao
            SET concluido = TRUE
            WHERE id_missao = %s AND id_alvo_instancia = %s AND tipo_requisito = 'ELIMINAR_MONSTRO';
        """
        self._execute_query(query, (mission_id, defeated_monster_instance_id))
        print(f"[DB] Requisito de missão {mission_id} (alvo: {defeated_monster_instance_id}) atualizado.")

    def are_mission_requirements_complete(self, mission_id: int):
        """Verifica se todos os requisitos de uma missão foram concluídos."""
        query = """
            SELECT NOT EXISTS (
                SELECT 1 FROM public.requisitos_missao
                WHERE id_missao = %s AND concluido = FALSE
            ) AS is_complete;
        """
        result = self._execute_query(query, (mission_id,), fetch_one=True)
        return result['is_complete'] if result else False

    def unlock_story_path(self, current_local_id: int, direction: str, destination_local_id: int):
        """Atualiza a tabela 'local' para criar uma nova saída e seu caminho de volta."""
        # Mapeia direções para suas opostas
        opposite_directions = {
            'norte': 'sul', 'sul': 'norte', 'leste': 'oeste', 'oeste': 'leste',
            'nordeste': 'sudoeste', 'sudoeste': 'nordeste',
            'noroeste': 'sudeste', 'sudeste': 'noroeste',
            'cima': 'baixo', 'baixo': 'cima'
        }
        
        # Cria a saída do local atual para o destino
        column_name = f"local_{direction.lower()}"
        query_ida = f"UPDATE public.local SET {column_name} = %s WHERE id = %s;"
        self._execute_query(query_ida, (destination_local_id, current_local_id))

        # Cria a saída de retorno do destino para o local atual
        opposite_direction = opposite_directions.get(direction.lower())
        if opposite_direction:
            opposite_column_name = f"local_{opposite_direction}"
            query_volta = f"UPDATE public.local SET {opposite_column_name} = %s WHERE id = %s;"
            self._execute_query(query_volta, (current_local_id, destination_local_id))

        print(f"[DB] Caminho desbloqueado: Local {current_local_id} ({direction}) -> Local {destination_local_id}")

    def advance_story_mission(self, player_id: int, next_mission_id: int):
        """Atualiza a missão de história ativa do jogador para a próxima na sequência."""
        # Se next_mission_id for None, significa que a campanha terminou.
        query = "UPDATE public.personagens_jogaveis SET id_missao_historia_ativa = %s WHERE id = %s;"
        self._execute_query(query, (next_mission_id, player_id))
        if next_mission_id:
            print(f"[DB] Jogador {player_id} avançou para a missão {next_mission_id}.")
        else:
            print(f"[DB] Jogador {player_id} concluiu a campanha.")

        

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