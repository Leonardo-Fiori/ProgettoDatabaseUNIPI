--
-- FUNZIONE 1#
--

DROP PROCEDURE IF EXISTS InserimentoPiantaMagazzino;

DELIMITER $$ 

CREATE PROCEDURE InserimentoPiantaMagazzino(IN _Nome char(50), IN _Cultivar char(50), IN _Dimensione int(50), IN _Prezzo int(50)) 

BEGIN 
	Declare ContenitoreVuoto int default 0;
    Declare PostiDisponibili int default 0;
    Declare _TempMin int default 0;
    Declare _TempMax int default 0;
    Declare _Terreno char(50) default '';
    Declare _CodicePianta int default 0;
    
    Set _TempMin = (Select TemperaturaMinima
					From Pianta P inner join EsigenzePianta E on (P.Nome = E.Nome and P.Cultivar = E.Cultivar)
                    Where P.Nome = _Nome and P.Cultivar = _Cultivar);
    
	Set _TempMax = (Select TemperaturaMassima
					From Pianta P inner join EsigenzePianta E on (P.Nome = E.Nome and P.Cultivar = E.Cultivar)
                    Where P.Nome = _Nome and P.Cultivar = _Cultivar);   
    Set PostiDisponibili = (Select count(*)
						From Contenitore C inner join Ripiani R on (C.CodiceRipiano = R.CodiceRipiano) inner join Sezione S on(R.CodiceSezione = S.CodiceSezione)
                        Where C.CodicePianta = 0 and C.Dimensione between (_Dimensione*1.5 - 5) and (_Dimensione*1.5 + 5) and S.Temperatura between _TempMin and _TempMax);
                        
	If PostiDisponibili = 0 Then
		Signal sqlstate '45000'
		Set Message_text = 'Nessun contenitore disponibile o adatto per le dimensioni della pianta';
	
    Else
		Set _CodicePianta = (Select max(CodicePianta) From Piante);
    
		Set ContenitoreVuoto = (Select min(C.Codice)
						From Contenitore C inner join Ripiani R on (C.CodiceRipiano = R.CodiceRipiano) inner join Sezione S on(R.CodiceSezione = S.CodiceSezione)
                        Where C.CodicePianta = 0 and C.Dimensione between (_Dimensione*1.5 - 5) and (_Dimensione*1.5 + 5) and S.Temperatura between _TempMin and _TempMax);
		Set _Terreno = (Select T.NomeTerreno
						From Pianta P inner join Terriccio T on (P.Nome = T.Nome and P.Cultivar = P.Cultivar)
                        Where P.Nome = _Nome and P.Cultivar = _Cultivar);
 		
        Insert into Piante (Nome, Cultivar, Dimensione, Prezzo, Acquistata)
		values (_Nome, _Cultivar, _Dimensione, _Prezzo, 'No');
    
	    Update Contenitore
		Set  CodicePianta = _CodicePianta, Substrato = _Terreno                                      
	 	Where Codice = ContenitoreVuoto; 
        
        Update Sezione
        Set Capienza = Capienza + 1
        Where CodiceSezione in (Select *
								From (Select S.CodiceSezione
								From Contenitore C inner join Ripiani R on (C.CodiceRipiano = R.CodiceRipiano) inner join Sezione S on(R.CodiceSezione = S.CodiceSezione)
                                Where C.Codice = ContenitoreVuoto) as D);
        
        Update Serra
		Set PiantePresenti = PiantePresenti + 1
        Where CodiceSerra in (Select *
								From (Select Se.CodiceSerra
								From Contenitore C inner join Ripiani R on (C.CodiceRipiano = R.CodiceRipiano) inner join Sezione S on(R.CodiceSezione = S.CodiceSezione) inner join Serra Se on (S.CodiceSerra = Se.CodiceSerra)
                                Where C.Codice = ContenitoreVuoto) as D);
        
    End if;

END $$

DELIMITER ;

-- Call InserimentoPiantaMagazzino('Betulla Bianca', 'Nessuno', 15, 20);

-- 
-- FUNZIONE 2#
-- 

DROP PROCEDURE IF EXISTS NuovoUtente;

DELIMITER $$ 

CREATE PROCEDURE NuovoUtente(IN _IndirizzoEmail char(50),  IN _NickName char(50), IN _Nome char(50), IN _Cognome char(50), IN _Password char(50), IN _DomandaSegreta char(250), IN _RispostaDomanda char(50), IN _CittaResidenza char(50)) 

BEGIN 

	Insert into Utente
    values (_NickName, _IndirizzoEmail, _Nome, _Cognome, _Password, _DomandaSegreta, _RispostaDomanda, 0, _CittaResidenza, 0);
    
END $$

DELIMITER ;

-- 
-- FUNZIONE 3#
-- 

DROP PROCEDURE IF EXISTS AcquistoPianta;

DELIMITER $$ 

CREATE PROCEDURE AcquistoPianta(IN _CodiceCliente char(50), IN _Nome char(50), IN _Cultivar char (50), IN _Dimensione INT (50)) 

