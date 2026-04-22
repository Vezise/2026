local CollectionService = game:GetService("CollectionService")

local RBXMXParser = {}

local SKIP_PROPS = {
	ClassName = true,
	Parent = true,
	UniqueId = true,
	HistoryId = true,
	SourceAssetId = true,
	ScriptGuid = true,
	UniqueIdSerialize = true,
	SecurityCapabilities = true,
	Capabilities = true,
	DataCost = true,
	RobloxLocked = true,
	DebugId = true,
}

local PRIORITY_EARLY = {
	Size = true,
	Shape = true,
	MeshType = true,
	MeshId = true,
	FormFactor = true,
	InitialSize = true,
	PhysicalConfigData = true,
	CanvasSize = true,
	Face = true,
}

local PRIORITY_LATE = {
	CFrame = true,
	Position = true,
	Orientation = true,
	Rotation = true,
	CoordinateFrame = true,
	WorldPivot = true,
	PivotOffset = true,
	C0 = true,
	C1 = true,
	WorldPosition = true,
	WorldCFrame = true,
	Focus = true,
}

local PROP_NAME_MAP = {
	Color3uint8 = "Color",
	size = "Size",
	shape = "Shape",
	formFactorRaw = "FormFactor",
	Health_XML = "Health",
}

local FONT_WEIGHTS = {
	[100] = Enum.FontWeight.Thin,
	[200] = Enum.FontWeight.ExtraLight,
	[300] = Enum.FontWeight.Light,
	[400] = Enum.FontWeight.Regular,
	[500] = Enum.FontWeight.Medium,
	[600] = Enum.FontWeight.SemiBold,
	[700] = Enum.FontWeight.Bold,
	[800] = Enum.FontWeight.ExtraBold,
	[900] = Enum.FontWeight.Heavy,
}

local FONT_STYLES = {
	Normal = Enum.FontStyle.Normal,
	Italic = Enum.FontStyle.Italic,
}

local FACE_BITS = {
	Right = 1, Top = 2, Back = 4, Left = 8, Bottom = 16, Front = 32,
}

local AXIS_BITS = { X = 1, Y = 2, Z = 4 }

local B64_LOOKUP = {}
do
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for i = 1, 64 do
		B64_LOOKUP[string.byte(chars, i)] = i - 1
	end
end

local function b64decode(data: string): string
	local out = {}
	local bits = 0
	local acc = 0
	for i = 1, #data do
		local b = B64_LOOKUP[string.byte(data, i)]
		if b then
			acc = acc * 64 + b
			bits += 6
			if bits >= 8 then
				bits -= 8
				table.insert(out, string.char(math.floor(acc / (2 ^ bits)) % 256))
			end
		end
	end
	return table.concat(out)
end

local XML_ENTITIES = {
	["&amp;"] = "&",
	["&lt;"] = "<",
	["&gt;"] = ">",
	["&quot;"] = '"',
	["&apos;"] = "'",
}

local function xmlDecode(s: string): string
	if not s then return "" end
	s = string.gsub(s, "&#(%d+);", function(n) return string.char(tonumber(n)) end)
	s = string.gsub(s, "&#x(%x+);", function(n) return string.char(tonumber(n, 16)) end)
	for entity, char in XML_ENTITIES do
		s = string.gsub(s, entity, char)
	end
	return s
end

