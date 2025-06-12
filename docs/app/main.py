from database import DataBase
import psycopg2

class Jogo():
    def __init__(self):
        self.db = DataBase()
    
    def consultas_teste(self):
        self.db.get_personagem()
        self.db.get_sala()
        self.db.get_enemies_nearby(self.db.connection, 1)

if __name__ == '__main__':
    jogo = Jogo()
    jogo.consultas_teste()

