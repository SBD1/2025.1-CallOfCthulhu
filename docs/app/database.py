import psycopg2
import psycopg2.extras 

class DataBase():
    def __init__(self):
        self.connection = self.create_connection()

    def create_connection(self):
        connection = psycopg2.connect(
            host="localhost",
            database="call_of_chtulhu",
            user="postgres",
            password="postgres",
            port=5431)
        if connection:
            print("Conexão com o banco de dados estabelecida com sucesso!")
        else:
            print("Falha ao conectar ao banco de dados.")
        return connection
        
    # Fazendo consultas ao banco e retornando como dicionário

    def select_to_dictionary(self, query: str, *args):
        cursor = self.connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cursor.execute(query, args)
        return cursor.fetchall()
        
    def get_personagem(self):
        if self.select_to_dictionary('SELECT * FROM public.personagens_jogaveis'):
            print('Existem personagens disponíveis para jogar.')
        else:
            print('Nenhum personagem disponível.')

    def get_sala(self):
        if self.select_to_dictionary('SELECT * FROM public.salas'):
            print('Sala disponível')
        else:
            print('Nenhum personagem disponível.')

    # Outra forma de fazer consultas
    def get_enemies_nearby(self, connection, area):
        cursor = connection.cursor()

        querry = """
        SELECT * FROM public.instancias_monstros monstro WHERE (monstro.id_sala = %s) OR (monstro.id_corredor = %s) 
        """
        cursor.execute(querry, (area, area))

        rtn = cursor.fetchone()

        if rtn == None:
            cursor.close()
            print('Nenhum monstro encontrado na área.')
        else:
            cursor.close()
            print('Monstro encontrado na área.')
            return rtn


def main():
    db = DataBase()

if __name__ == "__main__":
    main()