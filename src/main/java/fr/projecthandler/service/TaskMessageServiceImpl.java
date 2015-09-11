package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.TaskMessageDao;
import fr.projecthandler.model.TaskMessage;

@Service
public class TaskMessageServiceImpl implements TaskMessageService {

	@Autowired
	TaskMessageDao taskMessageDao;
	
	@Override
	public Long saveTaskMessage(TaskMessage taskMessage) {
		return taskMessageDao.saveTaskMessage(taskMessage);
	}

	@Override
	public void updateTaskMessage(TaskMessage taskMessage) {
		taskMessageDao.updateTaskMessage(taskMessage);
	}

	@Override
	public void deleteTaskMessagesByIds(List<Long> taskMessagesIds) {
		taskMessageDao.deleteTaskMessagesByIds(taskMessagesIds);
	}

	@Override
	public void deleteTaskMessageById(Long taskMessageId) {
		taskMessageDao.deleteTaskMessageById(taskMessageId);
	}

	@Override
	public TaskMessage findTaskMessageById(Long taskMessageId) {
		return taskMessageDao.findTaskMessageById(taskMessageId);
	}

	@Override
	public Set<TaskMessage> getTaskMessagesByTaskId(Long taskId) {
		return taskMessageDao.getTaskMessagesByTaskId(taskId);
	}
}
