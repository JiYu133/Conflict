# VisualShaderNodeGroupBase

Inherits: VisualShaderNodeResizableBase < VisualShaderNode < Resource < RefCounted < Object

Inherited By: VisualShaderNodeExpression

Base class for a family of nodes with variable number of input and output ports within the visual shader graph.

## Description

Currently, has no direct usage, use the derived classes instead.

## Methods

void | add_input_port(id: int, type: int, name: String)
void | add_output_port(id: int, type: int, name: String)
void | clear_input_ports()
void | clear_output_ports()
int | get_free_input_port_id() const
int | get_free_output_port_id() const
int | get_input_port_count() const
String | get_inputs() const
int | get_output_port_count() const
String | get_outputs() const
bool | has_input_port(id: int) const
bool | has_output_port(id: int) const
bool | is_valid_port_name(name: String) const
void | remove_input_port(id: int)
void | remove_output_port(id: int)
void | set_input_port_name(id: int, name: String)
void | set_input_port_type(id: int, type: int)
void | set_inputs(inputs: String)
void | set_output_port_name(id: int, name: String)
void | set_output_port_type(id: int, type: int)
void | set_outputs(outputs: String)

---

## Method Descriptions

void add_input_port(id: int, type: int, name: String) 

Adds an input port with the specified type (see PortType) and name.

---

void add_output_port(id: int, type: int, name: String) 

Adds an output port with the specified type (see PortType) and name.

---

void clear_input_ports() 

Removes all previously specified input ports.

---

void clear_output_ports() 

Removes all previously specified output ports.

---

int get_free_input_port_id() const 

Returns a free input port ID which can be used in add_input_port().

---

int get_free_output_port_id() const 

Returns a free output port ID which can be used in add_output_port().

---

int get_input_port_count() const 

Returns the number of input ports in use. Alternative for get_free_input_port_id().

---

String get_inputs() const 

Returns a String description of the input ports as a colon-separated list using the format id,type,name; (see add_input_port()).

---

int get_output_port_count() const 

Returns the number of output ports in use. Alternative for get_free_output_port_id().

---

String get_outputs() const 

Returns a String description of the output ports as a colon-separated list using the format id,type,name; (see add_output_port()).

---

bool has_input_port(id: int) const 

Returns true if the specified input port exists.

---

bool has_output_port(id: int) const 

Returns true if the specified output port exists.

---

bool is_valid_port_name(name: String) const 

Returns true if the specified port name does not override an existed port name and is valid within the shader.

---

void remove_input_port(id: int) 

Removes the specified input port.

---

void remove_output_port(id: int) 

Removes the specified output port.

---

void set_input_port_name(id: int, name: String) 

Renames the specified input port.

---

void set_input_port_type(id: int, type: int) 

Sets the specified input port's type (see PortType).

---

void set_inputs(inputs: String) 

Defines all input ports using a String formatted as a colon-separated list: id,type,name; (see add_input_port()).

---

void set_output_port_name(id: int, name: String) 

Renames the specified output port.

---

void set_output_port_type(id: int, type: int) 

Sets the specified output port's type (see PortType).

---

void set_outputs(outputs: String) 

Defines all output ports using a String formatted as a colon-separated list: id,type,name; (see add_output_port()).
