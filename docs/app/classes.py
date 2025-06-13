class Player:
    def __init__(self, idJogador, nome, ocupacao, residencia, local_nascimento, idade, sexo, forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao, movimento, sanidade_atual, insanidade_temporaria, insanidade_indefinida, PM_base, PM_max, pontos_de_vida_atual, id_sala, id_corredor, id_inventario, id_armadura, id_arma):
        self.idJogador = idJogador
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
        self.id_sala = id_sala  
        self.id_corredor = id_corredor  
        self.id_inventario = id_inventario  
        self.id_armadura = id_armadura  
        self.id_arma = id_arma 


class Corredor:
    def __init__(self, idCorredor, status, descricao):
        self.idCorredor = idCorredor
        self.status = status
        self.descricao = descricao

class Sala:
    def __init__(self, idSala, descricao):
        self.idSala = idSala
        self.descricao = descricao

    