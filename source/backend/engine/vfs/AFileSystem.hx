package backend.engine.vfs;

import backend.engine.utils.OneOfTwo;
import backend.engine.vfs.AFile;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;

using StringTools;

/**
 * Basic file data, giving its path and contents in bytes.
 * 
 * @since 0.00.008
 */
typedef AFileData = {
	filePath:String,
	fileContents:Bytes
}; // TODO: better error handling then 'throw'

// sigh...the casting hell...

/**
 * A VFS that's savable and loadable to a file.
 * 
 * @since 0.00.008
 */
class AFileSystem {
	/**
	 * The files that belong to this `AFileSystem`.
	 * 
	 * @since 0.00.008
	 */
	public var files:Map<String, AFileObj> = [];

	/**
	 * Creates a new `AFileSystem`.
	 * 
	 * @since 0.00.008
	 */
	public function new() {}

	// ----------------- FILE OPERATIONS ----------------- //

	/**
	 * Retrieves the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @return `AFile` The file at the given path, or `null` if it doesn't exist or it failed.
	 * @since 0.00.008
	 */
	public function getFile(filePath:String):AFile {
		var pathInfo = navigatePath(filePath);
		var parent = pathInfo?.parent;
		var fileName = pathInfo?.fileName;

		if (parent != null) {
			if (parent.contents.exists(fileName)) {
				var file = parent.contents.get(fileName);
				if (Std.isOfType(file, AFile))
					return cast file;
				else {
					trace('Found a folder instead for requested file at path "$filePath". Returning null.');
					return null;
				}
			}
		} else {
			trace('Failed to navigate to target file path to read bytes at path "$filePath". Returning null.');
			return null;
		}

		return null;
	}

	/**
	 * Gets the string contents of the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @return `String` The string contents of the file at the given path, or `null` if it doesn't exist or it failed.
	 * @since 0.00.008
	 */
	public function getContent(filePath:String):String
		return getFile(filePath).contents.toString();

	/**
	 * Gets the bytes of the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @return `Bytes` The bytes of the file at the given path, or `null` if it doesn't exist or it failed.
	 * @since 0.00.008
	 */
	public function getBytes(filePath:String):Bytes
		return getFile(filePath).contents;

	/**
	 * Saves the string contents of the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @param content The string contents of the file.
	 * @since 0.00.008
	 */
	public function saveContent(filePath:String, content:String)
		saveBytes(filePath, Bytes.ofString(content));

	/**
	 * Saves the bytes of the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @param bytes The bytes of the file.
	 * @since 0.00.008
	 */
	public function saveBytes(filePath:String, bytes:Bytes) {
		try {
			var file = getFile(filePath);
			file.contents = bytes;
		} catch (e:Dynamic) {
			var pathInfo = navigatePath(filePath, true);
			var parent = pathInfo?.parent;
			var fileName = pathInfo?.fileName;

			if (parent != null)
				parent.contents.set(fileName, new AFile(fileName, bytes));
			else
				trace('Failed to navigate to target file path to save bytes at path "$filePath".');
		}
	}

	/**
	 * Appends new bytes to the file at the given path.
	 * Creates a new file if it doesn't exist.
	 * 
	 * @param filePath The path of the file.
	 * @param bytes The bytes to append.
	 * @since 0.00.008
	 */
	public function appendBytes(filePath:String, bytes:Bytes) {
		try {
			var file = getFile(filePath);
			var buffer = new BytesBuffer();
			buffer.add(file.contents);
			buffer.add(bytes);
			file.contents = buffer.getBytes();
		} catch (e:Dynamic) {
			saveBytes(filePath, bytes);
		}
	}

	/**
	 * Appends new string contents to the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @param content The string contents to append.
	 * @since 0.00.008
	 */
	public function appendContent(filePath:String, content:String)
		appendBytes(filePath, Bytes.ofString(content));

	/**
	 * Copies the file at the given path to the target path.
	 * 
	 * @param startFilePath The path of the file to copy.
	 * @param targetFilePath The path to copy the file to.
	 * @since 0.00.008
	 */
	public function copyTo(startFilePath:String, targetFilePath:String) {
		var file = getFile(startFilePath);
		var targetPathInfo = navigatePath(targetFilePath, true);
		var targetParent = targetPathInfo?.parent;
		var targetFileName = targetPathInfo?.fileName;

		if (targetParent != null) {
			targetParent.contents.set(targetFileName, new AFile(targetFileName, file.contents));
		} else
			trace('Failed to navigate to target file path to copy file from path "$startFilePath" to path "$targetFilePath".');
	}

