package fr.projecthandler.model;

import java.util.Date;

public interface TimestampEntity {
	Date getCreatedAt();
	Date getUpdatedAt();
}
