package backend.utils;

import haxe.rtti.CType;
import haxe.rtti.Rtti;

/**
 * A utility for working with compiled methods *that belong to Hydro-Frame*.
 * Doesn't work on scripted methods, and doesn't work on methods that don't belong to Hydro-Frame.
 * Ex: `lime` methods, `openfl` methods, `svg` methods, etc.
 * 
 * @since 0.8.0
 */
class MethodUtil {
	/**
	 * Gets the signature of a method.
	 * On failure, returns the method signature with no modifiers(Ex: `public`, `private`, `override`, and `final`).
	 * 
	 * @param className The name of the class, including the package. Ex: `com.example.MyClass`
	 * @param methodName The name of the method.
	 * @return `String` The method signature.
	 * 
	 * @since 0.8.0
	 */
	public static function getSig(className:String, methodName:String):String {
		var targetClass = Type.resolveClass(className);
		if (targetClass == null)
			return 'function $methodName()';

		var rtti:Classdef;
		try {
			rtti = Rtti.getRtti(targetClass);
		} catch (e:Dynamic) {
			return 'function $methodName()';
		}

		for (field in rtti.fields)
			if (field.name == methodName)
				return buildSig(field, false);

		for (field in rtti.statics)
			if (field.name == methodName)
				return buildSig(field, true);

		return 'function $methodName()';
	}

	private static function buildSig(field:ClassField, isStatic:Bool):String {
		var parts:Array<String> = [];

		if (field.isFinal)
			parts.push('final');
		if (field.isOverride)
			parts.push('override');
		parts.push(field.isPublic ? 'public' : 'private');
		if (isStatic)
			parts.push('static');

		parts.push('function');
		parts.push(field.name);

		var argStr = '';
		switch (field.type) {
			case CFunction(args, ret):
				var argParts = args.map(a -> formatArg(a));
				argStr = '(' + argParts.join(', ') + ')';
			default:
				argStr = '';
		}

		parts.push(argStr);
		return parts.join(' ').replace(' (', '(');
	}

	private static function formatArg(arg:FunctionArgument):String
		return '${arg.opt ? '?' : ''}${arg.name}:${formatType(arg.t)}';

	private static function formatType(t:CType):String {
		return switch (t) { // Sigh, this is annoying to read after writing this
			case CUnknown:
				'Unknown';
			case CEnum(name, _):
				name;
			case CClass(name, params):
				params.length == 0 ? name : name + '<' + params.map(formatType).join(', ') + '>';
			case CTypedef(name, _):
				name;
			case CFunction(args, ret):
				var a = args.map(a -> formatType(a.t)).join(', ');
				'($a) -> ${formatType(ret)}';
			case CAnonymous(fields):
				'{}';
			case CDynamic(t):
				t == null ? 'Dynamic' : 'Dynamic<' + formatType(t) + '>';
			case CAbstract(name, params):
				params.length == 0 ? name : name + '<' + params.map(formatType).join(', ') + '>';
		}
	}
}