	/**
	 * Moves the file at the given path to the target path by copying then deleting the original.
	 * 
	 * @param startFilePath The path of the file to move.
	 * @param targetFilePath The path to move the file to.
	 * @since 0.00.008
	 */
	public function moveTo(startFilePath:String, targetFilePath:String) {
		copyTo(startFilePath, targetFilePath);
		rmFile(startFilePath);
	}

	//----------------- FILE SYSTEM OPERATIONS -----------------//

	/**
	 * Creates a new directory at the given path.
	 * Cannot create a folder the same name as a file.
	 * 
	 * @param dirPath The path of the directory to create.
	 * @since 0.00.008
	 */
	public function makeDir(dirPath:String) {
		var parts = dirPath.split('/');
		var currentPath = '';
		var currentFolder:AFolder = null;

		if (parts.length > 0 && parts[0] == '') {
			parts.shift();
			currentPath = '/';
			if (!files.exists('/')) {
				var rootFolder = new AFolder();
				files.set('/', rootFolder);
				currentFolder = rootFolder;
			} else {
				var fileObj = files.get('/');
				if (Std.isOfType(fileObj, AFolder))
					currentFolder = cast fileObj;
				else
					throw 'Root is a file, not a folder.';
			}
		} else {
			if (!files.exists('/')) {
				var rootFolder = new AFolder();
				files.set('/', rootFolder);
				currentFolder = rootFolder;
			} else
				currentFolder = cast files.get('/');
		}

		for (i in 0...parts.length) {
			var folderName = parts[i];
			if (folderName == '')
				continue;

			if (currentPath == '' || currentPath == '/')
				currentPath += folderName;
			else
				currentPath += '/' + folderName;

			if (currentFolder == null) {
				trace('Invalid path structure, cannot create directory: ' + dirPath);
			} else {
				if (!currentFolder.contents.exists(folderName)) {
					var newFolder = new AFolder();
					currentFolder.contents.set(folderName, newFolder);
					currentFolder = newFolder;
				} else {
					var fileObj = currentFolder.contents.get(folderName);
					if (Std.isOfType(fileObj, AFolder)) {
						currentFolder = cast fileObj;
					} else
						trace('Folder already exists as a file, cannot create directory: ' + dirPath);
				}
			}
		}
	}

	/**
	 * Removes the directory at the given path.
	 * 
	 * @param dirPath The path of the directory to remove.
	 * @since 0.00.008
	 */
	public function rmDir(dirPath:String) {
		if (dirPath == '/' || dirPath == '') {
			files.remove('/');
			return;
		}

		try {
			var parts = dirPath.split('/');
			var dirName = parts.pop();
			var parentPath = parts.join('/');

			if (parentPath == '')
				parentPath = '/';

			if (files.exists(parentPath)) {
				var parentObj = files.get(parentPath);
				if (Std.isOfType(parentObj, AFolder)) {
					var parent = cast(parentObj, AFolder);
					parent.contents.remove(dirName);
				} else {
					var pathInfo = navigatePath(parentPath);
					var parent = pathInfo?.parent;
					if (parent != null && parent.contents.exists(dirName)) {
						parent.contents.remove(dirName);
					} else
						trace('Failed to navigate to parent directory("$parentPath") to remove directory "$dirPath".');
				}
			} else
				trace('Failed to navigate to parent directory("$parentPath") to remove directory "$dirPath". It does not exist.');
		} catch (e:Dynamic) {
			trace('Failed to remove directory "$dirPath". (${e.toString()})');
		}
	}

	/**
	 * Sets the directory at the given path. Alternatively, you can use `makeDir()` to create
	 * a directory from a path without manually creating an `AFolder`.
	 * 
	 * @param dirPath The path of the directory to set.
	 * @param folder The `AFolder` to set the directory to.
	 * @since 0.00.008
	 * @see `makeDir()`
	 */
	public function setDir(dirPath:String, folder:AFolder) {
		if (dirPath == '/' || dirPath == '') {
			files.set('/', folder);
			return;
		}

		try {
			var parts = dirPath.split('/');
			var dirName = parts.pop();
			var parentPath = parts.join('/');

			if (parentPath == '')
				parentPath = '/';

			makeDir(parentPath);

			var parentObj = files.get(parentPath);
			if (Std.isOfType(parentObj, AFolder)) {
				var parent = cast(parentObj, AFolder);
				parent.contents.set(dirName, folder);
			} else
				trace('Failed to set directory "$dirPath": parent directory is not a folder.');
		} catch (e:Dynamic) {
			trace('Failed to set directory "$dirPath": ${e.toString()}');
		}
	}

