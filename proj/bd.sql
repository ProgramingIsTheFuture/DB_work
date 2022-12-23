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
  [investigadorId] INTEGER,
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
  [unidadeInvestigacaoId] INTEGER,
  [investigadorId] INTEGER,
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

GO
