CREATE TABLE [Projeto] (
  [id] INTEGER IDENTITY(1,1),
  [nome] varchar(255) NOT NULL,
  [titulo] varchar(255),
  [descricao] varchar(255),
  [portugues] varchar(255),
  [ingles] varchar(255),
  [data_ini] date NOT NULL,
  [data_fim] date,
  [url] varchar(255),
  [doi] varchar(255),
  [statusId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Contrato] (
  [id] INTEGER IDENTITY(1,1),
  [projectId] INTEGER,
  [nome] varchar(255),
  [titulo] varchar(255),
  [descricao] varchar(255),
  [statusId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Investigador] (
  [id] INTEGER IDENTITY(1,1),
  [institutoId] INTEGER,
  [nome] varchar(255) NOT NULL,
  [idade] INTEGER NOT NULL,
  [morada] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Entidade] (
  [id] INTEGER IDENTITY(1,1),
  [nacional] BIT,
  [nome] varchar(255) NOT NULL,
  [descricao] varchar(255),
  [email] varchar(255),
  [telemovel] BIGINT,
  [designacao] varchar(255),
  [morada] varchar(255),
  [url] varchar(255),
  [pais] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [Instituto] (
  [id] INTEGER IDENTITY(1,1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Papel] (
  [id] INTEGER IDENTITY(1,1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Keywords] (
  [id] INTEGER IDENTITY(1,1),
  [keyword] varchar(255) NOT NULL,
  [projectId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Publicacao] (
  [id] INTEGER IDENTITY(1,1),
  [indicador] BIT,
  [projectId] INTEGER,
  [url] varchar(255),
  [doi] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [Dominio] (
  [id] INTEGER IDENTITY(1,1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [AreaCientifica] (
  [id] INTEGER IDENTITY(1,1),
  [dominioId] INTEGER,
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Status] (
  [id] INTEGER IDENTITY(1,1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [HistoricoStatus] (
  [id] INTEGER IDENTITY(1,1),
  [projectId] INTEGER,
  [statusId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [UnidadeInvestigacao] (
  [id] INTEGER IDENTITY(1,1),
  [nome] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Programa] (
  [id] INTEGER IDENTITY(1,1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Participa] (
  [projectId] INTEGER,
  [investigadorId] INTEGER,
  [papelId] INTEGER,
  [tempoPerc] INTEGER NOT NULL,
  PRIMARY KEY ([projectId], [investigadorId])
)

CREATE TABLE [Dometo] (
  [projectId] INTEGER,
  [dominioId] INTEGER,
  PRIMARY KEY ([projectId], [dominioId])
)

CREATE TABLE [Entigrama] (
  [programId] INTEGER,
  [entidadeId] INTEGER,
  PRIMARY KEY ([programId], [entidadeId])
)

CREATE TABLE [Projama] (
  [programId] INTEGER,
  [projectId] INTEGER,
  PRIMARY KEY ([programId], [projectId])
)

CREATE TABLE [UnidadeInvestigador] (
  [investigadorId] INTEGER,
  [unidadeInvestigacaoId] INTEGER,
  PRIMARY KEY ([unidadeInvestigacaoId], [investigadorId])
)

ALTER TABLE [Projeto] ADD FOREIGN KEY ([statusId]) REFERENCES [Status] ([id])

ALTER TABLE [Contrato] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Contrato] ADD FOREIGN KEY ([statusId]) REFERENCES [Status] ([id])

ALTER TABLE [Investigador] ADD FOREIGN KEY ([institutoId]) REFERENCES [Instituto] ([id])

ALTER TABLE [Keywords] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Publicacao] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [HistoricoStatus] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [HistoricoStatus] ADD FOREIGN KEY ([statusId]) REFERENCES [Status] ([id])

ALTER TABLE [Projama] ADD FOREIGN KEY ([programId]) REFERENCES [Programa] ([id])

ALTER TABLE [Projama] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Dometo] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Dometo] ADD FOREIGN KEY ([dominioId]) REFERENCES [Dominio] ([id])

ALTER TABLE [AreaCientifica] ADD FOREIGN KEY ([dominioId]) REFERENCES [Dominio] ([id])

ALTER TABLE [Entigrama] ADD FOREIGN KEY ([programId]) REFERENCES [Programa] ([id])

ALTER TABLE [Entigrama] ADD FOREIGN KEY ([entidadeId]) REFERENCES [Entidade] ([id])

ALTER TABLE [UnidadeInvestigador] ADD FOREIGN KEY ([unidadeInvestigacaoId]) REFERENCES [UnidadeInvestigacao] ([id])

ALTER TABLE [UnidadeInvestigador] ADD FOREIGN KEY ([investigadorId]) REFERENCES [Investigador] ([id])

ALTER TABLE [Participa] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Participa] ADD FOREIGN KEY ([investigadorId]) REFERENCES [Investigador] ([id])

ALTER TABLE [Participa] ADD FOREIGN KEY ([papelId]) REFERENCES [Papel] ([id])

-- INSTITUTOS
INSERT INTO [dbo].[Instituto] ([designacao])
VALUES	
		('Universidade Da Beira Interior'), 
		('Universidade do Minho'),
		('Instituto Superior Técnico'),
		('University of Amsterdam'),
	    ('University of Oxford'),
		('Cornell University'),
		('Instituto Pedro Nunes'),
		('Alan Turing Institute'),
		('Massachusetts Institute of Technology')

-- INVESTIGADORES
INSERT INTO [dbo].[Investigador]
           ([institutoId]
           ,[nome]
           ,[idade]
           ,[morada])
VALUES
        (1, 'Leonardo Santos', 20, 'Varanda dos Carqueijais, Covilhã'),
		(1, 'Francisco Santos', 20, 'Assacaias, Santarém'),
		(1, 'António Costa', 34, 'Abrantes, Alfarrede'),
		(1, 'Cavaco Silva', 54, 'Almacave, Lamego'),
		(1, 'André Ventura', 35, 'McDonalds da Mealhada, Mealhada'),
		(1, 'José Socrates', 56, 'Prisão de Viseu, Viseu'),
		(1, 'Herman José', 45, 'Conservatório de Música do Porto, Porto'),
		(1, 'Cristiano Ronaldo', 39, 'São Roque, Funchal'),
		(1, 'José Mourinho', 46, 'Vilamoura, Quarteira'),
		(1, 'Maria Leal', 34, 'São Martinho do Porto, Alcobaça'),
		(2, 'Diogo Dalot', 23, 'Nogueiró, Braga'),
		(2, 'Afonso Henriques', 45, 'Conde de Portucale'),
		(3, 'Luís de Camões', 56, 'Mosteiro dos Jerónimos, Lisboa'),
		(3, 'Amália Rodrigues', 24, 'Pena, Lisboa'),
		(3, 'Fernando Pessoa', 34, 'Para viajar basta existir, Lisboa'),
		(4, 'Vincent van Gogh', 39, 'Zundert, Netherlands'),
		(4, 'Eddie Van Halen', 29, 'Amsterdam, Netherlands'),
	    (5, 'Stephen Hawking', 76, 'Oxford, United Kingdom'),
	    (5, 'Bill Clinton', 76, 'Hope, Arkansas, United States'),
	    (6, 'Bill Nye', 67, 'Washington D.C., United States'),
	    (6, 'Michael Ryan Clarkson', 43, 'Ithaca New York, United States'),
	    (7, 'Carlos Ribeiro', 40, 'Alcácer do Sal, Setúbal'),
	    (7, 'José Figueiras', 55, 'Queluz, Sintra'),
	    (8, 'Adrian Smith', 76, 'Dawlish, United Kingdom'),
	    (8, 'David Gilmour', 34, 'Cambridge, United Kingdom'),
	    (9, 'Roger Waters', 37, 'Great Bookham, United Kingdom'),
	    (9, 'Giannis Antetokounmpo', 28, 'Athens, Greece')

-- ENTIDADES
INSERT INTO [dbo].[Entidade]
           ([nacional]
           ,[nome]
           ,[descricao]
           ,[email]
           ,[telemovel]
           ,[designacao]
           ,[morada]
           ,[url]
           ,[pais])
VALUES
	    (1, 'Calouste Gulbenkian Foundation', 'Instituição portuguesa de direito privado e utilidade pública geral com caráter perpétuo, cujos fins estatutários são a Arte, a Beneficência, a Ciência e a Educação.',
	    'calouste@gulbenkien.pt', 351217823000, 'CGF', 'Av. de Berna, Lisboa', 'www.gulbenkian.pt', 'Portugal'),
	    (1, 'Instituto Camões', 'Criado para a promoção da língua portuguesa e da cultura portuguesa no exterior.', 
	    'camoes@camoes.pt', 351219037465, 'IC', 'Praça Marquês de Pombal, Lisboa', 'www.instituto-camoes.pt', 'Portugal'),
	    (0, 'Agência Sueca de Cooperação Internacional', 'Tem como missão a melhoria das infraestruturas, a promoção do crescimento e da cooperação, nos países em vias de desenvolvimento.',
	    'sida@sida.com', 46086985000, 'SIDA', 'Sundbyberg, Sweden', 'www.sida.se', 'Suécia'),
	    (0, 'UCL Institute of Finance & Technology', 'IFT is fast becoming a hub of excellence of knowledge on digital finance and alternative investment.',
	    'accommodation@ucl.ac.uk', 4402076792000, 'IFT', 'University College London, Gower Street, London', 'www.ucl.ac.uk', 'Inglaterra')

-- DOMINIOS
INSERT INTO [dbo].[Dominio] ([designacao])
VALUES
        ('Ciências Exatas e Naturais'),
		('Ciências da Engenharia e Tecnologias'),
		('Ciências Médicas e da Saúde')

-- ÁREAS CIÊNTIFICAS
INSERT INTO [dbo].[AreaCientifica]
           ([dominioId]
           ,[designacao])
VALUES
        (1, 'Biotecnologia'),
		(1, 'Bioengenharia'),
		(1, 'Biologia'),
		(2, 'Engenharia Informática'),
		(2, 'Matemática'),
		(2, 'Engenharia Física'),
		(2, 'Nanotecnologia'),
		(3, 'Medicina'),
		(3, 'Ciências da Saúde')

-- STATUS
INSERT INTO [dbo].[Status] ([designacao])
VALUES
        ('Aprovado'),
		('Cancelado'),
		('Concluído'),
		('Em Curso'),
		('Encerrado'),
		('Renovado'),
		('Em Submissão')

-- PAPEIS
INSERT INTO [dbo].[Papel] ([designacao])
VALUES
        ('Promotor'),
		('Copromotor'),
		('Líder'),
		('Participante')

-- UNIDADES DE INVESTIGAÇÃO
INSERT INTO [dbo].[UnidadeInvestigacao] ([nome])
VALUES
        ('Unidade EI UBI'),
		('Unidade Matemática e Física UBI'),
		('Unidade Bio UBI'),
		('Unidade EI União Europeia'),
		('Unidade Matemática e Física União Europeia'),
		('Unidade Bio União Europeia'),
		('Unidade EI UNESCO'),
		('Unidade Matemática e Física UNESCO'),
		('Unidade Bio UNESCO')

-- INVESTIGADORES <-> UNIDADES DE INVESTIGACAO
INSERT INTO [dbo].[UnidadeInvestigador]
           ([unidadeInvestigacaoId]
           ,[investigadorId])
VALUES
        (1, 1), (1, 2), (1, 3), (1, 8),
		(2, 1), (2, 4),
		(3, 1), (3, 3), (3, 4),
		(4, 1),
		(5, 2), (5, 6),
		(6, 1), (6, 3), (6, 5),
		(7, 3), (7, 9),
		(8, 1), (8, 2), (8, 4), (8, 8),
		(9, 3), (9, 9),
		(10, 3),
		(11, 4), (11, 8),
		(12, 4), (12, 7),
		(13, 6),
		(14, 6),
		(15, 4), (15, 8),
		(16, 4), (16, 5), (16, 7),
		(17, 9),
		(18, 4), (18, 5), (18, 6), (18, 7), (18, 8), (18, 9),
		(19, 6),
		(20, 9),
		(21, 7), (21, 8),
		(22, 8),
		(23, 7), (21, 9),
		(24, 7), (21, 8),
		(25, 7),
		(26, 7), (26, 8),
		(27, 8)

GO