	/**
	 * Checks if the directory exists.
	 * 
	 * @param dirPath The path of the directory to check.
	 * @return `Bool` `true` if the directory exists, `false` otherwise.
	 */
	public function dirExists(dirPath:String):Bool {
		if (dirPath == '/' || dirPath == '')
			return files.exists('/');

		try {
			var parts = dirPath.split('/');
			var dirName = parts.pop();
			var parentPath = parts.join('/');

			if (parentPath == '')
				parentPath = '/';

			if (files.exists(parentPath)) {
				var parentObj = files.get(parentPath);
				if (Std.isOfType(parentObj, AFolder)) {
					var parent:AFolder = (cast parentObj : AFolder);
					return parent.contents.exists(dirName) && Std.isOfType(parent.contents.get(dirName), AFolder);
				}
			}

			return false;
		} catch (e:Dynamic) {
			return false;
		}
	}

	/**
	 * Creates a file at the given path.
	 * 
	 * @param path The path to create the file at.
	 * @param name The name of the file to create, including the extension(if present).
	 * @param makeDirectory If `true`, the directory at the given path will be created if it does not exist.
	 * @param fileContent The content of the file to create. Optional.
	 * @return `AFile` The created file.
	 * @since 0.00.008
	 */
	public function makeFile(path:String, name:String, makeDirectory:Bool = false, ?fileContent:OneOfTwo<String, Bytes>):AFile {
		var content:Bytes = Bytes.alloc(0);
		if (fileContent != null)
			content = Std.isOfType(fileContent, String) ? Bytes.ofString(fileContent) : fileContent;

		if (makeDirectory) {
			makeDir(path);
		}

		var fullPath = (path.endsWith('/') ? path + name : path + '/' + name);
		var newFile = new AFile(name, content);

		try {
			var folder:AFolder = navigateDirectory(path, makeDirectory);
			if (folder != null)
				folder.contents.set(name, newFile);
			else
				trace('Failed to navigate to directory("$path") to create file "$fullPath".${(makeDirectory ? ' Failed to create file directories.' : ' It does not exist.')}');
		} catch (e:Dynamic) {
			if (makeDirectory)
				trace('Error creating file directories for path "$fullPath" to create file: ${e.toString()}');
			else
				trace('Failed to navigate to directory("$path") to create file "$fullPath". It does not exist.');
		}

		return newFile;
	}

	/**
	 * Removes the file at the given path.
	 * 
	 * @param path The path of the file to remove.
	 * @since 0.00.008
	 */
	public function rmFile(path:String) {
		try {
			var parts = path.split('/');
			var fileName = parts.pop();
			var parentPath = parts.join('/');

			if (parentPath == '')
				parentPath = '/';

			if (files.exists(parentPath)) {
				var parentObj = files.get(parentPath);
				if (Std.isOfType(parentObj, AFolder)) {
					var parent = cast(parentObj, AFolder);
					parent.contents.remove(fileName);
					return;
				} else
					trace('File parent("$parentPath") is not a folder.');
			} else
				trace('File parent("$parentPath") does not exist.');
		} catch (e:Dynamic) {
			trace('Failed to remove file "$path": ${e.toString()}');
		}
	}

	/**
	 * Sets a file at the given path. Alternatively, use `makeFile()` to create
	 * a file from a path without manually creating an `AFile` object.
	 * 
	 * @param path The path to set the file at.
	 * @param file The file to set.
	 * @since 0.00.008
	 */
	public function setFile(path:String, file:AFile) {
		try {
			var parts = path.split('/');
			var fileName = parts.pop();
			var parentPath = parts.join('/');

			if (parentPath == '')
				parentPath = '/';

			if (!dirExists(parentPath) && parentPath != '/') {
				makeDir(parentPath);
			}

			var parentObj = files.get(parentPath);
			if (Std.isOfType(parentObj, AFolder))
				(cast parentObj : AFolder).contents.set(fileName, file);
			else
				trace('Failed to set file "$path": parent file is not a folder.');
		} catch (e:Dynamic) {
			trace('Failed to set file "$path": ${e.toString()}');
		}
	}