local function parseXML(text: string)
	local pos = 1
	local len = #text
	local root = { tag = "ROOT", attrs = {}, children = {}, textParts = {} }
	local stack = { root }

	while pos <= len do
		local s = string.find(text, "<", pos, true)
		if not s then
			local t = string.sub(text, pos)
			if #t > 0 then
				table.insert(stack[#stack].textParts, xmlDecode(t))
			end
			break
		end

		if s > pos then
			local t = string.sub(text, pos, s - 1)
			table.insert(stack[#stack].textParts, xmlDecode(t))
		end

		if string.sub(text, s, s + 8) == "<![CDATA[" then
			local ce = string.find(text, "]]>", s + 9, true)
			if not ce then break end
			table.insert(stack[#stack].textParts, string.sub(text, s + 9, ce - 1))
			pos = ce + 3
		elseif string.sub(text, s, s + 3) == "<!--" then
			local ce = string.find(text, "-->", s + 4, true)
			if not ce then break end
			pos = ce + 3
		elseif string.sub(text, s, s + 1) == "<?" then
			local ce = string.find(text, "?>", s + 2, true)
			if not ce then break end
			pos = ce + 2
		elseif string.sub(text, s, s + 1) == "<!" then
			local ce = string.find(text, ">", s + 2, true)
			if not ce then break end
			pos = ce + 1
		elseif string.sub(text, s + 1, s + 1) == "/" then
			local ce = string.find(text, ">", s + 2, true)
			if not ce then break end
			local node = table.remove(stack)
			if node and node.textParts then
				node.text = table.concat(node.textParts)
				node.textParts = nil
			end
			pos = ce + 1
		else
			local tagEnd = string.find(text, ">", s + 1, true)
			if not tagEnd then break end
			local tagContent = string.sub(text, s + 1, tagEnd - 1)
			local selfClosing = string.sub(tagContent, -1) == "/"
			if selfClosing then
				tagContent = string.sub(tagContent, 1, -2)
			end

			local tagName = string.match(tagContent, "^(%S+)")
			local attrs = {}
			for k, v in string.gmatch(tagContent, '([%w_%-]+)%s*=%s*"([^"]*)"') do
				attrs[k] = xmlDecode(v)
			end

			local node = { tag = tagName, attrs = attrs, children = {}, textParts = {} }
			table.insert(stack[#stack].children, node)

			if selfClosing then
				node.text = ""
				node.textParts = nil
			else
				table.insert(stack, node)
			end

			pos = tagEnd + 1
		end
	end

	while #stack > 1 do
		local node = table.remove(stack)
		if node.textParts then
			node.text = table.concat(node.textParts)
			node.textParts = nil
		end
	end

	if root.textParts then
		root.text = table.concat(root.textParts)
		root.textParts = nil
	end

	return root
end

local function getChild(node, tag: string)
	if not node or not node.children then return nil end
	for _, c in node.children do
		if c.tag == tag then return c end
	end
	return nil
end

local function getText(node): string
	if not node then return "" end
	return node.text or ""
end

local function getChildText(node, tag: string): string
	return getText(getChild(node, tag))
end

local function getChildNum(node, tag: string): number
	return tonumber(getChildText(node, tag)) or 0
end

local function getAttr(node, name: string): string?
	if not node or not node.attrs then return nil end
	return node.attrs[name]
end

local function readVector2(node)
	return Vector2.new(getChildNum(node, "X"), getChildNum(node, "Y"))
end

local function readVector3(node)
	return Vector3.new(getChildNum(node, "X"), getChildNum(node, "Y"), getChildNum(node, "Z"))
end

local function readCFrameNode(node)
	return CFrame.new(
		getChildNum(node, "X"), getChildNum(node, "Y"), getChildNum(node, "Z"),
		getChildNum(node, "R00"), getChildNum(node, "R01"), getChildNum(node, "R02"),
		getChildNum(node, "R10"), getChildNum(node, "R11"), getChildNum(node, "R12"),
		getChildNum(node, "R20"), getChildNum(node, "R21"), getChildNum(node, "R22")
	)
end

local function readColor3(node)
	return Color3.new(getChildNum(node, "R"), getChildNum(node, "G"), getChildNum(node, "B"))
end

local function readColor3uint8(text: string)
	local n = tonumber(text) or 0
	if n < 0 then n = n + 4294967296 end
	local r = math.floor(n / 65536) % 256
	local g = math.floor(n / 256) % 256
	local b = n % 256
	return Color3.fromRGB(r, g, b)
end

local function readUDim(node)
	return UDim.new(getChildNum(node, "S"), getChildNum(node, "O"))
end

local function readUDim2(node)
	return UDim2.new(
		getChildNum(node, "XS"), getChildNum(node, "XO"),
		getChildNum(node, "YS"), getChildNum(node, "YO")
	)
end

local function readRect(node)
	local minNode = getChild(node, "min")
	local maxNode = getChild(node, "max")
	if minNode and maxNode then
		return Rect.new(
			getChildNum(minNode, "X"), getChildNum(minNode, "Y"),
			getChildNum(maxNode, "X"), getChildNum(maxNode, "Y")
		)
	end
	return Rect.new(0, 0, 0, 0)
end

local function readNumberSequence(text: string)
	local nums = {}
	for n in string.gmatch(text, "[%-%d%.eE]+") do
		table.insert(nums, tonumber(n) or 0)
	end
	local keypoints = {}
	for i = 1, #nums - 2, 3 do
		table.insert(keypoints, NumberSequenceKeypoint.new(nums[i], nums[i + 1], nums[i + 2]))
	end
	if #keypoints < 2 then
		return NumberSequence.new(0)
	end
	return NumberSequence.new(keypoints)
end

local function readColorSequence(text: string)
	local nums = {}
	for n in string.gmatch(text, "[%-%d%.eE]+") do
		table.insert(nums, tonumber(n) or 0)
	end
	local keypoints = {}
	for i = 1, #nums - 4, 5 do
		table.insert(keypoints, ColorSequenceKeypoint.new(
			nums[i], Color3.new(nums[i + 1], nums[i + 2], nums[i + 3])
		))
	end
	if #keypoints < 2 then
		return ColorSequence.new(Color3.new(1, 1, 1))
	end
	return ColorSequence.new(keypoints)
end

local function readNumberRange(text: string)
	local nums = {}
	for n in string.gmatch(text, "[%-%d%.eE]+") do
		table.insert(nums, tonumber(n) or 0)
	end
	if #nums >= 2 then
		return NumberRange.new(nums[1], nums[2])
	end
	return NumberRange.new(0)
end

local function readPhysicalProperties(node)
	local custom = getChildText(node, "CustomPhysics")
	if custom == "true" then
		return PhysicalProperties.new(
			getChildNum(node, "Density"),
			getChildNum(node, "Friction"),
			getChildNum(node, "Elasticity"),
			getChildNum(node, "FrictionWeight"),
			getChildNum(node, "ElasticityWeight")
		)
	end
	return nil
end

local function readFaces(text: string)
	local n = tonumber(text) or 0
	local faces = {}
	for name, bit in FACE_BITS do
		if bit32.band(n, bit) ~= 0 then
			table.insert(faces, Enum.NormalId[name])
		end
	end
	return Faces.new(unpack(faces))
end

local function readAxes(text: string)
	local n = tonumber(text) or 0
	local axes = {}
	for name, bit in AXIS_BITS do
		if bit32.band(n, bit) ~= 0 then
			table.insert(axes, Enum.Axis[name])
		end
	end
	return Axes.new(unpack(axes))
end

local function readFont(node)
	local familyNode = getChild(node, "Family")
	local family = ""
	if familyNode then
		local urlNode = getChild(familyNode, "url")
		family = urlNode and getText(urlNode) or getText(familyNode)
	end
	local weightNum = tonumber(getChildText(node, "Weight")) or 400
	local styleStr = getChildText(node, "Style")
	local weight = FONT_WEIGHTS[weightNum] or Enum.FontWeight.Regular
	local style = FONT_STYLES[styleStr] or Enum.FontStyle.Normal
	return Font.new(family, weight, style)
end

local function readContent(node)
	local urlNode = getChild(node, "url")
	if urlNode then
		return getText(urlNode)
	end
	local nullNode = getChild(node, "null")
	if nullNode then
		return ""
	end
	local hashNode = getChild(node, "hash")
	if hashNode then
		return getText(hashNode)
	end
	local t = getText(node)
	return string.match(t, "^%s*$") and "" or t
end

local function readRay(node)
	local originNode = getChild(node, "origin")
	local dirNode = getChild(node, "direction")
	local origin = originNode and readVector3(originNode) or Vector3.zero
	local dir = dirNode and readVector3(dirNode) or Vector3.zero
	return Ray.new(origin, dir)
end

local function decodeTags(binaryData: string): { string }
	local tags = {}
	if not binaryData or #binaryData == 0 then return tags end
	local current = {}
	for i = 1, #binaryData do
		local byte = string.byte(binaryData, i)
		if byte == 0 then
			if #current > 0 then
				table.insert(tags, table.concat(current))
				current = {}
			end
		else
			table.insert(current, string.char(byte))
		end
	end
	if #current > 0 then
		table.insert(tags, table.concat(current))
	end
	return tags
end

local function decodeAttributes(binaryData: string): { [string]: any }
	local attrs = {}
	if not binaryData or #binaryData < 4 then return attrs end

	local ok, result = pcall(function()
		local buf = buffer.fromstring(binaryData)
		local pos = 0
		local count = buffer.readu32(buf, pos); pos += 4

		for _ = 1, count do
			local keyLen = buffer.readu32(buf, pos); pos += 4
			local key = buffer.readstring(buf, pos, keyLen); pos += keyLen
			local typeId = buffer.readu8(buf, pos); pos += 1

			if typeId == 0x02 then
				local sLen = buffer.readu32(buf, pos); pos += 4
				attrs[key] = buffer.readstring(buf, pos, sLen); pos += sLen
			elseif typeId == 0x03 then
				attrs[key] = buffer.readu8(buf, pos) ~= 0; pos += 1
			elseif typeId == 0x05 then
				attrs[key] = buffer.readi32(buf, pos); pos += 4
			elseif typeId == 0x06 then
				attrs[key] = buffer.readf32(buf, pos); pos += 4
			elseif typeId == 0x09 then
				attrs[key] = buffer.readf64(buf, pos); pos += 8
			elseif typeId == 0x0D then
				local s = buffer.readf32(buf, pos); pos += 4
				local o = buffer.readi32(buf, pos); pos += 4
				attrs[key] = UDim.new(s, o)
			elseif typeId == 0x0E then
				local xs = buffer.readf32(buf, pos); pos += 4
				local xo = buffer.readi32(buf, pos); pos += 4
				local ys = buffer.readf32(buf, pos); pos += 4
				local yo = buffer.readi32(buf, pos); pos += 4
				attrs[key] = UDim2.new(xs, xo, ys, yo)
			elseif typeId == 0x10 then
				attrs[key] = BrickColor.new(buffer.readi32(buf, pos)); pos += 4
			elseif typeId == 0x11 then
				local r = buffer.readf32(buf, pos); pos += 4
				local g = buffer.readf32(buf, pos); pos += 4
				local b = buffer.readf32(buf, pos); pos += 4
				attrs[key] = Color3.new(r, g, b)
			elseif typeId == 0x12 then
				local x = buffer.readf32(buf, pos); pos += 4
				local y = buffer.readf32(buf, pos); pos += 4
				attrs[key] = Vector2.new(x, y)
			elseif typeId == 0x13 then
				local x = buffer.readf32(buf, pos); pos += 4
				local y = buffer.readf32(buf, pos); pos += 4
				local z = buffer.readf32(buf, pos); pos += 4
				attrs[key] = Vector3.new(x, y, z)
			elseif typeId == 0x17 then
				local kpCount = buffer.readu32(buf, pos); pos += 4
				local kps = {}
				for _ = 1, kpCount do
					local t = buffer.readf32(buf, pos); pos += 4
					local v = buffer.readf32(buf, pos); pos += 4
					local e = buffer.readf32(buf, pos); pos += 4
					table.insert(kps, NumberSequenceKeypoint.new(t, v, e))
				end
				if #kps >= 2 then attrs[key] = NumberSequence.new(kps) end
			elseif typeId == 0x18 then
				local kpCount = buffer.readu32(buf, pos); pos += 4
				local kps = {}
				for _ = 1, kpCount do
					local t = buffer.readf32(buf, pos); pos += 4
					local r = buffer.readf32(buf, pos); pos += 4
					local g = buffer.readf32(buf, pos); pos += 4
					local b = buffer.readf32(buf, pos); pos += 4
					pos += 4
					table.insert(kps, ColorSequenceKeypoint.new(t, Color3.new(r, g, b)))
				end
				if #kps >= 2 then attrs[key] = ColorSequence.new(kps) end
			elseif typeId == 0x1A then
				local mn = buffer.readf32(buf, pos); pos += 4
				local mx = buffer.readf32(buf, pos); pos += 4
				attrs[key] = NumberRange.new(mn, mx)
			elseif typeId == 0x1B then
				local x1 = buffer.readf32(buf, pos); pos += 4
				local y1 = buffer.readf32(buf, pos); pos += 4
				local x2 = buffer.readf32(buf, pos); pos += 4
				local y2 = buffer.readf32(buf, pos); pos += 4
				attrs[key] = Rect.new(x1, y1, x2, y2)
			elseif typeId == 0x1E then
				local fLen = buffer.readu32(buf, pos); pos += 4
				local family = buffer.readstring(buf, pos, fLen); pos += fLen
				local wt = buffer.readu16(buf, pos); pos += 2
				local st = buffer.readu8(buf, pos); pos += 1
				local cLen = buffer.readu32(buf, pos); pos += 4
				pos += cLen
				local weight = FONT_WEIGHTS[wt] or Enum.FontWeight.Regular
				local style = st == 1 and Enum.FontStyle.Italic or Enum.FontStyle.Normal
				attrs[key] = Font.new(family, weight, style)
			else
				break
			end
		end
		return attrs
	end)

	return if ok then result else {}
end

local function readProperty(propNode, sharedStrings: { [string]: string })
	local tag = propNode.tag
	local text = getText(propNode)

	if tag == "string" or tag == "ProtectedString" then
		return text
	elseif tag == "BinaryString" then
		return b64decode(string.gsub(text, "%s+", ""))
	elseif tag == "SharedString" then
		local hash = string.gsub(text, "%s+", "")
		return sharedStrings[hash] or ""
	elseif tag == "bool" then
		return text == "true"
	elseif tag == "int" or tag == "int64" then
		return tonumber(text) or 0
	elseif tag == "float" or tag == "double" then
		return tonumber(text) or 0
	elseif tag == "token" then
		return tonumber(text) or 0
	elseif tag == "Content" then
		return readContent(propNode)
	elseif tag == "Vector2" then
		return readVector2(propNode)
	elseif tag == "Vector3" then
		return readVector3(propNode)
	elseif tag == "Vector2int16" then
		return Vector2int16.new(getChildNum(propNode, "X"), getChildNum(propNode, "Y"))
	elseif tag == "Vector3int16" then
		return Vector3int16.new(
			getChildNum(propNode, "X"), getChildNum(propNode, "Y"), getChildNum(propNode, "Z")
		)
	elseif tag == "CoordinateFrame" or tag == "CFrame" then
		return readCFrameNode(propNode)
	elseif tag == "OptionalCoordinateFrame" then
		local cfNode = getChild(propNode, "CFrame")
		if cfNode then
			return readCFrameNode(cfNode)
		end
		return nil
	elseif tag == "Color3" then
		return readColor3(propNode)
	elseif tag == "Color3uint8" then
		return readColor3uint8(text)
	elseif tag == "BrickColor" then
		return BrickColor.new(tonumber(text) or 0)
	elseif tag == "UDim" then
		return readUDim(propNode)
	elseif tag == "UDim2" then
		return readUDim2(propNode)
	elseif tag == "Rect" or tag == "Rect2D" then
		return readRect(propNode)
	elseif tag == "NumberSequence" then
		return readNumberSequence(text)
	elseif tag == "ColorSequence" then
		return readColorSequence(text)
	elseif tag == "NumberRange" then
		return readNumberRange(text)
	elseif tag == "PhysicalProperties" then
		return readPhysicalProperties(propNode)
	elseif tag == "Ray" then
		return readRay(propNode)
	elseif tag == "Faces" then
		return readFaces(text)
	elseif tag == "Axes" then
		return readAxes(text)
	elseif tag == "Font" then
		return readFont(propNode)
	end

	return nil
end

local function setProp(inst: Instance, propName: string, value: any)
	pcall(function()
		(inst :: any)[propName] = value
	end)
end

local function applyBatch(batch, inst: Instance, sharedStrings: { [string]: string })
	for _, propNode in batch do
		local rawName = getAttr(propNode, "name")
		local propName = PROP_NAME_MAP[rawName] or rawName
		local readOk, value = pcall(readProperty, propNode, sharedStrings)
		if readOk and value ~= nil then
			setProp(inst, propName, value)
		end
	end
end

local function buildInstance(
	itemNode,
	sharedStrings: { [string]: string },
	referentMap: { [string]: Instance },
	deferredRefs: { { Instance | string } },
	deferredJointCFrames: { { Instance | string | CFrame } }
)
	local className = getAttr(itemNode, "class")
	if not className then return nil end

	local referent = getAttr(itemNode, "referent")
	local inst = nil

	local createOk = pcall(function()
		inst = Instance.new(className)
	end)

	if not createOk or not inst then
		return nil
	end

	if referent then
		referentMap[referent] = inst
	end

	local isJoint = inst:IsA("JointInstance")

	local propsNode = getChild(itemNode, "Properties")
	if propsNode then
		local earlyProps = {}
		local normalProps = {}
		local lateProps = {}

		for _, propNode in propsNode.children do
			local rawName = getAttr(propNode, "name")
			if not rawName or SKIP_PROPS[rawName] then
				continue
			end

			local propName = PROP_NAME_MAP[rawName] or rawName

			if propName == "Name" or rawName == "Name" then
				pcall(function() inst.Name = getText(propNode) end)
			elseif propNode.tag == "Ref" then
				local refId = string.gsub(getText(propNode), "%s+", "")
				if refId ~= "" and refId ~= "null" and refId ~= "nil" then
					table.insert(deferredRefs, { inst, propName, refId })
				end
			elseif rawName == "Tags" and propNode.tag == "BinaryString" then
				local decoded = b64decode(string.gsub(getText(propNode), "%s+", ""))
				for _, tag in decodeTags(decoded) do
					pcall(CollectionService.AddTag, CollectionService, inst, tag)
				end
			elseif rawName == "AttributesSerialize" and propNode.tag == "BinaryString" then
				local decoded = b64decode(string.gsub(getText(propNode), "%s+", ""))
				for attrName, attrValue in decodeAttributes(decoded) do
					pcall(inst.SetAttribute, inst, attrName, attrValue)
				end
			elseif isJoint and (propName == "C0" or propName == "C1") then
				local readOk, value = pcall(readProperty, propNode, sharedStrings)
				if readOk and value ~= nil then
					table.insert(deferredJointCFrames, { inst, propName, value })
				end
			elseif PRIORITY_EARLY[propName] then
				table.insert(earlyProps, propNode)
			elseif PRIORITY_LATE[propName] then
				table.insert(lateProps, propNode)
			else
				table.insert(normalProps, propNode)
			end
		end

		applyBatch(earlyProps, inst, sharedStrings)
		applyBatch(normalProps, inst, sharedStrings)
		applyBatch(lateProps, inst, sharedStrings)
	end

	for _, childNode in itemNode.children do
		if childNode.tag == "Item" then
			local childInst = buildInstance(childNode, sharedStrings, referentMap, deferredRefs, deferredJointCFrames)
			if childInst then
				childInst.Parent = inst
			end
		end
	end

	return inst
end

local function postProcess(instances: { Instance })
	local all = {}
	for _, root in instances do
		table.insert(all, root)
		for _, desc in root:GetDescendants() do
			table.insert(all, desc)
		end
	end

	for _, inst in all do
		if not inst:IsA("ViewportFrame") then
			continue
		end
		local vf = inst :: ViewportFrame

		if not vf.CurrentCamera then
			for _, child in vf:GetChildren() do
				if child:IsA("Camera") then
					vf.CurrentCamera = child :: Camera
					break
				end
			end
		end

		local hasWorldModel = false
		for _, child in vf:GetChildren() do
			if child:IsA("WorldModel") then
				hasWorldModel = true
				break
			end
		end

		if hasWorldModel then
			continue
		end

		local hasJoints = false
		for _, desc in vf:GetDescendants() do
			if desc:IsA("JointInstance") or desc:IsA("WeldConstraint") then
				hasJoints = true
				break
			end
		end

		if not hasJoints then
			for _, desc in vf:GetDescendants() do
				if desc:IsA("BasePart") then
					desc.Anchored = true
				end
			end
			continue
		end

		local wm = Instance.new("WorldModel")
		local toMove = {}
		for _, child in vf:GetChildren() do
			if child:IsA("BasePart") or child:IsA("Model") or child:IsA("Accessory") or child:IsA("Folder") then
				table.insert(toMove, child)
			end
		end
		for _, child in toMove do
			child.Parent = wm
		end
		wm.Parent = vf

		for _, desc in wm:GetDescendants() do
			if desc:IsA("BasePart") then
				local isJointed = false
				for _, other in desc:GetDescendants() do
					if other:IsA("JointInstance") then
						isJointed = true
						break
					end
				end
				if not isJointed then
					for _, sibling in (desc.Parent and desc.Parent:GetChildren() or {}) do
						if sibling:IsA("JointInstance") then
							isJointed = true
							break
						end
					end
				end
				if not isJointed and desc.Name == "HumanoidRootPart" then
					desc.Anchored = true
				end
			end
		end

		for _, desc in wm:GetDescendants() do
			if desc:IsA("Model") and desc.PrimaryPart then
				desc.PrimaryPart.Anchored = true
			end
		end
	end
end

function RBXMXParser.Deserialize(rbxmxText: string, parent: Instance?): { Instance }
	local xmlRoot = parseXML(rbxmxText)

	local robloxNode = nil
	for _, child in xmlRoot.children do
		if child.tag == "roblox" then
			robloxNode = child
			break
		end
	end

	if not robloxNode then
		robloxNode = xmlRoot
	end

	local sharedStrings = {}
	local ssNode = getChild(robloxNode, "SharedStrings")
	if ssNode then
		for _, child in ssNode.children do
			if child.tag == "SharedString" then
				local md5 = getAttr(child, "md5")
				if md5 then
					sharedStrings[md5] = b64decode(string.gsub(getText(child), "%s+", ""))
				end
			end
		end
	end

	local referentMap: { [string]: Instance } = {}
	local deferredRefs: { { Instance | string } } = {}
	local deferredJointCFrames: { { Instance | string | CFrame } } = {}
	local instances: { Instance } = {}

	for _, child in robloxNode.children do
		if child.tag == "Item" then
			local inst = buildInstance(child, sharedStrings, referentMap, deferredRefs, deferredJointCFrames)
			if inst then
				table.insert(instances, inst)
			end
		end
	end

	for _, ref in deferredRefs do
		local inst = ref[1] :: Instance
		local propName = ref[2] :: string
		local refId = ref[3] :: string
		local target = referentMap[refId]
		if target then
			setProp(inst, propName, target)
		end
	end

	for _, entry in deferredJointCFrames do
		local inst = entry[1] :: Instance
		local propName = entry[2] :: string
		local value = entry[3]
		setProp(inst, propName, value)
	end

	postProcess(instances)

	if parent then
		for _, inst in instances do
			inst.Parent = parent
		end
	end

	return instances
end

return RBXMXParser