BEGIN
	declare _CodicePianta_ INT default 0;
    declare _Disponibili_ INT default 0;
    
	Set _Disponibili_ = ( -- Controllo il numero di piante disponibili
    SELECT count(*)
	FROM Piante P inner join Contenitore C on C.CodicePianta = P.CodicePianta
    WHERE P.Nome = _Nome 
			and P.Cultivar = _Cultivar 
            and P.Dimensione = _Dimensione 
            and P.Acquistata = 'No'
			and C.Infetto = 'No'
    );
    
    IF _Disponibili_ > 0 THEN -- Se è disponibile
		Set _CodicePianta_ = ( 
		SELECT min(P.CodicePianta)
		FROM Piante P inner join Contenitore C on C.CodicePianta = P.CodicePianta
		WHERE P.Nome = _Nome 
				and P.Cultivar = _Cultivar 
				and P.Dimensione = _Dimensione 
				and P.Acquistata = 'No'
				and C.Infetto = 'No'
		);

		INSERT INTO Ordine (CodicePianta, CodiceCliente, DataOrdine, StatoOrdine) -- Creo un ordine
        VALUES (_CodicePianta_, _CodiceCliente, (current_date), 'In processazione');

		UPDATE Piante
		SET Acquistata = 1 
		WHERE CodicePianta = _CodicePianta_;
        
        UPDATE Contenitore
        SET CodicePianta = 0
        WHERE CodicePianta = _CodicePianta_;
	ELSE -- Se la pianta non era disponibile
		INSERT INTO Ordine (CodicePianta, CodiceCliente, DataOrdine, StatoOrdine)
		VALUES (0, _CodiceCliente, (current_date), 'Pendente');

		INSERT INTO OrdiniPendenti (Nickname, Nome, Cultivar, DataOrdine)
		VALUES (_CodiceCliente, _Nome, _Cultivar, (current_date));
	END IF;
    
END $$

DELIMITER ;

-- call AcquistoPianta('Fralli', 'Betulla Bianca', 'Nessuno', '20');

--
-- FUNZIONE 4#
-- 

DROP PROCEDURE IF EXISTS NuovoGiardino;

DELIMITER $$ 

CREATE PROCEDURE NuovoGiardino(IN _NickName char(50)) 

BEGIN 

	Insert into Giardino (NickName)
    values (_NickName);
	

END $$

DELIMITER ;

--
-- FUNZIONE 5#
-- 

DROP PROCEDURE IF EXISTS RicercaPostUtente;

DELIMITER $$ 

CREATE PROCEDURE RicercaPostUtente(IN _NickName char(50)) 

BEGIN 

	Select P.NickName, P.TimestampPost, P.Testo, P.Thread, M.Link
    From Post P inner join LinkMultimedialiPost M on (P.NickName = M.Nickname)
    Where P.NickName = _NickName;
    
END $$

DELIMITER ;


-- 
-- FUNZIONE 6#
--

DROP PROCEDURE IF EXISTS PiantaUsataMaggiormente;

DELIMITER $$ 

CREATE PROCEDURE PiantaUsataMaggiormente(IN _NickName char(50)) 

BEGIN 

	Select P.Nome, P.Cultivar
    
    From Giardino G inner join Settore S on (G.IDGiardino = S.IDGiardino) inner join PiantePosizionate P on (S.Codice = P.CodiceSettore)
    
    Where G.NickName = _NickName
    
    Group by P.Nome, P.Cultivar
    
    Having count(*) = (Select max(P.NumeroPiante)
					   From (Select count(*) as NumeroPiante
							 From Giardino G1 inner join Settore S1 on (G1.IDGiardino = S1.IDGiardino) inner join PiantePosizionate P1 on (S1.Codice = P1.CodiceSettore)
							 Where G1.NickName = _NickName
							 Group by P1.Nome, P1.Cultivar)
                             as P);
	
END $$

DELIMITER ;

-- call PiantaUsataMaggiormente('Verdilu');

--
-- FUNZIONE 7#
-- 

DROP PROCEDURE IF EXISTS RicercaManutenzioniRichieste;

DELIMITER $$ 

CREATE PROCEDURE RicercaManutenzioniRichieste(IN _NickName char(50)) 

BEGIN 

	Select *
    From ManutenzioneRichiesta M
    Where M.NickName = _NickName;
    
END $$

DELIMITER ;

-- call RicercaManutenzioniRichieste('Verdilu');

--
-- FUNZIONE 8#
--

DROP PROCEDURE IF EXISTS RicercaManutenzioniProgrammate;

DELIMITER $$ 

CREATE PROCEDURE RicercaManutenzioniProgrammate(IN _NickName char(50)) 

BEGIN 

	Select *
    From ManutenzioneProgrammata M
    Where M.NickName = _NickName;
    
END $$

DELIMITER ;

-- call RicercaManutenzioniProgrammate('Verdilu');

--
-- FUNZIONE Aggiornamento Valutazione Risposta
-- 

DROP PROCEDURE IF EXISTS AggiornamentoValutazioneRisposta;

DELIMITER $$ 

CREATE PROCEDURE AggiornamentoValutazioneRisposta(IN _Username char(50), IN _TimestampRisposta char(50), IN _Giudizio char(50)) 

BEGIN
	
	IF _Giudizio >= -5 and _Giudizio <= 5 THEN
		UPDATE PostRisposta
		SET NumeroGiudizi = NumeroGiudizi + 1,
			Giudizio = Giudizio + _Giudizio
		WHERE Username = _Username
				AND TimestampRisposta = _TimestampRisposta;
	ELSE
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Giudizio deve essere compreso tra -5 e +5 inclusi!';
    END IF;

END $$

DELIMITER ;

-- 
-- FUNZIONE Indagini Patologia
--

DROP PROCEDURE IF EXISTS Indagini;

DELIMITER $$

CREATE PROCEDURE Indagini(IN _Patologia char(50) )
BEGIN

SELECT LC.Umidita, LC.LivelloIdratazione, LR.Irrigazione, LS.Temperatura

FROM MalattieContratte M 
		inner join 
	 Contenitore C on M.CodicePianta = C.CodicePianta
		inner join
	 LogContenitore LC on C.Codice = LC.Codice
		inner join
	 Ripiani R on R.CodiceRipiano = LC.Codice
		inner join
	 LogRipiano LR on LR.CodiceRipiano = R.CodiceRipiano
		inner join
	 Sezione S on S.CodiceSezione = R.CodiceSezione
		inner join
	 LogSezione LS on LS.CodiceSezione = S.CodiceSezione