	/**
	 * Checks if the file exists.
	 * 
	 * @param filePath The path of the file to check.
	 * @return `Bool` `true` if the directory exists, `false` otherwise.
	 */
	public function fileExists(filePath:String):Bool {
		try {
			var parts = filePath.split('/');
			var fileName = parts.pop();
			var parentPath = parts.join('/');

			if (parentPath == '')
				parentPath = '/';

			if (files.exists(parentPath)) {
				var parentObj = files.get(parentPath);
				if (Std.isOfType(parentObj, AFolder)) {
					var parent = cast(parentObj, AFolder);
					return parent.contents.exists(fileName) && Std.isOfType(parent.contents.get(fileName), File);
				}
			}

			return false;
		} catch (e:Dynamic) {
			return false;
		}
	}

	// ----------------- FILE SYSTEM SAVING/LOADING ----------------- //

	/**
	 * Saves the file system to a file.
	 * 
	 * @param fileName The name of the file to save the file system to.
	 * @since 0.00.008
	 */
	public function saveFileSystem(fileName:String) {
		var filesArray:Array<Dynamic> = [];
		for (fileKey => fileObj in files)
			if (fileKey == '/')
				filesArray = filesArray.concat(lookThroughFolders((cast fileObj : AFolder), ''));
			else if (Std.isOfType(fileObj, AFile))
				filesArray.push([fileKey, (cast fileObj : AFile).contents]);
			else if (Std.isOfType(fileObj, AFolder))
				filesArray = filesArray.concat(lookThroughFolders((cast fileObj : AFolder), fileKey + '/'));

		var finalFiles:Array<AFileData> = flattenFiles(filesArray);
		var bytesOutput = new BytesOutput();

		bytesOutput.writeString('APFVFS');

		for (file in finalFiles) {
			var pathBytes = Bytes.ofString(file.filePath);
			bytesOutput.writeInt32(pathBytes.length);
			bytesOutput.write(pathBytes);

			bytesOutput.writeInt32(file.fileContents.length);
			bytesOutput.write(file.fileContents);
		}

		var outputBytes = bytesOutput.getBytes();
		File.saveBytes(fileName, outputBytes);
	}

	/**
	 * Loads a file system from a file into the current file system.
	 * If this file system is not empty, the behavior is *undefined*.
	 * 
	 * @param fileName The name of the file to load the file system from.
	 * @return `AFileSystem` This file system, for chaining.
	 */
	public function loadFileSystem(fileName:String):AFileSystem {
		var bytes = File.getBytes(fileName);
		var bytesInput = new BytesInput(bytes);

		var header:String = '';
		try {
			var header = bytesInput.readString(6);
		} catch (_) {
			throw 'Failed to read Abode VFS data.';
		}
		if (header != 'APFVFS')
			throw 'Invalid Abode VFS data.';

		try {
			while (bytesInput.position < bytes.length) {
				var pathLength = bytesInput.readInt32();
				var pathBytes = bytesInput.read(pathLength);
				var path = pathBytes.toString();

				var contentLength = bytesInput.readInt32();
				var contentBytes = bytesInput.read(contentLength);

				storeFile(path, contentBytes);
			}
		} catch (e:Dynamic) {
			throw 'Invalid Abode VFS data.';
		}

		return this;
	}

	// ----------------- PRIVATE CALLS ----------------- //

