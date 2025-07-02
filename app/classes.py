# classes.py

class Player:
    def __init__(self, id_jogador, nome, ocupacao, residencia, local_nascimento, idade, sexo, 
                 forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao, 
                 movimento, sanidade_atual, insanidade_temporaria, insanidade_indefinida, 
                 PM_base, PM_max, pontos_de_vida_atual, 
                 id_local, # AGORA EH APENAS id_local
                 id_inventario, id_armadura=None, id_arma=None, # id_armadura e id_arma podem ser opcionais
                 # Atributos calculados da view, se necessarios no objeto Player
                 ideia=None, conhecimento=None, sorte=None, pts_de_vida_maximo=None, sanidade_maxima=None):
        
        self.id_jogador = id_jogador
        self.nome = nome  
        self.ocupacao = ocupacao  
        self.residencia = residencia  
        self.local_nascimento = local_nascimento  
        self.idade = idade  
        self.sexo = sexo  
        self.forca = forca  
        self.constituicao = constituicao  
        self.poder = poder  
        self.destreza = destreza  
        self.aparencia = aparencia  
        self.tamanho = tamanho  
        self.inteligencia = inteligencia  
        self.educacao = educacao  
        self.movimento = movimento  
        self.sanidade_atual = sanidade_atual  
        self.insanidade_temporaria = insanidade_temporaria  
        self.insanidade_indefinida = insanidade_indefinida  
        self.PM_base = PM_base  
        self.PM_max = PM_max
        self.pontos_de_vida_atual = pontos_de_vida_atual  
        
        self.id_local = id_local # Atualizado para ser apenas id_local
        # self.id_sala = id_sala # Removido
        # self.id_corredor = id_corredor # Removido
        
        self.id_inventario = id_inventario  
        self.id_armadura = id_armadura  
        self.id_arma = id_arma 

        # Atributos calculados da view, que DataBase.get_personagem() preenchera
        self.ideia = ideia
        self.conhecimento = conhecimento
        self.sorte = sorte
        self.pts_de_vida_maximo = pts_de_vida_maximo
        self.sanidade_maxima = sanidade_maxima

    def __str__(self):
        return f"Personagem: {self.nome}, Ocupacao: {self.ocupacao}, Local ID: {self.id_local}"

# As classes Corredor e Sala nao sao mais necessarias para representar entidades separadas do DB,
# pois foram unificadas na tabela 'local'. Se voce ainda precisa de objetos para estas,
# elas seriam representacoes de dados, nao mapeamentos diretos de tabelas individuais.
# Por simplicidade e alinhamento com a refatoracao do BD, elas serao removidas daqui.

# class Corredor:
#     def __init__(self, idCorredor, status, descricao):
#         self.idCorredor = idCorredor
#         self.status = status
#         self.descricao = descricao

# class Sala:
#     def __init__(self, idSala, descricao):
#         self.idSala = idSala
#         self.descricao = descricao