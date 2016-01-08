-- MySQL Workbench Synchronization
-- Generated: 2016-01-08 17:40
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: laboratorio

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `proyecto_web` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;

CREATE TABLE IF NOT EXISTS `proyecto_web`.`Compania` (
  `idCompania` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `nombre` VARCHAR(45) NOT NULL COMMENT '',
  `latitud` VARCHAR(45) NOT NULL COMMENT '',
  `longitud` VARCHAR(45) NOT NULL COMMENT '',
  PRIMARY KEY (`idCompania`)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `proyecto_web`.`Carro` (
  `idCarro` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `nombre` VARCHAR(45) NOT NULL COMMENT '',
  `Compania_idCompania` INT(11) NOT NULL COMMENT '',
  `estado` VARCHAR(45) NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`idCarro`, `Compania_idCompania`)  COMMENT '',
  INDEX `fk_Carro_Compañia1_idx` (`Compania_idCompania` ASC)  COMMENT '',
  CONSTRAINT `fk_Carro_Compañia1`
    FOREIGN KEY (`Compania_idCompania`)
    REFERENCES `proyecto_web`.`Compania` (`idCompania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `proyecto_web`.`Codigo` (
  `idCodigo` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `codigo` VARCHAR(45) NOT NULL COMMENT '',
  PRIMARY KEY (`idCodigo`)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `proyecto_web`.`Especialidad` (
  `Carro_idCarro` INT(11) NOT NULL COMMENT '',
  `Codigo_idCodigo` INT(11) NOT NULL COMMENT '',
  PRIMARY KEY (`Carro_idCarro`, `Codigo_idCodigo`)  COMMENT '',
  INDEX `fk_Carro_has_Codigo_Codigo1_idx` (`Codigo_idCodigo` ASC)  COMMENT '',
  INDEX `fk_Carro_has_Codigo_Carro_idx` (`Carro_idCarro` ASC)  COMMENT '',
  CONSTRAINT `fk_Carro_has_Codigo_Carro`
    FOREIGN KEY (`Carro_idCarro`)
    REFERENCES `proyecto_web`.`Carro` (`idCarro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Carro_has_Codigo_Codigo1`
    FOREIGN KEY (`Codigo_idCodigo`)
    REFERENCES `proyecto_web`.`Codigo` (`idCodigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `proyecto_web`.`Emergencia` (
  `idEmergencia` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `poblacion` VARCHAR(45) NOT NULL COMMENT '',
  `sector` VARCHAR(45) NOT NULL COMMENT '',
  `callePrincipal` VARCHAR(45) NOT NULL COMMENT '',
  `calleSecundaria` VARCHAR(45) NOT NULL COMMENT '',
  `poi` VARCHAR(45) NOT NULL COMMENT '',
  `descripcion` TEXT NOT NULL COMMENT '',
  `contacto` VARCHAR(45) NOT NULL COMMENT '',
  `latitudEmergencia` VARCHAR(45) NOT NULL COMMENT '',
  `longitudEmergencia` VARCHAR(45) NOT NULL COMMENT '',
  `Codigo_idCodigo` INT(11) NOT NULL COMMENT '',
  `horaInicio` DATETIME NULL DEFAULT NULL COMMENT '',
  `horaEE` DATETIME NULL DEFAULT NULL COMMENT 'Hora En Emergencia',
  `horaFin` DATETIME NULL DEFAULT NULL COMMENT '',
  `horaLlegada` DATETIME NULL DEFAULT NULL COMMENT 'Hora llegada al cuartel',
  PRIMARY KEY (`idEmergencia`, `Codigo_idCodigo`)  COMMENT '',
  INDEX `fk_Emergencia_Codigo1_idx` (`Codigo_idCodigo` ASC)  COMMENT '',
  CONSTRAINT `fk_Emergencia_Codigo1`
    FOREIGN KEY (`Codigo_idCodigo`)
    REFERENCES `proyecto_web`.`Codigo` (`idCodigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `proyecto_web`.`Despacho` (
  `Carro_idCarro` INT(11) NOT NULL COMMENT '',
  `Carro_Compania_idCompania` INT(11) NOT NULL COMMENT '',
  `Emergencia_idEmergencia` INT(11) NOT NULL COMMENT '',
  `Emergencia_Codigo_idCodigo` INT(11) NOT NULL COMMENT '',
  PRIMARY KEY (`Carro_idCarro`, `Carro_Compania_idCompania`, `Emergencia_idEmergencia`, `Emergencia_Codigo_idCodigo`)  COMMENT '',
  INDEX `fk_Carro_has_Emergencia_Emergencia1_idx` (`Emergencia_idEmergencia` ASC, `Emergencia_Codigo_idCodigo` ASC)  COMMENT '',
  INDEX `fk_Carro_has_Emergencia_Carro1_idx` (`Carro_idCarro` ASC, `Carro_Compania_idCompania` ASC)  COMMENT '',
  CONSTRAINT `fk_Carro_has_Emergencia_Carro1`
    FOREIGN KEY (`Carro_idCarro` , `Carro_Compania_idCompania`)
    REFERENCES `proyecto_web`.`Carro` (`idCarro` , `Compania_idCompania`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Carro_has_Emergencia_Emergencia1`
    FOREIGN KEY (`Emergencia_idEmergencia` , `Emergencia_Codigo_idCodigo`)
    REFERENCES `proyecto_web`.`Emergencia` (`idEmergencia` , `Codigo_idCodigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `proyecto_web`.`Usuario` (
  `idUsuario` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `nombre` VARCHAR(45) NOT NULL COMMENT '',
  `password` VARCHAR(100) NOT NULL COMMENT '',
  PRIMARY KEY (`idUsuario`)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