WHERE M.Patologia = _Patologia 
		and LC.DataLogContenitore between M.DataContrazione and M.DataContrazione - interval 1 month
        and LR.DataLogRipiano between M.DataContrazione and M.DataContrazione - interval 1 month
        and LS.DataLogSezione between M.DataContrazione and M.DataContrazione - interval 1 month

GROUP BY LC.Umidita, LC.LivelloIdratazione, LR.Irrigazione, LS.Temperatura

HAVING count(*) = (
					SELECT max(P.NumeroRilevazioni)
					FROM (Select count(*) as NumeroRilevazioni
							From MalattieContratte M1
									inner join 
								Contenitore C1 on M1.CodicePianta = C1.CodicePianta
									inner join
								LogContenitore LC1 on C1.Codice = LC1.Codice
									inner join
								Ripiani R1 on R1.CodiceRipiano = LC1.Codice
									inner join
								LogRipiano LR1 on LR1.CodiceRipiano = R1.CodiceRipiano
									inner join
								Sezione S1 on S1.CodiceSezione = R1.CodiceSezione
									inner join
								LogSezione LS1 on LS1.CodiceSezione = S1.CodiceSezione
							WHERE M1.Patologia = _Patologia 
								and LC1.DataLogContenitore between M1.DataContrazione and M1.DataContrazione - interval 1 month
								and LR1.DataLogRipiano between M1.DataContrazione and M1.DataContrazione - interval 1 month
								and LS1.DataLogSezione between M1.DataContrazione and M1.DataContrazione - interval 1 month
							GROUP BY LC1.Umidita, LC1.LivelloIdratazione, LR1.Irrigazione, LS1.Temperatura
						) as P
                        );
END $$

DELIMITER ;

-- Call Indagini('Oidio');

--
-- FUNZIONE Inserimento Manuale Manutenzione
--

-- Inserimento manutenzione fatta a mano da utente

DROP PROCEDURE IF EXISTS InserimentoManualeManutenzione;

DELIMITER $$

CREATE PROCEDURE InserimentoManualeManutenzione ( 
													IN _CodicePianta INT, 
													IN _Data Date, 
													IN _Tipo char(50), 
                                                    IN _TipoPotatura CHAR(50), 
                                                    IN _CodiceConcimazione INT
												)
BEGIN
	IF _Tipo = "Concimazione" THEN
		
		INSERT INTO ConcimazioneEffettuata(DataConcimazione, Codice, CodicePianta, Costo )
		VALUES (_Data, _CodiceConcimazione, _CodicePianta, 0);
    
    ELSEIF _Tipo = "Potatura" THEN
    
		INSERT INTO PotaturaEffettuata(DataPotatura, Intervento, CodicePianta, Costo)
        VALUES (_Data, _TipoPotatura, _CodicePianta, 0);
    
    ELSEIF _Tipo = "Rinvaso" THEN
    
		INSERT INTO RinvasoEffettuato(CodicePianta, DataRinvaso, Costo)
		VALUES (_CodicePianta, _Data, 0);
	
    ELSE
    
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore!';
        
    END IF;
END $$

DELIMITER ;

-- Call InserimentoManualeManutenzione('001', '2016-06-05', 'Rinvaso', 'CampoVuoto', '0');

-- 
-- FUNZIONE Preventivo Giardino
--

DROP PROCEDURE IF EXISTS PreventivoGiardino;

DELIMITER $$ 

CREATE PROCEDURE PreventivoGiardino(IN _ID int)

BEGIN 
    CREATE TEMPORARY TABLE IF NOT EXISTS QuantitaPiante AS (
	Select P.Nome, P.Cultivar, count(*) as Quantita
    
    From Giardino G inner join Settore S on (G.IDGiardino = S.IDGiardino) 
			inner join
         PiantePosizionate P on (S.Codice = P.CodiceSettore)
    
    Where G.IDGiardino = _ID
    
    Group by P.Nome, P.Cultivar);
    
    
    Select Q.Nome, Q.Cultivar, Q.Quantita, avg(P.Prezzo) as PrezzoSingolo, (avg(P.Prezzo)*Quantita) as PrezzoTotale
     
    From QuantitaPiante Q inner join Piante P on (Q.Nome = P.Nome and Q.Cultivar = P.Cultivar)
    
    Group by Q.Nome, Q.Cultivar, Q.Quantita;
    
END $$

DELIMITER ;

Call PreventivoGiardino(001);

--
-- FUNZIONE Reporting
--

DROP PROCEDURE IF EXISTS Reporting;

DELIMITER $$ 

CREATE PROCEDURE Reporting() 

BEGIN 

	Select P.Nome, P.Cultivar
    From Piante P
    Where P.Acquistata = 'Si'
    Group by P.Nome, P.Cultivar
    Having count(*) = (Select Min(D.PianteVendute)
						From ( Select count(*) as PianteVendute
								From Piante P1
                                Where P1.Acquistata = 'Si'
								Group by P1.Nome, P1.Cultivar
								) as D)
	Union
    Select P.Nome, P.Cultivar
    From Piante P inner join Ordine O on(P.CodicePianta = O.CodicePianta) inner join MalattieContratte M on(P.CodicePianta = M.CodicePianta and M.DataContrazione >= O.DataOrdine)
    Where P.Acquistata = 'Si'
    Group by P.Nome, P.Cultivar
    Having count(*) = (Select Max(D.PianteMalata)
						From ( Select count(*) as PianteMalata
								 From Piante P1 inner join Ordine O on(P1.CodicePianta = O.CodicePianta) inner join MalattieContratte M1 on(P1.CodicePianta = M1.CodicePianta and M1.DataContrazione >= O.DataOrdine)
								 Where P1.Acquistata = 'Si'
								 Group by P1.Nome, P1.Cultivar
								) as D);
    
END $$

DELIMITER ;

-- Call Reporting();

