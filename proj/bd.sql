CREATE TABLE [Projeto] (
  [id] INTEGER,
  [nome] varchar(255),
  [titulo] varchar(255),
  [descricao] varchar(255),
  [portugues] varchar(255),
  [ingles] varchar(255),
  [data_ini] date,
  [data_fim] date,
  [url] varchar(255),
  [doi] varchar(255),
  [statusId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Contrato] (
  [id] INTEGER,
  [projectId] INTEGER,
  [nome] varchar(255),
  [titulo] varchar(255),
  [descricao] varchar(255),
  [statusId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Investigador] (
  [id] INTEGER,
  [institutoId] INTEGER,
  [nome] varchar(255),
  [idade] INTEGER,
  [morada] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [Papel] (
  [id] INTEGER,
  [designacao] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [Participa] (
  [id] INTEGER,
  [projectId] INTEGER,
  [InvestigadorId] INTEGER,
  [papelId] INTEGER,
  [tempoPerc] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Keywords] (
  [id] INTEGER,
  [keyword] varchar(255),
  [projectId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Publicacao] (
  [id] INTEGER,
  [indicador] BIT,
  [projectId] INTEGER,
  [url] varchar(255),
  [doi] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [Status] (
  [id] INTEGER,
  [designacao] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [HistoricoStatus] (
  [id] INTEGER,
  [projectId] INTEGER,
  [statusId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Entidade] (
  [id] INTEGER,
  [nacional] BIT,
  [nome] varchar(255),
  [descricao] varchar(255),
  [email] varchar(255),
  [telemovel] INTEGER,
  [designacao] varchar(255),
  [morada] varchar(255),
  [url] varchar(255),
  [pais] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [Projama] (
  [id] INTEGER,
  [programId] INTEGER,
  [projectId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [UnidadeInvestigacao] (
  [id] INTEGER,
  [investigadorId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Dometo] (
  [id] INTEGER,
  [projectId] INTEGER,
  [dominioId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Dominio] (
  [id] INTEGER,
  [designacao] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [AreaCientifica] (
  [id] INTEGER,
  [dominioId] INTEGER,
  [designacao] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [Entigrama] (
  [id] INTEGER,
  [programId] INTEGER,
  [entidadeId] INTEGER,
  PRIMARY KEY ([id])
)

CREATE TABLE [Programa] (
  [id] INTEGER,
  [programId] INTEGER,
  [designacao] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [Instituto] (
  [id] INTEGER,
  [designacao] varchar(255),
  PRIMARY KEY ([id])
)

CREATE TABLE [UnidadeInvestigador] (
  [id] INTEGER,
  [unidadeInvestigacaoId] INTEGER,
  [investigadorId] INTEGER,
  PRIMARY KEY ([id])
)

ALTER TABLE [Projeto] ADD FOREIGN KEY ([statusId]) REFERENCES [Status] ([id])

ALTER TABLE [Contrato] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Contrato] ADD FOREIGN KEY ([statusId]) REFERENCES [Status] ([id])

ALTER TABLE [Investigador] ADD FOREIGN KEY ([idInstituto]) REFERENCES [Instituto] ([id])

ALTER TABLE [Keywords] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Publicacao] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [HistoricoStatus] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [HistoricoStatus] ADD FOREIGN KEY ([statusId]) REFERENCES [Status] ([id])

ALTER TABLE [Projama] ADD FOREIGN KEY ([programId]) REFERENCES [Programa] ([programId])

ALTER TABLE [Projama] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Dometo] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Dometo] ADD FOREIGN KEY ([dominioId]) REFERENCES [Dominio] ([dominioId])

ALTER TABLE [AreaCientifica] ADD FOREIGN KEY ([dominioId]) REFERENCES [Dominio] ([dominioId])

ALTER TABLE [Entigrama] ADD FOREIGN KEY ([programId]) REFERENCES [Programa] ([programId])

ALTER TABLE [Entigrama] ADD FOREIGN KEY ([entidadeId]) REFERENCES [Entidade] ([id])

ALTER TABLE [UnidadeInvestigador] ADD FOREIGN KEY ([unidadeInvestigacaoId]) REFERENCES [UnidadeInvestigacao] ([id])

ALTER TABLE [UnidadeInvestigador] ADD FOREIGN KEY ([investigadorId]) REFERENCES [Investigador] ([id])

ALTER TABLE [Participa] ADD FOREIGN KEY ([projectId]) REFERENCES [Projeto] ([id])

ALTER TABLE [Participa] ADD FOREIGN KEY ([InvestigadorId]) REFERENCES [Investigador] ([id])

ALTER TABLE [Papel] ADD FOREIGN KEY ([id]) REFERENCES [Participa] ([papelId])

GO
