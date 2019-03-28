package com.zhenningtech.leaning.system.model;

public class SystemAttachment {
    /**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column system_attachment.id
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	private Integer id;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column system_attachment.name
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	private String name;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column system_attachment.real_path
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	private String realPath;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column system_attachment.original_name
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	private String originalName;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column system_attachment.type
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	private Integer type;

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column system_attachment.id
	 * @return  the value of system_attachment.id
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column system_attachment.id
	 * @param id  the value for system_attachment.id
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column system_attachment.name
	 * @return  the value of system_attachment.name
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public String getName() {
		return name;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column system_attachment.name
	 * @param name  the value for system_attachment.name
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column system_attachment.real_path
	 * @return  the value of system_attachment.real_path
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public String getRealPath() {
		return realPath;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column system_attachment.real_path
	 * @param realPath  the value for system_attachment.real_path
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public void setRealPath(String realPath) {
		this.realPath = realPath;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column system_attachment.original_name
	 * @return  the value of system_attachment.original_name
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public String getOriginalName() {
		return originalName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column system_attachment.original_name
	 * @param originalName  the value for system_attachment.original_name
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public void setOriginalName(String originalName) {
		this.originalName = originalName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column system_attachment.type
	 * @return  the value of system_attachment.type
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public Integer getType() {
		return type;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column system_attachment.type
	 * @param type  the value for system_attachment.type
	 * @mbg.generated  Thu Mar 28 11:50:55 CST 2019
	 */
	public void setType(Integer type) {
		this.type = type;
	}

	private String typeName;

	public String getTypeName() {
		return typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
    
}