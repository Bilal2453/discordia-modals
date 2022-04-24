Represents a Discord modal used to display a GUI prompt for end-users.
This is main builder for modals, the entry point of this library and where to create modals.

## Constructor

### Modal()

## Properties

| Name | Type | Description |
|-|-|-|
| textInputs | ArrayIterable | A cache of all constructed [[TextInput]] classes in this instance. |

## Methods

### raw()

Returns the raw table structure of this modal that is accepted by Discord.

*This method only operates on data in memory.*

**Returns:** table

----

### removeTextInput(id)

| Parameter | Type |
|-|-|
| id | string |

Removes a previously assigned [[TextInput]] component from the current instance.

*This method only operates on data in memory.*

**Returns:** [[Modal]]

----

### textInput(data, label, style)

| Parameter | Type |
|-|-|
| data | TextInput-Resolvable |
| label | string |
| style | Style-Resolvable |

Creates and assign a new [[TextInput]] component.

*This method only operates on data in memory.*

**Returns:** [[Modal]]

----

### title(title)

| Parameter | Type |
|-|-|
| title | string |

Sets the title of the modal. A modal title is displayed as a big text in the top-center of a modal.

*This method only operates on data in memory.*

**Returns:** [[Modal]]

----

