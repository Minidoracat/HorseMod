Attachment modding
==================
This guide explains how to create new attachments for horses using the HorseMod attachment API.

.. note::
  If you want more in-depth information of how the attachment system works internally, please refer to :doc:`attachmentsAPI`.

Creating a new slot
-------------------
Slots require the use of :lua:class:`HorseMod.SlotDefinition` to associated a slot name to a model attachment point on the horse model. You can also use multiple times the same attachment point if needed. Alternatively, extra properties can be set to have the attachment be a mane attachment.

To add a new slot, add a new :lua:class:`HorseMod.SlotDefinition` entry to the :lua:obj:`HorseMod.attachments.AttachmentData.slotsDefinitions` table. Below is an example of adding a new slot called "Hat" attached to the "head" model attachment point on the horse model:

::

  local AttachmentData = require("HorseMod/attachments/AttachmentData")

  AttachmentData.addNewSlot("Hat", {
      modelAttachment = "head",
  })

The slots are first defined in the table :lua:obj:`HorseMod.attachments.AttachmentData.slotsDefinitions`, which is then processed when the server Lua folder gets loaded to generate the various tables used by the attachment system. See :ref:`attachmentsload-label` for more details on that process.

Defining a new attachment
-------------------------
Defining a whole new attachment depends on the function :lua:obj:`HorseMod.AttachmentData.addNewAttachments`. This function allows you to add new slot and item definitions to an existing item full type or create a new item definition entry.

Below is an example usage:

::

  local AttachmentData = require("HorseMod/attachments/AttachmentData")
  local attachmentDef = {
      unequipBehavior = {
          time = -1,
          anim = {
              ["Left"] = "EquipMyItem_Left",
              ["Right"] = "EquipMyItem_Right",
          },
          shouldHold = true,
      },
      model = "MyMod.MyItemModel", -- has variants with riding state suffixes
  }
  AttachmentData.addNewAttachment("MyMod.MyItemFullType", "Reins", attachmentDef)

.. note:: Attachments should be added from the shared folder so that both the server and client are aware of them.