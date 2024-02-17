DROP TRIGGER IF EXISTS tg_before_insert_workplace ON workplace;
DROP TRIGGER IF EXISTS tg_before_insert_office ON office;
DROP TRIGGER IF EXISTS tg_before_insert_warehouse ON warehouse;
DROP TRIGGER IF EXISTS tg_after_delete_office ON office;
DROP TRIGGER IF EXISTS tg_after_delete_warehouse ON warehouse;
DROP TRIGGER IF EXISTS tg_before_insert_order ON orders;
DROP TRIGGER IF EXISTS tg_after_delete_contains ON contains;

-- IC-1 -------------------------------
ALTER TABLE employee
ADD CHECK(EXTRACT(YEAR FROM AGE(NOW(), bdate)) >= 18);
---------------------------------------

----------------------------------------------------------------

CREATE OR REPLACE FUNCTION before_insert_workplace() 
RETURNS TRIGGER AS
$$
DECLARE 
    count INTEGER;
BEGIN
	SELECT COUNT(*) INTO count 
    FROM (
        SELECT address 
        FROM office o 
        WHERE o.address = NEW.address 
        UNION ALL 
        SELECT address 
        FROM warehouse w 
        WHERE w.address = NEW.address
    ) a;

    IF count > 1  THEN
		RAISE EXCEPTION 'Workplace cannot be both an office and a warehouse';
    ELSIF count < 1 THEN
		RAISE EXCEPTION 'Workplace is needs to be either an office or a warehouse';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION before_insert_office() 
RETURNS TRIGGER AS
$$
BEGIN
	IF EXISTS (SELECT 1 FROM warehouse w WHERE w.address = NEW.address) THEN
		RAISE EXCEPTION 'Cannot add office since this address already belongs to a warehouse';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION before_insert_warehouse() 
RETURNS TRIGGER AS
$$
BEGIN
	IF EXISTS (SELECT 1 FROM office o WHERE o.address = NEW.address) THEN
		RAISE EXCEPTION 'Cannot add warehouse since this address already belongs to an office';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION after_delete_office_warehouse() 
RETURNS TRIGGER AS
$$
BEGIN
	IF EXISTS (SELECT 1 FROM workplace wp WHERE wp.address = OLD.address) AND
	    NOT EXISTS (SELECT 1 FROM office o WHERE o.address = OLD.address) AND 
	    NOT EXISTS (SELECT 1 FROM warehouse w WHERE w.address = OLD.address) THEN
		    RAISE EXCEPTION 'Cannot delete/update office/warehouse since this action violates an integrity constraint';
	END IF;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------

CREATE OR REPLACE FUNCTION before_insert_order() 
RETURNS TRIGGER AS
$$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM contains WHERE order_no = NEW.order_no) THEN
		RAISE EXCEPTION 'order_no is not in contains association';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION after_delete_contains() 
RETURNS TRIGGER AS
$$
BEGIN
	IF EXISTS (SELECT 1 FROM orders o WHERE o.order_no = OLD.order_no) AND
	    NOT EXISTS (SELECT 1 FROM contains c WHERE c.order_no = OLD.order_no) THEN
		    RAISE EXCEPTION 'Deletion of contains relation violates integrity constraint';
	END IF;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------

-- IC-2 --------------------------------

CREATE CONSTRAINT TRIGGER tg_before_insert_workplace
    AFTER INSERT OR UPDATE ON workplace DEFERRABLE
    FOR EACH ROW
    EXECUTE PROCEDURE before_insert_workplace();

CREATE CONSTRAINT TRIGGER tg_before_insert_office
    AFTER INSERT OR UPDATE ON office DEFERRABLE
    FOR EACH ROW
    EXECUTE PROCEDURE before_insert_office();

CREATE CONSTRAINT TRIGGER tg_before_insert_warehouse
    AFTER INSERT OR UPDATE ON warehouse DEFERRABLE
    FOR EACH ROW
    EXECUTE PROCEDURE before_insert_warehouse();

CREATE CONSTRAINT TRIGGER tg_after_delete_office
    AFTER DELETE OR UPDATE ON office DEFERRABLE
    FOR EACH ROW
    EXECUTE PROCEDURE after_delete_office_warehouse();

CREATE CONSTRAINT TRIGGER tg_after_delete_warehouse
    AFTER DELETE OR UPDATE ON warehouse DEFERRABLE
    FOR EACH ROW
    EXECUTE PROCEDURE after_delete_office_warehouse();
-- When updating a warehouse/office, both the insert and delete
-- triggers should be executed.

-- IC-3 --------------------------------

CREATE CONSTRAINT TRIGGER tg_before_insert_order
    AFTER INSERT OR UPDATE ON orders DEFERRABLE
    FOR EACH ROW
    EXECUTE PROCEDURE before_insert_order();

CREATE CONSTRAINT TRIGGER tg_after_delete_contains
    AFTER DELETE OR UPDATE ON contains DEFERRABLE
    FOR EACH ROW
    EXECUTE PROCEDURE after_delete_contains();