-- 
-- FUNZIONE Reporting Manutenzioni
--

Drop table if exists  MV_ManutenzioniRichieste;
Create table MV_ManutenzioniRichieste (
	Citta char(50) NOT NULL,
    Mese char(50) NOT NULL,
    Anno char(50) NOT NULL,
	NumeroInterventi int(50) NOT NULL,
    Primary key( Citta, Mese, Anno )
) ENGINE = InnoDB DEFAULT CHARSET=latin1;

DROP PROCEDURE IF EXISTS OrganizzazioneManutenzioni;

DELIMITER $$

CREATE PROCEDURE OrganizzazioneManutenzioni (OUT esito INTEGER)
BEGIN

	DECLARE esito INTEGER DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
	 	ROLLBACK;
		SET esito = 1;
        SELECT 'Si è verificato un errore: materialized view non aggiornata.';
	END;
	TRUNCATE TABLE MV_ManutenzioniRichieste;
    
    INSERT INTO MV_ManutenzioniRichieste (
		SELECT 
			U.CittaResidenza, month(M.Scadenza), year(M.Scadenza), count(*) as NumeroInterventi
		FROM
			ManutenzioneRichiesta M inner join Utente U on M.Nickname = U.Nickname
		WHERE
			year(M.Scadenza) >= year(current_date)
			and month(M.Scadenza) >= month(current_date)
		GROUP BY
			U.CittaResidenza, month(M.Scadenza), year(M.Scadenza)
	);
    
END $$

DELIMITER ;

-- call OrganizzazioneManutenzioni(@esito);

-- Select *
-- From MV_ManutenzioniRichieste;

--
-- FUNZIONE Reporting Manutenzioni 2#
--

