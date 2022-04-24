#### *extends Component*

A component that represents [TextInput](https://discord.com/developers/docs/interactions/message-components#text-inputs).
A TextInput is a GUI component where the user can input a piece of text.
TextInput component can only be used in a [[Modal]] context.

## Constructor

### TextInput()

## Methods

### label(label)

| Parameter | Type |
|-|-|
| label | string |

Sets the label of the TextInput.

*This method only operates on data in memory.*

**Returns:** [[TextInput]]

----

### maxLength(max)

| Parameter | Type |
|-|-|
| max | number |

Sets the maximum possible amount of characters in the user input. Must be a value between 0 and 4000 inclusive.

*This method only operates on data in memory.*

**Returns:** [[TextInput]]

----

### minLength(min)

| Parameter | Type |
|-|-|
| min | number |

Sets the minmum required amount of characters in the user input. Must be a value between 0 and 4000 inclusive.

*This method only operates on data in memory.*

**Returns:** [[TextInput]]

----

### optional()

Sets this TextInput as optiona.
An optional TextInput may or may not be provided on user modal submit.

*This method only operates on data in memory.*

**Returns:** [[TextInput]]

----

### placeholder(placeholder)

| Parameter | Type |
|-|-|
| placeholder | string |

Sets a placeholder for the TextInput. A placeholder is a shaded text displayed when the TextInput value is empty.
Must be a value between 0 and 100 inclusive.

*This method only operates on data in memory.*

**Returns:** [[TextInput]]

----

### required()

Sets this TextInput as required.
A required TextInput must be provided for the user to be able to submit the modal.

*This method only operates on data in memory.*

**Returns:** [[TextInput]]

----

### style(style)

| Parameter | Type |
|-|-|
| style | Style-Resolvable |

Sets the style of the TextInput.

*This method only operates on data in memory.*

**Returns:** [[TextInput]]

----

### value(value)

| Parameter | Type |
|-|-|
| value | string |

Sets a pre-provided value for the TextInput.
The pre-provided value can be then optionally changed by the user.
Must be a value between 1 and 4000 inclusive.

*This method only operates on data in memory.*

**Returns:** [[TextInput]]

----