	private function navigateDirectory(path:String, createMissing:Bool = false):AFolder {
		var parts = path.split('/');
		var currentFolder:AFolder = null;
		var currentPath = '';

		if (parts.length > 0 && parts[0] == '') {
			parts.shift();
			currentPath = '/';
			if (files.get('/') == null) {
				var rootFolder = new AFolder();
				files.set('/', rootFolder);
				currentFolder = rootFolder;
			} else {
				currentFolder = cast files.get('/');
			}
		}

		for (i in 0...parts.length) {
			var folderName = parts[i];
			if (folderName == '')
				continue;
			if (currentPath == '' || currentPath == '/')
				currentPath += folderName;
			else
				currentPath += '/' + folderName;

			var folder:AFolder = null;
			if (currentFolder == null) {
				if (files.exists(currentPath)) {
					var fileObj = files.get(currentPath);
					if (Std.isOfType(fileObj, AFolder))
						folder = cast fileObj;
					else
						throw '$currentPath is a file, not a folder';
				} else if (createMissing) {
					folder = new AFolder();
					files.set(currentPath, folder);
				} else
					throw 'Path ' + currentPath + ' does not exist';

				currentFolder = folder;
			} else {
				if (currentFolder.contents.exists(folderName)) {
					var fileObj = currentFolder.contents.get(folderName);
					if (Std.isOfType(fileObj, AFolder))
						folder = cast fileObj;
					else
						throw '$folderName is a file, not a folder';
				} else if (createMissing) {
					folder = new AFolder();
					currentFolder.contents.set(folderName, folder);
				} else
					throw 'AFolder ' + folderName + ' does not exist in ' + currentPath;

				currentFolder = folder;
			}
		}
		return currentFolder;
	}

	private function navigatePath(path:String, createMissing:Bool = false):{parent:AFolder, fileName:String} {
		while (path.length > 0 && path.charAt(0) == '/') {
			path = path.substr(1);
		}
		while (path.length > 0 && path.charAt(path.length - 1) == '/') {
			path = path.substr(0, path.length - 1);
		}

		var parts = path.split('/');
		if (parts.length == 0) {
			trace('Attempted to navigate to invalid file path, "$path". Returning null.');
			return null;
		}

		var fileName = parts.pop();

		if (!files.exists('/')) {
			if (createMissing) {
				files.set('/', new AFolder());
			} else {
				throw 'Root folder does not exist.';
			}
		}
		var currentFolder:AFolder = cast files.get('/');

		for (i in 0...parts.length) {
			var folderName = parts[i];
			if (folderName == '')
				continue;
			if (!currentFolder.contents.exists(folderName)) {
				if (createMissing) {
					currentFolder.contents.set(folderName, new AFolder());
				} else {
					trace('Attempted to navigate to path, "$path", which does not exist. Returning null.');
					return null;
				}
			}
			var nextFolder = currentFolder.contents.get(folderName);
			if (!Std.isOfType(nextFolder, AFolder)) {
				trace('Attempted to navigate to path, "$path", which is a file. Returning null.');
				return null;
			}
			currentFolder = cast nextFolder;
		}

		return {parent: currentFolder, fileName: fileName};
	}

	private function storeFile(path:String, contents:Bytes) {
		if (StringTools.startsWith(path, '/'))
			path = path.substr(1);

		var parts = path.split('/');

		if (parts.length == 1) {
			if (!files.exists('/'))
				files.set('/', new AFolder());
			var rootFolder:AFolder = cast files.get('/');
			var fileName = parts[0];
			rootFolder.contents.set(fileName, new AFile(fileName, contents));
			return;
		}

		if (!files.exists('/'))
			files.set('/', new AFolder());

		var folder:AFolder = cast files.get('/');
		var current:Map<String, AFileObj> = folder.contents;
		for (i in 0...parts.length - 1) {
			var folderName = parts[i];
			if (!current.exists(folderName))
				current.set(folderName, new AFolder());
			var folder:AFolder = cast current.get(folderName);
			current = folder.contents;
		}
		var fileName = parts[parts.length - 1];
		current.set(fileName, new AFile(fileName, contents));
	}

	private function flattenFiles(input:Array<Dynamic>):Array<AFileData> {
		var result:Array<AFileData> = [];
		for (item in input) {
			if (Std.isOfType(item, Array)) {
				var arr:Array<Dynamic> = cast item;
				if (arr.length == 2 && Std.isOfType(arr[0], String) && Std.isOfType(arr[1], Bytes))
					result.push({filePath: arr[0], fileContents: arr[1]});
				else
					result = result.concat(flattenFiles(arr));
			}
		}
		return result;
	}

	private function lookThroughFolders(folder:AFolder, basePath:String):Array<Dynamic> {
		var files:Array<Dynamic> = [];
		for (fileName => fileObj in folder.contents) {
			var currentPath = basePath + fileName;
			if (Std.isOfType(fileObj, AFile))
				files.push([currentPath, (cast fileObj : AFile).contents]);
			else if (Std.isOfType(fileObj, AFolder))
				files = files.concat(lookThroughFolders((cast fileObj : AFolder), currentPath + '/'));
		}
		return files;
	}
}