Drop table if exists  MV_ManutenzioniProgrammate;
Create table MV_ManutenzioniProgrammate (
	Citta char(50) NOT NULL,
    Mese char(50) NOT NULL,
	NumeroInterventi int(50) NOT NULL,
    Primary key( Citta, Mese)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;

DROP PROCEDURE IF EXISTS OrganizzazioneManutenzioniProgrammate;

DELIMITER $$


CREATE PROCEDURE OrganizzazioneManutenzioniProgrammate (OUT esito INTEGER)
BEGIN

	DECLARE esito INTEGER DEFAULT 0;
    
/*    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SET esito = 1;
        SELECT 'Si è verificato un errore: materialized view non aggiornata.';
	END;*/
	TRUNCATE TABLE  MV_ManutenzioniProgrammate;
    
	INSERT INTO MV_ManutenzioniProgrammate (
		SELECT 
			U.CittaResidenza, M.MeseManutenzione, count(*) as NumeroInterventi
		FROM
			ManutenzioneProgrammata M inner join Utente U on M.Nickname = U.Nickname
		WHERE
			M.MeseManutenzione >= month(current_date)
		GROUP BY
			U.CittaResidenza, M.MeseManutenzione
	);
    
END $$

DELIMITER ;

-- call OrganizzazioneManutenzioniProgrammate (@esito);

-- Select *
-- From MV_ManutenzioniProgrammate;


-- 
-- FUNZIONE Ricerca Pianta da Acquistare
--

DROP PROCEDURE IF EXISTS RicercaPiantaDaAcquistare;

DELIMITER $$ 

CREATE PROCEDURE RicercaPiantaDaAcquistare(
											IN _Esposizione char(50), 
                                            IN _FabbisognoAcquaRiposo char(50), 
                                            IN _FabbisognoAcquaVegetativo char(50), 
                                            IN _IndiceManutenzione char(50), 
                                            IN _PrezzoMin int, 
                                            IN _PrezzoMax int,
                                            IN _DimenzioneMin int,
                                            IN _DimenzioneMax int,
                                            IN _InizioPeriodoFioritura char(50)
										  ) 

BEGIN 

	SELECT PA.Genere, PA.Nome, PA.Cultivar, PE.Prezzo, PE.Dimensione

	FROM Pianta PA inner join Piante PE on PA.Nome = PE.Nome and PA.Cultivar = PE.Cultivar
			inner join
		 EsigenzePianta EP on EP.Nome = PE.Nome and EP.Cultivar = PE.Cultivar
			inner join
		 FasiPianta FP on  EP.Nome = FP.Nome and EP.Cultivar = FP.Cultivar
	
    WHERE PE.Prezzo between _PrezzoMin and _PrezzoMax
			and EP.Esposizione = _Esposizione
            and EP.FabbisognoAcquaVegetativo = _FabbisognoAcquaVegetativo
            and EP.FabbisognoAcquaRiposo = _FabbisognoAcquaRiposo
            and PA.IndiceManutenzione = _IndiceManutenzione
            and PE.Dimensione between _DimenzioneMin and _PrezzoMax
            and FP.InizioPeriodoFioritura = _InizioPeriodoFioritura;

END $$

DELIMITER ;

-- call RicercaPiantaDaAcquistare('Indiretta', '1', '1', 'Bassa', '0', '1000', '0', '1000', '02');

--
-- FUNZIONE Smart Design
--

DROP PROCEDURE IF EXISTS SmartDesing;

DELIMITER $$ 

CREATE PROCEDURE SmartDesing(IN _IndiceManutenzione char(50),  IN _PrezzoMin int(50), IN _PrezzoMax int(50), IN _OrediLuce int(50))

BEGIN 

	Select distinct P.Nome, P.Cultivar
    
    From Pianta P inner join EsigenzePianta E inner join Piante C on (P.Nome = C.Nome and P.Cultivar = C.Cultivar)
    
    Where P.IndiceManutenzione = _IndiceManutenzione and C.Prezzo between _PrezzoMin and _PrezzoMax and E.OreLuceVegetativo <= _OrediLuce and E.OreLuceRiposo <= _OrediLuce;
    
END $$

DELIMITER ;

-- call SmartDesing('Bassa', '0', '1000', '10');

-- 
-- FUNZIONE Test Ridondanze
--

DROP PROCEDURE IF EXISTS InserimentoManutenzioneRichiesta;

DELIMITER $$ 

CREATE PROCEDURE InserimentoManutenzioneRichiesta(IN _Codice INT, IN _Scadenza DATE, IN _TipoManutenzione CHAR(50), IN _Nickname CHAR(50)) 

BEGIN 
	INSERT INTO ManutenzioneRichiesta (Codice, Scadenza, TipoManutenzione, Nickname)
    VALUES (_Codice, _Scadenza, _TipoManutenzione, _Nickname);
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS InserimentoManutenzioneProgrammata;

DELIMITER $$ 

CREATE PROCEDURE InserimentoManutenzioneProgrammata(IN _Codice INT, IN _MeseManutenzione DATE, IN _TipoManutenzione CHAR(50), IN _Nickname CHAR(50)) 

BEGIN 
	INSERT INTO ManutenzioneRichiesta (Codice, MeseManutenzione, TipoManutenzione, Nickname)
    VALUES (_Codice, _MeseManutenzione, _TipoManutenzione, _Nickname);
END $$

DELIMITER ;

-- 
-- TRIGGER Nickname
-- 

DROP TRIGGER IF EXISTS ControlloNickname;

DELIMITER $$

CREATE TRIGGER ControlloNickname
BEFORE INSERT ON Utente
FOR EACH ROW

BEGIN
	
	DECLARE LunghezzaNickname INT default 0;
	SET LunghezzaNickname = CHAR_LENGTH(NEW.Nickname);
    IF (LunghezzaNickname < 6 OR LunghezzaNickname > 12) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il Nickname deve essere lungo tra i 5 e i 15 caratteri!';
    END IF;

END $$

DELIMITER ;

--
-- TRIGGER Password 1#
--

DROP TRIGGER IF EXISTS ControlloPassword;

DELIMITER $$

CREATE TRIGGER ControlloPassword
BEFORE INSERT ON Utente
FOR EACH ROW

BEGIN
	
	DECLARE LunghezzaPassword INT default 0;
	SET LunghezzaPassword = CHAR_LENGTH(NEW.PasswordUtente);
    IF (LunghezzaPassword < 6 OR LunghezzaPassword > 12) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La password deve essere lunga tra i 6 e i 12 caratteri!';
    END IF;

END $$

DELIMITER ;

INSERT INTO Utente
VALUES ('test6', 'test@test.test6', 'te6', 'te6', '777777777777', 'test', 'testcraft', '0', 'test', '0');

SELECT *
FROM Utente;

-- 
-- TRIGGER Password 2#
--

DROP TRIGGER IF EXISTS ControlloPassword2;

DELIMITER $$

CREATE TRIGGER ControlloPassword2
BEFORE INSERT ON Utente
FOR EACH ROW

BEGIN

	DECLARE uguali INT default 0;
	SET Uguali = STRCMP(NEW.PasswordUtente, NEW.NickName);
    IF (Uguali = 0) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La password non può essere uguale al nome utente!';
    END IF;

END $$

DELIMITER ;

-- INSERT INTO Utente
-- VALUES ('test5', 'test@test.test5', 'test5', 'tes5', 'test5', 'test', 'testcraft', '0', 'test', '0');

-- SELECT *
-- FROM Utente;

--
-- TRIGGER Potatura
--

DROP TRIGGER IF EXISTS ControlloTipiPotatura;

DELIMITER $$

CREATE TRIGGER ControlloTipiPotatura
BEFORE INSERT ON Potatura
FOR EACH ROW

BEGIN

    IF (NEW.TipoIntervento = "Contenimento" OR NEW.TipoIntervento = "Pulizia" OR NEW.TipoIntervento = "Aumento Produzione") THEN
		SET @Procedi = 1;
	ELSE
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Accettato solamente: Contenimento, Pulizia o Aumento Produzione.';
    END IF;

END $$

DELIMITER ;
/*
INSERT INTO Potatura
VALUES ('Biancospino Comune', 'Nessuno', '08', 'Aumento Produzioneee'); 
INSERT INTO Potatura
VALUES ('Biancospino Comune', 'Nessuno', '10', 'Aumento Produzione');
SELECT *
FROM Potatura;
*/

-- 
-- TRIGGER Valutazione Generale Utente dopo Nuova Risposta
--

DROP TRIGGER IF EXISTS AggiornamentoGiudizioUtente_NuovaRisposta;

DELIMITER $$

CREATE TRIGGER AggiornamentoGiudizioUtente_NuovaRisposta
AFTER INSERT ON PostRisposta
FOR EACH ROW

BEGIN
		
	DECLARE Nuovo_TotalePostUtente INT default 0;
    DECLARE Nuovo_ComplessivoValutazioniUtente INT default 0;
    DECLARE Nuovo_GiudizioComplessivo INT default 0;
    
	-- Calcolo numero risposte dell'utente in questione:
	SET Nuovo_TotalePostUtente = ( 
			SELECT count(*)
            FROM PostRisposta PR
            WHERE PR.Username = NEW.Username
	);
    
    -- Calcolo la somma dei giudizi complessivi dell'utente:
    SET Nuovo_ComplessivoValutazioniUtente = (
			SELECT sum(PR.NumeroGiudizi / PR.Giudizio)/count(*)
            FROM PostRisposta PR
            WHERE PR.Username = NEW.Username
	);
    
    -- Calcolo la nuova valutazione finale:
	SET Nuovo_GiudizioComplessivo = Nuovo_ComplessivoValutazioniUtente / Nuovo_TotalePostUtente;
    
	if Nuovo_GiudizioComplessivo is not NULL then
	-- Aggiorno il risultato:
	UPDATE Utente U
	SET GiudizioComplessivo = Nuovo_GiudizioComplessivo
    WHERE U.NickName = NEW.Username;
    end if;
	
END $$

DELIMITER ;

-- insert into PostRisposta
-- values( 'verdilu', current_timestamp, '2015-04-16 12:30:11', 'Verdilu', 0 ,0, 'Ciao123') 

-- 
-- TRIGGER Valutazione Generale Utente dopo Nuova Valutazione
--

DROP TRIGGER IF EXISTS AggiornamentoGiudizioUtente_NuovaValutazione;

DELIMITER $$

CREATE TRIGGER AggiornamentoGiudizioUtente_NuovaValutazione
AFTER UPDATE ON PostRisposta
FOR EACH ROW

BEGIN

DECLARE Nuovo_TotalePostUtente INT default 0;
DECLARE Nuovo_ComplessivoValutazioneUtente INT default 0;
DECLARE Nuovo_GiudizioComplessivo INT default 0;

-- IF NEW.NumeroGiudizi <> OLD.NumeroGiudizi THEN
    
	-- Calcolo numero risposte dell'utente in questione:
	SET Nuovo_TotalePostUtente = ( 
			SELECT count(*)
            FROM PostRisposta PR
            WHERE PR.Username = NEW.Username
	);
    
    -- Calcolo la somma dei giudizi complessivi dell'utente:
    SET Nuovo_ComplessivoValutazioneUtente = (
			SELECT sum(PR.Giudizio / PR.NumeroGiudizi)
            FROM PostRisposta PR
            WHERE PR.Username = NEW.Username
	);
    
    -- Calcolo la nuova valutazione finale:
	SET Nuovo_GiudizioComplessivo = Nuovo_ComplessivoValutazioneUtente / Nuovo_TotalePostUtente;

	-- Aggiorno il risultato:
	UPDATE Utente U
	SET GiudizioComplessivo = Nuovo_GiudizioComplessivo
    WHERE U.Nickname = NEW.Username;

-- END IF;
END $$

DELIMITER ;

-- call AggiornamentoValutazioneRisposta('Celelia', '2015-10-05 12:20:00', 5); 

-- SELECT *
-- FROM PostRisposta PR
-- WHERE PR.Username = 'Celelia';

-- SELECT *
-- FROM Utente U
-- WHERE U.NickName = 'Celelia';

--
-- EVENT Aggiornamento Indice di Manutenzione
--

DROP PROCEDURE IF EXISTS AggiornamentoIndiceManutenzione;

DELIMITER $$

CREATE PROCEDURE AggiornamentoIndiceManutenzione ()
BEGIN
	DECLARE finito INTEGER DEFAULT 0;
    DECLARE _nome CHAR(50) DEFAULT '';
    DECLARE _cultivar CHAR(50) DEFAULT '';
    DECLARE _indice INTEGER DEFAULT 0;

	-- Trovare numero medio manutenzione di tutte le piante
	CREATE OR REPLACE VIEW NumeroManutenzioni AS
    SELECT 
        PE.CodicePianta,
        PE.Nome,
        PE.Cultivar,
        SUM(TE.Costo) AS CostoManutenzioni
    FROM
        Piante PE
            INNER JOIN
        PotaturaEffettuata TE ON TE.CodicePianta = PE.CodicePianta
    WHERE
        TE.Costo <> 0
    GROUP BY PE.CodicePianta, PE.Nome , PE.Cultivar 
    
    UNION ALL SELECT 
    
        PE.CodicePianta,
        PE.Nome,
        PE.Cultivar,
        SUM(CE.Costo) AS CostoManutenzioni
    FROM
        Piante PE
            INNER JOIN
        ConcimazioneEffettuata CE ON CE.CodicePianta = PE.CodicePianta
    WHERE
        CE.Costo <> 0
    GROUP BY PE.CodicePianta , PE.Nome , PE.Cultivar 
    
    UNION ALL SELECT
    
        PE.CodicePianta,
        PE.Nome,
        PE.Cultivar,
        SUM(RE.Costo) AS CostoManutenzioni
    FROM
        Piante PE
            INNER JOIN
        RinvasoEffettuato RE ON PE.CodicePianta = RE.CodicePianta
    WHERE
        RE.Costo <> 0
    GROUP BY PE.CodicePianta , PE.Nome , PE.Cultivar;
    

BEGIN
	DECLARE cursoreCodici CURSOR FOR
    SELECT NM.Nome, NM.Cultivar, avg(NM.CostoManutenzioni) as Indice
    FROM NumeroManutenzioni NM
    GROUP BY NM.Nome, NM.Cultivar;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito = 1;
    
    OPEN cursoreCodici;
    
    prelievo: LOOP
		fetch cursoreCodici into _nome, _cultivar, _indice;
		
        IF finito = 1 THEN
			LEAVE prelievo;
		END IF;
		
	IF (_indice >= 0 and _indice < 100) THEN
		UPDATE Pianta
		SET IndiceManutenzione = 'Basso'
		WHERE Nome = _nome and Cultivar = _cultivar;
    ELSEIF(_indice >= 100 and _indice < 300) THEN
		UPDATE Pianta
		SET IndiceManutenzione = 'Medio'
		WHERE Nome = _nome and Cultivar = _cultivar;
	ELSEIF _indice >= 300 THEN
		UPDATE Pianta
		SET IndiceManutenzione = 'Alto'
		WHERE Nome = _nome and Cultivar = _cultivar;
	END IF;

    END LOOP prelievo;
    
    CLOSE cursoreCodici;
END ;

END $$

DROP EVENT IF EXISTS Event_IndiceManutenzione $$

CREATE EVENT Event_IndiceManutenzione
ON SCHEDULE EVERY 1 YEAR
STARTS '2016-01-01 00:05:00'
DO
BEGIN
	call AggiornamentoIndiceManutenzione();
END $$

DELIMITER ;

-- call AggiornamentoIndiceManutenzione();

--
-- EVENT Aggiornamento Tavole Log
--

/*
	Ogni 12 ore (start con anticipo di 5 minuti) vengono prelevati i dati
    contenuti nei vasi delle piante, nei ripiani e nelle sezioni e vengono 
    aggiunti alle relative tabelle di log nei relativi attributidi, con tanto
    di data prelievo dei dati. Questi log verranno analizzati da altre funzioni
    del database. I dati relativi al terreno dei contenitori presenti nella tabella
    "Dato Terreno" devono essere aggiornati costantemente da sensori. "Dato Terreno"
    infatti ammette una sola tupla per contenitore. Al contrario, nella rispettiva
    tabella "Log Dato Terreno" saranno presenti più tuple: ciascuna è una rilevazione
    prelevata da Dato Terreno ad una determinata ora.
*/
DROP EVENT IF EXISTS AggiornamentoLogs;

DELIMITER $$

CREATE EVENT AggiornamentoLogs
ON SCHEDULE EVERY 12 HOUR
STARTS '2016-10-01 23:55:00'
DO
BEGIN

DECLARE Finito INT default 0;
DECLARE New_CodiceLogContenitore INT default 0;
DECLARE New_EsalazioniLogContenitore CHAR(50) default '';
DECLARE New_UmiditaLogContenitore INT default 0;
DECLARE New_LivelloIdratazioneLogContenitore INT default 0; -- E' un int??

DECLARE New_CodiceLogDatoTerreno INT default 0;
DECLARE New_ConcentrazioneElemento INT default 0;
DECLARE New_Elemento char(50) default '';

DECLARE New_CodiceLogRipiano INT default 0;
DECLARE New_Irrigazione CHAR(50) default '';

DECLARE New_CodiceLogSezione INT default 0;
DECLARE New_Umidita INT default 0;
DECLARE New_Temperatura INT default 0;
DECLARE New_Illuminazione INT default 0;

DECLARE CursoreLogContenitore CURSOR FOR
SELECT Codice, Esalazioni, Umidita, LivelloIdratazione
FROM Contenitore;

DECLARE CursoreLogDatoTerreno CURSOR FOR
SELECT Codice, ConcentrazioneElemento, Elemento
FROM DatoTerreno;

DECLARE CursoreLogRipiano CURSOR FOR
SELECT Codice, Irrigazione
FROM LogRipiano;

DECLARE CursoreLogSezione CURSOR FOR
SELECT CodiceSezione Umidita, Temperatura, Illuminazione
FROM LogSezione;

DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET Finito = 1;

OPEN CursoreLogContenitore;

preleva: LOOP
	FETCH CursoreLogContenitore INTO New_CodiceLogContenitore, 
									 New_EsalazioniLogContenitore, 
									 New_UmiditaLogContenitore, 
									 New_LivelloIdratazioneLogContenitore; -- Funziona il fetch into su più colonne??

	IF Finito = 1 THEN
		LEAVE preleva;
	END IF;

	INSERT INTO LogContenitore(DataLogContenitore, Codice, Esalazioni, Umidita, LivelloIdratazione)
	VALUES (current_date, New_CodiceLogContenitore, New_EsalazioniLogContenitore, New_UmiditaLogContenitore, New_LivelloIdratazioneLogContenitore);
END LOOP preleva;

CLOSE CursoreLogContenitore;

 SET Finito = 0;


OPEN CursoreLogDatoTerreno;

preleva: LOOP
	FETCH CursoreLogDatoTerreno INTO New_CodiceLogDatoTerreno,
									 New_ConcentrazioneElemento,
									 New_Elemento;
                 
	IF Finito = 1 THEN
		LEAVE preleva;
	END IF;
                                     
	INSERT INTO LogDatoTerreno(Codice, DataLogContenitore, ConcentrazioneElemento, Elemento)
	VALUES (New_CodiceLogDatoTerreno, current_date, New_ConcentrazioneElemento, New_Elemento);
END LOOP preleva;

CLOSE CursoreLogDatoTerreno;

SET Finito = 0;


OPEN CursoreLogRipiano;

preleva: LOOP
	FETCH CursoreLogRipiano INTO New_CodiceLogRipiano,
								 New_Irrigazione;
                 
	IF Finito = 1 THEN
		LEAVE preleva;
	END IF;
                                     
	INSERT INTO LogRipiano(CodiceRipiano, DataLogRipiano, Irrigazione)
	VALUES (New_CodiceLogRipiano, current_date, New_Irrigazione);

END LOOP preleva;

CLOSE CursoreLogRipiano;

SET Finito = 0;

OPEN CursoreLogSezione;

preleva: LOOP
	FETCH CursoreLogSezione INTO New_CodiceLogSezione,
								 New_Umidita,
								 New_Temperatura,
                                 New_Illuminazione;
                 
	IF Finito = 1 THEN
		LEAVE preleva;
	END IF;
                                     
	INSERT INTO LogSezione(CodiceSezione, DataLogSezione, Umidita, Temperatura, Illuminazione)
	VALUES (New_CodiceLogSezione, current_date, New_Umidita, New_Temperatura, New_Illuminazione);
    
END LOOP preleva;

CLOSE CursoreLogSezione;

END $$

DELIMITER ;

--
-- EVENT Manutenzione Automatica
--

-- Trovare piante contrassegnate con manutenzione automatica
-- Controllare i periodi di manutenzione di queste piante
-- Se il periodo di manutenzione corrisponde a current date, notificare

DROP PROCEDURE IF EXISTS ControlloManutenzioniAutomatiche;

DELIMITER $$

CREATE PROCEDURE ControlloManutenzioniAutomatiche ()
BEGIN
	-- Trovare piante contrassegnate con manutenzione automatica
	CREATE OR REPLACE VIEW PianteConManutenzioneAuto AS
	SELECT S.CodicePianta, PA.Nome, PA.Cultivar, S.Nickname
	FROM Scheda S inner join Piante PE on S.CodicePianta = PE.CodicePianta
			inner join
		Pianta PA on PA.Cultivar = PE.Cultivar and PA.Nome = PE.Nome
	WHERE S.ManutenzioneAutomatica = "Si";

	-- Controllare i periodi di manutenzione di queste piante
	CREATE OR REPLACE VIEW PeriodiManutenzione AS
	SELECT PM.CodicePianta, PM.Nickname, PO.Periodo, 'Potatura'
	FROM Potatura PO inner join PianteConManutenzioneAuto PM 
			on PO.Nome = PM.Nome and PO.Cultivar = PM.Cultivar
	WHERE PO.Periodo = month(current_date) 
	
		UNION ALL

	SELECT PM.CodicePianta, PM.Nickname, CO.Periodo, 'Concimazione'
	FROM InterventiConcimazione CO inner join PianteConManutenzioneAuto PM 
			on CO.Nome = PM.Nome and CO.Cultivar = PM.Cultivar
	WHERE CO.Periodo = month(current_date)
	
		UNION ALL

	SELECT PM.CodicePianta, PM.Nickname, CO.Periodo, 'Rinvaso'
	FROM Rinvaso CO inner join PianteConManutenzioneAuto PM 
			on CO.Nome = PM.Nome and CO.Cultivar = PM.Cultivar
	WHERE CO.Periodo = month(current_date);
	
	SELECT *
	FROM PeriodiManutenzione;
END$$

CREATE EVENT Event_ControlloManutenzioniAutomatiche
ON SCHEDULE EVERY 1 MONTH
STARTS '2016-10-01 00:05:00'
DO
BEGIN
	call ControlloManutenzioniAutomatiche();
END$$


DELIMITER ;

-- 
-- EVENT Refresh del Report delle Vendite
--

Create table MV_ReportOrdine (
	Quantita int(50) NOT NULL,
    Nome char(50) NOT NULL,
    Cultivar char(50) NOT NULL,
    Primary key( Nome, Cultivar )
) ENGINE = InnoDB DEFAULT CHARSET=latin1;


DROP PROCEDURE IF EXISTS refresh_MV_ReportOrdine;

DELIMITER $$

CREATE PROCEDURE refresh_MV_ReportORdine (OUT esito INTEGER)
BEGIN

	DECLARE esito INTEGER DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SET esito = 1;
        SELECT 'Si è verificato un errore: materialized view non aggiornata.';
	END;
	TRUNCATE TABLE  MV_ReportORdine;
    
    INSERT INTO MV_ReportOrdine (
	SELECT SUM(Quantita) as Quantita, D.Nome, D.Cultivar

	FROM(
		SELECT
			count(*) as Quantita, P.Nome, P.Cultivar
		FROM 
			Ordine O inner join Piante P on (O.CodicePianta = P.CodicePianta)

		WHERE 
			O.DataOrdine between (Current_date - Interval 7 day) and Current_date

		GROUP BY
			P.Nome, P.Cultivar
    
	UNION ALL

		SELECT
			count(*) * 2 as Quantita, O.Nome, O.Cultivar
	
		FROM 
			OrdiniPendenti O

		WHERE 
			O.DataOrdine between (Current_date - Interval 7 day) and Current_date

		GROUP BY
			O.Nome, O.Cultivar
		) as D

	GROUP BY D.Nome, D.Cultivar
	
	);
    
END $$

DELIMITER ;

DELIMITER $$

CREATE EVENT Refresh_MV_ReportOrdine
ON SCHEDULE EVERY 7 DAY
STARTS '2016-09-11 23:55:00'
DO
	BEGIN
	SET @esito = 0;
    CALL refresh_MV_ReportOrdine(@esito);
    
    IF @esito = 1 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore refresh da temporal trigger.';
	END IF;
END $$

DELIMITER ;

-- 
-- EVENT Reporting Assunzioni
--

DROP PROCEDURE IF EXISTS ControlloDipendenti;

DELIMITER $$

CREATE PROCEDURE ControlloDipendenti (OUT testo CHAR(100))
BEGIN
	DECLARE NumeroDipendenti INT default 0;
	DECLARE NumeroManutenzioniProgrammate INT default 0;
	DECLARE NumeroManutenzioniRichieste INT default 0;
	DECLARE NumeroManutenzioniTotali INT default 0;
	
	SET NumeroDipendenti = (
		SELECT sum(NumeroDipendenti)
		FROM Sede
	);
	
	SET NumeroManutenzioniProgrammate = (
		SELECT count(*)
		FROM ManutenzioneProgrammata
        WHERE MeseManutenzione = month(current_date) + 1
	);
    
    SET NumeroManutenzioniRichieste = (
		SELECT count(*) 
		FROM ManutenzioneRichiesta
        WHERE month(Scadenza) = month(current_date) + 1
	);
    
    SET NumeroManutenzioniTotali = NumeroManutenzioniRichieste + NumeroManutenzioniProgrammate;

	IF (NumeroManutenzioniTotali / 20 > NumeroDipendenti) THEN
		SET testo = 'Assumere dipendenti per il prossimo mese!';
	ELSE
		SET testo = 'Non è necessario assumere dipendenti per il prossimo mese!';
	END IF;
	
END $$


CREATE EVENT ReportAssunzioni
ON SCHEDULE EVERY 1 MONTH
STARTS '2016-08-03 23:55:00'
DO
BEGIN

	CALL ControlloDipendenti(@testo);
	
	SELECT @testo;
    
END $$

DELIMITER ;

call ControlloDipendenti(@test);
Select @test;