package fr.projecthandler.dao;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.TaskMessage;

public interface TaskMessageDao {
	public Long saveTaskMessage(TaskMessage taskMessage);

	public void updateTaskMessage(TaskMessage taskMessage);

	public void deleteTaskMessagesByIds(List<Long> taskMessagesIds);

	public void deleteTaskMessageById(Long taskMessageId);

	public TaskMessage findTaskMessageById(Long taskMessageId);

	public Set<TaskMessage> getTaskMessagesByTaskId(Long taskId);
}
