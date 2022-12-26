CREATE DATABASE bd
go
use bd
go

CREATE TABLE [Projeto] (
  [id] int IDENTITY (1, 1),
  [nome] varchar(255) NOT NULL,
  [titulo] varchar(255),
  [descricao] varchar(500),
  [portugues] varchar(255),
  [ingles] varchar(255),
  [data_ini] date NOT NULL,
  [data_fim] date,
  [url] varchar(255),
  [doi] varchar(255),
  [statusId] int,
  PRIMARY KEY ([id])
)

CREATE TABLE [Contrato] (
  [id] int IDENTITY (1, 1),
  [projectId] int NOT NULL,
  [nome] varchar(255),
  [titulo] varchar(255),
  [descricao] varchar(255),
  [statusId] int NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Investigador] (
  [id] int IDENTITY (1, 1),
  [institutoId] int,
  [nome] varchar(255) NOT NULL,
  [idade] int NOT NULL,
  [morada] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Entidade] (
  [id] int IDENTITY (1, 1),
  [nacional] bit NOT NULL,
  [nome] varchar(255) NOT NULL,
  [descricao] varchar(255),
  [email] varchar(255),
  [telemovel] bigint,
  [designacao] varchar(255) NOT NULL,
  [morada] varchar(255),
  [url] varchar(255),
  [pais] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Instituto] (
  [id] int IDENTITY (1, 1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Papel] (
  [id] int IDENTITY (1, 1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Keywords] (
  [id] int IDENTITY (1, 1),
  [projectId] int NOT NULL,
  [keyword] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Publicacao] (
  [id] int IDENTITY (1, 1),
  [projectId] int NOT NULL,
  [indicador] bit NOT NULL,
  [nomeJornal] varchar(255),
  [url] varchar(255),
  [doi] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [AreaCientifica] (
  [id] int IDENTITY (1, 1),
  [dominioId] int,
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Dominio] (
  [id] int IDENTITY (1, 1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Status] (
  [id] int IDENTITY (1, 1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [HistoricoStatus] (
  [id] int IDENTITY (1, 1),
  [projectId] int,
  [statusId] int,
  [data] date,
  PRIMARY KEY ([id])
)

CREATE TABLE [UnidadeInvestigacao] (
  [id] int IDENTITY (1, 1),
  [nome] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Programa] (
  [id] int IDENTITY (1, 1),
  [designacao] varchar(255) NOT NULL,
  PRIMARY KEY ([id])
)

CREATE TABLE [Participa] (
  [projectId] int,
  [investigadorId] int,
  [papelId] int,
  [tempoPerc] int NOT NULL,
  PRIMARY KEY ([projectId], [investigadorId])
)

CREATE TABLE [AreaProjeto] (
  [projectId] int,
  [areaCientificaId] int,
  PRIMARY KEY ([projectId], [areaCientificaId])
)

CREATE TABLE [Entigrama] (
  [entidadeId] int,
  [programId] int,
  PRIMARY KEY ([entidadeId], [programId])
)

CREATE TABLE [Projama] (
  [projectId] int,
  [programId] int,
  PRIMARY KEY ([projectId], [programId])
)

CREATE TABLE [UnidadeInvestigador] (
  [investigadorId] int,
  [unidadeInvestigacaoId] int,
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

ALTER TABLE [AreaProjeto] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [AreaProjeto] ADD FOREIGN KEY ([areaCientificaId]) REFERENCES [AreaCientifica] ([id])

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
INSERT INTO [dbo].[Investigador] ([institutoId]
, [nome]
, [idade]
, [morada])
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
INSERT INTO [dbo].[Entidade] ([nacional]
, [nome]
, [descricao]
, [email]
, [telemovel]
, [designacao]
, [morada]
, [url]
, [pais])
  VALUES 
  (1, 'Calouste Gulbenkian Foundation', 'Instituição portuguesa de direito privado e utilidade pública geral com caráter perpétuo, cujos fins estatutários são a Arte, a Beneficência, a Ciência e a Educação.', 'calouste@gulbenkien.pt', 351217823000, 'CGF', 'Av. de Berna, Lisboa', 'www.gulbenkian.pt', 'Portugal'),

  (1, 'Instituto Camões', 'Criado para a promoção da língua portuguesa e da cultura portuguesa no exterior.', 'camoes@camoes.pt', 351219037465, 'IC', 'Praça Marquês de Pombal, Lisboa', 'www.instituto-camoes.pt', 'Portugal'),

  (0, 'Agência Sueca de Cooperação Internacional', 'Tem como missão a melhoria das infraestruturas, a promoção do crescimento e da cooperação, nos países em vias de desenvolvimento.', 'sida@sida.com', 46086985000, 'SIDA', 'Sundbyberg, Sweden', 'www.sida.se', 'Suécia'),

  (0, 'UCL Institute of Finance & Technology', 'IFT is fast becoming a hub of excellence of knowledge on digital finance and alternative investment.', 'accommodation@ucl.ac.uk', 4402076792000, 'IFT', 'University College London, Gower Street, London', 'www.ucl.ac.uk', 'Inglaterra'),

  (0, 'European Union Funding', 'Funding provided by the supranational political and economic union of 27 member states that are located primarily in Europe.', 'funding@eu.eu', 0080067891011, 'EUFP', 'Bruxels, Belgium', 'www.european-union.europa.eu/funding', 'Belgica'),

  (0, 'UNESCO Funding', 'Funding provided by the Educational, Scientific and Cultural Organization of the United Nations', 'funding@unesco.org', 33145681729, 'UNFP', 'Paris, France', 'www.unesco.org/funding', 'United States')

-- PROGRAMAS
INSERT INTO [dbo].[Programa] ([designacao])
  VALUES 
  ('Portugal 2020'),
  ('Concurso Projetos Portugueses'),
  ('European Best Computer Science Projects Contest'),
  ('Horizon 2020'),
  ('UNESCO Funding Program'),
  ('World Distinguished Project Funding Program')

-- ENTIDADES <-> PROGRAMAS (Entigrama)
INSERT INTO [dbo].[Entigrama] ([entidadeId]
, [programId])
  VALUES 
  (1, 1), (1, 2), (1, 4), (1, 5),
  (2, 2),
  (3, 3),
  (4, 3), (4, 4), (4, 5),
  (5, 3), (5, 4), (5, 5), (5, 6),
  (6, 5), (6, 6)


-- DOMINIOS
INSERT INTO [dbo].[Dominio] ([designacao])
  VALUES 
  ('Ciências Exatas e Naturais'),
  ('Ciências da Engenharia e Tecnologias'),
  ('Ciências Médicas e da Saúde')

-- ÁREAS CIÊNTIFICAS
INSERT INTO [dbo].[AreaCientifica] ([dominioId]
, [designacao])
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

-- INVESTIGADORES <-> UNIDADES DE INVESTIGACAO (UnidadeInvestigador)
INSERT INTO [dbo].[UnidadeInvestigador] ([investigadorId]
, [unidadeInvestigacaoId])
  VALUES 
  (1, 1), (1, 2), (1, 8),
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
  (23, 7), (23, 9),
  (24, 7), (24, 8),
  (25, 7),
  (26, 7), (26, 8),
  (27, 8)

-- PROJETOS
INSERT INTO [dbo].[Projeto] ([nome]
, [titulo]
, [descricao]
, [portugues]
, [ingles]
, [data_ini]
, [data_fim]
, [url]
, [doi]
, [statusId])
  VALUES 
  ('Blockchain: Contagem de votos', 'Blockchain: Aplicações a elieições públicas transparentes e seguras', 'Visa utilizar a tecnologia blockchain para criar um sistema de votação mais seguro e transparente. A blockchain permite que os votos sejam registrados de forma segura e imutável, garantindo a integridade do processo eleitoral.', NULL, 'Blockchain-based voting system for transparent and secure elections', '2020-10-23', '2021-12-05', 'www.projetos.ubi.pt/blockchain-para-eleicoes', 'www.projetos.ubi.pt/doi/h2j401j2k', 1),

  ('Psilocybin inside Tardigrades', 'Analisis of the possibility of Tardigrades having Psilobycin in their bloodstream', 'Analyzing whether or not tardigrades, also known as water bears, have the psychedelic compound psilocybin in their bloodstream. The results of this project could provide new insights into the biology and evolution of tardigrades and the role of psychoactive compounds in the natural world.', 'Análise da possibilidade de existir Psilobiscina na corrente sanguínea dos Tardígrados', NULL, '2019-05-21', '2020-02-18', 'www.projects.unesco.com/rejected/psilobycin-tardigrades', 'www.projects.unesco.com/doi/rejected/jds92qsif0', 2),

  ('Magnetic fields on turbulent fluids', 'Examining the impact of a magnetic field on turbulent flow in a conducting fluid', 'Studying the effect of an applied magnetic field on turbulent flow in a fluid that is capable of conducting electricity. Using computational fluid dynamics (CFD) simulations or experimental techniques to study the behavior of the flow and the characteristics of the magnetic field.', 'Impacto de um campo magnético no fluxo turbulento de um fluido condutor', NULL, '2021-05-21', NULL, 'www.projects.eu.org/magnetic-turbulence', 'www.projects.eu.org/doi/bajs82no12', 4)

-- PROJETOS <-> AREAS CIENTIFICAS (AreaProjeto)
INSERT INTO [dbo].[AreaProjeto] ([projectId]
, [areaCientificaId])
  VALUES 
  (1, 4), (1, 5),
  (2, 1), (2, 3),
  (3, 4), (3, 5), (3, 6)

-- KEYWORDS
INSERT INTO [dbo].[Keywords] ([projectId]
, [keyword])
  VALUES 
  (1, 'Blockchain'), (1, 'Eleições'), (1, 'Votos'),
  (2, 'Psilobycin'), (2, 'Tardigrades'), (2, 'Bloodstream'),
  (3, 'Magnetitism'), (3, 'Fields'), (3, 'Fuilds'), (3, 'Turbulence'), (3, 'Electricity')

-- PUBLICACOES
INSERT INTO [dbo].[Publicacao] ([projectId]
, [indicador]
, [nomeJornal]
, [url]
, [doi])
  VALUES 
  (1, 1, 'Jornal UBI', 'www.publicacoes.ubi.pt/blockchain-para-eleicoes', 'www.publicacoes.ubi.pt/doi/h2j401j2k'),
  (1, 1, 'IEEE-Access', 'www.ieeeaccess.ieee.org/project/election-blockchain', 'www.ieeeaccess.ieee.org//doi/q2sjf928j'),
  (3, 1, 'Jornal UBI', 'www.publicacoes.ubi.pt/turbulencia-magnetica', 'www.publicacoes.ubi.pt/doi/jdka2j4k'),
  (3, 1, 'ACM Transactions on Graphics', 'www.dl.acm.org/tog/projects/magnetic-turbulence', 'www.dl.acm.org/tog/doi/ko10spd2'),
  (3, 1, 'Computational Geometry: Theory and Applications', 'www.dl.acm.org/coge/projects/magnetic-turbulence', 'www.dl.acm.org/coge/doi/aoqjd9481')

-- HISTORICO STATUS
INSERT INTO [dbo].[HistoricoStatus] ([projectId]
, [statusId]
, [data])
  VALUES 
  (1, 1, '2020-10-23'), (1, 4, '2020-10-24'), (1, 7, '2021-11-12'), (1, 3, '2021-12-05'),
  (2, 1, '2019-05-21'), (2, 4, '2019-05-22'), (2, 7, '2019-12-30'), (2, 2, '2020-02-17'), (2, 5, '2020-02-18'),
  (3, 4, '2021-05-21'), (3, 4, '2021-05-23')

-- PROJETOS <-> PROGRAMAS (Projama)
INSERT INTO [dbo].[Projama] ([projectId]
, [programId])
  VALUES 
  (1, 1), (1, 3), (1, 4),
  (2, 5),
  (3, 3), (3, 6)

-- PROJETOS <-> INVESTIGADORES (Participa)
INSERT INTO [dbo].[Participa] ([projectId]
, [investigadorId]
, [papelId]
, [tempoPerc])
  VALUES 
  (1, 1, 4, 35),
  (1, 2, 3, 65),
  (1, 3, 1, 20),
  (1, 4, 2, 10),
  (2, 5, 3, 75),
  (2, 6, 4, 45),
  (2, 20, 1, 25),
  (3, 1, 3, 65),
  (3, 2, 4, 35),
  (3, 8, 4, 25),
  (3, 12, 2, 25),
  (3, 11, 2, 20),
  (3, 15, 1, 45),
  (3, 18, 4, 30),
  (3, 21, 4, 35)

-- CONTRATOS
INSERT INTO [dbo].[Contrato] ([projectId]
, [nome]
, [titulo]
, [descricao]
, [statusId])
  VALUES 
  (1, 'Contrato contagem de votos Blockchain', 'Contrato Aplicações blockchain para elieições públicas transparentes e seguras', 'Contrato referente ao financiamento e investigadores', 3),
  (2, 'Psilobycin inside Tardigrades Contract', NULL, 'This contract refers to the investors and researchers assigned to the project', 2),
  (3, 'Magnetic fields on turbulent fluids Contract', NULL, 'This contract refers to the investors and researchers assigned to the project', 3)
GO

--SELECT I.nome, U.nome FROM UnidadeInvestigador UI, Investigador I, UnidadeInvestigacao U
--WHERE UI.investigadorId = I.id
--  and UI.unidadeInvestigacaoId = U.id
--ORDER BY I.nome

--SELECT P.id, P.nome, A.designacao, D.designacao FROM Projeto P, AreaProjeto AP, AreaCientifica A, Dominio D
--WHERE AP.projectId = P.id
--  and AP.areaCientificaId = A.id
--  and A.dominioId = D.id
--ORDER BY P.id

--SELECT E.id, E.nome, P.designacao FROM Entidade E, Entigrama EP, Programa P 
--WHERE E.id = EP.entidadeId
--  and P.id = EP.programId
--ORDER BY E.id
