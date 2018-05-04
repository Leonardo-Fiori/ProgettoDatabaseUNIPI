DROP DATABASE IF EXISTS Giardino;

SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 0;

BEGIN;
CREATE DATABASE `Giardino`; 
COMMIT;

USE `Giardino`;


-- Creo la tabella "Pianta"
DROP TABLE IF EXISTS `Pianta`;
CREATE TABLE `Pianta` (
  `Nome` char(50) NOT NULL,
  `Genere` char(50) NOT NULL, -- Genere come da wikipedia
  `Cultivar` char(50) NOT NULL,
  `Infestante` char(50) NOT NULL, -- Si/No
  `Dioica` char(50) NOT NULL, -- Si/No
  `Sempreverde` char(50) NOT NULL, -- Si/No
  `DimensioneMax` int(50) NOT NULL, -- Metri cubi superfice aerea occupata
  `IndiceAccrescimentoAereo` int(50) NOT NULL, -- Metri in altezza guadagnati in un anno
  `IndiceAccrescimentoRadicale` int(50) NOT NULL, -- Metri diametro guadagnati in un anno
  `IndiceManutenzione` char(50) NOT NULL,
  `DistanzaMinima` int(50) NOT NULL, -- Raggio massimo + 1 metro
-- `DaTerra` char(50), -- Si/No Attributo necessario?
  PRIMARY KEY (`Nome`, `Cultivar`)

  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Pianta"
BEGIN;
INSERT INTO `Pianta` VALUES ('Abete bianco', 'Abies', 'Nessuno', 'No', 'No', 'Si', '120', '1', '0.1', 'Bassa', '4'), 
							('Betulla bianca', 'Betula', 'Nessuno', 'No', 'No', 'Si', '600', '2', '0.2', 'Bassa', '6'), 
                            ('Cipresso sempreverde', 'Cupressus', 'Nessuno', 'No', 'No', 'Si', '45', '1.5', '0.2', 'Bassa', '4'), 
                            ('Frassino da manna', 'Fraxinus', 'Nessuno', 'No', 'Si', 'No', '900', '0.8', '0.8', 'Bassa', '9'),
                            ('Lavanda officinale', 'Lavandula', 'Nessuno', 'No', 'No', 'No', '120', '0.1', '0.1', 'Bassa', '0.5'),
                            ('Giglio', 'Lilium', 'Nessuno', 'No', 'No', 'No', '1', '1', '0.4', 'Bassa', '0.5'),
                            ('Pioppo bianco', 'Popilus', 'Nessuno', 'No', 'No', 'Si', '30', '1.5', '0.1', 'Bassa', '3'),
                            ('Biancospino comune', 'Crataegus', 'Nessuno', 'No', 'No', 'No', '25', '0.2', '0.2', 'Bassa', '3'),
                            ('Rosa', 'Rosa', 'Alba', 'No', 'No', 'No', '0.5', '1', '0.1', 'Bassa', '0.4'),
                            ('Rosa', 'Rosa', 'Moscata', 'No', 'No', 'No', '0.5', '1', '0.1', 'Bassa', '0.4');
COMMIT;

-- Creo la tabella "EsigenzePianta"
DROP TABLE IF EXISTS `EsigenzePianta`;
CREATE TABLE `EsigenzePianta` (
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  `FabbisognoAcquaVegetativo` int(50) NOT NULL, -- Litri al giorno
  `OreLuceVegetativo` int(50) NOT NULL,
  `PeriodicitaIrrigazioneVegetativo` int(50) NOT NULL,
  `OreLuceRiposo` int(50) NOT NULL,
  `PeriodicitaIrrigazioneRiposo` int(50) NOT NULL,
  `FabbisognoAcquaRiposo` int(50) NOT NULL,
  `Sole` char(50) NOT NULL, -- Pieno/Ombra/Mezzombra
  `Esposizione` char(50) NOT NULL, -- Diretta/Indiritta
  `TemperaturaMinima` int(50) NOT NULL,
  `TemperaturaMassima` int(50) NOT NULL,
  `DiradazioneIrrigazioneRiposo` int(50) NOT NULL, -- Ad ogni irrigazione, quanto aumenta il periodo.
  PRIMARY KEY (`Nome`,`Cultivar`),

  CONSTRAINT Vincolo1
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "EsigenzePianta"
BEGIN;
INSERT INTO `EsigenzePianta` VALUES ('Giglio', 'Nessuno', '1', '8', '2', '6', '5', '1', 'Mezzombra', 'Diretta', '15', '38', '1'),
                                    ('Abete Bianco', 'Nessuno', '1', '8', '1', '5', '6', '1', 'Mezzombra', 'Indiretta', '15', '38', '1'),
                                    ('Betulla Bianca', 'Nessuno', '2', '8', '2', '6', '6', '2', 'Ombra', 'Diretta', '15', '38', '1'),
                                    ('Cipresso Sempreverde', 'Nessuno', '1', '5', '2', '6', '5', '4', 'Pieno', 'Diretta', '15', '38', '1'),
                                    ('Frassino da manna', 'Nessuno', '2', '7', '2', '7', '3', '1', 'Pieno', 'Indiretta', '15', '38', '1'),
                                    ('Lavanda officinale', 'Nessuno', '1', '8', '2', '5', '4', '5', 'Pieno', 'Diretta', '15', '38', '1'),
                                    ('Pioppo Bianco', 'Nessuno', '1', '8', '2', '2', '5', '4', 'Pieno', 'Diretta', '15', '38', '1'),
                                    ('Biancospino comune', 'Nessuno', '1', '8', '1', '4', '5', '2', 'Mezzombra', 'Indiretta', '15', '38', '1'),
                                    ('Rosa', 'Alba', '1', '8', '2', '6', '5', '1', 'Mezzombra', 'Diretta', '15', '38', '1'),
                                    ('Rosa', 'Moscata', '1', '8', '2', '6', '5', '1', 'Mezzombra', 'Diretta', '15', '38', '1');
COMMIT;

-- Creo la tabella "Terreno"
DROP TABLE IF EXISTS `Terreno`;
CREATE TABLE `Terreno` (
  `NomeTerreno` char(50) NOT NULL,
  `Consistenza` int(50) NOT NULL,
  `Permeabilita` int(50) NOT NULL,
  `PH` int(50) NOT NULL,
  PRIMARY KEY (`NomeTerreno`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Terreno"
BEGIN;
INSERT INTO `Terreno` VALUES ('Argilla', '4', '1', '4'),
							 ('Argilla limosa', '3', '2', '5'),
                             ('Terriccio limoso argilloso', '2', '4', '6'),
                             ('Terriccio argilloso', '3', '1', '7'),
                             ('Terriccio limoso', '3', '1', '8'),
                             ('Limo', '4', '2', '9'),
                             ('Terra grassa', '2', '4', '10'),
                             ('Sabbia argillosa', '1', '4', '4'),
                             ('Terriccio sabbioso argilloso', '2', '4', '5'),
                             ('Limo sabbioso', '1', '2', '6');
COMMIT;

-- Creo la tabella "Terriccio"
DROP TABLE IF EXISTS `Terriccio`;
CREATE TABLE `Terriccio` (
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  `NomeTerreno` char(50) NOT NULL,
  PRIMARY KEY (`Nome`,`Cultivar`,`NomeTerreno`),
  
  CONSTRAINT Vincolo2
  FOREIGN KEY (NomeTerreno) REFERENCES Terreno(NomeTerreno) ,
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo3
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Terriccio"
BEGIN;
INSERT INTO `Terriccio` VALUES ('Giglio', 'Nessuno', 'Terra Grassa'),
							   ('Abete Bianco', 'Nessuno', 'Terra Grassa'),
                               ('Biancospino Comune', 'Nessuno', 'Terriccio Limoso'),
                               ('Biancospino Comune', 'Nessuno', 'Terra Grassa'),
                               ('Pioppo Bianco', 'Nessuno', 'Terra Grassa'),
                               ('Pioppo Bianco', 'Nessuno', 'Terriccio Argilloso'),
                               ('Betulla Bianca', 'Nessuno', 'Terra Grassa'),
                               ('Cipresso Sempreverde', 'Nessuno', 'Terra Grassa'),
                               ('Frassino da Manna', 'Nessuno', 'Terriccio Argilloso Sabbioso'),
                               ('Lavanda Officinale', 'Nessuno', 'Terriccio Argilloso'),
                               ('Rosa', 'Alba', 'Terra Grassa'),
                               ('Rosa', 'Moscata', 'Terra Grassa');
COMMIT;

-- Creo la tabella "ElementiDisciolti"
DROP TABLE IF EXISTS `ElementiDisciolti`;
CREATE TABLE `ElementiDisciolti` (
  `Elemento` char(50) NOT NULL,
  PRIMARY KEY (`Elemento`)

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "ElementiDisciolti"
BEGIN;
INSERT INTO `ElementiDisciolti` VALUES ('Azoto'),
									   ('Magnesio'),
                                       ('Fosforo'),
                                       ('Potassio'),
                                       ('Zolfo'),
                                       ('Calcio'),
                                       ('Ferro'),
                                       ('Boro'),
                                       ('Manganese'),
                                       ('Rame');
COMMIT;

-- Creo la tabella "Elementi"
DROP TABLE IF EXISTS `Elementi`;
CREATE TABLE `Elementi` (
  `NomeTerreno` char(50) NOT NULL,
  `Elemento` char(50) NOT NULL,
  `Concentrazione` int(50) NOT NULL,
  PRIMARY KEY (`NomeTerreno`,`Elemento`),
  
  CONSTRAINT Vincolo4
  FOREIGN KEY (Elemento) REFERENCES ElementiDisciolti(Elemento)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo5
  FOREIGN KEY (NomeTerreno) REFERENCES Terreno(NomeTerreno)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Elementi"
BEGIN;
INSERT INTO `Elementi` VALUES ('Argilla', 'Magnesio', '20'),
							  ('Sabbia argilla', 'Calcio', '30'),
                              ('Sabbia argilla', 'Rame', '30'),
                              ('Argilla limosa', 'Calcio', '45'),
                              ('Terriccio argilloso', 'Fosforo', '33'),
                              ('Terriccio sabbioso argilloso', 'Rame', '60'),
                              ('Terriccio limoso argilloso', 'Zolfo', '10'),
                              ('Terriccio limoso argilloso', 'Manganese', '12'),
                              ('Terra grassa', 'Fosforo', '25'),
                              ('Terriccio limoso', 'Potassio', '40'),
                              ('Limo', 'Potassio', '12'),
                              ('Limo sabbioso', 'Manganese', '26');
COMMIT;

-- Creo la tabella "Componenti"
DROP TABLE IF EXISTS `Componenti`;
CREATE TABLE `Componenti` (
  `Componente` char(50) NOT NULL,
  `Consistenza` int(50) NOT NULL, -- 1,2,3
  `Permeabilita` int(50) NOT NULL, -- 1,2,3
  PRIMARY KEY (`Componente`)

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Componenti"
BEGIN;
INSERT INTO `Componenti` VALUES ('Argilla', '2', '1'),
								('Terriccio', '2', '1'),
								('Limo', '1', '3'),
                                ('Sabbia', '1', '3'),
                                ('Ghiaia Fine', '3', '2'),
                                ('Ghiaia Grossa', '3', '2'),
                                ('Torba', '3', '1'),
                                ('Truciolato', '3', '1');
COMMIT;

-- Creo la tabella "ComponenzaTerreno"
DROP TABLE IF EXISTS `ComponenzaTerreno`;
CREATE TABLE `ComponenzaTerreno` (
  `NomeTerreno` char(50) NOT NULL,
  `Componente` char(50) NOT NULL,
  `Percentuale` int(50) NOT NULL,
  PRIMARY KEY (`Componente`,`NomeTerreno`),
  
  CONSTRAINT Vincolo6
  FOREIGN KEY (Componente) REFERENCES Componenti(Componente)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo7
  FOREIGN KEY (NomeTerreno) REFERENCES Terreno(NomeTerreno)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Componenti"
BEGIN;
INSERT INTO `ComponenzaTerreno` VALUES ('Argilla', 'Argilla', '100'),
									   ('Argilla Limosa', 'Argilla', '40'),
                                       ('Argilla Limosa', 'Limo', '40'),
                                       ('Argilla', 'Sabbia', '20'),
                                       ('Terriccio argilloso limoso', 'Limo', '60'),
									   ('Terriccio argilloso limoso', 'Argilla', '30'),
                                       ('Terriccio argilloso limoso', 'Sabbia', '10'),
                                       ('Terriccio limoso', 'Limo', '70'),
                                       ('Terriccio limoso', 'Argilla', '20'),
                                       ('Terriccio limoso', 'Sabbia', '10'),
                                       ('Limo', 'Limo', '100'),
                                       ('Terra grassa', 'Limo', '50'),
                                       ('Terra grassa', 'Sabbia', '40'),
                                       ('Terra grassa', 'Argilla', '10'),
                                       ('Terriccio argilloso', 'Sabbia', '30'),
                                       ('Terriccio argilloso', 'Argilla', '35'),
                                       ('Terriccio argilloso', 'Limo', '35'),
                                       ('Sabbia argilla', 'Argilla', '40'),
                                       ('Sabbia argilla', 'Sabbia', '60'),
                                       ('Terriccio sabbioso argilloso', 'Argilla', '20'),
                                       ('Terriccio sabbioso argilloso', 'Sabbia', '60'),
                                       ('Terriccio sabbioso argilloso', 'Limo', '20'),
                                       ('Limo sabbioso', 'Sabbia', '40'),
                                       ('Limo sabbioso', 'Limo', '40'),
                                       ('Limo sabbioso', 'Argilla', '20');
COMMIT;

-- Creo la tabella "InterventiConcimazione"
DROP TABLE IF EXISTS `InterventiConcimazione`;
CREATE TABLE `InterventiConcimazione` (
  `Codice` INT NOT NULL AUTO_INCREMENT,
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL, 
  `Periodo` int(50) NOT NULL, -- Numero del mese
  `TipoApplicazione` char(50) NOT NULL, -- Terreno/Aerea
  PRIMARY KEY (`Codice`, `Nome`,`Cultivar`),
  
  CONSTRAINT Vincolo8
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "InterventiConcimazione"
BEGIN;
INSERT INTO `InterventiConcimazione` (Nome, Cultivar, Periodo, TipoApplicazione) VALUES 
											('Abete Bianco', 'Nessuno', '01', 'Terreno'),
											('Biancospino Comune', 'Nessuno', '01', 'Terreno'),
											('Cipresso Sempreverde', 'Nessuno', '03', 'Aerea'),
											('Frassino da Manna', 'Nessuno', '04', 'Terreno'),
											('Rosa', 'Alba', '05', 'Terreno'),
											('Rosa', 'Moscata', '06', 'Terreno'),
											('Giglio', 'Nessuno', '07', 'Aerea'),
											('Lavanda Officinale', 'Nessuno', '08', 'Terreno'),
											('Rosa', 'Alba', '09', 'Terreno'),
											('Lavanda Officinale', 'Nessuno', '10', 'Aerea');
COMMIT;

-- Creo la tabella "ComponenzaConcimazione"
DROP TABLE IF EXISTS `ComponenzaConcimazione`;
CREATE TABLE `ComponenzaConcimazione` (
  `Codice` INT NOT NULL, -- Codice concimazione
  `Sostanza` char(50) NOT NULL,
  `Peso` int(50) NOT NULL, -- percentuale su 100g di concime
  PRIMARY KEY (`Codice`,`Sostanza`,`Peso`),

  CONSTRAINT Vincolo9
  FOREIGN KEY (Sostanza) REFERENCES SostanzeConcimazione(Sostanza)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo10
  FOREIGN KEY (Codice) REFERENCES InterventiConcimazione(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "ComponenzaConcimazione"
BEGIN;
INSERT INTO `ComponenzaConcimazione` VALUES ('001', 'Fosforo', '5'),
											('001', 'Boro', '1'),
											('002', 'Magnesio', '11'),
											('003', 'Potassio', '15'),
											('004', 'Zolfo', '8'),
											('005', 'Rame', '11'),
											('006', 'Cloro', '10'),
											('007', 'Azoto', '15'),
											('008', 'Potassio', '1'),
											('009', 'Managanese', '20'),
											('009', 'Magnesio', '15'),
											('010', 'Fosforo', '5');
COMMIT;

-- Creo la tabella "SostanzeConcimazione"
DROP TABLE IF EXISTS `SostanzeConcimazione`;
CREATE TABLE `SostanzeConcimazione` (
  `Sostanza` char(50) NOT NULL,
  PRIMARY KEY (`Sostanza`)
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "SostanzeConcimazione"
BEGIN;
INSERT INTO `SostanzeConcimazione` VALUES ('Azoto'),
										  ('Fosforo'),
										  ('Potassio'),
										  ('Calcio'),
										  ('Magnesio'),
										  ('Zolfo'),
										  ('Fluoro'),
										  ('Boro'),
										  ('Manganese'),
										  ('Rame');
COMMIT;

-- Creo la tabella "Rinvaso"
DROP TABLE IF EXISTS `Rinvaso`;
CREATE TABLE `Rinvaso` (
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  `Periodo` int(50) NOT NULL,
  PRIMARY KEY (`Nome`,`Cultivar`,`Periodo`),
  
  CONSTRAINT Vincolo11
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Rinvaso"
BEGIN;
INSERT INTO `Rinvaso` VALUES ('Abete bianco', 'Nessuno', '03'),
							 ('Betulla bianca', 'Nessuno', '10'), 
                             ('Cipresso sempreverde', 'Nessuno', '04'), 
							 ('Frassino da manna', 'Nessuno', '07'),
                             ('Lavanda officinale', 'Nessuno', '05'),
							 ('Giglio', 'Lilium', '04'),
                             ('Pioppo bianco', 'Nessuno', '03'),
                             ('Biancospino comune', 'Nessuno', '06'),
                             ('Rosa', 'Alba', '11'),
                             ('Rosa', 'Moscata', '11');
COMMIT;

-- Creo la tabella "Potatura"
DROP TABLE IF EXISTS `Potatura`;
CREATE TABLE `Potatura` (
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  `Periodo` int(50) NOT NULL,
  `TipoIntervento` char(50) NOT NULL,
  PRIMARY KEY (`TipoIntervento`,`Nome`,`Cultivar`, `Periodo`),
  
  CONSTRAINT Vincolo12
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Potatura"
BEGIN;
INSERT INTO `Potatura` VALUES ('Abete bianco', 'Nessuno', '04', 'Contenimento Dimensioni'), 
							  ('Betulla bianca', 'Nessuno', '09', 'Contenimento Dimensioni'), 
                              ('Cipresso sempreverde', 'Nessuno', '05', 'Contenimento Dimensioni'), 
							  ('Frassino da manna', 'Nessuno', '08', 'Rimozione PartiMorte'),
                              ('Lavanda officinale', 'Nessuno', '04', 'Aumento Produzione'),
							  ('Giglio', 'Lilium', '05', 'Aumento Produzione'),
                              ('Pioppo bianco', 'Nessuno', '02', 'Rimozione PartiMorte'),
                              ('Biancospino comune', 'Nessuno', '07', 'Aumento Produzione'),
                              ('Rosa', 'Alba', '10', 'Aumento Produzione'),
                              ('Rosa', 'Moscata', '10', 'Aumento Produzione');
COMMIT;

-- Creo la tabella "MalattiaContraibile"
DROP TABLE IF EXISTS `MalattiaContraibile`;
CREATE TABLE `MalattiaContraibile` (
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  `NomePatologia` char(50) NOT NULL,
  PRIMARY KEY (`Nome`,`Cultivar`,`NomePatologia`),
  
  CONSTRAINT Vincolo13
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo14
  FOREIGN KEY (NomePatologia) REFERENCES Patologia(NomePatologia)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "MalattiaContraibile"
BEGIN;
INSERT INTO `MalattiaContraibile` VALUES ('Abete bianco', 'Nessuno', 'Peronospora'),
										 ('Betulla bianca', 'Nessuno', 'Peronospora'), 
										 ('Cipresso sempreverde', 'Nessuno', 'Muffa grigia'), 
										 ('Frassino da manna', 'Nessuno', 'Muffa grigia'),
										 ('Lavanda officinale', 'Nessuno', 'Peronospora'),
										 ('Giglio', 'Lilium', 'Muffa grigia'),
										 ('Pioppo bianco', 'Nessuno', 'Muffa grigia'),
										 ('Rosa', 'Alba', 'Oidio'),
										 ('Rosa', 'Moscata', 'Oidio'),
										 ('Cipresso sempreverde', 'Nessuno', 'Sclerotinia'), 
										 ('Frassino da manna', 'Nessuno', 'Ruggine delle piante'),
										 ('Lavanda officinale', 'Nessuno', 'Ticchiolatura'),
										 ('Giglio', 'Lilium', 'Antracnosi'),
										 ('Pioppo bianco', 'Nessuno', 'Antracnosi'),
										 ('Biancospino comune', 'Nessuno', 'Alternariosi'),
										 ('Pioppo bianco', 'Nessuno', 'Alternariosi'),
										 ('Biancospino comune', 'Nessuno', 'Afidi'),
										 ('Frassino da manna', 'Nessuno', 'Afidi'),
										 ('Lavanda officinale', 'Nessuno', 'Cocciniglia'),
										 ('Giglio', 'Lilium', 'Cocciniglia'),
										 ('Pioppo bianco', 'Nessuno', 'Peronospora'),
										 ('Biancospino comune', 'Nessuno', 'Oidio');
COMMIT;	

-- Creo la tabella "MalattieContratte"
DROP TABLE IF EXISTS `MalattieContratte`;
CREATE TABLE `MalattieContratte` (
  `CodicePianta` INT NOT NULL,
  `DataContrazione` DATE NOT NULL,
  `DataGuarigione` DATE NOT NULL,
  `Patologia` char(50) NOT NULL,
  PRIMARY KEY (`CodicePianta`,`Patologia`,`DataContrazione`),
  
  CONSTRAINT Vincolo15
  FOREIGN KEY (Patologia) REFERENCES Patologia(NomePatologia)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,

  CONSTRAINT Vincolo16
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "MalattieContratte"
BEGIN;
INSERT INTO `MalattieContratte` VALUES ('001', '2016-06-02', '2016-06-20', 'Peronospora'), 
									   ('002', '2016-05-23', '2016-06-11', 'Peronospora'), 
									   ('003', '2015-07-15', '2016-06-01', 'Muffa grigia'), 
									   ('004', '2016-01-01', '2016-04-05', 'Muffa grigia'), 
									   ('005', '2016-04-05', '2016-05-11', 'Peronospora'), 
									   ('006', '2015-06-07', '2016-07-07', 'Peronospora'),
									   ('007', '2015-02-01', '2015-04-12', 'Peronospora'), 
									   ('008', '2014-04-12', '2014-06-11', 'Oidio'), 
									   ('009', '2014-11-01', '2015-11-12', 'Oidio'), 
									   ('010', '2013-01-01', '2013-02-02', 'Oidio');
COMMIT;

-- Creo la tabella "Patologia"
DROP TABLE IF EXISTS `Patologia`;
CREATE TABLE `Patologia` (
  `NomePatologia` char(50) NOT NULL,
  `Probabilita` int(50) NOT NULL,
  `Periodo` char(50) NOT NULL,
  `Entita` int(50) NOT NULL, -- 1/10
  `AgentePatogeno` char(50) NOT NULL,
  PRIMARY KEY (`NomePatologia`)

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Patologia"
BEGIN;
INSERT INTO `Patologia` VALUES ('Oidio', '50', 'Sempre', '4', 'Fungo'),
							   ('Peronospora', '30', 'Estate', '6', 'Fungo'),
                               ('Muffa grigia', '70', 'Inverno', '4', 'Fungo'),
                               ('Sclerotinia', '30', 'Sempre', '4', 'Fungo'),
                               ('Ruggine delle piante', '50', 'Inverno', '4', 'Fungo'),
                               ('Ticchiolatura', '50', 'Sempre', '4', 'Fungo'),
                               ('Antracnosi', '55', 'Sempre', '7', 'Fungo'),
                               ('Alternariosi', '10', 'Estate', '4', 'Fungo'),
                               ('Afidi', '50', 'Sempre', '4', 'Parassita'),
                               ('Cocciniglia', '50', 'Sempre', '4', 'Parassita');
COMMIT;

-- Creo la tabella "Sintomo"
DROP TABLE IF EXISTS `Sintomo`;
CREATE TABLE `Sintomo` (
  `Codice` INT(50) NOT NULL AUTO_INCREMENT,
  `Descrizione` TEXT NOT NULL,
  PRIMARY KEY (`Codice`)
 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Sintomo"
BEGIN;
INSERT INTO `Sintomo`(Descrizione) VALUES   ('Sulle lamine fogliari appaino gradualmente delle decolorazioni con successivo ingiallimento e disseccamento'),
											('Si osserva un disseccamento parziale o addirittura totale delle foglie, preceduto da decolorazioni ed imbrunimenti fogliari'),
											('Si osserva la formazione di uno strato feltroso compatto di colore grigiastro sui tessuti della pianta'),
											('Si osserva la disgregazione completa del midollo con formazione di un feltro di colore biancastro nel quale si scorgono formazioni più scure'),
											('Si osserva la comparsa di uno strato superficiale di aspetto polverulento di color rossiccio brunastro'),
											('Foglie caratterizzate da tacche di colore bruno nerastro presenti sia sulla pagina superiore che su quella inferiore'),
											('Sui germogli compaiono strozzature di colore rosato che si trasformano in necrosi e che si ripiegano ad uncino in modo caratteristico'),
											('Macchie necrotiche tondeggianti di colore scuro che si sviluppano inizialmente sulle foglie della pianta'),
											('Presenza di piccoli insetti sulle piante'), -- A
											('Alterazione delle foglie'), -- A
											('Presenza di piccoli insetti di colore bianco sulle foglie'), -- B
											('Decolorazioni a macchie sulle foglie'); -- B
COMMIT;

-- Creo la tabella "Sintomi"
DROP TABLE IF EXISTS `Sintomi`;
CREATE TABLE `Sintomi` (
  `NomePatologia` char(50) NOT NULL,
  `Codice` INT NOT NULL,
  PRIMARY KEY (`NomePatologia`,`Codice`),

  CONSTRAINT Vincolo17
  FOREIGN KEY (NomePatologia) REFERENCES Patologia(NomePatologia)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,

  CONSTRAINT Vincolo18
  FOREIGN KEY (Codice) REFERENCES Sintomo(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Sintomi"
BEGIN;
INSERT INTO `Sintomi` VALUES ('Oidio', '001'),
							 ('Peronospora', '002'),
                             ('Muffa grigia', '003'),
                             ('Sclerotinia', '004'),
                             ('Ruggine delle piante', '005'),
                             ('Ticchiolatura', '006'),
                             ('Antracnosi', '007'),
                             ('Alternariosi', '008'),
                             ('Afidi', '009'),
                             ('Afidi', '010'),
                             ('Cocciniglia', '011'),
                             ('Cocciniglia', '012');
COMMIT;

-- Creo la tabella "Foto"
DROP TABLE IF EXISTS `Foto`;
CREATE TABLE `Foto` (
  `Codice` int(50) NOT NULL,
  `URL` char(255) NOT NULL,
  PRIMARY KEY (`Codice`,`URL`),
  
  CONSTRAINT Vincolo19
  FOREIGN KEY (Codice) REFERENCES Sintomo(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Foto"
BEGIN;
INSERT INTO `Foto` VALUES ('001', 'http://www.lortodiclaire.it/wp-content/uploads/2015/05/Oidio.jpg'), 
						  ('002', 'http://www.coltivobio.com/wp-content/uploads/2015/01/IMG_7215-copia.jpg'), 
                          ('003', 'http://www.pollicegreen.com/wp-content/uploads/2009/11/muffa-grigia.jpg'), 
                          ('004', 'http://www.canolawatch.org/wp-content/uploads/2012/08/base-sclerotinia-small-Kubinec.jpg'), 
                          ('005', 'http://www.coltivarefacile.it/wp-content/uploads/2012/03/ruggine-piante.jpg'),
                          ('006', 'http://static.giardinaggio.it/malattie/singolemalattie/ticchiolatura/ticchiolatura_NG3.jpg'), 
                          ('007', 'http://www.geasnc.eu/wp-content/uploads/2011/11/GEA_antracnosi_ippocastano3.jpg'), 
                          ('008', 'http://www.ortosemplice.it/wp-content/uploads/2013/09/Alternaria-alternata.jpg'), 
                          ('009', 'http://www.greenme.it/immagini/abitare/orto-giardino/afidi.jpg'), 
                          ('010', 'http://www.greenme.it/immagini/abitare/orto-giardino/cocciniglie.jpg'); 
				
COMMIT;

-- Creo la tabella "ProdottoCura"
DROP TABLE IF EXISTS `ProdottoCura`;
CREATE TABLE `ProdottoCura` (
  `Nome` char(50) NOT NULL,
  `Produttore` char(50) NOT NULL,
  `TempoMinAttesaPostUso` int(50) NOT NULL, -- Giorni
  `SomministrazioneAerea` char(50) NOT NULL,
  `SomministrazioneIrrigamento` char(50) NOT NULL,
  PRIMARY KEY (`Nome`)

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "ProdottoCura"
BEGIN;
INSERT INTO `ProdottoCura` VALUES ('Agrifen11FC', 'AgripharItalia', '2', 'Si', 'No'),
								  ('Ampelosan Combi', 'Dow Agrosciences', '4', 'No', 'Si'),
								  ('Cuprofolpet Bleu', 'Makhteshim Agan', '1', 'Si', 'Si'),
                                  ('Punginex', 'Cafarro', '6', 'No', 'Si'),
                                  ('Dodina', 'Nufarm', '3', 'Si', 'No'),
                                  ('Maneb', 'Dasf', '7', 'Si', 'No'),
                                  ('Afugan', 'Aventis Corposcience', '1', 'Si', 'No'),
                                  ('Askum', 'Rocca Frutta', '8', 'No', 'Si'),
                                  ('Adinil', 'Adica', '9', 'Si', 'Si'),
								  ('Benprop Pro', 'Makhteshim Agan', '10', 'Si', 'No');
COMMIT;

-- Creo la tabella "ProdottiCura"
DROP TABLE IF EXISTS `ProdottiCura`;
CREATE TABLE `ProdottiCura` (
  `Nome` char(50) NOT NULL,
  `NomePatologia` char(50) NOT NULL,
  PRIMARY KEY (`Nome`,`NomePatologia`),
  
  CONSTRAINT Vincolo20
  FOREIGN KEY (NomePatologia) REFERENCES Patologia(NomePatologia)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo21
  FOREIGN KEY (Nome) REFERENCES ProdottoCura(Nome)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "ProdottiCura"
BEGIN;
INSERT INTO `ProdottiCura` VALUES ('Agrifen11FC', 'Oidio'),
								  ('Ampelosan Combi', 'Perolospora'),
                                  ('Cuprofolpet Bleu', 'Muffa grigia'),
                                  ('Punginex', 'Ruggine delle piante'),
                                  ('Dodina', 'Ticchiolatura'),
                                  ('Maneb', 'Alternariosi'),
                                  ('Afugan', 'Oidio'),
                                  ('Askum', 'Perolospora'),
                                  ('Adinil', 'Muffa grigia'),
                                  ('Benprop Pro', 'Ruggine delle piante');
COMMIT;

-- Creo la tabella "PrincipioAttivo"
DROP TABLE IF EXISTS `PrincipioAttivo`;
CREATE TABLE `PrincipioAttivo` (
  `NomePrincipio` char(50) NOT NULL,
  PRIMARY KEY (`NomePrincipio`)   

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "PrincipioAttivo"
BEGIN;
INSERT INTO `PrincipioAttivo` VALUES ('Fenarimol'),
									 ('Folpet'),
                                     ('Oxadixil'),
                                     ('Oxychloride'),
                                     ('Triforine'),
                                     ('Dodine'),
                                     ('Maneb'),
                                     ('Pyrazophos'),
                                     ('Cymoxanil'),
                                     ('Chlorothalonil'),
                                     ('Prochloraz'),
                                     ('Propiconazole');
COMMIT;

-- Creo la tabella "PrincipiAttiviContenuti"
DROP TABLE IF EXISTS `PrincipiAttiviContenuti`;
CREATE TABLE `PrincipiAttiviContenuti` (
  `Nome` char(50) NOT NULL,
  `NomePrincipio` char(50) NOT NULL,
  `Concentrazione` INT(50) NOT NULL,
  PRIMARY KEY (`Nome`,`NomePrincipio`),
  
  CONSTRAINT Vincolo22
  FOREIGN KEY (NomePrincipio) REFERENCES PrincipioAttivo(NomePrincipio)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo23
  FOREIGN KEY (Nome) REFERENCES ProdottoCura(Nome)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "PrincipiAttiviContenuti"
BEGIN;
INSERT INTO `PrincipiAttiviContenuti` VALUES ('Agrifen11FC', 'Fenarimol', '11'),
											 ('Ampelosan Combi', 'Folpet', '35'),
											 ('Ampelosan Combi', 'Oxadixil', '10'),
                                             ('Cuprofolpet Bleu', 'Folpet', '30'),
                                             ('Cuprofolpet Bleu', 'Oxychloride', '15'),
                                             ('Punginex', 'Triforine', '18'),
                                             ('Dodina', 'Dodine', '30'),
                                             ('Maneb', 'Maneb', '80'),
                                             ('Pyrazophos', 'Afugan' ,'15'),
                                             ('Askum', 'Cymoxanil', '30'),
                                             ('Adinil', 'Chlorothalonil', '54'),
                                             ('Benprop Pro', 'Prochloraz', '35'),
											 ('Benprop Pro', 'Propiconazole', '8');
COMMIT;

-- Creo la tabella "Periodo"
DROP TABLE IF EXISTS `Periodo`;
CREATE TABLE `Periodo` (
  `Nome` char(50) NOT NULL,
  `DataInizio` int(50) NOT NULL,
  `DataFine` int(50) NOT NULL,
  PRIMARY KEY (`Nome`, `DataInizio`, `DataFine`),
  
  CONSTRAINT Vincolo24
  FOREIGN KEY (Nome) REFERENCES ProdottoCura(Nome)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Periodo"
BEGIN;
INSERT INTO `Periodo` VALUES ('Agrifen11FC', '01', '02'), 
							 ('Agrifen11FC', '06', '08'),
							 ('Ameplosan Combi', '09', '10'),
							 ('Ampelosan Combi', '10', '11'),
							 ('Dodina', '06', '08'),
							 ('Dodina', '08', '09'),
							 ('Maneb', '03', '05'),
							 ('Maneb', '05', '06'),
							 ('Afukan', '11', '12'),
							 ('Afukan', '02', '03');
COMMIT;

-- Creo la tabella "FasiPianta"
DROP TABLE IF EXISTS `FasiPianta`;
CREATE TABLE `FasiPianta` (
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  `InizioPeriodoVegetativo` char(50) NOT NULL,
  `FinePeriodoVegetativo` char(50) NOT NULL,
  `InizioPeriodoRiposo` char(50) NOT NULL,
  `FinePeriodoRiposo` char(50) NOT NULL,
  `InizioPeriodoFioritura` char(50) NOT NULL,
  `FinePeriodoFioritura` char(50) NOT NULL,
  `InizioPeriodoFruttificazione` char(50) NOT NULL,
  `FinePeriodoFruttificazione` char(50) NOT NULL,
  PRIMARY KEY (`Nome`,`Cultivar`),


  CONSTRAINT Vincolo25
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "FasiPianta"
BEGIN;
INSERT INTO `FasiPianta` VALUES ('Abete Bianco', 'Nessuno', '05', '09', '10', '04', '02', '03', '04', '05'),
								('Betulla Bianca', 'Nessuno', '05', '09', '10', '04', '02', '03', '04', '05'),
								('Cipresso Sempreverde', 'Nessuno', '05', '09', '10', '04', '02', '03', '04', '05'),
								('Frassino da Manna', 'Nessuno', '05', '09', '10', '04', '02', '03', '04', '05'),
								('Lavanda Officinale', 'Nessuno', '05', '09', '10', '04', '02', '03', '04', '05'),
								('Giglio', 'Nessuno', '05', '09', '10', '04', '02', '03', '04', '05'),
								('Pioppo Bianco', 'Nessuno', '05', '09', '10', '04', '02', '03', '04', '05'),
								('Biancospino Comune', 'Nessuno', '05', '09', '10', '04', '02', '03', '04', '05'),
								('Rosa', 'Alba', '05', '09', '10', '04', '02', '03', '04', '05'),
								('Rosa', 'Moscata', '05', '09', '10', '04', '02', '03', '04', '05');
COMMIT;

-- Creo la tabella "Piante"
DROP TABLE IF EXISTS `Piante`;
CREATE TABLE `Piante` (
  `CodicePianta` INT NOT NULL AUTO_INCREMENT,
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  `Dimensione` int(50) NOT NULL, -- Circoferenza tronco
  `Prezzo` int(50) NOT NULL,  -- Presi da un listino
  `Acquistata` char(50) NOT NULL,
  PRIMARY KEY (`CodicePianta`)

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Piante"
BEGIN;
INSERT INTO `Piante` (Nome, Cultivar, Dimensione, Prezzo, Acquistata) VALUES 
							('Betulla bianca', 'Nessuno', '20', '264', 'Si'), 
							('Abete bianco','Nessuno', '25', '109', 'Si'), 
                            ('Frassino da manna', 'Nessuno', '20', '240', 'Si'), 
                            ('Cipresso sempreverde', 'Nessuno', '15', '91', 'Si'), 
                            ('Pioppo bianco', 'Nessuno', '10', '32', 'Si'),
                            ('Abete bianco', 'Nessuno', '30', '160', 'Si'), 
                            ('Lavanda officinale', 'Nessuno', '2', '4', 'Si'),
                            ('Biancospino comune','Nessuno', '3', '9', 'Si'), 
                            ('Lavanda officinale', 'Nessuno', '3', '10', 'Si'), 
                            ('Rosa', 'Moscata', '2', '13', 'Si'), 
                            ('Rosa', 'Moscata', '2', '13', 'Si'), 
                            ('Rosa', 'Alba', '2', '11', 'Si'),
                            ('Pioppo bianco', 'Nessuno', '10', '32', 'Si'),
                            ('Rosa', 'Alba', '2', '11', 'No'),
                            ('Betulla bianca', 'Nessuno', '20', '264', 'No');

COMMIT;

-- Creo la tabella "PatologieRilevate"
DROP TABLE IF EXISTS `PatologieRilevate`;
CREATE TABLE `PatologieRilevate` (
  `CodicePianta` int(50) NOT NULL,
  `DataPatologia` date NOT NULL,
  `NomePatologia` char(50) NOT NULL,
  PRIMARY KEY (`CodicePianta`,`DataPatologia`),

  CONSTRAINT Vincolo26
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo27
  FOREIGN KEY (NomePatologia) REFERENCES Patologia(NomePatologia)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "PatologieRilevate"
BEGIN;
INSERT INTO `PatologieRilevate` VALUES ('001', '2016-06-01', 'Peronospora'),
									   ('002', '2016-05-22', 'Peronospora'),
									   ('003', '2015-07-15', 'Muffa grigia'),
									   ('004', '2016-01-01', 'Muffa grigia'),
									   ('005', '2016-04-05', 'Peronospora'),
									   ('006', '2015-06-07', 'Peronospora'),
									   ('007', '2015-02-01', 'Peronospora'),
									   ('008', '2014-04-12', 'Oidio'),
									   ('009', '2014-11-01', 'Oidio'),
									   ('010', '2013-01-01', 'Oidio');
COMMIT;

-- Creo la tabella "SintomiRilevati"
DROP TABLE IF EXISTS `SintomiRilevati`;
CREATE TABLE `SintomiRilevati` (
  `CodicePianta` int(50) NOT NULL,
  `DataSintomo` date NOT NULL,
  `Codice` int(50) NOT NULL,
  PRIMARY KEY (`CodicePianta`,`DataSintomo`),

  CONSTRAINT Vincolo28
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo29
  FOREIGN KEY (Codice) REFERENCES Sintomo(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "SintomiRilevati"
BEGIN;
INSERT INTO `SintomiRilevati` VALUES ('001', '2016-06-01', '002'),
									 ('002', '2016-05-22', '002'),
									 ('003', '2015-07-15', '003'),
									 ('004', '2016-01-01', '003'),
									 ('005', '2016-04-05', '007'),
									 ('006', '2015-06-07', '002'),
									 ('007', '2015-02-01', '011'),
									 ('008', '2014-04-12', '001'),
									 ('009', '2014-11-01', '001'),
									 ('010', '2013-01-01', '001');
COMMIT;

-- Creo la tabella "SubstratoRilevato"
DROP TABLE IF EXISTS `SubstratoRilevato`;
CREATE TABLE `SubstratoRilevato` (
  `CodicePianta` int(50) NOT NULL,
  `DataSubstrato` date NOT NULL,
  `Elemento` char(50) NOT NULL,
  `Concentrazione` int(50) NOT NULL,
  PRIMARY KEY (`CodicePianta`,`DataSubstrato`,`Elemento`),
  
  CONSTRAINT Vincolo30
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,

  CONSTRAINT Vincolo31
  FOREIGN KEY (Elemento) REFERENCES ElementiDisciolti(Elemento)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION  

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "SubstratoRilevato"
BEGIN;
INSERT INTO `SubstratoRilevato` VALUES 	('001', '2016-06-01', 'Azoto', '10'),
										('001', '2016-06-01', 'Rame', '10'),
										('002', '2016-05-22', 'Magnesio', '15'),
										('003', '2015-07-15', 'Zolfo', '5'),
										('004', '2016-01-01', 'Calcio', '15'),
										('005', '2016-04-05', 'Manganese', '18'),
										('006', '2015-06-07', 'Rame', '20'),
										('006', '2015-06-07', 'Calcio', '20'),
										('007', '2015-02-01', 'Zolfo', '002'),
										('008', '2014-04-12', 'Manganese', '002'),
										('009', '2014-11-01', 'Boro', '002'),
										('009', '2014-11-01', 'Potassio', '002'),
										('010', '2013-01-01', 'Fosforo', '002');
COMMIT;

-- Creo la tabella "Contenitore"
DROP TABLE IF EXISTS `Contenitore`;
CREATE TABLE `Contenitore` (
  `Codice` INT NOT NULL AUTO_INCREMENT,
  `CodicePianta` int(50),
  `Infetto` char(50) NOT NULL,
  `Substrato` char(50) NOT NULL,
  `Dimensione` int(50) NOT NULL, -- Raggio in centimetri
  `Quarantena` char(50) NOT NULL,
  `CodiceRipiano` int(50) NOT NULL,
  `Esalazione` char(50) NOT NULL, -- Si
  `Umidita` int(50) NOT NULL,
  `LivelloIdratazione` char(50) NOT NULL,

  PRIMARY KEY (`Codice`),
  
  CONSTRAINT Vincolo32
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,

  CONSTRAINT Vincolo33
  FOREIGN KEY (CodiceRipiano) REFERENCES Ripiani(CodiceRipiano)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Contenitore"
BEGIN;
INSERT INTO `Contenitore` VALUES ('001', '001', 'No', 'Terra Grassa', '30', 'No', '001', 'No', '50', 'Medio'),
								 ('002', '002', 'No', 'Terra Grassa', '35', 'No', '001', 'No', '50', 'Medio'),
                                 ('003', '003', 'No', 'Terriccio Sabbioso Argilloso', '30', 'No', '001', 'No', '50', 'Medio'),
                                 ('004', '004', 'No', 'Terra Grassa', '35', 'No', '001', 'No', '50', 'Medio'),
                                 ('005', '005', 'No', 'Terriccio Argilloso', '20', 'No', '001', 'No', '50', 'Medio'),
                                 ('006', '006', 'No', 'Terra Grassa', '40', 'No', '001', 'No', '50', 'Medio'),
                                 ('007', '007', 'No', 'Terriccio Argilloso', '5', 'No', '002', 'No', '50', 'Medio'),
                                 ('008', '008', 'No', 'Terriccio Limoso', '8', 'No', '002', 'No', '50', 'Medio'),
                                 ('009', '009', 'No', 'Terriccio Argilloso', '8', 'No', '002', 'No', '50', 'Medio'),
                                 ('010', '010', 'No', 'Terra Grassa', '5', 'No', '002', 'No', '50', 'Medio'),
                                 ('011', '011', 'No', 'Terra Grassa', '5', 'No', '002', 'No', '50', 'Medio'),
                                 ('012', '012', 'No', 'Terra Grassa', '5', 'No', '003', 'No', '50', 'Medio'),
                                 ('013', '013', 'No', 'Terriccio Argilloso', '15', 'No', '003', 'No', '50', 'Medio'),
                                 ('014', '014', 'No', 'Terra Grassa', '20', 'No', '003', 'No', '50', 'Medio'),
                                 ('015', '015', 'No', 'Terra Grassa', '30', 'No', '003', 'No', '50', 'Medio'),
                                 ('016', '000', 'No', 'TerraGrassa', '25', 'No', '014', 'No', '50', 'Medio');
COMMIT;

-- Creo la tabella "DatoTerreno"
DROP TABLE IF EXISTS `DatoTerreno`;
CREATE TABLE `DatoTerreno` (
  `Codice` int(50) NOT NULL, -- Codice del contenitore
  `ConcentrazioneElemento` int(50) NOT NULL, -- In quanta concentrazione sta venendo rilevato da un sensore un determinato elemento in un determinato contenitore
  `Elemento` char(50) NOT NULL, -- Elemento rilevato attualmente da un sensore in un determinato contenitore
  PRIMARY KEY (`Codice`, `ConcentrazioneElemento`, `Elemento`),
  
  CONSTRAINT Vincolo34
  FOREIGN KEY (Codice) REFERENCES Contenitore(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,

  CONSTRAINT Vincolo35
  FOREIGN KEY (Elemento) REFERENCES ElementiDisciolti(Elemento)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "DatoTerreno"
BEGIN;
INSERT INTO `DatoTerreno` VALUES ('001', '20', 'Fosforo'),
								 ('002', '21', 'Fosforo'),
								 ('003', '13', 'Rame'),
								 ('004', '10', 'Fosforo'),
								 ('005', '15', 'Fosforo'),
								 ('006', '10', 'Fosforo'),
								 ('007', '6', 'Fosforo'),
								 ('008', '10', 'Potassio'),
								 ('009', '10', 'Fosforo'),
								 ('010', '14', 'Fosforo'),
								 ('011', '7', 'Fosforo'),
								 ('012', '10', 'Fosforo'),
								 ('013', '5', 'Fosforo'),
								 ('014', '10', 'Fosforo'),
								 ('015', '9', 'Fosforo');
COMMIT;

-- Creo la tabella "LogContenitore"
DROP TABLE IF EXISTS `LogContenitore`;
CREATE TABLE `LogContenitore` (
  `DataLogContenitore` timestamp NOT NULL,
  `Codice` int(50),
  `LivelloIdratazione` char(50) NOT NULL,
  `Umidita` int(50) NOT NULL,
  `Esalazioni` char(50) NOT NULL,
  PRIMARY KEY (`DataLogContenitore`, `Codice`),

  CONSTRAINT Vincolo36
  FOREIGN KEY (Codice) REFERENCES Contenitore(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "LogContenitore"
BEGIN;
INSERT INTO `LogContenitore` VALUES ('2016-01-01 23:55:00', '001', 'Basso', '30', 'No'),
									('2016-01-02 23:55:00', '002', 'Medio', '50', 'Si'),
									('2016-01-03 23:55:00', '003', 'Alto', '50', 'No'),
									('2016-01-04 23:55:00', '004', 'Medio', '50', 'No'),
									('2016-01-05 23:55:00', '005', 'Basso', '30', 'No'),
									('2016-01-06 23:55:00', '006', 'Medio', '50', 'No'),
									('2016-01-07 23:55:00', '007', 'Alto', '50', 'No'),
									('2016-01-08 23:55:00', '008', 'Medio', '50', 'Si'),
									('2016-01-09 23:55:00', '009', 'Basso', '30', 'No'),
									('2016-01-10 23:55:00', '010', 'Medio', '50', 'Si');
COMMIT;

-- Creo la tabella "Ripiani"
DROP TABLE IF EXISTS `Ripiani`;
CREATE TABLE `Ripiani` (
  `CodiceRipiano` INT NOT NULL AUTO_INCREMENT,
  `CodiceSezione` int(50) NOT NULL,
  `Irrigazione` int(50) NOT NULL, -- Litri all'ora su tutto il ripiano
  PRIMARY KEY (`CodiceRipiano`),

  CONSTRAINT Vincolo37
  FOREIGN KEY (CodiceSezione) REFERENCES Sezione(CodiceSezione)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Ripiani"
BEGIN;
INSERT INTO `Ripiani` VALUES ('001','001','20'), 
							 ('002','001','10'), 
							 ('003','001','30'), 
                             ('004','002','10'), 
                             ('005','002','15'), 
							 ('006','002','10'), 
							 ('007','003','25'),
                             ('008','003','35'), 
                             ('009','004','10'),  
							 ('010','004','15'), 
							 ('011','004','5'), 
                             ('012','004','10'), 
                             ('013','004','20'),
                             ('014','008','20');
COMMIT;

-- Creo la tabella "LogRipiano"
DROP TABLE IF EXISTS `LogRipiano`;
CREATE TABLE `LogRipiano` (
  `CodiceRipiano` INT NOT NULL,
  `DataLogRipiano` timestamp NOT NULL,
  `Irrigazione` int NOT NULL,
  PRIMARY KEY (`CodiceRipiano`,`DataLogRipiano`),

  CONSTRAINT Vincolo38
  FOREIGN KEY (CodiceRipiano) REFERENCES Ripiani(CodiceRipiano)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "LogRipiano"
BEGIN;
INSERT INTO `LogRipiano` VALUES ('001','2016-01-01 23:55:00','20'),
								('002','2016-01-01 23:55:00','25'),
								('003','2016-01-01 23:55:00','15'),
								('004','2016-01-01 23:55:00','20'),
								('005','2016-01-01 23:55:00','30'),
								('006','2016-01-01 23:55:00','25'),
								('007','2016-01-01 23:55:00','35'),
								('008','2016-01-01 23:55:00','40'),
								('009','2016-01-01 23:55:00','15'),
								('010','2016-01-01 23:55:00','15');
COMMIT;

-- Creo la tabella "LogDatoTerreno"
DROP TABLE IF EXISTS `LogDatoTerreno`;
CREATE TABLE `LogDatoTerreno` (
  `Codice` int(50) NOT NULL,
  `ConcentrazioneElemento` int(50) NOT NULL,
  `Elemento` char(50) NOT NULL,
  `DataLog` timestamp NOT NULL,
  PRIMARY KEY (`Elemento`,`DataLog`,`ConcentrazioneElemento`,`Codice`),

  CONSTRAINT Vincolo39
  FOREIGN KEY (Elemento) REFERENCES ElementiDisciolti(Elemento)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,

  CONSTRAINT Vincolo40
  FOREIGN KEY (Codice) REFERENCES Contenitore(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "LogDatoTerreno"
BEGIN;
INSERT INTO `LogDatoTerreno` VALUES ('001', '20', 'Fosforo', '2016-01-01 23:55:00'),
									('002', '20', 'Fosforo', '2016-01-01 23:55:00'),
									('003', '13', 'Rame', '2016-01-01 23:55:00'),
									('004', '10', 'Fosforo', '2016-01-01 23:55:00'),
									('005', '15', 'Fosforo', '2016-01-01 23:55:00'),
									('006', '10', 'Fosforo', '2016-01-01 23:55:00'),
									('007', '6', 'Fosforo', '2016-01-01 23:55:00'),
									('008', '10', 'Potassio', '2016-01-01 23:55:00'),
									('009', '10', 'Fosforo', '2016-01-01 23:55:00'),
									('011', '14', 'Fosforo', '2016-01-01 23:55:00'),
									('011', '7', 'Fosforo', '2016-01-01 23:55:00'),
									('012', '10', 'Fosforo', '2016-01-01 23:55:00'),
									('013', '5', 'Fosforo', '2016-01-01 23:55:00'),
									('014', '10', 'Fosforo', '2016-01-01 23:55:00'),
									('015', '9', 'Fosforo', '2016-01-01 23:55:00');
COMMIT;

-- Creo la tabella "Sezione"
DROP TABLE IF EXISTS `Sezione`;
CREATE TABLE `Sezione` (
  `CodiceSezione` INT NOT NULL AUTO_INCREMENT,
  `Nome` char(50) NOT NULL,
  `Riempimento` int(50) NOT NULL,
  `Capienza` int(50) NOT NULL,
  `CodiceSerra` int(50) NOT NULL,
  `Umidita` int(50) NOT NULL,
  `Temperatura` int(50) NOT NULL,
  PRIMARY KEY (`CodiceSezione`),

  CONSTRAINT Vincolo41
  FOREIGN KEY (CodiceSerra) REFERENCES Serra(CodiceSerra)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION  

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Sezione"
BEGIN;
INSERT INTO `Sezione` VALUES ('001', 'A', '3', '5000', '001', '50', '24'), 
							 ('002', 'B', '3', '5000', '001', '55', '25'), 
                             ('003', 'A', '2', '6000', '002', '70', '22'),  
                             ('004',  'A', '5', '3000', '002', '70', '23'),
                             ('005',  'A', '0', '10000', '003', '60', '24'),
                             ('006', 'A', '0', '3000', '004', '50', '21'),
                             ('007', 'B', '0', '1000', '004', '55', '22'),
                             ('008', 'C', '0', '1000', '004', '60', '20'),
                             ('009', 'A', '0', '10000', '005', '65', '19'),
                             ('010', 'A', '0', '10000', '006', '66', '24');
COMMIT;

-- Creo la tabella "LogSezione"
DROP TABLE IF EXISTS `LogSezione`;
CREATE TABLE `LogSezione` (
  `CodiceSezione` INT NOT NULL,
  `DataLogSezione` TIMESTAMP NOT NULL,
  `Umidita` int NOT NULL,
  `Temperatura` int NOT NULL,
  `Illuminazione` char(50) NOT NULL,
  PRIMARY KEY (`CodiceSezione`,`DataLogSezione`),
  
  
  CONSTRAINT Vincolo42
  FOREIGN KEY (CodiceSezione) REFERENCES Sezione(CodiceSezione)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "LogSezione"
INSERT INTO `LogSezione` VALUES  ('001', '2016-01-01 23:55:00', '55', '22', 'Media'), 
								 ('002', '2016-01-01 23:55:00', '60', '22', 'Alta'), 
								 ('003', '2016-01-01 23:55:00', '65', '22', 'Media'), 
								 ('004', '2016-01-01 23:55:00', '70', '22', 'Alta'),
								 ('005', '2016-01-01 23:55:00', '75', '22', 'Media'), 
								 ('006', '2016-01-01 23:55:00', '80', '22', 'Alta'),
								 ('007', '2016-01-01 23:55:00', '75', '22', 'Media'), 
								 ('008', '2016-01-01 23:55:00', '70', '22', 'Alta'),
								 ('009', '2016-01-01 23:55:00', '65', '22', 'Media'), 
								 ('010', '2016-01-01 23:55:00', '60', '22', 'Alta');
COMMIT;

-- Creo la tabella "Serra"
DROP TABLE IF EXISTS `Serra`;
CREATE TABLE `Serra` (
  `CodiceSerra` INT NOT NULL AUTO_INCREMENT,
  `Nome` char(50) NOT NULL,
  `Indirizzo` char(50) NOT NULL,
  `Lunghezza` int(50) NOT NULL, -- Metri
  `Larghezza` int(50) NOT NULL,
  `Altezza` int(50) NOT NULL,
  `PiantePresenti` int(50) NOT NULL,
  `PianteOspitabili` int(50) NOT NULL, -- 25cm diametro per vaso medio
  `CodiceSede` int(50) NOT NULL,
  PRIMARY KEY (`CodiceSerra`),
  
  CONSTRAINT Vincolo43
  FOREIGN KEY (CodiceSede) REFERENCES Sede(CodiceSede)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Serra"
BEGIN;
INSERT INTO `Serra` VALUES ('001', 'Campoverde', 'Via Nicola 2', '10', '90', '6', '6', '10000', '001'), 
						   ('002', 'Camporosso', 'Via Marchi 5', '10', '80', '6', '7', '9000', '001'), 
                           ('003', 'Campogiallo', 'Via Roma 10', '20', '80', '6', '0', '10000', '002'),
                           ('004', 'Campovecchio', 'Via Garibaldi 3', '5', '45', '3', '0', '5000', '003'),
                           ('005', 'Camponuovo', 'Via Monte 4', '10', '90', '6', '0', '10000', '003'),
                           ('006', 'Camponolo', 'Via Alta 7', '10', '90', '6', '0', '10000', '004'), 
                           ('007', 'Campoalto', 'Via Bassa 2', '10', '90', '6', '0', '10000', '005'),
                           ('008', 'Campobello', 'Via Media 7', '10', '90', '6', '0', '10000', '004'), 
                           ('009', 'Camposotto', 'Via Sopra 8', '10', '90', '6', '0', '10000', '004'), 
						   ('010', 'Camposopra', 'Via Sotto 9', '10', '90', '6', '0', '10000', '006'); 
COMMIT;

-- Creo la tabella "Sede"

DROP TABLE IF EXISTS `Sede`;
CREATE TABLE `Sede` (
  `CodiceSede` INT NOT NULL AUTO_INCREMENT,
  `Nome` char(50) NOT NULL,
  `Indirizzo` char(50) NOT NULL,
  `NumeroDipendenti` int(50) NOT NULL,
  PRIMARY KEY (`CodiceSede`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Sede"
BEGIN;
INSERT INTO `Sede` VALUES ('001', 'Sede Rossi', 'Via Cosmopolitana 1', '5'), 
						  ('002', 'Sede Verdi', 'Via Roma 2', '10'),
                          ('003', 'Sede Gialli', 'Via Noverta 5', '7'), 
                          ('004', 'Sede Turchesi', 'Via Passabasso 6', '20'), 
                          ('005', 'Sede Neri', 'Via Campi 7', '30'), 
                          ('006', 'Sede Bianchi', 'Via Bella 8', '10'), 
                          ('007', 'Sede Rosi', 'Via Alvaro 9', '5'), 
                          ('008', 'Sede Gialli', 'Via Caspi 10', '10'), 
                          ('009', 'Sede Arancioni', 'Via Nelli 11', '15'), 
                          ('010', 'Sede Celesti', 'Via Morale 12', '16');
COMMIT;

-- Creo la tabella "TrattamentoEffettuato"
DROP TABLE IF EXISTS `TrattamentoEffettuato`;
CREATE TABLE `TrattamentoEffettuato` (
  `Codice` INT NOT NULL AUTO_INCREMENT,
  `CodicePianta` int(50) NOT NULL,
  `DataTrattamento` date NOT NULL,
  `Patologia` char(50) NOT NULL,
  `Prodotto` char(50) NOT NULL,
  `Dose` int(50) NOT NULL,
  PRIMARY KEY (`Codice`),
  
  CONSTRAINT Vincolo44
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo45
  FOREIGN KEY (Patologia) REFERENCES Patologia(NomePatologia)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo46
  FOREIGN KEY (Prodotto) REFERENCES ProdottoCura(Nome)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "TrattamentoEffettuato"
BEGIN;
INSERT INTO `TrattamentoEffettuato` (CodicePianta, DataTrattamento, Patologia, Prodotto, Dose) VALUES 
										   ('001', '2016-06-02', 'Peronospora', 'Ampelosan Combi', '10'),
										   ('002', '2016-05-23', 'Peronospora', 'Ampelosan Combi', '18'),
										   ('003', '2016-07-15', 'Muffa grigia', 'Cuprofolpet Bleu', '19'),
										   ('004', '2016-01-01', 'Muffa grigia', 'Cuprofolpet Bleu', '18'),
										   ('005', '2016-04-08', 'Peronospora', 'Ampelosan Combi', '17'),
										   ('006', '2015-06-10', 'Peronospora', 'Ampelosan Combi', '19'),
										   ('007', '2015-02-07', 'Peronospora', 'Ampelosan Combi', '17'),
										   ('008', '2014-04-15', 'Oidio', 'Afugan', '18'),
										   ('009', '2014-11-03', 'Oidio', 'Agrifen11FC', '18'),
										   ('010', '2013-01-10', 'Oidio', 'Afugan', '19');
COMMIT;

-- Creo la tabella "PotaturaEffettuata"
DROP TABLE IF EXISTS `PotaturaEffettuata`;
CREATE TABLE `PotaturaEffettuata` (
  `DataPotatura` date NOT NULL, 
  `Intervento` char(50) NOT NULL,
  `CodicePianta` int(50) NOT NULL,
  `Costo` int(50) NOT NULL,
  PRIMARY KEY (`DataPotatura`,`Intervento`,`CodicePianta`),

  CONSTRAINT Vincolo47
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo48
  FOREIGN KEY (Intervento) REFERENCES Potatura(TipoIntervento)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "PotaturaEffettuata"
BEGIN;
INSERT INTO `PotaturaEffettuata` VALUES ('2016-01-01', 'Contenimento Dimensioni', '006', '70'),
										('2016-02-02', 'Contenimento Dimensioni', '001', '60'),
										('2016-01-03', 'Contenimento Dimensioni', '004', '10'),
										('2016-01-04', 'Rimozione Parti Morte', '003', '20'),
										('2016-01-05', 'Aumento Produzione', '007', '40'),
										('2016-05-05', 'Aumento Produzione', '009', '70'),
										('2016-06-06', 'Rimozione Parti Morte', '005', '100'),
										('2016-07-07', 'Aumento Produzione', '008', '90'),
										('2016-08-08', 'Aumento Produzione', '014', '45'),
										('2016-09-10', 'Aumento Produzione', '011', '30');
COMMIT;

-- Creo la tabella "ConcimazioneEffettuata"
DROP TABLE IF EXISTS `ConcimazioneEffettuata`;
CREATE TABLE `ConcimazioneEffettuata` (
  `DataConcimazione` char(50) NOT NULL,
  `Codice` INT NOT NULL,
  `CodicePianta` int(50) NOT NULL,
  `Costo` int(50) NOT NULL,
  PRIMARY KEY (`DataConcimazione`,`Codice`,`CodicePianta`),

  CONSTRAINT Vincolo49
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo50
  FOREIGN KEY (Codice) REFERENCES InterventiConcimazione(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "ConcimazioneEffettuata"
BEGIN;
INSERT INTO `ConcimazioneEffettuata` VALUES ('2016-01-01', '002', '001', '50'),
											('2016-02-01', '003', '004', '60'),
											('2016-03-01', '004', '003', '30'),
											('2016-04-01', '006', '001', '25'),
											('2016-05-01', '007', '008', '15'),
											('2016-06-01', '008', '002', '20'),
											('2016-07-01', '009', '010', '30'),
											('2016-08-01', '010', '006', '70'),
											('2016-09-01', '012', '005', '50'),
											('2016-06-03', '008', '002', '20');
COMMIT;

-- Creo la tabella "RinvasoEffettuato"
DROP TABLE IF EXISTS `RinvasoEffettuato`;
CREATE TABLE `RinvasoEffettuato` (
  `CodicePianta` int(50) NOT NULL,
  `DataRinvaso` date NOT NULL, -- 
  `Costo` int(50) NOT NULL,
  PRIMARY KEY (`CodicePianta`,`DataRinvaso`),
  
  CONSTRAINT Vincolo51
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "RinvasoEffettuato"
BEGIN;
INSERT INTO `RinvasoEffettuato` VALUES ('001', '2016-01-01', '10'),
									   ('002', '2015-03-02', '15'),
									   ('003', '2016-01-03', '7'),
									   ('004', '2016-06-04', '20'),
									   ('005', '2016-01-05', '8'),
									   ('006', '2013-04-06', '7'),
									   ('007', '2016-01-07', '10'),
									   ('008', '2016-11-08', '10'),
									   ('009', '2014-01-09', '15'),
									   ('010', '2016-02-10', '25');
COMMIT;

-- Creo la tabella "Utente"
DROP TABLE IF EXISTS `Utente`;
CREATE TABLE `Utente` (
  `NickName` char(50) NOT NULL,
  `IndirizzoEmail` char(50) NOT NULL,
  `Nome` char(50) NOT NULL,
  `Cognome` char(50) NOT NULL,
  `PasswordUtente` char(50) NOT NULL,
  `DomandaSegreta` char(250) NOT NULL,
  `RispostaDomanda` char(50) NOT NULL,
  `GiudizioComplessivo` int(50) NOT NULL,
  `CittaResidenza` char(50) NOT NULL,
  `NumeroPostPubblicati` int(50) NOT NULL,
  PRIMARY KEY (`NickName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Utente"
BEGIN;
INSERT INTO `Utente` VALUES ('Rossima', 'rossi.mario@gmail.com', 'Rossi', 'Mario', 'rossimario12', 'Ospedale dove sei nato?', 'Cisanello', '0', 'Pisa', '1'), 
							('Verdilu', 'verdi.luigi@gmail.com', 'Verdi', 'Luigi', 'verdiluigi01', 'Migliore amico di infanzia?', 'Ugo', '0', 'Pisa', '2'),
                            ('Fralli', 'gialli.franco@gmail.com', 'Gialli', 'Franco', 'giallifranco12', 'Nome del tuo primo gatto?', 'Arnaldo', '0', 'Pisa', '1'),
                            ('Turviola', 'turchesi.viola@gmail.com', 'Turchesi', 'Viola', 'turchesiviola45', 'Sport preferito da bambino?', 'Skydiving', '0', 'Pisa', '1'), 
                            ('Narta', 'neri.marta@gmail.com', 'Neri', 'Marta', 'nerimarta62', 'Personaggio famoso preferito?', 'Cicerone', '0', 'Milano', '1'),
                            ('Bada', 'bianchi.ada@gmail.com', 'Bianchi', 'Ada', 'bianchiada78', 'Filosofo preferito?', 'Hegel', '0', 'Milano', '1'), 
                            ('Alosi', 'rosi.alvaro@gmail.com', 'Rosi', 'Alvaro', 'rossialvaro32', 'Videogioco preferito?', 'Minecraft', '0', 'Roma', '1'),
                            ('Maalli', 'gialli.margherita@gmail.com', 'Gialli', 'Margherita', 'giallimargherita32', 'Hobby preferito?', 'Droni', '0', 'Roma', '3'), 
                            ('Arugo', 'arancioni.ugo@gmail.com', 'Arancioni', 'Ugo', 'arancioniugo85', 'Squadra preferita?', 'Juventus', '0', 'Firenze', '0'), 
                            ('Celelia', 'celesti.clelia@gmail.com', 'Celesti', 'Clelia', 'celesticlelia76', 'Nome della vicina di casa?', 'Rita', '0', 'Firenze', '0');  
COMMIT;

-- Creo la tabella "Preferenze"
DROP TABLE IF EXISTS `Preferenze`;
CREATE TABLE `Preferenze` (
  `NickName` char(50) NOT NULL,
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  PRIMARY KEY (`NickName`,`Nome`,`Cultivar`),

  CONSTRAINT Vincolo52
  FOREIGN KEY (Nickname) REFERENCES Utente(Nickname)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,

  CONSTRAINT Vincolo53
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION

) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Preferenze"
BEGIN;
INSERT INTO `Preferenze` VALUES ('Rossima', 'Cipresso Sempreverde', 'Nessuno'),
								('Verdilu', 'Lavanda Officinale', 'Nessuno'),
								('Verdilu', 'Frassino da Manna', 'Nessuno'),
								('Fralli', 'Rosa', 'Alba'),
								('Turviola', 'Rosa', 'Moscata'), 
								('Narta', 'Giglio', 'Nessuno'),
								('Bada', 'Betulla Bianca', 'Nessuno'), 
								('Alosi', 'Abete Bianco', 'Nessuno'),
								('Maalli', 'Pioppo Bianco', 'Nessuno'),
								('Maalli', 'Biancospino Comune', 'Nessuno'), 
								('Maalli', 'Lavanda Officinale', 'Nessuno'), 
								('Arugo', 'Abete Bianco', 'Nessuno'), 
								('Celelia', 'Rosa', 'Moscata');  
COMMIT;

-- Creo la tabella "Ordine"
DROP TABLE IF EXISTS `Ordine`;
CREATE TABLE `Ordine` (
  `CodiceOrdine` INT NOT NULL AUTO_INCREMENT,
  `CodicePianta` int(50) NOT NULL,
  `CodiceCliente` char(50) NOT NULL,
  `DataOrdine` date NOT NULL,
  `StatoOrdine` char(50) NOT NULL,
  PRIMARY KEY (`CodiceOrdine`),
  
  CONSTRAINT Vincolo54
  FOREIGN KEY (CodiceCliente) REFERENCES Utente(Nickname)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo55
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Ordine"
BEGIN;
INSERT INTO `Ordine` (CodicePianta, CodiceCliente, DataOrdine, StatoOrdine) VALUES
							('001', 'Turviola', '2014-05-12', 'Evaso'), 
							('004', 'Naarta', '2015-03-14', 'Evaso'), 
							('010', 'Bada', '2016-08-16', 'Evaso'), 
                            ('005', 'Rossima', '2016-03-12', 'Evaso'), 
							('002', 'Verdilu', '2015-06-11', 'In preparazione'), 
							('003', 'Verdilu', '2013-01-01', 'Evaso'), 
							('009', 'Fralli', '2016-06-02', 'Evaso'), 
							('012', 'Fralli', '2016-05-07', 'Evaso'), 
							('008', 'Turviola', '2014-05-12', 'Spedito'), 
							('011', 'Naarta', '2015-03-14', 'Spedito'), 
							('006', 'Bada', '2016-08-16', 'Evaso'), 
							('007', 'Alosi', '2016-07-07', 'Evaso'), 
							('013', 'Alosi', '2013-02-02', 'Evaso');
COMMIT;

-- Creo la tabella "OrdiniPendenti"
DROP TABLE IF EXISTS `OrdiniPendenti`;
CREATE TABLE `OrdiniPendenti` (
  `CodiceOrdine` INT NOT NULL AUTO_INCREMENT,
  `Nickname` char(50) NOT NULL,
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  `DataOrdine` date NOT NULL,
  PRIMARY KEY (`CodiceOrdine`),
  
  CONSTRAINT Vincolo56
  FOREIGN KEY (Nickname) REFERENCES Utente(Nickname)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo57
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "OrdiniPendenti"
BEGIN;
INSERT INTO `OrdiniPendenti` (Nickname, Nome, Cultivar, DataOrdine) VALUES
							('Rossima', 'Giglio', 'Nessuno', '2016-06-02'), 
							('Rossima', 'Giglio', 'Nessuno', '2016-04-07'), 
							('Fralli', 'Giglio', 'Nessuno', '2016-07-12'),
							('Fralli', 'Giglio', 'Nessuno', '2016-07-12'),
							('Fralli', 'Giglio', 'Nessuno', '2016-07-12'),
							('Fralli', 'Giglio', 'Nessuno', '2016-07-12'),
							('Fralli', 'Giglio', 'Nessuno', '2016-07-12'),
							('Fralli', 'Giglio', 'Nessuno', '2016-07-12'),
							('Fralli', 'Giglio', 'Nessuno', '2016-07-12'),
							('Fralli', 'Giglio', 'Nessuno', '2016-07-12');
COMMIT;

-- Creo la tabella "Post"
DROP TABLE IF EXISTS `Post`;
CREATE TABLE `Post` (
  `NickName` char(50) NOT NULL,
  `TimestampPost` timestamp NOT NULL,
  `Testo` text NOT NULL,
  `Thread` char(50) NOT NULL,
  PRIMARY KEY (`Nickname`,`TimestampPost`),
  
  CONSTRAINT Vincolo58
  FOREIGN KEY (Nickname) REFERENCES Utente(Nickname)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Post"
BEGIN;
INSERT INTO `Post` VALUES ('Rossima', '2015-02-01 23:00:01', 'Ciao mondo!', 'Presentazione'),
						  ('Verdilu', '2016-05-12 13:01:01', 'Hello world!', 'Presentazione'),
						  ('Verdilu', '2015-04-16 12:30:11', 'Ciao mondo!', 'Presentazione'),
						  ('Fralli', '2013-09-13 15:10:01', 'Hello world!', 'Presentazione'),
						  ('Turviola', '2016-7-02 12:50:11', 'Ciao mondo!', 'Presentazione'),
						  ('Narta', '2015-09-13 16:10:01', 'Hello world!', 'Presentazione'),
						  ('Bada', '2015-7-04 16:51:09', 'Ciao mondo!', 'Presentazione'),
						  ('Alosi', '2016-08-18 17:10:08', 'Hello world!', 'Presentazione'),
						  ('Maalli', '2014-6-05 17:20:00', 'Ciao mondo!', 'Presentazione'),
						  ('Maalli', '2016-08-18 14:30:08', 'Hello world!', 'Presentazione'),
						  ('Maalli', '2016-6-05 12:20:00', 'Ciao mondo!', 'Presentazione');
COMMIT;

-- Creo la tabella "PostRisposta"
DROP TABLE IF EXISTS `PostRisposta`;
CREATE TABLE `PostRisposta` (
  `Username` char(50) NOT NULL,
  `TimestampRisposta` timestamp NOT NULL,
  `TimestampPost` timestamp NOT NULL,
  `Nickname` char(50) NOT NULL,
  `Giudizio` int(50) NOT NULL,
  `NumeroGiudizi` int(50) NOT NULL,
  `Testo` text NOT NULL,
  PRIMARY KEY (`Username`,`TimestampRisposta`),
  
  CONSTRAINT Vincolo59
  FOREIGN KEY (Username) REFERENCES Utente(Nickname)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo60
  FOREIGN KEY (Nickname, TimestampPost) REFERENCES Post(Nickname, TimestampPost)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "PostRisposta"
BEGIN;
INSERT INTO `PostRisposta`VALUES ('Rossima', '2016-06-06 23:00:01', '2016-06-05 12:20:00', 'Maalli', '0', '0', 'Ciao!'),
								 ('Bada', '2016-7-04 16:51:09', '2016-06-05 12:20:00', 'Maalli', '0', '0','Hello!'),
								 ('Arugo', '2015-7-04 17:51:09', '2015-7-04 16:51:09', 'Bada', '0', '0','Ciao!'),
								 ('Fralli', '2016-6-05 12:20:00', '2015-7-04 16:51:09', 'Bada', '0', '0','Hello!'),
								 ('Turviola', '2016-09-13 16:10:01', '2015-7-04 16:51:09', 'Bada', '0', '0','Ciao!'),
								 ('Celelia', '2016-08-12 13:01:01', '2016-06-05 12:20:00', 'Maalli', '0', '0','Hello!'),
								 ('Bada', '2016-6-05 17:20:00', '2015-09-13 16:10:01', 'Narta', '0', '0','Ciao!'),
								 ('Alosi', '2016-08-18 14:30:08', '2015-09-13 16:10:01', 'Narta', '0', '0','Hello!'),
								 ('Maalli', '2016-09-13 15:10:01', '2015-09-13 16:10:01', 'Narta', '0', '0','Ciao!'),
								 ('Celelia', '2015-10-05 12:20:00', '2015-09-13 16:10:01', 'Narta', '0', '0','Hello!'),
								 ('Maalli', '2015-11-01 23:00:01', '2015-09-13 16:10:01', 'Narta', '0', '0','Ciao!');
COMMIT;

-- Creo la tabella "LinkMultimedialiPost"
DROP TABLE IF EXISTS `LinkMultimedialiPost`;
CREATE TABLE `LinkMultimedialiPost` (
	`Nickname` char(50),
    `TimestampPost` timestamp not null,
	`Link` char(250),
    PRIMARY KEY (`Nickname`,`TimestampPost`,`Link`),
    
    CONSTRAINT Vincolo61
	FOREIGN KEY (Nickname, TimestampPost) REFERENCES Post(Nickname, TimestampPost)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
  
)	ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "LinkMultimedialiPost"
BEGIN;
INSERT INTO `LinkMultimedialiPost` VALUES ('Rossima', '2016-06-06 23:00:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
									('Maalli', '2015-11-01 23:00:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Maalli', '2015-11-01 23:36:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Bada', '2016-6-05 17:20:00', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Arugo', '2015-7-04 17:51:09', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Arugo', '2015-7-04 17:51:54', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Fralli', '2016-6-05 12:20:00', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Celelia', '2016-08-12 13:01:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Celelia', '2016-08-12 14:01:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Bada', '2016-7-04 16:51:09','http://i.imgur.com/6yHmlwT.jpg');
COMMIT;

-- Creo la tabella "LinkMultimedialiRisposta"
DROP TABLE IF EXISTS `LinkMultimedialiRisposta`;
CREATE TABLE `LinkMultimedialiRisposta` (
	`Username` char(50),
    `TimestampRisposta` timestamp,
	`Link` char(50),
    PRIMARY KEY (`Username`,`TimestampRisposta`,`Link`),
    
	CONSTRAINT Vincolo62
	FOREIGN KEY (Username, TimestampRisposta) REFERENCES PostRisposta(Username, TimestampRisposta)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
    
)	ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "LinkMultimedialiRisposta"
BEGIN;
INSERT INTO `LinkMultimedialiRisposta` VALUES ('Rossima', '2016-06-06 23:00:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
									('Maalli', '2015-11-01 23:10:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Maalli', '2015-11-01 23:00:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Bada', '2016-6-05 17:20:00', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Arugo', '2015-7-04 17:51:49', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Arugo', '2015-7-04 17:51:09', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Fralli', '2016-6-05 12:20:00', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Celelia', '2016-08-12 14:01:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Celelia', '2016-08-12 13:01:01', 'http://i.imgur.com/6yHmlwT.jpg'), 
                                    ('Bada', '2016-7-04 16:51:09','http://i.imgur.com/6yHmlwT.jpg');
COMMIT;

-- Creo la tabella "Giardino"
DROP TABLE IF EXISTS `Giardino`;
CREATE TABLE `Giardino` (
  `IDGiardino` INT NOT NULL AUTO_INCREMENT,
  `Nickname` char(50) NOT NULL,
  PRIMARY KEY (`IDGiardino`),
  
  CONSTRAINT Vincolo63
  FOREIGN KEY (Nickname) REFERENCES Utente(Nickname)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Giardino"
BEGIN;
INSERT INTO `Giardino` (NickName) VALUES   
								('Verdilu'), 
								('Verdilu'), 
                                ('Narta'), 
                                ('Turviola'), 
                                ('Celelia'), 
                                ('Celelia'), 
                                ('Arugo'), 
                                ('Narta'), 
                                ('Arugo'), 
                                ('Celelia');
COMMIT;

-- Creo la tabella "Settore"
DROP TABLE IF EXISTS `Settore`;
CREATE TABLE `Settore` (
  `Codice` INT NOT NULL AUTO_INCREMENT,
  `IDGiardino` int(50) NOT NULL,
  `PuntoCardinale` char(50) NOT NULL, -- Nord/Sud/Est/Ovest
  `OreLuce` int(50) NOT NULL,
  `Pavimento` char(50) NOT NULL, -- Si/No
  `Coord1x` char(50) NOT NULL,
  `Coord1y` char(50) NOT NULL,
  `Coord2x` char(50) NOT NULL,
  `Coord2y` char(50) NOT NULL,
  `Coord3x` char(50) NOT NULL,
  `Coord3y` char(50) NOT NULL,
  `Coord4x` char(50) NOT NULL,
  `Coord4y` char(50) NOT NULL,
  `Coord5x` char(50) NOT NULL,
  `Coord5y` char(50) NOT NULL,
  `Coord6x` char(50) NOT NULL,
  `Coord6y` char(50) NOT NULL,
  PRIMARY KEY (`Codice`),
  
  CONSTRAINT Vincolo64
  FOREIGN KEY (IDGiardino) REFERENCES Giardino(IDGiardino)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Settore"
BEGIN;
INSERT INTO `Settore` (IDGiardino, PuntoCardinale, OreLuce, Pavimento, Coord1x, Coord1y, Coord2x, Coord2y, Coord3x, Coord3y, Coord4x, Coord4y, Coord5x, Coord5y, Coord6x, Coord6y) VALUES 
							 ('001', 'Nord', '8', 'No', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'), 
							 ('001', 'Sud', '7', 'No', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13'),
							 ('001', 'Est', '6', 'No', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14'),
							 ('002', 'Ovest', '9', 'No', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'),
							 ('002', 'Est', '5', 'No', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'),
							 ('003', 'Sud', '8', 'No', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'),
							 ('003', 'Nord', '7', 'No', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'),
							 ('003', 'Oves', '9', 'No', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'),
							 ('004', 'Est', '7', 'No', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'),
							 ('004', 'Nord', '6', 'No', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12');
COMMIT;

-- Creo la tabella "PiantePosizionate"
DROP TABLE IF EXISTS `PiantePosizionate`;
CREATE TABLE `PiantePosizionate` (
  `Codice` INT NOT NULL AUTO_INCREMENT,
  `CodiceSettore` int(50) NOT NULL,
  `Nome` char(50) NOT NULL,
  `Cultivar` char(50) NOT NULL,
  `Dimensione` int(50), -- Dimensione vaso
  `Materiale` char(50), -- Materiale vaso
  `DentroVaso` char(50), -- Si/No
  `PosizioneX` char(50) NOT NULL,
  `PosizioneY` char(50) NOT NULL,
  `Raggio` char(50) NOT NULL, -- Raggio pianta in m
  PRIMARY KEY (`Codice`,`CodiceSettore`),
  
  CONSTRAINT Vincolo65
  FOREIGN KEY (CodiceSettore) REFERENCES Settore(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo66
  FOREIGN KEY (Nome, Cultivar) REFERENCES Pianta(Nome, Cultivar)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "PiantePosizionate"
BEGIN;
INSERT INTO `PiantePosizionate` (CodiceSettore, Nome, Cultivar, Dimensione, Materiale, DentroVaso, PosizioneX, PosizioneY, Raggio) VALUES 
									   ('001', 'Abete Bianco', 'Nessuno', '0', 'NULL', 'No', '1', '5', '5'),
									   ('001', 'Bincospino Comune', 'Nessuno', '0', 'NULL', 'No', '2', '4', '2'),
									   ('002', 'Giglio', 'Nessuno', '0', 'NULL', 'No', '2', '8', '0.5'),
									   ('003', 'Pioppo Bianco', 'Nessuno', '0', 'NULL', 'No', '2', '4', '4'),
									   ('004', 'Betulla Bianca', 'Nessuno', '0', 'NULL', 'No', '2', '6', '4'),
									   ('005', 'Rosa', 'Moscata', '0', 'NULL', 'No', '3', '7', '0.3'),
									   ('005', 'Rosa', 'Moscata', '0', 'NULL', 'No', '2', '4', '0.3'),
									   ('005', 'Rosa', 'Moscata', '0', 'NULL', 'No', '2', '6', '0.3'),
									   ('005', 'Rosa', 'Alba', '0', 'NULL', 'No', '1', '3', '0.3'),
									   ('002', 'Rosa', 'Alba', '0', 'NULL', 'No', '5', '7', '0.3');

COMMIT;

-- Creo la tabella "Scheda"
DROP TABLE IF EXISTS `Scheda`;
CREATE TABLE `Scheda` (
  `Codice` INT NOT NULL AUTO_INCREMENT,
  `CodicePianta` int(50) NOT NULL,
  `Nickname` char(50) NOT NULL,
  `ManutenzioneAutomatica` char(50) NOT NULL,
  `DimensioneAllAcquisto` int(50) NOT NULL, -- Circonferenza pianta
  `DimensioniVaso` int(50) NOT NULL, -- Raggio
  `InTerra` char(50),
  `InVaso` char(50),
  PRIMARY KEY (`Codice`),
  
  CONSTRAINT Vincolo67
  FOREIGN KEY (CodicePianta) REFERENCES Piante(CodicePianta)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo68
  FOREIGN KEY (Nickname) REFERENCES Utente(Nickname)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "Scheda"
BEGIN;
INSERT INTO `Scheda` VALUES ('001', '001', 'Turviola', 'No', '20', '0', 'Si', 'No'), 
							('002', '004', 'Naarta', 'No', '15',  '0', 'Si', 'No'), 
                            ('003', '010', 'Bada', 'No', '2',  '20', 'No', 'Si'), 
                            ('004', '005', 'Rossima', 'No', '10', '0', 'Si', 'No'), 
                            ('005', '002', 'Verdilu', 'No', '25', '0', 'Si', 'No'), 
                            ('006', '003', 'Verdilu', 'No', '20', '0', 'Si', 'No'), 
                            ('007', '009', 'Fralli', 'No', '3', '0', 'Si', 'No'), 
                            ('008', '012', 'Fralli', 'No', '2', '20', 'No', 'Si'), 
                            ('009', '008', 'Turviola', 'No', '3', '0', 'Si', 'No'), 
                            ('010', '011', 'Naarta', 'No', '2', '20', 'No', 'Si'), 
                            ('011', '006', 'Bada', 'No', '30', '0', 'Si', 'No'), 
                            ('012', '007', 'Alosi', 'No', '2', '0', 'Si', 'No'), 
                            ('013', '013', 'Alosi', 'No', '10', '0', 'Si', 'No');
COMMIT;	

-- Creo la tabella "ManutenzioneRichiesta"
DROP TABLE IF EXISTS `ManutenzioneRichiesta`;
CREATE TABLE `ManutenzioneRichiesta` (
  `Codice` int(50) NOT NULL,
  `Scadenza` date NOT NULL,
  `TipoManutenzione` char(50) NOT NULL,
  `Nickname` char(50) NOT NULL,
  PRIMARY KEY (`TipoManutenzione`,`Codice`,`Scadenza`),
  
  CONSTRAINT Vincolo69
  FOREIGN KEY (Codice) REFERENCES Scheda(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo70
  FOREIGN KEY (Nickname) REFERENCES Utente(Nickname)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "ManutenzioneRichiesta"
BEGIN;
INSERT INTO `ManutenzioneRichiesta` VALUES ('001', '2016-06-01', 'Concimazione', 'Turviola'),
										   ('002', '2016-06-02', 'Concimazione', 'Naarta'),
										   ('003', '2016-06-05', 'Rinvaso', 'Bada'),
										   ('004', '2016-06-03', 'Rinvaso', 'Rossima'),
										   ('005', '2016-04-01', 'Rinvaso', 'Verdilu'),
										   ('006', '2016-07-01', 'Concimazione', 'Verdilu'),
										   ('007', '2016-08-01', 'Potatura', 'Fralli'),
										   ('008', '2016-06-07', 'Potatura', 'Fralli'),
										   ('009', '2016-07-01', 'Potatura', 'Turviola'),
										   ('010', '2016-06-11', 'Potatura', 'Naarta');
COMMIT;

-- Creo la tabella "ManutenzioneProgrammata"
DROP TABLE IF EXISTS `ManutenzioneProgrammata`;
CREATE TABLE `ManutenzioneProgrammata` (
  `Codice` int(50) NOT NULL,
  `MeseManutenzione` int NOT NULL, -- Mese in cui eseguire la manutenzione questo anno
  `TipoManutenzione` char(50) NOT NULL,
  `Nickname` char(50) NOT NULL,
  PRIMARY KEY (`Codice`,`MeseManutenzione`, `TipoManutenzione`),
  
  CONSTRAINT Vincolo71
  FOREIGN KEY (Codice) REFERENCES Scheda(Codice)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION,
  
  CONSTRAINT Vincolo72
  FOREIGN KEY (Nickname) REFERENCES Utente(Nickname)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Inserisco 10 record dentro "ManutenzioneProgrammata"
BEGIN;
INSERT INTO `ManutenzioneProgrammata` VALUES ('001', '01', 'Potatura', 'Turviola'),
											 ('002', '02', 'Rinvaso', 'Naarta'),
											 ('003', '03', 'Concimazione', 'Bada'),
											 ('004', '04', 'Potatura', 'Rossima'),
											 ('005', '05', 'Potatura', 'Verdilu'),
											 ('006', '06', 'Potatura', 'Verdilu'),
											 ('007', '07', 'Concimazione', 'Fralli'),
											 ('008', '08', 'Concimazione', 'Fralli'),
											 ('009', '09', 'Potatura', 'Turviola'),
											 ('010', '10', 'Concimazione', 'Narta');
COMMIT;